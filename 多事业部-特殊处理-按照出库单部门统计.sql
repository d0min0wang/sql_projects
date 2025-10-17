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
SET @Period='202508' --统计的年月
SET @Department='健康事业部'

--SELECT MONTH(@Period+'01')

--年度累计销售额
DECLARE @Last_Year char(6)
SELECT @Last_Year=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112)
;WITH tongbihuanbi_year
AS
(
    SELECT FDepartment,FBigTrade,FTrade,
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
            FBigTrade=CASE WHEN GROUPING(v2.F_118)=1 THEN '<事业部合计>' ELSE (v2.F_118) END,
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
        LEFT JOIN t_Item v3 ON v1.FDeptID=v3.FItemID
        --LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
        LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID

        WHERE v1.FTranType=21 
        GROUP BY v3.FName,v2.F_118  WITH ROLLUP	
        --ORDER BY u1.FConsignAmount
        --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
        )a
        --ORDER BY a.FDepartment,a.C_Money DESC
)

select 
	t1.FDepartment AS 事业部,
	t1.FBigTrade AS 方普行业结构,
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
WHERE t1.FDepartment=@Department
order by t1.FDepartment,C_Money desc

--drop table #tongbihuanbi_year


--统计处理
DECLARE @Last_Period char(6),@Previous_Period char(6)
SELECT @Last_Period=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112),
 @Previous_Period=CONVERT(char(6),DATEADD(Month,-1,@Period+'01'),112)
 ;WITH tongbihuanbi
AS
(
    SELECT FDepartment,FBigTrade,FTrade,
        C_Money,
        L_Money,
        CL_Money=C_Money-L_Money,
        CL_Money_Rate=CASE
                WHEN L_Money=0 THEN '----'
                ELSE SUBSTRING('↓－↑',CAST(SIGN(C_Money-L_Money) as int)+2,1)
                    +CAST(CAST(ABS(C_Money-L_Money)*100/(CASE WHEN L_Money =0 THEN 1 ELSE L_Money END) as decimal(10,2)) as varchar)+'%'
            END,
        P_Money,
        CP_Money=C_Money-P_Money,
        CP_Money_Rate=CASE
                WHEN P_Money=0 THEN '----'
                ELSE SUBSTRING('↓－↑',CAST(SIGN(C_Money-P_Money) as int)+2,1)
                    +CAST(CAST(ABS(C_Money-P_Money)*100/P_Money as decimal(10,2)) as varchar)+'%'
            END,
        C_AuxQty,
        L_AuxQty,
        CL_AunQty=C_AuxQty-L_AuxQty,
        CL_AuxQty_Rate=CASE
                WHEN L_AuxQty=0 THEN '----'
                ELSE SUBSTRING('↓－↑',CAST(SIGN(C_AuxQty-L_AuxQty) as int)+2,1)
                    +CAST(CAST(ABS(C_AuxQty-L_AuxQty)*100/(CASE WHEN L_AuxQty =0 THEN 1 ELSE L_AuxQty END) as decimal(10,2)) as varchar)+'%'
            END,
        P_AuxQty,
        CP_AuxQty=C_AuxQty-P_AuxQty,
        CP_AuxQty_Rate=CASE
                WHEN P_AuxQty=0 THEN '----'
                ELSE SUBSTRING('↓－↑',CAST(SIGN(C_AuxQty-P_AuxQty) as int)+2,1)
                    +CAST(CAST(ABS(C_AuxQty-P_AuxQty)*100/P_AuxQty as decimal(10,2)) as varchar)+'%'
            END
    --into #tongbihuanbi
    FROM(
        SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
            FBigTrade=CASE WHEN GROUPING(v2.F_118)=1 THEN '<事业部合计>' ELSE (v2.F_118) END,
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
        LEFT JOIN t_Item v3 ON v1.FDeptID=v3.FItemID
        --LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
        LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID

        WHERE v1.FTranType=21 And
            CONVERT(char(6),v1.FDate,112) IN(@Last_Period,@Previous_Period,@Period)

        GROUP BY v3.FName,v2.F_118  WITH ROLLUP	
        --ORDER BY u1.FConsignAmount
        --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
        )a
        --ORDER BY a.FDepartment,a.C_Money DESC
)

