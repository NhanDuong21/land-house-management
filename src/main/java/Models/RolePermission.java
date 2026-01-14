package Models;

import java.time.LocalDateTime;

public class RolePermission {

    private int roleId;
    private int permissionId;
    private LocalDateTime assignedDate;
    private boolean isEnabled;

    public RolePermission() {
    }

    public RolePermission(int roleId, int permissionId, LocalDateTime assignedDate, boolean isEnabled) {
        this.roleId = roleId;
        this.permissionId = permissionId;
        this.assignedDate = assignedDate;
        this.isEnabled = isEnabled;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public int getPermissionId() {
        return permissionId;
    }

    public void setPermissionId(int permissionId) {
        this.permissionId = permissionId;
    }

    public LocalDateTime getAssignedDate() {
        return assignedDate;
    }

    public void setAssignedDate(LocalDateTime assignedDate) {
        this.assignedDate = assignedDate;
    }

    public boolean isEnabled() {
        return isEnabled;
    }

    public void setEnabled(boolean isEnabled) {
        this.isEnabled = isEnabled;
    }

}
