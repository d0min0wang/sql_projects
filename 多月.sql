SELECT  * from sys.databases 
where name='AIS20140921170539'


select is_cdc_enabled from sys.databases where name='AIS20140921170539';



use AIS20140921170539
DECLARE @Period char(6)
SET @Period='202101' --统计的年月


--统计处理
DECLARE 
	--@Last_Period char(6),
	@Period_1 char(6),
	@Period_2 char(6),
	@Period_3 char(6),
	@Period_4 char(6),
	@Period_5 char(6),
	@Period_6 char(6),
	@Period_7 char(6),
	@Period_8 char(6),
	@Period_9 char(6),
	@Period_10 char(6),
	@Period_11 char(6),
	@Period_12 char(6),
	@FMonth int,
	@FIndex int
SELECT 
	--@Last_Period=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112),
	@Period_1=@Period,
	@Period_2=CONVERT(char(6),DATEADD(Month,1,@Period+'01'),112),
	@Period_3=CONVERT(char(6),DATEADD(Month,2,@Period+'01'),112),
	@Period_4=CONVERT(char(6),DATEADD(Month,3,@Period+'01'),112),
	@Period_5=CONVERT(char(6),DATEADD(Month,4,@Period+'01'),112),
	@Period_6=CONVERT(char(6),DATEADD(Month,5,@Period+'01'),112),
	@Period_7=CONVERT(char(6),DATEADD(Month,6,@Period+'01'),112),
	@Period_8=CONVERT(char(6),DATEADD(Month,7,@Period+'01'),112),
	@Period_9=CONVERT(char(6),DATEADD(Month,8,@Period+'01'),112),
	@Period_10=CONVERT(char(6),DATEADD(Month,9,@Period+'01'),112),
	@Period_11=CONVERT(char(6),DATEADD(Month,10,@Period+'01'),112),
	@Period_12=CONVERT(char(6),DATEADD(Month,11,@Period+'01'),112)

SELECT FDepartment AS 事业部,FBigTrade AS 行业,
	P_Money AS '年销售额',
	P_AuxQty AS '年出货量',
    P_Money_1 AS '1月销售额',
    P_Money_2 AS '2月销售额',
    P_Money_3 AS '3月销售额',
    P_Money_4 AS '4月销售额',
    P_Money_5 AS '5月销售额',
    P_Money_6 AS '6月销售额',
    P_Money_7 AS '7月销售额',
    P_Money_8 AS '8月销售额',
    P_Money_9 AS '9月销售额',
    P_Money_10 AS '10月销售额',
    P_Money_11 AS '11月销售额',
    P_Money_12 AS '12月销售额',
    P_AuxQty_1 AS '1月出货量',
    P_AuxQty_2 AS '2月出货量',
    P_AuxQty_3 AS '3月出货量',
    P_AuxQty_4 AS '4月出货量',
    P_AuxQty_5 AS '5月出货量',
    P_AuxQty_6 AS '6月出货量',
    P_AuxQty_7 AS '7月出货量',
    P_AuxQty_8 AS '8月出货量',
    P_AuxQty_9 AS '9月出货量',
    P_AuxQty_10 AS '10月出货量',
    P_AuxQty_11 AS '11月出货量',
    P_AuxQty_12 AS '12月出货量'
FROM(
    SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
        FBigTrade=CASE WHEN GROUPING(v5.FName)=1 THEN '<事业部合计>' ELSE (v5.FName) END,    
		P_Money=ISNULL(SUM(u1.FConsignAmount),0),
        P_AuxQty=ISNULL(SUM(u1.FAuxQty),0),
        P_Money_1=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_1 THEN u1.FConsignAmount END),0),
        P_Money_2=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_2 THEN u1.FConsignAmount END),0),
        P_Money_3=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_3 THEN u1.FConsignAmount END),0),
        P_Money_4=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_4 THEN u1.FConsignAmount END),0),
        P_Money_5=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_5 THEN u1.FConsignAmount END),0),
        P_Money_6=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_6 THEN u1.FConsignAmount END),0),
        P_Money_7=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_7 THEN u1.FConsignAmount END),0),
        P_Money_8=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_8 THEN u1.FConsignAmount END),0),
        P_Money_9=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_9 THEN u1.FConsignAmount END),0),
        P_Money_10=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_10 THEN u1.FConsignAmount END),0),
        P_Money_11=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_11 THEN u1.FConsignAmount END),0),
        P_Money_12=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_12 THEN u1.FConsignAmount END),0),
        P_AuxQty_1=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_1 THEN u1.FAuxQty END),0),
        P_AuxQty_2=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_2 THEN u1.FAuxQty END),0),
        P_AuxQty_3=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_3 THEN u1.FAuxQty END),0),
        P_AuxQty_4=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_4 THEN u1.FAuxQty END),0),
        P_AuxQty_5=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_5 THEN u1.FAuxQty END),0),
        P_AuxQty_6=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_6 THEN u1.FAuxQty END),0),
        P_AuxQty_7=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_7 THEN u1.FAuxQty END),0),
        P_AuxQty_8=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_8 THEN u1.FAuxQty END),0),
        P_AuxQty_9=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_9 THEN u1.FAuxQty END),0),
        P_AuxQty_10=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_10 THEN u1.FAuxQty END),0),
        P_AuxQty_11=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_11 THEN u1.FAuxQty END),0),
        P_AuxQty_12=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_12 THEN u1.FAuxQty END),0)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID
	left join t_Item v5 ON v2.F_117=v5.FItemID
    WHERE v1.FTranType=21 And v1.FCheckerID>0 AND
		year(v1.FDate) =left(@Period,4)
		--and month(v1.FDate)<month(getdate()) 
		--and v3.FName='高端器材事业部'

    GROUP BY v3.FName,v5.FName  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FDepartment,P_Money DESC
--
--select   RIGHT(CONVERT(char(6),getdate(),112),2)    
--select month(getdate())


--select * from t_Organization where FNumber='01.CZ.0001'
----F_123 新增日期 

--企业销售额
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
		[2021销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then u1.FConsignAmount END),0),
		[1月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '1' then u1.FConsignAmount END),0),
		[2月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '2' then u1.FConsignAmount END),0),
		[3月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '3' then u1.FConsignAmount END),0),
		[4月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '4' then u1.FConsignAmount END),0),
		[5月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '5' then u1.FConsignAmount END),0),
		[6月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '6' then u1.FConsignAmount END),0),
		[7月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '7' then u1.FConsignAmount END),0),
		[8月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '8' then u1.FConsignAmount END),0),
		[9月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '9' then u1.FConsignAmount END),0),
		[10月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '10' then u1.FConsignAmount END),0),
		[11月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '11' then u1.FConsignAmount END),0),
		[12月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FConsignAmount END),0),
		[2021出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then u1.FAuxQty END),0),
		[1月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '1' then u1.FAuxQty END),0),
		[2月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '2' then u1.FAuxQty END),0),
		[3月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '3' then u1.FAuxQty END),0),
		[4月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '4' then u1.FAuxQty END),0),
		[5月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '5' then u1.FAuxQty END),0),
		[6月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '6' then u1.FAuxQty END),0),
		[7月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '7' then u1.FAuxQty END),0),
		[8月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '8' then u1.FAuxQty END),0),
		[9月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '9' then u1.FAuxQty END),0),
		[10月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '10' then u1.FAuxQty END),0),
		[11月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '11' then u1.FAuxQty END),0),
		[12月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FAuxQty END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	where year(v1.FDate)IN ('2021') 
	--and month(v1.FDate)<='2'
	
	and v1.FTranType=21 
	group by v1.FSupplyID) t1

LEFT JOIN t_Organization v2 ON t1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
LEFT JOIN t_SubMessage v7 ON v2.FRegionID=v7.FInterID
LEFT JOIN t_Emp v8 ON v2.Femployee=v8.FItemID
where v3.FName='新能源事业部'
----where v4.FName='微波炉'
--and v2.FName like '%顺科新能源%'
order by [2021销售额] desc



