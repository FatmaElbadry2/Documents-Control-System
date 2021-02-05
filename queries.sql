 DELIMITER //
 
 CREATE PROCEDURE insert_employee (IN f_name varchar(20), IN l_name varchar(20))
	BEGIN
        INSERT INTO employee (f_name,l_name) VALUES(f_name,l_name);
	END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE create_draft (IN doc int, IN employee int)
	BEGIN
        INSERT INTO employee (document,employee) VALUES(doc,employee);
	END //

DELIMITER ;


DELIMITER //
 CREATE PROCEDURE create_copy (IN draft int, IN employee int)
	BEGIN
        INSERT INTO employee (draft,employee) VALUES(draft,employee);
	END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE create_doc (IN dtype varchar(20), IN title varchar(20), In received bool,In receipt_no int,In dstatus int,In employee_id int,IN adcode middleint)
	BEGIN
	 DECLARE r_date date ;
    
    if received = false then
    set receipt_no = null;
    set r_date = null;
	else 
    set r_date = current_date();
    end if;
	if dstatus = 1 then
    set adcode = null;
    else 
    set employee_id = null;
    end if;
    START TRANSACTION;
	   INSERT INTO document (d_type,title,received,receipt_date,receipt_number,d_status,employee,address_code) VALUES(dtype,title,received,r_date,receipt_no,dstatus,employee_id,adcode);
       INSERT INTO change_history(document,employee,change_date,change_type) Values(LAST_INSERT_ID(),0,now(),1);
       if dstatus =1 then
       INSERT INTO circ_history(employee,change_id) values (employee_id,LAST_INSERT_ID());
       end if;
       COMMIT;
	END //   

DELIMITER ;

DELIMITER //
CREATE PROCEDURE circulate (IN employeeId int, IN doc_id int)
BEGIN
declare curremployee int;
START TRANSACTION;
set curremployee = (select employee from document where id=doc_id);
if curremployee is null then 
set curremployee=0;
end if;
	 UPDATE document SET d_status = 1, employee = employeeId,address_code=null WHERE id = doc_id;
     INSERT INTO change_history(document,employee,change_date,change_type) Values(doc_id,curremployee,now(),2);
     INSERT INTO circ_history(employee,change_id) values (employeeId,LAST_INSERT_ID());
     COMMIT;
END // 
DELIMITER ;  

DELIMITER //
CREATE PROCEDURE mailto (IN mailaddress middleint, IN doc_id int)
BEGIN
declare curremployee int;
START TRANSACTION;
set curremployee = (select employee from document where id=doc_id);
if curremployee is null then 
set curremployee=0;
end if;
	 UPDATE document SET d_status = 2, address_code = mailaddress,employee=null WHERE id = doc_id;
     INSERT INTO change_history(document,employee,change_date,change_type) Values(doc_id,curremployee,now(),2);
     COMMIT;
END // 
DELIMITER ;  

DELIMITER //
CREATE PROCEDURE get_changes(IN doc_id int)
begin 
select * from change_history
where document = doc_id;
end //
DELIMITER ;  

DELIMITER //
CREATE PROCEDURE get_circ_history(IN doc_id int)
begin 
select circ_history.employee, change_history.document, change_history.change_date from change_history INNER JOIN circ_history on circ_history.change_id=change_history.id
where change_history.document= doc_id;

end //
DELIMITER ; 




