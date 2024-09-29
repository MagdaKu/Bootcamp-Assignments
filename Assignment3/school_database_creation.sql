CREATE DATABASE School;
USE School;

-- database School, consisting of 5 tables - students with their personal data, parents and their contact data, 
-- student_parent to show relations between students and parents, teachers with their personal data 
-- and grades with students' results

CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(30) NOT NULL,
    LastName VARCHAR(30) NOT NULL,
    Gender CHAR(1) NOT NULL, CHECK (Gender IN ('F', 'M')),
    DateOfBirth DATE NOT NULL,
    GradeLevel INT NOT NULL,
    Email VARCHAR(30) UNIQUE ) ;
    
    
INSERT INTO Students(FirstName, LastName, Gender, DateOfBirth, GradeLevel, Email)
VALUES
('Megan', 'Aguilare', 'F', '2007-03-14', 11, 'megan.aguilare@school.com'),
('Nicole', 'Welch', 'F', '2006-07-25', 12, 'nicole.welch@school.com'),
('Tia', 'Johnson', 'F', '2008-02-09', 10, 'tia.johnson@school.com'),
('Linda', 'Donnelly', 'F', '2005-11-22', 12, 'linda.donnelly@school.com'),
('Steve', 'Lucas', 'M', '2007-04-10', 11, 'steve.lucas@school.com'),
('Isaac', 'Knight', 'M', '2006-06-17', 12, 'isaac.knight@school.com'),
('Rihanna', 'Gray', 'F', '2008-01-30', 10, 'rihanna.gray@school.com'),
('Maddie', 'Cantrell', 'F', '2007-08-05', 11, 'maddie.cantrell@school.com'),
('Jonas', 'Kim', 'M', '2009-04-18', 9, 'jonas.kim@school.com'),
('Jerome', 'Dickson', 'M', '2005-12-28', 12, 'jerome.dickson@school.com'),
('Frank', 'Dickson', 'M', '2007-12-03', 11, 'frank.dickson@school.com'),
('Celia', 'Holden', 'F', '2008-10-12', 10, 'celia.holden@school.com');

    
CREATE TABLE Parents (
    ParentID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(30) NOT NULL,
    LastName VARCHAR(30) NOT NULL,
    PhoneNumber VARCHAR(9) UNIQUE,
    Email VARCHAR(30) UNIQUE);
    
INSERT INTO Parents (FirstName, LastName, PhoneNumber, Email)
VALUES
('John', 'Aguilare', '523456789', 'john.aguilare@parent.com'),
('Sarah', 'Aguilare', '922658821', 'sarah.aguilare@parent.com'),
('Mark', 'Welch', '456947238', 'mark.welch@parent.com'),
('Michelle', 'Johnson', '234102191', 'michelle.johnson@parent.com'),
('David', 'Donnelly', '349931912', 'david.donnelly@parent.com'),
('Laura', 'Donnelly', '555891254', 'laura.donnelly@parent.com'),
('Paul', 'Lucas', '678001345', 'paul.lucas@parent.com'),
('Linda', 'Lucas', '788232456', 'linda.lucas@parent.com'),
('James', 'Knight', '898832467', 'james.knight@parent.com'),
('Anna', 'Knight', '900239678', 'anna.knight@parent.com'),
('Robert', 'Gray', '128810256', 'robert.gray@parent.com'),
('Sophia', 'Cantrell', '235546567', 'sophia.cantrell@parent.com'),
('Michael', 'Kim', '345004078', 'michael.kim@parent.com'),
('Thomas', 'Dickson', '456000369', 'thomas.dickson@parent.com'),
('Emily', 'Dickson', '561114891', 'emily.dickson@parent.com'),
('William', 'Holden', '678323712', 'william.holden@parent.com'),
('Jennifer', 'Holden', '789123123', 'jennifer.holden@parent.com');
    
    
CREATE TABLE Teachers (
    TeacherID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(30) NOT NULL,
    LastName VARCHAR(30) NOT NULL,
    SubjectName  VARCHAR(30),
    PhoneNumber VARCHAR(9) UNIQUE,
    Email VARCHAR(30) UNIQUE,
    HireDate DATE) ;
    
    
