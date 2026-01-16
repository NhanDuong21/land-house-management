package Models;

import java.time.LocalDateTime;

public class MaintenanceRequest {

    private int requestId;
    private int roomId;
    private int tenantId;
    private Integer handledByStaffId;
    private String description;
    private String imageUrl;
    private byte status;              // 0 to 3
    private LocalDateTime createdAt;
    private LocalDateTime completedAt;

    public MaintenanceRequest() {
    }

    public MaintenanceRequest(int requestId, int roomId, int tenantId, Integer handledByStaffId, String description,
            String imageUrl, byte status, LocalDateTime createdAt, LocalDateTime completedAt) {
        this.requestId = requestId;
        this.roomId = roomId;
        this.tenantId = tenantId;
        this.handledByStaffId = handledByStaffId;
        this.description = description;
        this.imageUrl = imageUrl;
        this.status = status;
        this.createdAt = createdAt;
        this.completedAt = completedAt;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
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

    public Integer getHandledByStaffId() {
        return handledByStaffId;
    }

    public void setHandledByStaffId(Integer handledByStaffId) {
        this.handledByStaffId = handledByStaffId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public byte getStatus() {
        return status;
    }

    public void setStatus(byte status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }

}