select 
	t1.FDepartment AS 事业部,
	t1.FBigTrade AS 方普行业结构,
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
WHERE t1.FDepartment=@Department
order by t1.FDepartment,C_Money desc

--drop table #tongbihuanbi



--客户同比环比
--DECLARE @Last_Period char(6),@Previous_Period char(6)
SELECT @Last_Period=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112),
 @Previous_Period=CONVERT(char(6),DATEADD(Month,-1,@Period+'01'),112)
 ;WITH tongbihuanbi
AS
(
    SELECT FDepartment,FCustName,FEmp,FTrade,
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
            FEmp=CASE WHEN GROUPING(v2.FName)=1 THEN null ELSE convert(varchar(10),min(v2.Femployee)) end,    
            FTrade=CASE WHEN GROUPING(v2.FName)=1 THEN null ELSE convert(varchar(10),min(v2.F_117)) end,    
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
        LEFT JOIN t_Item v3 ON v1.FDeptID=v3.FItemID
        --LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
        LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID
        --LEFT join t_Emp v5 ON v2.Femployee=v5.FItemID

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
    t3.FName as 业务员,
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
LEFT JOIN t_Emp t3 ON t1.femp=t3.FItemID
WHERE t1.FDepartment=@Department
order by t1.FDepartment,C_Money desc

--drop table #tongbihuanbi


--SELECT FDepartment AS 事业部,FBigTrade AS 行业,FTrade,
--    C_Money AS 本年同期销售额,
--    L_Money AS 去年同期销售额,
--    销售额同比=C_Money-L_Money,
--    销售额同比百分比=CASE
--            WHEN L_Money=0 THEN '----'
--            ELSE SUBSTRING('↓－↑',CAST(SIGN(C_Money-L_Money) as int)+2,1)
--                +CAST(CAST(ABS(C_Money-L_Money)*100/(CASE WHEN L_Money =0 THEN 1 ELSE L_Money END) as decimal(10,2)) as varchar)+'%'
--        END,
--    P_Money AS 上期销售额,
--    销售额环比=C_Money-P_Money,
--    销售额环比百分比=CASE
--            WHEN P_Money=0 THEN '----'
--            ELSE SUBSTRING('↓－↑',CAST(SIGN(C_Money-P_Money) as int)+2,1)
--                +CAST(CAST(ABS(C_Money-P_Money)*100/P_Money as decimal(10,2)) as varchar)+'%'
--        END,
--    C_AuxQty AS 本年同期出货量,
--    L_AuxQty AS 去年同期出货量,
--    出货量同比=C_AuxQty-L_AuxQty,
--    出货量同比百分比=CASE
--            WHEN L_AuxQty=0 THEN '----'
--            ELSE SUBSTRING('↓－↑',CAST(SIGN(C_AuxQty-L_AuxQty) as int)+2,1)
--                +CAST(CAST(ABS(C_AuxQty-L_AuxQty)*100/(CASE WHEN L_AuxQty =0 THEN 1 ELSE L_AuxQty END) as decimal(10,2)) as varchar)+'%'
--        END,
--    P_AuxQty AS 上期出货量,
--    出货量环比=C_AuxQty-P_AuxQty,
--    出货量环比百分比=CASE


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
        P_Money_1=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '1' THEN u1.FConsignAmount END),0),
        P_Money_2=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '2' THEN u1.FConsignAmount END),0),
        P_Money_3=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '3' THEN u1.FConsignAmount END),0),
        P_Money_4=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '4' THEN u1.FConsignAmount END),0),
        P_Money_5=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '5' THEN u1.FConsignAmount END),0),
        P_Money_6=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '6' THEN u1.FConsignAmount END),0),
        P_Money_7=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '7' THEN u1.FConsignAmount END),0),
        P_Money_8=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '8' THEN u1.FConsignAmount END),0),
        P_Money_9=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '9' THEN u1.FConsignAmount END),0),
        P_Money_10=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '10' THEN u1.FConsignAmount END),0),
        P_Money_11=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '11' THEN u1.FConsignAmount END),0),
        P_Money_12=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '12' THEN u1.FConsignAmount END),0),
        P_AuxQty_1=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '1' THEN u1.FAuxQty END),0),
        P_AuxQty_2=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '2' THEN u1.FAuxQty END),0),
        P_AuxQty_3=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '3' THEN u1.FAuxQty END),0),
        P_AuxQty_4=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '4' THEN u1.FAuxQty END),0),
        P_AuxQty_5=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '5' THEN u1.FAuxQty END),0),
        P_AuxQty_6=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '6' THEN u1.FAuxQty END),0),
        P_AuxQty_7=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '7' THEN u1.FAuxQty END),0),
        P_AuxQty_8=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '8' THEN u1.FAuxQty END),0),
        P_AuxQty_9=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '9' THEN u1.FAuxQty END),0),
        P_AuxQty_10=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '10' THEN u1.FAuxQty END),0),
        P_AuxQty_11=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '11' THEN u1.FAuxQty END),0),
        P_AuxQty_12=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '12' THEN u1.FAuxQty END),0)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v1.FDeptID=v3.FItemID
        --LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID
	left join t_Item v5 ON v2.F_117=v5.FItemID
    WHERE v1.FTranType=21 And v1.FCheckerID>0 AND
		year(v1.FDate) =left(@Period,4)
		--and month(v1.FDate)<month(getdate()) 
		and v3.FName=@Department

    GROUP BY v3.FName,v5.FName  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FDepartment,P_Money DESC
	

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
		[年销售额]=ISNULL(SUM(CASE year(v1.FDate) when left(@Period,4) then u1.FConsignAmount END),0),
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
		[年出货量]=ISNULL(SUM(CASE year(v1.FDate) when left(@Period,4) then u1.FAuxQty END),0),
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
	where year(v1.FDate)=left(@Period,4)
	--and month(v1.FDate)<='2'
	
	and v1.FTranType=21 
	group by v1.FSupplyID) t1