where year(v1.FDate)IN ('2014') 
and month(v1.FDate)<='12' 
and v1.FTranType=21 
--and v2.F_123>='2013-09-01' --新开发
--and v3.FName='防尘帽事业部' --and v5.FName='体育用品' 
--and v4.FName IN ('通信设备','光纤连接器','射频连接器','天线','光纤\光缆','日用五金')

group by --v3.FName,v5.FName,
v4.FName,v2.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
with rollup
order by v4.FName,
[12] desc

FRegionID t_SubMessage
select * from t_Organization
select * from t_SubMessage where FName like '%华南%'

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
	AND v3.FName='健康事业部'
    GROUP BY v3.FName,v5.FName  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FDepartment,P_Money_7 DESC
--     
--select   RIGHT(CONVERT(char(6),getdate(),112),2)    
--select month(getdate())


--企业四年

SELECT --v3.FName,
		--v5.FName,
		v4.FName as FTradeName,
		v2.FName AS FName,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
		--[2008销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FConsignAmount END),0),
		--[2009销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FConsignAmount END),0),
		--[2010销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then v1.FConsignAmount END),0),
		[2023销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2023' AND Month(v1.FDate)<='6' then v1.FConsignAmount END),0),
		[2022销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2022' AND Month(v1.FDate)<='6' then v1.FConsignAmount END),0),
		[2021销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2021' AND Month(v1.FDate)<='6'  then v1.FConsignAmount END),0),
		[2020销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2020' AND Month(v1.FDate)<='6'  then v1.FConsignAmount END),0),
		[2019销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2019' AND Month(v1.FDate)<='6'  then v1.FConsignAmount END),0),
		--[2008出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FAuxQty END),0),
		--[2009出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FAuxQty END),0),
		--[2010出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then v1.FAuxQty END),0),
		[2023出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2023' AND Month(v1.FDate)<='6' then v1.FAuxQty END),0),
		[2022出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2022' AND Month(v1.FDate)<='6' then v1.FAuxQty END),0),
		[2021出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2021' AND Month(v1.FDate)<='6'  then v1.FAuxQty END),0),
		[2020出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2020' AND Month(v1.FDate)<='6'  then v1.FAuxQty END),0),
		[2019出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2019' AND Month(v1.FDate)<='6'  then v1.FAuxQty END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM 
	(
	--select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	--from [AIS20130811090352].[dbo].ICStockBill t1 
	--INNER JOIN [AIS20130811090352].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	--where year(t1.FDate)<='2012' and t1.FTranType =21
	--union all
	select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	from [AIS20140921170539].[dbo].ICStockBill t1 
	INNER JOIN [AIS20140921170539].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	where year(t1.FDate)>='2013') v1
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
	LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
	LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
where --year(v1.FDate) <= '2013')
month(v1.FDate)<='12' 
and 
v1.FTranType=21 
And v1.FCheckerID>0 
and v3.FName='新能源事业部' --and v5.FName='体育用品' 
--and v4.FName IN ('通信设备','光纤连接器','射频连接器','天线','光纤\光缆','日用五金')

group by --v3.FName,v5.FName,
v4.FName,v2.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
with rollup
order by v4.FName,
[2023销售额] desc


--企业四年按业务员分

SELECT v3.FName,
		--v5.FName,
		v4.FName as FTradeName,
		v7.FName AS FEmpName,
		v2.FName AS FName,
		max(v2.FProvince) AS FProvince,
		max(v2.FCity) AS FCity,
		max(v8.FName) AS FSettle,
		max(v2.F_101) AS F_101,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
		--[2008销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FConsignAmount END),0),
		--[2009销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FConsignAmount END),0),
		--[2010销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then v1.FConsignAmount END),0),
		--[2011销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2011' then v1.FConsignAmount END),0),
		--[2012销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2012' then v1.FConsignAmount END),0),
		[2014销售额]=ISNULL(SUM(CASE when year(v1.FDate)= '2014' then v1.FConsignAmount END),0),
		[2015销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' then v1.FConsignAmount END),0),
		[2016销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' then v1.FConsignAmount END),0),
		[1月销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '1' then v1.FConsignAmount END),0),
		[2月销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '2' then v1.FConsignAmount END),0),
		[3月销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '3' then v1.FConsignAmount END),0),
		[4月销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '4' then v1.FConsignAmount END),0),
		[5月销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '5' then v1.FConsignAmount END),0),
		[6月销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '6' then v1.FConsignAmount END),0),
		--[7月销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '7' then v1.FConsignAmount END),0),
		--[8月销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '8' then v1.FConsignAmount END),0),
		--[9月销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '9' then v1.FConsignAmount END),0),
		--[10月销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '10' then v1.FConsignAmount END),0),
		--[11月销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '11' then v1.FConsignAmount END),0),
		--[12月销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '12' then v1.FConsignAmount END),0),
		--[2008出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FAuxQty END),0),
		--[2009出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FAuxQty END),0),
		--[2010出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then v1.FAuxQty END),0),
		--[2011出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2011' then v1.FAuxQty END),0),
		--[2012出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2012' then v1.FAuxQty END),0),
		[2014出货量]=ISNULL(SUM(CASE when year(v1.FDate)= '2014'  then v1.FAuxQty END),0),
		[2015出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2015'  then v1.FAuxQty END),0),
		[2016出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2016'  then v1.FAuxQty END),0),
		[1月出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '1' then v1.FAuxQty END),0),
		[2月出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '2' then v1.FAuxQty END),0),
		[3月出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '3' then v1.FAuxQty END),0),
		[4月出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '4' then v1.FAuxQty END),0),
		[5月出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '5' then v1.FAuxQty END),0),
		[6月出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '6' then v1.FAuxQty END),0)
		--[7月出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '7' then v1.FAuxQty END),0),
		--[8月出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '8' then v1.FAuxQty END),0),
		--[9月出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '9' then v1.FAuxQty END),0),
		--[10月出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '10' then v1.FAuxQty END),0),
		--[11月出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '11' then v1.FAuxQty END),0),
		--[12月出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '12' then v1.FAuxQty END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM 
	(
	--select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	--from [AIS20130811090352].[dbo].ICStockBill t1 
	--INNER JOIN [AIS20130811090352].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	--where year(t1.FDate)<='2012'
	--union all
	select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	from ICStockBill t1 
	INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	where year(t1.FDate)>='2013' and month(t1.FDate)<='6')  v1
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
	LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
	LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
	LEFT JOIN t_Emp v7 ON v2.Femployee=v7.FItemID
	left join t_settle v8 on v2.fsetid=v8.fitemid
where --year(v1.FDate) <= '2013')
--and month(v1.FDate)<='11' 
--and 
v1.FTranType=21 
And v1.FCheckerID>0 
and v3.FName='端子套事业部' --and v5.FName='体育用品' 
----and v4.FName IN ('通信设备','光纤连接器','射频连接器','天线','光纤\光缆','日用五金')
--and v7.FName='朱明霞'
--and [2014销售额]<>0
group by v3.FName,--v5.FName,
v4.FName,v7.FName,v2.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
with rollup
order by v4.FName,v7.FName,
[2016销售额] desc

--select t2.FName,t1.* from t_Organization t1
--left join t_Emp t2 on t1.Femployee=t2.FItemID

--行业半年

DECLARE @Period char(4)
SET @Period='2009' --统计的年月


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
	--@Period_2=CONVERT(char(4),DATEADD(Year,1,@Period),112),
	--@Period_3=CONVERT(char(4),DATEADD(Year,2,@Period),112),
	--@Period_4=CONVERT(char(4),DATEADD(Year,3,@Period),112),
	@Period_5=CONVERT(char(4),DATEADD(Year,5,@Period),112),
	@Period_6=CONVERT(char(4),DATEADD(Year,6,@Period),112),
	@Period_7=CONVERT(char(4),DATEADD(Year,7,@Period),112)
