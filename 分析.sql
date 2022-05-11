SELECT v3.FName,
		v5.FName,
		v4.FName,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
--		[2013]=ISNULL(SUM(CASE year(v1.FDate) when '2013' then u1.FConsignAmount END),0),
		[2012]=ISNULL(SUM(CASE year(v1.FDate) when '2012' then u1.FConsignAmount END),0),
		[2011]=ISNULL(SUM(CASE year(v1.FDate) when '2011' then u1.FConsignAmount END),0),
		[2010]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then u1.FConsignAmount END),0),
		[2009]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then u1.FConsignAmount END),0)
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
where year(v1.FDate)IN ('2009','2010','2011','2012') 
--and month(v1.FDate)<='6'
and v1.FTranType=21 and v3.FName='手把套事业部' 
--and v4.FName IN ('家用空调器','微波炉','冰箱\冷柜','热水器','电饭煲/压力锅')
group by v3.FName,v5.FName,v4.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
--with rollup
order by [2012] desc--v5.FName,v4.FName,[2011]
--order by v4.FName,[2013] desc

--月份
SELECT v3.FName,
		v5.FName,
		v4.FName,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
		[1]=ISNULL(SUM(CASE month(v1.FDate) when '1' then u1.FConsignAmount END),0),
		[2]=ISNULL(SUM(CASE month(v1.FDate) when '2' then u1.FConsignAmount END),0),
		[3]=ISNULL(SUM(CASE month(v1.FDate) when '3' then u1.FConsignAmount END),0),
		[4]=ISNULL(SUM(CASE month(v1.FDate) when '4' then u1.FConsignAmount END),0),
		[5]=ISNULL(SUM(CASE month(v1.FDate) when '5' then u1.FConsignAmount END),0),
		[6]=ISNULL(SUM(CASE month(v1.FDate) when '6' then u1.FConsignAmount END),0),
		[7]=ISNULL(SUM(CASE month(v1.FDate) when '7' then u1.FConsignAmount END),0),
		[8]=ISNULL(SUM(CASE month(v1.FDate) when '8' then u1.FConsignAmount END),0),
		[9]=ISNULL(SUM(CASE month(v1.FDate) when '9' then u1.FConsignAmount END),0),
		[10]=ISNULL(SUM(CASE month(v1.FDate) when '10' then u1.FConsignAmount END),0),
		[11]=ISNULL(SUM(CASE month(v1.FDate) when '11' then u1.FConsignAmount END),0),
		[12]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FConsignAmount END),0)
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
where year(v1.FDate)='2012' and v1.FTranType=21 and v3.FName='端子套事业部' and v5.FName='家用电力器具'
group by v3.FName,v5.FName,v4.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
--with rollup
order by v5.FName,v4.FName

