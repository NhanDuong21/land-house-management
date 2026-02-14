package Controllers.manager;

import java.io.IOException;
import java.util.List;

import DALs.contract.ContractDAO;
import Models.dto.ManagerContractRowDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class ManagerContractsController extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<ManagerContractRowDTO> list = contractDAO.getManagerContracts();
        request.setAttribute("contracts", list);

        request.getRequestDispatcher("/views/manager/contracts.jsp").forward(request, response);
    }
}
