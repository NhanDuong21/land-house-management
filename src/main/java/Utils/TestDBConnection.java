package Utils;

import java.sql.ResultSet;
import java.sql.Statement;

public class TestDBConnection {
    public static void main(String[] args) {
        try {
            DBContext db = new DBContext();
            Statement stmt = db.connection.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT 1");

            if (rs.next()) {
                System.out.println("Ket noi db thanh cong");
            }
        } catch (Exception e) {
            System.out.println("Im lang ma fix di co be");
            e.printStackTrace();
        }
    }
}
