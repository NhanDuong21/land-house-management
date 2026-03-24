<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<t:layout
    title="News - RentHouse"
    active="news"
    cssFile="${pageContext.request.contextPath}/assets/css/views/news.css"
    jsFile="${pageContext.request.contextPath}/assets/js/pages/news.js">

    <div class="news-page">

        <section class="news-hero">
            <div class="news-hero__content">
                <span class="news-badge">
                    <i class="bi bi-newspaper"></i>
                    Project Updates
                </span>
                <h1>Latest News & Announcements</h1>
                <p>
                    Stay updated with project progress, system improvements, feature releases,
                    and important announcements related to RentHouse Management.
                </p>
            </div>
        </section>

        <section class="news-section">
            <div class="news-section__heading">
                <span class="news-tag">Highlights</span>
                <h2>Recent project news</h2>
            </div>

            <div class="news-grid">
                <article class="news-card news-card--featured">
                    <div class="news-card__meta">
                        <span><i class="bi bi-calendar-event"></i> March 2026</span>
                        <span><i class="bi bi-stars"></i> Featured</span>
                    </div>
                    <h3>RentHouse Management project interface completed</h3>
                    <p>
                        The project has completed the major user interface pages for guest,
                        tenant, manager, and admin roles. The system now provides a more
                        consistent and organized experience across modules.
                    </p>
                    <a href="#" class="news-link">Read more <i class="bi bi-arrow-right"></i></a>
                </article>

                <article class="news-card">
                    <div class="news-card__meta">
                        <span><i class="bi bi-calendar-event"></i> March 2026</span>
                    </div>
                    <h3>Room and tenant management modules improved</h3>
                    <p>
                        New updates focus on room listing, tenant tracking, and better
                        organization for rental data within the management workflow.
                    </p>
                    <a href="#" class="news-link">Read more <i class="bi bi-arrow-right"></i></a>
                </article>

                <article class="news-card">
                    <div class="news-card__meta">
                        <span><i class="bi bi-calendar-event"></i> March 2026</span>
                    </div>
                    <h3>Billing and contract modules integrated</h3>
                    <p>
                        Monthly billing, contract confirmation, and payment-related features
                        have been connected to support the main rental lifecycle.
                    </p>
                    <a href="#" class="news-link">Read more <i class="bi bi-arrow-right"></i></a>
                </article>

                <article class="news-card">
                    <div class="news-card__meta">
                        <span><i class="bi bi-calendar-event"></i> March 2026</span>
                    </div>
                    <h3>Maintenance request flow is now available</h3>
                    <p>
                        Tenants can submit maintenance issues and managers can follow up
                        through the dedicated maintenance management pages.
                    </p>
                    <a href="#" class="news-link">Read more <i class="bi bi-arrow-right"></i></a>
                </article>
            </div>
        </section>

        <section class="news-section news-section--soft">
            <div class="news-section__heading">
                <span class="news-tag">Release Notes</span>
                <h2>What has been developed</h2>
            </div>

            <div class="release-list">
                <div class="release-item">
                    <div class="release-item__icon"><i class="bi bi-check2-circle"></i></div>
                    <div>
                        <h3>Guest features</h3>
                        <p>Home page, contact page, room detail page, and public navigation completed.</p>
                    </div>
                </div>

                <div class="release-item">
                    <div class="release-item__icon"><i class="bi bi-check2-circle"></i></div>
                    <div>
                        <h3>Tenant features</h3>
                        <p>My room, bills, contracts, utility usage, maintenance requests, and payment history implemented.</p>
                    </div>
                </div>

                <div class="release-item">
                    <div class="release-item__icon"><i class="bi bi-check2-circle"></i></div>
                    <div>
                        <h3>Manager features</h3>
                        <p>Manage rooms, tenants, contracts, bills, maintenance, and utilities supported.</p>
                    </div>
                </div>

                <div class="release-item">
                    <div class="release-item__icon"><i class="bi bi-check2-circle"></i></div>
                    <div>
                        <h3>Admin features</h3>
                        <p>Account management, room administration, contract overview, and dashboard modules available.</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="news-section">
            <div class="news-section__heading">
                <span class="news-tag">Upcoming</span>
                <h2>Next possible improvements</h2>
            </div>

            <div class="upcoming-grid">
                <div class="upcoming-card">
                    <i class="bi bi-bar-chart-line"></i>
                    <h3>Dashboard Analytics</h3>
                    <p>More visual statistics for occupancy, revenue, and contract status.</p>
                </div>

                <div class="upcoming-card">
                    <i class="bi bi-bell"></i>
                    <h3>Notifications</h3>
                    <p>Reminder and alert features for bills, contracts, and maintenance updates.</p>
                </div>

                <div class="upcoming-card">
                    <i class="bi bi-phone"></i>
                    <h3>Mobile Optimization</h3>
                    <p>Further responsive enhancement for better experience on small devices.</p>
                </div>
            </div>
        </section>

    </div>

</t:layout>