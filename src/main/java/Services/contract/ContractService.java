package Services.contract;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Random;

import DALs.auth.OtpCodeDAO;
import DALs.auth.TenantDAO;
import DALs.contract.ContractDAO;
import Models.common.ServiceResult;
import Models.entity.Contract;
import Models.entity.Tenant;
import Utils.database.DBContext;
import Utils.mail.MailUtil;

public class ContractService {

    private final TenantDAO tenantDAO = new TenantDAO();
    private final ContractDAO contractDAO = new ContractDAO();
    private final OtpCodeDAO otpDAO = new OtpCodeDAO();

    @SuppressWarnings("UseSpecificCatch")
    public ServiceResult createContractAndTenant(Contract c, Tenant t) {

        String email = (t == null || t.getEmail() == null) ? "" : t.getEmail().trim();
        if (email.isBlank()) {
            return ServiceResult.fail("Email tenant không hợp lệ.");
        }

        //MỖI LẦN GỌI -> LẤY CONNECTION MỚI (transaction độc lập, không bị 'connection closed' do nơi khác)
        try (Connection conn = new DBContext().getConnection()) {

            conn.setAutoCommit(false);

            // 1) Check tenant tồn tại
            if (tenantDAO.findByEmail(email) != null) {
                conn.rollback();
                return ServiceResult.fail("Email tenant đã tồn tại trong hệ thống.");
            }

            // 2) Insert tenant PENDING
            int tenantId = tenantDAO.insertPendingTenant(conn, t);
            if (tenantId <= 0) {
                conn.rollback();
                return ServiceResult.fail("Không tạo được tenant (PENDING).");
            }

            // 3) Insert contract PENDING
            c.setTenantId(tenantId);
            int contractId = contractDAO.insertPendingContract(conn, c);
            if (contractId <= 0) {
                conn.rollback();
                return ServiceResult.fail("Không tạo được contract (PENDING).");
            }

            // 4) Generate OTP + insert
            String otp = String.format("%06d", new Random().nextInt(1_000_000));
            otpDAO.insertFirstLoginOtp(conn, tenantId, email, otp);

            // 5) Send mail
            boolean mailOk = MailUtil.sendOtp(email, otp);
            if (!mailOk) {
                conn.rollback();
                return ServiceResult.fail("Gửi OTP thất bại. Vui lòng kiểm tra cấu hình mail.");
            }

            conn.commit();
            return ServiceResult.ok("Tạo contract + tenant PENDING và gửi OTP thành công.");

        } catch (SQLException e) {
            // map lỗi SQL -> message dễ hiểu
            String msg = mapSqlErrorToUi(e);
            return ServiceResult.fail(msg);

        } catch (Exception e) {
            return ServiceResult.fail("Lỗi hệ thống: " + (e.getMessage() == null ? "UNKNOWN" : e.getMessage()));
        }
    }

    private String mapSqlErrorToUi(SQLException e) {

        String m = (e.getMessage() == null) ? "" : e.getMessage().toLowerCase();

        // UNIQUE email/phone
        if (m.contains("uq_tenant_email") || (m.contains("unique") && m.contains("email"))) {
            return "Email tenant đã tồn tại (trùng dữ liệu).";
        }
        if (m.contains("uq_tenant_phone") || (m.contains("unique") && m.contains("phone"))) {
            return "Số điện thoại tenant đã tồn tại (trùng dữ liệu).";
        }

        // room chỉ được có 1 contract pending/active
        if (m.contains("ux_contract_room_active")) {
            return "Phòng này đã có hợp đồng PENDING/ACTIVE rồi.";
        }

        // check end_date > start_date
        if (m.contains("ck_contract_end_after_start")) {
            return "Ngày kết thúc phải lớn hơn ngày bắt đầu.";
        }

        // money nonnegative
        if (m.contains("ck_contract_money_nonnegative")) {
            return "Tiền thuê / tiền cọc không được âm.";
        }

        // connection closed / db down
        if (m.contains("connection is closed")) {
            return "Kết nối DB đã bị đóng. Vui lòng restart server hoặc kiểm tra DBContext.";
        }

        // fallback
        return "Lỗi SQL: " + e.getMessage();
    }
}
