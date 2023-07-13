SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER   PROCEDURE [dbo].[p_xy_Industry_YoY]
	@PeriodYear int,
    @PeriodMonth int,
    @Department nvarchar(30)
--SET @Querytime='2011-02-28'
AS
SET NOCOUNT ON

--EXEC p_xy_Industry_YoY '2023','6','电气连接事业部'

--select * from t_xySaleReporttest
--DECLARE @Period char(6)
--DECLARE @Department char(30)
--SET @Period='202306' --统计的年月
--SET @Department='电气连接事业部'

--select DATEFROMPARTS(@PeriodYear,@PeriodMonth,'01')



--统计处理
DECLARE @Period nvarchar(6),@Last_Period nvarchar(6),@Previous_Period nvarchar(6)
SET @Period=FORMAT(@PeriodYear,'D4')+FORMAT(@PeriodMonth,'D2')
--SELECT @Period
set @Last_Period=FORMAT(@PeriodYear-1,'D4')+FORMAT(@PeriodMonth,'D2')
set @Previous_Period=FORMAT(@PeriodYear,'D4')+FORMAT(@PeriodMonth-1,'D2')

 ;WITH Origin
AS
(
    SELECT --FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
            FBigTrade=CASE WHEN GROUPING(v5.FName)=1 THEN '总计' ELSE (v5.FName) END,
            --FTrade=convert(varchar(10),min(v2.F_117)),    
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
        left join t_Item v5 ON v2.F_132=v5.FItemID

        WHERE v1.FTranType=21 And
            CONVERT(char(6),v1.FDate,112) IN(@Last_Period,@Previous_Period,@Period)
            AND v3.fname=@Department
        GROUP BY v5.FName  WITH ROLLUP	
        --ORDER BY u1.FConsignAmount
        --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
        
),

tongbihuanbi
AS
(
    SELECT FBigTrade,--FTrade,
        C_Money,
        L_Money,
        CL_Money=C_Money-L_Money,
        CL_Money_Rate=CASE
                WHEN L_Money=0 THEN '----'
                ELSE format((C_Money-L_Money)/(CASE WHEN L_Money =0 THEN 1 ELSE L_Money END) ,'P')
            END,
        P_Money,
        CP_Money=C_Money-P_Money,
        CP_Money_Rate=CASE
                WHEN P_Money=0 THEN '----'
                ELSE format((C_Money-P_Money)/P_Money,'P')
            END,
        C_AuxQty,
        L_AuxQty,
        CL_AunQty=C_AuxQty-L_AuxQty,
        CL_AuxQty_Rate=CASE
                WHEN L_AuxQty=0 THEN '----'
                ELSE format((C_AuxQty-L_AuxQty)/(CASE WHEN L_AuxQty =0 THEN 1 ELSE L_AuxQty END) ,'P')
            END,
        P_AuxQty,
        CP_AuxQty=C_AuxQty-P_AuxQty,
        CP_AuxQty_Rate=CASE
                WHEN P_AuxQty=0 THEN '----'
                ELSE format((C_AuxQty-P_AuxQty)/P_AuxQty,'P')
            END
    --into #tongbihuanbi
    FROM Origin
        --ORDER BY a.FDepartment,a.C_Money DESC
)

select 
	--t1.FDepartment AS 事业部,
	t1.FBigTrade AS 行业,
	--t2.FName AS 行业,
    P_Money AS 上月出库金额,
    L_Money AS 去年当月出库金额,
    C_Money AS 当月出库金额,
    format(C_Money*2/(select sum(C_Money) from tongbihuanbi),'P')  AS 占比,    
    --CP_Money AS 销售额环比,
    CP_Money_Rate AS 环比,
    --CL_Money AS 销售额同比,
    CL_Money_Rate AS 同比,
    P_AuxQty AS 上月出货量,
    L_AuxQty AS 去年当月出货量,
	C_AuxQty AS 当月出货量,
    --CP_AuxQty AS 出货量环比,
    CP_AuxQty_Rate AS 环比,
    --CL_AunQty AS 出货量同比,
    CL_AuxQty_Rate AS 同比
from tongbihuanbi t1
--left join t_Item t2 ON t1.FTrade=t2.FItemID
--WHERE t1.FDepartment='电气连接事业部'
order by C_Money desc

--select * from t_TableDescription where FTableName='t_Organization'

--SELECT * FROM t_FieldDescription where FTableID=49

--select f_132,* from t_Organization