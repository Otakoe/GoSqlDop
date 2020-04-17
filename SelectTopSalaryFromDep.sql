-- Выбор самых оплачиваемых сотрудников из департаментов, топ 3 по зарплатам
-- Выбор каждого департамента вручную без использования лупа
select result.name,result.salary,dep.name 
from (
		select emp.name,emp.salary,emp.departmentid
			from employee emp
		-- присоединяю выбор из уникальных топ 3 зп
		inner join (select distinct salary,departmentid 
					from employee 
					where departmentid = 1 
					order by salary 
					desc limit 3
					) tmp
			on emp.salary=tmp.salary and tmp.departmentid=emp.departmentid
	-- присоединяю следующий департамент
		union
		select emp.name,emp.salary,emp.departmentid
			from employee emp
		-- присоединяю выбор из уникальных топ 3 зп
		inner join (select distinct salary,departmentid 
					from employee 
					where departmentid = 2 
					order by salary 
					desc limit 3
					) tmp
			on emp.salary=tmp.salary and tmp.departmentid=emp.departmentid) as result
-- присоединяю таблицу с названиями департаментов
inner join department dep
on dep.id = result.departmentid
