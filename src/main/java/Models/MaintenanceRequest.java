package Models;

import java.sql.Date;

public class MaintenanceRequest {

    private int requestId;
    private int tenantId;
    private Integer managerId;
    private int roomId;
    private Date requestDate;
    private String description;
    private String status;

    public MaintenanceRequest() {
    }

    public MaintenanceRequest(int requestId, int tenantId, Integer managerId,
            int roomId, Date requestDate,
            String description, String status) {
        this.requestId = requestId;
        this.tenantId = tenantId;
        this.managerId = managerId;
        this.roomId = roomId;
        this.requestDate = requestDate;
        this.description = description;
        this.status = status;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getTenantId() {
        return tenantId;
    }

    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }

    public Integer getManagerId() {
        return managerId;
    }

    public void setManagerId(Integer managerId) {
        this.managerId = managerId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public Date getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Date requestDate) {
        this.requestDate = requestDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
