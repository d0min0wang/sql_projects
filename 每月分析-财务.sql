--create table [t_xySaleReporttest](FDate Datetime,FDepartment nvarchar(200),FbigTrade nvarchar(200),FCustomer nvarchar(200),FQty decimal(18,4),FAmount decimal(18,4))

--truncate table t_xySaleReporttest
--truncate table t_xySaleTongbi
--insert into [t_xySaleReporttest](FDate,FDepartment,FbigTrade,FCustomer,FQty,FAmount)
--select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
--SELECT v1.FSupplyID,v4.FShortNumber,v2.FNumber,v2.FName,
--	u1.FConsignPrice,
--	u1.FConsignAmount,
--		u1.FAuxQty,v3.FName,v2.F_110
		--,v2.F_111
--	,v5.FName AS FProdTrade,v4.FName AS FMidTrade,v3.FName AS FBigTrade 
--FROM ICStockBill v1 
--INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
--LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
--LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
--LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID
--WHERE v1.FTranType=21 And v1.FDate BETWEEN '2009-01-01' AND '2010-04-30' 

--select * from t_xySaleReporttest
use AIS20140921170539
DECLARE @Period char(6)
DECLARE @Department char(30)
SET @Period='202502' --统计的年月
--SET @Department='健康事业部'

--SELECT MONTH(@Period+'01')


--客户同比环比
DECLARE @Last_Period char(6),@Previous_Period char(6)
SELECT @Last_Period=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112),
 @Previous_Period=CONVERT(char(6),DATEADD(Month,-1,@Period+'01'),112)
 ;WITH tongbihuanbi
AS
(
    SELECT FDepartment,FCustName,FTrade,
        C_Money,
        L_Money,
        CL_Money=C_Money-L_Money,
        CL_Money_Rate=CASE
                WHEN L_Money=0 THEN '----'
                ELSE SUBSTRING('↓－↑',CAST(SIGN(C_Money-L_Money) as int)+2,1)
                    +CAST(CAST(ABS(C_Money-L_Money)*100/(CASE WHEN L_Money =0 THEN 1 ELSE L_Money END) as decimal(18,2)) as varchar)+'%'
            END,
        P_Money,
        CP_Money=C_Money-P_Money,
        CP_Money_Rate=CASE
                WHEN P_Money=0 THEN '----'
                ELSE SUBSTRING('↓－↑',CAST(SIGN(C_Money-P_Money) as int)+2,1)
                    +CAST(CAST(ABS(C_Money-P_Money)*100/P_Money as decimal(18,2)) as varchar)+'%'
            END,
        C_AuxQty,
        L_AuxQty,
        CL_AunQty=C_AuxQty-L_AuxQty,
        CL_AuxQty_Rate=CASE
                WHEN L_AuxQty=0 THEN '----'
                ELSE SUBSTRING('↓－↑',CAST(SIGN(C_AuxQty-L_AuxQty) as int)+2,1)
                    +CAST(CAST(ABS(C_AuxQty-L_AuxQty)*100/(CASE WHEN L_AuxQty =0 THEN 1 ELSE L_AuxQty END) as decimal(18,2)) as varchar)+'%'
            END,
        P_AuxQty,
        CP_AuxQty=C_AuxQty-P_AuxQty,
        CP_AuxQty_Rate=CASE
                WHEN P_AuxQty=0 THEN '----'
                ELSE SUBSTRING('↓－↑',CAST(SIGN(C_AuxQty-P_AuxQty) as int)+2,1)
                    +CAST(CAST(ABS(C_AuxQty-P_AuxQty)*100/P_AuxQty as decimal(18,2)) as varchar)+'%'
            END
    --into #tongbihuanbi
    FROM(
        SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
            FCustName=CASE WHEN GROUPING(v2.FName)=1 THEN '<事业部合计>' ELSE (v2.FName) END,
            FTrade=convert(varchar(10),min(v2.F_117)),    
            C_Money=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
            L_Money=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Last_Period THEN u1.FConsignAmount END),0),
            P_Money=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Previous_Period THEN u1.FConsignAmount END),0),
            C_AuxQty=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FAuxQty END),0),
            L_AuxQty=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Last_Period THEN u1.FAuxQty END),0),
            P_AuxQty=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Previous_Period THEN u1.FAuxQty END),0)
        --FROM t_xySaleReporttest
        --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
        FROM ICStockBill v1 
        INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
        LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
        LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
        LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID

        WHERE v1.FTranType=21 And
            CONVERT(char(6),v1.FDate,112) IN(@Last_Period,@Previous_Period,@Period)

        GROUP BY v3.FName,v2.FName  WITH ROLLUP	
        --ORDER BY u1.FConsignAmount
        --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
        )a
        --ORDER BY a.FDepartment,a.C_Money DESC
)

