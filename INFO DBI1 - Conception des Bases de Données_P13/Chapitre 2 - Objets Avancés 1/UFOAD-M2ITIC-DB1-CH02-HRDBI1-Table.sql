--
-- Copyright (c) Oracle Corporation 2018. All Rights Reserved.
--
-- NAME
-- UFOAD-M2ITIC-DBI1-CH02-HRDBI1-Table.sql
--
-- DESCRIPTION
-- This script creates the SQL*Plus demonstration tables in the
-- current schema. It should be STARTed by each user wishing to
-- access the tables. 
--
-- USAGE
-- SQL> START UFOAD-M2ITIC-DBI1-CH02-HRDBI1-Table.sql
--
-- 

SET TERMOUT ON
PROMPT Building HRDBI1 tables. Please wait.
SET TERMOUT OFF

DROP TABLE Job CASCADE CONSTRAINTS;
DROP TABLE Region CASCADE CONSTRAINTS;
DROP TABLE Location CASCADE CONSTRAINTS;
DROP TABLE Job_History CASCADE CONSTRAINTS;
DROP TABLE Department CASCADE CONSTRAINTS;
DROP TABLE Employee CASCADE CONSTRAINTS;
DROP TABLE Country CASCADE CONSTRAINTS;

REM ********************************************************************
REM Create the Region table to hold region information for Location
REM HRDBI1.Location table has a foreign key to this table.
       
CREATE TABLE Region
   ( Regionid NUMBER CONSTRAINT NN_regionid NOT NULL, 
     Region_name VARCHAR2(25));

ALTER TABLE Region ADD CONSTRAINT PK_regionid PRIMARY KEY (regionid);

REM ********************************************************************
REM Create the Country table to hold country information for customers
REM and company Location. 
REM OE.CUSTOMERS table and HRDBI1.Location have a foreign key to this table.
       
CREATE TABLE Country 
   ( Countryid CHAR(2) CONSTRAINT NN_Countryid NOT NULL,
     Country_name VARCHAR2(40) DEFAULT 'France',
	 Cotation NUMBER(2),
     Regionid NUMBER); 
ALTER TABLE Country ADD CONSTRAINT PK_Countryid  PRIMARY KEY (countryid);
ALTER TABLE Country ADD CONSTRAINT FK_Country_Region FOREIGN KEY (Regionid) REFERENCES Region(regionid);
ALTER TABLE Country ADD CONSTRAINT CHK_Cotation CHECK (Cotation >=0 AND Cotation <=20);



REM ********************************************************************
REM Create the Location table to hold address information for company Department.
REM HRDBI1.Department has a foreign key to this table.
       
CREATE TABLE Location
   ( Locationid NUMBER(4),
     Street_address VARCHAR2(40),
     Postal_code VARCHAR2(12),
     City VARCHAR2(30) CONSTRAINT NN_Location_city NOT NULL,
     State_province VARCHAR2(25),
     Countryid CHAR(2));
	 
ALTER TABLE Location ADD CONSTRAINT PK_Locationid PRIMARY KEY (Locationid);
ALTER TABLE Location ADD CONSTRAINT FK_Locationid FOREIGN KEY (Countryid) REFERENCES Country(Countryid);

   
REM ********************************************************************
REM Create the Department table to hold company department information.
REM HRDBI1.Employee and HRDBI1.JOB_HISTORY have a foreign key to this table.
       
CREATE TABLE Department
   ( Departmentid NUMBER(4),
     Department_name VARCHAR2(30) CONSTRAINT NN_departement_Name NOT NULL,
     Managerid NUMBER(6),
     Locationid NUMBER(4));

ALTER TABLE Department ADD CONSTRAINT PK_Departementid PRIMARY KEY (Departmentid);
ALTER TABLE Department ADD CONSTRAINT FK_Dept_location FOREIGN KEY (Locationid) REFERENCES Location (Locationid);
  
   
REM ********************************************************************
REM Create the Job table to hold the different names of job roles within the company.
REM HRDBI1.Employee has a foreign key to this table.
       
CREATE TABLE Job
   ( Jobid VARCHAR2(10),
     Job_title VARCHAR2(35) CONSTRAINT NN_Job_Title NOT NULL,
     Min_salary NUMBER(6),
     Max_salary NUMBER(6)) ;
	 
ALTER TABLE Job ADD CONSTRAINT PK_Jobid PRIMARY KEY(Jobid);