LEFT JOIN t_Organization v2 ON t1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v1.FDeptID=v3.FItemID
        --LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
LEFT JOIN t_SubMessage v7 ON v2.FRegionID=v7.FInterID
LEFT JOIN t_Emp v8 ON v2.Femployee=v8.FItemID
where v3.FName=@Department
----where v4.FName='微波炉'
--and v2.FName like '%顺科新能源%'
order by [年销售额] desc


--SELECT * FROM t_FieldDescription WHERE FDescription LIKE '%配套%'



--年度累计销售额
--DECLARE @Last_Year char(6)
SELECT @Last_Year=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112)
;WITH tongbihuanbi_year
AS
(
    SELECT FDepartment,FCustName,FEmp,FTrade,
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
            FEmp=CASE WHEN GROUPING(v2.FName)=1 THEN null ELSE convert(varchar(10),min(v2.Femployee)) end,    
            FTrade=CASE WHEN GROUPING(v2.FName)=1 THEN null ELSE convert(varchar(10),min(v2.F_117)) end,    
            C_Money=ISNULL(SUM(CASE WHEN year(v1.FDate) =year(@Period+'01') and MONTH(v1.FDate) <=MONTH(@Period+'01') THEN u1.FConsignAmount END),0),
            L_Money=ISNULL(SUM(CASE WHEN year(v1.FDate) =year(@Last_Year+'01') and MONTH(v1.FDate) <=MONTH(@Last_Year+'01') THEN u1.FConsignAmount END),0),
            C_AuxQty=ISNULL(SUM(CASE WHEN year(v1.FDate) =year(@Period+'01') and MONTH(v1.FDate) <=MONTH(@Period+'01') THEN u1.FAuxQty END),0),
            L_AuxQty=ISNULL(SUM(CASE WHEN year(v1.FDate) =year(@Last_Year+'01') and MONTH(v1.FDate) <=MONTH(@Last_Year+'01') THEN u1.FAuxQty END),0)
        --FROM t_xySaleReporttest
        --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
        FROM ICStockBill v1 
        INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
        LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
        LEFT JOIN t_Item v3 ON v1.FDeptID=v3.FItemID
        --LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
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
    t3.FName as 业务员,
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
LEFT JOIN t_Emp t3 ON t1.femp=t3.FItemID
WHERE t1.FDepartment=@Department
order by t1.FDepartment,C_Money desc

--drop table #tongbihuanbi_year

