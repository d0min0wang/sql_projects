
DECLARE @Period char(4)
SET @Period='2018' --统计的年月


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
    P_Money_2 AS '2019销售额',
    P_Money_3 AS '2020销售额',
    P_Money_4 AS '2021销售额',
    P_Money_5 AS '2022销售额',
    P_Money_6 AS '2023销售额',
	P_Money_7 AS '2024销售额',
	--P_AuxQty_1 AS '2009出货量',
    P_AuxQty_2 AS '2019出货量',
    P_AuxQty_3 AS '2020出货量',
    P_AuxQty_4 AS '2021出货量',
    P_AuxQty_5 AS '2022出货量',
    P_AuxQty_6 AS '2023出货量',
	P_AuxQty_7 AS '2024出货量'
FROM(
    SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
        FBigTrade=CASE WHEN GROUPING(v5.FName)=1 THEN '<事业部合计>' ELSE (v5.FName) END,    
		--P_Money=ISNULL(SUM(u1.FConsignAmount),0),
        --P_AuxQty=ISNULL(SUM(u1.FAuxQty),0),
        P_Money_1=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_1 THEN v1.FConsignAmount END),0),
        P_Money_2=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_2 THEN v1.FConsignAmount END),0),
        P_Money_3=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_3 THEN v1.FConsignAmount END),0),
        P_Money_4=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_4 THEN v1.FConsignAmount END),0),
        P_Money_5=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_5 THEN v1.FConsignAmount END),0),
		P_Money_6=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_6 THEN v1.FConsignAmount END),0),
		P_Money_7=ISNULL(SUM(CASE when Year(v1.FDate)=@Period_7 and MONTH(v1.FDate)<'12' THEN v1.FConsignAmount END),0),
        P_AuxQty_1=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_1 THEN v1.FAuxQty END),0),
        P_AuxQty_2=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_2 THEN v1.FAuxQty END),0),
        P_AuxQty_3=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_3 THEN v1.FAuxQty END),0),
        P_AuxQty_4=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_4 THEN v1.FAuxQty END),0),
        P_AuxQty_5=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_5 THEN v1.FAuxQty END),0),
        P_AuxQty_6=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_6 THEN v1.FAuxQty END),0),
        P_AuxQty_7=ISNULL(SUM(CASE when Year(v1.FDate)=@Period_7 and MONTH(v1.FDate)<'12' THEN v1.FAuxQty END),0)
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
	AND
		year(v1.FDate) >=@Period
		and month(v1.FDate)<='12'

    GROUP BY v3.FName,v5.FName  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FDepartment,P_Money_7 DESC


--业务员

DECLARE @Period char(4)
SET @Period='2018' --统计的年月


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
SELECT FDepartment AS 事业部,FEmp as 业务员,FBigTrade AS 行业,
	--P_Money AS '年销售额',
	--P_AuxQty AS '年出货量',
	--P_Money_1 AS '2009销售额',
    P_Money_2 AS '2019销售额',
    P_Money_3 AS '2020销售额',
    P_Money_4 AS '2021销售额',
    P_Money_5 AS '2022销售额',
    P_Money_6 AS '2023销售额',
	P_Money_7 AS '2024销售额',
	--P_AuxQty_1 AS '2009出货量',
    P_AuxQty_2 AS '2019出货量',
    P_AuxQty_3 AS '2020出货量',
    P_AuxQty_4 AS '2021出货量',
    P_AuxQty_5 AS '2022出货量',
    P_AuxQty_6 AS '2023出货量',
	P_AuxQty_7 AS '2024出货量'
