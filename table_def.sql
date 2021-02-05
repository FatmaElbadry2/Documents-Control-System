create database documents;

use documents;

create table employee(
id int NOT NULL AUTO_INCREMENT,
f_name varchar(20) NOT NULL,
l_name varchar(20) NOT NULL,
primary key(id)
);

create table document(
id int NOT NULL AUTO_INCREMENT,
d_type varchar(20) NOT NULL,
title varchar(20) NOT NULL,
received boolean NOT NULL default false,
receipt_date date,
receipt_number int unique,
d_status ENUM('circulated','mailed externally') NOT NULL,
employee INT default 0 REFERENCES employee(id) on delete set null,
address_code middleint ,
primary key(id)
);

create table draft(
id int NOT NULL AUTO_INCREMENT,
doc INT NOT NULL references document(id) on delete cascade,
employee INT NOT NULL references employee(id) on delete cascade,
primary key(id)
);

create table copy(
id int NOT NULL AUTO_INCREMENT,
draft INT NOT NULL references draft(id) on delete cascade,
employee INT NOT NULL references employee(id) on delete cascade,
primary key(id)
);

create table change_history(
id int NOT NULL AUTO_INCREMENT,
document INT NOT NULL references document(id) on delete cascade,
employee INT NOT NULL references employee(id) on delete set null,
change_date datetime NOT NULL,
change_type ENUM('created','status changed','title','d_type','other') NOT NULL,
primary key(id)
);

create table circ_history(
id int NOT NULL AUTO_INCREMENT,
employee INT NOT NULL references employee(id) on delete SET null,
change_id int not null references change_history(id) on delete cascade,
primary key(id)
);




## insert employee, document, draft, copy
# update doc, status, circulate, change 

