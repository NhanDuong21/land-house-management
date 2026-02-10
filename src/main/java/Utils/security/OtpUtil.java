package Utils.security;

import java.security.SecureRandom;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-11
 */
public class OtpUtil {
    
    private static final SecureRandom random = new SecureRandom();

    public static String generate6Digits() {
        int n = 100000 + random.nextInt(900000);
        return String.valueOf(n);
    }  
}