FROM(
    SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
        FEmp=CASE WHEN GROUPING(v4.FName)=1 THEN '<事业部合计>' ELSE (v4.FName) END,    
		FBigTrade=CASE WHEN GROUPING(v5.FName)=1 THEN '<业务员合计>' ELSE (v5.FName) END,  
		--P_Money=ISNULL(SUM(u1.FConsignAmount),0),
        --P_AuxQty=ISNULL(SUM(u1.FAuxQty),0),
        P_Money_1=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_1 THEN v1.FConsignAmount END),0),
        P_Money_2=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_2 THEN v1.FConsignAmount END),0),
        P_Money_3=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_3 THEN v1.FConsignAmount END),0),
        P_Money_4=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_4 THEN v1.FConsignAmount END),0),
        P_Money_5=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_5 THEN v1.FConsignAmount END),0),
		P_Money_6=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_6 THEN v1.FConsignAmount END),0),
		P_Money_7=ISNULL(SUM(CASE when Year(v1.FDate)=@Period_7 and MONTH(v1.FDate)<'12' THEN v1.FConsignAmount END),0),
        P_AuxQty_1=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_1 THEN v1.FAuxQty END),0),
        P_AuxQty_2=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_2 THEN v1.FAuxQty END),0),
        P_AuxQty_3=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_3 THEN v1.FAuxQty END),0),
        P_AuxQty_4=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_4 THEN v1.FAuxQty END),0),
        P_AuxQty_5=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_5 THEN v1.FAuxQty END),0),
        P_AuxQty_6=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_6 THEN v1.FAuxQty END),0),
        P_AuxQty_7=ISNULL(SUM(CASE when Year(v1.FDate)=@Period_7 and MONTH(v1.FDate)<'12' THEN v1.FAuxQty END),0)
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
	LEFT JOIN t_Item v4 ON v2.Femployee=v4.FItemID
	left join t_Item v5 ON v2.F_117=v5.FItemID
    WHERE v1.FTranType=21 And v1.FCheckerID>0 
	AND
		year(v1.FDate) >=@Period
		and month(v1.FDate)<='12'

    GROUP BY v3.FName,v4.FName,v5.FName  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FDepartment,P_Money_7 DESC




