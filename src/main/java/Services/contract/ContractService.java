package Services.contract;

import java.sql.Connection;
import java.util.Random;

import DALs.auth.OtpCodeDAO;
import DALs.auth.TenantDAO;
import DALs.contract.ContractDAO;
import Models.entity.Contract;
import Models.entity.Tenant;
import Utils.database.DBContext;
import Utils.mail.MailUtil;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-11
 */
public class ContractService extends DBContext {

    private final TenantDAO tenantDAO = new TenantDAO();
    private final ContractDAO contractDAO = new ContractDAO();
    private final OtpCodeDAO otpDAO = new OtpCodeDAO();

    @SuppressWarnings("CallToPrintStackTrace")
    public boolean createContractAndTenant(Contract c, Tenant t) {

        try (Connection conn = this.connection) {

            conn.setAutoCommit(false);

            //Check tenant tồn tại chưa
            if (tenantDAO.findByEmail(t.getEmail()) != null) {
                conn.rollback();
                return false; // tenant đã tồn tại → không cho tạo
            }

            // Insert tenant PENDING
            int tenantId = tenantDAO.insertPendingTenant(conn, t);
            if (tenantId <= 0) {
                conn.rollback();
                return false;
            }

            //Insert contract PENDING
            c.setTenantId(tenantId);
            int contractId = contractDAO.insertPendingContract(conn, c);
            if (contractId <= 0) {
                conn.rollback();
                return false;
            }

            //Generate OTP
            String otp = String.format("%06d", new Random().nextInt(999999));
            otpDAO.insertFirstLoginOtp(conn, tenantId, t.getEmail(), otp);

            //Send mail
            boolean mailOk = MailUtil.sendOtp(t.getEmail(), otp);
            if (!mailOk) {
                conn.rollback();
                return false;
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
