package Models;

public class BillDetail {

    private int billDetailId;
    private int billId;
    private int utilityId;
    private Double oldIndex;
    private Double newIndex;
    private double quantity;
    private double unitPrice;
    private double amount;

    public BillDetail() {
    }

    public BillDetail(int billDetailId, int billId, int utilityId,
            Double oldIndex, Double newIndex,
            double quantity, double unitPrice, double amount) {
        this.billDetailId = billDetailId;
        this.billId = billId;
        this.utilityId = utilityId;
        this.oldIndex = oldIndex;
        this.newIndex = newIndex;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.amount = amount;
    }

    public int getBillDetailId() {
        return billDetailId;
    }

    public void setBillDetailId(int billDetailId) {
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

    public Double getOldIndex() {
        return oldIndex;
    }

    public void setOldIndex(Double oldIndex) {
        this.oldIndex = oldIndex;
    }

    public Double getNewIndex() {
        return newIndex;
    }

    public void setNewIndex(Double newIndex) {
        this.newIndex = newIndex;
    }

    public double getQuantity() {
        return quantity;
    }

    public void setQuantity(double quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }
}
