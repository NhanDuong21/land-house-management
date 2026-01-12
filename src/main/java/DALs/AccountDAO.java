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

    //remember me
    public void saveRemember(int accountId, String token) {
        String sql = "UPDATE Account SET token = ? WHERE account_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, token);
            ps.setInt(2, accountId);
            ps.executeUpdate();

        } catch (SQLException e) {
            System.out.println("SAVE REMEMBER TOKEN ERROR: " + e.getMessage());
        }
    }

    //muốn biết cookie token này thuộc về account nào trong DB thì phải có method này
    //login select theo username + password
    //findByRememberToken select theo token
    public Account findByRememberToken(String token) {
        String sql = """
        SELECT account_id, username, role, status
        FROM Account
        WHERE token = ? AND status = 'ACTIVE'
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, token);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Account acc = new Account();
                    acc.setAccountId(rs.getInt("account_id"));
                    acc.setUsername(rs.getString("username"));
                    acc.setRole(rs.getString("role"));
                    acc.setStatus(rs.getString("status"));
                    return acc;
                }
            }
        } catch (SQLException e) {
            System.out.println("FIND BY REMEMBER TOKEN ERROR: " + e.getMessage());
        }
        return null;
    }

    //set token lại thành null 
    public void clearRememberToken(int accountId) {
        String sql = "UPDATE Account SET token = NULL WHERE account_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("CLEAR REMEMBER TOKEN ERROR: " + e.getMessage());
        }
    }

}
