---select * from t_tabledescription where fdescription like '%销售%' --210008 230004

--select * from t_fielddescription where ftableid=230005
declare @begindate char(10)
declare @enddate char(10)
set @begindate='2010-01-01'
set @enddate='2010-02-01'

select distinct a.prodname as [规格],
	coalesce(b.fauxqty_sum,0) as [出库],
	coalesce(c.fauxqty_sum,0) as [入库],
	coalesce(d.fauxqty_sum,0) as [订单]
from (
(select 
	prodname=t3.fname,
	fauxqty_sum=sum(t2.fauxqty) 
from icstockbill t1
left join icstockbillentry t2 on t1.finterid=t2.finterid
left join t_icitem t3 on t2.fitemid=t3.fitemid
where ftrantype=21 and fdate >=@begindate and fdate <@enddate
group by t3.fname)
union all(
select 
	prodname=t3.fname,
	fauxqty_sum=sum(t2.fauxqty) 
from icstockbill t1
left join icstockbillentry t2 on t1.finterid=t2.finterid
left join t_icitem t3 on t2.fitemid=t3.fitemid
where ftrantype=2 and fdate >=@begindate and fdate <@enddate
group by t3.fname)
union all(
select 
	prodname=t3.fname,
	fauxqty_sum=sum(t2.fauxqty) 
from seorder t1
left join seorderentry t2
on t1.finterid=t2.finterid
left join t_icitem t3
on t2.fitemid=t3.fitemid
where t1.fdate >=@begindate and t1.fdate <@enddate
group by t3.fname)) as a
left join 
(select 
	prodname=t3.fname,
	fauxqty_sum=sum(t2.fauxqty) 
from icstockbill t1
left join icstockbillentry t2 on t1.finterid=t2.finterid
left join t_icitem t3 on t2.fitemid=t3.fitemid
where ftrantype=21 and fdate >=@begindate and fdate <@enddate --出库
group by t3.fname) as b
on a.prodname=b.prodname
left join
(select 
	prodname=t3.fname,
	fauxqty_sum=sum(t2.fauxqty) 
from icstockbill t1
left join icstockbillentry t2 on t1.finterid=t2.finterid
left join t_icitem t3 on t2.fitemid=t3.fitemid
where ftrantype=2 and fdate >=@begindate and fdate <@enddate--入库
group by t3.fname) as c
on a.prodname=c.prodname
left join(
select 
	prodname=t3.fname,
	fauxqty_sum=sum(t2.fauxqty) 
from seorder t1
left join seorderentry t2
on t1.finterid=t2.finterid
left join t_icitem t3
on t2.fitemid=t3.fitemid
where t1.fdate >=@begindate and t1.fdate <@enddate --订单
group by t3.fname) as d
on a.prodname=d.prodname





