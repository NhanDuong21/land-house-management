package Models.entity;

import java.math.BigDecimal;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-01-16
 */
public class Utility {

    private int utilityId;
    private String utilityName;
    private String unit;
    private BigDecimal standardPrice;
    private byte status; // 0 1 2

    public Utility() {
    }

    public Utility(int utilityId, String utilityName, String unit, BigDecimal standardPrice, byte status) {
        this.utilityId = utilityId;
        this.utilityName = utilityName;
        this.unit = unit;
        this.standardPrice = standardPrice;
        this.status = status;
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

    public byte getStatus() {
        return status;
    }

    public void setStatus(byte status) {
        this.status = status;
    }

}
