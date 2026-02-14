package Models.dto;

import java.math.BigDecimal;
import java.sql.Date;

/**
 * Description: DTO displayed list contract
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-11
 */
public class ManagerContractRowDTO {

    private int contractId;
    private String roomNumber;
    private String tenantName;
    private Date startDate;
    private BigDecimal monthlyRent;
    private String status;

    public ManagerContractRowDTO() {
    }

    public ManagerContractRowDTO(int contractId, String roomNumber, String tenantName, Date startDate,
            BigDecimal monthlyRent, String status) {
        this.contractId = contractId;
        this.roomNumber = roomNumber;
        this.tenantName = tenantName;
        this.startDate = startDate;
        this.monthlyRent = monthlyRent;
        this.status = status;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public String getTenantName() {
        return tenantName;
    }

    public void setTenantName(String tenantName) {
        this.tenantName = tenantName;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public BigDecimal getMonthlyRent() {
        return monthlyRent;
    }

    public void setMonthlyRent(BigDecimal monthlyRent) {
        this.monthlyRent = monthlyRent;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // display contract id 000001 match figma
    public String getDisplayId() {
        return String.format("%06d", contractId);
    }
}
