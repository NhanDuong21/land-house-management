/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DALs.manageRooms;

import Models.entity.Room;
import Utils.database.DBContext;
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

    public List<Room> fetchAllRoom() {
        String sql
                = "SELECT r.*, b.blockName "
                + "FROM Room r "
                + "JOIN Block b ON r.blockId = b.blockId "
                + "ORDER BY r.roomId "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<Room> Rooms = new ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
//            int offset = (pageIndex - 1) * pageSize;
//            ps.setInt(1, offset);
//            ps.setInt(2, pageSize);
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
                Rooms.add(p);
            }
        } catch (SQLException ex) {
            return null;
        }
        return Rooms;
    }
    
}
