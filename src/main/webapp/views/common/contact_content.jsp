<%-- 
    Document   : contact_content
    Author     : Duong Thien Nhan - CE190741
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="Models.common.ContactInfo" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<div class="ct-page">
    <div class="ct-header">
        <h1>Contact</h1>
        <p>Get in touch with the management</p>
    </div>

    <div class="ct-card">
        <div class="ct-card-title">Manager Contact Information</div>

        <div class="ct-item">
            <div class="ct-icon ct-user">👤</div>
            <div class="ct-body">
                <div class="ct-label">Manager Name</div>
                <div class="ct-value">${contact.managerName}</div>
            </div>
        </div>

        <div class="ct-item">
            <div class="ct-icon ct-phone">📞</div>
            <div class="ct-body">
                <div class="ct-label">Phone Number</div>
                <div class="ct-value">
                    <a href="tel:${contact.phone}">${contact.phone}</a>
                </div>
            </div>
        </div>

        <div class="ct-item">
            <div class="ct-icon ct-mail">✉️</div>
            <div class="ct-body">
                <div class="ct-label">Email Address</div>
                <div class="ct-value">
                    <a href="mailto:${contact.email}">${contact.email}</a>
                </div>
            </div>
        </div>

        <div class="ct-item">
            <div class="ct-icon ct-pin">📍</div>
            <div class="ct-body">
                <div class="ct-label">Address</div>
                <div class="ct-value">${contact.address}</div>
            </div>
        </div>

        <div class="ct-note">
            <b>Office Hours:</b> ${contact.workingHours}<br/>
            For urgent matters outside office hours, please call the emergency hotline.
        </div>

        <div class="ct-company">
            <span>Company:</span> <b>${contact.companyName}</b>
        </div>
    </div>
</div>
