package Models;

import java.sql.Date;

public class RoomUtility {

    private int roomUtilityId;
    private int roomId;
    private int utilityId;
    private double initialIndex;
    private Date startDate;
    private Date endDate;

    public RoomUtility() {
    }

    public RoomUtility(int roomUtilityId, int roomId, int utilityId,
            double initialIndex, Date startDate, Date endDate) {
        this.roomUtilityId = roomUtilityId;
        this.roomId = roomId;
        this.utilityId = utilityId;
        this.initialIndex = initialIndex;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public int getRoomUtilityId() {
        return roomUtilityId;
    }

    public void setRoomUtilityId(int roomUtilityId) {
        this.roomUtilityId = roomUtilityId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getUtilityId() {
        return utilityId;
    }

    public void setUtilityId(int utilityId) {
        this.utilityId = utilityId;
    }

    public double getInitialIndex() {
        return initialIndex;
    }

    public void setInitialIndex(double initialIndex) {
        this.initialIndex = initialIndex;
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
}
