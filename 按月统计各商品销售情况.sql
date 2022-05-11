SELECT tt1.FBigTrade AS '大行业',
    tt1.FMidTrade AS '中行业',
    tt2.FName AS '产品',
    tt1.FDepartment AS '部门',
    tt1.FCustName AS '客户',
    tt2.FPlanPrice AS '计划单价',
    tt1.P_Money_1 AS '1月销售金额',
    tt1.P_Price_1 AS '1月销售单价',
    tt1.P_AuxQty_1 AS '1月销售数量',
    tt1.P_Money_2 AS '2月销售金额',
    tt1.P_Price_2 AS '2月销售单价',
    tt1.P_AuxQty_2 AS '2月销售数量',
    tt1.P_Money_3 AS '3月销售金额',
    tt1.P_Price_3 AS '3月销售单价',
    tt1.P_AuxQty_3 AS '3月销售数量',
    tt1.P_Money_4 AS '4月销售金额',
    tt1.P_Price_4 AS '4月销售单价',
    tt1.P_AuxQty_4 AS '4月销售数量',
    tt1.P_Money_5 AS '5月销售金额',
    tt1.P_Price_5 AS '5月销售单价',
    tt1.P_AuxQty_5 AS '5月销售数量',
    tt1.P_Money_6 AS '6月销售金额',
    tt1.P_Price_6 AS '6月销售单价',
    tt1.P_AuxQty_6 AS '6月销售数量',
    tt1.P_Money_7 AS '7月销售金额',
    tt1.P_Price_7 AS '7月销售单价',
    tt1.P_AuxQty_7 AS '7月销售数量',
    tt1.P_Money_8 AS '8月销售金额',
    tt1.P_Price_8 AS '8月销售单价',
    tt1.P_AuxQty_8 AS '8月销售数量',
    tt1.P_Money_9 AS '9月销售金额',
    tt1.P_Price_9 AS '9月销售单价',
    tt1.P_AuxQty_9 AS '9月销售数量',
    tt1.P_Money_10 AS '10月销售金额',
    tt1.P_Price_10 AS '10月销售单价',
    tt1.P_AuxQty_10 AS '10月销售数量',
    tt1.P_Money_11 AS '11月销售金额',
    tt1.P_Price_11 AS '11月销售单价',
    tt1.P_AuxQty_11 AS '11月销售数量',
    tt1.P_Money_12 AS '12月销售金额',
    tt1.P_Price_12 AS '12月销售单价',
    tt1.P_AuxQty_12 AS '12月销售数量'
