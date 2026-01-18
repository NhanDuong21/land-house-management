package DALs;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import Models.authentication.AuthUser;
import Models.entity.Tenant;
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
            System.err.println("LOGIN SQL ERROR, username=" + username + ": " + e.getMessage());
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

    public Tenant getById(int tenantId) {
        String sql = "SELECT tenant_id, username, password_hash, full_name, phone_number, email, identity_code, address, gender, date_of_birth, avatar, created_at, updated_at "
                + "FROM TENANTS "
                + "WHERE tenant_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Tenant tenant = new Tenant();
                    tenant.setTenantId(rs.getInt("tenant_id"));
                    tenant.setUsername(rs.getString("username"));
                    tenant.setPasswordHash(rs.getString("password_hash"));
                    tenant.setFullName(rs.getString("full_name"));
                    tenant.setPhoneNumber(rs.getString("phone_number"));
                    tenant.setEmail(rs.getString("email"));
                    tenant.setIdentityCode(rs.getString("identity_code"));
                    tenant.setAddress(rs.getString("address"));
                    tenant.setGender(rs.getByte("gender"));
                    tenant.setDateOfBirth(rs.getDate("date_of_birth") != null ? rs.getDate("date_of_birth").toLocalDate() : null);
                    tenant.setAvatar(rs.getString("avatar"));
                    tenant.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    tenant.setUpdatedAt(rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null);
                    return tenant;
                }
            }
        } catch (SQLException e) {
            System.err.println("Database Error: " + e.getMessage());
            System.err.println("Tenant ID attempted: " + tenantId);
        } catch (Exception e) {
            System.err.println("General Error: " + e.getMessage());
        }
        return null;
    }

    public boolean updatePassword(int tenantId, String newPassword) {
        String newHash = HashUtil.md5(newPassword);
        String sql = "UPDATE TENANTS SET password_hash = ?, updated_at = SYSDATETIME() WHERE tenant_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setInt(2, tenantId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
