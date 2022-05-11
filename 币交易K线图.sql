--ʱ���>=10:00:00 and ʱ���<10:05:00  

select t1.tTime as ʱ��,
	t1.tAmount as ������, 
	t1.maxPrice as ��߼۸�,
	t1.minPrice as ��ͼ۸�,
	t2.tPrice as ���̼۸�,
	t3.tPrice as ���̼۸�

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
  
--ʱ���>10:00:00 and ʱ���<=10:05:00  
select dateadd(mi,(datediff(mi,convert(varchar(10),dateadd(ss,1,ʱ��),120),dateadd(ss,1,ʱ��))/5)*5,convert(varchar(10),ʱ��,120)) as ʱ���,  
       count(*) as ����,  
       sum(���) as �ܽ��  
from tb  
group by dateadd(mi,(datediff(mi,convert(varchar(10),dateadd(ss,1,ʱ��),120),dateadd(ss,1,ʱ��))/5)*5,convert(varchar(10),ʱ��,120))

--ɾ���ظ�
select * from trade
where tID in (select tID from trade group by tID having count(tID) > 1)
order by tID

select distinct * into #Tmp from trade
drop table trade
select * into trade from #Tmp
drop table #Tmp

select * from ltctradekline 