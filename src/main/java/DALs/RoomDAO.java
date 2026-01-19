package DALs;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Models.entity.Room;
import Utils.DBContext;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-01-20
 */
public class RoomDAO extends DBContext {

    /**
     * Lấy danh sách các phòng có trạng thái là 1 (Available)
     *
     * @return List<Room>
     */
    public List<Room> getAvailableRooms() {
        List<Room> listRooms = new ArrayList<>();
        String sql = "SELECT * FROM ROOMS WHERE status = 1";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setHouseId(rs.getInt("house_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setPrice(rs.getBigDecimal("price"));
                room.setArea(rs.getBigDecimal("area"));
                room.setFloor(rs.getInt("floor"));
                room.setMaxTenants(rs.getInt("max_tenants"));
                room.setMezzanine(rs.getBoolean("is_mezzanine"));
                room.setRoomImage(rs.getString("room_image"));
                room.setStatus(rs.getByte("status"));
                room.setDescription(rs.getString("description"));

                listRooms.add(room);
            }
        } catch (SQLException e) {
            System.out.println("getAvailableRooms Error: " + e.getMessage());
        }
        return listRooms;
    }
}
