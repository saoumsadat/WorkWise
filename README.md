# WorkWise

WorkWise is a university–job matching platform designed around a **skill-based approach**.  
The system connects **students, universities, and employers** while incorporating **social contribution points** to promote socially impactful employment.

This repository currently focuses on the **frontend foundation** of the system.

---

## Project Overview

- Universities offer courses that map to generic courses and produce skills
- Students acquire skills through courses
- Employers (clients) post jobs with skill requirements
- University administrators assign **social contribution points** to jobs
- Students can view jobs, evaluate salary + social impact, and apply

---

## Tech Stack (Current)

### Frontend
- HTML
- CSS
- Vanilla JavaScript

### Backend (Planned)
- Node.js
- Relational Database (MariaDB / MySQL)
- phpMyAdmin for database management

> No frontend frameworks are used intentionally to keep the system simple, transparent, and easy to integrate with the database later.

---

## Project Structure

workwise-frontend/
│
├── index.html # Landing page (role selection)
├── student.html # Student dashboard
├── client.html # Client dashboard
├── admin.html # University admin dashboard
│
├── css/
│ └── style.css # Shared styles
│
└── js/
└── main.js # Frontend logic for all roles

---

## Current Features (Completed)

### Landing Page
- Role-based navigation:
  - Student
  - Client (Employer)
  - University Admin

### Student Dashboard
- Displays student information:
  - User ID
  - Student ID
  - Name
  - Email
  - Major
- Displays available jobs with:
  - Job title
  - Salary
  - Required skills
  - **Social contribution points**
  - Application status
- Apply button:
  - Updates UI state
  - Prevents duplicate applications

### Client Dashboard
- Displays client information:
  - User ID
  - Company name
  - Industry
  - Email
- Displays jobs posted by the client
- Uses the same job card layout as the student view

### University Admin Dashboard
- Displays admin information:
  - User ID
  - Name
  - University
  - Email
- Displays jobs with assigned **social contribution points**

### UI Design
- Consistent job card layout across all roles
- Shared styling using reusable CSS classes
- Clear separation of role-based views

> All data shown is currently **mock data** (frontend-only).

---

## Current Status

- Frontend structure and workflows are **complete**
- All three user roles are implemented
- UI aligns directly with the ER diagram and relational schema
- Backend and database integration **not started yet** (planned)

---

## Next Steps

- Client: Job posting form
- Admin: Assign/edit social contribution points
- Student: Application history page
- Backend API using Node.js
- Database integration (MariaDB)
- Stored procedures, triggers, and audit logging

---

## Contribution Notes

- Please do not restructure folders without discussion
- Avoid adding frameworks unless agreed upon
- Current goal was to finalize **UI + workflows** before backend integration

---

## License

This project is for academic purposes.
