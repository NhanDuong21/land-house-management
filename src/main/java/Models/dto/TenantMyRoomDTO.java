package Models.dto;

import java.math.BigDecimal;
import java.util.List;

import Models.entity.RoomImage;

/**
 * Description vi nhung du lieu cua 4 table
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-28
 */
public class TenantMyRoomDTO {

    private int contractId;
    private int roomId;
    private int blockId;
    private String blockName;

    private String roomNumber;
    private BigDecimal area;
    private BigDecimal price;
    private String roomStatus; // AVAILABLE/OCCUPIED...
    private Integer floor;
    private Integer maxTenants;
    private boolean mezzanine;
    private boolean airConditioning;
    private String description;

    private String coverImage;
    private List<RoomImage> images;

    public TenantMyRoomDTO() {
    }

    public TenantMyRoomDTO(int contractId, int roomId, int blockId, String blockName, String roomNumber,
            BigDecimal area, BigDecimal price, String roomStatus, Integer floor, Integer maxTenants, boolean mezzanine,
            boolean airConditioning, String description, String coverImage, List<RoomImage> images) {
        this.contractId = contractId;
        this.roomId = roomId;
        this.blockId = blockId;
        this.blockName = blockName;
        this.roomNumber = roomNumber;
        this.area = area;
        this.price = price;
        this.roomStatus = roomStatus;
        this.floor = floor;
        this.maxTenants = maxTenants;
        this.mezzanine = mezzanine;
        this.airConditioning = airConditioning;
        this.description = description;
        this.coverImage = coverImage;
        this.images = images;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
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

    public String getBlockName() {
        return blockName;
    }

    public void setBlockName(String blockName) {
        this.blockName = blockName;
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

    public String getRoomStatus() {
        return roomStatus;
    }

    public void setRoomStatus(String roomStatus) {
        this.roomStatus = roomStatus;
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
        return mezzanine;
    }

    public void setMezzanine(boolean mezzanine) {
        this.mezzanine = mezzanine;
    }

    public boolean isAirConditioning() {
        return airConditioning;
    }

    public void setAirConditioning(boolean airConditioning) {
        this.airConditioning = airConditioning;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCoverImage() {
        return coverImage;
    }

    public void setCoverImage(String coverImage) {
        this.coverImage = coverImage;
    }

    public List<RoomImage> getImages() {
        return images;
    }

    public void setImages(List<RoomImage> images) {
        this.images = images;
    }

}
