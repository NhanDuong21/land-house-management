package Models;

public class Utility {

    private Integer utilityId;
    private String utilityName;
    private String unit;
    private long standardPrice; //vnd

    public Utility() {
    }

    public Utility(Integer utilityId, String utilityName, String unit, long standardPrice) {
        this.utilityId = utilityId;
        this.utilityName = utilityName;
        this.unit = unit;
        this.standardPrice = standardPrice;
    }

    public Integer getUtilityId() {
        return utilityId;
    }

    public void setUtilityId(Integer utilityId) {
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

    public long getStandardPrice() {
        return standardPrice;
    }

    public void setStandardPrice(long standardPrice) {
        this.standardPrice = standardPrice;
    }

}