select convert(varchar,year(v1.FDate)) +'-'+ convert(varchar,datepart(qq,v1.FDate))
--季度
SELECT v3.FName,
		v5.FName,
		v4.FName,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
		[2009-1]=ISNULL(SUM(CASE convert(varchar,year(v1.FDate)) +'-'+ convert(varchar,datepart(qq,v1.FDate)) when '2009-1' then u1.FConsignAmount END),0),
		[2009-2]=ISNULL(SUM(CASE convert(varchar,year(v1.FDate)) +'-'+ convert(varchar,datepart(qq,v1.FDate)) when '2009-2' then u1.FConsignAmount END),0),
		[2009-3]=ISNULL(SUM(CASE convert(varchar,year(v1.FDate)) +'-'+ convert(varchar,datepart(qq,v1.FDate)) when '2009-3' then u1.FConsignAmount END),0),
		[2009-4]=ISNULL(SUM(CASE convert(varchar,year(v1.FDate)) +'-'+ convert(varchar,datepart(qq,v1.FDate)) when '2009-4' then u1.FConsignAmount END),0),
		[2010-1]=ISNULL(SUM(CASE convert(varchar,year(v1.FDate)) +'-'+ convert(varchar,datepart(qq,v1.FDate)) when '2010-1' then u1.FConsignAmount END),0),
		[2010-2]=ISNULL(SUM(CASE convert(varchar,year(v1.FDate)) +'-'+ convert(varchar,datepart(qq,v1.FDate)) when '2010-2' then u1.FConsignAmount END),0),
		[2010-3]=ISNULL(SUM(CASE convert(varchar,year(v1.FDate)) +'-'+ convert(varchar,datepart(qq,v1.FDate)) when '2010-3' then u1.FConsignAmount END),0),
		[2010-4]=ISNULL(SUM(CASE convert(varchar,year(v1.FDate)) +'-'+ convert(varchar,datepart(qq,v1.FDate)) when '2010-4' then u1.FConsignAmount END),0),
		[2011-1]=ISNULL(SUM(CASE convert(varchar,year(v1.FDate)) +'-'+ convert(varchar,datepart(qq,v1.FDate)) when '2011-1' then u1.FConsignAmount END),0),
		[2011-2]=ISNULL(SUM(CASE convert(varchar,year(v1.FDate)) +'-'+ convert(varchar,datepart(qq,v1.FDate)) when '2011-2' then u1.FConsignAmount END),0),
		[2011-3]=ISNULL(SUM(CASE convert(varchar,year(v1.FDate)) +'-'+ convert(varchar,datepart(qq,v1.FDate)) when '2011-3' then u1.FConsignAmount END),0),
		[2011-4]=ISNULL(SUM(CASE convert(varchar,year(v1.FDate)) +'-'+ convert(varchar,datepart(qq,v1.FDate)) when '2011-4' then u1.FConsignAmount END),0),
		[2012-1]=ISNULL(SUM(CASE convert(varchar,year(v1.FDate)) +'-'+ convert(varchar,datepart(qq,v1.FDate)) when '2012-1' then u1.FConsignAmount END),0),
		[2012-2]=ISNULL(SUM(CASE convert(varchar,year(v1.FDate)) +'-'+ convert(varchar,datepart(qq,v1.FDate)) when '2012-2' then u1.FConsignAmount END),0),
		[2012-3]=ISNULL(SUM(CASE convert(varchar,year(v1.FDate)) +'-'+ convert(varchar,datepart(qq,v1.FDate)) when '2012-3' then u1.FConsignAmount END),0),
		[2012-4]=ISNULL(SUM(CASE convert(varchar,year(v1.FDate)) +'-'+ convert(varchar,datepart(qq,v1.FDate)) when '2012-4' then u1.FConsignAmount END),0)
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
where year(v1.FDate)>='2009' and v1.FTranType=21 and v3.FName='端子套事业部' --and v5.FName='家用电力器具'
group by v3.FName,v5.FName,v4.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
--with rollup
order by v5.FName,v4.FName

--企业

SELECT --v3.FName,
		--v5.FName,
		v4.FName as FTradeName,
		v2.FName AS FName,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
--		[2009]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then u1.FConsignAmount END),0),
--		[2010]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then u1.FConsignAmount END),0),
--		[2013]=ISNULL(SUM(CASE year(v1.FDate) when '2013' then u1.FConsignAmount END),0),
		[2012]=ISNULL(SUM(CASE year(v1.FDate) when '2012' then u1.FConsignAmount END),0),
		[2011]=ISNULL(SUM(CASE year(v1.FDate) when '2011' then u1.FConsignAmount END),0),
		[2010]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then u1.FConsignAmount END),0),
		[2009]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then u1.FConsignAmount END),0)
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
where year(v1.FDate)IN ('2009','2010','2011','2012') 
--and month(v1.FDate)<='6' 
and v1.FTranType=21 
and v3.FName='防尘帽事业部' --and v5.FName='体育用品' 
and v4.FName IN ('通信设备','光纤连接器','射频连接器','天线','光纤\光缆','日用五金')

group by --v3.FName,v5.FName,
v4.FName,v2.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
with rollup
order by v4.FName,
[2012] desc
