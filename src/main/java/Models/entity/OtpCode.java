package Models.entity;

import java.sql.Timestamp;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-05
 */
public class OtpCode {

    private int otpId;
    private int tenantId;
    private String purpose;    // FIRST_LOGIN/RESET_PASSWORD...
    private String receiver;   // email/phone
    private String otpHash;    // hashed otp
    private Timestamp expiresAt;
    private Timestamp usedAt;  // nullable

    public OtpCode() {
    }

    public OtpCode(int otpId, int tenantId, String purpose, String receiver, String otpHash, Timestamp expiresAt,
            Timestamp usedAt) {
        this.otpId = otpId;
        this.tenantId = tenantId;
        this.purpose = purpose;
        this.receiver = receiver;
        this.otpHash = otpHash;
        this.expiresAt = expiresAt;
        this.usedAt = usedAt;
    }

    public int getOtpId() {
        return otpId;
    }

    public void setOtpId(int otpId) {
        this.otpId = otpId;
    }

    public int getTenantId() {
        return tenantId;
    }

    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public String getReceiver() {
        return receiver;
    }

    public void setReceiver(String receiver) {
        this.receiver = receiver;
    }

    public String getOtpHash() {
        return otpHash;
    }

    public void setOtpHash(String otpHash) {
        this.otpHash = otpHash;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    public Timestamp getUsedAt() {
        return usedAt;
    }

    public void setUsedAt(Timestamp usedAt) {
        this.usedAt = usedAt;
    }

}
