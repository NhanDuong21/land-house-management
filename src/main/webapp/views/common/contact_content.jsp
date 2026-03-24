<%--
    Document   : contact_content
    Author     : Duong Thien Nhan - CE190741
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="Models.common.ContactInfo" %>

<div class="ct-page">

    <!-- HERO -->
    <section class="ct-hero">
        <div class="ct-hero__overlay"></div>

        <div class="ct-hero__content">
            <div class="ct-hero__left">
                <span class="ct-badge">
                    <i class="bi bi-headset"></i>
                    Contact & Support
                </span>

                <h1>Get In Touch With Management</h1>

                <p class="ct-hero__desc">
                    Need help with room information, billing, contract issues, or maintenance support?
                    Contact the management team through the information below for quick assistance.
                </p>

                <div class="ct-hero__actions">
                    <a href="tel:${contact.phone}" class="ct-btn ct-btn--light">
                        <i class="bi bi-telephone-fill"></i>
                        Call Now
                    </a>

                    <a href="mailto:${contact.email}" class="ct-btn ct-btn--ghost">
                        <i class="bi bi-envelope-fill"></i>
                        Send Email
                    </a>
                </div>
            </div>

            <div class="ct-hero__right">
                <div class="ct-stat-card ct-stat-card--main">
                    <div class="ct-stat-card__icon">
                        <i class="bi bi-person-lines-fill"></i>
                    </div>
                    <div class="ct-stat-card__value">24/7</div>
                    <div class="ct-stat-card__label">Support Availability</div>
                </div>

                <div class="ct-stat-row">
                    <div class="ct-stat-card">
                        <div class="ct-stat-card__icon">
                            <i class="bi bi-telephone"></i>
                        </div>
                        <div class="ct-stat-card__value">Hotline</div>
                        <div class="ct-stat-card__label">Direct Contact</div>
                    </div>

                    <div class="ct-stat-card">
                        <div class="ct-stat-card__icon">
                            <i class="bi bi-envelope"></i>
                        </div>
                        <div class="ct-stat-card__value">Email</div>
                        <div class="ct-stat-card__label">Fast Response</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- MAIN CONTACT -->
    <section class="ct-section">
        <div class="ct-section__heading">
            <span class="ct-section__tag">Contact Details</span>
            <h2>Manager Contact Information</h2>
            <p>
                Reach the responsible manager using the channels below for support, consultation,
                or urgent problem handling related to the rental system.
            </p>
        </div>

        <div class="ct-grid">
            <div class="ct-info-panel">
                <div class="ct-card-title">
                    <i class="bi bi-person-vcard-fill"></i>
                    <span>Primary Information</span>
                </div>

                <div class="ct-item">
                    <div class="ct-icon ct-user">
                        <i class="bi bi-person-badge-fill"></i>
                    </div>
                    <div class="ct-body">
                        <div class="ct-label">Manager Name</div>
                        <div class="ct-value">${contact.managerName}</div>
                    </div>
                </div>

                <div class="ct-item">
                    <div class="ct-icon ct-phone">
                        <i class="bi bi-telephone-fill"></i>
                    </div>
                    <div class="ct-body">
                        <div class="ct-label">Phone Number</div>
                        <div class="ct-value">
                            <a href="tel:${contact.phone}">
                                <i class="bi bi-telephone-outbound-fill"></i>
                                <span>${contact.phone}</span>
                            </a>
                        </div>
                    </div>
                </div>

                <div class="ct-item">
                    <div class="ct-icon ct-mail">
                        <i class="bi bi-envelope-fill"></i>
                    </div>
                    <div class="ct-body">
                        <div class="ct-label">Email Address</div>
                        <div class="ct-value">
                            <a href="mailto:${contact.email}">
                                <i class="bi bi-send-fill"></i>
                                <span>${contact.email}</span>
                            </a>
                        </div>
                    </div>
                </div>

                <div class="ct-item">
                    <div class="ct-icon ct-pin">
                        <i class="bi bi-geo-alt-fill"></i>
                    </div>
                    <div class="ct-body">
                        <div class="ct-label">Address</div>
                        <div class="ct-value">${contact.address}</div>
                    </div>
                </div>

                <div class="ct-company">
                    <i class="bi bi-building-fill"></i>
                    <span>Company</span>
                    <strong>${contact.companyName}</strong>
                </div>
            </div>

            <div class="ct-side-panel">
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

                <div class="ct-support-card">
                    <div class="ct-support-card__icon">
                        <i class="bi bi-life-preserver"></i>
                    </div>
                    <h3>Need quick support?</h3>
                    <p>
                        Use the phone number for urgent problems and email for formal requests,
                        billing clarifications, contract questions, or general consultation.
                    </p>

                    <div class="ct-support-actions">
                        <a href="tel:${contact.phone}" class="ct-action-btn ct-action-btn--primary">
                            <i class="bi bi-telephone-fill"></i>
                            Call Manager
                        </a>
                        <a href="mailto:${contact.email}" class="ct-action-btn ct-action-btn--secondary">
                            <i class="bi bi-envelope-fill"></i>
                            Email Manager
                        </a>
                    </div>
                </div>

                <div class="ct-mini-grid">
                    <div class="ct-mini-card">
                        <i class="bi bi-shield-check"></i>
                        <h4>Reliable</h4>
                        <p>Direct and trusted communication with management.</p>
                    </div>

                    <div class="ct-mini-card">
                        <i class="bi bi-lightning-charge-fill"></i>
                        <h4>Responsive</h4>
                        <p>Fast support for urgent rental and maintenance issues.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- QUICK GUIDE -->
    <section class="ct-section ct-section--soft">
        <div class="ct-section__heading">
            <span class="ct-section__tag">Support Guide</span>
            <h2>When should you contact management?</h2>
        </div>

        <div class="ct-guide-grid">
            <div class="ct-guide-card">
                <div class="ct-guide-card__icon">
                    <i class="bi bi-tools"></i>
                </div>
                <h3>Maintenance Issues</h3>
                <p>Contact management for urgent repairs, broken facilities, or safety-related problems.</p>
            </div>

            <div class="ct-guide-card">
                <div class="ct-guide-card__icon">
                    <i class="bi bi-receipt-cutoff"></i>
                </div>
                <h3>Billing Questions</h3>
                <p>Ask for clarification on invoices, payment status, utility charges, and related billing concerns.</p>
            </div>

            <div class="ct-guide-card">
                <div class="ct-guide-card__icon">
                    <i class="bi bi-file-earmark-text"></i>
                </div>
                <h3>Contract Support</h3>
                <p>Get assistance on rental contracts, extensions, confirmations, and other agreement matters.</p>
            </div>

            <div class="ct-guide-card">
                <div class="ct-guide-card__icon">
                    <i class="bi bi-chat-dots-fill"></i>
                </div>
                <h3>General Consultation</h3>
                <p>Reach out for general questions related to rooms, services, policies, and management support.</p>
            </div>
        </div>
    </section>

</div>