select 
	t1.FDepartment AS 事业部,
	t1.FCustName AS 客户名称,
	t2.FName AS 行业,
    C_Money AS 本年同期销售额,
    L_Money AS 去年同期销售额,
    CL_Money AS 销售额同比,
    CL_Money_Rate AS 销售额同比百分比,
	P_Money AS 上期销售额,
    CP_Money AS 销售额环比,
    CP_Money_Rate AS 销售额环比百分比,
	C_AuxQty AS 本年同期出货量,
    L_AuxQty AS 去年同期出货量,
    CL_AunQty AS 出货量同比,
    CL_AuxQty_Rate AS 出货量同比百分比,
	P_AuxQty AS 上期出货量,
    CP_AuxQty AS 出货量环比,
    CP_AuxQty_Rate AS 出货量环比百分比
from tongbihuanbi t1
left join t_Item t2 ON t1.FTrade=t2.FItemID
--WHERE t1.FDepartment=@Department
order by t1.FDepartment,C_Money desc

--drop table #tongbihuanbi


--年度累计销售额
DECLARE @Last_Year char(6)
SELECT @Last_Year=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112)
;WITH tongbihuanbi_year
AS
(
    SELECT FDepartment,FCustName,FTrade,
        C_Money,
        L_Money,
        CL_Money=C_Money-L_Money,
        CL_Money_Rate=CASE
                WHEN L_Money=0 THEN '----'
                ELSE SUBSTRING('↓－↑',CAST(SIGN(C_Money-L_Money) as int)+2,1)
                    +CAST(CAST(ABS(C_Money-L_Money)*100/(CASE WHEN L_Money =0 THEN 1 ELSE L_Money END) as decimal(10,2)) as varchar)+'%'
            END,
        C_AuxQty,
        L_AuxQty,
        CL_AunQty=C_AuxQty-L_AuxQty,
        CL_AuxQty_Rate=CASE
                WHEN L_AuxQty=0 THEN '----'
                ELSE SUBSTRING('↓－↑',CAST(SIGN(C_AuxQty-L_AuxQty) as int)+2,1)
                    +CAST(CAST(ABS(C_AuxQty-L_AuxQty)*100/(CASE WHEN L_AuxQty =0 THEN 1 ELSE L_AuxQty END) as decimal(10,2)) as varchar)+'%'
            END
    --into #tongbihuanbi_year
    FROM(
        SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
            FCustName=CASE WHEN GROUPING(v2.FName)=1 THEN '<事业部合计>' ELSE (v2.FName) END,
            FTrade=convert(varchar(10),min(v2.F_117)),    
            C_Money=ISNULL(SUM(CASE WHEN year(v1.FDate) =year(@Period+'01') and MONTH(v1.FDate) <=MONTH(@Period+'01') THEN u1.FConsignAmount END),0),
            L_Money=ISNULL(SUM(CASE WHEN year(v1.FDate) =year(@Last_Year+'01') and MONTH(v1.FDate) <=MONTH(@Last_Year+'01') THEN u1.FConsignAmount END),0),
            C_AuxQty=ISNULL(SUM(CASE WHEN year(v1.FDate) =year(@Period+'01') and MONTH(v1.FDate) <=MONTH(@Period+'01') THEN u1.FAuxQty END),0),
            L_AuxQty=ISNULL(SUM(CASE WHEN year(v1.FDate) =year(@Last_Year+'01') and MONTH(v1.FDate) <=MONTH(@Last_Year+'01') THEN u1.FAuxQty END),0)
        --FROM t_xySaleReporttest
        --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
        FROM ICStockBill v1 
        INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
        LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
        LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
        LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID

        WHERE v1.FTranType=21 
        GROUP BY v3.FName,v2.FName  WITH ROLLUP	
        --ORDER BY u1.FConsignAmount
        --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
        )a
        --ORDER BY a.FDepartment,a.C_Money DESC
)

