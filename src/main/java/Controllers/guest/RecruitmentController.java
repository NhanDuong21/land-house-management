package Controllers.guest;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RecruitmentController", urlPatterns = {"/recruitment"})
public class RecruitmentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/common/recruitment.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Recruitment page controller";
    }
}
