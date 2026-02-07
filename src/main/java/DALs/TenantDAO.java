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
}