SELECT --v3.FName,
		--v5.FName,
		v4.FName as FTradeName,
		v2.FName AS FName,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
		--[2008销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FConsignAmount END),0),
		--[2009销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FConsignAmount END),0),
		[2014销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2014' then v1.FConsignAmount END),0),
		[2015销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2015' then v1.FConsignAmount END),0),
		[2016销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2016' then v1.FConsignAmount END),0),
		[2017销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2017' then v1.FConsignAmount END),0),
		[2018销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2018' then v1.FConsignAmount END),0),
		[2019销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FConsignAmount END),0),
		[2020销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FConsignAmount END),0),
		[2021销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FConsignAmount END),0),
		[2022销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2022' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
		[2023销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2023' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
		[2024销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2024' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
		--[2008出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FAuxQty END),0),
		--[2009出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FAuxQty END),0),
		[2019出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FAuxQty END),0),
		[2020出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FAuxQty END),0),
		[2021出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0),
		[2022出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2022' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
		[2023出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2023' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
		[2024出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2024' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0)
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
--and v3.FName='健康事业部' --and v5.FName='体育用品' 
--and v4.FName IN ('通信设备','光纤连接器','射频连接器','天线','光纤\光缆','日用五金')

group by --v3.FName,v5.FName,
v4.FName,v2.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
with rollup
order by v4.FName,
[2024销售额] desc






SELECT [部门]=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
		--v5.FName,
		[行业]=CASE WHEN GROUPING(v4.FName)=1 THEN '<事业部合计>' ELSE (v4.FName) END,
		[客户]=CASE WHEN GROUPING(v2.FName)=1 THEN '<行业合计>' ELSE (v2.FName) END,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
		--[2008销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FConsignAmount END),0),
		--[2009销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FConsignAmount END),0),
		[2019销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FConsignAmount END),0),
		[2020销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FConsignAmount END),0),
        [2020对比2019年销售额]=(ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FConsignAmount END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FConsignAmount END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2019' then v1.FConsignAmount END),0),
		[2021销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FConsignAmount END),0),
        [2021对比2020年销售额]=(ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FConsignAmount END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FConsignAmount END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2020' then v1.FConsignAmount END),0),
		[2022销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2022' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
        [2022对比2021年销售额]=(ISNULL(SUM(CASE year(v1.FDate) when '2022' then v1.FConsignAmount END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FConsignAmount END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2021' then v1.FConsignAmount END),0),
		[2023销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2023' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
        [2023对比2022年销售额]=(ISNULL(SUM(CASE year(v1.FDate) when '2023' then v1.FConsignAmount END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2022' then v1.FConsignAmount END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2022' then v1.FConsignAmount END),0),
		[2024销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2024' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
		[2024对比2023年销售额]=(ISNULL(SUM(CASE year(v1.FDate) when '2024' then v1.FConsignAmount END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2023' then v1.FConsignAmount END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2023' then v1.FConsignAmount END),0),
		[2025销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2025' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
		[2025对比2024年销售额]=(ISNULL(SUM(CASE year(v1.FDate) when '2025' then v1.FConsignAmount END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2024' then v1.FConsignAmount END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2024' then v1.FConsignAmount END),0),
		--[2008出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FAuxQty END),0),
		--[2009出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FAuxQty END),0),
		[2019出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FAuxQty END),0),
		[2020出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FAuxQty END),0),
        [2020对比2019年出货量]=(ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FAuxQty END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FAuxQty END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2019' then v1.FAuxQty END),0),
		[2021出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0),
        [2021对比2020年出货量]=(ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FAuxQty END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2020' then v1.FAuxQty END),0),
		[2022出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2022' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
        [2022对比2021年出货量]=(ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0),
		[2023出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2023' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
        [2023对比2022年出货量]=(ISNULL(SUM(CASE year(v1.FDate) when '2023' then v1.FAuxQty END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2022' then v1.FAuxQty END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2022' then v1.FAuxQty END),0),
		[2024出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2024' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
        [2024对比2023年出货量]=(ISNULL(SUM(CASE year(v1.FDate) when '2024' then v1.FAuxQty END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2023' then v1.FAuxQty END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2023' then v1.FAuxQty END),0),
		[2025出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2025' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
        [2025对比2024年出货量]=(ISNULL(SUM(CASE year(v1.FDate) when '2025' then v1.FAuxQty END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2024' then v1.FAuxQty END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2024' then v1.FAuxQty END),0)
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
and v3.FName='医疗事业部' --and v5.FName='体育用品' 
--and v4.FName IN ('通信设备','光纤连接器','射频连接器','天线','光纤\光缆','日用五金')

group by --v3.FName,v5.FName,
v3.fname,v4.FName,v2.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
with rollup
order by v3.fname,v4.FName,v2.FName



SELECT [部门]=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
		--v5.FName,
		[业务员]=CASE WHEN GROUPING(v7.FName)=1 THEN '<事业部合计>' ELSE (v7.FName) END,
		[行业]=CASE WHEN GROUPING(v4.FName)=1 THEN '<业务员合计>' ELSE (v4.FName) END,
		[客户]=CASE WHEN GROUPING(v2.FName)=1 THEN '<行业合计>' ELSE (v2.FName) END,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
		--[2008销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FConsignAmount END),0),
		--[2009销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FConsignAmount END),0),
		[2019销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FConsignAmount END),0),
		[2020销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FConsignAmount END),0),
        [2020对比2019年销售额]=(ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FConsignAmount END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FConsignAmount END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2019' then v1.FConsignAmount END),0),
		[2021销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FConsignAmount END),0),
        [2021对比2020年销售额]=(ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FConsignAmount END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FConsignAmount END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2020' then v1.FConsignAmount END),0),
		[2022销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2022' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
        [2022对比2021年销售额]=(ISNULL(SUM(CASE year(v1.FDate) when '2022' then v1.FConsignAmount END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FConsignAmount END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2021' then v1.FConsignAmount END),0),
		[2023销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2023' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
        [2023对比2022年销售额]=(ISNULL(SUM(CASE year(v1.FDate) when '2023' then v1.FConsignAmount END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2022' then v1.FConsignAmount END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2022' then v1.FConsignAmount END),0),
		[2024销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2024' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
		[2024对比2023年销售额]=(ISNULL(SUM(CASE year(v1.FDate) when '2024' then v1.FConsignAmount END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2023' then v1.FConsignAmount END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2023' then v1.FConsignAmount END),0),
		[2025销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2025' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
		[2025对比2024年销售额]=(ISNULL(SUM(CASE year(v1.FDate) when '2025' then v1.FConsignAmount END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2024' then v1.FConsignAmount END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2024' then v1.FConsignAmount END),0),
		--[2008出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FAuxQty END),0),
		--[2009出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FAuxQty END),0),
		[2019出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FAuxQty END),0),
		[2020出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FAuxQty END),0),
        [2020对比2019年出货量]=(ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FAuxQty END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FAuxQty END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2019' then v1.FAuxQty END),0),
		[2021出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0),
        [2021对比2020年出货量]=(ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FAuxQty END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2020' then v1.FAuxQty END),0),
		[2022出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2022' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
        [2022对比2021年出货量]=(ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0),
		[2023出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2023' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
        [2023对比2022年出货量]=(ISNULL(SUM(CASE year(v1.FDate) when '2023' then v1.FAuxQty END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2022' then v1.FAuxQty END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2022' then v1.FAuxQty END),0),
		[2024出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2024' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
        [2024对比2023年出货量]=(ISNULL(SUM(CASE year(v1.FDate) when '2024' then v1.FAuxQty END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2023' then v1.FAuxQty END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2023' then v1.FAuxQty END),0),
		[2025出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2025' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
        [2025对比2024年出货量]=(ISNULL(SUM(CASE year(v1.FDate) when '2025' then v1.FAuxQty END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2024' then v1.FAuxQty END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2024' then v1.FAuxQty END),0)
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
	LEFT JOIN t_Emp v7 ON v2.Femployee=v7.FItemID
where --year(v1.FDate) <= '2013')
month(v1.FDate)<='12' 
and 
v1.FTranType=21 
And v1.FCheckerID>0 
and v3.FName='医疗事业部' --and v5.FName='体育用品' 
--and v4.FName IN ('通信设备','光纤连接器','射频连接器','天线','光纤\光缆','日用五金')

group by --v3.FName,v5.FName,
v3.fname,v7.FName,v4.FName,v2.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
with rollup
order by v3.fname,v7.FName,v4.FName,v2.FName





SELECT [部门]=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
		--v5.FName,
		[行业]=CASE WHEN GROUPING(v4.FName)=1 THEN '<事业部合计>' ELSE (v4.FName) END,
		--[客户]=CASE WHEN GROUPING(v2.FName)=1 THEN '<行业合计>' ELSE (v2.FName) END,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
		--[2008销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FConsignAmount END),0),
		--[2009销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FConsignAmount END),0),
		[2019销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FConsignAmount END),0),
		[2020销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FConsignAmount END),0),
        [2020对比2019年销售额]=(ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FConsignAmount END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FConsignAmount END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2019' then v1.FConsignAmount END),0),
		[2021销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FConsignAmount END),0),
        [2021对比2020年销售额]=(ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FConsignAmount END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FConsignAmount END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2020' then v1.FConsignAmount END),0),
		[2022销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2022' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
        [2022对比2021年销售额]=(ISNULL(SUM(CASE year(v1.FDate) when '2022' then v1.FConsignAmount END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FConsignAmount END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2021' then v1.FConsignAmount END),0),
		[2023销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2023' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
        [2023对比2022年销售额]=(ISNULL(SUM(CASE year(v1.FDate) when '2023' then v1.FConsignAmount END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2022' then v1.FConsignAmount END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2022' then v1.FConsignAmount END),0),
		[2024销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2024' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
		--[2008出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FAuxQty END),0),
		--[2009出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FAuxQty END),0),
		[2019出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FAuxQty END),0),
		[2020出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FAuxQty END),0),
        [2020对比2019年出货量]=(ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FAuxQty END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FAuxQty END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2019' then v1.FAuxQty END),0),
		[2021出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0),
        [2021对比2020年出货量]=(ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FAuxQty END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2020' then v1.FAuxQty END),0),
		[2022出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2022' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
        [2022对比2021年出货量]=(ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0),
		[2023出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2023' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
        [2023对比2022年出货量]=(ISNULL(SUM(CASE year(v1.FDate) when '2023' then v1.FAuxQty END),0)
            -ISNULL(SUM(CASE year(v1.FDate) when '2022' then v1.FAuxQty END),0))
            /nullif(SUM(CASE year(v1.FDate) when '2022' then v1.FAuxQty END),0),
		[2024出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2024' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0)
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
and v3.FName='健康事业部' --and v5.FName='体育用品' 
--and v4.FName IN ('通信设备','光纤连接器','射频连接器','天线','光纤\光缆','日用五金')

group by --v3.FName,v5.FName,
v3.fname,v4.FName--,v2.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
with rollup
order by v3.fname,v4.FName--,v2.FName


SELECT * FROM t_Organization

--国外客户

SELECT --v3.FName,
		--v5.FName,
		v2.FCountry as FCountry,
		v2.FName AS FName,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
		--[2008销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FConsignAmount END),0),
		--[2009销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FConsignAmount END),0),
		[2019销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FConsignAmount END),0),
		[2020销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FConsignAmount END),0),
		[2021销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FConsignAmount END),0),
		[2022销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2022' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
		[2023销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2023' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
		[2024销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2024' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
		--[2008出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FAuxQty END),0),
		--[2009出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FAuxQty END),0),
		[2019出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FAuxQty END),0),
		[2020出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FAuxQty END),0),
		[2021出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0),
		[2022出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2022' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
		[2023出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2023' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
		[2024出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2024' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0)
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
v2.FCountry not in ('中国')
AND
month(v1.FDate)<='12' 
and 
v1.FTranType=21 
And v1.FCheckerID>0 
--and v3.FName='健康事业部' --and v5.FName='体育用品' 
--and v4.FName IN ('通信设备','光纤连接器','射频连接器','天线','光纤\光缆','日用五金')

group by --v3.FName,v5.FName,
v2.FCountry,v2.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
with rollup
order by [2024销售额] desc




SELECT v3.FName,
		--v5.FName,
		--v4.FName as FTradeName,
		--v2.FName AS FName,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
		--[2008销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FConsignAmount END),0),
		--[2009销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FConsignAmount END),0),
		[2014销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2014' then v1.FConsignAmount END),0),
		[2015销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2015' then v1.FConsignAmount END),0),
		[2016销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2016' then v1.FConsignAmount END),0),
		[2017销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2017' then v1.FConsignAmount END),0),
		[2018销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2018' then v1.FConsignAmount END),0),
		[2019销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FConsignAmount END),0),
		[2020销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FConsignAmount END),0),
		[2021销售额]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FConsignAmount END),0),
		[2022销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2022' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
		[2023销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2023' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
		[2024销售额]=ISNULL(SUM(CASE when year(v1.FDate) = '2024' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
		--[2008出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FAuxQty END),0),
		--[2009出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FAuxQty END),0),
		[2019出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2019' then v1.FAuxQty END),0),
		[2020出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2020' then v1.FAuxQty END),0),
		[2021出货量]=ISNULL(SUM(CASE year(v1.FDate) when '2021' then v1.FAuxQty END),0),
		[2022出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2022' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
		[2023出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2023' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
		[2024出货量]=ISNULL(SUM(CASE when year(v1.FDate) = '2024' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0)
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
--and v3.FName='健康事业部' --and v5.FName='体育用品' 
--and v4.FName IN ('通信设备','光纤连接器','射频连接器','天线','光纤\光缆','日用五金')

group by v3.FName
--,v5.FName,
--v4.FName,v2.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
with rollup
order by --v4.FName,
[2024销售额] desc


SELECT ',' + F_210
    FROM (
        SELECT t2_inner.F_210, u1_inner.FQty,
               ROW_NUMBER() OVER (PARTITION BY t2_inner.F_210 ORDER BY u1_inner.FQty DESC) AS RowNum
        FROM ICStockBill v1_inner
        INNER JOIN ICStockBillEntry u1_inner ON v1_inner.FInterID = u1_inner.FInterID AND u1_inner.FInterID <> 0
        LEFT OUTER JOIN t_Department t105_inner ON v1_inner.FDeptID = t105_inner.FItemID AND t105_inner.FItemID <> 0
        LEFT OUTER JOIN t_Organization t2_inner ON t2_inner.FItemID = v1_inner.FSupplyID
        WHERE
            u1_inner.fitemid = u1.fitemid
            AND YEAR(v1_inner.Fdate) >= '2024' --AND t105_inner.FName IN ('电气连接事业部', '电气连接国内事业部')
            AND (v1_inner.FTranType = 21)
    ) AS OrderedData
    WHERE RowNum = 1  -- 仅选择去重后的第一个记录
    ORDER BY OrderedData.FQty DESC  -- 按FQty降序排序
    FOR XML PATH('')