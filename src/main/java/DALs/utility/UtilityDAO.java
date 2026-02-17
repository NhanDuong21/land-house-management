/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DALs.utility;

import Models.dto.RoomFilterDTO;
import Models.dto.RoomUtilityDTO;
import Models.entity.Room;
import Models.entity.Utility;
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
public class UtilityDAO extends DBContext {

    //view available
    @SuppressWarnings("CallToPrintStackTrace")
    public List<RoomUtilityDTO> getRoomsUsingUtility(int utilityId) {
        List<RoomUtilityDTO> rooms = new ArrayList<>();

        String sql = """
    SELECT DISTINCT
        r.room_id,
        r.room_number,
        t.full_name
    FROM ROOM r
    JOIN CONTRACT c 
        ON r.room_id = c.room_id
    JOIN TENANT t 
        ON c.tenant_id = t.tenant_id
    JOIN BILL b
        ON b.contract_id = c.contract_id
    JOIN BILL_DETAIL bd
        ON bd.bill_id = b.bill_id
    WHERE bd.utility_id = ?
      AND bd.charge_type = 'UTILITY'
""";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, utilityId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                RoomUtilityDTO dto = new RoomUtilityDTO();
                dto.setRoomId(rs.getInt("room_id"));
                dto.setRoomNumber(rs.getString("room_number"));
                dto.setTenantName(rs.getString("full_name"));
                rooms.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    @SuppressWarnings("CallToPrintStackTrace")
    public List<Utility> getAllUtilities() {
        List<Utility> list = new ArrayList<>();

        String sql = """
        SELECT
            utility_id,
            utility_name,
            standard_price,
            unit
        FROM UTILITY
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Utility u = new Utility();
                u.setUtilityId(rs.getInt("utility_id"));
                u.setUtilityName(rs.getString("utility_name"));
                u.setStandardPrice(rs.getBigDecimal("standard_price"));
                u.setUnit(rs.getString("unit"));

                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

}
