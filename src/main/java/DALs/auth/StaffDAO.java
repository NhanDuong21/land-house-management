package DALs.auth;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import Models.entity.Staff;
import Utils.database.DBContext;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-05
 */
public class StaffDAO extends DBContext {

    @SuppressWarnings("CallToPrintStackTrace")
    public Staff findByEmail(String email) {
        String sql = "SELECT staff_id, full_name, email, password_hash, staff_role, status "
                + "FROM STAFF WHERE email = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Staff s = new Staff();
                s.setStaffId(rs.getInt("staff_id"));
                s.setFullName(rs.getString("full_name"));
                s.setEmail(rs.getString("email"));
                s.setPasswordHash(rs.getString("password_hash"));
                s.setStaffRole(rs.getString("staff_role"));
                s.setStatus(rs.getString("status"));
                return s;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateTokenForStaff(int staffId, String token) {
        String sql = "UPDATE STAFF SET token = ? WHERE staff_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setInt(2, staffId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("SAVE REMEMBER TOKEN ERROR: " + e.getMessage());
        }
    }

    public void clearTokenForStaff(int staffId) {
        String sql = "UPDATE STAFF SET token = NULL WHERE staff_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("CLEAR REMEMBER TOKEN ERROR: " + e.getMessage());
        }
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public Staff findByTokenForStaff(String token) {
        if (token == null || token.isBlank()) {
            return null;
        }

        String sql = "SELECT TOP 1 * FROM STAFF WHERE token = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, token.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Staff staff = new Staff();
                    staff.setStaffId(rs.getInt("staff_id"));
                    staff.setFullName(rs.getString("full_name"));
                    staff.setPhoneNumber(rs.getString("phone_number"));
                    staff.setEmail(rs.getString("email"));
                    staff.setIdentityCode(rs.getString("identity_code"));
                    staff.setDateOfBirth(rs.getDate("date_of_birth"));
                    staff.setGender(rs.getObject("gender") == null ? null : ((Number) rs.getObject("gender")).intValue());
                    staff.setStaffRole(rs.getString("staff_role"));
                    staff.setPasswordHash(rs.getString("password_hash"));
                    staff.setAvatar(rs.getString("avatar"));
                    staff.setStatus(rs.getString("status"));
                    staff.setCreatedAt(rs.getTimestamp("created_at"));
                    staff.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return staff;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public Staff findById(int staffId) {
        String sql = """
        SELECT staff_id, full_name, phone_number, email, identity_code, date_of_birth, gender,
               staff_role, password_hash, avatar, status, created_at, updated_at
        FROM STAFF
        WHERE staff_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, staffId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Staff staff = new Staff();
                    staff.setStaffId(rs.getInt("staff_id"));
                    staff.setFullName(rs.getString("full_name"));
                    staff.setPhoneNumber(rs.getString("phone_number"));
                    staff.setEmail(rs.getString("email"));
                    staff.setIdentityCode(rs.getString("identity_code"));
                    staff.setDateOfBirth(rs.getDate("date_of_birth"));
                    staff.setGender(rs.getObject("gender") == null ? null : ((Number) rs.getObject("gender")).intValue());
                    staff.setStaffRole(rs.getString("staff_role"));
                    staff.setPasswordHash(rs.getString("password_hash"));
                    staff.setAvatar(rs.getString("avatar"));
                    staff.setStatus(rs.getString("status"));
                    staff.setCreatedAt(rs.getTimestamp("created_at"));
                    staff.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return staff;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public String getPasswordHashById(int staffId) {
        String sql = "SELECT password_hash FROM STAFF WHERE staff_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("password_hash");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public boolean updatePasswordForStaff(int staffId, String newHash) {
        String sql = "UPDATE STAFF SET password_hash = ?, updated_at = SYSDATETIME() WHERE staff_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setInt(2, staffId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
