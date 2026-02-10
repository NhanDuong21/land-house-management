package DALs.auth;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;

import Utils.database.DBContext;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-11
 */
public class OtpCodeDAO extends DBContext {

    @SuppressWarnings("CallToPrintStackTrace")
    public void invalidateOldOtps(int tenantId, String purpose) {
        String sql = "UPDATE OTP_CODE SET used_at = SYSDATETIME() "
                + "WHERE tenant_id = ? AND purpose = ? AND used_at IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
            ps.setString(2, purpose);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public int insertOtp(int tenantId, String purpose, String receiver, String otpHash, LocalDateTime expiresAt) {
        String sql = "INSERT INTO OTP_CODE(tenant_id, purpose, receiver, otp_hash, expires_at, used_at) "
                + "VALUES(?,?,?,?,?,NULL)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, tenantId);
            ps.setString(2, purpose);
            ps.setString(3, receiver);
            ps.setString(4, otpHash);
            ps.setTimestamp(5, Timestamp.valueOf(expiresAt));
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
}
