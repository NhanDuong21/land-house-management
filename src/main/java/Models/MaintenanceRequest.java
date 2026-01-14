package Models;

import java.time.LocalDateTime;

public class MaintenanceRequest {

    private Integer requestId;
    private int roomId;
    private int submittedByProfileId;
    private Integer handledByAccountId; // nullable
    private String description;
    private String imageUrl; // nullable
    private int status; // 0..3
    private LocalDateTime createdAt;
    private LocalDateTime completedAt; // nullable

    public MaintenanceRequest() {
    }

    public MaintenanceRequest(Integer requestId, int roomId, int submittedByProfileId, Integer handledByAccountId,
            String description, String imageUrl, int status, LocalDateTime createdAt, LocalDateTime completedAt) {
        this.requestId = requestId;
        this.roomId = roomId;
        this.submittedByProfileId = submittedByProfileId;
        this.handledByAccountId = handledByAccountId;
        this.description = description;
        this.imageUrl = imageUrl;
        this.status = status;
        this.createdAt = createdAt;
        this.completedAt = completedAt;
    }

    public Integer getRequestId() {
        return requestId;
    }

    public void setRequestId(Integer requestId) {
        this.requestId = requestId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getSubmittedByProfileId() {
        return submittedByProfileId;
    }

    public void setSubmittedByProfileId(int submittedByProfileId) {
        this.submittedByProfileId = submittedByProfileId;
    }

    public Integer getHandledByAccountId() {
        return handledByAccountId;
    }

    public void setHandledByAccountId(Integer handledByAccountId) {
        this.handledByAccountId = handledByAccountId;
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

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
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