SELECT FDepartment AS 事业部,FBigTrade AS 行业,
	--P_Money AS '年销售额',
	--P_AuxQty AS '年出货量',
	--P_Money_1 AS '2008销售额',
 --   P_Money_2 AS '2009销售额',
 --   P_Money_3 AS '2010销售额',
 --   P_Money_4 AS '2011销售额',
    P_Money_5 AS '2014销售额',
    P_Money_6 AS '2015销售额',
	P_Money_7 AS '2016销售额',
	--P_AuxQty_1 AS '2008出货量',
 --   P_AuxQty_2 AS '2009出货量',
 --   P_AuxQty_3 AS '2010出货量',
 --   P_AuxQty_4 AS '2011出货量',
    P_AuxQty_5 AS '2014出货量',
    P_AuxQty_6 AS '2015出货量',
	P_AuxQty_7 AS '2016出货量'
FROM(
    SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
        FBigTrade=CASE WHEN GROUPING(v5.FName)=1 THEN '<事业部合计>' ELSE (v5.FName) END,    
		--P_Money=ISNULL(SUM(u1.FConsignAmount),0),
        --P_AuxQty=ISNULL(SUM(u1.FAuxQty),0),
        P_Money_1=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_1 AND Month(v1.FDate)<='6' THEN v1.FConsignAmount END),0),
        P_Money_2=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_2 AND Month(v1.FDate)<='6' THEN v1.FConsignAmount END),0),
        P_Money_3=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_3 AND Month(v1.FDate)<='6' THEN v1.FConsignAmount END),0),
        P_Money_4=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_4 AND Month(v1.FDate)<='6' THEN v1.FConsignAmount END),0),
        P_Money_5=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_5 AND Month(v1.FDate)<='6' THEN v1.FConsignAmount END),0),
		P_Money_6=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_6 AND Month(v1.FDate)<='6' THEN v1.FConsignAmount END),0),
		P_Money_7=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_7 AND Month(v1.FDate)<='6' THEN v1.FConsignAmount END),0),
        P_AuxQty_1=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_1 AND Month(v1.FDate)<='6' THEN v1.FAuxQty END),0),
        P_AuxQty_2=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_2 AND Month(v1.FDate)<='6' THEN v1.FAuxQty END),0),
        P_AuxQty_3=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_3 AND Month(v1.FDate)<='6' THEN v1.FAuxQty END),0),
        P_AuxQty_4=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_4 AND Month(v1.FDate)<='6' THEN v1.FAuxQty END),0),
        P_AuxQty_5=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_5 AND Month(v1.FDate)<='6' THEN v1.FAuxQty END),0),
        P_AuxQty_6=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_6 AND Month(v1.FDate)<='6' THEN v1.FAuxQty END),0),
        P_AuxQty_7=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_7 AND Month(v1.FDate)<='6' THEN v1.FAuxQty END),0)
   FROM 
   (
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
 --   FROM (select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	--from [AIS20131027152019].[dbo].ICStockBill t1 
	--INNER JOIN [AIS20131027152019].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	--where year(t1.FDate)<='2012'
	--union all
	select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	from ICStockBill t1 
	INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	where year(t1.FDate)>='2013') v1
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	--LEFT JOIN t_Item v4 ON v1.FItemID=v4.FItemID
	left join t_Item v5 ON v2.F_117=v5.FItemID
    WHERE v1.FTranType=21 And v1.FCheckerID>0 
	AND
		year(v1.FDate) >=@Period
		and month(v1.FDate)<=month(getdate()) 

    GROUP BY v3.FName,v5.FName  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FDepartment,P_Money_7 DESC
--     
--select   RIGHT(CONVERT(char(6),getdate(),112),2)    
--select month(getdate())

--企业出货量
select v7.FName,
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
		[2013]=ISNULL(SUM(CASE year(v1.FDate) when '2013' then u1.FAuxQty END),0),
		[1]=ISNULL(SUM(CASE month(v1.FDate) when '1' then u1.FAuxQty END),0),
		[2]=ISNULL(SUM(CASE month(v1.FDate) when '2' then u1.FAuxQty END),0),
		[3]=ISNULL(SUM(CASE month(v1.FDate) when '3' then u1.FAuxQty END),0),
		[4]=ISNULL(SUM(CASE month(v1.FDate) when '4' then u1.FAuxQty END),0),
		[5]=ISNULL(SUM(CASE month(v1.FDate) when '5' then u1.FAuxQty END),0),
		[6]=ISNULL(SUM(CASE month(v1.FDate) when '6' then u1.FAuxQty END),0),
		[7]=ISNULL(SUM(CASE month(v1.FDate) when '7' then u1.FAuxQty END),0),
		[8]=ISNULL(SUM(CASE month(v1.FDate) when '8' then u1.FAuxQty END),0),
		[9]=ISNULL(SUM(CASE month(v1.FDate) when '9' then u1.FAuxQty END),0),
		[10]=ISNULL(SUM(CASE month(v1.FDate) when '10' then u1.FAuxQty END),0),
		[11]=ISNULL(SUM(CASE month(v1.FDate) when '11' then u1.FAuxQty END),0),
		[12]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FAuxQty END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	where year(v1.FDate)IN ('2013') 
	--and month(v1.FDate)<='6'
	
	and v1.FTranType=21 
	group by v1.FSupplyID) t1

LEFT JOIN t_Organization v2 ON t1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
LEFT JOIN t_SubMessage v7 ON v2.FRegionID=v7.FInterID

--where v3.FName='防尘帽事业部'
where v4.FName='微波炉'
order by [2013] desc


--select * from  t_Organization

--企业每月按业务员分

