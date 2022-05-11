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

DECLARE @Period char(6)
SET @Period='201004' --统计的年月


--统计处理
DECLARE @Last_Period char(6),@Previous_Period char(6)
SELECT @Last_Period=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112)

    SELECT Department=CASE WHEN GROUPING(v3.FName)=1 THEN '<销售部合计>' ELSE (v3.FName) END,
        Organization=CASE WHEN GROUPING(v5.FName)=1 THEN '<事业部合计>' ELSE (v5.FName) END,    
        January=ISNULL(SUM(CASE WHEN MONTH(v1.FDate)='01' THEN u1.FConsignAmount END),0),
        February=ISNULL(SUM(CASE WHEN MONTH(v1.FDate)='02' THEN u1.FConsignAmount END),0),
        March=ISNULL(SUM(CASE WHEN MONTH(v1.FDate)='03' THEN u1.FConsignAmount END),0),
        April=ISNULL(SUM(CASE WHEN MONTH(v1.FDate)='04' THEN u1.FConsignAmount END),0),
        May=ISNULL(SUM(CASE WHEN MONTH(v1.FDate)='05' THEN u1.FConsignAmount END),0),
        June=ISNULL(SUM(CASE WHEN MONTH(v1.FDate)='06' THEN u1.FConsignAmount END),0),
        July=ISNULL(SUM(CASE WHEN MONTH(v1.FDate)='07' THEN u1.FConsignAmount END),0),
        August=ISNULL(SUM(CASE WHEN MONTH(v1.FDate)='08' THEN u1.FConsignAmount END),0),
        September=ISNULL(SUM(CASE WHEN MONTH(v1.FDate)='09' THEN u1.FConsignAmount END),0),
        October=ISNULL(SUM(CASE WHEN MONTH(v1.FDate)='10' THEN u1.FConsignAmount END),0),
        November=ISNULL(SUM(CASE WHEN MONTH(v1.FDate)='11' THEN u1.FConsignAmount END),0),
        --December=ISNULL(SUM(CASE WHEN MONTH(v1.FDate)='12' THEN u1.FConsignAmount END),0),
		Total=ISNULL(SUM(u1.FConsignAmount),0)
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID	--产品名称
	left join t_Item v5 on v4.FParentID=v5.FItemID --旗型等区分

    WHERE v1.FTranType=21 And
		YEAR(v1.FDate)='2010'
		AND
		MONTH(v1.FDate)<>'12'

    GROUP BY v3.FName,v5.FName  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    ORDER BY Department,Total DESC
	
	