package DALs.room;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Models.dto.RoomFilterDTO;
import Models.entity.Room;
import Models.entity.RoomImage;
import Utils.DBContext;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-06
 */
public class RoomDAO extends DBContext {

    //view available
    @SuppressWarnings("CallToPrintStackTrace")
    public List<Room> searchAvailable(RoomFilterDTO filterDTO) {
        List<Room> list = new ArrayList<>();
        String sql = """
    SELECT r.room_id, r.block_id, r.room_number, r.area, r.price, r.status, r.floor, r.max_tenants, r.is_mezzanine, r.description, r.has_air_conditioning, img.image_url AS cover_image
    FROM ROOM r
    INNER JOIN BLOCK b ON b.block_id = r.block_id
	LEFT JOIN ROOM_IMAGE img ON img.room_id = r.room_id AND img.is_cover = 1
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
                r.setRoomImage(rs.getString("cover_image")); // left join ROOM_IMAGE
                r.setDescription(rs.getString("description"));
                list.add(r);

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public Room findById(int roomId) {
        String sql = """
SELECT        ROOM.room_id, ROOM.block_id, BLOCK.block_name, ROOM.room_number, ROOM.area, ROOM.price, ROOM.status, ROOM.floor, ROOM.max_tenants, ROOM.is_mezzanine, ROOM.description, 
                         ROOM.has_air_conditioning, img.image_url AS cover_image
FROM            ROOM INNER JOIN
                         BLOCK ON ROOM.block_id = BLOCK.block_id
                         LEFT JOIN ROOM_IMAGE img ON img.room_id = ROOM.room_id AND img.is_cover = 1
WHERE   ROOM.room_id = ?
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery();) {
                if (rs.next()) {
                    Room r = new Room();
                    r.setRoomId(rs.getInt("room_id"));
                    r.setBlockId(rs.getInt("block_id"));
                    r.setBlockName(rs.getString("block_name"));
                    r.setRoomNumber(rs.getString("room_number"));
                    r.setArea(rs.getBigDecimal("area"));
                    r.setPrice(rs.getBigDecimal("price"));
                    r.setStatus(rs.getString("status"));
                    r.setFloor((Integer) rs.getObject("floor")); //oj easy debug
                    r.setMaxTenants((Integer) rs.getObject("max_tenants"));
                    r.setAirConditioning(rs.getBoolean("has_air_conditioning"));
                    r.setMezzanine(rs.getBoolean("is_mezzanine"));
                    r.setRoomImage(rs.getString("cover_image"));
                    r.setDescription(rs.getString("description"));
                    return r;
                }
                return null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<RoomImage> findImagesByRoomId(int roomId) {
        List<RoomImage> list = new ArrayList<>();
        String sql
                = "SELECT image_id, room_id, image_url, is_cover, sort_order "
                + "FROM ROOM_IMAGE "
                + "WHERE room_id = ? "
                + "ORDER BY is_cover DESC, sort_order ASC, image_id ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomImage img = new RoomImage();
                    img.setImageId(rs.getInt("image_id"));
                    img.setRoomId(rs.getInt("room_id"));
                    img.setImageUrl(rs.getString("image_url"));
                    img.setCover(rs.getBoolean("is_cover"));
                    img.setSortOrder(rs.getInt("sort_order"));
                    list.add(img);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}
