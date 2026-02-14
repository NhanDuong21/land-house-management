package Models.dto;

/**
 * Description: DTO debug confirm contract of manager
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-11
 */
public class TxResult {

    private boolean ok;
    private String code;   // e.g. NOT_FOUND, NOT_PENDING, FAIL_ROOM...
    private String detail; // optional

    public TxResult() {
    }

    public TxResult(boolean ok, String code, String detail) {
        this.ok = ok;
        this.code = code;
        this.detail = detail;
    }

    public boolean isOk() {
        return ok;
    }

    public void setOk(boolean ok) {
        this.ok = ok;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }
}
