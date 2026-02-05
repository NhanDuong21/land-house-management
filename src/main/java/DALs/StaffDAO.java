package DALs;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import Models.entity.Staff;
import Utils.DBContext;

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
}
