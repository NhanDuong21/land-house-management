package DALs.auth;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;

import Models.entity.OtpCode;
import Utils.database.DBContext;
import Utils.security.HashUtil;

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

    //tìm OTP mới nhất còn hiệu lực để verify
    // find dựa trên tiêu chí tenant id và purpoes
    @SuppressWarnings("CallToPrintStackTrace")
    public OtpCode findValidLatestOtp(int tenantId, String purpose) {
        String sql = """
    SELECT TOP 1 otp_id, tenant_id, purpose, receiver, otp_hash, expires_at, used_at 
    FROM OTP_CODE 
    WHERE tenant_id = ? AND purpose = ? AND used_at IS NULL AND expires_at > SYSDATETIME() 
    ORDER BY otp_id DESC
                """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
            ps.setString(2, purpose);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    OtpCode o = new OtpCode();
                    o.setOtpId(rs.getInt("otp_id"));
                    o.setTenantId(rs.getInt("tenant_id"));
                    o.setPurpose(rs.getString("purpose"));
                    o.setReceiver(rs.getString("receiver"));
                    o.setOtpHash(rs.getString("otp_hash"));
                    o.setExpiresAt(rs.getTimestamp("expires_at"));
                    o.setUsedAt(rs.getTimestamp("used_at"));
                    return o;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    //disable otp khi mà đã sử dụng
    @SuppressWarnings("CallToPrintStackTrace")
    public boolean markUsed(int otpId) {
        String sql = "UPDATE OTP_CODE SET used_at = SYSDATETIME() WHERE otp_id = ? AND used_at IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, otpId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    //login laanf ddau voiw otp
    public void insertFirstLoginOtp(Connection conn, int tenantId, String email, String otpPlain)
            throws SQLException {

        String sql = """
        INSERT INTO OTP_CODE (tenant_id, purpose, receiver, otp_hash, expires_at, used_at) 
        VALUES (?, 'FIRST_LOGIN', ?, ?, DATEADD(MINUTE,10,SYSDATETIME()), NULL)
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
            ps.setString(2, email);
            ps.setString(3, HashUtil.md5(otpPlain));
            ps.executeUpdate();
        }
    }

}
