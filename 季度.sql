--ISNULL(SUM(CASE CAST(DATEPART(year,v1.FDate) AS varchar)+CAST(DATEPART(quarter,getdate()) AS varchar)

--select DATEPART(quarter,getdate())

DECLARE @Period char(4)

SET @Period='2008' --统计的年月



--统计处理
DECLARE 
	--@Last_Period char(6),
	@Period_1 char(4),
	@Period_2 char(4),
	@Period_3 char(6),
	@Period_4 char(6),
	@Period_5 char(6),
	@Period_6 char(6),
	@Period_7 char(6),

	@Quarter1 char(2),
	@Quarter2 char(2),
	@Quarter3 char(2),
	@Quarter4 char(2),

	@FMonth int,
	@FIndex int
SELECT 
	--@Last_Period=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112),
	@Period_1=@Period,
	@Period_2=CONVERT(char(4),DATEADD(Year,1,@Period),112),
	@Period_3=CONVERT(char(4),DATEADD(Year,2,@Period),112),
	@Period_4=CONVERT(char(4),DATEADD(Year,3,@Period),112),
	@Period_5=CONVERT(char(4),DATEADD(Year,4,@Period),112),
	@Period_6=CONVERT(char(4),DATEADD(Year,5,@Period),112),
	@Period_7=CONVERT(char(4),DATEADD(Year,6,@Period),112)

SET @Quarter1='01'
SET @Quarter2='02'
SET @Quarter3='03'
SET @Quarter4='04'

SELECT FDepartment AS 事业部,FBigTrade AS 行业,
	--P_Money AS '年销售额',
	--P_AuxQty AS '年出货量',
	P_Money_11 AS '2008第一季度销售额',
	P_Money_12 AS '2008第二季度销售额',
	P_Money_13 AS '2008第三季度销售额',
	P_Money_14 AS '2008第四季度销售额',
    P_Money_21 AS '2009第一季度销售额',
	P_Money_22 AS '2009第二季度销售额',
	P_Money_23 AS '2009第三季度销售额',
	P_Money_24 AS '2009第四季度销售额',
    P_Money_31 AS '2010第一季度销售额',
	P_Money_32 AS '2010第二季度销售额',
	P_Money_33 AS '2010第三季度销售额',
	P_Money_34 AS '2010第四季度销售额',
    P_Money_41 AS '2011第一季度销售额',
	P_Money_42 AS '2011第二季度销售额',
	P_Money_43 AS '2011第三季度销售额',
	P_Money_44 AS '2011第四季度销售额',
    P_Money_51 AS '2012第一季度销售额',
	P_Money_52 AS '2012第二季度销售额',
	P_Money_53 AS '2012第三季度销售额',
	P_Money_54 AS '2012第四季度销售额',
    P_Money_61 AS '2013第一季度销售额',
	P_Money_62 AS '2013第二季度销售额',
	P_Money_63 AS '2013第三季度销售额',
	P_Money_64 AS '2013第四季度销售额',
    P_Money_71 AS '2014第一季度销售额',
	P_Money_72 AS '2014第二季度销售额',
	P_Money_73 AS '2014第三季度销售额',
	P_Money_74 AS '2014第四季度销售额',
    P_AuxQty_11 AS '2008第一季度出货量',
	P_AuxQty_12 AS '2008第二季度出货量',
	P_AuxQty_13 AS '2008第三季度出货量',
	P_AuxQty_14 AS '2008第四季度出货量',
    P_AuxQty_21 AS '2009第一季度出货量',
	P_AuxQty_22 AS '2009第二季度出货量',
	P_AuxQty_23 AS '2009第三季度出货量',
	P_AuxQty_24 AS '2009第四季度出货量',
    P_AuxQty_31 AS '2010第一季度出货量',
	P_AuxQty_32 AS '2010第二季度出货量',
	P_AuxQty_33 AS '2010第三季度出货量',
	P_AuxQty_34 AS '2010第四季度出货量',
    P_AuxQty_41 AS '2011第一季度出货量',
	P_AuxQty_42 AS '2011第二季度出货量',
	P_AuxQty_43 AS '2011第三季度出货量',
	P_AuxQty_44 AS '2011第四季度出货量',
    P_AuxQty_51 AS '2012第一季度出货量',
	P_AuxQty_52 AS '2012第二季度出货量',
	P_AuxQty_53 AS '2012第三季度出货量',
	P_AuxQty_54 AS '2012第四季度出货量',
    P_AuxQty_61 AS '2013第一季度出货量',
	P_AuxQty_62 AS '2013第二季度出货量',
	P_AuxQty_63 AS '2013第三季度出货量',
	P_AuxQty_64 AS '2013第四季度出货量',
    P_AuxQty_71 AS '2014第一季度出货量',
	P_AuxQty_72 AS '2014第二季度出货量',
	P_AuxQty_73 AS '2014第三季度出货量',
	P_AuxQty_74 AS '2014第四季度出货量'
FROM(
    SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
        FBigTrade=CASE WHEN GROUPING(v5.FName)=1 THEN '<事业部合计>' ELSE (v5.FName) END,    
		--P_Money=ISNULL(SUM(u1.FConsignAmount),0),
        --P_AuxQty=ISNULL(SUM(u1.FAuxQty),0),
        P_Money_11=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_1 and DATEPART(quarter,v1.FDate)=@Quarter1 THEN v1.FConsignAmount END),0),
		P_Money_12=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_1 and DATEPART(quarter,v1.FDate)=@Quarter2 THEN v1.FConsignAmount END),0),
		P_Money_13=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_1 and DATEPART(quarter,v1.FDate)=@Quarter3 THEN v1.FConsignAmount END),0),
		P_Money_14=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_1 and DATEPART(quarter,v1.FDate)=@Quarter4 THEN v1.FConsignAmount END),0),
        P_Money_21=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_2 and DATEPART(quarter,v1.FDate)=@Quarter1 THEN v1.FConsignAmount END),0),
		P_Money_22=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_2 and DATEPART(quarter,v1.FDate)=@Quarter2 THEN v1.FConsignAmount END),0),
		P_Money_23=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_2 and DATEPART(quarter,v1.FDate)=@Quarter3 THEN v1.FConsignAmount END),0),
		P_Money_24=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_2 and DATEPART(quarter,v1.FDate)=@Quarter4 THEN v1.FConsignAmount END),0),
        P_Money_31=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_3 and DATEPART(quarter,v1.FDate)=@Quarter1 THEN v1.FConsignAmount END),0),
		P_Money_32=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_3 and DATEPART(quarter,v1.FDate)=@Quarter2 THEN v1.FConsignAmount END),0),
		P_Money_33=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_3 and DATEPART(quarter,v1.FDate)=@Quarter3 THEN v1.FConsignAmount END),0),
		P_Money_34=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_3 and DATEPART(quarter,v1.FDate)=@Quarter4 THEN v1.FConsignAmount END),0),
		P_Money_41=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_4 and DATEPART(quarter,v1.FDate)=@Quarter1 THEN v1.FConsignAmount END),0),
		P_Money_42=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_4 and DATEPART(quarter,v1.FDate)=@Quarter2 THEN v1.FConsignAmount END),0),
		P_Money_43=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_4 and DATEPART(quarter,v1.FDate)=@Quarter3 THEN v1.FConsignAmount END),0),
		P_Money_44=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_4 and DATEPART(quarter,v1.FDate)=@Quarter4 THEN v1.FConsignAmount END),0),
		P_Money_51=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_5 and DATEPART(quarter,v1.FDate)=@Quarter1 THEN v1.FConsignAmount END),0),
		P_Money_52=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_5 and DATEPART(quarter,v1.FDate)=@Quarter2 THEN v1.FConsignAmount END),0),
		P_Money_53=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_5 and DATEPART(quarter,v1.FDate)=@Quarter3 THEN v1.FConsignAmount END),0),
		P_Money_54=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_5 and DATEPART(quarter,v1.FDate)=@Quarter4 THEN v1.FConsignAmount END),0),
		P_Money_61=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_6 and DATEPART(quarter,v1.FDate)=@Quarter1 THEN v1.FConsignAmount END),0),
		P_Money_62=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_6 and DATEPART(quarter,v1.FDate)=@Quarter2 THEN v1.FConsignAmount END),0),
		P_Money_63=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_6 and DATEPART(quarter,v1.FDate)=@Quarter3 THEN v1.FConsignAmount END),0),
		P_Money_64=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_6 and DATEPART(quarter,v1.FDate)=@Quarter4 THEN v1.FConsignAmount END),0),
		P_Money_71=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_7 and DATEPART(quarter,v1.FDate)=@Quarter1 THEN v1.FConsignAmount END),0),
		P_Money_72=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_7 and DATEPART(quarter,v1.FDate)=@Quarter2 THEN v1.FConsignAmount END),0),
		P_Money_73=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_7 and DATEPART(quarter,v1.FDate)=@Quarter3 THEN v1.FConsignAmount END),0),
		P_Money_74=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_7 and DATEPART(quarter,v1.FDate)=@Quarter4 THEN v1.FConsignAmount END),0),
		P_AuxQty_11=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_1 and DATEPART(quarter,v1.FDate)=@Quarter1 THEN v1.FAuxQty END),0),
        P_AuxQty_12=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_1 and DATEPART(quarter,v1.FDate)=@Quarter2 THEN v1.FAuxQty END),0),
        P_AuxQty_13=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_1 and DATEPART(quarter,v1.FDate)=@Quarter3 THEN v1.FAuxQty END),0),
        P_AuxQty_14=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_1 and DATEPART(quarter,v1.FDate)=@Quarter4 THEN v1.FAuxQty END),0),
        P_AuxQty_21=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_2 and DATEPART(quarter,v1.FDate)=@Quarter1 THEN v1.FAuxQty END),0),
        P_AuxQty_22=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_2 and DATEPART(quarter,v1.FDate)=@Quarter2 THEN v1.FAuxQty END),0),
        P_AuxQty_23=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_2 and DATEPART(quarter,v1.FDate)=@Quarter3 THEN v1.FAuxQty END),0),
        P_AuxQty_24=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_2 and DATEPART(quarter,v1.FDate)=@Quarter4 THEN v1.FAuxQty END),0),
        P_AuxQty_31=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_3 and DATEPART(quarter,v1.FDate)=@Quarter1 THEN v1.FAuxQty END),0),
        P_AuxQty_32=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_3 and DATEPART(quarter,v1.FDate)=@Quarter2 THEN v1.FAuxQty END),0),
        P_AuxQty_33=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_3 and DATEPART(quarter,v1.FDate)=@Quarter3 THEN v1.FAuxQty END),0),
        P_AuxQty_34=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_3 and DATEPART(quarter,v1.FDate)=@Quarter4 THEN v1.FAuxQty END),0),
        P_AuxQty_41=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_4 and DATEPART(quarter,v1.FDate)=@Quarter1 THEN v1.FAuxQty END),0),
        P_AuxQty_42=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_4 and DATEPART(quarter,v1.FDate)=@Quarter2 THEN v1.FAuxQty END),0),
        P_AuxQty_43=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_4 and DATEPART(quarter,v1.FDate)=@Quarter3 THEN v1.FAuxQty END),0),
        P_AuxQty_44=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_4 and DATEPART(quarter,v1.FDate)=@Quarter4 THEN v1.FAuxQty END),0),
        P_AuxQty_51=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_5 and DATEPART(quarter,v1.FDate)=@Quarter1 THEN v1.FAuxQty END),0),
        P_AuxQty_52=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_5 and DATEPART(quarter,v1.FDate)=@Quarter2 THEN v1.FAuxQty END),0),
        P_AuxQty_53=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_5 and DATEPART(quarter,v1.FDate)=@Quarter3 THEN v1.FAuxQty END),0),
        P_AuxQty_54=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_5 and DATEPART(quarter,v1.FDate)=@Quarter4 THEN v1.FAuxQty END),0),
        P_AuxQty_61=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_6 and DATEPART(quarter,v1.FDate)=@Quarter1 THEN v1.FAuxQty END),0),
        P_AuxQty_62=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_6 and DATEPART(quarter,v1.FDate)=@Quarter2 THEN v1.FAuxQty END),0),
        P_AuxQty_63=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_6 and DATEPART(quarter,v1.FDate)=@Quarter3 THEN v1.FAuxQty END),0),
        P_AuxQty_64=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_6 and DATEPART(quarter,v1.FDate)=@Quarter4 THEN v1.FAuxQty END),0),
        P_AuxQty_71=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_7 and DATEPART(quarter,v1.FDate)=@Quarter1 THEN v1.FAuxQty END),0),
        P_AuxQty_72=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_7 and DATEPART(quarter,v1.FDate)=@Quarter2 THEN v1.FAuxQty END),0),
        P_AuxQty_73=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_7 and DATEPART(quarter,v1.FDate)=@Quarter3 THEN v1.FAuxQty END),0),
        P_AuxQty_74=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_7 and DATEPART(quarter,v1.FDate)=@Quarter4 THEN v1.FAuxQty END),0)
   --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM (select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	from [AIS20131027152019].[dbo].ICStockBill t1 
	INNER JOIN [AIS20131027152019].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	where year(t1.FDate)<='2012'
	union all
	select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	from [AIS20131027183315].[dbo].ICStockBill t1 
	INNER JOIN [AIS20131027183315].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	where year(t1.FDate)>='2013') v1
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	--LEFT JOIN t_Item v4 ON v1.FItemID=v4.FItemID
	left join t_Item v5 ON v2.F_117=v5.FItemID
    WHERE v1.FTranType=21 And v1.FCheckerID>0 
	AND
		year(v1.FDate) >=@Period
		--and month(v1.FDate)<month(getdate()) 

    GROUP BY v3.FName,v5.FName  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FDepartment,P_Money_11 DESC