INSERT INTO Teachers (FirstName, LastName, SubjectName, PhoneNumber, Email, HireDate)
VALUES
('Emily', 'Collins', 'Mathematics', '345546789', 'emily.collins@teacher.com', '1994-09-01'),
('Daniel', 'Smith', 'History', '234502391', 'daniel.smith@teacher.com', '2001-08-30'),
('Laura', 'Bennett', 'English', '459678912', 'laura.bennett@teacher.com', '2010-09-02'),
('James', 'Turner', 'Biology', '400289123', 'james.turner@teacher.com', '2023-04-15'),
('Sophia', 'White', 'Chemistry', '567890274', 'sophia.white@teacher.com', '2015-08-29'),
('Michael', 'Lee', 'Physics', '678919525', 'michael.lee@teacher.com', '1990-09-05'),
('Rachel', 'Harris', 'Art', '789144256', 'rachel.harris@teacher.com', '2020-09-01'),
('Andrew', 'Clark', 'Physical Education', '899183567', 'andrew.clark@teacher.com', '2022-08-31');
    
CREATE TABLE Grades (
    GradeID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT NOT NULL,
    TeacherID INT NOT NULL,
    Grade FLOAT(2),
    Date DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (TeacherID) REFERENCES Teachers(TeacherID));
    

INSERT INTO Grades (StudentID, TeacherID, Grade, Date) VALUES
(1, 1, 4.5, '2023-09-15'),
(1, 2, 3.0, '2023-11-03'),
(1, 4, 4.0, '2024-02-18'),
(1, 4, 3.5, '2024-03-25'),
(1, 5, 4.0, '2024-05-10'),
(2, 1, 5.0, '2023-10-12'),
(2, 2, 4.0, '2024-01-10'),
(2, 3, 4.5, '2024-02-05'),
(2, 6, 5.0, '2024-04-15'),
(2, 2, 3.0, '2024-05-22'),
(3, 2, 3.5, '2023-10-29'),
(3, 3, 4.0, '2024-02-14'),
(3, 1, 2.5, '2024-04-08'),
(3, 7, 4.0, '2024-05-03'),
(4, 1, 2.5, '2023-11-07'),
(4, 4, 3.0, '2024-03-01'),
(4, 6, 3.5, '2024-04-12'),
(4, 3, 1.0, '2024-05-25'),
(5, 5, 4.0, '2023-12-19'),
(5, 6, 3.5, '2024-01-25'),
(5, 2, 5.0, '2024-03-10'),
(5, 1, 2.5, '2024-04-02'),
(5, 3, 3.0, '2024-05-12'),
(5, 4, 4.0, '2024-06-05'),
(6, 7, 5.0, '2023-09-25'),
(6, 3, 3.5, '2024-05-02'),
(6, 4, 4.5, '2024-02-13'),
(6, 2, 3.0, '2024-01-19'),
(6, 1, 5.0, '2024-04-21'),
(6, 5, 2.0, '2024-05-15'),
(7, 3, 2.0, '2023-11-18'),
(7, 6, 3.5, '2024-02-26'),
(7, 6, 1.0, '2024-04-18'),
(7, 2, 2.5, '2024-03-29'),
(8, 2, 4.5, '2023-12-05'),
(8, 4, 4.0, '2024-04-15'),
(8, 3, 5.0, '2024-02-22'),
(8, 8, 4.5, '2024-03-28'),
(8, 6, 5.0, '2024-05-07'),
(9, 3, 3.5, '2023-11-11'),
(9, 5, 4.5, '2024-02-20'),
(9, 2, 4.0, '2024-03-25'),
(9, 1, 1.0, '2024-04-10'),
(9, 4, 3.5, '2024-05-22'),
(9, 6, 4.0, '2024-06-03'),
(10, 3, 2.0, '2023-12-20'),
(10, 3, 3.5, '2024-05-05'),
(10, 1, 3.0, '2024-02-28'),
(10, 4, 2.5, '2024-03-15'),
(10, 5, 4.0, '2024-04-18'),
(11, 2, 4.0, '2023-09-29'),
(11, 1, 3.5, '2024-04-03'),
(11, 3, 3.0, '2024-05-18'),
(12, 3, 4.0, '2023-10-10'),
(12, 1, 2.5, '2024-01-15'),
(12, 4, 4.0, '2024-03-01'),
(12, 2, 3.5, '2024-02-05'),
(12, 5, 4.5, '2024-04-12'),
(12, 6, 3.0, '2024-05-25');
    
CREATE TABLE Student_Parent(
    StudentID INT NOT NULL,
    ParentID INT NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (ParentID) REFERENCES Parents(ParentID));
    
INSERT INTO Student_Parent (StudentID, ParentID) VALUES
(1, 1), (1, 2),  
(2, 3),          
(3, 4),         
(4, 5), (4, 6), 
(5, 7), (5, 8),  
(6, 9), (6, 10), 
(7, 11),         
(8, 12),        
(9, 13),         
(10, 14), (10, 15), 
(11, 14), (11, 15), 
(12, 16), (12, 17); 


