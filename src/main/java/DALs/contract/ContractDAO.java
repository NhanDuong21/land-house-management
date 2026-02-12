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
        SELECT contract_id, room_id, tenant_id, created_by_staff_id,
               start_date, end_date, monthly_rent, deposit,
               payment_qr_data, status, created_at, updated_at
        FROM CONTRACT
        WHERE contract_id = ? AND tenant_id = ?
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ps.setInt(2, tenantId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Contract contract = new Contract();
                    contract.setContractId(rs.getInt("contract_id"));
                    contract.setRoomId(rs.getInt("room_id"));
                    contract.setTenantId(rs.getInt("tenant_id"));
                    contract.setCreatedByStaffId(rs.getInt("created_by_staff_id"));
                    contract.setStartDate(rs.getDate("start_date"));
                    contract.setEndDate(rs.getDate("end_date") != null ? rs.getDate("end_date") : null);
                    contract.setMonthlyRent(rs.getBigDecimal("monthly_rent"));
                    contract.setDeposit(rs.getBigDecimal("deposit"));
                    contract.setPaymentQrData(rs.getString("payment_qr_data"));
                    contract.setStatus(rs.getString("status"));
                    contract.setCreatedAt(rs.getTimestamp("created_at"));
                    contract.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return contract;
                }
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
