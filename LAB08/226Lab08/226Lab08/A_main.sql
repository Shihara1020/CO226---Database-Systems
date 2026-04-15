DROP DATABASE IF EXISTS E21Company;


CREATE DATABASE E21Company;
USE E21Company;

create table employees (
    emp_no int,
    birth_date date,
    first_name varchar(14),
    last_name varchar(16),
    sex enum("M","F"),
    hire_date date,
    primary key (emp_no)
);

create table departments (
    dept_no char(10),
    dept_name varchar(40),
    primary key(dept_no)
);

create table dept_manager (
    emp_no int,
    dept_no char(10),
    from_date date,
    to_date date,
    primary key (dept_no, emp_no),
    CONSTRAINT dept_manager_to_dept FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    CONSTRAINT fk2 FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

create table dept_emp (
    emp_no int,
    dept_no char(10),
    from_date date,
    to_date date,
    primary key (emp_no, dept_no),
    CONSTRAINT dept_no_to_dept_no FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    CONSTRAINT fk3 FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

create table titles(
    emp_no int,
    title varchar(50) ,
    from_date date,
    to_date date,
    primary key (title, emp_no),
    CONSTRAINT fk4 FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

create table salaries (
    emp_no int,
    salary int, 
    from_date date,
    to_date date,
    primary key (emp_no, from_date, to_date),
    CONSTRAINT fk5 FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);



source load_employees.sql
source load_departments.sql
source load_dept_emp.sql
source load_dept_manager.sql
source load_salaries1.sql
source load_salaries2.sql
source load_titles.sql

SELECT
  (SELECT COUNT(*) FROM employees) AS total_employees,
  (SELECT COUNT(*) FROM dept_manager) AS total_dept_managers,
  (SELECT COUNT(*) FROM dept_emp) AS total_dept_employees,
  (SELECT COUNT(*) FROM titles) AS total_titles,
  (SELECT COUNT(*) FROM salaries) AS total_salaries,
  (SELECT COUNT(*) FROM departments) AS total_departments;
