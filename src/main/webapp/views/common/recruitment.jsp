<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<t:layout
    title="Recruitment - RentHouse"
    active="recruit"
    cssFile="${pageContext.request.contextPath}/assets/css/views/recruitment.css"
    jsFile="${pageContext.request.contextPath}/assets/js/pages/recruitment.js">

    <div class="recruit-page">

        <section class="recruit-hero">
            <div class="recruit-hero__content">
                <span class="recruit-badge">
                    <i class="bi bi-briefcase-fill"></i>
                    Team Opportunities
                </span>
                <h1>Recruitment & Collaboration</h1>
                <p>
                    This page presents sample recruitment content for the RentHouse Management
                    project, showcasing possible team roles, collaboration opportunities,
                    and future development directions.
                </p>
            </div>
        </section>

        <section class="recruit-section">
            <div class="recruit-section__heading">
                <span class="recruit-tag">Why Join</span>
                <h2>Why work on this project?</h2>
                <p>
                    RentHouse Management is a practical academic system that combines
                    business process thinking, software engineering, and web development
                    into one complete rental management platform.
                </p>
            </div>

            <div class="recruit-benefit-grid">
                <div class="recruit-benefit-card">
                    <i class="bi bi-lightbulb-fill"></i>
                    <h3>Practical Experience</h3>
                    <p>Work on a real-world style management system with multiple roles and workflows.</p>
                </div>

                <div class="recruit-benefit-card">
                    <i class="bi bi-diagram-3-fill"></i>
                    <h3>Team Collaboration</h3>
                    <p>Develop communication, planning, and task coordination skills in a group environment.</p>
                </div>

                <div class="recruit-benefit-card">
                    <i class="bi bi-code-square"></i>
                    <h3>Technical Growth</h3>
                    <p>Practice Java Servlet/JSP, MVC architecture, database handling, and UI development.</p>
                </div>
            </div>
        </section>

        <section class="recruit-section recruit-section--soft">
            <div class="recruit-section__heading">
                <span class="recruit-tag">Open Roles</span>
                <h2>Sample positions in the project</h2>
            </div>

            <div class="job-grid">
                <div class="job-card">
                    <div class="job-card__top">
                        <h3>Frontend Developer</h3>
                        <span class="job-badge">UI/UX</span>
                    </div>
                    <p>Build and refine JSP pages, improve layout consistency, and enhance user experience.</p>
                    <ul>
                        <li>Work with JSP, HTML, CSS, Bootstrap</li>
                        <li>Improve page responsiveness</li>
                        <li>Polish dashboard and detail screens</li>
                    </ul>
                </div>

                <div class="job-card">
                    <div class="job-card__top">
                        <h3>Backend Developer</h3>
                        <span class="job-badge">Logic</span>
                    </div>
                    <p>Implement controllers, services, DAO logic, and support feature integration across modules.</p>
                    <ul>
                        <li>Develop with Servlet architecture</li>
                        <li>Handle business logic and flow</li>
                        <li>Connect database operations</li>
                    </ul>
                </div>

                <div class="job-card">
                    <div class="job-card__top">
                        <h3>Database Designer</h3>
                        <span class="job-badge">Data</span>
                    </div>
                    <p>Design and optimize the schema for rooms, tenants, contracts, payments, and maintenance data.</p>
                    <ul>
                        <li>Create structured data models</li>
                        <li>Support DAO queries</li>
                        <li>Maintain data consistency</li>
                    </ul>
                </div>

                <div class="job-card">
                    <div class="job-card__top">
                        <h3>Business Analyst / Tester</h3>
                        <span class="job-badge">QA</span>
                    </div>
                    <p>Review requirements, validate flows, and ensure the system meets practical management needs.</p>
                    <ul>
                        <li>Test major workflows</li>
                        <li>Write use cases and feedback</li>
                        <li>Support validation and refinement</li>
                    </ul>
                </div>
            </div>
        </section>

        <section class="recruit-section">
            <div class="recruit-section__heading">
                <span class="recruit-tag">Requirements</span>
                <h2>What we look for</h2>
            </div>

            <div class="requirement-list">
                <div class="requirement-item">
                    <i class="bi bi-check-circle-fill"></i>
                    <span>Basic understanding of Java web development</span>
                </div>
                <div class="requirement-item">
                    <i class="bi bi-check-circle-fill"></i>
                    <span>Ability to work in a collaborative team environment</span>
                </div>
                <div class="requirement-item">
                    <i class="bi bi-check-circle-fill"></i>
                    <span>Interest in software engineering and practical system design</span>
                </div>
                <div class="requirement-item">
                    <i class="bi bi-check-circle-fill"></i>
                    <span>Willingness to learn and improve during project development</span>
                </div>
            </div>
        </section>

        <section class="recruit-section recruit-section--cta">
            <div class="recruit-cta-box">
                <h2>Interested in this kind of project?</h2>
                <p>
                    Although this recruitment page is presented as part of the SWP391 project,
                    it demonstrates how the system can include company-style pages and public
                    information screens in a complete web application.
                </p>
                <div class="recruit-cta-actions">
                    <a href="${pageContext.request.contextPath}/about" class="recruit-btn recruit-btn--light">
                        <i class="bi bi-people-fill"></i> View Team
                    </a>
                    <a href="${pageContext.request.contextPath}/contact" class="recruit-btn recruit-btn--dark">
                        <i class="bi bi-envelope-fill"></i> Contact Us
                    </a>
                </div>
            </div>
        </section>

    </div>

</t:layout>