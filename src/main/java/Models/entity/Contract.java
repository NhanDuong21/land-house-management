package Models.entity;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-05
 */
public class Contract {

    private int contractId;
    private int roomId;
    private int tenantId;
    private int createdByStaffId;

    private Date startDate;
    private Date endDate; // nullable

    private BigDecimal monthlyRent;
    private BigDecimal deposit;
    private String paymentQrData;

    private String status; // PENDING/ACTIVE/ENDED/CANCELLED
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private String roomNumber;
    private String blockName;

    public Contract() {
    }

    public Contract(int contractId, int roomId, int tenantId, int createdByStaffId, Date startDate, Date endDate,
            BigDecimal monthlyRent, BigDecimal deposit, String paymentQrData, String status, Timestamp createdAt,
            Timestamp updatedAt, String roomNumber, String blockName) {
        this.contractId = contractId;
        this.roomId = roomId;
        this.tenantId = tenantId;
        this.createdByStaffId = createdByStaffId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.monthlyRent = monthlyRent;
        this.deposit = deposit;
        this.paymentQrData = paymentQrData;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.roomNumber = roomNumber;
        this.blockName = blockName;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getTenantId() {
        return tenantId;
    }

    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }

    public int getCreatedByStaffId() {
        return createdByStaffId;
    }

    public void setCreatedByStaffId(int createdByStaffId) {
        this.createdByStaffId = createdByStaffId;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public BigDecimal getMonthlyRent() {
        return monthlyRent;
    }

    public void setMonthlyRent(BigDecimal monthlyRent) {
        this.monthlyRent = monthlyRent;
    }

    public BigDecimal getDeposit() {
        return deposit;
    }

    public void setDeposit(BigDecimal deposit) {
        this.deposit = deposit;
    }

    public String getPaymentQrData() {
        return paymentQrData;
    }

    public void setPaymentQrData(String paymentQrData) {
        this.paymentQrData = paymentQrData;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getBlockName() {
        return blockName;
    }

    public void setBlockName(String blockName) {
        this.blockName = blockName;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

}