REM ********************************************************************
REM Create the Employee table to hold the employee personnel 
REM information for the company.
REM HRDBI1.Employee has a self referencing foreign key to this table.
       
CREATE TABLE Employee
   ( Employeeid NUMBER(6),
     First_name VARCHAR2(20),
     Last_name VARCHAR2(25) CONSTRAINT NN_emp_last_name NOT NULL,
     Email VARCHAR2(25) CONSTRAINT NN_emp_email NOT NULL,
     Phone_number VARCHAR2(20),
     Hire_date DATE CONSTRAINT NN_emp_hire_date NOT NULL,
     Jobid VARCHAR2(10) CONSTRAINT NN_emp_job NOT NULL,
     Salary NUMBER(8,2),
     Commission_pct NUMBER(2,2),
     Managerid NUMBER(6),
     Departmentid NUMBER(4));
	
	
ALTER TABLE Employee ADD CONSTRAINT MIN_emp_salary CHECK (Salary > 0); 
ALTER TABLE Employee ADD CONSTRAINT UK_emp_email UNIQUE (Email);

ALTER TABLE Employee ADD CONSTRAINT PK_emp_empid PRIMARY KEY (Employeeid);
ALTER TABLE Employee ADD CONSTRAINT FK_emp_dept FOREIGN KEY (Departmentid) REFERENCES Department(Departmentid) ;
ALTER TABLE Employee ADD CONSTRAINT FK_emp_job FOREIGN KEY (Jobid) REFERENCES Job(Jobid);
ALTER TABLE Employee ADD CONSTRAINT FK_emp_mgr FOREIGN KEY(Managerid) REFERENCES Employee;
ALTER TABLE Department ADD CONSTRAINT FK_dept_mgr FOREIGN KEY (Managerid) REFERENCES Employee (Employeeid);
       

   
REM ********************************************************************
REM Create the JOB_HISTORY table to hold the history of Job that 
REM Employee have held in the past.
REM HRDBI1.Job, HR_Department, and HRDBI1.Employee have a foreign key to this table.
       
CREATE TABLE Job_history
   ( Employeeid NUMBER(6) CONSTRAINT NN_jhist_employee NOT NULL,
     Start_date DATE CONSTRAINT NN_jhist_start_date NOT NULL,
     End_date DATE CONSTRAINT NN_jhist_end_date NOT NULL,
     Jobid VARCHAR2(10) CONSTRAINT NN_jhist_job NOT NULL,
     Departmentid NUMBER(4));
	 
	 
ALTER TABLE Job_history ADD CONSTRAINT PK_jhist_empid_st_date PRIMARY KEY (employeeid, start_date);
ALTER TABLE Job_history ADD CONSTRAINT FK_jhist_job FOREIGN KEY (jobid) REFERENCES Job;
ALTER TABLE Job_history ADD CONSTRAINT FK_jhist_emp FOREIGN KEY (employeeid) REFERENCES Employee;
ALTER TABLE Job_history ADD CONSTRAINT FK_jhist_dept FOREIGN KEY (departmentid) REFERENCES Department;
ALTER TABLE Job_history ADD CONSTRAINT CH_jhist_date_interval CHECK (End_date > Start_date);


COMMENT ON TABLE Region 
         IS 'Region table that contains region numbers and names. Contains 4 rows; references with the Country table.';
COMMENT ON COLUMN Region.regionid
         IS 'Primary key of Region table.';
COMMENT ON COLUMN Region.region_name
         IS 'Names of Region. Location are in the Country of these Region.';
COMMENT ON TABLE Location
         IS 'Location table that contains specific address of a specific office,
         warehouse, and/or production site of a company. Does not store addresses /
         Location of customers. Contains 23 rows; references with the
         Department and Country tables. ';
COMMENT ON COLUMN Location.locationid
         IS 'Primary key of Location table';
COMMENT ON COLUMN Location.street_address
         IS 'Street address of an office, warehouse, or production site of a company.
         Contains building number and street name';
COMMENT ON COLUMN Location.postal_code
         IS 'Postal code of the location of an office, warehouse, or production site 
         of a company. ';
COMMENT ON COLUMN Location.city
         IS 'A not null column that shows city where an office, warehouse, or 
         production site of a company is located. ';
COMMENT ON COLUMN Location.state_province
         IS 'State or Province where an office, warehouse, or production site of a 
         company is located.';
COMMENT ON COLUMN Location.countryid
         IS 'Country where an office, warehouse, or production site of a company is
         located. Foreign key to countryid column of the Country table.';
       
