--时间段>=10:00:00 and 时间段<10:05:00  

select t1.tTime as 时间,
	t1.tAmount as 交易数, 
	t1.maxPrice as 最高价格,
	t1.minPrice as 最低价格,
	t2.tPrice as 开盘价格,
	t3.tPrice as 收盘价格

select distinct t1.tTime,
	t1.tAmount, 
	t1.maxPrice,
	t1.minPrice,
	t2.tPrice as startPrice,
	t3.tPrice as endPrice
from 
(select dateadd(mi,(datediff(mi,convert(varchar(10),dateadd(ss,-1,tDate ),120),
	dateadd(ss,-1,tDate ))/5)*5,convert(varchar(10),tDate ,120)) as tTime,  
       sum(tAmount) as tAmount,  
       max(tPrice ) as maxPrice,
	   min(tPrice) as minPrice ,
	   min( tID ) as startID,
	   max(tID ) as endID
from trade 
group by dateadd(mi,(datediff(mi,convert(varchar(10),dateadd(ss,-1,tDate),120),dateadd(ss,-1,tDate))/5)*5,convert(varchar(10),tDate,120))  
) t1
left join trade t2 on t1.startID=t2.tID
left join trade t3 on t1.endID=t3.tID
where t1.tTime >='2013-12-10' and t1.tTime <'2013-12-11'
order by t1.tTime


select top 1000 * from BTCtrade
  
--时间段>10:00:00 and 时间段<=10:05:00  
select dateadd(mi,(datediff(mi,convert(varchar(10),dateadd(ss,1,时间),120),dateadd(ss,1,时间))/5)*5,convert(varchar(10),时间,120)) as 时间段,  
       count(*) as 行数,  
       sum(金额) as 总金额  
from tb  
group by dateadd(mi,(datediff(mi,convert(varchar(10),dateadd(ss,1,时间),120),dateadd(ss,1,时间))/5)*5,convert(varchar(10),时间,120))

--删除重复
select * from trade
where tID in (select tID from trade group by tID having count(tID) > 1)
order by tID

select distinct * into #Tmp from trade
drop table trade
select * into trade from #Tmp
drop table #Tmp

select * from ltctradekline 