SELECT v3.FName,
		--v5.FName,
		v4.FName as FTradeName,
		v7.FName AS FEmpName,
		v2.FName AS FName,
		max(v2.FProvince) AS FProvince,
		max(v2.FCity) AS FCity,
		max(v8.FName) AS FSettle,
		max(v2.F_101) AS F_101,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
		--[2008销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FConsignAmount END),0),
		--[2009销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FConsignAmount END),0),
		--[2010销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then v1.FConsignAmount END),0),
		--[2011销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2011' then v1.FConsignAmount END),0),
		--[2012销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2012' then v1.FConsignAmount END),0),
		[2015销售额]=ISNULL(SUM(CASE when year(v1.FDate)= '2015' then v1.FConsignAmount END),0),
		[1月销售额]=ISNULL(SUM(CASE when month(v1.FDate) = '1' then v1.FConsignAmount END),0),
		[2月销售额]=ISNULL(SUM(CASE when month(v1.FDate) = '2' then v1.FConsignAmount END),0),
		[3月销售额]=ISNULL(SUM(CASE when month(v1.FDate) = '3' then v1.FConsignAmount END),0),
		[4月销售额]=ISNULL(SUM(CASE when month(v1.FDate) = '4' then v1.FConsignAmount END),0),
		[5月销售额]=ISNULL(SUM(CASE when month(v1.FDate) = '5' then v1.FConsignAmount END),0),
		[6月销售额]=ISNULL(SUM(CASE when month(v1.FDate) = '6' then v1.FConsignAmount END),0),
		[7月销售额]=ISNULL(SUM(CASE when month(v1.FDate) = '7' then v1.FConsignAmount END),0),
		[8月销售额]=ISNULL(SUM(CASE when month(v1.FDate) = '8' then v1.FConsignAmount END),0),
		[9月销售额]=ISNULL(SUM(CASE when month(v1.FDate) = '9' then v1.FConsignAmount END),0),
		[10月销售额]=ISNULL(SUM(CASE when month(v1.FDate) = '10' then v1.FConsignAmount END),0),
		[11月销售额]=ISNULL(SUM(CASE when month(v1.FDate) = '11' then v1.FConsignAmount END),0),
		[12月销售额]=ISNULL(SUM(CASE when month(v1.FDate) = '12' then v1.FConsignAmount END),0),
		--[2008出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FAuxQty END),0),
		--[2009出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FAuxQty END),0),
		--[2010出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then v1.FAuxQty END),0),
		--[2011出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2011' then v1.FAuxQty END),0),
		--[2012出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2012' then v1.FAuxQty END),0),
		[2015出货量]=ISNULL(SUM(CASE when year(v1.FDate)= '2015'  then v1.FAuxQty END),0),
		[1月出货量]=ISNULL(SUM(CASE when month(v1.FDate) = '1'  then v1.FAuxQty END),0),
		[2月出货量]=ISNULL(SUM(CASE when month(v1.FDate) = '2'  then v1.FAuxQty END),0),
		[3月出货量]=ISNULL(SUM(CASE when month(v1.FDate) = '3'  then v1.FAuxQty END),0),
		[4月出货量]=ISNULL(SUM(CASE when month(v1.FDate) = '4'  then v1.FAuxQty END),0),
		[5月出货量]=ISNULL(SUM(CASE when month(v1.FDate) = '5'  then v1.FAuxQty END),0),
		[6月出货量]=ISNULL(SUM(CASE when month(v1.FDate) = '6'  then v1.FAuxQty END),0),
		[7月出货量]=ISNULL(SUM(CASE when month(v1.FDate) = '7'  then v1.FAuxQty END),0),
		[8月出货量]=ISNULL(SUM(CASE when month(v1.FDate) = '8'  then v1.FAuxQty END),0),
		[9月出货量]=ISNULL(SUM(CASE when month(v1.FDate) = '9'  then v1.FAuxQty END),0),
		[10月出货量]=ISNULL(SUM(CASE when month(v1.FDate) = '10'  then v1.FAuxQty END),0),
		[11月出货量]=ISNULL(SUM(CASE when month(v1.FDate) = '11'  then v1.FAuxQty END),0),
		[12月出货量]=ISNULL(SUM(CASE when month(v1.FDate) = '12'  then v1.FAuxQty END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM 
	(
	--select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	--from [AIS20130811090352].[dbo].ICStockBill t1 
	--INNER JOIN [AIS20130811090352].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	--where year(t1.FDate)<='2012'
	--union all
	select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	from ICStockBill t1 
	INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	where year(t1.FDate)>='2015' and month(t1.FDate)<='12')  v1
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
	LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
	LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
	LEFT JOIN t_Emp v7 ON v2.Femployee=v7.FItemID
	left join t_settle v8 on v2.fsetid=v8.fitemid
where --year(v1.FDate) <= '2013')
--and month(v1.FDate)<='11' 
--and 
v1.FTranType=21 
And v1.FCheckerID>0 
and v3.FName='端子套事业部' --and v5.FName='体育用品' 
----and v4.FName IN ('通信设备','光纤连接器','射频连接器','天线','光纤\光缆','日用五金')
--and v7.FName='朱明霞'
--and [2014销售额]<>0
group by v3.FName,--v5.FName,
v7.FName,v4.FName,v2.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
with rollup
order by v7.FName,v4.FName,
[2015销售额] desc




--今年新交易客户



SELECT top 20 * FROM
(select tt3.FName AS 部门,
	tt5.FName AS 行业, 
	tt2.FName AS 客户名称,
	CASE tt2.FComboBox 
		WHEN '00' THEN '其他网络'
		WHEN '01' THEN '展会'
		WHEN '02' THEN '客户介绍'
		WHEN '03' THEN '杂志'
		WHEN '04' THEN '现场信息'
		WHEN '05' THEN '阿里巴巴'
		WHEN '06' THEN '公司网站'
		ELSE ''
	END
	AS 来源,
	tt2.FContact AS 联系人,
	tt2.FPhone AS 电话,
	tt2.FFax AS 传真,
	tt2.FAddress AS 地址,
	tt2.F_101 AS 客户分类,
	tt1.FMinDate AS 首次交易日期,
	tt1.FMaxDate AS 最后交易日期,
	tt1.FConsignAmount AS 金额,
	tt1.FAuxQtySum AS 出货量,
	tt1.FAuxQtyCount AS 出货次数,
	tt1.FAuxQtySum/tt1.FAuxQtyCount  AS 平均出货量,
	tt1.FAuxQtyMax AS 单次最大出货量,
	tt1.FAuxQtyMin AS 单次最小出货量
 from
(select t1.FSupplyID as FSupplyID,
	sum(t2.FConsignAmount) AS FConsignAmount,
	sum(t2.FAuxQty) AS FAuxQtySum,
	count(t2.FAuxQty) AS FAuxQtyCount,
	max(t2.FAuxQty) AS FAuxQtyMax,
	min(t2.FAuxQty) AS FAuxQtyMin,
	min(t1.FDate) AS FMinDate,
	max(t1.FDate) AS FMaxDate
from ICStockBill t1 
INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
where --year(t1.FDate)='2016'
t1.FTranType=21 
And t1.FCheckerID>0 
group by t1.FSupplyID )tt1
LEFT JOIN t_Organization tt2 ON tt1.FSupplyID=tt2.FItemID
LEFT JOIN t_Item tt3 ON tt2.Fdepartment=tt3.FItemID
LEFT JOIN t_Item tt4 ON tt2.F_122=tt4.FItemID
LEFT JOIN t_Item tt5 ON tt2.F_117=tt5.FItemID
where year(tt1.FMaxDate)='2016'
and tt2.F_101='C'
)table1
  ORDER BY NEWID()


order by tt3.FName,tt2.F_101,tt1.FConsignAmount DESC



--今年新增客户
select tt3.FName AS 部门,
	tt5.FName AS 行业, 
	tt2.FName AS 客户名称,
	CASE tt2.FComboBox 
		WHEN '00' THEN '其他网络'
		WHEN '01' THEN '展会'
		WHEN '02' THEN '客户介绍'
		WHEN '03' THEN '杂志'
		WHEN '04' THEN '现场信息'
		WHEN '05' THEN '阿里巴巴'
		WHEN '06' THEN '公司网站'
		ELSE ''
	END
	AS 来源,
	tt2.FContact AS 联系人,
	tt2.FPhone AS 电话,
	tt2.FFax AS 传真,
	tt2.FAddress AS 地址,
	tt2.F_101 AS 客户分类,
	tt2.F_123 AS 新增日期,
	tt1.FConsignAmount AS 金额,
	tt1.FAuxQtySum AS 出货量,
	tt1.FAuxQtyCount AS 出货次数,
	tt1.FAuxQtySum/tt1.FAuxQtyCount  AS 平均出货量,
	tt1.FAuxQtyMax AS 单次最大出货量,
	tt1.FAuxQtyMin AS 单次最小出货量
 from
(select t1.FSupplyID as FSupplyID,
	sum(t2.FConsignAmount) AS FConsignAmount,
	sum(t2.FAuxQty) AS FAuxQtySum,
	count(t2.FAuxQty) AS FAuxQtyCount,
	max(t2.FAuxQty) AS FAuxQtyMax,
	min(t2.FAuxQty) AS FAuxQtyMin,
	min(t1.FDate) AS FMinDate
from ICStockBill t1 
INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
where 
(convert(varchar(10),t1.FDate,120)>='2022-01-01' and convert(varchar(10),t1.FDate,120)<'2022-07-01')
and
t1.FTranType=21 
And t1.FCheckerID>0 
group by t1.FSupplyID )tt1
LEFT JOIN t_Organization tt2 ON tt1.FSupplyID=tt2.FItemID
LEFT JOIN t_Item tt3 ON tt2.Fdepartment=tt3.FItemID
LEFT JOIN t_Item tt4 ON tt2.F_122=tt4.FItemID
LEFT JOIN t_Item tt5 ON tt2.F_117=tt5.FItemID
where --year(tt1.FMinDate)='2015'
(convert(varchar(10),tt2.F_123,120)>='2022-01-01' and convert(varchar(10),tt2.F_123,120)<'2022-07-01')

order by tt3.FName,tt2.F_101,tt1.FConsignAmount DESC

--客户来源：FCombobox
--00	其他网络
--01	展会
--02	客户介绍
--03	杂志
--04	现场信息
--05	阿里巴巴
--06	公司网站

select * from t_Organization

FPhone FFax FContact FAddress


select * from t_Organization


--企业销售额
select  v8.FName,
		v7.FName,
		CASE WHEN v2.FProvince LIKE '广东%' then '广东' else '外省' end as FPro,
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
		[2017销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2017' then u1.FConsignAmount END),0),
		[2017年1月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='1' THEN u1.FConsignAmount END),0),
		[2017年2月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='2' THEN u1.FConsignAmount END),0),
		[2017年3月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='3' THEN u1.FConsignAmount END),0),
		[2017年4月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='4' THEN u1.FConsignAmount END),0),
		[2017年5月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='5' THEN u1.FConsignAmount END),0),
		[2017年6月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='6' THEN u1.FConsignAmount END),0),
		[2017年7月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='7' THEN u1.FConsignAmount END),0),
		[2017年8月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='8' THEN u1.FConsignAmount END),0),
		[2017年9月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='9' THEN u1.FConsignAmount END),0),
		[2017年10月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='10' THEN u1.FConsignAmount END),0),
		[2017年11月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='11' THEN u1.FConsignAmount END),0),
		[2017年12月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='12' THEN u1.FConsignAmount END),0),
		[2016销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2016' then u1.FConsignAmount END),0),
		[2016年1月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='1' THEN u1.FConsignAmount END),0),
		[2016年2月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='2' THEN u1.FConsignAmount END),0),
		[2016年3月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='3' THEN u1.FConsignAmount END),0),
		[2016年4月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='4' THEN u1.FConsignAmount END),0),
		[2016年5月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='5' THEN u1.FConsignAmount END),0),
		[2016年6月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='6' THEN u1.FConsignAmount END),0),
		[2016年7月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='7' THEN u1.FConsignAmount END),0),
		[2016年8月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='8' THEN u1.FConsignAmount END),0),
		[2016年9月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='9' THEN u1.FConsignAmount END),0),
		[2016年10月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='10' THEN u1.FConsignAmount END),0),
		[2016年11月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='11' THEN u1.FConsignAmount END),0),
		[2016年12月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='12' THEN u1.FConsignAmount END),0),
		[2015销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2015' then u1.FConsignAmount END),0),
		[2015年1月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='1' THEN u1.FConsignAmount END),0),
		[2015年2月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='2' THEN u1.FConsignAmount END),0),
		[2015年3月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='3' THEN u1.FConsignAmount END),0),
		[2015年4月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='4' THEN u1.FConsignAmount END),0),
		[2015年5月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='5' THEN u1.FConsignAmount END),0),
		[2015年6月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='6' THEN u1.FConsignAmount END),0),
		[2015年7月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='7' THEN u1.FConsignAmount END),0),
		[2015年8月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='8' THEN u1.FConsignAmount END),0),
		[2015年9月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='9' THEN u1.FConsignAmount END),0),
		[2015年10月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='10' THEN u1.FConsignAmount END),0),
		[2015年11月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='11' THEN u1.FConsignAmount END),0),
		[2015年12月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='12' THEN u1.FConsignAmount END),0),
		[2014销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2014' then u1.FConsignAmount END),0),
		[2014年1月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='1' THEN u1.FConsignAmount END),0),
		[2014年2月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='2' THEN u1.FConsignAmount END),0),
		[2014年3月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='3' THEN u1.FConsignAmount END),0),
		[2014年4月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='4' THEN u1.FConsignAmount END),0),
		[2014年5月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='5' THEN u1.FConsignAmount END),0),
		[2014年6月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='6' THEN u1.FConsignAmount END),0),
		[2014年7月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='7' THEN u1.FConsignAmount END),0),
		[2014年8月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='8' THEN u1.FConsignAmount END),0),
		[2014年9月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='9' THEN u1.FConsignAmount END),0),
		[2014年10月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='10' THEN u1.FConsignAmount END),0),
		[2014年11月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='11' THEN u1.FConsignAmount END),0),
		[2014年12月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='12' THEN u1.FConsignAmount END),0),
		--[7月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '7' then u1.FConsignAmount END),0),
		--[8月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '8' then u1.FConsignAmount END),0),
		--[9月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '9' then u1.FConsignAmount END),0),
		--[10月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '10' then u1.FConsignAmount END),0),
		--[11月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '11' then u1.FConsignAmount END),0),
		--[12月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FConsignAmount END),0),
		[2017出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2017' then u1.FAuxQty END),0),
		[2017年1月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='1' then u1.FAuxQty END),0),
		[2017年2月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='2' then u1.FAuxQty END),0),
		[2017年3月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='3' then u1.FAuxQty END),0),
		[2017年4月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='4' then u1.FAuxQty END),0),
		[2017年5月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='5' then u1.FAuxQty END),0),
		[2017年6月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='6' then u1.FAuxQty END),0),
		[2017年7月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='7' then u1.FAuxQty END),0),
		[2017年8月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='8' then u1.FAuxQty END),0),
		[2017年9月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='9' then u1.FAuxQty END),0),
		[2017年10月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='10' then u1.FAuxQty END),0),
		[2017年11月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='11' then u1.FAuxQty END),0),
		[2017年12月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='12' then u1.FAuxQty END),0),
		[2016出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2016' then u1.FAuxQty END),0),
		[2016年1月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='1' then u1.FAuxQty END),0),
		[2016年2月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='2' then u1.FAuxQty END),0),
		[2016年3月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='3' then u1.FAuxQty END),0),
		[2016年4月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='4' then u1.FAuxQty END),0),
		[2016年5月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='5' then u1.FAuxQty END),0),
		[2016年6月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='6' then u1.FAuxQty END),0),
		[2016年7月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='7' then u1.FAuxQty END),0),
		[2016年8月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='8' then u1.FAuxQty END),0),
		[2016年9月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='9' then u1.FAuxQty END),0),
		[2016年10月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='10' then u1.FAuxQty END),0),
		[2016年11月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='11' then u1.FAuxQty END),0),
		[2016年12月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='12' then u1.FAuxQty END),0),
		[2015出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2015' then u1.FAuxQty END),0),
		[2015年1月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='1' then u1.FAuxQty END),0),
		[2015年2月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='2' then u1.FAuxQty END),0),
		[2015年3月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='3' then u1.FAuxQty END),0),
		[2015年4月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='4' then u1.FAuxQty END),0),
		[2015年5月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='5' then u1.FAuxQty END),0),
		[2015年6月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='6' then u1.FAuxQty END),0),
		[2015年7月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='7' then u1.FAuxQty END),0),
		[2015年8月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='8' then u1.FAuxQty END),0),
		[2015年9月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='9' then u1.FAuxQty END),0),
		[2015年10月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='10' then u1.FAuxQty END),0),
		[2015年11月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='11' then u1.FAuxQty END),0),
		[2015年12月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='12' then u1.FAuxQty END),0),
		[2014出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2014' then u1.FAuxQty END),0),
		[2014年1月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='1' then u1.FAuxQty END),0),
		[2014年2月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='2' then u1.FAuxQty END),0),
		[2014年3月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='3' then u1.FAuxQty END),0),
		[2014年4月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='4' then u1.FAuxQty END),0),
		[2014年5月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='5' then u1.FAuxQty END),0),
		[2014年6月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='6' then u1.FAuxQty END),0),
		[2014年7月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='7' then u1.FAuxQty END),0),
		[2014年8月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='8' then u1.FAuxQty END),0),
		[2014年9月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='9' then u1.FAuxQty END),0),
		[2014年10月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='10' then u1.FAuxQty END),0),
		[2014年11月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='11' then u1.FAuxQty END),0),
		[2014年12月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='12' then u1.FAuxQty END),0)
		--[7月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '7' then u1.FAuxQty END),0),
		--[8月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '8' then u1.FAuxQty END),0),
		--[9月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '9' then u1.FAuxQty END),0),
		--[10月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '10' then u1.FAuxQty END),0),
		--[11月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '11' then u1.FAuxQty END),0),
		--[12月出货量]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FAuxQty END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	where year(v1.FDate)IN ('2017','2016','2015','2014') 
	--and month(v1.FDate)<='12'
	
	and v1.FTranType=21 
	group by v1.FSupplyID) t1

