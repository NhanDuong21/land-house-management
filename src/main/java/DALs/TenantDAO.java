package DALs;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import Models.authentication.AuthUser;
import Utils.DBContext;
import Utils.HashUtil;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-01-16
 */
public class TenantDAO extends DBContext {

    public AuthUser login(String username, String password) {
        String sql = "SELECT        tenant_id, full_name, status "
                + "FROM TENANTS WHERE username = ? AND password_hash = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, HashUtil.md5(password));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() == true) {
                    byte status = rs.getByte("status");
                    if (status != 1) {
                        return null;
                    }
                    AuthUser authUser = new AuthUser();
                    authUser.setId(rs.getInt("tenant_id"));
                    authUser.setFullName(rs.getString("full_name"));
                    authUser.setRole("TENANT"); // vì chỉ có 1 entity tenant duy nhất
                    return authUser;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    //remember me
    public void saveRemember(int tenantId, String token) {
        String sql = "UPDATE TENANTS SET token = ? WHERE tenant_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setInt(2, tenantId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("SAVE REMEMBER TOKEN ERROR: " + e.getMessage());
        }
    }

    public AuthUser findByRememberToken(String token) {
        String sql = "SELECT tenant_id, full_name FROM TENANTS WHERE token = ? AND status = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AuthUser authUser = new AuthUser();
                    authUser.setId(rs.getInt("tenant_id"));
                    authUser.setFullName(rs.getString("full_name"));
                    authUser.setRole("TENANT");
                    return authUser;
                }
            }
        } catch (SQLException e) {
            System.out.println("FIND BY REMEMBER TOKEN ERROR: " + e.getMessage());
        }
        return null;
    }

    //set token lại thành null 
    public void clearRememberToken(int tenantId) {
        String sql = "UPDATE TENANTS SET token = NULL WHERE staff_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("CLEAR REMEMBER TOKEN ERROR: " + e.getMessage());
        }
    }
}
