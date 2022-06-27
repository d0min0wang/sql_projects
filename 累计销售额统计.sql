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
	where year(v1.FDate)IN ('2021') 
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
	where year(v1.FDate)IN ('2021') 
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