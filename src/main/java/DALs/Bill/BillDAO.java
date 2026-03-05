package DALs.Bill;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Models.dto.ManagerBillRowDTO;
import Models.entity.Bill;
import Models.entity.BillDetail;
import Models.entity.Payment;
import Models.entity.Utility;
import Utils.database.DBContext;

/**
 *
 * @author To Thi Thao Trang - CE191027
 */
public class BillDAO extends DBContext {

    // =========================
    // GET LIST BILL - MANAGER
    // =========================
    @SuppressWarnings("CallToPrintStackTrace")
    public List<ManagerBillRowDTO> getManagerBills(int page, int pageSize) {
        List<ManagerBillRowDTO> listBill = new ArrayList<>();

        String sql = "SELECT b.bill_id, r.room_number, b.bill_month, "
                + "       t.full_name AS tenant_name, bl.block_name, "
                + "       b.due_date, x.total_amount, "
                + "       b.status, "
                + "       p.status AS payment_status "
                + "FROM BILL b "
                + "JOIN CONTRACT c ON b.contract_id = c.contract_id "
                + "JOIN TENANT t ON c.tenant_id = t.tenant_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "JOIN BLOCK bl ON r.block_id = bl.block_id "
                + "JOIN ( "
                + "   SELECT bill_id, SUM(unit_price * quantity) AS total_amount "
                + "   FROM BILL_DETAIL GROUP BY bill_id "
                + ") x ON b.bill_id = x.bill_id "
                + "LEFT JOIN PAYMENT p ON p.bill_id = b.bill_id "
                + "ORDER BY b.bill_month DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        int offset = (page - 1) * pageSize;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ManagerBillRowDTO dto = new ManagerBillRowDTO();
                dto.setBillId(rs.getInt("bill_id"));
                dto.setRoomNumber(rs.getString("room_number"));
                dto.setMonth(rs.getDate("bill_month"));
                dto.setTenantName(rs.getString("tenant_name"));
                dto.setBlockName(rs.getString("block_name"));
                dto.setDueDate(rs.getDate("due_date"));
                dto.setTotalAmount(rs.getBigDecimal("total_amount"));
                dto.setStatus(rs.getString("status"));
                dto.setPaymentStatus(rs.getString("payment_status"));
                listBill.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return listBill;
    }

