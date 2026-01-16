package Models.authentication;

/**
 * Description: save infor login in session
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-01-16
 */
public class AuthUser {

    private int id;
    private String fullName;
    private String role;

    public AuthUser() {
    }

    public AuthUser(int id, String fullName, String role) {
        this.id = id;
        this.fullName = fullName;
        this.role = role;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

}
