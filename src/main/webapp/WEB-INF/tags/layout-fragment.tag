<%-- 
    Document   : layout-fragment
    Created on : Feb 2, 2026, 3:01:05 AM
    Author     : Duong Thien Nhan - CE190741
--%>
<%@ tag body-content="scriptless" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ attribute name="cssFile" required="false" type="java.lang.String" %>

<c:if test="${not empty cssFile}">
  <link rel="stylesheet" href="${cssFile}">
</c:if>

<div class="rh-fragment">
  <jsp:doBody/>
</div>

