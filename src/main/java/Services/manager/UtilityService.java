/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Services.manager;

import DALs.utility.UtilityDAO;
import Models.entity.Utility;
import java.util.List;

/**
 *
 * @author Truong Hoang Khang - CE190729
 */
public class UtilityService {
    private final UtilityDAO udao = new UtilityDAO();
    public List<Utility> getAllUtilities(){
        return udao.getAllUtilities();
    }
}
