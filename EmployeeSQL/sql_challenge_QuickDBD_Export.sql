-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/OK97QS
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

CREATE TABLE "dept_managers" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" BIGINT   NOT NULL
);

CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_managers" ADD CONSTRAINT "fk_dept_managers_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_managers" ADD CONSTRAINT "fk_dept_managers_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

-- Need to amend database datestyle as it appears data is in MDY format. Errors encountered in employees table when trying to import with DMY format.
ALTER DATABASE "sql_challenge" SET datestyle TO "ISO, MDY";

-- Data Analysis:
-- List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT employees.emp_no, 
	employees.last_name,
	employees.first_name,
	employees.sex,
	salaries.salary
FROM employees
LEFT JOIN salaries
ON employees.emp_no = salaries.emp_no
ORDER BY emp_no;

-- List first name, last name, and hire date for employees who were hired in 1986.
SELECT employees.first_name,
	employees.last_name,
	employees.hire_date
FROM employees
WHERE DATE_PART('year',hire_date) = 1986
ORDER BY emp_no;

-- List the manager of each department with the following information: department number, 
-- department name, the manager's employee number, last name, first name.
SELECT dept_managers.dept_no, 
	departments.dept_name,
	dept_managers.emp_no,
	employees.last_name, 
	employees.first_name
FROM dept_managers
LEFT JOIN departments
ON dept_managers.dept_no = departments.dept_no
LEFT JOIN employees 
ON dept_managers.emp_no = employees.emp_no
ORDER BY emp_no;

-- List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT
	employees.emp_no,
	employees.last_name,
	employees.first_name,
	departments.dept_name
FROM employees 
INNER JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
INNER JOIN departments ON departments.dept_no = dept_emp.dept_no
ORDER BY emp_no;

-- List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT
	employees.first_name,
	employees.last_name,
	employees.sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%'
ORDER BY emp_no;

-- List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT 
	employees.emp_no, 
	employees.last_name, 
	employees.first_name,
	departments.dept_name
FROM employees 
LEFT JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no
INNER JOIN departments 
ON departments.dept_no = dept_emp.dept_no
WHERE departments.dept_name='Sales'
ORDER BY emp_no;

-- List all employees in the Sales and Development departments, including their employee number, 
-- last name, first name, and department name.
SELECT 
	employees.emp_no, 
	employees.last_name, 
	employees.first_name,
	departments.dept_name
FROM employees 
LEFT JOIN dept_emp 
ON employees.emp_no = dept_emp.emp_no
INNER JOIN departments 
ON departments.dept_no = dept_emp.dept_no
WHERE departments.dept_name in ('Sales', 'Development')
ORDER BY emp_no;

-- In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name, COUNT(*) AS freq_count
FROM employees
GROUP BY last_name
ORDER BY freq_count DESC;
