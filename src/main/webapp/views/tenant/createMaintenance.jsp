<%-- 
    Document   : createMaintenance
    Created on : Mar 8, 2026, 4:51:53 PM
    Author     : truon
--%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<t:layout title="Create Maintenance Request"
          active="maintenance"
          cssFile="${pageContext.request.contextPath}/assets/css/views/createMaintenance.css">

    <div class="create-maintenance-wrapper">
        <div class="create-maintenance-card cm-reveal">
            <div class="create-maintenance-title">Create Maintenance Request</div>

            <c:if test="${not empty error}">
                <div class="error-msg cm-error-box">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <form id="createMaintenanceForm"
                  action="${pageContext.request.contextPath}/tenant/maintenance"
                  method="post"
                  enctype="multipart/form-data"
                  novalidate>

                <div class="form-group cm-reveal">
                    <label>Room</label>
                    <select name="roomId" class="form-input" required>
                        <c:forEach var="room" items="${rooms}">
                            <option value="${room.roomId}">${room.roomNumber}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group cm-reveal">
                    <label>Issue Category</label>
                    <div class="category-group">
                        <input class="category-radio" type="radio" id="electric" name="category" value="ELECTRIC" checked>
                        <label class="category-label" for="electric">
                            <i class="bi bi-lightning-charge-fill"></i> Electric
                        </label>

                        <input class="category-radio" type="radio" id="water" name="category" value="WATER">
                        <label class="category-label" for="water">
                            <i class="bi bi-droplet-fill"></i> Water
                        </label>

                        <input class="category-radio" type="radio" id="other" name="category" value="OTHER">
                        <label class="category-label" for="other">
                            <i class="bi bi-wrench-adjustable"></i> Other
                        </label>
                    </div>
                </div>

                <div class="form-group cm-reveal">
                    <label>Description</label>
                    <textarea name="description"
                              id="cmDescription"
                              class="form-input"
                              rows="4"
                              placeholder="Describe the issue in detail..."
                              required></textarea>

                    <div class="cm-helper-row">
                        <small id="cmDescHint" class="cm-hint-text">Please describe the problem clearly.</small>
                        <small id="cmDescCount" class="cm-char-count">0</small>
                    </div>
                </div>

                <div class="form-group cm-reveal">
                    <label>
                        Upload Images
                        <span class="hint">(optional, max 3)</span>
                    </label>

                    <input type="file"
                           id="cmImages"
                           name="images"
                           class="form-input file-input"
                           multiple
                           accept="image/*">

                    <div id="cmFileInfo" class="cm-file-info">
                        No files selected
                    </div>

                    <div id="cmPreview" class="cm-preview-grid"></div>
                </div>

                <div class="create-maintenance-actions cm-reveal">
                    <button type="submit" class="btn-save cm-ripple" id="cmSubmitBtn">
                        <span class="cm-btn-content">
                            <i class="bi bi-send-fill"></i> Submit Request
                        </span>
                    </button>

                    <a href="${pageContext.request.contextPath}/tenant/maintenance" class="btn-cancel cm-ripple">
                        <i class="bi bi-x-lg"></i> Cancel
                    </a>
                </div>

            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/pages/createMaintenance.js"></script>
</t:layout>