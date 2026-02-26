/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DALs.utilities;

import Models.entity.Utility;
import Utils.database.DBContext;
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

    
    
    public static void main(String[] args) {
        utilitiesDAO ud = new utilitiesDAO();
        List<Utility> list = ud.getManagerUntilities();
        for (Utility u : list) {
            System.out.println(u);
        }
    }
}
