
select emp.id as user_id,sec_to_time(valueon2-valueon1) as Online_time,sec_to_time(valoff1-valoff2) as Offline_time
from employee emp
join(
	select emp.id,sum(lton1.on_start) as valueon1
		from employee emp
		join (select user_id,time_to_sec(timediff(status_time,now())) as on_start 
				from lifetime where status='online') lton1
			on lton1.user_id=emp.id
		group by emp.id) result_online1
	on result_online1.id=emp.id
join (select emp.id,sum(lton2.on_end) as valueon2
			from employee emp
			inner join (select user_id,time_to_sec(timediff(status_time,now())) as on_end 
					from lifetime where status='offline') lton2
				on lton2.user_id=emp.id
			group by emp.id) result_online2
	on result_online2.id=emp.id
join(
	select emp.id,sum(lton1.off_start)-min(lton1.off_start) as valoff1
		from employee emp
		join (select user_id,time_to_sec(timediff(status_time,now())) as off_start 
			from lifetime where status='online') lton1
			on lton1.user_id=emp.id
		group by emp.id) result_offline1
	on result_offline1.id=emp.id
join (select emp.id,sum(lton2.off_end)-max(lton2.off_end) as valoff2
			from employee emp
			inner join (select user_id,time_to_sec(timediff(status_time,now())) as off_end 
						from lifetime where status='offline') lton2
			on lton2.user_id=emp.id
			group by emp.id) result_offline2
	on result_offline2.id=emp.id
limit 200;
                                