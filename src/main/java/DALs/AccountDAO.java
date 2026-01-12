package DALs;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import Models.Account;
import Utils.DBContext;

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
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Account acc = new Account();
                    acc.setAccountId(rs.getInt("accountId"));
                    acc.setUsername(rs.getString("username"));
                    acc.setPassword(rs.getString("password"));
                    acc.setEmail(rs.getString("email"));
                    acc.setAvatar(rs.getString("avatar"));
                    acc.setRole(rs.getString("role"));
                    acc.setStatus(rs.getString("status"));
                    return acc;
                }
            }
        } catch (SQLException e) {
            System.out.println("getById ERROR: " + e.getMessage());
        }
        return null;
    }
}
