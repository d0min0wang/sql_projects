--新客户在2019年销售额

--再次交易的老客户
WITH CTE_OLD
AS
(
	SELECT FItemID,F_123 FROM t_Organization WHERE F_123<'2018-01-01'
),
cte_old0
AS
(
	SELECT FSupplyID AS FSupplyID,
	min(FDate) AS FMinDate
	from ICStockBill
	where FDate>='2018-01-01'
	AND
	fsupplyid in (select fitemid from CTE_old)
	and
	FTranType=21 
	And FCheckerID>0 
	group by FSupplyID
),
cte_old1
AS
(
	SELECT FSupplyID AS FSupplyID,
	max(FDate) AS FMaxDate
	from ICStockBill
	where FDate<'2018-01-01'
	AND
	FSupplyID in (select FSupplyID from CTE_OLD)
	and
	FTranType=21 
	And FCheckerID>0 
	group by FSupplyID
),
CTE_OLD_ALL
AS
(
SELECT t1.FSupplyID,t1.FMinDate FROM cte_old0 t1
LEFT JOIN cte_old1 t2 ON t1.FSupplyID=t2.FSupplyID
LEFT JOIN cte_old t3 ON t1.FSupplyID=t3.FItemID
WHERE
datediff(month,t2.FMaxDate,t1.FMinDate)>12 
OR
datediff(month,t2.FMaxDate,t1.FMinDate) IS NULL
),
--2018\2019年新开发客户
CTE
AS
(
	SELECT FItemID,F_123 FROM t_Organization WHERE F_123>='2018-01-01'
),
CTE1
AS
(
SELECT FSupplyID as FSupplyID,
	min(FDate) AS FMinDate
FROM ICStockBill
WHERE
FDate >='2018-01-01'
AND
FSupplyID IN (select fitemid from CTE)
and
FTranType=21 
AND FCheckerID>0 
GROUP BY FSupplyID
),
CTE_ALL
AS
(
	SELECT * FROM CTE_OLD_ALL
	UNION all
	SELECT * FROM CTE1
),
CTE_RESULT
AS
(
select t1.FSupplyID as FSupplyID,
--t1.FMinDate,
--t2.FDate,
--DATEDIFF( MONTH,t1.FMinDate,t2.FDate)
	[FConsignAmount2018]=ISNULL(SUM(CASE when year(t2.FDate)= '2018' then t3.FConsignAmount END),0),
	[FConsignAmount2019]=ISNULL(SUM(CASE when year(t2.FDate)= '2019' then t3.FConsignAmount END),0)
	--sum(t2.FConsignAmount) AS FConsignAmount,
	--[FAuxQtySum2018]=ISNULL(SUM(CASE when year(t1.FDate)= '2018' then t2.FAuxQty END),0),
	--[FAuxQtySum2019]=ISNULL(SUM(CASE when year(t1.FDate)= '2019' then t2.FAuxQty END),0)
from CTE_ALL t1
LEFT JOIN ICStockBill t2 ON t1.FSupplyID=t2.FSupplyID
INNER JOIN ICStockBillEntry t3 ON t2.FInterID=t3.FInterID
WHERE DATEDIFF( MONTH,t1.FMinDate,t2.FDate)<=12
GROUP BY t1.FSupplyID
)

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
	tt1.FConsignAmount2019 AS [2019年销售额]
	--tt1.FAuxQtySum2018 AS [2018年出货量],
	--tt1.FAuxQtySum2019 AS [2019年出货量]
 from CTE_RESULT tt1
LEFT JOIN t_Organization tt2 ON tt1.FSupplyID=tt2.FItemID
LEFT JOIN t_Item tt3 ON tt2.Fdepartment=tt3.FItemID
LEFT JOIN t_Item tt4 ON tt2.F_122=tt4.FItemID
LEFT JOIN t_Item tt5 ON tt2.F_117=tt5.FItemID
LEFT JOIN t_Emp tt6 ON tt2.Femployee=tt6.FItemID






--老客户在2019年销售额

