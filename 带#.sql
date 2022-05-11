DECLARE @Year char(4)
SET @Year='2012' 

--端子套带#销售额 
   SELECT --v3.FName,
	'端子套带#销售额 ',sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	where v3.FName like '%端子套%' and v2.FName like '%#' 
	and year(v1.FDate)=@Year
	and v1.FDate<'2012-08-01'
	GROUP BY v3.FName --with rollup
UNION ALL
--防尘帽带&销售额
    SELECT --v3.FName,
	'防尘帽带&销售额',sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	where v3.FName like '%防尘帽%' and v2.FName like '%&' 
	and year(v1.FDate)=@Year
	and v1.FDate<'2012-08-01'
	GROUP BY v3.FName --with rollup
UNION ALL
--端子套不带#销售额
   SELECT --v3.FName,
	'端子套不带#销售额',sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	where v3.FName like '%端子套%' and v2.FName like '%[^#]' 
	and year(v1.FDate)=@Year
	and v1.FDate<'2012-08-01'
	GROUP BY v3.FName --with rollup
UNION ALL
--防尘帽不带&销售额
    SELECT --v3.FName,
	'防尘帽不带&销售额',sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	where v3.FName like '%防尘帽%' 
	and v2.FName like '%[^&]' 
	and year(v1.FDate)=@Year
	and v1.FDate<'2012-08-01'
	GROUP BY v3.FName --with rollup