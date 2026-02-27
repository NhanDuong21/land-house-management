<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="layout" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<layout:layout title="Manage Tenants" active="m_tenants">

    <style>
        .mt-container{
            padding: 30px;
        }

        .mt-header h2{
            margin: 0;
            font-size: 28px;
            font-weight: 700;
        }

        .mt-header p{
            color: #6b7280;
            margin-top: 5px;
        }

        .mt-search-box{
            margin-top: 20px;
            margin-bottom: 20px;
        }

        .mt-search-input{
            width: 100%;
            padding: 14px 16px;
            border-radius: 12px;
            border: 1px solid #ddd;
            background: #f3f4f6;
            font-size: 14px;
            outline: none;
        }

        .mt-card{
            background: white;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .mt-card-title{
            font-weight: 600;
            margin-bottom: 15px;
        }

        .mt-table{
            width: 100%;
            border-collapse: collapse;
        }

        .mt-table th{
            text-align: left;
            padding: 14px;
            border-bottom: 2px solid #eee;
            font-weight: 600;
        }

        .mt-table td{
            padding: 14px;
            border-bottom: 1px solid #f1f1f1;
        }

        .mt-name{
            font-weight: 500;
        }

        .mt-btn-edit{
            padding: 6px 14px;
            border-radius: 8px;
            border: 1px solid #ccc;
            color: black;
            font-size: 14px;
            background: #f9f9f9;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .mt-btn-edit:hover{
            background: #eee;
        }

        .mt-empty{
            text-align: center;
            padding: 20px;
            color: gray;
        }

        /* ===== MODAL ===== */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.45);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }

        .modal-overlay.active {
            display: flex;
        }

        .modal-box {
            background: white;
            border-radius: 16px;
            padding: 32px;
            width: 560px;
            max-width: 95vw;
            box-shadow: 0 8px 32px rgba(0,0,0,0.18);
            position: relative;
        }

        .modal-title {
            font-size: 20px;
            font-weight: 700;
            margin: 0 0 4px 0;
        }

        .modal-subtitle {
            color: #6b7280;
            font-size: 14px;
            margin-bottom: 24px;
        }

        .modal-close-btn {
            position: absolute;
            top: 16px;
            right: 16px;
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: #6b7280;
            line-height: 1;
        }

        .modal-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .modal-field {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .modal-field label {
            font-size: 13px;
            font-weight: 600;
            color: #374151;
        }

        .modal-field-row {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .modal-field-row input,
        .modal-field-row select {
            flex: 1;
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
            background: #f9fafb;
        }

        .modal-field-row input:focus,
        .modal-field-row select:focus {
            border-color: #6366f1;
            background: white;
        }

        .modal-clear-btn {
            background: #ef4444;
            border: none;
            border-radius: 8px;
            width: 36px;
            height: 36px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            color: white;
            font-size: 16px;
        }

        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 24px;
        }

        .modal-btn-cancel {
            padding: 10px 20px;
            border-radius: 8px;
            border: 1px solid #d1d5db;
            background: white;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .modal-btn-save {
            padding: 10px 24px;
            border-radius: 8px;
            border: none;
            background: #22c55e;
            color: white;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .modal-btn-save:hover {
            background: #16a34a;
        }
        .modal-btn-cancel:hover {
            background: #f3f4f6;
        }
        /* ===== TOAST NOTIFICATION ===== */
        .toast {
            position: fixed;
            top: 24px;
            right: 24px;
            z-index: 9999;
            display: flex;
            align-items: flex-start;
            gap: 12px;
            background: white;
            border-radius: 12px;
            padding: 16px 20px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.15);
            min-width: 320px;
            max-width: 420px;
            border-left: 4px solid #ef4444;
            transform: translateX(120%);
            transition: transform 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
        }

        .toast.show {
            transform: translateX(0);
        }

        .toast-icon {
            font-size: 20px;
            flex-shrink: 0;
            margin-top: 1px;
        }

        .toast-body {
            flex: 1;
        }

        .toast-title {
            font-weight: 700;
            font-size: 14px;
            color: #111827;
            margin-bottom: 2px;
        }

        .toast-message {
            font-size: 13px;
            color: #6b7280;
            line-height: 1.4;
        }

        .toast-close {
            background: none;
            border: none;
            font-size: 16px;
            cursor: pointer;
            color: #9ca3af;
            padding: 0;
            flex-shrink: 0;
        }

        .toast-close:hover {
            color: #374151;
        }
        /* ===== CONFIRM DIALOG ===== */
        .confirm-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.45);
            z-index: 2000;
            justify-content: center;
            align-items: center;
        }

        .confirm-overlay.active {
            display: flex;
        }

        .confirm-box {
            background: white;
            border-radius: 16px;
            padding: 32px;
            width: 400px;
            max-width: 95vw;
            box-shadow: 0 8px 32px rgba(0,0,0,0.18);
            text-align: center;
        }

        .confirm-icon {
            font-size: 48px;
            margin-bottom: 12px;
        }

        .confirm-title {
            font-size: 18px;
            font-weight: 700;
            color: #111827;
            margin-bottom: 8px;
        }

        .confirm-subtitle {
            font-size: 14px;
            color: #6b7280;
            margin-bottom: 24px;
        }

        .confirm-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
        }

        .confirm-btn-cancel {
            padding: 10px 24px;
            border-radius: 8px;
            border: 1px solid #d1d5db;
            background: white;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
        }

        .confirm-btn-ok {
            padding: 10px 24px;
            border-radius: 8px;
            border: none;
            background: #22c55e;
            color: white;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
        }

        .confirm-btn-cancel:hover {
            background: #f3f4f6;
        }
        .confirm-btn-ok:hover {
            background: #16a34a;
        }
    </style>

    <div class="mt-container">

        <!-- HEADER -->
        <div class="mt-header">
            <h2>Manage Tenants</h2>
            <p>View and manage all tenant information</p>
        </div>

        <!-- SEARCH -->
        <div class="mt-search-box">
            <form method="get"
                  action="${pageContext.request.contextPath}/manager/tenants"
                  style="display:flex; gap:10px;">
                <input type="text" 
                       name="keyword"
                       value="${keyword}"
                       class="mt-search-input"
                       placeholder="Search by tenant ID, name, phone or email...">
                <button type="submit" class="mt-btn-edit">Search</button>
            </form>
        </div>

        <!-- CARD -->
        <div class="mt-card">
            <div class="mt-card-title">
                All Tenants (<c:out value="${empty tenants ? 0 : tenants.size()}"/>)
            </div>

            <table class="mt-table">
                <thead>
                    <tr>
                        <th>Tenant ID</th>
                        <th>Full Name</th>
                        <th>Phone Number</th>
                        <th>Email</th>
                        <th>Citizen ID</th>
                        <th>Date of Birth</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="t" items="${tenants}">
                        <tr>
                            <td>${t.tenantId}</td>
                            <td class="mt-name">${t.fullName}</td>
                            <td>${t.phoneNumber}</td>
                            <td>${t.email}</td>
                            <td>
                                ${t.identityCode.substring(0,2)}******${t.identityCode.substring(t.identityCode.length()-2)}
                            </td>
                            <td>
                                <fmt:formatDate value="${t.dateOfBirth}" pattern="yyyy-MM-dd"/>
                            </td>
                            <td>
                                <button class="mt-btn-edit"
                                        onclick="openEditModal(
                                                        '${t.tenantId}',
                                                        '${t.fullName}',
                                                        '${t.identityCode}',
                                                        '${t.phoneNumber}',
                                                        '${t.email}',
                                                        '<fmt:formatDate value="${t.dateOfBirth}" pattern="yyyy-MM-dd"/>',
                                                        '${t.gender}',
                                                        '${t.address}'
                                                        )">
                                    ✏️ Edit
                                </button>
                                <!-- DELETE -->
                                <button class="mt-btn-edit"
                                        style="background:#fee2e2; border-color:#fca5a5; color:#b91c1c;"
                                        onclick="openDeleteConfirm('${t.tenantId}')">
                                    🗑 Delete
                                </button>                   
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty tenants}">
                        <tr>
                            <td colspan="7" class="mt-empty">No tenants found</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- ===== EDIT MODAL ===== -->
    <div class="modal-overlay" id="editModal">
        <div class="modal-box">
            <button class="modal-close-btn" onclick="closeEditModal()">✕</button>
            <div class="modal-title">Edit Tenant Information</div>
            <div class="modal-subtitle">Update tenant details or remove incorrect information</div>

            <form method="post" action="${pageContext.request.contextPath}/manager/tenant/edit">
                <input type="hidden" name="tenantId" id="modal_tenantId"/>

                <div class="modal-grid">

                    <!-- Full Name -->
                    <div class="modal-field">
                        <label>Full Name</label>
                        <div class="modal-field-row">
                            <input type="text" name="fullName" id="modal_fullName" placeholder="Full Name"/>
                            <button type="button" class="modal-clear-btn" onclick="clearField('modal_fullName')">🗑</button>
                        </div>
                    </div>

                    <!-- Phone Number -->
                    <div class="modal-field">
                        <label>Phone Number</label>
                        <div class="modal-field-row">
                            <input type="text" name="phoneNumber" id="modal_phoneNumber" placeholder="Phone Number"/>
                            <button type="button" class="modal-clear-btn" onclick="clearField('modal_phoneNumber')">🗑</button>
                        </div>
                    </div>

                    <!-- Email -->
                    <div class="modal-field">
                        <label>Email</label>
                        <div class="modal-field-row">
                            <input type="email" name="email" id="modal_email" placeholder="Email"/>
                            <button type="button" class="modal-clear-btn" onclick="clearField('modal_email')">🗑</button>
                        </div>
                    </div>

                    <!-- Citizen ID -->
                    <div class="modal-field">
                        <label>Citizen ID (12 digits)</label>
                        <div class="modal-field-row">
                            <input type="text" name="identityCode" id="modal_identityCode" placeholder="Citizen ID" maxlength="12"/>
                            <button type="button" class="modal-clear-btn" onclick="clearField('modal_identityCode')">🗑</button>
                        </div>
                    </div>

                    <!-- Date of Birth -->
                    <div class="modal-field">
                        <label>Date of Birth</label>
                        <div class="modal-field-row">
                            <input type="date" name="dateOfBirth" id="modal_dateOfBirth"/>
                            <button type="button" class="modal-clear-btn" onclick="clearField('modal_dateOfBirth')">🗑</button>
                        </div>
                    </div>

                    <!-- Gender -->
                    <div class="modal-field">
                        <label>Gender</label>
                        <div class="modal-field-row">
                            <select name="gender" id="modal_gender">
                                <option value="">-- Select --</option>
                                <option value="1">Male</option>
                                <option value="0">Female</option>
                            </select>
                            <button type="button" class="modal-clear-btn" onclick="document.getElementById('modal_gender').value = ''">🗑</button>
                        </div>
                    </div>

                    <!-- Address (full width) -->
                    <div class="modal-field" style="grid-column: span 2;">
                        <label>Address</label>
                        <div class="modal-field-row">
                            <input type="text" name="address" id="modal_address" placeholder="Address"/>
                            <button type="button" class="modal-clear-btn" onclick="clearField('modal_address')">🗑</button>
                        </div>
                    </div>

                </div>

                <div class="modal-actions">
                    <button type="button" class="modal-btn-cancel" onclick="closeEditModal()">✕ Cancel</button>
                    <button type="button" class="modal-btn-save" onclick="openConfirm()">✔ Save Changes</button>
                </div>
            </form>
        </div>
    </div>
    <!-- ===== CONFIRM DIALOG ===== -->
    <div class="confirm-overlay" id="confirmDialog">
        <div class="confirm-box">
            <div class="confirm-icon">💾</div>
            <div class="confirm-title">Xác nhận lưu thay đổi</div>
            <div class="confirm-subtitle">Bạn có chắc chắn muốn cập nhật thông tin tenant này không?</div>
            <div class="confirm-actions">
                <button class="confirm-btn-cancel" onclick="closeConfirm()">✕ Cancel</button>
                <button class="confirm-btn-ok" onclick="submitEditForm()">✔ Đồng ý</button>
            </div>
        </div>
    </div>
    <!-- ===== DELETE CONFIRM ===== -->
    <div class="confirm-overlay" id="deleteDialog">
        <div class="confirm-box">
            <div class="confirm-icon">⚠️</div>
            <div class="confirm-title">Delete Tenant</div>
            <div class="confirm-subtitle">
                Are you sure you want to delete this tenant? This action cannot be undone.
            </div>

            <div class="confirm-actions">
                <button class="confirm-btn-cancel" onclick="closeDeleteConfirm()">Cancel</button>
                <button class="confirm-btn-ok" 
                        style="background:#ef4444"
                        onclick="confirmDelete()">
                    Delete
                </button>
            </div>
        </div>
    </div>
    <!-- TOAST -->
    <div class="toast" id="errorToast">
        <div class="toast-icon">❌</div>
        <div class="toast-body">
            <div class="toast-title">Validation Error</div>
            <div class="toast-message" id="toastMessage"></div>
        </div>
        <button class="toast-close" onclick="hideToast()">✕</button>
    </div>
    <script>
        function showToast(message) {
            document.getElementById('toastMessage').textContent = message;
            const toast = document.getElementById('errorToast');
            toast.classList.add('show');
            setTimeout(hideToast, 4000); // tự ẩn sau 4 giây
        }

        function hideToast() {
            document.getElementById('errorToast').classList.remove('show');
        }

        (function () {
            const params = new URLSearchParams(window.location.search);
            const err = params.get('error');
            if (err) {
                showToast(decodeURIComponent(err));
                const url = new URL(window.location.href);
                url.searchParams.delete('error');
                window.history.replaceState({}, '', url);
            }
        })();
        function openEditModal(id, fullName, identityCode, phone, email, dob, gender, address) {
            document.getElementById('modal_tenantId').value = id;
            document.getElementById('modal_fullName').value = fullName;
            document.getElementById('modal_identityCode').value = identityCode;
            document.getElementById('modal_phoneNumber').value = phone;
            document.getElementById('modal_email').value = email;
            document.getElementById('modal_dateOfBirth').value = dob;
            document.getElementById('modal_address').value = (address === 'null' ? '' : address);

            var genderSelect = document.getElementById('modal_gender');
            if (gender === '0')
                genderSelect.value = '0';
            else if (gender === '1')
                genderSelect.value = '1';
            else
                genderSelect.value = '';

            document.getElementById('editModal').classList.add('active');
        }

        function closeEditModal() {
            document.getElementById('editModal').classList.remove('active');
        }

        function clearField(id) {
            document.getElementById(id).value = '';
        }

        // Close modal when clicking outside
        document.getElementById('editModal').addEventListener('click', function (e) {
            if (e.target === this)
                closeEditModal();
        });
        function openConfirm() {
            document.getElementById('confirmDialog').classList.add('active');
        }

        function closeConfirm() {
            document.getElementById('confirmDialog').classList.remove('active');
        }

        function submitEditForm() {
            closeConfirm();
            document.querySelector('#editModal form').submit();
        }
        let deleteTenantId = null;

        function openDeleteConfirm(id) {
            deleteTenantId = id;
            document.getElementById('deleteDialog').classList.add('active');
        }

        function closeDeleteConfirm() {
            document.getElementById('deleteDialog').classList.remove('active');
        }

        function confirmDelete() {
            if (deleteTenantId) {
                window.location.href =
                        "${pageContext.request.contextPath}/manager/tenant/delete?id=" + deleteTenantId;
            }
        }
    </script>

</layout:layout>