LEFT JOIN t_Organization v2 ON t1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
LEFT JOIN t_SubMessage v7 ON v2.FRegionID=v7.FInterID
LEFT JOIN t_Emp v8 ON v2.Femployee=v8.FItemID
where v3.FName='健康事业部'
----where v4.FName='微波炉'
order by [FPro],[2017销售额] desc


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
		[2022年1月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='1' then u1.FConsignAmount END),0),
		[2022年2月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='2' then u1.FConsignAmount END),0),
		[2022年3月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='3' then u1.FConsignAmount END),0),
		[2022年4月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='4' then u1.FConsignAmount END),0),
		[2022年5月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='5' then u1.FConsignAmount END),0),
		[2022年6月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='6' then u1.FConsignAmount END),0),
		[2022年7月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='7' then u1.FConsignAmount END),0),
		[2022年8月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='8' then u1.FConsignAmount END),0),
		[2022年9月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='9' then u1.FConsignAmount END),0),
		[2022年10月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='10' then u1.FConsignAmount END),0),
		[2022年11月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='11' then u1.FConsignAmount END),0),
		--[2022年12月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='12' then u1.FConsignAmount END),0),
		[2022销售额]=ISNULL(SUM(CASE when Year(v1.FDate)='2022' AND Month(v1.FDate)<='11'  then u1.FConsignAmount END),0),
		[2021销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then u1.FConsignAmount END),0),
		[2020销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then u1.FConsignAmount END),0),
		[2019销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then u1.FConsignAmount END),0),
		[2018销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2018' then u1.FConsignAmount END),0),
		[2017销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2017' then u1.FConsignAmount END),0),
		[2022年1月出货量]=ISNULL(SUM(CASE when Year(v1.FDate)='2022' AND Month(v1.FDate)='1' then u1.FAuxQty END),0),
		[2022年2月出货量]=ISNULL(SUM(CASE when Year(v1.FDate)='2022' AND Month(v1.FDate)='2' then u1.FAuxQty END),0),
		[2022年3月出货量]=ISNULL(SUM(CASE when Year(v1.FDate)='2022' AND Month(v1.FDate)='3' then u1.FAuxQty END),0),
		[2022年4月出货量]=ISNULL(SUM(CASE when Year(v1.FDate)='2022' AND Month(v1.FDate)='4' then u1.FAuxQty END),0),
		[2022年5月出货量]=ISNULL(SUM(CASE when Year(v1.FDate)='2022' AND Month(v1.FDate)='5' then u1.FAuxQty END),0),
		[2022年6月出货量]=ISNULL(SUM(CASE when Year(v1.FDate)='2022' AND Month(v1.FDate)='6' then u1.FAuxQty END),0),
		[2022年7月出货量]=ISNULL(SUM(CASE when Year(v1.FDate)='2022' AND Month(v1.FDate)='7' then u1.FAuxQty END),0),
		[2022年8月出货量]=ISNULL(SUM(CASE when Year(v1.FDate)='2022' AND Month(v1.FDate)='8' then u1.FAuxQty END),0),
		[2022年9月出货量]=ISNULL(SUM(CASE when Year(v1.FDate)='2022' AND Month(v1.FDate)='9' then u1.FAuxQty END),0),
		[2022年10月出货量]=ISNULL(SUM(CASE when Year(v1.FDate)='2022' AND Month(v1.FDate)='10' then u1.FAuxQty END),0),
		[2022年11月出货量]=ISNULL(SUM(CASE when Year(v1.FDate)='2022' AND Month(v1.FDate)='11' then u1.FAuxQty END),0),
		[2022出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)<='11'  then u1.FAuxQty END),0),
		[2021出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then u1.FAuxQty END),0),
		[2020出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then u1.FAuxQty END),0),
		[2019出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then u1.FAuxQty END),0),
		[2018出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2018' then u1.FAuxQty END),0),
		[2017出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2017' then u1.FAuxQty END),0)
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
where v3.FName='新能源事业部'
----where v4.FName='微波炉'
--and v2.FName like '%顺科新能源%'
order by [2022销售额] desc




--行业年度

DECLARE @Period char(4)
SET @Period='2016' --统计的年月


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

SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
        FBigTrade=CASE WHEN GROUPING(v5.FName)=1 THEN '<事业部合计>' ELSE (v5.FName) END,    
		--P_Money=ISNULL(SUM(u1.FConsignAmount),0),
        --P_AuxQty=ISNULL(SUM(u1.FAuxQty),0),
        [2022年1月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='1'  THEN v1.FConsignAmount END),0),
        [2022年2月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='2'  THEN v1.FConsignAmount END),0),
        [2022年3月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='3'  THEN v1.FConsignAmount END),0),
        [2022年4月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='4'  THEN v1.FConsignAmount END),0),
        [2022年5月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='5'  THEN v1.FConsignAmount END),0),
        [2022年6月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='6'  THEN v1.FConsignAmount END),0),
        [2022年7月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='7'  THEN v1.FConsignAmount END),0),
        [2022年8月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='8'  THEN v1.FConsignAmount END),0),
        [2022年9月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='9'  THEN v1.FConsignAmount END),0),
        [2022年10月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='10'  THEN v1.FConsignAmount END),0),
        [2022年11月销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='11'  THEN v1.FConsignAmount END),0),
        [2022销售额]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)<='11'  THEN v1.FConsignAmount END),0),
        [2021销售额]=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_6 THEN v1.FConsignAmount END),0),
        [2020销售额]=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_5 THEN v1.FConsignAmount END),0),
        [2019销售额]=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_4 THEN v1.FConsignAmount END),0),
        [2018销售额]=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_3 THEN v1.FConsignAmount END),0),
		[2017销售额]=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_2 THEN v1.FConsignAmount END),0),
		--P_Money_7=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_1 THEN v1.FConsignAmount END),0),
        [2022年1月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='1' THEN v1.FAuxQty END),0),
        [2022年2月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='2' THEN v1.FAuxQty END),0),
        [2022年3月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='3' THEN v1.FAuxQty END),0),
        [2022年4月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='4' THEN v1.FAuxQty END),0),
        [2022年5月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='5' THEN v1.FAuxQty END),0),
        [2022年6月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='6' THEN v1.FAuxQty END),0),
        [2022年7月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='7' THEN v1.FAuxQty END),0),
        [2022年8月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='8' THEN v1.FAuxQty END),0),
        [2022年9月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='9' THEN v1.FAuxQty END),0),
        [2022年10月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='10' THEN v1.FAuxQty END),0),
        [2022年11月出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)='11' THEN v1.FAuxQty END),0),
        [2022出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' AND Month(v1.FDate)<='11'  THEN v1.FAuxQty END),0),
        [2021出货量]=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_6 THEN v1.FAuxQty END),0),
        [2020出货量]=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_5 THEN v1.FAuxQty END),0),
        [2019出货量]=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_4 THEN v1.FAuxQty END),0),
        [2018出货量]=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_3 THEN v1.FAuxQty END),0),
        [2017出货量]=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_2 THEN v1.FAuxQty END),0)
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
	LEFT join t_Emp v6 on v2.Femployee=v6.FItemID
    WHERE v1.FTranType=21 And v1.FCheckerID>0 
	AND
		year(v1.FDate) >=@Period
		--and month(v1.FDate)<='8'
	AND
		v3.FName='新能源事业部'
	--AND 
	--	v6.FName='吕俊杰'
    GROUP BY v3.FName,v5.FName  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    ORDER BY [2022销售额] DESC
