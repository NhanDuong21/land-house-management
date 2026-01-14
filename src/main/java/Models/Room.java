package Models;

public class Room {

    private Integer roomId;
    private int houseId;
    private String roomNumber;
    private double area;        // m2
    private int floor;
    private int maxTenants;
    private long price;         // VND (vd 3500000)
    private String roomImage; // nullable -> bạn có thể để String bình thường
    private boolean isMezzanine;
    private String description;
    private int status;         // 0..3

    public Room() {
    }

    public Room(Integer roomId, int houseId, String roomNumber, double area, int floor, int maxTenants, long price,
            String roomImage, boolean isMezzanine, String description, int status) {
        this.roomId = roomId;
        this.houseId = houseId;
        this.roomNumber = roomNumber;
        this.area = area;
        this.floor = floor;
        this.maxTenants = maxTenants;
        this.price = price;
        this.roomImage = roomImage;
        this.isMezzanine = isMezzanine;
        this.description = description;
        this.status = status;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
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

    public double getArea() {
        return area;
    }

    public void setArea(double area) {
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

    public long getPrice() {
        return price;
    }

    public void setPrice(long price) {
        this.price = price;
    }

    public String getRoomImage() {
        return roomImage;
    }

    public void setRoomImage(String roomImage) {
        this.roomImage = roomImage;
    }

    public boolean isMezzanine() {
        return isMezzanine;
    }

    public void setMezzanine(boolean isMezzanine) {
        this.isMezzanine = isMezzanine;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

}
