<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<t:layout
    title="About Us - RentHouse"
    active="about"
    cssFile="${pageContext.request.contextPath}/assets/css/views/about.css"
    jsFile="${pageContext.request.contextPath}/assets/js/pages/about.js">

    <div class="about-page">

        <!-- HERO -->
        <section class="about-hero">
            <div class="about-hero__overlay"></div>

            <div class="about-hero__content">
                <div class="about-hero__left">
                    <span class="about-badge">
                        <i class="bi bi-mortarboard-fill"></i>
                        SWP391 Project • FPT University
                    </span>

                    <h1>About RentHouse Management</h1>

                    <p class="about-hero__desc">
                        RentHouse Management is a web-based rental house management system
                        developed for the SWP course at FPT University. The project aims
                        to help managers monitor rooms, tenants, contracts, billing,
                        utility services, and maintenance requests in a centralized,
                        organized, and user-friendly platform.
                    </p>

                    <div class="about-hero__actions">
                        <a href="${pageContext.request.contextPath}/home" class="about-btn about-btn--primary">
                            <i class="bi bi-house-door-fill"></i> Explore Home
                        </a>
                        <a href="#team-section" class="about-btn about-btn--secondary">
                            <i class="bi bi-people-fill"></i> Meet Our Team
                        </a>
                    </div>
                </div>

                <div class="about-hero__right">
                    <div class="about-stat-card stat-main">
                        <div class="about-stat-card__icon">
                            <i class="bi bi-buildings-fill"></i>
                        </div>
                        <div class="about-stat-card__value">113+</div>
                        <div class="about-stat-card__label">Managed Rooms</div>
                    </div>

                    <div class="about-stat-row">
                        <div class="about-stat-card">
                            <div class="about-stat-card__icon">
                                <i class="bi bi-people-fill"></i>
                            </div>
                            <div class="about-stat-card__value">6</div>
                            <div class="about-stat-card__label">Team Members</div>
                        </div>

                        <div class="about-stat-card">
                            <div class="about-stat-card__icon">
                                <i class="bi bi-code-slash"></i>
                            </div>
                            <div class="about-stat-card__value">JSP</div>
                            <div class="about-stat-card__label">Servlet Based</div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- OVERVIEW -->
        <section class="about-section">
            <div class="about-section__heading">
                <span class="about-section__tag">Project Overview</span>
                <h2>What does the system help manage?</h2>
                <p>
                    The system is designed to support rental house operations by improving
                    data organization, reducing manual work, and making the management process
                    more transparent and efficient.
                </p>
            </div>

            <div class="about-card-grid">
                <div class="about-feature-card">
                    <div class="about-feature-card__icon">
                        <i class="bi bi-door-open-fill"></i>
                    </div>
                    <h3>Room Management</h3>
                    <p>
                        Monitor room status, room area, floor, price, capacity,
                        and availability across the system.
                    </p>
                </div>

                <div class="about-feature-card">
                    <div class="about-feature-card__icon">
                        <i class="bi bi-person-vcard-fill"></i>
                    </div>
                    <h3>Tenant Management</h3>
                    <p>
                        Store tenant profiles, track account status, and manage
                        room assignments in a structured way.
                    </p>
                </div>

                <div class="about-feature-card">
                    <div class="about-feature-card__icon">
                        <i class="bi bi-file-earmark-text-fill"></i>
                    </div>
                    <h3>Contracts & Billing</h3>
                    <p>
                        Support contract lifecycle, monthly bills, payment tracking,
                        and rental records for both managers and tenants.
                    </p>
                </div>

                <div class="about-feature-card">
                    <div class="about-feature-card__icon">
                        <i class="bi bi-tools"></i>
                    </div>
                    <h3>Utilities & Maintenance</h3>
                    <p>
                        Handle utility usage and maintenance requests to improve
                        service quality and response time.
                    </p>
                </div>
            </div>
        </section>

        <!-- PROJECT INFO -->
        <section class="about-section about-section--soft">
            <div class="about-section__heading">
                <span class="about-section__tag">Academic Information</span>
                <h2>Project Details</h2>
                <p>
                    This page presents the project context, team information, and
                    technical orientation of the RentHouse Management System.
                </p>
            </div>

            <div class="about-info-grid">
                <div class="about-info-box">
                    <span class="about-info-box__label">Subject</span>
                    <strong>SWP391</strong>
                </div>

                <div class="about-info-box">
                    <span class="about-info-box__label">University</span>
                    <strong>FPT University</strong>
                </div>

                <div class="about-info-box">
                    <span class="about-info-box__label">Project Type</span>
                    <strong>Rental House Management System</strong>
                </div>

                <div class="about-info-box">
                    <span class="about-info-box__label">Architecture</span>
                    <strong>Java Servlet / JSP</strong>
                </div>

                <div class="about-info-box">
                    <span class="about-info-box__label">Users</span>
                    <strong>Guest • Tenant • Manager • Admin</strong>
                </div>

                <div class="about-info-box">
                    <span class="about-info-box__label">Development Mode</span>
                    <strong>Team Project</strong>
                </div>
            </div>
        </section>

        <!-- SYSTEM FLOW -->
        <section class="about-section">
            <div class="about-section__heading">
                <span class="about-section__tag">System Flow</span>
                <h2>How the platform works</h2>
            </div>

            <div class="about-timeline">
                <div class="about-timeline__item">
                    <div class="about-timeline__dot">1</div>
                    <div class="about-timeline__content">
                        <h3>Room Listing & Monitoring</h3>
                        <p>Managers create and maintain room data with status and pricing information.</p>
                    </div>
                </div>

                <div class="about-timeline__item">
                    <div class="about-timeline__dot">2</div>
                    <div class="about-timeline__content">
                        <h3>Tenant Registration</h3>
                        <p>Tenant accounts and personal information are stored and linked to rooms or contracts.</p>
                    </div>
                </div>

                <div class="about-timeline__item">
                    <div class="about-timeline__dot">3</div>
                    <div class="about-timeline__content">
                        <h3>Contract Management</h3>
                        <p>The system supports creating, confirming, extending, and tracking rental contracts.</p>
                    </div>
                </div>

                <div class="about-timeline__item">
                    <div class="about-timeline__dot">4</div>
                    <div class="about-timeline__content">
                        <h3>Billing & Utilities</h3>
                        <p>Monthly bills and utility usage can be managed and reviewed more conveniently.</p>
                    </div>
                </div>

                <div class="about-timeline__item">
                    <div class="about-timeline__dot">5</div>
                    <div class="about-timeline__content">
                        <h3>Maintenance Support</h3>
                        <p>Tenants can submit requests and managers can follow up on maintenance activities.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- TEAM -->
        <section class="about-section about-section--team" id="team-section">
            <div class="about-section__heading">
                <span class="about-section__tag">Our Team</span>
                <h2>Meet the project members</h2>
                <p>
                    This project was developed collaboratively by our team for the SWP391 course.
                </p>
            </div>

            <div class="team-grid">

                <div class="team-card">
                    <div class="team-card__avatar">N</div>
                    <h3>Dương Thiện Nhân</h3>
                    <span class="team-card__role">Team Member</span>
                    <p>Participated in analysis, implementation, and development of the rental house management system.</p>
                </div>

                <div class="team-card">
                    <div class="team-card__avatar">T</div>
                    <h3>Tô Thị Thảo Trang</h3>
                    <span class="team-card__role">Team Member</span>
                    <p>Contributed to project development, collaboration, and feature implementation for the system.</p>
                </div>

                <div class="team-card">
                    <div class="team-card__avatar">Ý</div>
                    <h3>Bùi Như Ý</h3>
                    <span class="team-card__role">Team Member</span>
                    <p>Supported analysis, design ideas, and implementation tasks throughout the project lifecycle.</p>
                </div>

                <div class="team-card">
                    <div class="team-card__avatar">K</div>
                    <h3>Trương Hoàng Khang</h3>
                    <span class="team-card__role">Team Member</span>
                    <p>Worked on project modules and contributed to the overall development and system completion.</p>
                </div>

                <div class="team-card">
                    <div class="team-card__avatar">T</div>
                    <h3>Đặng Hữu Thạnh</h3>
                    <span class="team-card__role">Team Member</span>
                    <p>Helped implement project functions and supported the team in system building activities.</p>
                </div>

                <div class="team-card">
                    <div class="team-card__avatar">L</div>
                    <h3>Nguyễn Hữu Lập</h3>
                    <span class="team-card__role">Team Member</span>
                    <p>Contributed to team development efforts and assisted with the implementation of project features.</p>
                </div>

            </div>
        </section>

        <!-- TECH STACK -->
        <section class="about-section about-section--soft">
            <div class="about-section__heading">
                <span class="about-section__tag">Technology Stack</span>
                <h2>Technologies used in the project</h2>
            </div>

            <div class="tech-stack">
                <span class="tech-badge">Java</span>
                <span class="tech-badge">Servlet</span>
                <span class="tech-badge">JSP</span>
                <span class="tech-badge">JSTL</span>
                <span class="tech-badge">Bootstrap</span>
                <span class="tech-badge">HTML/CSS</span>
                <span class="tech-badge">JavaScript</span>
                <span class="tech-badge">SQL Server</span>
                <span class="tech-badge">MVC Pattern</span>
            </div>
        </section>

        <!-- CLOSING -->
        <section class="about-closing">
            <div class="about-closing__box">
                <h2>Built for learning, designed for practical management</h2>
                <p>
                    RentHouse Management reflects our effort to apply software engineering
                    knowledge into a practical rental management scenario, combining usability,
                    structure, and maintainability in a web-based system.
                </p>
            </div>
        </section>

    </div>

</t:layout>