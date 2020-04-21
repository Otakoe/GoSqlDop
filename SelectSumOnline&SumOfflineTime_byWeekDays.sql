drop table if exists tmp;
create table tmp
select * from lifetime
order by user_id,status_time;

alter table tmp
add column que int auto_increment unique key;

select result.user_id as user_id,dayname(result.data) as dayofweek,sec_to_time(sum(result.uptime)) as time_online, sec_to_time(time_to_sec('24:00:00')-sum(result.uptime)) as time_offline
	from(
		select date(d1.status_time)as data,d1.user_id,time_to_sec(timediff(d2.status_time,d1.status_time)) as uptime
			from tmp d1
			join tmp d2
			on date(d2.status_time)=date(d1.status_time) and d2.user_id=d1.user_id 
			where d1.que=(d2.que-1) and d2.status='offline' and d1.status='online'
		union
		select date(d1.status_time)as data,d1.user_id,time_to_sec(timediff(adddate(date(d2.status_time),interval -1 second),d1.status_time)) as uptime
			from tmp d1
			join tmp d2
			on date(d2.status_time)>date(d1.status_time) and d2.user_id=d1.user_id 
			where d1.que=(d2.que-1) and d2.status='offline' and d1.status='online'
		union
		select date(d2.status_time)as data,d1.user_id,time_to_sec(timediff(d2.status_time,timestamp(date(d2.status_time)))) as uptime
			from tmp d1
			join tmp d2
			on date(d2.status_time)>date(d1.status_time) and d2.user_id=d1.user_id 
			where d1.que=(d2.que-1) and d2.status='offline' and d1.status='online') result
group by user_id,dayofweek
order by user_id,field(dayofweek,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday')
limit 200;