use AIS20140921170539
DECLARE @Period char(6)
DECLARE @Department char(30)
SET @Period='202207' --统计的年月
SET @Department='电气连接国内事业部'

--SELECT MONTH(@Period+'01')

--年度累计销售额
DECLARE @Last_Year char(6),@Previous_Period char(6)
SELECT @Last_Year=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112)
    ,@Previous_Period=CONVERT(char(6),DATEADD(Month,-1,@Period+'01'),112)
;WITH basicTable
as
(
SELECT '新增规格数(个)' AS fname,
    '' AS fdepartment,
    count(CASE WHEN 
            year(t2.FCreateDate) =year(@Period+'01') 
            and MONTH(t2.FCreateDate) =MONTH(@Period+'01') 
        THEN 1 else null END) AS thisMonth,
    count(CASE WHEN 
            year(t2.FCreateDate) =year(@Last_Year+'01') 
            and MONTH(t2.FCreateDate) =MONTH(@Last_Year+'01') 
        THEN 1 else null END) AS lastYearMonth,
    count(CASE WHEN 
            year(t2.FCreateDate) =year(@Previous_Period+'01') 
            and MONTH(t2.FCreateDate) =MONTH(@Previous_Period+'01') 
        THEN 1 else null END) AS lastMonth,
    count(CASE WHEN 
            year(t2.FCreateDate) =year(@Period+'01') 
            and MONTH(t2.FCreateDate) <=MONTH(@Period+'01') 
        THEN 1 else null END) AS thisYear,
    count(CASE WHEN 
            year(t2.FCreateDate) =year(@Last_Year+'01') 
            and MONTH(t2.FCreateDate) <=MONTH(@Last_Year+'01') 
        THEN 1 else null END) AS lastYear
FROM t_ICItem t1
LEFT JOIN t_BaseProperty t2 on	 t1.FItemID=t2.FItemID AND t2.FTypeID=3 
left join t_Item t4 ON t1.FParentID=t4.FItemID
left join t_Item t5 ON t4.FParentID=t5.FItemID
left join t_Item t6 ON t5.FParentID=t6.FItemID
WHERE YEAR(t2.FCreateDate) IN (year(@Period+'01') ,year(@Last_Year+'01'))
AND t6.FNumber='90'
union ALL
--部门新增规格个数
SELECT '部门新增规格数(个)' AS fname,
    t3.FName AS fdepartment,
    count(CASE WHEN 
            year(t2.FCreateDate) =year(@Period+'01') 
            and MONTH(t2.FCreateDate) =MONTH(@Period+'01') 
        THEN 1 else null END) AS thisMonth,
    count(CASE WHEN 
            year(t2.FCreateDate) =year(@Last_Year+'01') 
            and MONTH(t2.FCreateDate) =MONTH(@Last_Year+'01') 
        THEN 1 else null END) AS lastYearMonth,
    count(CASE WHEN 
            year(t2.FCreateDate) =year(@Previous_Period+'01') 
            and MONTH(t2.FCreateDate) =MONTH(@Previous_Period+'01') 
        THEN 1 else null END) AS lastMonth,
    count(CASE WHEN 
            year(t2.FCreateDate) =year(@Period+'01') 
            and MONTH(t2.FCreateDate) <=MONTH(@Period+'01') 
        THEN 1 else null END) AS thisYear,
    count(CASE WHEN 
            year(t2.FCreateDate) =year(@Last_Year+'01') 
            and MONTH(t2.FCreateDate) <=MONTH(@Last_Year+'01') 
        THEN 1 else null END) AS lastYear
FROM t_ICItem t1
LEFT JOIN t_BaseProperty t2 on	 t1.FItemID=t2.FItemID AND t2.FTypeID=3 
LEFT JOIN t_Department t3 ON t1.FSource=t3.FItemID
left join t_Item t4 ON t1.FParentID=t4.FItemID
left join t_Item t5 ON t4.FParentID=t5.FItemID
left join t_Item t6 ON t5.FParentID=t6.FItemID
WHERE YEAR(t2.FCreateDate) IN (year(@Period+'01') ,year(@Last_Year+'01'))
and t6.FNumber='90'
GROUP BY t3.FName
UNION ALL
--月度新增规格销售额
SELECT  '月度新增规格销售额(元)' AS fname,
        t4.fname AS Fdepartment,
		[thisMonth]=ISNULL(SUM(CASE WHEN
                                (year(t2.FCreateDate) =year(@Period+'01') and MONTH(t2.FCreateDate) =MONTH(@Period+'01')) and
                                (year(v1.FDate) =year(@Period+'01') and MONTH(v1.FDate) =MONTH(@Period+'01'))
                                  then u1.FConsignAmount END),0),
		[lastYearMonth]=ISNULL(SUM(CASE WHEN
                                (year(t2.FCreateDate) =year(@Last_Year+'01') and MONTH(t2.FCreateDate) =MONTH(@Last_Year+'01')) and
                                (year(v1.FDate) =year(@Last_Year+'01') and MONTH(v1.FDate) =MONTH(@Last_Year+'01'))
                                  then u1.FConsignAmount END),0),
        [lastMonth]=ISNULL(SUM(CASE WHEN
                                (year(t2.FCreateDate) =year(@Previous_Period+'01') and MONTH(t2.FCreateDate) =MONTH(@Previous_Period+'01')) and
                                (year(v1.FDate) =year(@Previous_Period+'01') and MONTH(v1.FDate) =MONTH(@Previous_Period+'01'))
                                  then u1.FConsignAmount END),0),
		[thisYear]=ISNULL(SUM(CASE WHEN
                                (year(t2.FCreateDate) =year(@Period+'01') and MONTH(t2.FCreateDate) =MONTH(@Period+'01')) and
                                (year(v1.FDate) =year(@Period+'01') and MONTH(v1.FDate) <=MONTH(@Period+'01'))
                                  then u1.FConsignAmount END),0),
		[lastYear]=ISNULL(SUM(CASE WHEN
                                (year(t2.FCreateDate) =year(@Last_Year+'01') and MONTH(t2.FCreateDate) =MONTH(@Last_Year+'01')) and
                                (year(v1.FDate) =year(@Last_Year+'01') and MONTH(v1.FDate) <=MONTH(@Last_Year+'01'))
                                  then u1.FConsignAmount END),0)
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
	WHERE YEAR(v1.FDate) IN (year(@Period+'01') ,year(@Last_Year+'01'))
    and YEAR(t2.FCreateDate) IN (year(@Period+'01') ,year(@Last_Year+'01'))
    --where year(v1.FDate)IN ('2022') 
	--and year(t2.FCreateDate) in ('2022')
	--and month(v1.FDate)<='6'
    and v1.FTranType=21 
    GROUP BY t4.fname
union ALL
--累计新增规格销售额
SELECT  '累计新增规格销售额(元)' AS fname,
        t4.fname as fdepartment,
		[thisMonth]=ISNULL(SUM(CASE WHEN
                                (year(t2.FCreateDate) =year(@Period+'01') and MONTH(t2.FCreateDate) <=MONTH(@Period+'01')) and
                                (year(v1.FDate) =year(@Period+'01') and MONTH(v1.FDate) =MONTH(@Period+'01'))
                                  then u1.FConsignAmount END),0),
		[lastYearMonth]=ISNULL(SUM(CASE WHEN
                                (year(t2.FCreateDate) =year(@Last_Year+'01') and MONTH(t2.FCreateDate) <=MONTH(@Last_Year+'01')) and
                                (year(v1.FDate) =year(@Last_Year+'01') and MONTH(v1.FDate) =MONTH(@Last_Year+'01'))
                                  then u1.FConsignAmount END),0),
        [lastMonth]=ISNULL(SUM(CASE WHEN
                                (year(t2.FCreateDate) =year(@Previous_Period+'01') and MONTH(t2.FCreateDate) <=MONTH(@Previous_Period+'01')) and
                                (year(v1.FDate) =year(@Previous_Period+'01') and MONTH(v1.FDate) =MONTH(@Previous_Period+'01'))
                                  then u1.FConsignAmount END),0),
		[thisYear]=ISNULL(SUM(CASE WHEN
                                (year(t2.FCreateDate) =year(@Period+'01') and MONTH(t2.FCreateDate) <=MONTH(@Period+'01')) and
                                (year(v1.FDate) =year(@Period+'01') and MONTH(v1.FDate) <=MONTH(@Period+'01'))
                                  then u1.FConsignAmount END),0),
		[lastYear]=ISNULL(SUM(CASE WHEN
                                (year(t2.FCreateDate) =year(@Last_Year+'01') and MONTH(t2.FCreateDate) <=MONTH(@Last_Year+'01')) and
                                (year(v1.FDate) =year(@Last_Year+'01') and MONTH(v1.FDate) <=MONTH(@Last_Year+'01'))
                                  then u1.FConsignAmount END),0)
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
	WHERE YEAR(v1.FDate) IN (year(@Period+'01') ,year(@Last_Year+'01'))
    and YEAR(t2.FCreateDate) IN (year(@Period+'01') ,year(@Last_Year+'01'))
    --where year(v1.FDate)IN ('2022') 
	--and year(t2.FCreateDate) in ('2022')
	--and month(v1.FDate)<='6'
	and v1.FTranType=21 
    GROUP BY t4.fname
)
SELECT fname as 项目,
        fdepartment as 部门,
        thisMonth as 本年同期,
        lastMonth as 本年上期,
        lastyearmonth as 去年同期,
        thisMonth-lastMonth as 环比增长,
        CASE
                WHEN lastMonth=0 THEN '----'
                ELSE SUBSTRING('↓－↑',CAST(SIGN(thisMonth-lastMonth) as int)+2,1)
                    +CAST(CAST(ABS(thisMonth-lastMonth)*100/(CASE WHEN lastMonth =0 THEN 1 ELSE lastMonth END) as decimal(10,2)) as varchar)+'%'
            END as 环比增长率,
        thisMonth-lastYearMonth as 同比增长,
        CASE
                WHEN lastYearMonth=0 THEN '----'
                ELSE SUBSTRING('↓－↑',CAST(SIGN(thisMonth-lastYearMonth) as int)+2,1)
                    +CAST(CAST(ABS(thisMonth-lastYearMonth)*100/lastYearMonth as decimal(10,2)) as varchar)+'%'
            END as 同比增长率,
        thisYear as 本年累计,
        lastYear as 去年累计,
        thisYear-lastYear as 累计同比增长,
        CASE
                WHEN lastYear=0 THEN '----'
                ELSE SUBSTRING('↓－↑',CAST(SIGN(thisYear-lastYear) as int)+2,1)
                    +CAST(CAST(ABS(thisYear-lastYear)*100/(CASE WHEN lastYear =0 THEN 1 ELSE lastYear END) as decimal(10,2)) as varchar)+'%'
            END as 累计同比增长率
    --into #tongbihuanbi
    FROM basicTable



