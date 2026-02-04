package Models.entity;

import java.sql.Timestamp;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-05
 */
public class MaintenanceRequest {

    private int requestId;
    private int tenantId;
    private int roomId;

    private String issueCategory;  // ELECTRIC/WATER/OTHER
    private Integer utilityId;     // nullable (OTHER = null)

    private Integer handledByStaffId; // nullable
    private String description;
    private String imageUrl;

    private String status;         // PENDING/IN_PROGRESS/DONE/CANCELLED
    private Timestamp createdAt;
    private Timestamp completedAt; // nullable

    public MaintenanceRequest() {
    }

    public MaintenanceRequest(int requestId, int tenantId, int roomId, String issueCategory, Integer utilityId,
            Integer handledByStaffId, String description, String imageUrl, String status, Timestamp createdAt,
            Timestamp completedAt) {
        this.requestId = requestId;
        this.tenantId = tenantId;
        this.roomId = roomId;
        this.issueCategory = issueCategory;
        this.utilityId = utilityId;
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

    public String getIssueCategory() {
        return issueCategory;
    }

    public void setIssueCategory(String issueCategory) {
        this.issueCategory = issueCategory;
    }

    public Integer getUtilityId() {
        return utilityId;
    }

    public void setUtilityId(Integer utilityId) {
        this.utilityId = utilityId;
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

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

}
