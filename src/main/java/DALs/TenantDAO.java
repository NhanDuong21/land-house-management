package DALs;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import Models.entity.Tenant;
import Utils.database.DBContext;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-05
 */
public class TenantDAO extends DBContext {

    @SuppressWarnings("CallToPrintStackTrace")
    public Tenant findByEmail(String email) {
        String sql = "SELECT tenant_id, full_name, email, password_hash, account_status, must_set_password "
                + "FROM TENANT WHERE email = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Tenant t = new Tenant();
                t.setTenantId(rs.getInt("tenant_id"));
                t.setFullName(rs.getString("full_name"));
                t.setEmail(rs.getString("email"));
                t.setPasswordHash(rs.getString("password_hash"));
                t.setAccountStatus(rs.getString("account_status"));
                t.setMustSetPassword(rs.getBoolean("must_set_password"));
                return t;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateTokenForTenant(int tenantId, String token) {
        String sql = "UPDATE TENANT SET token = ? WHERE tenant_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setInt(2, tenantId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("SAVE REMEMBER TOKEN ERROR: " + e.getMessage());
        }
    }

    public void clearTokenForTenant(int tenantId) {
        String sql = "UPDATE TENANT SET token = NULL WHERE tenant_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("CLEAR REMEMBER TOKEN ERROR: " + e.getMessage());
        }
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public Tenant findByTokenForTenant(String token) {
        if (token == null || token.isBlank()) {
            return null;
        }

        String sql = "select top 1 * from TENANT where token = ? and account_status = 'ACTIVE'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, token.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Tenant tenant = new Tenant();
                    tenant.setTenantId(rs.getInt("tenant_id"));
                    tenant.setFullName(rs.getString("full_name"));
                    tenant.setIdentityCode(rs.getString("identity_code"));
                    tenant.setPhoneNumber(rs.getString("phone_number"));
                    tenant.setEmail(rs.getString("email"));
                    tenant.setAddress(rs.getString("address"));
                    tenant.setDateOfBirth(rs.getDate("date_of_birth"));
                    tenant.setGender(rs.getObject("gender") == null ? null : (Integer) rs.getObject("gender"));
                    tenant.setAvatar(rs.getString("avatar"));
                    tenant.setAccountStatus(rs.getString("account_status"));
                    tenant.setPasswordHash(rs.getString("password_hash"));
                    tenant.setMustSetPassword(rs.getBoolean("must_set_password"));
                    tenant.setCreatedAt(rs.getTimestamp("created_at"));
                    tenant.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return tenant;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
