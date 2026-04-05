<%-- 
    Document   : createRoom
    Created on : Mar 3, 2026, 1:31:33 PM
    Author     : truon
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<t:layout>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/views/admin/addRoom.css"/>

    <div class="add-room-wrapper">
        <div class="add-room-card">

            <div class="add-room-title">
                Create New Room
            </div>

            <c:if test="${not empty err}">
                <div class="error-msg">${err}</div>
            </c:if>

            <form method="post"
                  action="${pageContext.request.contextPath}/admin/rooms/create"
                  enctype="multipart/form-data">

                <div class="form-group">
                    <label class="section-label">Block</label>

                    <div class="block-switcher">
                        <label class="block-option">
                            <input type="radio"
                                   name="blockMode"
                                   value="existing"
                                   ${empty param.blockMode or param.blockMode eq 'existing' ? 'checked' : ''}>
                            <span>Use existing block</span>
                        </label>

                        <label class="block-option">
                            <input type="radio"
                                   name="blockMode"
                                   value="new"
                                   ${param.blockMode eq 'new' ? 'checked' : ''}>
                            <span>Create new block</span>
                        </label>
                    </div>

                    <div id="existingBlockHint" class="block-hint is-hidden">
                        You are using an existing block. Please select one block from the list below.
                    </div>

                    <div id="newBlockHint" class="block-hint is-hidden">
                        You are creating a new block. Please enter a new block name below.
                    </div>
                </div>

                <div class="form-group is-hidden" id="existingBlockGroup">
                    <label>Select Block</label>
                    <select name="blockId" id="blockId" class="form-control">
                        <option value="">-- Select Block --</option>
                        <c:forEach var="b" items="${blocks}">
                            <option value="${b.blockId}"
                                    ${param.blockId eq b.blockId.toString() ? 'selected' : ''}>
                                ${b.blockName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group is-hidden" id="newBlockGroup">
                    <label>New Block Name</label>
                    <input type="text"
                           name="newBlockName"
                           id="newBlockName"
                           class="form-control"
                           value="${param.newBlockName}"
                           placeholder="Example: Khu A">
                </div>
                <div class="form-group">
                    <label>Room Number</label>
                    <input type="text" name="roomNumber" value="${param.roomNumber}" required/>
                </div>

                <div class="form-row">
                    <div class="form-group half">
                        <label>Price</label>
                        <input type="number" step="0.01" name="price" value="${param.price}" required/>
                    </div>
                    <div class="form-group half">
                        <label>Area (m²)</label>
                        <input type="number" step="0.01" name="area" value="${param.area}" required/>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group half">
                        <label>Floor</label>
                        <input type="number" name="floor" value="${param.floor}" required/>
                    </div>
                    <div class="form-group half">
                        <label>Max Tenants</label>
                        <input type="number" name="maxTenants" value="${param.maxTenants}" required/>
                    </div>
                </div>

                <div class="checkbox-group">
                    <label>
                        <input type="checkbox" name="isMezzanine"
                               ${not empty param.isMezzanine ? 'checked' : ''}/>
                        Mezzanine
                    </label>
                    <label>
                        <input type="checkbox" name="airConditioning"
                               ${not empty param.airConditioning ? 'checked' : ''}/>
                        Air Conditioning
                    </label>
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description">${param.description}</textarea>
                </div>

                <div class="form-group">
                    <label>Room Images (0-12)</label>
                    <input type="file"
                           name="images"
                           multiple
                           accept="image/*"
                           required/>
                </div>

                <div class="add-room-actions">
                    <button type="submit" class="btn-add">Create Room</button>
                    <a href="${pageContext.request.contextPath}/admin/rooms" class="btn-cancel">Cancel</a>
                </div>

            </form>

        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/pages/admin/createRoom.js"></script>
</t:layout>