<%--
    Document   : wrapper dùng layout.tag
    Created on : 02/06/2026, 6:22:57 AM
    Author     : Duong Thien Nhan - CE190741
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="Contact - RentHouse" active="contact"
          cssFile="${pageContext.request.contextPath}/assets/css/views/contact.css"
          jsFile="${pageContext.request.contextPath}/assets/js/pages/contact.js">
    <%@ include file="/views/common/contact_content.jsp" %>
</t:layout>