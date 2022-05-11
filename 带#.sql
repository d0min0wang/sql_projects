DECLARE @Year char(4)
SET @Year='2012' 

--�����״�#���۶� 
   SELECT --v3.FName,
	'�����״�#���۶� ',sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	where v3.FName like '%������%' and v2.FName like '%#' 
	and year(v1.FDate)=@Year
	and v1.FDate<'2012-08-01'
	GROUP BY v3.FName --with rollup
UNION ALL
--����ñ��&���۶�
    SELECT --v3.FName,
	'����ñ��&���۶�',sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	where v3.FName like '%����ñ%' and v2.FName like '%&' 
	and year(v1.FDate)=@Year
	and v1.FDate<'2012-08-01'
	GROUP BY v3.FName --with rollup
UNION ALL
--�����ײ���#���۶�
   SELECT --v3.FName,
	'�����ײ���#���۶�',sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	where v3.FName like '%������%' and v2.FName like '%[^#]' 
	and year(v1.FDate)=@Year
	and v1.FDate<'2012-08-01'
	GROUP BY v3.FName --with rollup
UNION ALL
--����ñ����&���۶�
    SELECT --v3.FName,
	'����ñ����&���۶�',sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	where v3.FName like '%����ñ%' 
	and v2.FName like '%[^&]' 
	and year(v1.FDate)=@Year
	and v1.FDate<'2012-08-01'
	GROUP BY v3.FName --with rollup