REM *********************************************
COMMENT ON TABLE Department
         IS 'Department table that shows details of Department where Employee 
         work. Contains 27 rows; references with Location, Employee, and job_history tables.';
COMMENT ON COLUMN Department.departmentid
         IS 'Primary key column of Department table.';
COMMENT ON COLUMN Department.department_name
         IS 'A not null column that shows name of a department. Administration, 
         Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public 
         Relations, Sales, Finance, and Accounting. ';
COMMENT ON COLUMN Department.managerid
         IS 'Managerid of a department. Foreign key to employeeid column of Employee table. The managerid column of the employee table references this column.';
COMMENT ON COLUMN Department.locationid
         IS 'Location id where a department is located. Foreign key to locationid column of Location table.';
       
REM *********************************************
COMMENT ON TABLE job_history
         IS 'Table that stores job history of the Employee. If an employee 
         changes Department within the job or changes Job within the department, 
         new rows get inserted into this table with old job information of the 
         employee. Contains a complex primary key: employeeid+start_date.
         Contains 25 rows. References with Job, Employee, and Department tables.';
COMMENT ON COLUMN job_history.employeeid
         IS 'A not null column in the complex primary key employeeid+start_date.
         Foreign key to employeeid column of the employee table';
COMMENT ON COLUMN job_history.start_date
         IS 'A not null column in the complex primary key employeeid+start_date. 
         Must be less than the end_date of the job_history table. (enforced by 
         constraint jhist_date_interval)';
COMMENT ON COLUMN job_history.end_date
         IS 'Last day of the employee in this job role. A not null column. Must be 
         greater than the start_date of the job_history table. 
         (enforced by constraint jhist_date_interval)';
COMMENT ON COLUMN job_history.jobid
         IS 'Job role in which the employee worked in the past; foreign key to 
         jobid column in the Job table. A not null column.';
COMMENT ON COLUMN job_history.departmentid
         IS 'Department id in which the employee worked in the past; foreign key to deparmentid column in the Department table';
       
REM *********************************************
COMMENT ON TABLE Country
         IS 'country table. Contains 25 rows. References with Location table.';
COMMENT ON COLUMN Country.countryid
         IS 'Primary key of Country table.';
COMMENT ON COLUMN Country.country_name
         IS 'Country name';
COMMENT ON COLUMN Country.regionid
         IS 'Region ID for the country. Foreign key to regionid column in the Department table.';
REM *********************************************
COMMENT ON TABLE Job
         IS 'Job table with job titles and salary ranges. Contains 19 rows.
         References with Employee and job_history table.';
COMMENT ON COLUMN Job.jobid
         IS 'Primary key of Job table.';
COMMENT ON COLUMN Job.job_title
         IS 'A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT';
COMMENT ON COLUMN Job.min_salary
         IS 'Minimum salary for a job title.';
COMMENT ON COLUMN Job.max_salary
         IS 'Maximum salary for a job title';
REM *********************************************
COMMENT ON TABLE Employee
         IS 'Employee table. Contains 107 rows. References with Department, 
         Job, job_history tables. Contains a self reference.';
COMMENT ON COLUMN Employee.employeeid
         IS 'Primary key of Employee table.';
COMMENT ON COLUMN Employee.first_name
         IS 'First name of the employee. A not null column.';
COMMENT ON COLUMN Employee.last_name
         IS 'Last name of the employee. A not null column.';
COMMENT ON COLUMN Employee.email
         IS 'Email id of the employee';
COMMENT ON COLUMN Employee.phone_number
         IS 'Phone number of the employee; includes country code and area code';
COMMENT ON COLUMN Employee.hire_date
         IS 'Date when the employee started on this job. A not null column.';
COMMENT ON COLUMN Employee.jobid
         IS 'Current job of the employee; foreign key to jobid column of the 
         Job table. A not null column.';
COMMENT ON COLUMN Employee.salary
         IS 'Monthly salary of the employee. Must be greater 
         than zero (enforced by constraint emp_salary_min)';
COMMENT ON COLUMN Employee.commission_pct
         IS 'Commission percentage of the employee; Only Employee in sales 
         department elgible for commission percentage';
COMMENT ON COLUMN Employee.managerid
         IS 'Manager id of the employee; has same domain as managerid in 
         Department table. Foreign key to employeeid column of Employee table.
         (useful for reflexive joins and CONNECT BY query)';
COMMENT ON COLUMN Employee.departmentid
         IS 'Department id where employee works; foreign key to departmentid 
         column of the Department table';
COMMIT;
 