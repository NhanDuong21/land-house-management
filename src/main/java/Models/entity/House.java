package Models.entity;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-01-16
 */
public class House {

    private int houseId;
    private String houseName;
    private String city;
    private String address;
    private String description;
    private byte status;
    private int numOfRooms;

    public House() {
    }

    public House(int houseId, String houseName, String city, String address, String description, byte status,
            int numOfRooms) {
        this.houseId = houseId;
        this.houseName = houseName;
        this.city = city;
        this.address = address;
        this.description = description;
        this.status = status;
        this.numOfRooms = numOfRooms;
    }

    public int getHouseId() {
        return houseId;
    }

    public void setHouseId(int houseId) {
        this.houseId = houseId;
    }

    public String getHouseName() {
        return houseName;
    }

    public void setHouseName(String houseName) {
        this.houseName = houseName;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public byte getStatus() {
        return status;
    }

    public void setStatus(byte status) {
        this.status = status;
    }

    public int getNumOfRooms() {
        return numOfRooms;
    }

    public void setNumOfRooms(int numOfRooms) {
        this.numOfRooms = numOfRooms;
    }

}