FROM
(SELECT  v2.F_110 AS FBigTrade,
        v5.FName AS FMidTrade,--中行业
        u1.FItemID AS FProductID,
        --v2.Fdepartment,
        v3.FName AS FDepartment,
        v2.FName AS FCustName,
        --v4.fplanprice,
        P_Money_1=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '1' THEN u1.FConsignAmount END),0),
        P_Price_1=ISNULL(AVG(CASE MONTH(v1.FDate) WHEN '1' THEN u1.FConsignPrice END),0),
        P_AuxQty_1=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '1' THEN u1.FAuxQty END),0),
        P_Money_2=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '2' THEN u1.FConsignAmount END),0),
        P_Price_2=ISNULL(AVG(CASE MONTH(v1.FDate) WHEN '2' THEN u1.FConsignPrice END),0),
        P_AuxQty_2=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '2' THEN u1.FAuxQty END),0),
        P_Money_3=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '3' THEN u1.FConsignAmount END),0),
        P_Price_3=ISNULL(AVG(CASE MONTH(v1.FDate) WHEN '3' THEN u1.FConsignPrice END),0),
        P_AuxQty_3=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '3' THEN u1.FAuxQty END),0),
        P_Money_4=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '4' THEN u1.FConsignAmount END),0),
        P_Price_4=ISNULL(AVG(CASE MONTH(v1.FDate) WHEN '4' THEN u1.FConsignPrice END),0),
        P_AuxQty_4=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '4' THEN u1.FAuxQty END),0),
        P_Money_5=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '5' THEN u1.FConsignAmount END),0),
        P_Price_5=ISNULL(AVG(CASE MONTH(v1.FDate) WHEN '5' THEN u1.FConsignPrice END),0),
        P_AuxQty_5=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '5' THEN u1.FAuxQty END),0),
        P_Money_6=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '6' THEN u1.FConsignAmount END),0),
        P_Price_6=ISNULL(AVG(CASE MONTH(v1.FDate) WHEN '6' THEN u1.FConsignPrice END),0),
        P_AuxQty_6=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '6' THEN u1.FAuxQty END),0),
        P_Money_7=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '7' THEN u1.FConsignAmount END),0),
        P_Price_7=ISNULL(AVG(CASE MONTH(v1.FDate) WHEN '7' THEN u1.FConsignPrice END),0),
        P_AuxQty_7=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '7' THEN u1.FAuxQty END),0),
        P_Money_8=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '8' THEN u1.FConsignAmount END),0),
        P_Price_8=ISNULL(AVG(CASE MONTH(v1.FDate) WHEN '8' THEN u1.FConsignPrice END),0),
        P_AuxQty_8=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '8' THEN u1.FAuxQty END),0),
        P_Money_9=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '9' THEN u1.FConsignAmount END),0),
        P_Price_9=ISNULL(AVG(CASE MONTH(v1.FDate) WHEN '9' THEN u1.FConsignPrice END),0),
        P_AuxQty_9=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '9' THEN u1.FAuxQty END),0),
        P_Money_10=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '10' THEN u1.FConsignAmount END),0),
        P_Price_10=ISNULL(AVG(CASE MONTH(v1.FDate) WHEN '10' THEN u1.FConsignPrice END),0),
        P_AuxQty_10=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '10' THEN u1.FAuxQty END),0),
        P_Money_11=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '11' THEN u1.FConsignAmount END),0),
        P_Price_11=ISNULL(AVG(CASE MONTH(v1.FDate) WHEN '11' THEN u1.FConsignPrice END),0),
        P_AuxQty_11=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '11' THEN u1.FAuxQty END),0),
        P_Money_12=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '12' THEN u1.FConsignAmount END),0),
        P_Price_12=ISNULL(AVG(CASE MONTH(v1.FDate) WHEN '12' THEN u1.FConsignPrice END),0),
        P_AuxQty_12=ISNULL(SUM(CASE MONTH(v1.FDate) WHEN '12' THEN u1.FAuxQty END),0)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Department v3 ON v2.Fdepartment=v3.FItemID
	--LEFT JOIN t_ICItem v4 ON u1.FItemID=v4.FItemID
	left join t_Item v5 ON v5.FItemID=(case when v2.Fdepartment=89 or v2.Fdepartment=38755 then v2.F_132 else v2.F_117 end)
    --LEFT JOIN t_Item v6 ON v6.FItemID=v2.F_110
    WHERE v1.FTranType=21 And v1.FCheckerID>0 AND
		year(v1.FDate) ='2021'
    GROUP BY v2.F_110,v5.FName,u1.FItemID,v3.FName,v2.FName
)tt1
LEFT JOIN t_ICItem tt2 ON tt1.FProductID=tt2.FItemID


SELECT  v2.F_110 AS FBigTrade,
        v5.FName AS FMidTrade,--中行业
        v4.FName AS FProductID,
        --v2.Fdepartment,
        v3.FName AS FDepartment,
        v2.FName AS FCustName,
        --v4.fplanprice,
        u1.FConsignAmount,
        u1.FConsignPrice,
        u1.FAuxQty
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Department v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_ICItem v4 ON u1.FItemID=v4.FItemID
	left join t_Item v5 ON v5.FItemID=(case when v2.Fdepartment=89 or v2.Fdepartment=38755 then v2.F_132 else v2.F_117 end)
    --LEFT JOIN t_Item v6 ON v6.FItemID=v2.F_110
    WHERE v1.FTranType=21 And v1.FCheckerID>0 AND
		year(v1.FDate) ='2021' AND MONTH(v1.FDate)='06'
        AND v4.FName='FFT187-24B/C51'