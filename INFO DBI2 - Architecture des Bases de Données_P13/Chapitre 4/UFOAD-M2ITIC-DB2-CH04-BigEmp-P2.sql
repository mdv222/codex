--
-- Copyright (c) Oracle Corporation 2018. All Rights Reserved.
--
-- NAME
-- UFOAD-M2ITIC-DB2-CH04-BigEmp-P2.sql
--
-- DESCRIPTION
-- This script creates the table BigEmp and populate it with 30000 records.
--
-- USAGE
-- SQL> START UFOAD-M2ITIC-DB2-CH04-BigEmp-P2.sql
--
-- 
-- CA 20/04/2018
--
-- Creation de la table BigEmp
CREATE TABLE bigEMP (
EMPNO NUMBER ,
ENAME VARCHAR2(10) NOT NULL CHECK (ename=UPPER(ename)),
JOB VARCHAR2(9),
MGR NUMBER ,
HIREDATE DATE,
SAL NUMBER(7,2) CHECK (SAL > 500 ),
COMM NUMBER(7,2),
DEPTNO NUMBER NOT NULL );

--
--
-- Insertion des lignes
begin
for i in 0..30000
loop
    insert into bigemp
    select i*1000+empno, ename, job, i*1000+mgr, hiredate, sal, comm, i*100+deptno
    from bigemp;
end loop;
commit;
end;
/