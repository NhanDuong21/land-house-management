/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Services.staff;

import DALs.auth.TenantDAO;
import Models.entity.Tenant;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ADMIN
 */
public class TenantService {

    private TenantDAO TenantDAO = new TenantDAO();

    public List<Tenant> getAllTenants() {
        return TenantDAO.getAllTenants();
    }
    
  public List<Tenant> searchTenant(String keyword) {
        return TenantDAO.searchTenant(keyword);
    }
}
