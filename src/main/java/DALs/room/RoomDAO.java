package DALs.room;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Models.dto.RoomFilterDTO;
import Models.entity.Room;
import Utils.DBContext;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-06
 */
public class RoomDAO extends DBContext {

    @SuppressWarnings("CallToPrintStackTrace")
    public List<Room> searchAvailable(RoomFilterDTO filterDTO) {
        List<Room> list = new ArrayList<>();
        String sql = """
    SELECT r.room_id, r.block_id, r.room_number, r.area, r.price, r.status, r.floor, r.max_tenants, r.is_mezzanine, r.room_image, r.description, r.has_air_conditioning
    FROM ROOM r
    INNER JOIN BLOCK b ON b.block_id = r.block_id
    WHERE r.status = 'AVAILABLE'
      AND (? IS NULL OR r.price >= ?)
      AND (? IS NULL OR r.price <= ?)
      AND (? IS NULL OR r.area  >= ?)
      AND (? IS NULL OR r.area  <= ?)
      AND (? IS NULL OR r.has_air_conditioning = ?) 
      AND (? IS NULL OR r.is_mezzanine = ?)
    ORDER BY b.block_name, r.room_number
""";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            int i = 1;
            //moi query has 2 param
            ps.setBigDecimal(i++, filterDTO.getMinPrice());
            ps.setBigDecimal(i++, filterDTO.getMinPrice());
            ps.setBigDecimal(i++, filterDTO.getMaxPrice());
            ps.setBigDecimal(i++, filterDTO.getMaxPrice());
            ps.setBigDecimal(i++, filterDTO.getMinArea());
            ps.setBigDecimal(i++, filterDTO.getMinArea());
            ps.setBigDecimal(i++, filterDTO.getMaxArea());
            ps.setBigDecimal(i++, filterDTO.getMaxArea());
            ps.setObject(i++, filterDTO.getHasAirConditioning()); // null/true/false
            ps.setObject(i++, filterDTO.getHasAirConditioning());
            ps.setObject(i++, filterDTO.getHasMezzanine()); // null/true/false
            ps.setObject(i++, filterDTO.getHasMezzanine());

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Room r = new Room();
                r.setRoomId(rs.getInt("room_id"));
                r.setBlockId(rs.getInt("block_id"));
                r.setRoomNumber(rs.getString("room_number"));
                r.setArea(rs.getBigDecimal("area"));
                r.setPrice(rs.getBigDecimal("price"));
                r.setStatus(rs.getString("status"));
                r.setFloor((Integer) rs.getObject("floor")); //oj easy debug
                r.setMaxTenants((Integer) rs.getObject("max_tenants"));
                r.setAirConditioning(rs.getBoolean("has_air_conditioning"));
                r.setMezzanine(rs.getBoolean("is_mezzanine"));
                r.setRoomImage(rs.getString("room_image"));
                r.setDescription(rs.getString("description"));
                list.add(r);

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
