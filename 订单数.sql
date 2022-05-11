DECLARE @Period char(6)
SET @Period='201004' --统计的年月


--统计处理
DECLARE @Last_Period char(6),@Previous_Period char(6)
SELECT @Last_Period=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112),
 @Previous_Period=CONVERT(char(6),DATEADD(Month,-1,@Period+'01'),112)
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
		CONVERT(char(6),FDate,112) IN(@Last_Period,@Previous_Period,@Period)

    GROUP BY v3.FName,v2.F_110  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
LEFT JOIN 
(SELECT FDepartment AS 事业部,FBigTrade AS 行业,
    C_BillCount AS 本年同期订单数,
    L_BillCount AS 去年同期订单数,
    订单数同比=C_BillCount-L_BillCount,
    订单数同比百分比=CASE
            WHEN L_BillCount=0 THEN '----'
            ELSE SUBSTRING('↓－↑',CAST(SIGN(C_BillCount-L_BillCount) as int)+2,1)
                +CAST(CAST(ABS(C_BillCount-L_BillCount)*100/(CASE WHEN L_BillCount =0 THEN 1 ELSE L_BillCount END) as decimal(10,2)) as varchar)+'%'
        END,
    P_BillCount AS 上期订单数,
    订单数环比=C_BillCount-P_BillCount,
    订单数环比百分比=CASE
            WHEN P_BillCount=0 THEN '----'
            ELSE SUBSTRING('↓－↑',CAST(SIGN(C_BillCount-P_BillCount) as int)+2,1)
                +CAST(CAST(ABS(C_BillCount-P_BillCount)*100/P_BillCount as decimal(10,2)) as varchar)+'%'
        END
FROM(
	SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
		FBigTrade=CASE WHEN GROUPING(v2.F_110)=1 THEN '<事业部合计>' ELSE (v2.F_110) END,    
		C_BillCount=ISNULL(COUNT(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN v1.FBillNo END),0),
		L_BillCount=ISNULL(COUNT(CASE CONVERT(char(6),v1.FDate,112) WHEN @Last_Period THEN v1.FBillNo END),0),
		P_BillCount=ISNULL(COUNT(CASE CONVERT(char(6),v1.FDate,112) WHEN @Previous_Period THEN v1.FBillNo END),0)
	from seorder v1
	LEFT JOIN t_Organization v2 ON v1.FCustID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	WHERE CONVERT(char(6),FDate,112) IN(@Last_Period,@Previous_Period,@Period)
	GROUP BY v3.FName,v2.F_110  WITH ROLLUP	)c)b
	
ON a.FDepartment=b.FDepartment and a.FBigTrade=b.FBigTrade


select t1.fbillno,t1.fdate,t2.forderinterid from icstockbill t1
left join icstockbillentry t2 on t1.finterid=t2.finterid where t1.ftrantype=21

select * from t_tabledescription where fdescription like '%出入%'

select * from t_fielddescription where ftableid=210009