--     
--select   RIGHT(CONVERT(char(6),getdate(),112),2)    
--select month(getdate())

--企业销售额多年对比
select  v8.FName,
		v7.FName,
		v2.FProvince,
		v2.FName AS FName,
		v3.FName,
		v5.FName,
		v4.FName as 客户所属行业,
        v2.F_112 AS 配套产品,
        v2.F_101 AS 客户等级,
        v9.FName AS 结算方式,
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
		[2022销售额]=ISNULL(SUM(CASE when Year(v1.FDate)='2022' then u1.FConsignAmount END),0),
		[2021销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then u1.FConsignAmount END),0),
		[2020销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then u1.FConsignAmount END),0),
		[2019销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then u1.FConsignAmount END),0),
		[2018销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2018' then u1.FConsignAmount END),0),
		[2017销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2017' then u1.FConsignAmount END),0),
		[2022出货量]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2022' then u1.FAuxQty END),0),
		[2021出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then u1.FAuxQty END),0),
		[2020出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then u1.FAuxQty END),0),
		[2019出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then u1.FAuxQty END),0),
		[2018出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2018' then u1.FAuxQty END),0),
		[2017出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2017' then u1.FAuxQty END),0)
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
LEFT JOIN t_Settle v9 ON v2.FSetID=v9.FItemID
where v3.FName='新能源事业部'
----where v4.FName='微波炉'
--and v2.FName like '%顺科新能源%'
order by [2022销售额] desc


--行业年度

DECLARE @Period char(4)
SET @Period='2016' --统计的年月


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
    P_Money_7 AS '2023销售额',
    P_Money_6 AS '2022销售额',
    P_Money_5 AS '2021销售额',
    P_Money_4 AS '2020销售额',
    P_Money_3 AS '2019销售额',
	P_Money_2 AS '2018销售额',
	--P_AuxQty_1 AS '2009出货量',
    P_AuxQty_7 AS '2023出货量',
    P_AuxQty_6 AS '2022出货量',
    P_AuxQty_5 AS '2021出货量',
    P_AuxQty_4 AS '2020出货量',
    P_AuxQty_3 AS '2019出货量',
	P_AuxQty_2 AS '2018出货量'
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
	and month(v1.FDate)<='6'
	AND v3.FName='新能源事业部'
    GROUP BY v3.FName,v5.FName  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FDepartment,P_Money_7 DESC


;WITH CTE
AS
(
	SELECT --v3.FName,
		--v5.FName,
		--v4.FName as FTradeName,
		--v2.FName AS FName,  
		YEAR(v1.FDate) AS FYear,
		v1.FSupplyID,  
		u1.FItemID,
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
--		[2009]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then u1.FConsignAmount END),0),
--		[2010]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then u1.FConsignAmount END),0),
		--[2014销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2014' then u1.FConsignAmount END),0),
		SUM(u1.FConsignAmount) AS FConsignAmount,
		SUM(u1.FAuxQty) AS FAuxQty,
		AVG(u1.FPrice) AS FPrice,
		count(*) AS FCount
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	where year(v1.FDate)IN ('2020','2021') 
	--month(v1.FDate)>='5'
	--AND
	--MONTH(v1.FDate)<='11'
	
	and
	 v1.FTranType=21 
	group by YEAR(v1.FDate),v1.FSupplyID,u1.FItemID
)
select t1.FYear,t4.FName,t2.FName,t5.FName,t3.FName,t1.FAuxQty,
	t1.FPrice,t1.FConsignAmount,t1.FCount FROM CTE t1
