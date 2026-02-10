package Services.auth;

import DALs.auth.OtpCodeDAO;
import Utils.mail.MailUtil;
import Utils.security.HashUtil;
import Utils.security.OtpUtil;

import java.time.LocalDateTime;
/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-11
 */
public class OtpService {

    private final OtpCodeDAO otpDAO = new OtpCodeDAO();

    public boolean sendFirstLoginOtp(int tenantId, String tenantEmail) {
        String otpPlain = OtpUtil.generate6Digits();
        String otpHash = HashUtil.md5(otpPlain); 

        otpDAO.invalidateOldOtps(tenantId, "FIRST_LOGIN");

        int otpId = otpDAO.insertOtp(
                tenantId,
                "FIRST_LOGIN",
                tenantEmail,
                otpHash,
                LocalDateTime.now().plusMinutes(10)
        );

        if (otpId <= 0) return false;

        // gửi mail
        return MailUtil.sendOtp(tenantEmail, otpPlain);
    }
}
