--
-- Copyright (c) Oracle Corporation 2018. All Rights Reserved.
--
-- NAME
-- UFOAD-M2ITIC-DBI2-CH03-DawnJ.sql
--
-- DESCRIPTION
-- This script creates the SQL*Plus demonstration tables in the
-- current schema. It should be STARTed by each user wishing to
-- access the tables.
--
-- USAGE
-- SQL> START UFOAD-M2ITIC-DBI2-CH03-DawnJ.sql
--
-- 
REM ********************************************************************
REM Create the REGIONS table to hold region information for locations
REM LOCATIONS table has a foreign key to this table.

Prompt ******  Creating REGIONS table ....

CREATE TABLE regions
    ( region_id      NUMBER 
       CONSTRAINT  region_id_nn NOT NULL 
    , region_name    VARCHAR2(25) 
    );

CREATE UNIQUE INDEX reg_id_pk
ON regions (region_id);

ALTER TABLE regions
ADD ( CONSTRAINT reg_id_pk
       		 PRIMARY KEY (region_id)
    ) ;

REM ********************************************************************
REM Create the COUNTRIES table to hold country information for customers
REM and company locations. 


Prompt ******  Creating COUNTRIES table ....

CREATE TABLE countries 
    ( country_id      CHAR(2) 
       CONSTRAINT  country_id_nn NOT NULL 
    , country_name    VARCHAR2(40) 
    , region_id       NUMBER 
    , CONSTRAINT     country_c_id_pk 
        	     PRIMARY KEY (country_id) 
    ) 
    ORGANIZATION INDEX; 

ALTER TABLE countries
ADD ( CONSTRAINT countr_reg_fk
        	 FOREIGN KEY (region_id)
          	  REFERENCES regions(region_id) 
    ) ;

	

REM ***************************insert data into the REGIONS table

Prompt ******  Populating REGIONS table ....

INSERT INTO regions VALUES 
        ( 1
        , 'Europe' 
        );

INSERT INTO regions VALUES 
        ( 2
        , 'Americas' 
        );

INSERT INTO regions VALUES 
        ( 3
        , 'Asia' 
        );

INSERT INTO regions VALUES 
        ( 4
        , 'Middle East and Africa' 
        );

REM ***************************insert data into the COUNTRIES table

Prompt ******  Populating COUNTIRES table ....

INSERT INTO countries VALUES 
        ( 'IT'
        , 'Italy'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'JP'
        , 'Japan'
	, 3 
        );

INSERT INTO countries VALUES 
        ( 'US'
        , 'United States of America'
        , 2 
        );

INSERT INTO countries VALUES 
        ( 'CA'
        , 'Canada'
        , 2 
        );

INSERT INTO countries VALUES 
        ( 'CN'
        , 'China'
        , 3 
        );

INSERT INTO countries VALUES 
        ( 'IN'
        , 'India'
        , 3 
        );

INSERT INTO countries VALUES 
        ( 'AU'
        , 'Australia'
        , 3 
        );

INSERT INTO countries VALUES 
        ( 'ZW'
        , 'Zimbabwe'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'SG'
        , 'Singapore'
        , 3 
        );

INSERT INTO countries VALUES 
        ( 'UK'
        , 'United Kingdom'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'FR'
        , 'France'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'DE'
        , 'Germany'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'ZM'
        , 'Zambia'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'EG'
        , 'Egypt'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'BR'
        , 'Brazil'
        , 2 
        );

INSERT INTO countries VALUES 
        ( 'CH'
        , 'Switzerland'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'NL'
        , 'Netherlands'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'MX'
        , 'Mexico'
        , 2 
        );

INSERT INTO countries VALUES 
        ( 'KW'
        , 'Kuwait'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'IL'
        , 'Israel'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'DK'
        , 'Denmark'
        , 1 
        );

INSERT INTO countries VALUES 
        ( 'HK'
        , 'HongKong'
        , 3 
        );

INSERT INTO countries VALUES 
        ( 'NG'
        , 'Nigeria'
        , 4 
        );

INSERT INTO countries VALUES 
        ( 'AR'
        , 'Argentina'
        , 2 
        );

INSERT INTO countries VALUES 
        ( 'BE'
        , 'Belgium'
        , 1 
        );

	
COMMIT;

SET TERMOUT ON
PROMPT Demonstration table build is complete.