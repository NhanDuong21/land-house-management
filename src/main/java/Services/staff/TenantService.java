/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Services.staff;


import DALs.auth.StaffDAO;
import Models.entity.Tenant;
import java.util.List;

/**
 *
 * @author ADMIN
 */
public class TenantService {
        private StaffDAO StaffDAO = new StaffDAO();

    public List<Tenant> getAllTenants() {
        return StaffDAO.getAllTenants();
    }
}
