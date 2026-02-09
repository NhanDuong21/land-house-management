/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models.dto;

/**
 *
 * @author truon
 */
public class RoomUtilityDTO {

    private int roomId;
    private String roomNumber;
    private String tenantName;

    public RoomUtilityDTO() {
    }

    public RoomUtilityDTO(int roomId, String roomNumber, String tenantName) {
        this.roomId = roomId;
        this.roomNumber = roomNumber;
        this.tenantName = tenantName;
    }
    
    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public String getTenantName() {
        return tenantName;
    }

    public void setTenantName(String tenantName) {
        this.tenantName = tenantName;
    }   
}
