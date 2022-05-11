--select * from t_Organization where fname like '%格兰仕%'

DECLARE @Period char(6)
SET @Period='201101' --统计的年月


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

SELECT FItemName AS 产品,
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
    SELECT FItemName=CASE WHEN GROUPING(v4.FName)=1 THEN '<产品合计>' ELSE (v4.FName) END,
        --FBigTrade=CASE WHEN GROUPING(v5.FName)=1 THEN '<事业部合计>' ELSE (v5.FName) END,    
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
		and v2.FName like '%格兰仕%' 

    GROUP BY v4.FName  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FItemName,P_Money DESC