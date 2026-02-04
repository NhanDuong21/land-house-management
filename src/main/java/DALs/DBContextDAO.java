package DALs;

import java.sql.Connection;

import Utils.DBContext;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-05
 */
public class DBContextDAO extends DBContext {

    public Connection getConnection() {
        return connection;
    }
}
