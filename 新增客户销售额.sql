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




select tt3.FName AS 部门,
	tt6.FName AS 业务员,
	tt5.FName AS 行业, 
	tt2.FName AS 客户名称,
	--CASE tt2.FComboBox 
	--	WHEN '00' THEN '其他网络'
	--	WHEN '01' THEN '展会'
	--	WHEN '02' THEN '客户介绍'
	--	WHEN '03' THEN '杂志'
	--	WHEN '04' THEN '现场信息'
	--	WHEN '05' THEN '阿里巴巴'
	--	WHEN '06' THEN '公司网站'
	--	ELSE ''
	--END
	--AS 来源,
	--tt2.FContact AS 联系人,
	--tt2.FPhone AS 电话,
	--tt2.FFax AS 传真,
	--tt2.FAddress AS 地址,
	tt2.F_101 AS 客户分类,
	tt2.F_123 AS 新增日期,
	tt1.FConsignAmount2016 AS [2016年销售额],
	tt1.FConsignAmount2017 AS [2017年销售额]
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
