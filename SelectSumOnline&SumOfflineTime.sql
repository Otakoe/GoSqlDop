
select emp.name,sec_to_time(valoff1-valon1) as Online_time,sec_to_time(valon2-valoff2) as Offline_time
from employee emp
join(
	select emp.id,sum(lton1.on_start) as valon1
			from employee emp
			join (select user_id,time_to_sec(timediff(status_time,adddate(now(),interval -1 hour))) as on_start 
					from lifetime where status='online') lton1
				on lton1.user_id=emp.id
                group by emp.id) result_online1
	on result_online1.id=emp.id
join (select emp.id,sum(lton2.on_end) as valoff1
			from employee emp
				inner join (select user_id,time_to_sec(timediff(status_time,adddate(now(),interval -1 hour))) as on_end 
					from lifetime where status='offline') lton2
				on lton2.user_id=emp.id
                group by emp.id) result_offline1
	on result_offline1.id=emp.id
join(
	select emp.id,sum(lton1.on_start)-min(lton1.on_start) as valon2
		from employee emp
	join (select user_id,time_to_sec(timediff(status_time,adddate(now(),interval -1 hour))) as on_start 
				from lifetime where status='online') lton1
		on lton1.user_id=emp.id
	group by emp.id) result_online2
	on result_online2.id=emp.id
join (select emp.id,sum(lton2.on_end)-max(lton2.on_end) as valoff2
			from employee emp
			inner join (select user_id,time_to_sec(timediff(status_time,adddate(now(),interval -1 hour))) as on_end 
						from lifetime where status='offline') lton2
			on lton2.user_id=emp.id
			group by emp.id) result_offline2
	on result_offline2.id=emp.id
                                