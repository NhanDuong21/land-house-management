package Models.entity;

import java.math.BigDecimal;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-05
 */
public class Room {

    private int roomId;
    private int blockId;
    private String roomNumber;
    private BigDecimal area;
    private BigDecimal price;
    private String status;        // AVAILABLE/OCCUPIED/MAINTENANCE/INACTIVE
    private Integer floor;
    private Integer maxTenants;
    private boolean airConditioning;
    private boolean isMezzanine;
    private String roomImage;
    private String description;

    public Room() {
    }

    public Room(int roomId, int blockId, String roomNumber, BigDecimal area, BigDecimal price, String status,
            Integer floor, Integer maxTenants, boolean airConditioning, boolean isMezzanine, String roomImage, String description) {
        this.roomId = roomId;
        this.blockId = blockId;
        this.roomNumber = roomNumber;
        this.area = area;
        this.price = price;
        this.status = status;
        this.floor = floor;
        this.maxTenants = maxTenants;
        this.airConditioning = airConditioning;
        this.isMezzanine = isMezzanine;
        this.roomImage = roomImage;
        this.description = description;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getBlockId() {
        return blockId;
    }

    public void setBlockId(int blockId) {
        this.blockId = blockId;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public BigDecimal getArea() {
        return area;
    }

    public void setArea(BigDecimal area) {
        this.area = area;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getFloor() {
        return floor;
    }

    public void setFloor(Integer floor) {
        this.floor = floor;
    }

    public Integer getMaxTenants() {
        return maxTenants;
    }

    public void setMaxTenants(Integer maxTenants) {
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isAirConditioning() {
        return airConditioning;
    }

    public void setAirConditioning(boolean airConditioning) {
        this.airConditioning = airConditioning;
    }

}
