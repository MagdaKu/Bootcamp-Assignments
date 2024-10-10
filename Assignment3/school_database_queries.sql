#A file with queries and possible scenarios in which we could use them

#we want to find three students with the best average grade
SELECT CONCAT(s.FirstName, " ", s.LastName) AS Student, ROUND(AVG(g.grade), 2) AS average_grade FROM students AS s INNER JOIN 
grades AS g ON s.StudentID = g.StudentID  GROUP BY s.StudentID ORDER BY average_grade DESC LIMIT 3 ;


#we want to write to parents, whose children got a grade 1, so we need their email
SELECT CONCAT(s.FirstName, " ", s.LastName) AS Student, CONCAT(p.FirstName, " ", p.LastName) AS Parent, p.Email 
FROM parents AS p JOIN student_parent AS sp ON p.parentID = sp.parentID 
INNER JOIN students AS s ON s.StudentID = sp.StudentID INNER JOIN grades AS g on g.StudentID = 
s.StudentID WHERE g.Grade = 1.0;


#we want to check for how long our teachers have been hired
SELECT CONCAT(t.FirstName, " ", t.LastName) AS Teacher, TIMESTAMPDIFF(YEAR, t.HireDate, CURDATE()) AS 
Years_Hired FROM Teachers AS t ORDER BY Years_Hired DESC;


#we want to know who is over 18 years old and get their email
SELECT CONCAT(s.FirstName, " ", s.LastName) AS StudentOver18, s.Email FROM Students AS s
WHERE TIMESTAMPDIFF(YEAR, s.DateOfBirth, CURDATE()) >= 18;


#we want to see the number of grades given by each teacher and their average
SELECT CONCAT(t.FirstName, " ", t.LastName) AS Teacher, t.SubjectName, COUNT(g.Grade) AS Number_of_grades, ROUND(AVG(g.Grade), 2)
AS Average FROM  teachers AS t INNER JOIN grades AS g ON t.TeacherID = g.TeacherID 
GROUP BY t.TeacherID ORDER BY Average;


#we create a stored procedure to get a view of all students' average grades - it may come in handy in various cases. 
#To ensure that we can always use it, first we drop the view (if it exists) and then create a new one

DELIMITER //
CREATE PROCEDURE CreateViewWithAverages()
BEGIN
DROP VIEW IF EXISTS average_table ;
CREATE VIEW average_table AS SELECT s.StudentID, CONCAT(s.FirstName, " ", s.LastName) AS Student, s.GradeLevel, 
ROUND(AVG(g.grade), 2) AS average_grade FROM students AS s INNER JOIN grades 
AS g ON s.StudentID = g.StudentID GROUP BY s.StudentID;
END //
DELIMITER ;
CALL CreateViewWithAverages();

#we want to find the best student in every grade using the view from stored procedure
CALL CreateViewWithAverages();
SELECT CONCAT(s.FirstName, " ", s.LastName) AS Student_With_Best_Average, s.GradeLevel, ROUND(AVG(g.Grade), 2) AS Average
FROM students AS s INNER JOIN grades AS g ON s.StudentID = g.StudentID
GROUP BY s.StudentID, s.GradeLevel
HAVING  Average = (SELECT  MAX(average_table.average_grade) FROM  average_table
        WHERE  average_table.StudentID IN ( SELECT students.StudentID FROM students 
                WHERE students.GradeLevel = s.GradeLevel)) ORDER BY s.GradeLevel;



#we want to delete one grade
#DELETE FROM grades WHERE GradeID = 4;



#Additional feature - event
#Every year on the 1st of September, students receive a welcoming email. This event itself does not send the
#email, but gives the necessary data to use later. It creates a table with the messages that we want to send to each student.

DELIMITER //
CREATE EVENT StartOfTheSchool
ON SCHEDULE  EVERY 1 YEAR  STARTS '2024-09-01 08:00:00'
DO 
BEGIN
	DROP TABLE IF EXISTS student_messages; 
	CREATE TABLE student_messages (
		id INT AUTO_INCREMENT PRIMARY KEY,
		email VARCHAR(255),
		message TEXT);
    INSERT INTO student_messages (email, message)
    SELECT s.Email, CONCAT('Hello ', s.FirstName, ' ', s.LastName, ',\n as you start your ', s.GradeLevel, 'th grade,
    we wish you all the best in the upcoming academic year!')
    AS message     FROM students AS s;
END //
DELIMITER ;