LEFT JOIN t_Organization t2 ON t1.FSupplyID=t2.FItemID
LEFT JOIN t_ICItem t3 ON t1.FItemID=t3.FItemID
LEFT JOIN t_Department t4 ON t2.Fdepartment=t4.FItemID
LEFT JOIN t_Emp t5 ON t2.Femployee=t5.FItemID
WHERE t4.FName IN('电气连接事业部','电气连接国内事业部')

select top 1000 * FROM ICStockBillEntry


SELECT --v3.FName,
		--v5.FName,
		--v4.FName as FTradeName,
		--v2.FName AS FName,  
		t4.FName,
		 
		t3.fname,
		t1.FName,
		max(t5.fname),
		max(t2.FCreateDate) AS 创建日期, 
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
--		[2009]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then u1.FConsignAmount END),0),
--		[2010]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then u1.FConsignAmount END),0),
		[年度出货数量]=ISNULL(SUM(u1.FAuxQty),0),
		[1月出货数量]=ISNULL(SUM(CASE month(v1.FDate) when '1' then u1.FAuxQty END),0),
		[2月出货数量]=ISNULL(SUM(CASE month(v1.FDate) when '2' then u1.FAuxQty END),0),
		[3月出货数量]=ISNULL(SUM(CASE month(v1.FDate) when '3' then u1.FAuxQty END),0),
		[4月出货数量]=ISNULL(SUM(CASE month(v1.FDate) when '4' then u1.FAuxQty END),0),
		[5月出货数量]=ISNULL(SUM(CASE month(v1.FDate) when '5' then u1.FAuxQty END),0),
		[6月出货数量]=ISNULL(SUM(CASE month(v1.FDate) when '6' then u1.FAuxQty END),0),
		[7月出货数量]=ISNULL(SUM(CASE month(v1.FDate) when '7' then u1.FAuxQty END),0),
		[8月出货数量]=ISNULL(SUM(CASE month(v1.FDate) when '8' then u1.FAuxQty END),0),
		[9月出货数量]=ISNULL(SUM(CASE month(v1.FDate) when '9' then u1.FAuxQty END),0),
		[10月出货数量]=ISNULL(SUM(CASE month(v1.FDate) when '10' then u1.FAuxQty END),0),
		[11月出货数量]=ISNULL(SUM(CASE month(v1.FDate) when '11' then u1.FAuxQty END),0),
		[12月出货数量]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FAuxQty END),0),
		[年度销售额]=ISNULL(SUM(u1.FConsignAmount),0),
		[1月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '1' then u1.FConsignAmount END),0),
		[2月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '2' then u1.FConsignAmount END),0),
		[3月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '3' then u1.FConsignAmount END),0),
		[4月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '4' then u1.FConsignAmount END),0),
		[5月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '5' then u1.FConsignAmount END),0),
		[6月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '6' then u1.FConsignAmount END),0),
		[7月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '7' then u1.FConsignAmount END),0),
		[8月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '8' then u1.FConsignAmount END),0),
		[9月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '9' then u1.FConsignAmount END),0),
		[10月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '10' then u1.FConsignAmount END),0),
		[11月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '11' then u1.FConsignAmount END),0),
		[12月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FConsignAmount END),0)
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
	where year(v1.FDate)IN ('2022') 
	and year(t2.FCreateDate) in ('2022')
	--and month(v1.FDate)<='6'
	
	and v1.FTranType=21 
	group by t4.FName,t3.fname,t1.FName



SELECT t1.FNumber,t1.FName,t4.FName,t3.FName FROM t_Organization t1
LEFT JOIN t_Department t2 ON t1.Fdepartment=t2.FItemID
LEFT JOIN t_Emp t3 ON t1.Femployee=t3.FItemID
LEFT JOIN t_Item t4 ON t1.F_117=t4.FItemID
WHERE t2.FName='健康事业部'
and t1.FItemID not IN
(select distinct t1.FSupplyID
from ICStockBill t1 
where year(t1.FDate) in ('2021','2022')
and t1.FTranType=21 )


