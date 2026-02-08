package Services.staff;

import java.math.BigDecimal;
import java.util.List;

import DALs.room.RoomDAO;
import DALs.room.RoomImageDAO;
import Models.dto.RoomFilterDTO;
import Models.entity.Room;

/**
 * Description: staff xem full ( k phan biet status room )
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-09
 */
public class RoomStaffService {

    private final RoomDAO rdao = new RoomDAO();
    private final RoomImageDAO imgDao = new RoomImageDAO();

    //phễu lọc (browser nhận string db nhận bigdec)
    public List<Room> searchForStaff(String minPrice, String maxPrice, String minArea, String maxArea,
            String hasAC, String hasMezzanine) {
        RoomFilterDTO f = new RoomFilterDTO();
        f.setMinPrice(parseDecimal(minPrice));
        f.setMaxPrice(parseDecimal(maxPrice));
        f.setMinArea(parseDecimal(minArea));
        f.setMaxArea(parseDecimal(maxArea));
        f.setHasAirConditioning(parseTriState(hasAC));  // any/yes/no -> null/true/false
        f.setHasMezzanine(parseTriState(hasMezzanine));
        return rdao.searchAll(f);
    }

    private BigDecimal parseDecimal(String s) {
        try {
            if (s == null || s.trim().isEmpty()) {
                return null;
            }
            return new BigDecimal(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private Boolean parseTriState(String str) {
        if (str == null) {
            return null;
        }
        str = str.trim().toLowerCase();
        if (str.equals("yes") || str.equals("true") || str.equals("1")) {
            return true;
        }
        if (str.equals("no") || str.equals("false") || str.equals("0")) {
            return false;
        }
        return null; // any
    }

    //role staff
    public Room getRoomDetailForStaff(int roomId) {

        if (roomId <= 0) {
            return null;
        }
        Room r = rdao.findById(roomId);
        r.setImages(imgDao.findByRoomId(roomId));
        return r;
    }
}
