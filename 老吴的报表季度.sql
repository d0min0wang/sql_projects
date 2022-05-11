DECLARE @Period char(5)
SET @Period='20101' --统计的季度
--SELECT CASE RIGHT(@Period,1) WHEN '1' THEN CAST(CAST(@Period AS int)-7 as varchar)
--							ELSE CAST(CAST(@Period AS int)-1 as varchar) END

--统计处理
DECLARE @Last_Period char(5),@Previous_Period char(5)
SELECT  @Last_Period=CAST(CAST(@Period AS int)-10 as varchar),
		@Previous_Period=CASE RIGHT(@Period,1) WHEN '1' THEN CAST(CAST(@Period AS int)-7 as varchar) 
							ELSE CAST(CAST(@Period AS int)-1 as varchar) END
SELECT FDepartment AS 事业部,FBigTrade AS 行业,
    C_Money AS 本年同期销售额,
    L_Money AS 去年同期销售额,
    销售额同比=C_Money-L_Money,
    销售额同比百分比=CASE
            WHEN L_Money=0 THEN '----'
            ELSE SUBSTRING('↓－↑',CAST(SIGN(C_Money-L_Money) as int)+2,1)
                +CAST(CAST(ABS(C_Money-L_Money)*100/(CASE WHEN L_Money =0 THEN 1 ELSE L_Money END) as decimal(10,2)) as varchar)+'%'
        END,
    P_Money AS 上期销售额,
    销售额环比=C_Money-P_Money,
    销售额环比百分比=CASE
            WHEN P_Money=0 THEN '----'
            ELSE SUBSTRING('↓－↑',CAST(SIGN(C_Money-P_Money) as int)+2,1)
                +CAST(CAST(ABS(C_Money-P_Money)*100/P_Money as decimal(10,2)) as varchar)+'%'
        END,
    C_AuxQty AS 本年同期出货量,
    L_AuxQty AS 去年同期出货量,
    出货量同比=C_AuxQty-L_AuxQty,
    出货量同比百分比=CASE
            WHEN L_AuxQty=0 THEN '----'
            ELSE SUBSTRING('↓－↑',CAST(SIGN(C_AuxQty-L_AuxQty) as int)+2,1)
                +CAST(CAST(ABS(C_AuxQty-L_AuxQty)*100/(CASE WHEN L_AuxQty =0 THEN 1 ELSE L_AuxQty END) as decimal(10,2)) as varchar)+'%'
        END,
    P_AuxQty AS 上期出货量,
    出货量环比=C_AuxQty-P_AuxQty,
    出货量环比百分比=CASE
            WHEN P_AuxQty=0 THEN '----'
            ELSE SUBSTRING('↓－↑',CAST(SIGN(C_AuxQty-P_AuxQty) as int)+2,1)
                +CAST(CAST(ABS(C_AuxQty-P_AuxQty)*100/P_AuxQty as decimal(10,2)) as varchar)+'%'
        END
FROM(
    SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
        FBigTrade=CASE WHEN GROUPING(v2.F_110)=1 THEN '<事业部合计>' ELSE (v2.F_110) END,    
        C_Money=ISNULL(SUM(CASE CAST(DATEPART(year,v1.FDate) AS varchar)+CAST(DATEPART(quarter,v1.FDate) AS varchar) WHEN @Period THEN u1.FConsignAmount END),0),
        L_Money=ISNULL(SUM(CASE CAST(DATEPART(year,v1.FDate) AS varchar)+CAST(DATEPART(quarter,v1.FDate) AS varchar) WHEN @Last_Period THEN u1.FConsignAmount END),0),
        P_Money=ISNULL(SUM(CASE CAST(DATEPART(year,v1.FDate) AS varchar)+CAST(DATEPART(quarter,v1.FDate) AS varchar) WHEN @Previous_Period THEN u1.FConsignAmount END),0),
        C_AuxQty=ISNULL(SUM(CASE CAST(DATEPART(year,v1.FDate) AS varchar)+CAST(DATEPART(quarter,v1.FDate) AS varchar) WHEN @Period THEN u1.FAuxQty END),0),
        L_AuxQty=ISNULL(SUM(CASE CAST(DATEPART(year,v1.FDate) AS varchar)+CAST(DATEPART(quarter,v1.FDate) AS varchar) WHEN @Last_Period THEN u1.FAuxQty END),0),
        P_AuxQty=ISNULL(SUM(CASE CAST(DATEPART(year,v1.FDate) AS varchar)+CAST(DATEPART(quarter,v1.FDate) AS varchar) WHEN @Previous_Period THEN u1.FAuxQty END),0)

    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID

    WHERE v1.FTranType=21 

    GROUP BY v3.FName,v2.F_110  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FDepartment,a.C_Money DESC
	
	
   --SELECT   CAST(DATEPART(year,GETDATE()) AS varchar)+CAST(DATEPART(quarter,GETDATE()) AS varchar)
   --select CAST(DATEPART(year,v1.FDate) AS varchar)+CAST(DATEPART(quarter,v1.FDate) AS varchar)