select convert(varchar(7),getdate(),120)



;WITH CTE
AS
(
	SELECT --v3.FName,
		--v5.FName,
		--v4.FName as FTradeName,
		--v2.FName AS FName,  
		--YEAR(v1.FDate) AS FYear,
		v1.FSupplyID,  
		--u1.FItemID,
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),fnumber like '93.%'
--		[2009]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then u1.FConsignAmount END),0),
--		[2010]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then u1.FConsignAmount END),0),
		--[2014销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2014' then u1.FConsignAmount END),0),
		[2017硅胶]=ISNULL(SUM(CASE when year(v1.FDate)='2017' and t1.FHelpCode like 'GQ%' then u1.FConsignAmount END),0),
		[2018硅胶]=ISNULL(SUM(CASE when year(v1.FDate)='2018' and t1.FHelpCode like 'GQ%' then u1.FConsignAmount END),0),
		[2019硅胶]=ISNULL(SUM(CASE when year(v1.FDate)='2019' and t1.FHelpCode like 'GQ%' then u1.FConsignAmount END),0),
		[2020硅胶]=ISNULL(SUM(CASE when year(v1.FDate)='2020' and t1.FHelpCode like 'GQ%' then u1.FConsignAmount END),0),
		[2021硅胶]=ISNULL(SUM(CASE when year(v1.FDate)='2021' and t1.FHelpCode like 'GQ%' then u1.FConsignAmount END),0),
		[2022硅胶]=ISNULL(SUM(CASE when year(v1.FDate)='2022' and t1.FHelpCode like 'GQ%' then u1.FConsignAmount END),0),

		[2017外购硅胶]=ISNULL(SUM(CASE when year(v1.FDate)='2017' and t1.fnumber like '93.%' then u1.FConsignAmount END),0),
		[2018外购硅胶]=ISNULL(SUM(CASE when year(v1.FDate)='2018' and t1.fnumber like '93.%' then u1.FConsignAmount END),0),
		[2019外购硅胶]=ISNULL(SUM(CASE when year(v1.FDate)='2019' and t1.fnumber like '93.%' then u1.FConsignAmount END),0),
		[2020外购硅胶]=ISNULL(SUM(CASE when year(v1.FDate)='2020' and t1.fnumber like '93.%' then u1.FConsignAmount END),0),
		[2021外购硅胶]=ISNULL(SUM(CASE when year(v1.FDate)='2021' and t1.fnumber like '93.%' then u1.FConsignAmount END),0),
		[2022外购硅胶]=ISNULL(SUM(CASE when year(v1.FDate)='2022' and t1.fnumber like '93.%' then u1.FConsignAmount END),0),
		SUM(u1.FConsignAmount) AS FConsignAmount
		--SUM(u1.FAuxQty) AS FAuxQty
		--AVG(u1.FPrice) AS FPrice,
		--count(*) AS FCount
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_ICItem t1 on u1.fitemid=t1.fitemid
	where year(v1.FDate)IN ('2017','2018','2019','2020','2021','2022') 
	and (t1.FHelpCode like 'GQ%' or t1.fnumber like '93.%')
	--month(v1.FDate)>='5'
	--AND
	--MONTH(v1.FDate)<='11'
	
	and
	 v1.FTranType=21 
	group by v1.FSupplyID--,u1.FItemID
	--order by [2022] DESC
)
select t4.FName,t2.FName,t5.FName,
	t1.* FROM CTE t1
LEFT JOIN t_Organization t2 ON t1.FSupplyID=t2.FItemID
--LEFT JOIN t_ICItem t3 ON t1.FItemID=t3.FItemID
LEFT JOIN t_Department t4 ON t2.Fdepartment=t4.FItemID
LEFT JOIN t_Emp t5 ON t2.Femployee=t5.FItemID
--WHERE t4.FName IN('电气连接事业部','电气连接国内事业部')


--企业销售额
select  v8.FName,
		v7.FName,
		v2.FProvince,
		v2.FName AS FName,
		v3.FName,
		v5.FName AS 行业,
		v4.FName as 客户所属行业,
        v2.F_112 AS 配套产品,
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
		[2023年销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2023' then u1.FConsignAmount END),0),
		[2022年销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2022' then u1.FConsignAmount END),0),
		[2021年销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then u1.FConsignAmount END),0),
		[2020年销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then u1.FConsignAmount END),0),
		[2019年销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then u1.FConsignAmount END),0),
		
		[2023年出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2023' then u1.FAuxQty END),0),
		[2022年出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2022' then u1.FAuxQty END),0),
		[2021年出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then u1.FAuxQty END),0),
		[2020年出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then u1.FAuxQty END),0),
		[2019年出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then u1.FAuxQty END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	where month(v1.FDate)<='12'
	
	and v1.FTranType=21 
	group by v1.FSupplyID) t1

LEFT JOIN t_Organization v2 ON t1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
LEFT JOIN t_SubMessage v7 ON v2.FRegionID=v7.FInterID
LEFT JOIN t_Emp v8 ON v2.Femployee=v8.FItemID
where v3.FName='新能源事业部'
----where v4.FName='微波炉'
--and v2.FName like '%顺科新能源%'
order by [2023年销售额] desc


SELECT FDepartment AS 事业部,FBigTrade AS 行业,
	P_Money AS '年销售额',
	P_AuxQty AS '年出货量',
    P_Money_1 AS '2023销售额',
    P_Money_2 AS '2022销售额',
    P_Money_3 AS '2021销售额',
    P_Money_4 AS '2020销售额',
    P_Money_5 AS '2019销售额',
    P_AuxQty_1 AS '2023出货量',
    P_AuxQty_2 AS '2022出货量',
    P_AuxQty_3 AS '2021出货量',
    P_AuxQty_4 AS '2020出货量',
    P_AuxQty_5 AS '2019出货量'
FROM(
    SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
        FBigTrade=CASE WHEN GROUPING(v5.FName)=1 THEN '<事业部合计>' ELSE (v5.FName) END,    
		P_Money=ISNULL(SUM(u1.FConsignAmount),0),
        P_AuxQty=ISNULL(SUM(u1.FAuxQty),0),
        P_Money_1=ISNULL(SUM(CASE year(v1.FDate) WHEN '2023' THEN u1.FConsignAmount END),0),
        P_Money_2=ISNULL(SUM(CASE year(v1.FDate) WHEN '2022' THEN u1.FConsignAmount END),0),
        P_Money_3=ISNULL(SUM(CASE year(v1.FDate) WHEN '2021' THEN u1.FConsignAmount END),0),
        P_Money_4=ISNULL(SUM(CASE year(v1.FDate) WHEN '2020' THEN u1.FConsignAmount END),0),
        P_Money_5=ISNULL(SUM(CASE year(v1.FDate) WHEN '2019' THEN u1.FConsignAmount END),0),
        
        P_AuxQty_1=ISNULL(SUM(CASE year(v1.FDate) WHEN '2023' THEN u1.FAuxQty END),0),
        P_AuxQty_2=ISNULL(SUM(CASE year(v1.FDate) WHEN '2022' THEN u1.FAuxQty END),0),
        P_AuxQty_3=ISNULL(SUM(CASE year(v1.FDate) WHEN '2021' THEN u1.FAuxQty END),0),
        P_AuxQty_4=ISNULL(SUM(CASE year(v1.FDate) WHEN '2020' THEN u1.FAuxQty END),0),
        P_AuxQty_5=ISNULL(SUM(CASE year(v1.FDate) WHEN '2019' THEN u1.FAuxQty END),0)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID
	left join t_Item v5 ON v2.F_117=v5.FItemID
    WHERE v1.FTranType=21 And v1.FCheckerID>0 AND
		month(v1.FDate) <='12'
		--and month(v1.FDate)<month(getdate()) 
		and v3.FName='新能源事业部'

    GROUP BY v3.FName,v5.FName  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FDepartment,P_Money DESC

