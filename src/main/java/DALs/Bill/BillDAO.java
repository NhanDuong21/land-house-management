/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DALs.Bill;

import Models.dto.ManagerBillRowDTO;
import Utils.database.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author To Thi Thao Trang - CE191027
 */
public class BillDAO  extends DBContext{
    //get list manage bills
    @SuppressWarnings("CallToPrintStackTrace")
    public List<ManagerBillRowDTO> getManagerBills() {
        List<ManagerBillRowDTO> listBill = new ArrayList<>();
        String sql = "SELECT b.bill_id, "
                + "r.room_number, "
                + "b.bill_month, "
                + "t.full_name AS tenant_name, "
                + "bl.block_name, "
                + "b.due_date,"
                + "SUM(bd.unit_price*bd.quantity) AS total_amount, "
                + "b.status "
                + "FROM BILL b "
                + "JOIN BILL_DETAIL bd ON b.bill_id = bd.bill_id "
                + "JOIN CONTRACT c ON b.contract_id = c.contract_id "
                + "JOIN TENANT t ON c.tenant_id = t.tenant_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "JOIN BLOCK bl ON r.block_id = bl.block_id "
                + "GROUP BY b.bill_id, "
                + "b.bill_month, "
                + "r.room_number, "
                + "t.full_name, "
                + "bl.block_name,"
                + "b.due_date, "
                + "b.status "
                + "ORDER BY b.bill_month DESC";
         try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
             while (rs.next()) {
               ManagerBillRowDTO billRowDTO = new ManagerBillRowDTO();
                billRowDTO.setBillId(rs.getInt("bill_id"));
                billRowDTO.setRoomNumber(rs.getString("room_number"));
                billRowDTO.setMonth(rs.getDate("bill_month"));
                billRowDTO.setTenantName(rs.getString("tenant_name"));
                billRowDTO.setBlockName(rs.getString("block_name"));
                billRowDTO.setDueDate(rs.getDate("due_date"));
                billRowDTO.setTotalAmount(rs.getBigDecimal("total_amount"));
                billRowDTO.setStatus(rs.getString("status"));
               listBill.add(billRowDTO);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listBill;
    }
    public static void main(String[] args) {
        BillDAO bd= new BillDAO();
        List<ManagerBillRowDTO> list = bd.getManagerBills();
        for (ManagerBillRowDTO m : list) {
            System.out.println(m);
        }
    }
    
}
