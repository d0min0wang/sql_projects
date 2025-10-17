use AIS20140921170539
--累计新增规格，并发生销售额
IF OBJECT_ID('tempdb.dbo.#temp1','U') IS NOT NULL DROP TABLE dbo.#temp1;
IF OBJECT_ID('tempdb.dbo.#temp2','U') IS NOT NULL DROP TABLE dbo.#temp2;

DECLARE @sql_sum AS NVARCHAR(max)
DECLARE @sql AS NVARCHAR(max)
--set @sql_sum=(select ',SUM(case when fdepartment='+quotename(FName,'''')+' then FConsignAmount end) AS '+quotename(fname)+'' 
--        from t_Department WHERE FParentID=75 AND FName NOT in ('物流部') for xml path(''))

--SET @sql='select fitemname as [产品名称],min(FName) as [新增部门] '+@sql_sum+' FROM #temp1 GROUP by fitemname'

--select @sql
--SELECT * FROM t_Department WHERE FParentID=75
 

--AND (t6.FNumber in ('90','91','92','93') OR t5.FNumber in ('90','91','92','93') OR t4.FNumber in ('90','91','92','93'))
--AND t3.FName IN ('电气连接国内事业部','电气连接事业部','医疗事业部','食品设备事业部','健康事业部','通信事业部','新能源事业部')

SELECT  
    t1.FName AS fitemname,
    t6.FName,
    t4.fname AS Fdepartment,
    t5.fname as Ftrade,
    u1.FConsignAmount
into #temp1
FROM ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
LEFT JOIN t_ICItem t1 ON u1.FItemID=t1.FItemID
LEFT JOIN t_BaseProperty t2 on	 t1.FItemID=t2.FItemID AND t2.FTypeID=3 
LEFT JOIN t_Organization t3 ON v1.FSupplyID=t3.FItemID
LEFT JOIN t_Department t4 ON t3.Fdepartment=t4.FItemID
left join t_Item t5 ON t3.F_117=t5.FItemID
LEFT JOIN t_Department t6 ON t1.FSource=t6.FItemID
WHERE YEAR(v1.FDate) ='2025' AND MONTH(v1.FDate)<='06'
and 
YEAR(t2.FCreateDate) in ('2025') AND MONTH(t2.FCreateDate)='06'
--AND (t6.FNumber in ('90','91','92','93') OR t5.FNumber in ('90','91','92','93') OR t4.FNumber in ('90','91','92','93'))
--where year(v1.FDate)IN ('2022') 
--and year(t2.FCreateDate) in ('2022')
--and month(v1.FDate)<='6'
and v1.FTranType=21 AND (v1.FROB=1 AND  v1.FCancellation = 0)

SELECT distinct Fdepartment into #temp2 FROM #temp1

set @sql_sum=(select ',SUM(case when fdepartment='+quotename(fdepartment,'''')+' then FConsignAmount end) AS '+quotename(fdepartment)+'' 
        from #temp2 for xml path(''))

SET @sql='select fitemname as [产品名称],min(FName) as [新增部门] '+@sql_sum+' FROM #temp1 GROUP by fitemname order  by fitemname'

--SELECT distinct Fdepartment FROM #temp1

exec (@sql)

DROP TABLE #temp1
DROP TABLE #temp2


