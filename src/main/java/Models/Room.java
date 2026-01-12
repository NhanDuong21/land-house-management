package Models;

/**
 * Author: Duong Thien Nhan - CE190741 Created on: 2026-01-12  
 */
public class Room {

    private int roomId;
    private int houseId;
    private String roomNumber;
    private double price;
    private String status;
    private String roomImage;
    private String description;

    public Room() {
    }

    public Room(int roomId, int houseId, String roomNumber, double price, String status, String roomImage,
            String description) {
        this.roomId = roomId;
        this.houseId = houseId;
        this.roomNumber = roomNumber;
        this.price = price;
        this.status = status;
        this.roomImage = roomImage;
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

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRoomImage() {
        return roomImage;
    }

    public void setRoomImage(String roomImage) {
        this.roomImage = roomImage;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

}
