create schema if not exists sqldop
CHARACTER SET = utf8mb4
COLLATE= utf8mb4_0900_ai_ci
DEFAULT ENCRYPTION = 'Y';
 
 use sqldop;
-- Создание и вызов функции удаления fk если был
set @dropFk_userid_userid=(
	select if(
		(SELECT count(1) 
        FROM information_schema.TABLE_CONSTRAINTS
            where table_schema = 'sqldop'
        	and table_name = 'lifetime'
            and CONSTRAINT_NAME   = 'fk_userid_userid' 
            AND CONSTRAINT_TYPE   = 'FOREIGN KEY') >0,
            "alter table lifetime drop foreign key fk_userid_userid;",
            "drop table if exists neverExists;"));
prepare functionDropFkIfExists from @dropFk_userid_userid;
execute functionDropFkIfExists;
deallocate prepare functionDropFkIfExists;

drop table if exists employee;
Create table If Not Exists Employee (
	Id int, Name varchar(255), Salary int, DepartmentId int);
Create table If Not Exists Department (Id int, Name varchar(255));
Truncate table Employee;
insert into Employee (
	Id, Name, Salary, DepartmentId) values 
	('1', 'Joe', '85000', '1');
insert into Employee (
	Id, Name, Salary, DepartmentId) values 
	('2', 'Henry', '80000', '2');
insert into Employee (
	Id, Name, Salary, DepartmentId) values 
	('3', 'Sam', '60000', '2');
insert into Employee (
	Id, Name, Salary, DepartmentId) values 
	('4', 'Max', '90000', '1');
insert into Employee (
	Id, Name, Salary, DepartmentId) values 
	('5', 'Janet', '69000', '1');
insert into Employee (
	Id, Name, Salary, DepartmentId) values 
	('6', 'Randy', '85000', '1');
insert into Employee (
	Id, Name, Salary, DepartmentId) values 
	('7', 'Will', '70000', '1');
Truncate table Department;
insert into Department (Id, Name) values ('1', 'IT');
insert into Department (Id, Name) values ('2', 'Sales');
alter table employee modify id int not null;
alter table employee add primary key (id);

create table if not exists lifetime(
	id int auto_increment,
    user_id int not null,
    status_time timestamp,
    status enum('online','offline'),
    primary key(id)
    );
-- Создание и вызов функции удаления fk если был
set @dropFk_userid_userid=(
	select if(
		(SELECT count(1) 
        FROM information_schema.TABLE_CONSTRAINTS
            where table_schema = 'sqldop'
        	and table_name = 'lifetime'
            and CONSTRAINT_NAME   = 'fk_userid_userid' 
            AND CONSTRAINT_TYPE   = 'FOREIGN KEY') >0,
            "alter table employee drop foreign key fk_userid_userid;",
            "drop table if exists neverExists;"));
prepare functionDropFkIfExists from @dropFk_userid_userid;
execute functionDropFkIfExists;
deallocate prepare functionDropFkIfExists;

alter table lifetime
add constraint fk_userid_userid
	foreign key (user_id)
    references employee(id);
    
truncate table lifetime;
insert into lifetime(user_id,status_time,status) values
	(1,(select now()),'online'),
    (2,(select now()),'online'),
    (3,(select now()),'online'),
    (4,(select now()),'online'),
    (1,(select adddate(now(), interval 4 hour)),'offline'),
    (2,(select adddate(now(), interval 3 hour)),'offline'),
    (3,(select adddate(now(), interval 7 hour)),'offline'),
    (4,(select adddate(now(), interval 2 hour)),'offline'),
    (1,(select adddate(now(), interval 14 hour)),'online'),
    (2,(select adddate(now(), interval 11 hour)),'online'),
    (3,(select adddate(now(), interval 17 hour)),'online'),
    (4,(select adddate(now(), interval 18 hour)),'online'),
	(1,(select adddate(now(), interval 22 hour)),'offline'),
    (2,(select adddate(now(), interval 21 hour)),'offline'),
    (3,(select adddate(now(), interval 28 hour)),'offline'),
    (4,(select adddate(now(), interval 27 hour)),'offline'),
    (1,(select adddate(now(), interval 34 hour)),'offline'),
    (2,(select adddate(now(), interval 37 hour)),'offline'),
    (3,(select adddate(now(), interval 32 hour)),'offline'),
    (4,(select adddate(now(), interval 33 hour)),'offline'),
    (1,(select adddate(now(), interval 45 hour)),'online'),
    (2,(select adddate(now(), interval 48 hour)),'online'),
    (3,(select adddate(now(), interval 47 hour)),'online'),
    (4,(select adddate(now(), interval 44 hour)),'online'),
	(1,(select adddate(now(), interval 53 hour)),'offline'),
    (2,(select adddate(now(), interval 59 hour)),'offline'),
    (3,(select adddate(now(), interval 51 hour)),'offline'),
    (4,(select adddate(now(), interval 55 hour)),'offline');
    