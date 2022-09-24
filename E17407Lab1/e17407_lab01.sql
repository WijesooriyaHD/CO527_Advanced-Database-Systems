
/* E/17/407     Wijesooriya H.D */

/* Q1 */

CREATE DATABASE Company;

USE Company;

CREATE TABLE employees(

	emp_no INT ,
    birth_date DATE,
    first_name VARCHAR (14),
    last_name VARCHAR (16),
    sex ENUM('M','F'),
    hire_date DATE,
    
    PRIMARY KEY (emp_no)

);

CREATE TABLE  departments(

	dept_no CHAR(4),
    dept_name VARCHAR (40),
    
    PRIMARY KEY (dept_no)
    
);

CREATE TABLE dept_manager(

    emp_no INT,
	dept_no CHAR(4),
    from_date DATE,
    to_date date,
    
    PRIMARY KEY (emp_no,dept_no),
    
    FOREIGN KEY  (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY  (emp_no) REFERENCES employees(emp_no)
    
);


CREATE TABLE  dept_emp(

	emp_no INT,
    dept_no CHAR(4),
    from_date DATE,
    to_date DATE,
    
    PRIMARY KEY (emp_no,dept_no),
    
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);


CREATE TABLE  salaries(
    emp_no INT,
    salary INT,
    from_date DATE,
    to_date DATE,
    
    PRIMARY KEY (emp_no,from_date,to_date),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);


CREATE TABLE  titles(

	emp_no INT,
    title VARCHAR (50),
    from_date DATE,
    to_date DATE,
    
	PRIMARY KEY (emp_no,title,from_date,to_date),
    FOREIGN KEY(emp_no) REFERENCES employees(emp_no)
);


/* Q2 */
SELECT last_name,COUNT(last_name) AS last_name_count
FROM employees
GROUP BY last_name
ORDER BY last_name_count DESC
LIMIT 10;

/* Q3*/
SELECT  departments.dept_no AS 'Department_Number' ,
count(employees.emp_no) AS 'Number of Engineers'
FROM departments , dept_emp ,employees ,titles
WHERE departments.dept_no=dept_emp.dept_no AND 
dept_emp.emp_no=employees.emp_no AND
employees.emp_no=titles.emp_no AND 
titles.title='Engineer' AND
titles.to_date > curdate()
GROUP BY Department_Number
ORDER BY Department_Number ASC;


/* Q4 */
SELECT  dept_manager.emp_no,employees.first_name,
employees.last_name,employees.sex,
dept_manager.dept_no,titles.title
FROM employees,dept_manager,titles
WHERE  employees.sex='F' AND  
employees.emp_no=dept_manager.emp_no AND
dept_manager.emp_no=titles.emp_no AND
dept_manager.to_date >= curdate() AND
titles.to_date < curdate() AND
titles.title='Senior Engineer';

/* Q5 */
SELECT dept_emp.dept_no , titles.title
FROM employees,salaries,dept_emp,titles
WHERE employees.emp_no=salaries.emp_no AND 
salaries.salary>115000 AND
salaries.to_date >= curdate() AND
dept_emp.to_date >=curdate() AND
employees.emp_no=titles.emp_no AND 
employees.emp_no=dept_emp.emp_no
ORDER BY dept_emp.dept_no;

SELECT  dept_emp.dept_no AS 'Department_Number' , 
COUNT(dept_emp.emp_no) AS 'No of Employees'
FROM employees,salaries,dept_emp,titles,departments
WHERE employees.emp_no=salaries.emp_no AND 
salaries.salary>115000 AND 
salaries.to_date >= curdate() AND
dept_emp.to_date >=curdate() AND
employees.emp_no=titles.emp_no AND
employees.emp_no=dept_emp.emp_no
GROUP BY Department_Number
ORDER BY departments.dept_no ASC;


/* Q6*/
SELECT employees.first_name , employees.last_name , 
TIMESTAMPDIFF(YEAR,employees.birth_date,CURDATE()) AS age ,
TIMESTAMPDIFF(YEAR,employees.hire_date,dept_emp.to_date) as years_of_service ,
employees.hire_date AS joined_date
FROM employees,dept_emp
WHERE TIMESTAMPDIFF(YEAR,employees.birth_date,CURDATE()) > 50 AND
employees.emp_no=dept_emp.emp_no AND
TIMESTAMPDIFF(YEAR,employees.hire_date,dept_emp.to_date)>10;


/* Q7 */
SELECT employees.first_name , employees.last_name
FROM employees,departments,dept_emp
WHERE departments.dept_name!='Human Resources' AND 
departments.dept_no=dept_emp.dept_no AND
dept_emp.emp_no=employees.emp_no;


/* Q8 */
SELECT employees.first_name , employees.last_name
FROM employees,salaries
WHERE employees.emp_no IN
(SELECT salaries.emp_no FROM salaries )
AND salaries.salary > 
(SELECT MAX(salaries.salary) FROM
salaries,departments,dept_emp,employees
WHERE departments.dept_name='Finance' AND 
departments.dept_no=dept_emp.dept_no AND 
dept_emp.emp_no=employees.emp_no AND 
employees.emp_no=salaries.emp_no);
	

/* Q9 */
SELECT DISTINCT employees.first_name , employees.last_name
FROM employees,salaries
WHERE salaries.to_date >=curdate() AND 
employees.emp_no=salaries.emp_no AND 
salaries.salary > (SELECT AVG(salaries.salary) FROM salaries);



/* 10 */
SELECT ((SELECT AVG(salaries.salary) FROM salaries) -
(SELECT AVG(salaries.salary) FROM employees,salaries,titles 
WHERE titles.title='Senior Engineer' AND  
titles.emp_no=employees.emp_no AND employees.emp_no=salaries.emp_no)) AS diff;

/* 11 */
CREATE VIEW current_dept_emp (emp_no, current_department)
AS SELECT DISTINCT emp_no,dept_no FROM dept_emp WHERE to_date>=CURDATE();

SELECT DISTINCT emp_no,dept_no FROM dept_emp WHERE to_date>=CURDATE();


/* 12 */



/*13 */
DELIMITER $$
CREATE TRIGGER print_salary_change BEFORE UPDATE
ON salaries FOR EACH ROW
BEGIN

	SET new_salary = NEW.salary;
    SET old_salary = OLD.salary;
    SET difference = ABS(new_salary-old_salary);
    
END $$
DELIMITER ;


/*14*/ 
DELIMITER $$  
CREATE TRIGGER cause_an_error
BEFORE UPDATE  
ON salaries FOR EACH ROW  
BEGIN  
    DECLARE error_msg VARCHAR(255);  
    SET error_msg = ('The new salary cannot be grater than the 10% of the current salary' );  
    IF (new.salary - old.salary ) > ((old.salary/100)*10) THEN  
    SIGNAL SQLSTATE '45000'   
    SET MESSAGE_TEXT = error_msg;  
    END IF;  
END $$  
  
DELIMITER ;  

/* LAB 02 */

/* Q1 */

explain SELECT first_name
FROM employees
ORDER BY first_name ASC ;

/* Q2 */

CREATE INDEX fname_index ON 
Company.employees(first_name) ;

drop index fname_index on employees;

SHOW INDEX FROM dept_manager;

/* Q4 */
CREATE UNIQUE INDEX emp_uix ON
Company.employees(emp_no,first_name,last_name);

drop index emp_uix on employees;

SELECT emp_no,first_name,last_name
FROM employees;

/* Q5 */

CREATE INDEX deptno_index ON
Company.dept_manager(dept_no);

drop index deptno_index on dept_manager;

select distinct emp_no from dept_manager where from_date>=
'1985-01-01' and dept_no>= 'd005';

 select distinct emp_no from dept_manager where from_date>=
'1996-01-03' and dept_no>= 'd005';

select distinct emp_no from dept_manager where from_date>=
'1985-01-01' and dept_no<= 'd009';



/* ...............................  Lab 03  .......................................*/

/* Q1 */
explain SELECT * FROM departments WHERE dept_name = 'Finance';
 explain SELECT * FROM departments WHERE dept_no ='d002'; 

/*Q2 */
create table emplist select emp_no, first_name from employees;
create table titleperiod select emp_no, title, datediff(to_date, from_date) 
as period FROM titles;

EXPLAIN SELECT first_name , period
FROM emplist , titleperiod
WHERE emplist.emp_no=titleperiod.emp_no AND period > 4000;

/* Q3 */
CREATE UNIQUE INDEX emp_no_uni_index ON
Company.emplist(emp_no);

CREATE INDEX emp_no_index ON
Company.titleperiod(emp_no);

EXPLAIN SELECT first_name , period
FROM emplist , titleperiod
WHERE emplist.emp_no=titleperiod.emp_no AND period > 4000;

CREATE INDEX period_index ON
Company.titleperiod(period);

EXPLAIN SELECT first_name , period
FROM emplist , titleperiod
WHERE emplist.emp_no=titleperiod.emp_no AND period > 4000;

/* Q4 */
EXPLAIN SELECT first_name , period
FROM emplist , titleperiod
FORCE INDEX(emp_no_index)
WHERE emplist.emp_no=titleperiod.emp_no AND period > 4000;

EXPLAIN SELECT STRAIGHT_JOIN period , first_name 
FROM titleperiod ,emplist 
WHERE emplist.emp_no=titleperiod.emp_no AND period > 4000;



/* LAB 04 */

/* Q1 */
select * from salaries where emp_no=43624;

