package Services.tenant;

import DALs.auth.TenantDAO;
import Models.common.ServiceResult;
import Models.entity.Tenant;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-26
 */
public class TenantService {

    private final TenantDAO tenantDAO = new TenantDAO();

    public ServiceResult updatePhone(int tenantId, String phoneRaw) {

        Tenant t = tenantDAO.findById(tenantId);
        if (t == null) {
            return ServiceResult.fail("NOT_FOUND");
        }

        if (!"ACTIVE".equalsIgnoreCase(t.getAccountStatus())) {
            return ServiceResult.fail("TENANT_NOT_ACTIVE");
        }

        String phone = (phoneRaw == null) ? "" : phoneRaw.trim();
        phone = phone.replaceAll("[\\s.]", "");

        if (phone.isBlank()) {
            return ServiceResult.fail("PHONE_REQUIRED");
        }

        // bắt đầu từ 0 và theo sau là 9 hoặc 10 số
        if (!phone.matches("^0\\d{9,10}$")) {
            return ServiceResult.fail("PHONE_FORMAT");
        }

        //trung thi khoi update ton tai nguyen
        if (phone.equals(t.getPhoneNumber())) {
            return ServiceResult.ok("OK");
        }

        if (tenantDAO.existsPhoneExceptTenant(tenantId, phone)) {
            return ServiceResult.fail("PHONE_EXISTS");
        }

        boolean ok = tenantDAO.updatePhoneForTenant(tenantId, phone);
        return ok ? ServiceResult.ok("OK") : ServiceResult.fail("UPDATE_FAILED");
    }
}
