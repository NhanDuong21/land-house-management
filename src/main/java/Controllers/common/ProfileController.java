package Controllers.common;

import java.io.IOException;

import DALs.auth.StaffDAO;
import DALs.auth.TenantDAO;
import Models.authentication.AuthResult;
import Models.entity.Staff;
import Models.entity.Tenant;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class ProfileController extends HttpServlet {

    private final TenantDAO tenantDAO = new TenantDAO();
    private final StaffDAO staffDAO = new StaffDAO();

    @Override
    @SuppressWarnings({"UseSpecificCatch", "CallToPrintStackTrace"})
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        AuthResult auth = (session == null) ? null : (AuthResult) session.getAttribute("auth");

        if (auth == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String defaultAvatar = request.getContextPath() + "/assets/images/avatar/avtDefault.png";

        try {
            // TENANT
            if (auth.getTenant() != null) {
                int tenantId = auth.getTenant().getTenantId();
                Tenant t = tenantDAO.findById(tenantId);

                if (t == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                request.setAttribute("profileType", "TENANT");
                request.setAttribute("roleDisplay", "TENANT");
                request.setAttribute("active", "t_profile");

                request.setAttribute("avatarUrl", defaultAvatar);

                request.setAttribute("fullName", nvl(t.getFullName()));
                request.setAttribute("email", nvl(t.getEmail()));
                request.setAttribute("phone", nvl(t.getPhoneNumber()));
                request.setAttribute("identity", nvl(t.getIdentityCode()));
                request.setAttribute("dob", (t.getDateOfBirth() == null) ? "" : t.getDateOfBirth().toString());
                request.setAttribute("gender", genderLabel(t.getGender()));

                request.setAttribute("showAddress", true);
                request.setAttribute("address", nvl(t.getAddress()));

                request.getRequestDispatcher("/views/common/profile.jsp").forward(request, response);
                return;
            }

            //  STAFF (MANAGER/ADMIN)
            if (auth.getStaff() != null) {
                int staffId = auth.getStaff().getStaffId();
                Staff s = staffDAO.findById(staffId);

                if (s == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                String role = resolveRole(auth, s); // MANAGER / ADMIN / STAFF fallback

                request.setAttribute("profileType", role);
                request.setAttribute("roleDisplay", role);

                // highlight menu
                if ("MANAGER".equalsIgnoreCase(role)) {
                    request.setAttribute("active", "m_profile");
                } else if ("ADMIN".equalsIgnoreCase(role)) {
                    request.setAttribute("active", "a_profile");
                } else {
                    request.setAttribute("active", "");
                }

                request.setAttribute("avatarUrl",
                        (s.getAvatar() != null && !s.getAvatar().isBlank()) ? s.getAvatar() : defaultAvatar);

                request.setAttribute("fullName", nvl(s.getFullName()));
                request.setAttribute("email", nvl(s.getEmail()));
                request.setAttribute("phone", nvl(s.getPhoneNumber()));
                request.setAttribute("identity", nvl(s.getIdentityCode()));
                request.setAttribute("dob", (s.getDateOfBirth() == null) ? "" : s.getDateOfBirth().toString());
                request.setAttribute("gender", genderLabel(s.getGender()));

                request.setAttribute("showAddress", false);
                request.setAttribute("address", "");

                request.getRequestDispatcher("/views/common/profile.jsp").forward(request, response);
                return;
            }

            //weird state
            response.sendRedirect(request.getContextPath() + "/login");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    private static String nvl(String s) {
        return (s == null) ? "" : s;
    }

    private static String genderLabel(Integer g) {
        if (g == null) {
            return "";
        }
        return (g == 1) ? "Male" : "Female";
    }

    /**
     * follow same fallback logic as layout.tag: - auth.role if not blank - else
     * staff.staffRole (MANAGER/ADMIN) - else STAFF (rare)
     */
    private static String resolveRole(AuthResult auth, Staff staff) {
        if (auth != null && auth.getRole() != null && !auth.getRole().isBlank()) {
            return auth.getRole().trim().toUpperCase();
        }
        if (staff != null && staff.getStaffRole() != null && !staff.getStaffRole().isBlank()) {
            return staff.getStaffRole().trim().toUpperCase(); // MANAGER/ADMIN
        }
        return "STAFF";
    }
}
