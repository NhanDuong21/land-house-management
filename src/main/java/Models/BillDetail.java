package Models;

public class BillDetail {

    private Integer billDetailId;
    private int billId;
    private int utilityId;
    private Integer oldIndex; // nullable
    private Integer newIndex; // nullable
    private double quantity;  // DECIMAL(12,3)
    private long unitPrice;

    public BillDetail() {
    }

    public BillDetail(Integer billDetailId, int billId, int utilityId, Integer oldIndex, Integer newIndex,
            double quantity, long unitPrice) {
        this.billDetailId = billDetailId;
        this.billId = billId;
        this.utilityId = utilityId;
        this.oldIndex = oldIndex;
        this.newIndex = newIndex;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public Integer getBillDetailId() {
        return billDetailId;
    }

    public void setBillDetailId(Integer billDetailId) {
        this.billDetailId = billDetailId;
    }

    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }

    public int getUtilityId() {
        return utilityId;
    }

    public void setUtilityId(int utilityId) {
        this.utilityId = utilityId;
    }

    public Integer getOldIndex() {
        return oldIndex;
    }

    public void setOldIndex(Integer oldIndex) {
        this.oldIndex = oldIndex;
    }

    public Integer getNewIndex() {
        return newIndex;
    }

    public void setNewIndex(Integer newIndex) {
        this.newIndex = newIndex;
    }

    public double getQuantity() {
        return quantity;
    }

    public void setQuantity(double quantity) {
        this.quantity = quantity;
    }

    public long getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(long unitPrice) {
        this.unitPrice = unitPrice;
    }

}
