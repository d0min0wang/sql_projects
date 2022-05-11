--select * from t_TableDescription WHERE FDescription LIKE '%库%'

--select * from ICStockBill t1
--LEFT JOIN ICStockBillEntry t2
--ON t1.FInterID=t2.FInterID
--WHERE FTranType=21 AND FDate BETWEEN '2010-01-01' AND '2010-02-28'
--create table [t_xySaleReport](FMonth nvarchar(200),FDepartment nvarchar(200),FbigTrade nvarchar(200),FCustomer nvarchar(200),FQty decimal(18,4),FAmount decimal(18,4))
--create table [t_xySaleTongbi](FDepartmentLast nvarchar(200),FbigTradeLast nvarchar(200),
--								FQtyLast decimal(18,4),FAmountLast decimal(18,4),
--								FDepartmentNow nvarchar(200),FbigTradeNow nvarchar(200),
--								FQtyNow decimal(18,4),FAmountNow decimal(18,4))
--create table [t_xySaleReportAfterLast](FMonth nvarchar(200),FDepartment nvarchar(200),FbigTrade nvarchar(200),FCustomer nvarchar(200),FQty decimal(18,4),FAmount decimal(18,4))
--create table [t_xySaleReportAfterNow](FMonth nvarchar(200),FDepartment nvarchar(200),FbigTrade nvarchar(200),FCustomer nvarchar(200),FQty decimal(18,4),FAmount decimal(18,4))
--drop table t_xySaleReport
--drop table t_xySaleTongbi
--09年数据
truncate table t_xySaleReport
--truncate table t_xySaleTongbi
truncate table t_xySaleReportAfterLast
insert into [t_xySaleReport](FMonth,FDepartment,FbigTrade,FCustomer,FQty,FAmount)
select month(v1.FDate),v3.FName,v2.F_110,v3.Fname,u1.FAuxQty,u1.FConsignAmount
--SELECT v1.FSupplyID,v4.FShortNumber,v2.FNumber,v2.FName,
--	u1.FConsignPrice,
--	u1.FConsignAmount,
--		u1.FAuxQty,v3.FName,v2.F_110
		--,v2.F_111
--	,v5.FName AS FProdTrade,v4.FName AS FMidTrade,v3.FName AS FBigTrade 
FROM ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID
WHERE v1.FTranType=21 And v1.FDate BETWEEN '2009-01-01' AND '2009-01-31' 
INSERT INTO t_xySaleReportAfterLast(FDepartment,FbigTrade,FQty,FAmount)
SELECT CASE WHEN (GROUPING(FDepartment) = 1) THEN 'FDepartmentALL' 
            ELSE ISNULL(FDepartment, 'UNKNOWN') 
       END AS FDepartment, 
       CASE WHEN (GROUPING(FbigTrade) = 1) THEN 'FbigTradeALL' 
            ELSE ISNULL(FbigTrade, 'UNKNOWN') 
       END AS FbigTrade, 
       --购货单位 AS 购货单位,
       SUM(FQty) AS FQty,
       SUM(FAmount) AS FAmount 
FROM [t_xySaleReport]
GROUP BY Fdepartment,FbigTrade  WITH ROLLUP 




--10年数据
truncate table t_xySaleReport
--truncate table t_xySaleTongbi
truncate table t_xySaleReportAfterNow
insert into [t_xySaleReport](FMonth,FDepartment,FbigTrade,FCustomer,FQty,FAmount)
select month(v1.FDate),v3.FName,v2.F_110,v3.Fname,u1.FAuxQty,u1.FConsignAmount
--SELECT v1.FSupplyID,v4.FShortNumber,v2.FNumber,v2.FName,
--	u1.FConsignPrice,
--	u1.FConsignAmount,
--		u1.FAuxQty,v3.FName,v2.F_110
		--,v2.F_111
--	,v5.FName AS FProdTrade,v4.FName AS FMidTrade,v3.FName AS FBigTrade 
FROM ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID
WHERE v1.FTranType=21 And v1.FDate BETWEEN '2010-01-01' AND '2010-01-31' 
INSERT INTO t_xySaleReportAfterNow(FDepartment,FbigTrade,FQty,FAmount)
SELECT CASE WHEN (GROUPING(FDepartment) = 1) THEN 'FDepartmentALL' 
            ELSE ISNULL(FDepartment, 'UNKNOWN') 
       END AS FDepartment, 
       CASE WHEN (GROUPING(FbigTrade) = 1) THEN 'FbigTradeALL' 
            ELSE ISNULL(FbigTrade, 'UNKNOWN') 
       END AS FbigTrade, 
       --购货单位 AS 购货单位,
       SUM(FQty) AS FQty,
       SUM(FAmount) AS FAmount 
FROM [t_xySaleReport]
GROUP BY Fdepartment,FbigTrade  WITH ROLLUP 


--同比分析
TRUNCATE TABLE t_xySaleTongbi
INSERT INTO t_xySaleTongbi(FDepartmentLast,FbigTradeLast,
								FQtyLast,FAmountLast,
								FDepartmentNow,FbigTradeNow,
								FQtyNow,FAmountNow)
SELECT t1.FDepartment,t1.FbigTrade,t1.FQty,t1.FAmount,
	t2.FDepartment,t2.FbigTrade,t2.FQty,t2.FAmount
FROM t_xySaleReportAfterLast t1
FULL JOIN t_xySaleReportAfterNow t2
ON t1.FDepartment=t2.FDepartment AND t1.FbigTrade=t2.FbigTrade
--select * From t_xySaleReportAfterNow
--select * From t_xySaleReportAfterAfter
--select * from t_xySaleTongbi