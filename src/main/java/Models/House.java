package Models;

public class House {

    private Integer houseId;
    private String houseName;
    private String city; // nullable
    private String address;
    private Integer numOfRooms; // nullable
    private String description; // nullable
    private int status; // 0..3

    public House() {
    }

    public House(Integer houseId, String houseName, String city, String address, Integer numOfRooms, String description,
            int status) {
        this.houseId = houseId;
        this.houseName = houseName;
        this.city = city;
        this.address = address;
        this.numOfRooms = numOfRooms;
        this.description = description;
        this.status = status;
    }

    public Integer getHouseId() {
        return houseId;
    }

    public void setHouseId(Integer houseId) {
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

    public Integer getNumOfRooms() {
        return numOfRooms;
    }

    public void setNumOfRooms(Integer numOfRooms) {
        this.numOfRooms = numOfRooms;
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
