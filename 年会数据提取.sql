--select * from t_tabledescription where fdescription like '%�����%'
--select top 100 * from icstockbill where ftrantype=2
--select * from t_fielddescription where ftableid=210009
--�·�
select fmonth,
	sum(fauxqty) as fauxqty,
--    fconsignamount09=ISNULL(SUM(CASE year(fdate) WHEN '2009' THEN FConsignAmount END),0),
--    fconsignamount10=ISNULL(SUM(CASE year(fdate) WHEN '2010' THEN FConsignAmount END),0)
	sum(fconsignamount) as fconsignamount
from
(select 
--	t1.finterid,
	t1.fdate,
	month(t1.fdate) as fmonth,
	t2.fconsignamount as fconsignamount,
	t2.fauxqty as fauxqty 
from icstockbill t1
left join icstockbillentry t2
on t1.finterid=t2.finterid
where year(t1.fdate)='2009' and t1.ftrantype=21 --and t2.FDCStockID=14403
) a
group by fmonth
order by fmonth

--���
--select 
----	t1.finterid,
----	t1.fdate,
--	year(t1.fdate) as fyear ,
--	sum(t2.fconsignamount) as fconsignamount,
--	sum(t2.fauxqty) as fauxqty 
--from icstockbill t1
--left join icstockbillentry t2
--on t1.finterid=t2.finterid
--where year(t1.fdate)='2010' and ftrantype=21
--group by year(t1.fdate)
--order by fyear

---����
--select * from t_tabledescription where fdescription like '%����%'
--select top 100 * from icstockbill where ftrantype=2
--select * from t_fielddescription where ftableid=290015
--����
select 
	month(t1.fdate) as fmonth,
    fauxqty09=ISNULL(SUM(CASE year(t1.fdate) WHEN '2009' THEN t2.fauxqty END),0),
    fauxqty10=ISNULL(SUM(CASE year(t1.fdate) WHEN '2010' THEN t2.fauxqty END),0)
	--fauxqty09= sum(t2.fauxqty)
from seorder t1
left join seorderentry t2
on t1.finterid=t2.finterid
where year(t1.fdate)='2010' or year(t1.fdate)='2009'
group by month(t1.fdate)
order by fmonth

--���
select 
	month(t1.fdate) as fmonth,
    famount09=ISNULL(SUM(CASE year(t1.fdate) WHEN '2009' THEN t2.famount END),0),
    famount10=ISNULL(SUM(CASE year(t1.fdate) WHEN '2010' THEN t2.famount END),0)
	--fauxqty09= sum(t2.fauxqty)
from seorder t1
left join seorderentry t2
on t1.finterid=t2.finterid
where year(t1.fdate)='2010' or year(t1.fdate)='2009'
group by month(t1.fdate)
order by fmonth

--


--����ǧֻ
--select * from t_tabledescription where fdescription like '%�����%'
--select top 100 fauxqty,fconsignamount,fauxprice from icstockbillentry where ftrantype=21
--select * from t_fielddescription where ftableid=210009
--select *,percentage=(fconsignprice10-fconsignprice09)/fconsignprice09 from
--(select 
--	t3.FName,
--    fconsignprice09=ISNULL(avg(CASE year(t1.fdate) WHEN '2009' THEN FConsignPrice END),0),
--    fconsignprice10=ISNULL(avg(CASE year(t1.fdate) WHEN '2010' THEN FConsignPrice END),0)
----	AVG(fconsignprice) 
--from icstockbill t1
--left join icstockbillentry t2 on t1.finterid=t2.finterid
--LEFT JOIN t_ICItem t3 ON t2.FItemID=t3.FItemID
--where (year(t1.fdate)='2010' or year(t1.fdate)='2009') and t1.ftrantype=21
--group by t3.FName) a
--where fconsignprice10<>0 and fconsignprice09<>0