SELECT '部门新增规格数(个)' AS fname,
    t3.FName AS fdepartment,
    t1.*
FROM t_ICItem t1
LEFT JOIN t_BaseProperty t2 on	 t1.FItemID=t2.FItemID --AND t2.FTypeID=3 
LEFT JOIN t_Department t3 ON t1.FSource=t3.FItemID
left join t_Item t4 ON t1.FParentID=t4.FItemID
left join t_Item t5 ON t4.FParentID=t5.FItemID
left join t_Item t6 ON t5.FParentID=t6.FItemID
WHERE t1.FName='ECD17-33(1.0)/E01'
WHERE YEAR(t2.FCreateDate)='2022' AND MONTH(t2.FCreateDate)='07'
AND t6.FNumber in ('90','91','92','93')
and FHelpCode IS NOT NULL


SELECT  '月度新增规格销售额(元)' AS fname,
        t4.fname AS Fdepartment,
		t1.FName,
        t2.FCreateDate
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
	WHERE YEAR(v1.FDate) IN ('2022')
    and YEAR(t2.FCreateDate) ='2022' and MONTH(t2.FCreateDate)='07'
    --where year(v1.FDate)IN ('2022') 
	--and year(t2.FCreateDate) in ('2022')
	--and month(v1.FDate)<='6'
    and v1.FTranType=21 