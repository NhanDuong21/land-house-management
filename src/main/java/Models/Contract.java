package Models;

import java.sql.Date;

public class Contract {

    private int contractId;
    private int managerId;
    private int tenantId;
    private int roomId;
    private Date startDate;
    private Date endDate;
    private double deposit;
    private String status;

    public Contract() {
    }

    public Contract(int contractId, int managerId, int tenantId, int roomId,
            Date startDate, Date endDate, double deposit, String status) {
        this.contractId = contractId;
        this.managerId = managerId;
        this.tenantId = tenantId;
        this.roomId = roomId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.deposit = deposit;
        this.status = status;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public int getTenantId() {
        return tenantId;
    }

    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
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

    public double getDeposit() {
        return deposit;
    }

    public void setDeposit(double deposit) {
        this.deposit = deposit;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
