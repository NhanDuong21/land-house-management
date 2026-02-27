package DALs.auth;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Models.entity.Staff;
import Models.entity.Tenant;
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

    public List<Tenant> getAllTenants() {
        List<Tenant> list = new ArrayList<>();
        try {
            String sql = "SELECT tenant_id, full_name, identity_code, phone_number, email, date_of_birth FROM TENANT";
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Tenant t = new Tenant(
                        rs.getInt("tenant_id"),
                        rs.getString("full_name"),
                        rs.getString("identity_code"),
                        rs.getString("phone_number"),
                        rs.getString("email"),
                        rs.getDate("date_of_birth")
                );
                list.add(t);
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Tenant> searchTenant(String keyword) {
        List<Tenant> list = new ArrayList<>();
        try {

            String sql;
            PreparedStatement ps;

            // Nếu là số → search id
            if (keyword.matches("\\d+")) {
                sql = """
                SELECT tenant_id, full_name, identity_code, phone_number, email, date_of_birth
                FROM TENANT
                WHERE tenant_id = ?
            """;
                ps = connection.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(keyword));
            } // Nếu là chữ → search name phone email
            else {
                sql = """
                SELECT tenant_id, full_name, identity_code, phone_number, email, date_of_birth
                FROM TENANT
                WHERE full_name LIKE ?
                   OR phone_number LIKE ?
                   OR email LIKE ?
            """;
                ps = connection.prepareStatement(sql);

                String key = "%" + keyword + "%";
                ps.setString(1, key);
                ps.setString(2, key);
                ps.setString(3, key);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Tenant t = new Tenant(
                        rs.getInt("tenant_id"),
                        rs.getString("full_name"),
                        rs.getString("identity_code"),
                        rs.getString("phone_number"),
                        rs.getString("email"),
                        rs.getDate("date_of_birth")
                );
                list.add(t);
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public static void main(String[] args) {
        StaffDAO dao = new StaffDAO();

        // List<Tenant> list = dao.searchTenant("10"); // search id
        List<Tenant> list = dao.searchTenant("o"); // search name
        //List<Tenant> list = dao.searchTenant("090"); // search phone
        //List<Tenant> list = dao.searchTenant("nhan1@gmail.com"); // search email

        for (Tenant t : list) {
            System.out.println(t.getTenantId() + " - " + t.getFullName());
        }
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public boolean existsPhoneExceptStaff(int staffId, String phone) {
        String sql = "SELECT 1 FROM STAFF WHERE phone_number = ? AND staff_id <> ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setInt(2, staffId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public boolean existsEmailExceptStaff(int staffId, String email) {
        String sql = "SELECT 1 FROM STAFF WHERE email = ? AND staff_id <> ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, staffId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // update manager
    @SuppressWarnings("CallToPrintStackTrace")
    public boolean updateContactForStaff(int staffId, String phone, String email) {
        String sql = """
        UPDATE STAFF
        SET phone_number = ?, email = ?, updated_at = SYSDATETIME()
        WHERE staff_id = ?
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setString(2, email);
            ps.setInt(3, staffId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // admin thi update full infor bth
    @SuppressWarnings("CallToPrintStackTrace")
    public boolean updateProfileForAdmin(int staffId, String fullName, String phone, String email,
            String identityCode, java.sql.Date dob, Integer gender) {

        String sql = """
    UPDATE STAFF SET full_name = ?, phone_number = ?, email = ?,
            identity_code = ?, date_of_birth = ?,gender = ?,
            updated_at = SYSDATETIME()
        WHERE staff_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, identityCode);
            ps.setDate(5, dob);
            if (gender == null) {
                ps.setNull(6, java.sql.Types.TINYINT);
            } else {
                ps.setInt(6, gender);
            }
            ps.setInt(7, staffId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;

    }

    @SuppressWarnings("CallToPrintStackTrace")
    public Staff findManager() {
        String sql = """
        SELECT TOP 1 staff_id, full_name, email, staff_role, status
        FROM STAFF
        WHERE staff_role = 'MANAGER' AND status = 'ACTIVE'
        ORDER BY staff_id ASC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                Staff s = new Staff();
                s.setStaffId(rs.getInt("staff_id"));
                s.setFullName(rs.getString("full_name"));
                s.setEmail(rs.getString("email"));
                s.setStaffRole(rs.getString("staff_role"));
                s.setStatus(rs.getString("status"));
                return s;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
