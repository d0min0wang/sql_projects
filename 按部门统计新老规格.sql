use AIS20140921170539
DECLARE @Period char(6)
DECLARE @Department char(30)
SET @Period='202312' --统计的年月
SET @Department='电气连接事业部'

--SELECT MONTH(@Period+'01')

--年度累计销售额
DECLARE @Last_Year char(6),@Previous_Period char(6)
SELECT @Last_Year=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112)
    ,@Previous_Period=CONVERT(char(6),DATEADD(Month,-1,@Period+'01'),112)
;WITH basicTable
as
(
SELECT '新增规格数(个)' AS fname,
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
LEFT JOIN t_Department t3 on t1.FSource=t3.FItemID
WHERE YEAR(t2.FCreateDate) IN (year(@Period+'01') ,year(@Last_Year+'01'))
AND (t6.FNumber in ('90','91','92','93') OR t5.FNumber in ('90','91','92','93') OR t4.FNumber in ('90','91','92','93'))
AND t3.FName IN (@Department)
union ALL
--累计新增规格销售额
SELECT  '累计新增规格销售额(元)' AS fname,
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
	AND t4.FName IN (@Department)
	and v1.FTranType=21 AND (v1.FROB=1 AND  v1.FCancellation = 0)
union ALL
--累计新增规格出货量
SELECT  '累计新增规格出货量(K)' AS fname,
		[thisYear]=ISNULL(SUM(CASE WHEN
                                (year(t2.FCreateDate) =year(@Period+'01') and MONTH(t2.FCreateDate) <=MONTH(@Period+'01')) and
                                (year(v1.FDate) =year(@Period+'01') and MONTH(v1.FDate) <=MONTH(@Period+'01'))
                                  then u1.FAuxQty END),0),
		[lastYear]=ISNULL(SUM(CASE WHEN
                                (year(t2.FCreateDate) =year(@Last_Year+'01') and MONTH(t2.FCreateDate) <=MONTH(@Last_Year+'01')) and
                                (year(v1.FDate) =year(@Last_Year+'01') and MONTH(v1.FDate) <=MONTH(@Last_Year+'01'))
                                  then u1.fauxqty END),0)
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
	AND t4.FName IN (@Department)
	and v1.FTranType=21 AND (v1.FROB=1 AND  v1.FCancellation = 0)
)
SELECT fname AS 项目,
        thisYear AS 本年累计,
        lastYear AS 去年累计,
        thisYear-lastYear AS 累计同比增长,
        CASE
                WHEN lastYear=0 THEN '----'
                ELSE SUBSTRING('↓－↑',CAST(SIGN(thisYear-lastYear) as int)+2,1)
                    +CAST(CAST(ABS(thisYear-lastYear)*100/(CASE WHEN lastYear =0 THEN 1 ELSE lastYear END) as decimal(10,2)) as varchar)+'%'
            END AS 累计同比增长率
    --into #tongbihuanbi
    FROM basicTable

--全部规格数量
SELECT  '全部规格数量' AS fname,
		[thisYear]=ISNULL(count (distinct CASE WHEN
                                (year(v1.FDate) =year(@Period+'01') )
                                  then u1.FItemID END),0),
		[lastYear]=ISNULL(count(distinct CASE WHEN
                                (year(v1.FDate) =year(@Last_Year+'01') )
                                  then u1.FItemID END),0)
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
    --where year(v1.FDate)IN ('2022') 
	--and year(t2.FCreateDate) in ('2022')
	--and month(v1.FDate)<='6'
	AND t4.FName IN (@Department)
	and v1.FTranType=21 AND (v1.FROB=1 AND  v1.FCancellation = 0)

    --全部规格销售额
SELECT  '全部规格销售额(元)' AS fname,
		[thisYear]=ISNULL(SUM(CASE WHEN
                                (year(v1.FDate) =year(@Period+'01') )
                                  then u1.FConsignAmount END),0),
		[lastYear]=ISNULL(SUM(CASE WHEN
                                (year(v1.FDate) =year(@Last_Year+'01') )
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
    --where year(v1.FDate)IN ('2022') 
	--and year(t2.FCreateDate) in ('2022')
	--and month(v1.FDate)<='6'
	AND t4.FName IN (@Department)
	and v1.FTranType=21 AND (v1.FROB=1 AND  v1.FCancellation = 0)


    --全部规格销售额
SELECT  '全部规格出货量(K)' AS fname,
		[thisYear]=ISNULL(SUM(CASE WHEN
                                (year(v1.FDate) =year(@Period+'01') )
                                  then u1.FAuxQty END),0),
		[lastYear]=ISNULL(SUM(CASE WHEN
                                (year(v1.FDate) =year(@Last_Year+'01') )
                                  then u1.FAuxQty END),0)
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
    --where year(v1.FDate)IN ('2022') 
	--and year(t2.FCreateDate) in ('2022')
	--and month(v1.FDate)<='6'
	AND t4.FName IN (@Department)
	and v1.FTranType=21 AND (v1.FROB=1 AND  v1.FCancellation = 0)


Select COUNT(distinct u1.FItemID) 
 from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
 INNER JOIN t_ICItem t14 ON     u1.FItemID = t14.FItemID   AND t14.FItemID <>0 
 LEFT OUTER JOIN t_Department t105 ON     v1.FDeptID = t105.FItemID   AND t105.FItemID <>0 
 where 1=1 AND (     
v1.Fdate >=  '2023-01-01' 
  AND  
v1.Fdate <=  '2023-12-31' 
  AND  
t105.FName = '健康事业部'
)  AND (v1.FTranType=21 AND (v1.FROB=1 AND  v1.FCancellation = 0))
