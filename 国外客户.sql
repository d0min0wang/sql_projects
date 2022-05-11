select t3.FName,t2.FName,* from t_Organization t1
left join t_Item t2 on t1.FParentID=t2.FItemID
left join t_Item t3 on t2.FParentID=t3.FItemID
where t3.FName IN ('香港','台湾省','欧洲','亚洲','美洲','澳洲','大洋洲')


DECLARE @Period char(4)
DECLARE @Department char(12)
select @Period='2013'
select @Department='端子套事业部'
SELECT max(year(v1.FDate)) AS FPeriod,
		v7.FName as FCountry,
		v2.FName AS FOrg,
		v3.FName AS FDepartment,
		v4.FName AS FTrade,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
		[销售额合计]=ISNULL(SUM(u1.FConsignAmount),0),
		[1月销售额]=ISNULL(SUM(CASE WHEN month(v1.FDate) = '1' then u1.FConsignAmount END),0),
		[2月销售额]=ISNULL(SUM(CASE WHEN month(v1.FDate) = '2' then u1.FConsignAmount END),0),
		[3月销售额]=ISNULL(SUM(CASE WHEN month(v1.FDate) = '3' then u1.FConsignAmount END),0),
		[4月销售额]=ISNULL(SUM(CASE WHEN month(v1.FDate) = '4' then u1.FConsignAmount END),0),
		[5月销售额]=ISNULL(SUM(CASE WHEN month(v1.FDate) = '5' then u1.FConsignAmount END),0),
		[6月销售额]=ISNULL(SUM(CASE WHEN month(v1.FDate) = '6' then u1.FConsignAmount END),0),
		[7月销售额]=ISNULL(SUM(CASE WHEN month(v1.FDate) = '7' then u1.FConsignAmount END),0),
		[8月销售额]=ISNULL(SUM(CASE WHEN month(v1.FDate) = '8' then u1.FConsignAmount END),0),
		[9月销售额]=ISNULL(SUM(CASE WHEN month(v1.FDate) = '9' then u1.FConsignAmount END),0),
		[10月销售额]=ISNULL(SUM(CASE WHEN month(v1.FDate) = '10' then u1.FConsignAmount END),0),
		[11月销售额]=ISNULL(SUM(CASE WHEN month(v1.FDate) = '11' then u1.FConsignAmount END),0),
		[12月销售额]=ISNULL(SUM(CASE WHEN month(v1.FDate) = '12' then u1.FConsignAmount END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
	LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
	LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
	left join t_Item v7 on v2.FParentID=v7.FItemID
	left join t_Item v8 on v7.FParentID=v8.FItemID
where year(v1.FDate)=@Period
--and month(v1.FDate)<='6'
and v1.FTranType=21 --and v3.FName=@Department 
--and v4.FName IN ('家用空调器','微波炉','热水器','冰箱\冷柜','电饭煲/压力锅','汽车及配件制造
--')
and v8.FName IN ('香港','台湾省','欧洲','亚洲','美洲','澳洲','大洋洲')
group by v3.FName,v2.FName,v7.FName,v4.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
--with rollup
--order by [2013] desc--v5.FName,v4.FName,[2011]
--order by v4.FName,[2013] desc