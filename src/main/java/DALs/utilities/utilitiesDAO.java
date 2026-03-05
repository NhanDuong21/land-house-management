/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DALs.utilities;

import Models.entity.Utility;
import Utils.database.DBContext;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author DELL
 */
public class utilitiesDAO extends DBContext {

    public List<Utility> getManagerUntilities() {
        List<Utility> listUntilities = new ArrayList<>();
        String sql = "SELECT utility_id, utility_name, unit, standard_price, is_active, status, created_at, updated_at\n"
                + "FROM     UTILITY\n"
                + "ORDER BY utility_id";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Utility u = new Utility();
                u.setUtilityId(rs.getInt("utility_id"));
                u.setUtilityName(rs.getString("utility_name"));
                u.setUnit(rs.getString("unit"));
                u.setStandardPrice(rs.getBigDecimal("standard_price"));
                u.setActive(rs.getBoolean("is_active"));
                u.setStatus(rs.getString("status"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setUpdatedAt(rs.getTimestamp("updated_at"));
                listUntilities.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listUntilities;
    }

    public boolean addUtility(String utilityName, BigDecimal standardPrice, String unit) {
        String sql = "insert into utility(utility_name, standard_price, unit, is_active, status, created_at, updated_at) \n"
                + "values(?, ?, ?, 1, 'ACTIVE', GETDATE(), GETDATE())";
        //mình add tỏng sql là có 5 dữ liệu nên là 5 dấu hỏi á
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, utilityName);
            ps.setBigDecimal(2, standardPrice);
            ps.setString(3, unit);

            //thay đổi dữ liệu nên xài executeUpdate()
            //còn executeQuery() nó k có lm thay đổi 
            int row = ps.executeUpdate();
            if (row > 0) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Utility getUtilityById(int id) {
        String sql = "SELECT * FROM UTILITY WHERE utility_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Utility u = new Utility();
                u.setUtilityId(rs.getInt("utility_id"));
                u.setUtilityName(rs.getString("utility_name"));
                u.setUnit(rs.getString("unit"));
                u.setStandardPrice(rs.getBigDecimal("standard_price"));
                u.setActive(rs.getBoolean("is_active"));
                u.setStatus(rs.getString("status"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Boolean deleteUtilities(int id) {
        String sql = "DELETE FROM UTILITY WHERE utility_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            //trả về kiểu int kiểu số lượng dòng mình xóa hay mình thêm
            //update mà ra 0 là k có update đc dòng nào
            int num = ps.executeUpdate();
            if (num > 0) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUtilities(int id, BigDecimal price) {
        String sql = "UPDATE UTILITY SET standard_price = ?, updated_at = GETDATE() WHERE utility_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setBigDecimal(1, price);
            ps.setInt(2, id);
            int num = ps.executeUpdate();
            return num > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static void main(String[] args) {
        utilitiesDAO ud = new utilitiesDAO();
        List<Utility> list = ud.getManagerUntilities();
        for (Utility u : list) {
            System.out.println(u);
        }
    }
}
