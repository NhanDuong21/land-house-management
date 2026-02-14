package Models.common;

/**
 * Description: class nhỏ để trả kết quả created contract
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-12
 */
public class ServiceResult {

    private final boolean ok;
    private final String message;

    public ServiceResult(boolean ok, String message) {
        this.ok = ok;
        this.message = message;
    }

    public static ServiceResult ok(String msg) {
        return new ServiceResult(true, msg);
    }

    public static ServiceResult fail(String msg) {
        return new ServiceResult(false, msg);
    }

    public boolean isOk() {
        return ok;
    }

    public String getMessage() {
        return message;
    }
}