WITH CTE_OLD
AS
(
	SELECT FItemID,F_123 FROM t_Organization WHERE F_123<'2018-01-01'
),
cte_old0
AS
(
	SELECT FSupplyID AS FSupplyID,
	min(FDate) AS FMinDate
	from ICStockBill
	where FDate>='2018-01-01'
	AND
	fsupplyid in (select fitemid from CTE_old)
	and
	FTranType=21 
	And FCheckerID>0 
	group by FSupplyID
),
cte_old1
AS
(
	SELECT FSupplyID AS FSupplyID,
	max(FDate) AS FMaxDate
	from ICStockBill
	where FDate<'2018-01-01'
	AND
	FSupplyID in (select FSupplyID from CTE_OLD)
	and
	FTranType=21 
	And FCheckerID>0 
	group by FSupplyID
),
CTE_OLD_ALL
AS
(
SELECT t1.FSupplyID,t1.FMinDate FROM cte_old0 t1
LEFT JOIN cte_old1 t2 ON t1.FSupplyID=t2.FSupplyID
LEFT JOIN cte_old t3 ON t1.FSupplyID=t3.FItemID
WHERE
datediff(month,t2.FMaxDate,t1.FMinDate)>12 
OR
datediff(month,t2.FMaxDate,t1.FMinDate) IS NULL
),
CTE
AS
(
	SELECT FItemID,F_123 FROM t_Organization WHERE year(F_123) IN ('2018','2019')
),
CTE1
AS
(
SELECT FSupplyID as FSupplyID,
	min(FDate) AS FMinDate
FROM ICStockBill
WHERE
FDate >='2018-01-01'
AND
FSupplyID IN (select fitemid from CTE)
and
FTranType=21 
AND FCheckerID>0 
GROUP BY FSupplyID
),
CTE_ALL
AS
(
	SELECT * FROM CTE_OLD_ALL
	UNION all
	SELECT * FROM CTE1
),
CTE_RESULT
AS
(
select t1.FSupplyID as FSupplyID,
	[FConsignAmount2018]=ISNULL(SUM(CASE when year(t1.FDate)= '2018' then t2.FConsignAmount END),0),
	[FConsignAmount2019]=ISNULL(SUM(CASE when year(t1.FDate)= '2019' then t2.FConsignAmount END),0)
	--sum(t2.FConsignAmount) AS FConsignAmount,
	--[FAuxQtySum2018]=ISNULL(SUM(CASE when year(t1.FDate)= '2018' then t2.FAuxQty END),0),
	--[FAuxQtySum2019]=ISNULL(SUM(CASE when year(t1.FDate)= '2019' then t2.FAuxQty END),0)
from ICStockBill t1 
INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
where year(t1.FDate) in('2018','2019')
and
t1.FSupplyID NOT IN (select FSupplyID from CTE_ALL)
and
t1.FTranType=21 
And t1.FCheckerID>0 
group by t1.FSupplyID
)
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
	CASE (tt1.FConsignAmount2019-tt1.FConsignAmount2018) when 0 then 0 else (tt1.FConsignAmount2019-tt1.FConsignAmount2018)/tt1.FConsignAmount2018 END AS Increase
	--tt1.FAuxQtySum2018 AS [2018年出货量],
	--tt1.FAuxQtySum2019 AS [2019年出货量]
 from CTE_RESULT tt1
LEFT JOIN t_Organization tt2 ON tt1.FSupplyID=tt2.FItemID
LEFT JOIN t_Item tt3 ON tt2.Fdepartment=tt3.FItemID
LEFT JOIN t_Item tt4 ON tt2.F_122=tt4.FItemID
LEFT JOIN t_Item tt5 ON tt2.F_117=tt5.FItemID
LEFT JOIN t_Emp tt6 ON tt2.Femployee=tt6.FItemID
where tt1.FConsignAmount2018>=100000
and
(tt1.FConsignAmount2019-tt1.FConsignAmount2018)/tt1.FConsignAmount2018>0.3


--where --year(tt1.FMinDate)='2015'

--drop table #old_supply