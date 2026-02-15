package DALs.contract;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import Models.dto.ManagerContractRowDTO;
import Models.entity.Contract;
import Utils.database.DBContext;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-11
 */
public class ContractDAO extends DBContext {

    public int insertPendingContract(Connection conn, Contract c) throws SQLException {
        String sql = """
                INSERT INTO CONTRACT (room_id, tenant_id, created_by_staff_id, start_date, end_date, monthly_rent, deposit, payment_qr_data, status)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'PENDING')
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, c.getRoomId());
            ps.setInt(2, c.getTenantId());
            ps.setInt(3, c.getCreatedByStaffId());
            ps.setDate(4, c.getStartDate());
            ps.setDate(5, c.getEndDate());
            ps.setBigDecimal(6, c.getMonthlyRent());
            ps.setBigDecimal(7, c.getDeposit());
            ps.setString(8, c.getPaymentQrData());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        }
        return -1;
    }

    //get list manage contract
    @SuppressWarnings("CallToPrintStackTrace")
    public List<ManagerContractRowDTO> getManagerContracts() {
        List<ManagerContractRowDTO> list = new ArrayList<>();

        String sql = """
SELECT CONTRACT.contract_id, ROOM.room_number, TENANT.full_name as tenant_name , CONTRACT.start_date, CONTRACT.monthly_rent, CONTRACT.status
FROM     CONTRACT INNER JOIN
                  ROOM ON CONTRACT.room_id = ROOM.room_id INNER JOIN
                  TENANT ON CONTRACT.tenant_id = TENANT.tenant_id
            ORDER BY CONTRACT.created_at DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ManagerContractRowDTO contractRowDTO = new ManagerContractRowDTO();
                contractRowDTO.setContractId(rs.getInt("contract_id"));
                contractRowDTO.setRoomNumber(rs.getString("room_number"));
                contractRowDTO.setTenantName(rs.getString("tenant_name"));
                contractRowDTO.setStartDate(rs.getDate("start_date"));
                contractRowDTO.setMonthlyRent(rs.getBigDecimal("monthly_rent"));
                contractRowDTO.setStatus(rs.getString("status"));
                list.add(contractRowDTO);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    //nếu m có 100 hợp đồng và mỗi trang hiển thị 10 cái, 
    //m cần con số 100 này để vẽ ra các nút chuyển trang 1, 2, 3, ..., 10 trên UI. 
    //nếu không m sẽ không biết khi nào thì hết dữ liệu để dừng phân trang.
    @SuppressWarnings("CallToPrintStackTrace")
    public int countManagerContracts(String keyword, String status) {
        String sql = """
        SELECT COUNT(*)
        FROM CONTRACT c
        JOIN ROOM r ON c.room_id = r.room_id
        JOIN TENANT t ON c.tenant_id = t.tenant_id
        WHERE 1=1
          AND (
                ? IS NULL OR ? = '' OR
                CAST(c.contract_id AS NVARCHAR(20)) LIKE '%' + ? + '%' OR
                r.room_number LIKE '%' + ? + '%' OR
                t.full_name LIKE '%' + ? + '%'
              )
          AND (
                ? IS NULL OR ? = '' OR
                c.status = ?
              )
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String k = (keyword == null) ? "" : keyword.trim();
            String s = (status == null) ? "" : status.trim();

            int i = 1;
            ps.setString(i++, k);
            ps.setString(i++, k);
            ps.setString(i++, k);
            ps.setString(i++, k);
            ps.setString(i++, k);

            ps.setString(i++, s);
            ps.setString(i++, s);
            ps.setString(i++, s);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public List<ManagerContractRowDTO> findManagerContracts(String keyword, String status, int page, int pageSize) {
        List<ManagerContractRowDTO> list = new ArrayList<>();

        if (page <= 0) {
            page = 1;
        }
        if (pageSize <= 0) {
            pageSize = 10;
        }
        int offset = (page - 1) * pageSize;

        String sql = """
        SELECT c.contract_id, r.room_number, t.full_name as tenant_name,
               c.start_date, c.monthly_rent, c.status
        FROM CONTRACT c
        JOIN ROOM r ON c.room_id = r.room_id
        JOIN TENANT t ON c.tenant_id = t.tenant_id
        WHERE 1=1
          AND (
                ? IS NULL OR ? = '' OR
                CAST(c.contract_id AS NVARCHAR(20)) LIKE '%' + ? + '%' OR
                r.room_number LIKE '%' + ? + '%' OR
                t.full_name LIKE '%' + ? + '%'
              )
          AND (
                ? IS NULL OR ? = '' OR
                c.status = ?
              )
        ORDER BY c.created_at DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String k = (keyword == null) ? "" : keyword.trim();
            String s = (status == null) ? "" : status.trim();

            int i = 1;
            ps.setString(i++, k);
            ps.setString(i++, k);
            ps.setString(i++, k);
            ps.setString(i++, k);
            ps.setString(i++, k);

            ps.setString(i++, s);
            ps.setString(i++, s);
            ps.setString(i++, s);

            ps.setInt(i++, offset);
            ps.setInt(i++, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ManagerContractRowDTO dto = new ManagerContractRowDTO();
                    dto.setContractId(rs.getInt("contract_id"));
                    dto.setRoomNumber(rs.getString("room_number"));
                    dto.setTenantName(rs.getString("tenant_name"));
                    dto.setStartDate(rs.getDate("start_date"));
                    dto.setMonthlyRent(rs.getBigDecimal("monthly_rent"));
                    dto.setStatus(rs.getString("status"));
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    //get list contract theo tenantId
    //sort theo status, pending gan 0,active gan 1, uu tien pending len dau
    @SuppressWarnings("CallToPrintStackTrace")
    public List<Contract> findByTenantId(int tenantId) {
        List<Contract> list = new ArrayList<>();

        String sql = """
        SELECT
            c.contract_id, c.room_id, c.tenant_id, c.created_by_staff_id, 
            c.start_date, c.end_date, c.monthly_rent, c.deposit, 
            c.payment_qr_data, c.status, c.created_at, c.updated_at, r.room_number, b.block_name 
        FROM CONTRACT c
        JOIN ROOM r ON c.room_id = r.room_id
        LEFT JOIN BLOCK b ON r.block_id = b.block_id
        WHERE c.tenant_id = ?
        ORDER BY
            CASE c.status WHEN 'PENDING' THEN 0 WHEN 'ACTIVE' THEN 1 ELSE 2 END, c.created_at DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tenantId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Contract c = new Contract();
                    c.setContractId(rs.getInt("contract_id"));
                    c.setRoomId(rs.getInt("room_id"));
                    c.setTenantId(rs.getInt("tenant_id"));
                    c.setCreatedByStaffId(rs.getInt("created_by_staff_id"));
                    c.setStartDate(rs.getDate("start_date"));
                    c.setEndDate(rs.getDate("end_date"));
                    c.setMonthlyRent(rs.getBigDecimal("monthly_rent"));
                    c.setDeposit(rs.getBigDecimal("deposit"));
                    c.setPaymentQrData(rs.getString("payment_qr_data"));
                    c.setStatus(rs.getString("status"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    c.setUpdatedAt(rs.getTimestamp("updated_at"));
                    c.setRoomNumber(rs.getString("room_number"));
                    c.setBlockName(rs.getString("block_name"));

                    list.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    //get contract theo id de tenant ko xem contract cua ngkhac
    @SuppressWarnings("CallToPrintStackTrace")
    public Contract findByIdForTenant(int contractId, int tenantId) {

        String sql = """
        SELECT
            c.contract_id, c.room_id, c.tenant_id, c.created_by_staff_id,
            c.start_date, c.end_date, c.monthly_rent, c.deposit,
            c.payment_qr_data, c.status, c.created_at, c.updated_at,
            r.room_number, b.block_name
        FROM CONTRACT c
        JOIN ROOM r ON c.room_id = r.room_id
        LEFT JOIN BLOCK b ON r.block_id = b.block_id
        WHERE c.contract_id = ? AND c.tenant_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ps.setInt(2, tenantId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Contract c = new Contract();
                    c.setContractId(rs.getInt("contract_id"));
                    c.setRoomId(rs.getInt("room_id"));
                    c.setTenantId(rs.getInt("tenant_id"));
                    c.setCreatedByStaffId(rs.getInt("created_by_staff_id"));
                    c.setStartDate(rs.getDate("start_date"));
                    c.setEndDate(rs.getDate("end_date"));
                    c.setMonthlyRent(rs.getBigDecimal("monthly_rent"));
                    c.setDeposit(rs.getBigDecimal("deposit"));
                    c.setPaymentQrData(rs.getString("payment_qr_data"));
                    c.setStatus(rs.getString("status"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    c.setUpdatedAt(rs.getTimestamp("updated_at"));
                    c.setRoomNumber(rs.getString("room_number"));
                    c.setBlockName(rs.getString("block_name"));
                    return c;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public Contract findDetailForTenant(int contractId, int tenantId) {

        String sql = """
        SELECT
            c.contract_id, c.room_id, c.tenant_id, c.created_by_staff_id,
            c.start_date, c.end_date, c.monthly_rent, c.deposit,
            c.payment_qr_data, c.status, c.created_at, c.updated_at,

            r.room_number, r.floor, r.area, r.max_tenants,
            r.is_mezzanine, r.has_air_conditioning, r.[description] AS room_description,
            b.block_name,

            t.full_name AS tenant_name,
            t.email AS tenant_email,
            t.phone_number AS tenant_phone,
            t.identity_code AS tenant_identity,
            t.date_of_birth AS tenant_dob,
            t.[address] AS tenant_address,

            a.full_name AS landlord_name,
            a.phone_number AS landlord_phone,
            a.email AS landlord_email,
            a.identity_code AS landlord_identity,
            a.date_of_birth AS landlord_dob

        FROM CONTRACT c
        JOIN ROOM r ON c.room_id = r.room_id
        LEFT JOIN BLOCK b ON r.block_id = b.block_id
        JOIN TENANT t ON c.tenant_id = t.tenant_id

        CROSS APPLY (
            SELECT TOP 1 *
            FROM STAFF
            WHERE staff_role = 'ADMIN' AND [status] = 'ACTIVE'
            ORDER BY staff_id ASC
        ) a

        WHERE c.contract_id = ? AND c.tenant_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ps.setInt(2, tenantId);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                Contract c = new Contract();

                //contract
                c.setContractId(rs.getInt("contract_id"));
                c.setRoomId(rs.getInt("room_id"));
                c.setTenantId(rs.getInt("tenant_id"));
                c.setCreatedByStaffId(rs.getInt("created_by_staff_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setMonthlyRent(rs.getBigDecimal("monthly_rent"));
                c.setDeposit(rs.getBigDecimal("deposit"));
                c.setPaymentQrData(rs.getString("payment_qr_data"));
                c.setStatus(rs.getString("status"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                c.setUpdatedAt(rs.getTimestamp("updated_at"));

                //room && block
                c.setRoomNumber(rs.getString("room_number"));
                c.setBlockName(rs.getString("block_name"));
                c.setFloor((Integer) rs.getObject("floor"));
                c.setArea(rs.getBigDecimal("area"));
                c.setMaxTenants((Integer) rs.getObject("max_tenants"));
                c.setIsMezzanine((Boolean) rs.getObject("is_mezzanine"));
                c.setHasAirConditioning((Boolean) rs.getObject("has_air_conditioning"));
                c.setRoomDescription(rs.getString("room_description"));

                //party B
                c.setTenantName(rs.getString("tenant_name"));
                c.setTenantEmail(rs.getString("tenant_email"));
                c.setTenantPhoneNumber(rs.getString("tenant_phone"));
                c.setTenantIdentityCode(rs.getString("tenant_identity"));
                c.setTenantDateOfBirth(rs.getDate("tenant_dob"));
                c.setTenantAddress(rs.getString("tenant_address"));

                //party A
                c.setLandlordFullName(rs.getString("landlord_name"));
                c.setLandlordPhoneNumber(rs.getString("landlord_phone"));
                c.setLandlordEmail(rs.getString("landlord_email"));
                c.setLandlordIdentityCode(rs.getString("landlord_identity"));
                c.setLandlordDateOfBirth(rs.getDate("landlord_dob"));

                return c;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public Contract findDetailForManager(int contractId) {

        String sql = """
        SELECT
            c.contract_id, c.room_id, c.tenant_id, c.created_by_staff_id,
            c.start_date, c.end_date, c.monthly_rent, c.deposit,
            c.payment_qr_data, c.status, c.created_at, c.updated_at,

            r.room_number, r.floor, r.area, r.max_tenants,
            r.is_mezzanine, r.has_air_conditioning, r.[description] AS room_description,
            b.block_name,

            t.full_name AS tenant_name,
            t.email AS tenant_email,
            t.phone_number AS tenant_phone,
            t.identity_code AS tenant_identity,
            t.date_of_birth AS tenant_dob,
            t.[address] AS tenant_address,

            a.full_name AS landlord_name,
            a.phone_number AS landlord_phone,
            a.email AS landlord_email,
            a.identity_code AS landlord_identity,
            a.date_of_birth AS landlord_dob

        FROM CONTRACT c
        JOIN ROOM r ON c.room_id = r.room_id
        LEFT JOIN BLOCK b ON r.block_id = b.block_id
        JOIN TENANT t ON c.tenant_id = t.tenant_id
        JOIN STAFF cb ON c.created_by_staff_id = cb.staff_id

        CROSS APPLY (
            SELECT TOP 1 *
            FROM STAFF
            WHERE staff_role = 'ADMIN' AND [status] = 'ACTIVE'
            ORDER BY staff_id ASC
        ) a

        WHERE c.contract_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                Contract c = new Contract();

                // contract
                c.setContractId(rs.getInt("contract_id"));
                c.setRoomId(rs.getInt("room_id"));
                c.setTenantId(rs.getInt("tenant_id"));
                c.setCreatedByStaffId(rs.getInt("created_by_staff_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setMonthlyRent(rs.getBigDecimal("monthly_rent"));
                c.setDeposit(rs.getBigDecimal("deposit"));
                c.setPaymentQrData(rs.getString("payment_qr_data"));
                c.setStatus(rs.getString("status"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                c.setUpdatedAt(rs.getTimestamp("updated_at"));

                // room & block
                c.setRoomNumber(rs.getString("room_number"));
                c.setBlockName(rs.getString("block_name"));
                c.setFloor((Integer) rs.getObject("floor"));
                c.setArea(rs.getBigDecimal("area"));
                c.setMaxTenants((Integer) rs.getObject("max_tenants"));
                c.setIsMezzanine((Boolean) rs.getObject("is_mezzanine"));
                c.setHasAirConditioning((Boolean) rs.getObject("has_air_conditioning"));
                c.setRoomDescription(rs.getString("room_description"));

                // tenant (party B)
                c.setTenantName(rs.getString("tenant_name"));
                c.setTenantEmail(rs.getString("tenant_email"));
                c.setTenantPhoneNumber(rs.getString("tenant_phone"));
                c.setTenantIdentityCode(rs.getString("tenant_identity"));
                c.setTenantDateOfBirth(rs.getDate("tenant_dob"));
                c.setTenantAddress(rs.getString("tenant_address"));

                // landlord/admin (party A)
                c.setLandlordFullName(rs.getString("landlord_name"));
                c.setLandlordPhoneNumber(rs.getString("landlord_phone"));
                c.setLandlordEmail(rs.getString("landlord_email"));
                c.setLandlordIdentityCode(rs.getString("landlord_identity"));
                c.setLandlordDateOfBirth(rs.getDate("landlord_dob"));

                return c;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public boolean updateStatus(int contractId, String status) {
        String sql = "UPDATE CONTRACT SET status = ?, updated_at = SYSDATETIME() WHERE contract_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, contractId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
