CREATE TABLE Sales (
salesid number not null,
salesno number not null,
salesdate date not null default sysdate,
employeeid number(6) not null,
salestype varchar(10),
salesamountHT number not null default 0,

CONSTRAINT PK_Sales_SalesId PRIMARY KEY (salesid),
CONSTRAINT UK_Sales_SalesNo UNIQUE (salesno),
CONSTRAINT FK_Sales_Emp FOREIGN KEY (EmployeeId)
    REFERENCES EMPLOYEE(EmployeeId),
CONSTRAINT CHK_Sales_SalesType CHECK (SalesType IN ('ARTICLE','SERVICE')) 
);

