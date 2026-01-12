package Models;

/**
 * Author: Duong Thien Nhan - CE190741 Created on: 2026-01-12
 */
public class House {

    private int houseId;
    private String houseName;
    private String address;
    private String city;
    private String description;
    private String status;

    public House() {
    }

    public House(int houseId, String houseName, String address, String city, String description, String status) {
        this.houseId = houseId;
        this.houseName = houseName;
        this.address = address;
        this.city = city;
        this.description = description;
        this.status = status;
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

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}
