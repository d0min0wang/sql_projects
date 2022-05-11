select FInterID,FSupplyID,FDate,FTranType,FCheckerID
into #temp_ICS
from ICStockBill
union all
select FInterID,FSupplyID,FDate,FTranType,FCheckerID
from [AIS20130811090352].dbo.ICStockBill

select FInterID,FConsignAmount
into #temp_ICSE
from ICStockBillEntry
union all
select FInterID,FConsignAmount
from [AIS20130811090352].dbo.ICStockBillEntry



select FSupplyID,min(FMinDate) FMinDate
into #old_supply
from
(
	select tt1.FSupplyID,max(tt1.FMinDate) as FMinDate 
	--into #old_supply
	from
	(
		select t1.FSupplyID as FSupplyID,
		min(t1.FDate) AS FMinDate
		from ICStockBill t1 
		INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
		where year(t1.FDate)='2016'
		and
		t1.FTranType=21 
		And t1.FCheckerID>0 
		group by t1.FSupplyID
	)tt1
	left join
	(
		select t1.FSupplyID as FSupplyID,
		max(t1.FDate) AS FMaxDate
		from #temp_ICS t1 
		INNER JOIN #temp_ICSE t2 ON t1.FInterID=t2.FInterID
		where year(t1.FDate) <'2016'
		and
		t1.FTranType=21 
		And t1.FCheckerID>0 
		and
		t2.FConsignAmount>0
		group by t1.FSupplyID
		--union all
		--select t1.FSupplyID as FSupplyID,
		--max(t1.FDate) AS FMaxDate
		--from [AIS20130811090352].dbo.ICStockBill t1 
		--INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
		--where year(t1.FDate)<'2013'
		--and
		--t1.FTranType=21 
		--And t1.FCheckerID>0 
		--group by t1.FSupplyID
	)tt2 on tt1.FSupplyID=tt2.FSupplyID
	where datediff(month,tt2.FMaxDate,tt1.FMinDate)>12
	group by tt1.FSupplyID
	union all
	(
		select t1.FSupplyID as FSupplyID,
		min(t1.FDate) AS FMinDate
	--into #old_supply
		from ICStockBill t1 
		INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
		where FSupplyID in
		(select FItemID from t_Organization where year(F_123)='2016')
		and 
		year(fdate)='2016'
		and
		t1.FTranType=21 
		And t1.FCheckerID>0 
		group by t1.FSupplyID
	)
)ttt1
group by FSupplyID




select tt3.FName AS ����,
	tt6.FName AS ҵ��Ա,
	tt5.FName AS ��ҵ, 
	tt2.FName AS �ͻ�����,
	--CASE tt2.FComboBox 
	--	WHEN '00' THEN '��������'
	--	WHEN '01' THEN 'չ��'
	--	WHEN '02' THEN '�ͻ�����'
	--	WHEN '03' THEN '��־'
	--	WHEN '04' THEN '�ֳ���Ϣ'
	--	WHEN '05' THEN '����Ͱ�'
	--	WHEN '06' THEN '��˾��վ'
	--	ELSE ''
	--END
	--AS ��Դ,
	--tt2.FContact AS ��ϵ��,
	--tt2.FPhone AS �绰,
	--tt2.FFax AS ����,
	--tt2.FAddress AS ��ַ,
	tt2.F_101 AS �ͻ�����,
	tt2.F_123 AS ��������,
	tt1.FConsignAmount2016 AS [2016�����۶�],
	tt1.FConsignAmount2017 AS [2017�����۶�]
 from
 (
select t1.FSupplyID as FSupplyID,
	[FConsignAmount2016]=ISNULL(SUM(CASE when year(t2.FDate)= '2016' then t3.FConsignAmount END),0),
	[FConsignAmount2017]=ISNULL(SUM(CASE when year(t2.FDate)= '2017' and datediff(month,t1.FMinDate,t2.FDate)<12 then t3.FConsignAmount END),0)
from #old_supply t1
left join  ICStockBill t2 on t1.FSupplyID=t2.FSupplyID
left join ICStockBillEntry t3 on t2.FInterID=t3.FInterID
where year(t2.FDate) in('2016','2017')
and
t2.FTranType=21 
And t2.FCheckerID>0 
group by t1.FSupplyID
) tt1
LEFT JOIN t_Organization tt2 ON tt1.FSupplyID=tt2.FItemID
LEFT JOIN t_Item tt3 ON tt2.Fdepartment=tt3.FItemID
LEFT JOIN t_Item tt4 ON tt2.F_122=tt4.FItemID
LEFT JOIN t_Item tt5 ON tt2.F_117=tt5.FItemID
LEFT JOIN t_Emp tt6 ON tt2.Femployee=tt6.FItemID


drop table #old_supply
drop table #temp_ICS


--select datediff(day,GETDATE(),'2019-02-06')
