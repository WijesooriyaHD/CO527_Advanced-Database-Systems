
/*        E/17/407   Lab05       */
					


                             /* .......................   Exercise  .............................     */
                             
/* Q3 */
/* Create a new user ‘user1’ within the MySQL shell. */

CREATE USER 'user1'@'localhost' IDENTIFIED BY 'password1';


/* Q4 */
/* Login to MySQL with a new user account and password and see if the new user
has any authorities or privileges to the database. */

use company_security;

/* Q5 */
/* Make sure the new user has only read only permission to ‘Employee’ table. */

GRANT SELECT 
ON company_security.employee
TO 'user1'@'localhost';


/* Q6 */
/* Now allow ‘user1’ to query the followings: SELECT * FROM Employee; INSERT 
into Employee(...)VALUES(...). What happens? Fix the problem*/

select * from employee;
INSERT INTO EMPLOYEE VALUES('Hasara','B','Smith',123456788,'1965-01-09','731 Fondren, Housten, TX','M', 30000,'333445555',5);
GRANT INSERT
ON company_security.employee
TO 'user1'@'localhost';

/* Q7 */
/* From user1 create a view WORKS ON1(Fname,Lname,Pno) on EMPLOYEE and 
WORKS ON. (Note: You will have to give permission to user1 on CREATE VIEW). 
Give another user ‘user2’ permission to select tuples from WORKS ON1(Note: 
user2 will not be able to see WORKS ON or EMPLOYEE). */

GRANT SELECT 
ON company_security.works_on
TO 'user1'@'localhost';

GRANT CREATE VIEW
ON company_security.*
TO 'user1'@'localhost';

CREATE VIEW WORKS_ON1 AS
SELECT employee.Fname,employee.Lname,works_on.Pno
FROM employee,works_on
WHERE employee.ssn=works_on.Essn;

CREATE USER 'user2'@'localhost' IDENTIFIED BY 'password2';

GRANT SELECT 
ON company_security.works_on1
TO 'user2'@'localhost';

/* Q8 */
 /* Select tuples from user2 account. What happens? */
 
 SELECT * FROM works_on1;

/* Q9 */
/* Remove privileges of user1 on WORKS ON and EMPLOYEE. Can user1 still access 
WORKS ON1? What happened to WORKS ON1? Why? */ 

REVOKE
SELECT
ON company_security.works_on
FROM 'user1'@'localhost';

REVOKE
SELECT
ON company_security.employee
FROM 'user1'@'localhost';

SELECT * FROM works_on1;


/*  .....................................  Assignment  ..................................................... */

use company_security;

CREATE USER 'A'@'localhost' IDENTIFIED BY 'passwordA';
CREATE USER 'B'@'localhost' IDENTIFIED BY 'passwordB';
CREATE USER 'C'@'localhost' IDENTIFIED BY 'passwordC';
CREATE USER 'D'@'localhost' IDENTIFIED BY 'passwordD';
CREATE USER 'E'@'localhost' IDENTIFIED BY 'passwordE';


/* i */
/* Account A can retrieve or modify any relation except DEPENDENT and can grant any of
these privileges to other users.*/

GRANT SELECT, UPDATE ON company_security.EMPLOYEE TO 'A'@'localhost' WITH GRANT OPTION;

GRANT SELECT, UPDATE ON company_security.DEPARTMENT TO 'A'@'localhost' WITH GRANT OPTION;

GRANT SELECT, UPDATE ON company_security.DEPT_LOCATIONS TO 'A'@'localhost' WITH GRANT OPTION;

GRANT SELECT, UPDATE ON company_security.PROJECT TO 'A'@'localhost' WITH GRANT OPTION;

GRANT SELECT, UPDATE ON company_security.WORKS_ON TO 'A'@'localhost' WITH GRANT OPTION;


/* ii */
/* Account B can retrieve all the attributes of EMPLOYEE and DEPARTMENT except for
Salary, Mgr ssn, and Mgr start date. */

CREATE VIEW empDetails AS
SELECT Fname, Minit, Lname, Ssn, Bdate, Address,sex
Supper_ssn,Dno
FROM EMPLOYEE;

GRANT SELECT ON empDetails
TO 'B'@'localhost';

CREATE VIEW deptDetails AS
SELECT Dname, Dnumber
FROM DEPARTMENT;

GRANT SELECT ON deptDetails
TO 'B'@'localhost';


/* iii */
/* Account C can retrieve or modify WORKS ON but can only retrieve the Fname, Minit,
Lname, and Ssn attributes of EMPLOYEE and the Pname and Pnumber attributes of
PROJECT. */

GRANT SELECT, UPDATE
ON WORKS_ON
TO 'C'@'localhost';

CREATE VIEW empd2 AS
SELECT Fname, Minit, Lname, Ssn
FROM EMPLOYEE;

GRANT SELECT ON empd2
TO 'C'@'localhost';

CREATE VIEW projd2 AS
SELECT Pname, Pnumber
FROM PROJECT;

GRANT SELECT ON projd2
TO 'C'@'localhost';


/* iv */
/* Account D can retrieve any attribute of EMPLOYEE or DEPENDENT and can modify
DEPENDENT. */

 
GRANT SELECT ON EMPLOYEE TO 'D'@'localhost';
GRANT SELECT ON DEPENDENT TO 'D'@'localhost';
GRANT UPDATE ON DEPENDENT TO 'D'@'localhost';


/* v */
/* Account E can retrieve any attribute of EMPLOYEE but only for EMPLOYEE tuples that
have Dno = 3. */

CREATE VIEW dno3_emp AS
SELECT * FROM EMPLOYEE
WHERE DNO = 3;
GRANT SELECT ON dno3_emp
TO 'E'@'localhost';








 










