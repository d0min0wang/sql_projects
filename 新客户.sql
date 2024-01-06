--新增客户新算法
declare @FYear AS int
DECLARE @FMonth AS int
SET @FYear=2023
set @FMonth=8
;WITH cte1
as
(
--SELECT TT1.FSupplyID, MIN(TT1.FDate) as fdate
--FROM
	--(
		SELECT T1.FSupplyID, T1.FDate
		FROM
			(select
				v1.FSupplyID AS FSupplyID,
				min(v1.FDate) as FDate
			From ICStockBill v1
				inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
			where v1.FTranType=21 and year(v1.FDate)=CAST(@FYear as varchar(4))
			GROUP BY v1.FSupplyID) T1
			LEFT JOIN
			(select
				v1.FSupplyID AS FSupplyID,
				max(v1.FDate) as FDate
			From ICStockBill v1
				inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
			where v1.FTranType=21 and year(v1.FDate)<=CAST(@FYear-1 as varchar(4))
			GROUP BY v1.FSupplyID) T2
			ON T1.FSupplyID = T2.FSupplyID
		WHERE (CASE WHEN T2.FDate IS NULL THEN 0 ELSE CAST(DATEDIFF(MONTH, T2.FDate, T1.FDate) AS INT) END) > 12
			OR (CASE WHEN T2.FDate IS NULL THEN 0 ELSE CAST(DATEDIFF(MONTH, T2.FDate, T1.FDate) AS INT) END) = 0

	UNION ALL
		SELECT T1.FSupplyID, T1.FDate
		FROM
			(select
				v1.FSupplyID AS FSupplyID,
				min(v1.FDate) as FDate
			From ICStockBill v1
				inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
			where v1.FTranType=21 and year(v1.FDate)=CAST(@FYear-1 as varchar(4))
			GROUP BY v1.FSupplyID) T1
			LEFT JOIN
			(select
				v1.FSupplyID AS FSupplyID,
				max(v1.FDate) as FDate
			From ICStockBill v1
				inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
			where v1.FTranType=21 and year(v1.FDate)<=CAST(@FYear-2 as varchar(4))
			GROUP BY v1.FSupplyID) T2
			ON T1.FSupplyID = T2.FSupplyID
		WHERE (CASE WHEN T2.FDate IS NULL THEN 0 ELSE CAST(DATEDIFF(MONTH, T2.FDate, T1.FDate) AS INT) END) > 12
			OR (CASE WHEN T2.FDate IS NULL THEN 0 ELSE CAST(DATEDIFF(MONTH, T2.FDate, T1.FDate) AS INT) END) = 0--) TT1
--GROUP BY TT1.FSupplyID
)

select t5.FName,
    case Year(t1.fdate) when CAST(@FYear-1 as varchar(4)) then COUNT(t1.FSupplyID) end as fcount_last,
    case Year(t1.fdate) when CAST(@FYear as varchar(4)) then COUNT(t1.FSupplyID) end as fcount_this 
FROM cte1 t1
left join t_Organization t4 on t1.FSupplyID=t4.FItemID
left join t_Department t5 on t4.FDepartment=t5.FItemID
GROUP BY t5.FName ,year(t1.fdate)
ORDER BY t5.FName 

--新客户销售额
;WITH cte1
as
(

		SELECT T1.FSupplyID, T1.FDate
		FROM
			(select
				v1.FSupplyID AS FSupplyID,
				min(v1.FDate) as FDate
			From ICStockBill v1
				inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
			where v1.FTranType=21 and year(v1.FDate)=CAST(@FYear as varchar(4))
			GROUP BY v1.FSupplyID) T1
			LEFT JOIN
			(select
				v1.FSupplyID AS FSupplyID,
				max(v1.FDate) as FDate
			From ICStockBill v1
				inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
			where v1.FTranType=21 and year(v1.FDate)<=CAST(@FYear-1 as varchar(4))
			GROUP BY v1.FSupplyID) T2
			ON T1.FSupplyID = T2.FSupplyID
		WHERE (CASE WHEN T2.FDate IS NULL THEN 0 ELSE CAST(DATEDIFF(MONTH, T2.FDate, T1.FDate) AS INT) END) > 12
			OR (CASE WHEN T2.FDate IS NULL THEN 0 ELSE CAST(DATEDIFF(MONTH, T2.FDate, T1.FDate) AS INT) END) = 0

	UNION ALL
		SELECT T1.FSupplyID, T1.FDate
		FROM
			(select
				v1.FSupplyID AS FSupplyID,
				min(v1.FDate) as FDate
			From ICStockBill v1
				inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
			where v1.FTranType=21 and year(v1.FDate)=CAST(@FYear-1 as varchar(4))
			GROUP BY v1.FSupplyID) T1
			LEFT JOIN
			(select
				v1.FSupplyID AS FSupplyID,
				max(v1.FDate) as FDate
			From ICStockBill v1
				inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
			where v1.FTranType=21 and year(v1.FDate)<=CAST(@FYear-2 as varchar(4))
			GROUP BY v1.FSupplyID) T2
			ON T1.FSupplyID = T2.FSupplyID
		WHERE (CASE WHEN T2.FDate IS NULL THEN 0 ELSE CAST(DATEDIFF(MONTH, T2.FDate, T1.FDate) AS INT) END) > 12
			OR (CASE WHEN T2.FDate IS NULL THEN 0 ELSE CAST(DATEDIFF(MONTH, T2.FDate, T1.FDate) AS INT) END) = 0
)
select t5.FName,sum(t3.FConsignAmount) FROM cte1 t1
LEFT JOIN ICStockBill t2 on t1.FSupplyID=t2.FSupplyID AND CAST(DATEDIFF(MONTH, t1.FDate, t2.FDate) AS INT)<12 
LEFT JOIN ICStockBillEntry t3 ON t2.FInterID=t3.FInterID 
left join t_Organization t4 on t1.FSupplyID=t4.FItemID
left join t_Department t5 on t4.FDepartment=t5.FItemID
WHERE YEAR(t2.FDate)=CAST(@FYear as varchar(4)) AND t2.FTranType=21
GROUP BY t5.FName 
ORDER BY t5.FName 