    // =========================
    // GET BILL DETAIL - MANAGER
    // =========================
    public Bill findBillDetailByIdForManager(int bill_id) {
        String sql = "SELECT *"
                + "FROM BILL "
                + "WHERE bill_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bill_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Bill b = new Bill();
                b.setBillId(rs.getInt("bill_id"));
                b.setContractId(rs.getInt("contract_id"));
                b.setBillMonth(rs.getDate("bill_month"));
                b.setDueDate(rs.getDate("due_date"));
                b.setStatus(rs.getString("status"));
                b.setNote(rs.getString("note"));
                b.setOldElectricNumber(rs.getInt("old_electric_number"));
                b.setNewElectricNumber(rs.getInt("new_electric_number"));
                b.setOldWaterNumber(rs.getInt("old_water_number"));
                b.setNewWaterNumber(rs.getInt("new_water_number"));
                return b;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getStringRoomnumber(int bill_id) {
        String sql = "SELECT ROOM.room_number FROM BILL "
                + "INNER JOIN CONTRACT ON BILL.contract_id = CONTRACT.contract_id "
                + "INNER JOIN ROOM ON CONTRACT.room_id = ROOM.room_id "
                + "WHERE BILL.bill_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bill_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("room_number");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =========================
    // TOTAL AMOUNT - BILL DETAIL
    // =========================
    public BigDecimal totalAmount(int bill_id) {
        String sql = "SELECT ROUND(SUM(unit_price * quantity), 0) AS total_amount "
                + "FROM BILL_DETAIL "
                + "where bill_id = ? "
                + "GROUP BY bill_id;";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bill_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // return 0 instead of null, advoid NullPointerException
        return BigDecimal.ZERO;
    }

    // =========================
    //  GET LIST BILL DETAIL (BREAKDOWN UI)
    // =========================
    public List<BillDetail> getListBillDetailByBillId(int bill_id) {
        List<BillDetail> listBillDetail = new ArrayList<>();
        String sql = "SELECT * "
                + "FROM BILL_DETAIL "
                + "WHERE bill_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bill_id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BillDetail bd = new BillDetail();
                bd.setBillDetailId(rs.getInt("bill_detail_id"));
                bd.setBillId(rs.getInt("bill_id"));
                bd.setUtilityId(rs.getInt("utility_id"));
                bd.setItemName(rs.getString("item_name"));
                bd.setUnit(rs.getString("unit"));
                bd.setQuantity(rs.getBigDecimal("quantity"));
                bd.setUnitPrice(rs.getBigDecimal("unit_price"));
                bd.setChargeType(rs.getString("charge_type"));
                listBillDetail.add(bd);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return listBillDetail;
    }

    // =========================
    //  GET QR CODE DATA - BILL DETAIL
    // =========================
    public String getQRFromContractByBillId(int bill_id) {
        String sql = "SELECT c.payment_qr_data "
                + "FROM BILL b "
                + "JOIN CONTRACT c ON b.contract_id = c.contract_id "
                + "WHERE b.bill_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bill_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("payment_qr_data");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =========================
    // Count Bill for pagination
    // =========================
    public int countManagerBills() {
        String sql = "SELECT COUNT(*) FROM BILL";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
        }
        return 0;
    }

    // =========================
    // insert bill detail()
    // =========================
    public void insertBillDetail(int billId, Integer utilityId, String itemName, String unit, BigDecimal quantity, BigDecimal unitPrice, String type) throws SQLException {
        if (quantity.compareTo(BigDecimal.ZERO) < 0) {
            throw new SQLException("Quantity cannot be negative");
        }
        BigDecimal amount = quantity.multiply(unitPrice);

        String sql = "INSERT INTO BILL_DETAIL "
                + "(bill_id, utility_id, item_name, unit, quantity, unit_price, amount, charge_type) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, billId);

            if (utilityId == null) {
                ps.setNull(2, java.sql.Types.INTEGER);
            } else {
                ps.setInt(2, utilityId);
            }

            ps.setString(3, itemName);
            ps.setString(4, unit);
            ps.setBigDecimal(5, quantity);
            ps.setBigDecimal(6, unitPrice);
            ps.setBigDecimal(7, amount);
            ps.setString(8, type);

            ps.executeUpdate();
        }
    }

    // =========================
    // insert bill
    // =========================
    public int insertBill(int contractId, Date billMonthDate, int oldE, int newE, int oldW, int newW) throws SQLException {

        // Check duplicate bill
        String checkSql = "SELECT bill_id FROM BILL WHERE contract_id = ? AND bill_month = ?";
        try (PreparedStatement check = connection.prepareStatement(checkSql)) {
            check.setInt(1, contractId);
            check.setDate(2, billMonthDate);
            ResultSet rs = check.executeQuery();
            if (rs.next()) {
                throw new SQLException("Bill for this month already exists!");
            }
        }

        String sql = "INSERT INTO BILL (contract_id, bill_month, due_date, [status], note, "
                + "old_electric_number, new_electric_number, old_water_number, new_water_number) "
                + "VALUES (?, ?, DATEADD(DAY, 5, GETDATE()), 'UNPAID', ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, contractId);
            ps.setDate(2, billMonthDate);
            ps.setString(3, " Bill"
                    + billMonthDate.toLocalDate().getMonthValue() + "/"
                    + billMonthDate.toLocalDate().getYear());
            ps.setInt(4, oldE);
            ps.setInt(5, newE);
            ps.setInt(6, oldW);
            ps.setInt(7, newW);

            int affected = ps.executeUpdate();
            if (affected == 0) {
                throw new SQLException("Insert bill failed!");
            }

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            } else {
                throw new SQLException("Failed to get bill ID!");
            }
        }
    }

    // =========================
    //  LẤY CONTRACT_ID CHO GENERATE BILL
    // =========================
    public int getActiveContractByRoom(int roomId) {

        String sql = """
                        SELECT contract_id
                        FROM CONTRACT
                        WHERE room_id = ?
                        AND status = 'ACTIVE'
                    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("contract_id");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // không có contract
    }

    // =========================
    //  LẤY Room price CHO from Contract
    // =========================
    public BigDecimal getRoomPrice(int contractId) {
        String sql = """
                        SELECT monthly_rent
                        FROM CONTRACT 
                        WHERE contract_id = ?
                    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getBigDecimal("monthly_rent");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }

    // =========================
    //  get Utility By Name
    // =========================
    public Utility getUtilityByName(String nameUtilities) {
        String sql = """
                        SELECT *
                        FROM UTILITY
                        WHERE utility_name = ?
                    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, nameUtilities);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Utility u = new Utility();

                u.setUtilityId(rs.getInt("utility_id"));
                u.setUtilityName(rs.getString("utility_name"));
                u.setUnit(rs.getString("unit"));
                u.setStandardPrice(rs.getBigDecimal("standard_price"));
                u.setActive(rs.getBoolean("is_active"));
                u.setStatus(rs.getString("status"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setCreatedAt(rs.getTimestamp("updated_at"));
                return u;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =========================
    //  generate bill
    // =========================
    public int generateBill(int roomId, int month, int year, int oldE, int newE, int oldW, int newW) throws SQLException {

        if (newE < oldE || newW < oldW) {
            throw new SQLException("Invalid meter index!");
        }

        int contractId = getActiveContractByRoom(roomId);

        if (contractId == -1) {
            throw new SQLException("No active contract for this room");
        }
        Date billMonth = Date.valueOf(year + "-" + String.format("%02d", month) + "-01");
        connection.setAutoCommit(false);

        try {

            int billId = insertBill(contractId, billMonth, oldE, newE, oldW, newW);
            BigDecimal roomPrice = getRoomPrice(contractId);
            Utility electric = getUtilityByName("Electric");
            Utility water = getUtilityByName("Water");
            Utility wifi = getUtilityByName("Wifi");
            int electricUsage = newE - oldE;
            int waterUsage = newW - oldW;

            insertBillDetail(billId, null, "Room Rent" + " " + month + "/" + year, "month", BigDecimal.ONE, roomPrice, "RENT");
            insertBillDetail(billId, electric.getUtilityId(), electric.getUtilityName() + " " + month + "/" + year, electric.getUnit(), BigDecimal.valueOf(newE - oldE), electric.getStandardPrice(), "UTILITY");
            insertBillDetail(billId, water.getUtilityId(), water.getUtilityName() + " " + month + "/" + year, water.getUnit(), BigDecimal.valueOf(newW - oldW), electric.getStandardPrice(), "UTILITY");
            insertBillDetail(billId, wifi.getUtilityId(), wifi.getUtilityName() + " " + month + "/" + year, wifi.getUnit(), BigDecimal.ONE, electric.getStandardPrice(), "UTILITY");

            connection.commit();
            return billId;
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    // =========================
    // get Bill detail current for tenant
    // =========================
    public Bill getCurrentBillForTenant(int tenant_id) {
        String sql = "SELECT TOP 1 b.* "
                + "FROM BILL b "
                + "JOIN CONTRACT c ON b.contract_id = c.contract_id "
                + "WHERE c.tenant_id = ? AND c.status = 'ACTIVE' "
                + "ORDER BY b.bill_month DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, tenant_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Bill b = new Bill();
                b.setBillId(rs.getInt("bill_id"));
                b.setContractId(rs.getInt("contract_id"));
                b.setBillMonth(rs.getDate("bill_month"));
                b.setDueDate(rs.getDate("due_date"));
                b.setStatus(rs.getString("status"));
                b.setNote(rs.getString("note"));
                b.setOldElectricNumber(rs.getInt("old_electric_number"));
                b.setNewElectricNumber(rs.getInt("new_electric_number"));
                b.setOldWaterNumber(rs.getInt("old_water_number"));
                b.setNewWaterNumber(rs.getInt("new_water_number"));
                return b;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =========================
    // get total tenant unpaid
    // =========================
    public BigDecimal getTotalTenantUnpaid(int tenant_id) {
        String sql = "SELECT SUM(d.unit_price * d.quantity) AS total_unpaid "
                + "FROM BILL b   "
                + "JOIN CONTRACT c ON b.contract_id = c.contract_id "
                + "JOIN BILL_DETAIL d ON b.bill_id = d.bill_id "
                + "WHERE c.tenant_id = ?  AND b.status = 'UNPAID'";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, tenant_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getBigDecimal(1) != null) {
                return rs.getBigDecimal(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    // =========================
    // GET LASTPAYMENT
    // =========================
    public Payment getLastPaidAmountByTenant(int tenant_id) {
        String sql = "SELECT TOP 1 P.* "
                + "FROM CONTRACT C "
                + "JOIN BILL B ON B.contract_id = C.contract_id "
                + "JOIN PAYMENT P ON P.bill_id = B.bill_id "
                + "WHERE C.tenant_id = ? AND C.status = 'ACTIVE' "
                + "ORDER BY paid_at DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, tenant_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setContractId(rs.getInt("contract_id"));
                p.setBillId(rs.getInt("bill_id"));
                p.setMethod(rs.getString("method"));
                p.setAmount(rs.getBigDecimal("amount"));
                p.setPaidAt(rs.getTimestamp("paid_at"));
                p.setStatus(rs.getString("status"));
                p.setNote(rs.getString("note"));
                return p;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =========================
    // GET Room Number By TenantId
    // =========================
    public String getRoomNumberByTenantId(int tenant_id) {
        String sql = "SELECT R.room_number "
                + "FROM CONTRACT C "
                + "JOIN TENANT T ON T.tenant_id = C.tenant_id "
                + "JOIN ROOM R ON C.room_id = R.room_id "
                + "WHERE C.tenant_id = ? AND C.status = 'ACTIVE'";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, tenant_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("room_number");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =========================
    // GET Bill Detail By Id For Tenant
    // =========================
    public Bill findBillDetailByIdForTenant(int billId, int tenantId) {
        String sql = """
        SELECT b.*
        FROM BILL b
        JOIN CONTRACT c ON b.contract_id = c.contract_id
        WHERE b.bill_id = ?
          AND c.tenant_id = ?
          AND c.status = 'ACTIVE'
    """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, billId);
            ps.setInt(2, tenantId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Bill b = new Bill();
                b.setBillId(rs.getInt("bill_id"));
                b.setContractId(rs.getInt("contract_id"));
                b.setBillMonth(rs.getDate("bill_month"));
                b.setDueDate(rs.getDate("due_date"));
                b.setStatus(rs.getString("status"));
                b.setNote(rs.getString("note"));
                b.setOldElectricNumber(rs.getInt("old_electric_number"));
                b.setNewElectricNumber(rs.getInt("new_electric_number"));
                b.setOldWaterNumber(rs.getInt("old_water_number"));
                b.setNewWaterNumber(rs.getInt("new_water_number"));
                return b;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // =========================
    // GET List Bill For Tenant
    // =========================
    public List<ManagerBillRowDTO> listBillForTenant(int tenant_id) {
        List<ManagerBillRowDTO> list = new ArrayList<>();
        String sql = "SELECT b.bill_id, r.room_number, b.bill_month, "
                + "       t.full_name AS tenant_name, bl.block_name, "
                + "       b.due_date, "
                + "       COALESCE(SUM(d.unit_price * d.quantity), 0) AS total_amount, "
                + "       b.status, "
                + "       p.status AS payment_status "
                + "FROM BILL b "
                + "JOIN CONTRACT c ON b.contract_id = c.contract_id "
                + "JOIN TENANT t ON c.tenant_id = t.tenant_id "
                + "JOIN ROOM r ON c.room_id = r.room_id "
                + "JOIN BLOCK bl ON r.block_id = bl.block_id "
                + "LEFT JOIN BILL_DETAIL d ON b.bill_id = d.bill_id "
                + "LEFT JOIN PAYMENT p ON p.bill_id = b.bill_id "
                + "WHERE c.tenant_id = ? "
                + "GROUP BY b.bill_id, r.room_number, b.bill_month, "
                + "         t.full_name, bl.block_name, "
                + "         b.due_date, b.status, p.status "
                + "ORDER BY CASE WHEN b.status = 'UNPAID' THEN 0 ELSE 1 END ASC, b.bill_month DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, tenant_id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ManagerBillRowDTO dto = new ManagerBillRowDTO();
                dto.setBillId(rs.getInt("bill_id"));
                dto.setRoomNumber(rs.getString("room_number"));
                dto.setMonth(rs.getDate("bill_month"));
                dto.setTenantName(rs.getString("tenant_name"));
                dto.setBlockName(rs.getString("block_name"));
                dto.setDueDate(rs.getDate("due_date"));
                dto.setTotalAmount(rs.getBigDecimal("total_amount"));
                dto.setStatus(rs.getString("status"));
                dto.setPaymentStatus(rs.getString("payment_status"));
                list.add(dto);
            }
        } catch (Exception e) {

            e.printStackTrace();
        }
        return list;
    }

    public static void main(String[] args) {
        BillDAO bd = new BillDAO();
        System.out.println(bd.getQRFromContractByBillId(1));
    }

}
