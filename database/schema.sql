-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 21, 2025 at 06:08 AM
-- Server version: 12.1.2-MariaDB
-- PHP Version: 8.5.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `workwise`
--

-- --------------------------------------------------------

--
-- Table structure for table `Application`
--

DROP TABLE IF EXISTS `Application`;
CREATE TABLE `Application` (
  `student_id` int(11) NOT NULL,
  `job_id` int(11) NOT NULL,
  `application_no` int(11) NOT NULL,
  `apply_date` date DEFAULT NULL,
  `status` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Application`
--

INSERT INTO `Application` (`student_id`, `job_id`, `application_no`, `apply_date`, `status`) VALUES
(1, 1, 1, '2025-01-05', 'Applied'),
(1, 4, 1, '2025-01-06', 'Hired'),
(2, 1, 1, '2025-01-06', 'Shortlisted'),
(2, 10, 1, '2025-01-07', 'Applied'),
(3, 2, 1, '2025-01-06', 'Hired'),
(3, 6, 1, '2025-01-08', 'Applied'),
(4, 4, 1, '2025-01-05', 'Applied'),
(4, 9, 1, '2025-01-09', 'Shortlisted'),
(5, 3, 1, '2025-01-07', 'Hired'),
(5, 5, 1, '2025-01-08', 'Applied');

-- --------------------------------------------------------

--
-- Table structure for table `AuditLog`
--

DROP TABLE IF EXISTS `AuditLog`;
CREATE TABLE `AuditLog` (
  `log_id` int(11) NOT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  `operation_type` varchar(20) DEFAULT NULL,
  `entity_name` varchar(100) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Client`
--

DROP TABLE IF EXISTS `Client`;
CREATE TABLE `Client` (
  `user_id` int(11) NOT NULL,
  `company_name` varchar(150) DEFAULT NULL,
  `industry` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Client`
--

INSERT INTO `Client` (`user_id`, `company_name`, `industry`) VALUES
(8, 'Campus Events BD', 'Event Management'),
(9, 'Tech Support Dhaka', 'IT Support'),
(10, 'SurveyWorks BD', 'Survey & Research'),
(11, 'Green Campus Initiative', 'Community Service'),
(12, 'Library Assist Services', 'Education Support');

-- --------------------------------------------------------

--
-- Table structure for table `Generic_Course`
--

DROP TABLE IF EXISTS `Generic_Course`;
CREATE TABLE `Generic_Course` (
  `generic_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Generic_Course`
--

INSERT INTO `Generic_Course` (`generic_id`, `name`) VALUES
(1, 'Basic Computing'),
(2, 'Communication Skills'),
(3, 'Event Management'),
(4, 'Data Collection'),
(5, 'Library Assistance'),
(6, 'Office Support'),
(7, 'IT Fundamentals'),
(8, 'Research Methods'),
(9, 'Customer Handling'),
(10, 'Environmental Awareness');

-- --------------------------------------------------------

--
-- Table structure for table `Job`
--

DROP TABLE IF EXISTS `Job`;
CREATE TABLE `Job` (
  `job_id` int(11) NOT NULL,
  `job_title` varchar(150) NOT NULL,
  `job_description` text DEFAULT NULL,
  `salary` decimal(10,2) DEFAULT NULL,
  `social_contribution_points` int(11) DEFAULT NULL,
  `admin_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Job`
--

INSERT INTO `Job` (`job_id`, `job_title`, `job_description`, `salary`, `social_contribution_points`, `admin_id`, `client_id`) VALUES
(1, 'Event Volunteer', 'Help manage BRAC events', 3000.00, 8, 6, 8),
(2, 'Survey Assistant', 'Conduct student surveys', 2500.00, 7, 7, 10),
(3, 'Library Helper', 'Assist library staff', 3500.00, 6, 6, 12),
(4, 'IT Lab Helper', 'Support computer lab', 4500.00, 5, 6, 9),
(5, 'Office Assistant', 'Department paperwork help', 4000.00, 6, 7, 11),
(6, 'Data Entry Operator', 'Enter research data', 3000.00, 5, 7, 10),
(7, 'Green Campus Volunteer', 'Tree plantation drive', 2000.00, 9, 6, 11),
(8, 'Reception Support', 'Front desk assistance', 3500.00, 6, 7, 9),
(9, 'Research Helper', 'Assist faculty research', 5000.00, 7, 7, 10),
(10, 'Event Setup Crew', 'Stage and logistics setup', 3000.00, 6, 6, 8);

-- --------------------------------------------------------

--
-- Table structure for table `Payment`
--

DROP TABLE IF EXISTS `Payment`;
CREATE TABLE `Payment` (
  `payment_id` int(11) NOT NULL,
  `payment_date` int(11) DEFAULT NULL,
  `payment_month` int(11) DEFAULT NULL,
  `payment_year` int(11) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `status` varchar(30) DEFAULT NULL,
  `application_student_id` int(11) DEFAULT NULL,
  `application_job_id` int(11) DEFAULT NULL,
  `application_no` int(11) DEFAULT NULL,
  `student_id` int(11) DEFAULT NULL,
  `client_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Payment`
--

INSERT INTO `Payment` (`payment_id`, `payment_date`, `payment_month`, `payment_year`, `amount`, `status`, `application_student_id`, `application_job_id`, `application_no`, `student_id`, `client_id`) VALUES
(11, 31, 1, 2025, 4500.00, 'Paid', 1, 4, 1, 1, 9),
(12, 31, 1, 2025, 2500.00, 'Paid', 3, 2, 1, 3, 10),
(13, 31, 1, 2025, 3500.00, 'Paid', 5, 3, 1, 5, 12),
(14, 28, 2, 2025, 4500.00, 'Paid', 1, 4, 1, 1, 9),
(15, 28, 2, 2025, 2500.00, 'Paid', 3, 2, 1, 3, 10),
(16, 28, 2, 2025, 3500.00, 'Paid', 5, 3, 1, 5, 12);

-- --------------------------------------------------------

--
-- Table structure for table `Produces`
--

DROP TABLE IF EXISTS `Produces`;
CREATE TABLE `Produces` (
  `generic_id` int(11) NOT NULL,
  `skill_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Produces`
--

INSERT INTO `Produces` (`generic_id`, `skill_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(10, 3),
(1, 4),
(7, 4),
(4, 5),
(5, 6),
(6, 7),
(4, 8),
(8, 8),
(2, 9),
(9, 9),
(3, 10);

-- --------------------------------------------------------

--
-- Table structure for table `Requires`
--

DROP TABLE IF EXISTS `Requires`;
CREATE TABLE `Requires` (
  `job_id` int(11) NOT NULL,
  `skill_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Requires`
--

INSERT INTO `Requires` (`job_id`, `skill_id`) VALUES
(6, 1),
(1, 3),
(7, 3),
(4, 4),
(2, 5),
(3, 6),
(5, 7),
(9, 8),
(8, 9),
(1, 10),
(10, 10);

-- --------------------------------------------------------

--
-- Table structure for table `Skill`
--

DROP TABLE IF EXISTS `Skill`;
CREATE TABLE `Skill` (
  `skill_id` int(11) NOT NULL,
  `skill_name` varchar(100) NOT NULL,
  `skill_description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Skill`
--

INSERT INTO `Skill` (`skill_id`, `skill_name`, `skill_description`) VALUES
(1, 'Data Entry', 'Entering and managing records'),
(2, 'Public Speaking', 'Speaking to groups'),
(3, 'Teamwork', 'Working in teams'),
(4, 'Basic IT Support', 'Solving simple IT issues'),
(5, 'Survey Handling', 'Collecting survey responses'),
(6, 'Library Management', 'Book handling and cataloging'),
(7, 'Office Assistance', 'Clerical support work'),
(8, 'Research Assistance', 'Helping in research tasks'),
(9, 'Customer Support', 'Handling people politely'),
(10, 'Event Coordination', 'Managing events');

-- --------------------------------------------------------

--
-- Table structure for table `Student`
--

DROP TABLE IF EXISTS `Student`;
CREATE TABLE `Student` (
  `user_id` int(11) NOT NULL,
  `student_id` varchar(20) NOT NULL,
  `major` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Student`
--

INSERT INTO `Student` (`user_id`, `student_id`, `major`) VALUES
(1, 'BRAC-S-001', 'CSE'),
(2, 'BRAC-S-002', 'BBA'),
(3, 'DU-S-003', 'Sociology'),
(4, 'BUET-S-004', 'EEE'),
(5, 'NSU-S-005', 'CSE');

-- --------------------------------------------------------

--
-- Table structure for table `Takes`
--

DROP TABLE IF EXISTS `Takes`;
CREATE TABLE `Takes` (
  `student_id` int(11) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `semester` varchar(20) DEFAULT NULL,
  `grade` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Takes`
--

INSERT INTO `Takes` (`student_id`, `course_code`, `semester`, `grade`) VALUES
(1, 'BUS201', 'Spring 2025', 'B'),
(1, 'CSE110', 'Spring 2025', 'A'),
(2, 'CSR101', 'Spring 2025', 'A'),
(2, 'EVT101', 'Spring 2025', 'A'),
(3, 'RES300', 'Spring 2025', 'A'),
(3, 'SOC210', 'Spring 2025', 'B'),
(4, 'CSE120', 'Spring 2025', 'A'),
(4, 'ENV200', 'Spring 2025', 'B'),
(5, 'LIB100', 'Spring 2025', 'A'),
(5, 'OFF101', 'Spring 2025', 'A');

-- --------------------------------------------------------

--
-- Table structure for table `University`
--

DROP TABLE IF EXISTS `University`;
CREATE TABLE `University` (
  `university_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `University`
--

INSERT INTO `University` (`university_id`, `name`) VALUES
(1, 'BRAC University'),
(2, 'University of Dhaka'),
(3, 'BUET'),
(4, 'North South University'),
(5, 'AIUB'),
(6, 'East West University'),
(7, 'Jahangirnagar University'),
(8, 'Daffodil International University'),
(9, 'Independent University Bangladesh'),
(10, 'United International University');

-- --------------------------------------------------------

--
-- Table structure for table `University_Admin`
--

DROP TABLE IF EXISTS `University_Admin`;
CREATE TABLE `University_Admin` (
  `user_id` int(11) NOT NULL,
  `university_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `University_Admin`
--

INSERT INTO `University_Admin` (`user_id`, `university_id`) VALUES
(6, 1),
(7, 2);

-- --------------------------------------------------------

--
-- Table structure for table `University_Course`
--

DROP TABLE IF EXISTS `University_Course`;
CREATE TABLE `University_Course` (
  `course_code` varchar(20) NOT NULL,
  `course_title` varchar(150) NOT NULL,
  `university_id` int(11) NOT NULL,
  `generic_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `University_Course`
--

INSERT INTO `University_Course` (`course_code`, `course_title`, `university_id`, `generic_id`) VALUES
('BUS201', 'Business Communication', 1, 2),
('CSE110', 'Intro to Computing', 1, 1),
('CSE120', 'IT Fundamentals', 5, 7),
('CSR101', 'Customer Relations', 6, 9),
('ENV200', 'Environmental Studies', 7, 10),
('EVT101', 'Event Basics', 1, 3),
('LIB100', 'Library Operations', 3, 5),
('OFF101', 'Office Practices', 4, 6),
('RES300', 'Research Methods', 2, 8),
('SOC210', 'Survey Methods', 2, 4);

-- --------------------------------------------------------

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
CREATE TABLE `User` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `User`
--

INSERT INTO `User` (`user_id`, `name`, `email`) VALUES
(1, 'Arafat Hossain', 'arafat@student.bracu.ac.bd'),
(2, 'Nusrat Jahan', 'nusrat@student.bracu.ac.bd'),
(3, 'Tanvir Ahmed', 'tanvir@student.du.ac.bd'),
(4, 'Mehedi Hasan', 'mehedi@student.buet.ac.bd'),
(5, 'Farzana Islam', 'farzana@student.nsu.ac.bd'),
(6, 'Dr. Rahman', 'rahman@bracu.ac.bd'),
(7, 'Dr. Sultana', 'sultana@du.ac.bd'),
(8, 'Campus Events BD', 'events@campusbd.com'),
(9, 'Tech Support Dhaka', 'support@techdhaka.com'),
(10, 'SurveyWorks BD', 'contact@surveyworksbd.com'),
(11, 'Green Campus Initiative', 'info@greencampus.org'),
(12, 'Library Assist Services', 'library@assist.com');

-- --------------------------------------------------------

--
-- Table structure for table `User_Phone`
--

DROP TABLE IF EXISTS `User_Phone`;
CREATE TABLE `User_Phone` (
  `user_id` int(11) NOT NULL,
  `phone` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `User_Phone`
--

INSERT INTO `User_Phone` (`user_id`, `phone`) VALUES
(1, '01710000001'),
(2, '01710000002'),
(3, '01710000003'),
(4, '01710000004'),
(5, '01710000005'),
(8, '01820000001'),
(9, '01820000002'),
(10, '01820000003');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Application`
--
ALTER TABLE `Application`
  ADD PRIMARY KEY (`student_id`,`job_id`,`application_no`),
  ADD KEY `job_id` (`job_id`);

--
-- Indexes for table `AuditLog`
--
ALTER TABLE `AuditLog`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `Client`
--
ALTER TABLE `Client`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `Generic_Course`
--
ALTER TABLE `Generic_Course`
  ADD PRIMARY KEY (`generic_id`);

--
-- Indexes for table `Job`
--
ALTER TABLE `Job`
  ADD PRIMARY KEY (`job_id`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `client_id` (`client_id`);

--
-- Indexes for table `Payment`
--
ALTER TABLE `Payment`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `application_student_id` (`application_student_id`,`application_job_id`,`application_no`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `client_id` (`client_id`);

--
-- Indexes for table `Produces`
--
ALTER TABLE `Produces`
  ADD PRIMARY KEY (`generic_id`,`skill_id`),
  ADD KEY `skill_id` (`skill_id`);

--
-- Indexes for table `Requires`
--
ALTER TABLE `Requires`
  ADD PRIMARY KEY (`job_id`,`skill_id`),
  ADD KEY `skill_id` (`skill_id`);

--
-- Indexes for table `Skill`
--
ALTER TABLE `Skill`
  ADD PRIMARY KEY (`skill_id`);

--
-- Indexes for table `Student`
--
ALTER TABLE `Student`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `student_id` (`student_id`);

--
-- Indexes for table `Takes`
--
ALTER TABLE `Takes`
  ADD PRIMARY KEY (`student_id`,`course_code`),
  ADD KEY `course_code` (`course_code`);

--
-- Indexes for table `University`
--
ALTER TABLE `University`
  ADD PRIMARY KEY (`university_id`);

--
-- Indexes for table `University_Admin`
--
ALTER TABLE `University_Admin`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `university_id` (`university_id`);

--
-- Indexes for table `University_Course`
--
ALTER TABLE `University_Course`
  ADD PRIMARY KEY (`course_code`),
  ADD KEY `university_id` (`university_id`),
  ADD KEY `generic_id` (`generic_id`);

--
-- Indexes for table `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `User_Phone`
--
ALTER TABLE `User_Phone`
  ADD PRIMARY KEY (`user_id`,`phone`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `AuditLog`
--
ALTER TABLE `AuditLog`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Generic_Course`
--
ALTER TABLE `Generic_Course`
  MODIFY `generic_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `Job`
--
ALTER TABLE `Job`
  MODIFY `job_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `Payment`
--
ALTER TABLE `Payment`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `Skill`
--
ALTER TABLE `Skill`
  MODIFY `skill_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `University`
--
ALTER TABLE `University`
  MODIFY `university_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `User`
--
ALTER TABLE `User`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Application`
--
ALTER TABLE `Application`
  ADD CONSTRAINT `1` FOREIGN KEY (`student_id`) REFERENCES `Student` (`user_id`),
  ADD CONSTRAINT `2` FOREIGN KEY (`job_id`) REFERENCES `Job` (`job_id`);

--
-- Constraints for table `AuditLog`
--
ALTER TABLE `AuditLog`
  ADD CONSTRAINT `1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`);

--
-- Constraints for table `Client`
--
ALTER TABLE `Client`
  ADD CONSTRAINT `1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `Job`
--
ALTER TABLE `Job`
  ADD CONSTRAINT `1` FOREIGN KEY (`admin_id`) REFERENCES `University_Admin` (`user_id`),
  ADD CONSTRAINT `2` FOREIGN KEY (`client_id`) REFERENCES `Client` (`user_id`);

--
-- Constraints for table `Payment`
--
ALTER TABLE `Payment`
  ADD CONSTRAINT `1` FOREIGN KEY (`application_student_id`,`application_job_id`,`application_no`) REFERENCES `Application` (`student_id`, `job_id`, `application_no`),
  ADD CONSTRAINT `2` FOREIGN KEY (`student_id`) REFERENCES `Student` (`user_id`),
  ADD CONSTRAINT `3` FOREIGN KEY (`client_id`) REFERENCES `Client` (`user_id`);

--
-- Constraints for table `Produces`
--
ALTER TABLE `Produces`
  ADD CONSTRAINT `1` FOREIGN KEY (`generic_id`) REFERENCES `Generic_Course` (`generic_id`),
  ADD CONSTRAINT `2` FOREIGN KEY (`skill_id`) REFERENCES `Skill` (`skill_id`);

--
-- Constraints for table `Requires`
--
ALTER TABLE `Requires`
  ADD CONSTRAINT `1` FOREIGN KEY (`job_id`) REFERENCES `Job` (`job_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `2` FOREIGN KEY (`skill_id`) REFERENCES `Skill` (`skill_id`);

--
-- Constraints for table `Student`
--
ALTER TABLE `Student`
  ADD CONSTRAINT `1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `Takes`
--
ALTER TABLE `Takes`
  ADD CONSTRAINT `1` FOREIGN KEY (`student_id`) REFERENCES `Student` (`user_id`),
  ADD CONSTRAINT `2` FOREIGN KEY (`course_code`) REFERENCES `University_Course` (`course_code`);

--
-- Constraints for table `University_Admin`
--
ALTER TABLE `University_Admin`
  ADD CONSTRAINT `1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `2` FOREIGN KEY (`university_id`) REFERENCES `University` (`university_id`);

--
-- Constraints for table `University_Course`
--
ALTER TABLE `University_Course`
  ADD CONSTRAINT `1` FOREIGN KEY (`university_id`) REFERENCES `University` (`university_id`),
  ADD CONSTRAINT `2` FOREIGN KEY (`generic_id`) REFERENCES `Generic_Course` (`generic_id`);

--
-- Constraints for table `User_Phone`
--
ALTER TABLE `User_Phone`
  ADD CONSTRAINT `1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
