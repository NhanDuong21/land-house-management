package Models.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-05
 */
public class Utility {

    private int utilityId;
    private String utilityName;
    private String unit;
    private BigDecimal standardPrice;
    private boolean isActive;
    private String status; // ACTIVE/INACTIVE
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Utility() {
    }

    public Utility(int utilityId, String utilityName, String unit, BigDecimal standardPrice, boolean isActive,
            String status, Timestamp createdAt, Timestamp updatedAt) {
        this.utilityId = utilityId;
        this.utilityName = utilityName;
        this.unit = unit;
        this.standardPrice = standardPrice;
        this.isActive = isActive;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getUtilityId() {
        return utilityId;
    }

    public void setUtilityId(int utilityId) {
        this.utilityId = utilityId;
    }

    public String getUtilityName() {
        return utilityName;
    }

    public void setUtilityName(String utilityName) {
        this.utilityName = utilityName;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public BigDecimal getStandardPrice() {
        return standardPrice;
    }

    public void setStandardPrice(BigDecimal standardPrice) {
        this.standardPrice = standardPrice;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

}
