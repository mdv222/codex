DECLARE

-- création d'un curseur pour parcourir la table Employee
cursor cursor_emp is 
select Employeeid 
from Employee
where lower(jobid) = 'sales representative' -- en gardant uniquement les lignes où l'identifiant du job correspond à 'sales representative'. lower permettra d'ignorer la casse  
and rownum <= 5; -- limité à 5 élément

-- déclaration des variables
var_salesid sales.salesid%type := 0;
var_salesno sales.salesno%type := 1000;

BEGIN
-- lancement de la boucle for
for emp in cursor_emp loop 
    -- Première insertion pour l'employé en cours de traitement
    insert into sales(salesid, salesno, salesdate, employeeid, salestype, salesamountHT) 
    values(var_salesid, var_salesno, sysdate, emp.employeeid, 'ARTICLE', 10000);
    DBMS_OUTPUT.PUT_LINE('Insertion numero', ||var_salesid||, 'successful.');
    
    -- incrément du numero de vente et de l'id de vente
    var_salesid := var_salesid + 1;
    var_salesno := var_salesno + 1;
    
    -- Seconde insertion pour l'employé en cours
    insert into sales(salesid, salesno, salesdate, employeeid, salestype, salesamountHT) 
    values(var_salesid, var_salesno, sysdate, emp.employeeid, 'SERVICE', 15000);
    DBMS_OUTPUT.PUT_LINE('Insertion numero', ||var_salesid||, 'successful.'); 

    -- incrément du numero de vente et de l'id de vente
    var_salesid := var_salesid + 1;
    var_salesno := var_salesno + 1;
    end loop;
    
    commit;
    DBMS_OUTPUT.PUT_LINE(' Insertion terminée pour les 5 employés.');

    END;
    /