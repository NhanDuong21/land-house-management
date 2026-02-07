package Utils.security;

import java.security.SecureRandom;
import java.util.Base64;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-07
 */
public class TokenUtil {

    public static String generateToken() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[32];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
