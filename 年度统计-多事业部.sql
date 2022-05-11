DECLARE @Department NVARCHAR(50)

SET @Department='新能源事业部'



--企业销售额多年对比
select  v8.FName,
		v7.FName,
		v2.FProvince,
		v2.FName AS FName,
		v3.FName,
		v5.FName,
		v4.FName as FTradeName,
		t1.*
from
(
SELECT --v3.FName,
		--v5.FName,
		--v4.FName as FTradeName,
		--v2.FName AS FName,  
		v1.FSupplyID,  
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
--		[2009]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then u1.FConsignAmount END),0),
--		[2010]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then u1.FConsignAmount END),0),
		--[2014销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2014' then u1.FConsignAmount END),0),
		[2021销售额]=ISNULL(SUM(CASE when Year(v1.FDate)='2021' then u1.FConsignAmount END),0),
		[2020销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then u1.FConsignAmount END),0),
		[2019销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then u1.FConsignAmount END),0),
		[2018销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2018' then u1.FConsignAmount END),0),
		[2017销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2017' then u1.FConsignAmount END),0),
		[2016销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2016' then u1.FConsignAmount END),0),
		[2021出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2021' then u1.FAuxQty END),0),
		[2020出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then u1.FAuxQty END),0),
		[2019出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then u1.FAuxQty END),0),
		[2018出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2018' then u1.FAuxQty END),0),
		[2017出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2017' then u1.FAuxQty END),0),
		[2016出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2016' then u1.FAuxQty END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	where --year(v1.FDate)IN ('2019') 
	--month(v1.FDate)>='5'
	--AND
	--MONTH(v1.FDate)<='11'
	
	--and
	 v1.FTranType=21 
	group by v1.FSupplyID) t1

LEFT JOIN t_Organization v2 ON t1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
LEFT JOIN t_SubMessage v7 ON v2.FRegionID=v7.FInterID
LEFT JOIN t_Emp v8 ON v2.Femployee=v8.FItemID
where v3.FName=@Department
----where v4.FName='微波炉'
--and v2.FName like '%顺科新能源%'
order by [2021销售额] desc


--行业年度

DECLARE @Period char(4)
SET @Period='2015' --统计的年月


--统计处理
DECLARE 
	--@Last_Period char(6),
	@Period_1 char(4),
	@Period_2 char(4),
	@Period_3 char(6),
	@Period_4 char(6),
	@Period_5 char(6),
	@Period_6 char(6),
	@Period_7 char(6),

	@FMonth int,
	@FIndex int
SELECT 
	--@Last_Period=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112),
	--@Period_1=@Period,
	@Period_2=CONVERT(char(4),DATEADD(Year,1,@Period),112),
	@Period_3=CONVERT(char(4),DATEADD(Year,2,@Period),112),
	@Period_4=CONVERT(char(4),DATEADD(Year,3,@Period),112),
	@Period_5=CONVERT(char(4),DATEADD(Year,4,@Period),112),
	@Period_6=CONVERT(char(4),DATEADD(Year,5,@Period),112),
	@Period_7=CONVERT(char(4),DATEADD(Year,6,@Period),112)
SELECT FDepartment AS 事业部,FBigTrade AS 行业,
	--P_Money AS '年销售额',
	--P_AuxQty AS '年出货量',
	--P_Money_1 AS '2009销售额',
    P_Money_7 AS '2021销售额',
    P_Money_6 AS '2020销售额',
    P_Money_5 AS '2019销售额',
    P_Money_4 AS '2018销售额',
    P_Money_3 AS '2017销售额',
	P_Money_2 AS '2016销售额',
	--P_AuxQty_1 AS '2009出货量',
    P_AuxQty_7 AS '2021出货量',
    P_AuxQty_6 AS '2020出货量',
    P_AuxQty_5 AS '2019出货量',
    P_AuxQty_4 AS '2018出货量',
    P_AuxQty_3 AS '2017出货量',
	P_AuxQty_2 AS '2016出货量'
FROM(
    SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
        FBigTrade=CASE WHEN GROUPING(v5.FName)=1 THEN '<事业部合计>' ELSE (v5.FName) END,    
		--P_Money=ISNULL(SUM(u1.FConsignAmount),0),
        --P_AuxQty=ISNULL(SUM(u1.FAuxQty),0),
        P_Money_7=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_7 THEN v1.FConsignAmount END),0),
        P_Money_6=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_6 THEN v1.FConsignAmount END),0),
        P_Money_5=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_5 THEN v1.FConsignAmount END),0),
        P_Money_4=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_4 THEN v1.FConsignAmount END),0),
        P_Money_3=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_3 THEN v1.FConsignAmount END),0),
		P_Money_2=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_2 THEN v1.FConsignAmount END),0),
		--P_Money_7=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_1 THEN v1.FConsignAmount END),0),
        P_AuxQty_7=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_7 THEN v1.FAuxQty END),0),
        P_AuxQty_6=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_6 THEN v1.FAuxQty END),0),
        P_AuxQty_5=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_5 THEN v1.FAuxQty END),0),
        P_AuxQty_4=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_4 THEN v1.FAuxQty END),0),
        P_AuxQty_3=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_3 THEN v1.FAuxQty END),0),
        P_AuxQty_2=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_2 THEN v1.FAuxQty END),0)
        --P_AuxQty_7=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_1 THEN v1.FAuxQty END),0)
   --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM (
	select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	from [AIS20130811090352].[dbo].ICStockBill t1 
	INNER JOIN [AIS20130811090352].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	where year(t1.FDate)<='2012'
	union all
	select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	from [AIS20140921170539].[dbo].ICStockBill t1 
	INNER JOIN [AIS20140921170539].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	where year(t1.FDate)>='2013') v1
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	--LEFT JOIN t_Item v4 ON v1.FItemID=v4.FItemID
	left join t_Item v5 ON v2.F_117=v5.FItemID
    WHERE v1.FTranType=21 And v1.FCheckerID>0 
	--AND v1.FDate<='2021-12-21'
	--	year(v1.FDate) >=@Period
	--	and month(v1.FDate)<='8'
	AND v3.FName=@Department
    GROUP BY v3.FName,v5.FName  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FDepartment,P_Money_7 DESC