select 
	t1.FDepartment AS 事业部,
	t1.FCustName AS 客户名称,
	t2.FName AS 行业,
    C_Money AS 本年同期累计销售额,
    L_Money AS 去年同期累计销售额,
    CL_Money AS 累计销售额同比,
    CL_Money_Rate AS 累计销售额同比百分比,
	C_AuxQty AS 本年同期累计出货量,
    L_AuxQty AS 去年同期累计出货量,
    CL_AunQty AS 出货量累计同比,
    CL_AuxQty_Rate AS 累计出货量同比百分比
from tongbihuanbi_year t1
left join t_Item t2 ON t1.FTrade=t2.FItemID
--WHERE t1.FDepartment=@Department
order by t1.FDepartment,C_Money desc

--drop table #tongbihuanbi_year

--产品数据
;WITH cte_Items
AS
(
    SELECT FDepartment=v3.FName,
            FItemName=t2.FNumber,
            C_Money=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
            L_Money=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Last_Period THEN u1.FConsignAmount END),0),
            C_AuxQty=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FAuxQty END),0),
            L_AuxQty=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Last_Period THEN u1.FAuxQty END),0)
        --FROM t_xySaleReporttest
        --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
        FROM ICStockBill v1 
        INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
        LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
        LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
        LEFT JOIN t_ICItem v4 ON u1.FItemID=v4.FItemID
        left join t_Item t2 on v4.fparentid=t2.fitemid
        LEFT JOIN t_Item t3 ON t2.FParentID=t3.FItemID
        LEFT JOIN t_Item t4 ON t3.FParentID=t4.FItemID
        where (t3.FNumber in ('90','91','92','93')
        or t4.FNumber in ('90','91','92','93'))
        AND v3.FItemID>0
        and v1.FTranType=21 And
            CONVERT(char(6),v1.FDate,112) IN(@Last_Period,@Previous_Period,@Period)

        GROUP BY v3.FName,t2.FNumber  WITH ROLLUP
)
SELECT FDepartment as '部门',
     FItemName as '产品系列',
     C_Money as '当月销售额',
     C_AuxQty as '当月出货数量',
     C_Money/nullif(C_AuxQty,0) AS '当月平均单价',        
     FORMAT(C_Money*2/(SELECT 
                SUM(C_Money) 
                FROM
                cte_Items 
                WHERE FDepartment = a.FDepartment),'P') AS '当月销售额占比',
    L_Money as '去年同期销售额',
    L_AuxQty as '去年同期出货数量',
    L_Money/nullif(L_AuxQty,0) as '去年同期平均单价',
    FORMAT(L_Money*2/(SELECT 
                SUM(L_Money) 
                FROM
                cte_Items 
                WHERE FDepartment = a.FDepartment),'P') as '去年同期销售额占比'
            
FROM cte_Items	a
ORDER BY FDepartment,C_Money DESC


--ORDER BY t2.FNumber
--        GROUP BY v3.FName,t2.FNumber  WITH ROLLUP


--SELECT * FROM t_TableDescription WHERE FDescription LIKE '%调拨%'