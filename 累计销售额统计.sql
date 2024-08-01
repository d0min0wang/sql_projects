--累计出货金额
;WITH Amount
AS
(
SELECT CONVERT(varchar(100), v1.fdate, 23) AS fdate, 
    sum(u1.FConsignAmount) AS FConsignAmount
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	where year(v1.FDate)IN ('2023') 
	--and month(v1.FDate)<='2'
	
	and v1.FTranType=21 
    GROUP BY CONVERT(varchar(100), v1.fdate, 23)
)
SELECT
  fdate,
  FConsignAmount,
  SUM(FConsignAmount) over () AS FAllAmount,
  SUM(FConsignAmount) over (PARTITION BY fdate) AS FDateAmount,
  SUM(FConsignAmount) over (
ORDER BY fdate) AS FAccAmount
FROM
  Amount

--累计订单金额
;WITH Amount
AS
(
SELECT CONVERT(varchar(100), v1.fdate, 23) AS fdate, 
    sum(u1.FConsignAmount) AS FConsignAmount
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	where year(v1.FDate)IN ('2020') 
	--and month(v1.FDate)<='2'
	
	and v1.FTranType=21 
    GROUP BY CONVERT(varchar(100), v1.fdate, 23)
)
SELECT
  fdate,
  FConsignAmount,
  SUM(FConsignAmount) over () AS FAllAmount,
  SUM(FConsignAmount) over (PARTITION BY fdate) AS FDateAmount,
  SUM(FConsignAmount) over (
ORDER BY fdate) AS FAccAmount
FROM
  Amount


--累计订单金额对比
;WITH Amount
AS
(
SELECT cast(format(v1.fdate, 'MM-dd') AS nvarchar(5)) AS fdate, 
    sum(case year(v1.FDate) when '2020' then u1.FConsignAmount else 0 end) AS FConsignAmount2020,
    sum(case year(v1.FDate) when '2021' then u1.FConsignAmount else 0 end) AS FConsignAmount2021,
    sum(case year(v1.FDate) when '2022' then u1.FConsignAmount else 0 end) AS FConsignAmount2022,
    sum(case year(v1.FDate) when '2023' then u1.FConsignAmount else 0 end) AS FConsignAmount2023,
    sum(case year(v1.FDate) when '2024' then u1.FConsignAmount else 0 end) AS FConsignAmount2024
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
  LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
  WHERE v3.FName='新能源事业部'
	--where year(v1.FDate)IN ('2020','2021','2022') 
	--and month(v1.FDate)<='2'
	
	and v1.FTranType=21 
    GROUP BY cast(format(v1.fdate, 'MM-dd') AS nvarchar(5))
)
SELECT
  fdate,
  --FConsignAmount2021,
  --FConsignAmount2022,
  --SUM(FConsignAmount2021) over () AS FAllAmount2021,
  --SUM(FConsignAmount2022) over () AS FAllAmount2022,
  --SUM(FConsignAmount2021) over (PARTITION BY fdate) AS FDateAmount2021,
  --SUM(FConsignAmount2022) over (PARTITION BY fdate) AS FDateAmount2022,
  SUM(FConsignAmount2020) over (ORDER BY fdate) AS [2020],
  SUM(FConsignAmount2021) over (ORDER BY fdate) AS [2021],
  SUM(FConsignAmount2022) over (ORDER BY fdate) AS [2022],
  SUM(FConsignAmount2023) over (ORDER BY fdate) AS [2023],
  SUM(FConsignAmount2024) over (ORDER BY fdate) AS [2024]
FROM
  Amount

  select len(format(GETDATE(),'MM-dd'))