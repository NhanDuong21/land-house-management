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
    text-decoration: none;
    color: black;
    font-size: 14px;
    background: #f9f9f9;
    display: inline-block;
}

.mt-btn-edit:hover{
    background: #eee;
}

.mt-empty{
    text-align: center;
    padding: 20px;
    color: gray;
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
              action="${pageContext.request.contextPath}/manager/tenants">

            <input type="text" 
                   name="q"
                   value="${q}"
                   class="mt-search-input"
                   placeholder="Search by tenant ID or full name...">
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

                        <td class="mt-name">
                            ${t.fullName}
                        </td>

                        <td>${t.phoneNumber}</td>

                        <td>${t.email}</td>

                        <td>
                            ${t.identityCode.substring(0,2)}
                            ******
                            ${t.identityCode.substring(t.identityCode.length()-2)}
                        </td>

                        <td>
                            <fmt:formatDate value="${t.dateOfBirth}" pattern="yyyy-MM-dd"/>
                        </td>

                        <td>
                            <a href="${pageContext.request.contextPath}/manager/tenant/edit?id=${t.tenantId}"
                               class="mt-btn-edit">
                                Edit
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty tenants}">
                    <tr>
                        <td colspan="7" class="mt-empty">
                            No tenants found
                        </td>
                    </tr>
                </c:if>

            </tbody>
        </table>

    </div>

</div>

</layout:layout>