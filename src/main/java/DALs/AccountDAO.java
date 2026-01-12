package DALs;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import Models.Account;
import Utils.DBContext;
import Utils.HashUtil;

/**
 * Author: Duong Thien Nhan - CE190741 Created on: 2026-01-12
 */
public class AccountDAO extends DBContext {

    public Account login(String username, String password) {
        String sql = """
            SELECT account_id, username, password, email, avatar, role, status
            FROM Account
            WHERE username = ? AND password = ? AND status = 'ACTIVE'
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, HashUtil.md5(password));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() == true) { //check db co null ko
                    Account acc = new Account();
                    acc.setAccountId(rs.getInt("account_id"));
                    acc.setUsername(rs.getString("username"));
                    acc.setRole(rs.getString("role"));
                    acc.setStatus(rs.getString("status"));
                    return acc;
                }
            }
        } catch (SQLException e) {
            System.out.println("LOGIN ERROR: " + e.getMessage());
        }
        return null;
    }

}
