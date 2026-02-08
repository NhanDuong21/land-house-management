package Utils.config;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.Writer;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Properties;

import Models.common.ContactInfo;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-09
 */
public class ContactConfigUtil {

    // đọc properties -> object
    public static ContactInfo load(String path) throws IOException {
        Properties p = new Properties();
        try (InputStream in = Files.newInputStream(Paths.get(path)); Reader r = new InputStreamReader(in, StandardCharsets.UTF_8)) {
            p.load(r);
        }

        ContactInfo c = new ContactInfo();
        c.companyName = p.getProperty("companyName", "RentHouse");
        c.managerName = p.getProperty("managerName", "Manager");
        c.phone = p.getProperty("phone", "");
        c.email = p.getProperty("email", "");
        c.address = p.getProperty("address", "");
        c.workingHours = p.getProperty("workingHours", "");
        return c;
    }

    // ghi object -> properties (ghi an toàn: temp rồi replace)
    public static void save(String path, ContactInfo c) throws IOException {
        Properties p = new Properties();
        p.setProperty("companyName", nullToEmpty(c.companyName));
        p.setProperty("managerName", nullToEmpty(c.managerName));
        p.setProperty("phone", nullToEmpty(c.phone));
        p.setProperty("email", nullToEmpty(c.email));
        p.setProperty("address", nullToEmpty(c.address));
        p.setProperty("workingHours", nullToEmpty(c.workingHours));

        Path target = Paths.get(path);
        Files.createDirectories(target.getParent());

        Path tmp = Paths.get(path + ".tmp");

        try (OutputStream out = Files.newOutputStream(tmp); Writer w = new OutputStreamWriter(out, StandardCharsets.UTF_8)) {
            p.store(w, "Contact Info");
        }

        Files.move(tmp, target, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.ATOMIC_MOVE);
    }

    private static String nullToEmpty(String s) {
        return s == null ? "" : s.trim();
    }
}
