--新增客户新算法
declare @FYear AS int
SET @FYear=2023
;WITH CTE_CustID
AS
(
  SELECT T1.FSupplyID, T1.FDate
		FROM
			(select
				v1.FSupplyID AS FSupplyID,
				min(v1.FDate) as FDate
			From ICStockBill v1
				inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
			where v1.FTranType=21 and year(v1.FDate)=CAST(@FYear as varchar(4)) AND MONTH(v1.FDate)<=6
			GROUP BY v1.FSupplyID) T1
			LEFT JOIN
			(select
				v1.FSupplyID AS FSupplyID,
				max(v1.FDate) as FDate
			From ICStockBill v1
				inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
			where v1.FTranType=21 and year(v1.FDate)=CAST(@FYear-1 as varchar(4)) AND MONTH(v1.FDate)<=6
			GROUP BY v1.FSupplyID) T2
			ON T1.FSupplyID = T2.FSupplyID
		WHERE (CASE WHEN T2.FDate IS NULL THEN 0 ELSE CAST(DATEDIFF(MONTH, T2.FDate, T1.FDate) AS INT) END) > 12
			OR (CASE WHEN T2.FDate IS NULL THEN 0 ELSE CAST(DATEDIFF(MONTH, T2.FDate, T1.FDate) AS INT) END) = 0

)
select t5.FName,sum(t3.FConsignAmount) FROM CTE_CustID t1
LEFT JOIN ICStockBill t2 on t1.FSupplyID=t2.FSupplyID
LEFT JOIN ICStockBillEntry t3 ON t2.FInterID=t3.FInterID
left join t_Organization t4 on t1.FSupplyID=t4.FItemID
left join t_Department t5 on t4.FDepartment=t5.FItemID
WHERE YEAR(t2.FDate)=CAST(@FYear as varchar(4))
GROUP BY t5.FName


--今年新增客户
select '累计新增客户销售额(元)' AS fname, 
    t4.FName,
	[销售额]=ISNULL(SUM(CASE WHEN
                                (convert(varchar(10),t3.F_123,120)>='2022-01-01' and convert(varchar(10),t3.F_123,120)<'2022-07-01') and
                                (convert(varchar(10),t1.FDate,120)>='2022-01-01' and convert(varchar(10),t1.FDate,120)<'2022-07-01')
                                  then t2.FConsignAmount END),0),
    [今年]=ISNULL(SUM(CASE WHEN
                                (convert(varchar(10),t3.F_123,120)>='2023-01-01' and convert(varchar(10),t3.F_123,120)<'2023-07-01') and
                                (convert(varchar(10),t1.FDate,120)>='2023-01-01' and convert(varchar(10),t1.FDate,120)<'2023-07-01')
                                  then t2.FConsignAmount END),0)
from ICStockBill t1 
INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
LEFT JOIN t_Organization t3 ON t1.FSupplyID=t3.FItemID
LEFT JOIN t_Department t4 ON t3.Fdepartment=t4.FItemID
where 
YEAR(t1.FDate) IN ('2022' ,'2023')
and YEAR(t3.F_123) IN ('2022' ,'2023')
and t1.FTranType=21 
GROUP BY t4.fname 



SELECT  '累计新增规格销售额(元)' AS fname,
        t4.fname as fdepartment,
		[销售额]=ISNULL(SUM(CASE WHEN
                                (convert(varchar(10),t2.FCreateDate,120)>='2022-01-01' and convert(varchar(10),t2.FCreateDate,120)<'2022-07-01') and
                                (convert(varchar(10),v1.FDate,120)>='2022-01-01' and convert(varchar(10),v1.FDate,120)<'2022-07-01')
                                  then u1.FConsignAmount END),0),
        [今年]=ISNULL(SUM(CASE WHEN
                                (convert(varchar(10),t2.FCreateDate,120)>='2023-01-01' and convert(varchar(10),t2.FCreateDate,120)<'2023-07-01') and
                                (convert(varchar(10),v1.FDate,120)>='2023-01-01' and convert(varchar(10),v1.FDate,120)<'2023-07-01')
                                  then u1.FConsignAmount END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_ICItem t1 ON u1.FItemID=t1.FItemID
	LEFT JOIN t_BaseProperty t2 on	 t1.FItemID=t2.FItemID AND t2.FTypeID=3 
	LEFT JOIN t_Organization t3 ON v1.FSupplyID=t3.FItemID
	LEFT JOIN t_Department t4 ON t3.Fdepartment=t4.FItemID
	left join t_Item t5 ON t3.F_117=t5.FItemID
	WHERE YEAR(v1.FDate) IN ('2021' ,'2022','2023')
    and YEAR(t2.FCreateDate) IN ('2021' ,'2022','2023')
    --where year(v1.FDate)IN ('2022') 
	--and year(t2.FCreateDate) in ('2022')
	--and month(v1.FDate)<='6'
	and v1.FTranType=21 
    GROUP BY t4.fname