package DALs.room;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import Models.entity.RoomImage;
import Utils.database.DBContext;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-07
 */
public class RoomImageDAO extends DBContext {

    @SuppressWarnings("CallToPrintStackTrace")
    public List<RoomImage> findByRoomId(int roomId) {
        String sql = """
            SELECT image_id, room_id, image_url, is_cover, sort_order
            FROM ROOM_IMAGE
            WHERE room_id = ?
            ORDER BY is_cover DESC, sort_order ASC, image_id ASC
        """;

        List<RoomImage> list = new ArrayList<>();
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
