<%--
    Document   : contact_content
    Author     : Duong Thien Nhan - CE190741
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="Models.common.ContactInfo" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<div class="ct-page">

    <div class="ct-header">
        <div class="ct-title">
            <i class="bi bi-chat-dots"></i>
            <span>Contact</span>
        </div>
        <p>Get in touch with the management</p>
    </div>

    <div class="ct-card">
        <div class="ct-card-title">
            <i class="bi bi-person-lines-fill"></i>
            Manager Contact Information
        </div>

        <div class="ct-item">
            <div class="ct-icon ct-user">
                <i class="bi bi-person-badge"></i>
            </div>
            <div class="ct-body">
                <div class="ct-label">Manager Name</div>
                <div class="ct-value">${contact.managerName}</div>
            </div>
        </div>

        <div class="ct-item">
            <div class="ct-icon ct-phone">
                <i class="bi bi-telephone"></i>
            </div>
            <div class="ct-body">
                <div class="ct-label">Phone Number</div>
                <div class="ct-value">
                    <a href="tel:${contact.phone}">
                        <i class="bi bi-telephone-outbound"></i>
                        <span>${contact.phone}</span>
                    </a>
                </div>
            </div>
        </div>

        <div class="ct-item">
            <div class="ct-icon ct-mail">
                <i class="bi bi-envelope"></i>
            </div>
            <div class="ct-body">
                <div class="ct-label">Email Address</div>
                <div class="ct-value">
                    <a href="mailto:${contact.email}">
                        <i class="bi bi-send"></i>
                        <span>${contact.email}</span>
                    </a>
                </div>
            </div>
        </div>

        <div class="ct-item">
            <div class="ct-icon ct-pin">
                <i class="bi bi-geo-alt"></i>
            </div>
            <div class="ct-body">
                <div class="ct-label">Address</div>
                <div class="ct-value">${contact.address}</div>
            </div>
        </div>

        <div class="ct-note">
            <div class="ct-note-head">
                <i class="bi bi-clock-history"></i>
                <b>Office Hours</b>
            </div>
            <div class="ct-note-body">
                ${contact.workingHours}<br/>
                For urgent matters outside office hours, please call the emergency hotline.
            </div>
        </div>

        <div class="ct-company">
            <i class="bi bi-building"></i>
            <span>Company:</span> <b>${contact.companyName}</b>
        </div>
    </div>

</div>