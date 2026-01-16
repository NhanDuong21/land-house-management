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
public class StaffDAO extends DBContext {

    public AuthUser login(String username, String password) {
        String sql = "SELECT        staff_id, full_name, staff_role, status "
                + "FROM STAFF WHERE username=? AND password_hash=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, HashUtil.md5(password));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() == true) { //check db co null ko
                    byte status = rs.getByte("status");
                    if (status != 1) {
                        return null;
                    }
                    byte staffRole = rs.getByte("staff_role");
                    String role = (staffRole == 1) ? "ADMIN" : "MANAGER";

                    AuthUser authUser = new AuthUser();
                    authUser.setId(rs.getInt("staff_id"));
                    authUser.setFullName(rs.getString("full_name"));
                    authUser.setRole(role);
                    return authUser;
                }
            }
        } catch (SQLException e) {
            System.out.println("LOGIN ERROR: " + e.getMessage());
        }
        return null;
    }
}
