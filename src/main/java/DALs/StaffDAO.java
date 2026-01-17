package DALs;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import Models.authentication.AuthUser;
import Models.entity.Staff;
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

    //remember me
    public void saveRemember(int staffId, String token) {
        String sql = "UPDATE STAFF SET token = ? WHERE staff_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setInt(2, staffId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("SAVE REMEMBER TOKEN ERROR: " + e.getMessage());
        }
    }

    //muốn biết cookie token này thuộc về staff nào trong DB thì phải có method này
    //login select theo username + password
    //findByRememberToken select theo token
    public AuthUser findByRememberToken(String token) {
        String sql = "SELECT staff_id, full_name, staff_role FROM STAFF WHERE token = ? AND status = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
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
            System.out.println("FIND BY REMEMBER TOKEN ERROR: " + e.getMessage());
        }
        return null;
    }

    //set token lại thành null 
    public void clearRememberToken(int staffId) {
        String sql = "UPDATE STAFF SET token = NULL WHERE staff_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("CLEAR REMEMBER TOKEN ERROR: " + e.getMessage());
        }
    }

    public Staff getById(int staffId) {
        String sql = "SELECT staff_id, username, password_hash, full_name, phone_number, "
                + " email, identity_code, staff_role, status, created_at, updated_at, avatar,gender, date_of_birth, house_id "
                + "FROM Staff "
                + "WHERE staff_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Staff staff = new Staff();
                    staff.setStaffId(rs.getInt("staff_id"));
                    staff.setUsername(rs.getString("username"));
                    staff.setPasswordHash(rs.getString("password_hash"));
                    staff.setFullName(rs.getString("full_name"));
                    staff.setPhoneNumber(rs.getString("phone_number"));
                    staff.setEmail(rs.getString("email"));
                    staff.setIdentityCode(rs.getString("identity_code"));
                    staff.setStaffRole(rs.getByte("staff_role"));
                    staff.setStatus(rs.getByte("status"));

                    staff.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (Exception e) {

        }
        return null;
    }
}
