# CSE370: Database Systems

## Project Report

**Project Title:** WorkWise – University-Centric Part-Time Job Management System  
**Course:** CSE370 – Database Systems  
**Semester:** Fall 2025  
**Prepared by:** Single Author Submission

---

## Table of Contents
1. Introduction  
2. Project Features  
3. ER/EER Diagram  
4. Schema Diagram  
5. Normalization  
6. Frontend Development  
7. Backend Development  
8. Source Code Repository  
9. Conclusion  
10. References

---

## 1. Introduction

The motivation behind building **WorkWise** was to address a common but often overlooked reality faced by university students: the need to take up "odd" or informal jobs to become financially self-sufficient. While such jobs play an important role in supporting students, they are frequently undervalued, unstructured, and disconnected from the academic ecosystem of universities.

This project was designed to create an **official, university-recognized platform** where students can access part-time and short-term jobs in a structured manner. By involving universities and administrators in the workflow, WorkWise aims to bring dignity, transparency, and legitimacy to these jobs. A key motivating feature of the system is the introduction of **social contribution points**, which incentivize students to engage in work that has positive social or community impact rather than viewing employment purely as a financial necessity.

Overall, the project was built to explore how a database-centric system can support social goals while solving a real-world problem faced by students.

---

## 2. Project Features

### Core Features
- Role-based access for **Student**, **Client**, and **University Admin**
- Job posting with required skills
- Eligibility-based job application and reapplication
- Admin-controlled social contribution point assignment
- Application review and decision workflow
- Automated monthly payment tracking
- Audit logging using database triggers

---

## 3. ER/EER Diagram

The ER/EER diagram illustrates the conceptual design of the WorkWise system. It includes entities such as User, Student, Client, University Admin, Job, Skill, Application, Payment, AuditLog, and several associative entities to model many-to-many relationships. The diagram also demonstrates specialization (User → Student/Client/Admin) and clearly defined cardinalities.

*(ER/EER diagram attached separately as provided)*

---

## 4. Schema Diagram

The schema diagram represents the relational mapping derived from the ER/EER diagram. Each entity is converted into a table with primary keys, foreign keys, and appropriate constraints. Junction tables are used to resolve many-to-many relationships such as job-skill requirements and student-course mappings.

*(Schema diagram attached separately as provided)*

---

## 5. Normalization

### First Normal Form (1NF)
The schema is in **1NF** as all attributes contain atomic values. Multivalued attributes, such as phone numbers, are handled using a separate table (`User_Phone`), ensuring no repeating groups exist.

### Second Normal Form (2NF)
The schema is in **2NF** because all non-key attributes are fully functionally dependent on the entire primary key. Composite keys appear only in associative tables (e.g., Application, Requires), and no partial dependencies exist.

### Third Normal Form (3NF)
The schema satisfies **3NF** as there are no transitive dependencies. Non-key attributes do not depend on other non-key attributes. For example, university details are stored separately from admin records, and payment details are isolated from job and application tables.

Overall, the database design adheres to proper normalization principles up to 3NF.

---

## 6. Frontend Development

The frontend of WorkWise is implemented using **HTML, CSS, and JavaScript**. Separate dashboard pages are created for students, clients, and administrators to ensure role-specific interaction.

### Key Frontend Components
- Login page with role validation
- Student dashboard for job browsing, applications, skills, and payments
- Client dashboard for job posting, application review, and payment management
- Admin dashboard for reviewing jobs and assigning social contribution points

The frontend communicates with the backend exclusively through RESTful API calls, ensuring a clean separation of concerns.

---

## 7. Backend Development

The backend is built using **Node.js with Express.js**, connected to a **MySQL/MariaDB** database.

### Backend Responsibilities
- Exposing REST APIs for all user roles
- Executing complex SQL queries and views
- Managing stored procedures for multi-step workflows
- Handling transactions with commit and rollback
- Enforcing business rules through database triggers

Stored procedures are used for operations such as job application, application review, job posting, and payment updates. Views simplify reporting and dashboard queries. Triggers automatically log important changes into the audit table.

---

## 8. Source Code Repository

The complete source code for this project is organized into separate folders for frontend, backend, and database components. The repository includes SQL scripts, backend API code, and frontend UI files.

**Repository:** (Public link to GitHub or Drive to be added by student)

---

## 9. Conclusion

Working on the WorkWise project was a valuable learning experience that bridged theoretical database concepts with practical system design. One of the main challenges faced during development was translating real-world workflows—such as job applications, reviews, and payments—into a consistent relational schema while maintaining data integrity and normalization.

Designing stored procedures, views, and triggers helped deepen the understanding of how business logic can be enforced directly at the database level rather than relying solely on application code. Integrating the frontend with backend APIs also highlighted the importance of clear data contracts and role-based access control.

Through this project, significant learning was gained in ER modeling, normalization, SQL querying, transaction management, and backend integration. In the future, the system can be improved by adding authentication mechanisms, scalability optimizations, richer analytics, and enhanced user interfaces. Overall, the project successfully met its goals and provided strong hands-on experience in database system development.

---

## 10. References

1. Elmasri, R., & Navathe, S. *Fundamentals of Database Systems*, Pearson Education.
2. MySQL Official Documentation – https://dev.mysql.com/doc/
3. MariaDB Documentation – https://mariadb.org/documentation/
4. Express.js Official Documentation – https://expressjs.com/
5. Node.js Documentation – https://nodejs.org/en/docs/
6. MDN Web Docs (JavaScript, HTML) – https://developer.mozilla.org/
7. Various online tutorials and blog posts related to SQL procedures, triggers, and database design used during development.

