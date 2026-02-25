/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DALs.manageRooms;

import Models.entity.Room;
import Utils.database.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Truong Hoang Khang - CE190729
 */
public class ManageRoomsDAO extends DBContext {

    public List<Room> fetchAllRoom(int pageIndex, int pageSize) {
        List<Room> list = new ArrayList<>();

        String sql
                = "SELECT r.*, b.block_name "
                + "FROM Room r "
                + "JOIN Block b ON r.block_id = b.block_id "
                + "ORDER BY r.room_id "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, (pageIndex - 1) * pageSize);
            ps.setInt(2, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Room p = new Room();

                p.setRoomId(rs.getInt("room_id"));
                p.setBlockName(rs.getString("block_name"));
                p.setRoomNumber(rs.getString("room_number"));
                p.setArea(rs.getBigDecimal("area"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setFloor(rs.getInt("floor"));
                p.setMaxTenants(rs.getInt("max_tenants"));
                p.setMezzanine(rs.getBoolean("is_mezzanine"));
                p.setAirConditioning(rs.getBoolean("has_air_conditioning"));
                p.setStatus(rs.getString("status"));

                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countRoom() {
        String sql = "SELECT COUNT(*) FROM Room";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
