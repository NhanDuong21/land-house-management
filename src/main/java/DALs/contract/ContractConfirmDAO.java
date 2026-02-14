package DALs.contract;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import Models.dto.TxResult;
import Utils.database.DBContext;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-13
 */
public class ContractConfirmDAO extends DBContext {

    @SuppressWarnings("CallToPrintStackTrace")
    public TxResult confirmContractWithDebug(int contractId) {

        String getSql = """
            SELECT contract_id, room_id, tenant_id, status
            FROM CONTRACT
            WHERE contract_id = ?
        """;

        String updateContract = """
            UPDATE CONTRACT
            SET status = 'ACTIVE', updated_at = SYSDATETIME()
            WHERE contract_id = ? AND status = 'PENDING'
        """;

        String updateRoom = """
            UPDATE ROOM
            SET status = 'OCCUPIED'
            WHERE room_id = ?
        """;

        String updateTenant = """
            UPDATE TENANT
            SET account_status = 'ACTIVE', updated_at = SYSDATETIME()
            WHERE tenant_id = ?
        """;

        // optional
        String confirmPayment = """
            UPDATE PAYMENT
            SET status = 'CONFIRMED'
            WHERE payment_id = (
                SELECT TOP 1 payment_id
                FROM PAYMENT
                WHERE contract_id = ?
                  AND method = 'BANK'
                  AND status = 'PENDING'
                ORDER BY paid_at DESC, payment_id DESC
            )
        """;

        // ✅ MỖI LẦN GỌI -> LẤY CONNECTION MỚI (tránh reuse connection đã close)
        try (Connection conn = new DBContext().getConnection()) {

            conn.setAutoCommit(false);

            int roomId;
            int tenantId;
            String status;

            // STEP 1: load contract
            try (PreparedStatement ps = conn.prepareStatement(getSql)) {
                ps.setInt(1, contractId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return new TxResult(false, "NOT_FOUND", "Contract not found");
                    }
                    status = rs.getString("status");
                    roomId = rs.getInt("room_id");
                    tenantId = rs.getInt("tenant_id");
                }
            }

            if (!"PENDING".equalsIgnoreCase(status)) {
                conn.rollback();
                return new TxResult(false, "NOT_PENDING", "Current status=" + status);
            }

            // STEP 2: contract pending -> active
            int a1;
            try (PreparedStatement ps = conn.prepareStatement(updateContract)) {
                ps.setInt(1, contractId);
                a1 = ps.executeUpdate();
            }
            if (a1 <= 0) {
                conn.rollback();
                return new TxResult(false, "FAIL_CONTRACT_UPDATE", "Row affected=" + a1);
            }

            // STEP 3: room -> occupied
            int a2;
            try (PreparedStatement ps = conn.prepareStatement(updateRoom)) {
                ps.setInt(1, roomId);
                a2 = ps.executeUpdate();
            }
            if (a2 <= 0) {
                conn.rollback();
                return new TxResult(false, "FAIL_ROOM_UPDATE", "roomId=" + roomId);
            }

            // STEP 4: tenant -> active
            int a3;
            try (PreparedStatement ps = conn.prepareStatement(updateTenant)) {
                ps.setInt(1, tenantId);
                a3 = ps.executeUpdate();
            }
            if (a3 <= 0) {
                conn.rollback();
                return new TxResult(false, "FAIL_TENANT_UPDATE", "tenantId=" + tenantId);
            }

            // STEP 5: payment confirm (optional)
            try (PreparedStatement ps = conn.prepareStatement(confirmPayment)) {
                ps.setInt(1, contractId);
                ps.executeUpdate();
            }

            conn.commit();
            return new TxResult(true, "OK", null);

        } catch (SQLException e) {
            e.printStackTrace();
            return new TxResult(false, "EXCEPTION", e.getMessage());
        }
    }

    // giữ hàm cũ để code khác không vỡ
    public boolean confirmContract(int contractId) {
        return confirmContractWithDebug(contractId).isOk();
    }
}
