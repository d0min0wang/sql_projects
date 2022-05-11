--2018年开发的客户在2019年销售额

select tt1.FSupplyID 
into #old_supply
from
(select t1.FSupplyID as FSupplyID,
	min(t1.FDate) AS FMinDate
from ICStockBill t1 
INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
where year(t1.FDate)='2019'
and
t1.FTranType=21 
And t1.FCheckerID>0 
group by t1.FSupplyID)tt1
left join
(select t1.FSupplyID as FSupplyID,
	max(t1.FDate) AS FMaxDate
from ICStockBill t1 
INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
where year(t1.FDate)='2018'
and
t1.FTranType=21 
And t1.FCheckerID>0 
group by t1.FSupplyID)tt2 on tt1.FSupplyID=tt2.FSupplyID
where datediff(month,tt2.FMaxDate,tt1.FMinDate)<=12


SELECT FItemID INTO #old_supply FROM t_Organization WHERE year(F_123)='2018'

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
	tt1.FConsignAmount2018 AS [2018年销售额],
	tt1.FConsignAmount2019 AS [2019年销售额],
	tt1.FAuxQtySum2018 AS [2018年出货量],
	tt1.FAuxQtySum2019 AS [2019年出货量]
 from
(select t1.FSupplyID as FSupplyID,
	[FConsignAmount2018]=ISNULL(SUM(CASE when year(t1.FDate)= '2018' then t2.FConsignAmount END),0),
	[FConsignAmount2019]=ISNULL(SUM(CASE when year(t1.FDate)= '2019' then t2.FConsignAmount END),0),
	--sum(t2.FConsignAmount) AS FConsignAmount,
	[FAuxQtySum2018]=ISNULL(SUM(CASE when year(t1.FDate)= '2018' then t2.FAuxQty END),0),
	[FAuxQtySum2019]=ISNULL(SUM(CASE when year(t1.FDate)= '2019' then t2.FAuxQty END),0)
from ICStockBill t1 
INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
where year(t1.FDate) in('2018','2019')
and
t1.FSupplyID in(SELECT FItemID FROM t_Organization WHERE year(F_123)='2018')
and
t1.FTranType=21 
And t1.FCheckerID>0 
group by t1.FSupplyID )tt1
LEFT JOIN t_Organization tt2 ON tt1.FSupplyID=tt2.FItemID
LEFT JOIN t_Item tt3 ON tt2.Fdepartment=tt3.FItemID
LEFT JOIN t_Item tt4 ON tt2.F_122=tt4.FItemID
LEFT JOIN t_Item tt5 ON tt2.F_117=tt5.FItemID
LEFT JOIN t_Emp tt6 ON tt2.Femployee=tt6.FItemID
--where --year(tt1.FMinDate)='2015'

drop table #old_supply