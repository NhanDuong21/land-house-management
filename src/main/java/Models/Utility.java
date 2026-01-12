package Models;

public class Utility {

    private int utilityId;
    private String utilityName;
    private double utilityPrice;
    private String unit;

    public Utility() {
    }

    public Utility(int utilityId, String utilityName, double utilityPrice, String unit) {
        this.utilityId = utilityId;
        this.utilityName = utilityName;
        this.utilityPrice = utilityPrice;
        this.unit = unit;
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

    public double getUtilityPrice() {
        return utilityPrice;
    }

    public void setUtilityPrice(double utilityPrice) {
        this.utilityPrice = utilityPrice;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

}
