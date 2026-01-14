package Models;

import java.time.LocalDate;

public class RoomUtility {

    private int roomId;
    private int utilityId;
    private LocalDate startDate;
    private long customPrice;
    private String description;

    public RoomUtility() {
    }

    public RoomUtility(int roomId, int utilityId, LocalDate startDate, long customPrice, String description) {
        this.roomId = roomId;
        this.utilityId = utilityId;
        this.startDate = startDate;
        this.customPrice = customPrice;
        this.description = description;
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

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public long getCustomPrice() {
        return customPrice;
    }

    public void setCustomPrice(long customPrice) {
        this.customPrice = customPrice;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

}
