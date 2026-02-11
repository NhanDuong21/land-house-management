<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="layout" tagdir="/WEB-INF/tags"%>

<layout:layout title="Manage Contracts"
               active="m_contracts"
               cssFile="${pageContext.request.contextPath}/assets/css/views/managerContracts.css">

    <div class="mc-wrap">

        <div class="mc-head">
            <div class="mc-head-left">
                <div class="mc-title">Manage Contracts</div>
                <div class="mc-sub">View and manage all rental contracts</div>
            </div>

            <a class="mc-add-btn" href="${pageContext.request.contextPath}/manager/contracts/create">
                <span class="mc-plus">＋</span>
                <span>Add Contract</span>
            </a>
        </div>

        <div class="mc-search-card">
            <div class="mc-search">
                <span class="mc-search-icon">🔍</span>
                <input class="mc-search-input" type="text"
                       placeholder="Search by contract ID, room number, or tenant name..."
                       onkeydown="return false;">
            </div>
        </div>

        <div class="mc-card">
            <div class="mc-card-title">All Contracts (2)</div>

            <div class="mc-table-wrap">
                <table class="mc-table">
                    <thead>
                        <tr>
                            <th>Contract ID</th>
                            <th>Room</th>
                            <th>Tenant Name</th>
                            <th>Start Date</th>
                            <th>Monthly Rent</th>
                            <th>Status</th>
                            <th class="mc-th-action">Action</th>
                        </tr>
                    </thead>

                    <tbody>
                        <tr>
                            <td class="mc-mono">000001</td>
                            <td>A101</td>
                            <td>John Doe</td>
                            <td>January 1, 2025</td>
                            <td class="mc-money">3.500.000 đ</td>
                            <td>
                                <span class="mc-badge active">ACTIVE</span>
                            </td>
                            <td class="mc-td-action">
                                <a class="mc-view-btn" href="#" onclick="return false;">
                                    <span class="mc-eye">👁️</span>
                                    <span>View</span>
                                </a>
                            </td>
                        </tr>

                        <tr>
                            <td class="mc-mono">000002</td>
                            <td>A102</td>
                            <td>Nguyễn Văn A</td>
                            <td>February 1, 2026</td>
                            <td class="mc-money">2.800.000 đ</td>
                            <td>
                                <span class="mc-badge pending">PENDING</span>
                            </td>
                            <td class="mc-td-action">
                                <a class="mc-view-btn" href="#" onclick="return false;">
                                    <span class="mc-eye">👁️</span>
                                    <span>View</span>
                                </a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

</layout:layout>
