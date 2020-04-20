drop table if exists result;
create table result(name varchar(45), salary int, departmentid int);
delimiter //
drop procedure if exists addingtopsalaryguys;
create procedure addingtopsalaryguys(topsal int)
begin
	declare i int;
	declare countdep int;
	set i = 1;
	set countdep = (select count(id) from department);
	while i<=countdep do
		insert into result (name,salary,departmentId)
		select emp.name,emp.salary,emp.departmentid
				from employee emp
			-- присоединяю выбор из уникальных топ 3 зп
			inner join (select distinct salary,departmentid 
						from employee 
						where departmentid = i 
						order by salary desc 
						limit topsal
						) tmp
				on emp.salary=tmp.salary and tmp.departmentid=emp.departmentid;
			set i=i+1;
	end while;
end //

call addingtopsalaryguys(3);

select result.name,result.salary,dep.name as departament from result
-- присоединяю таблицу с названиями департаментов
		inner join department dep
		on dep.id = result.departmentid
	order by dep.id asc,result.salary desc;