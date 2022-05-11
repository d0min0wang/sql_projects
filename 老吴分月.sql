DECLARE @Period char(5)
SET @Period='2008' --统计的年份


--SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
--	FMonth=CASE WHEN GROUPING(DATEPART(month,v1.FDate))=1 THEN '<月份合计>' ELSE (DATEPART(year,v1.FDate)) END,
SELECT FDepartment=v3.FName,
	FMonth=DATEPART(month,v1.FDate),
    C_Money=ISNULL(SUM(CASE CAST(DATEPART(year,v1.FDate) AS varchar) WHEN @Period THEN u1.FConsignAmount END),0),
    C_AuxQty=ISNULL(SUM(CASE CAST(DATEPART(year,v1.FDate) AS varchar) WHEN @Period THEN u1.FAuxQty END),0)
--FROM t_xySaleReporttest
--select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
FROM ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID

WHERE v1.FTranType=21 

GROUP BY v3.FName,DATEPART(month,v1.FDate)
ORDER BY v3.FName,DATEPART(month,v1.FDate)