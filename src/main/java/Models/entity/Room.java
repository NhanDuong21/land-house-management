package Models.entity;

import java.math.BigDecimal;

public class Room {

    private int roomId;
    private int houseId;
    private String roomNumber;
    private BigDecimal price;
    private BigDecimal area;
    private int floor;
    private int maxTenants;
    private boolean isMezzanine;
    private String roomImage;
    private byte status; // 0-3
    private String description;

    public Room() {
    }

    public Room(int roomId, int houseId, String roomNumber, BigDecimal price, BigDecimal area, int floor,
            int maxTenants, boolean isMezzanine, String roomImage, byte status, String description) {
        this.roomId = roomId;
        this.houseId = houseId;
        this.roomNumber = roomNumber;
        this.price = price;
        this.area = area;
        this.floor = floor;
        this.maxTenants = maxTenants;
        this.isMezzanine = isMezzanine;
        this.roomImage = roomImage;
        this.status = status;
        this.description = description;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getHouseId() {
        return houseId;
    }

    public void setHouseId(int houseId) {
        this.houseId = houseId;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getArea() {
        return area;
    }

    public void setArea(BigDecimal area) {
        this.area = area;
    }

    public int getFloor() {
        return floor;
    }

    public void setFloor(int floor) {
        this.floor = floor;
    }

    public int getMaxTenants() {
        return maxTenants;
    }

    public void setMaxTenants(int maxTenants) {
        this.maxTenants = maxTenants;
    }

    public boolean isMezzanine() {
        return isMezzanine;
    }

    public void setMezzanine(boolean isMezzanine) {
        this.isMezzanine = isMezzanine;
    }

    public String getRoomImage() {
        return roomImage;
    }

    public void setRoomImage(String roomImage) {
        this.roomImage = roomImage;
    }

    public byte getStatus() {
        return status;
    }

    public void setStatus(byte status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

}
