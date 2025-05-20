--新增客户新算法 2024年新客户+新产品销售数据报表
declare @FYear AS int
DECLARE @FMonth AS int
SET @FYear=2024
set @FMonth=12



--新增客户数量
;WITH CTE_CustID_Trade
AS
(
  SELECT T1.FSupplyID, T1.FDate--,t2.FDate AS NewFDate
		FROM
			(select
				v1.FSupplyID AS FSupplyID,
				min(v1.FDate) as FDate
			From ICStockBill v1
				inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
			where v1.FTranType=21 and year(v1.FDate)=CAST(@FYear as varchar(4)) AND MONTH(v1.FDate)<=@FMonth
			GROUP BY v1.FSupplyID) T1
			LEFT JOIN
			(select
				v1.FSupplyID AS FSupplyID,
				max(v1.FDate) as FDate
			From ICStockBill v1
				inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
			where v1.FTranType=21 and year(v1.FDate)<=CAST(@FYear-1 as varchar(4)) --AND MONTH(v1.FDate)<=@FMonth
			GROUP BY v1.FSupplyID) T2
			ON T1.FSupplyID = T2.FSupplyID
		WHERE (CASE WHEN T2.FDate IS NULL THEN 0 ELSE CAST(DATEDIFF(MONTH, T2.FDate, T1.FDate) AS INT) END) > 12
			OR (CASE WHEN T2.FDate IS NULL THEN 0 ELSE CAST(DATEDIFF(MONTH, T2.FDate, T1.FDate) AS INT) END) = 0

),
CTE_CustID_Union
AS
(
	SELECT * FROM CTE_CustID_Trade
	UNION ALL
	SELECT FItemID,F_123 FROM t_Organization WHERE YEAR(F_123)=CAST(@FYear as varchar(4)) AND MONTH(F_123)<=@FMonth
),
CTE_CustID
AS
(
	SELECT *
  	FROM (
		SELECT  FSupplyID,
				fdate,
				ROW_NUMBER() OVER(PARTITION BY FSupplyID ORDER BY FSupplyID DESC) rn
			FROM CTE_CustID_Union
		) a
	WHERE rn = 1
)
select t5.FName,t4.FName,t6.FDate as 首次交易日期,t4.F_123 as 新增日期 FROM CTE_CustID t1
left join t_Organization t4 on t1.FSupplyID=t4.FItemID
left join t_Department t5 on t4.FDepartment=t5.FItemID
LEFT JOIN CTE_CustID_Trade t6 ON t1.FSupplyID=t6.FSupplyID
--where t5.Fname='食品设备事业部'



--全新开发客户数量
;WITH CTE_CustID_Trade
AS
(
  SELECT T1.FSupplyID, T1.FDate
		FROM
			(select
				v1.FSupplyID AS FSupplyID,
				min(v1.FDate) as FDate
			From ICStockBill v1
				inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
			where v1.FTranType=21 and year(v1.FDate)=CAST(@FYear as varchar(4)) AND MONTH(v1.FDate)<=@FMonth
			GROUP BY v1.FSupplyID) T1
			LEFT JOIN
			(select
				v1.FSupplyID AS FSupplyID,
				max(v1.FDate) as FDate
			From ICStockBill v1
				inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
			where v1.FTranType=21 and year(v1.FDate)=CAST(@FYear-1 as varchar(4)) --AND MONTH(v1.FDate)<=@FMonth
			GROUP BY v1.FSupplyID) T2
			ON T1.FSupplyID = T2.FSupplyID
		WHERE (CASE WHEN T2.FDate IS NULL THEN 0 ELSE CAST(DATEDIFF(MONTH, T2.FDate, T1.FDate) AS INT) END) = 0

),
CTE_CustID_Union
AS
(
	SELECT * FROM CTE_CustID_Trade
	UNION ALL
	SELECT FItemID,F_123 FROM t_Organization WHERE YEAR(F_123)=CAST(@FYear as varchar(4)) AND MONTH(F_123)<=@FMonth
),
CTE_CustID
AS
(
	SELECT *
  	FROM (
		SELECT  FSupplyID,
				fdate,
				ROW_NUMBER() OVER(PARTITION BY FSupplyID ORDER BY FSupplyID DESC) rn
			FROM CTE_CustID_Union
		) a
	WHERE rn = 1
)
select t5.FName,t4.FName,t6.FDate as 首次交易日期,t4.F_123 AS 新增日期 FROM CTE_CustID t1
left join t_Organization t4 on t1.FSupplyID=t4.FItemID
left join t_Department t5 on t4.FDepartment=t5.FItemID
LEFT JOIN CTE_CustID_Trade t6 ON t1.FSupplyID=t6.FSupplyID
--where t5.Fname='食品设备事业部'