;WITH cte
AS
(
    SELECT u1.FItemID,  
		ISNULL(SUM(u1.FAuxQty),0) AS FAuxQty
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Department v3 ON v2.Fdepartment=v3.FItemID
	where year(v1.FDate)IN ('2021') 
	--and month(v1.FDate)<='3'
	--and (v2.FName like '%187-21%' or v2.Fname like '%250-25F%')
    AND v3.FName IN('电气连接事业部','电气连接国内事业部','电气连接国内驻外办事处')
	and v1.FTranType=21 
	group by u1.FItemID
),
cte1
AS
(
SELECT v4.FName,
        v1.FSupplyID,
        v3.FName AS FDepartment,
		ISNULL(SUM(u1.FAuxQty),0) AS FAuxQty,
        ISNULL(SUM(FConsignAmount),0) AS FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Department v3 ON v2.Fdepartment=v3.FItemID
    LEFT join t_ICItem v4 ON u1.FItemID=v4.FItemID
    --LEFT JOIN t_Emp v5 ON v2.Femployee=v5.FItemID
	where year(v1.FDate)IN ('2021') 
	--and month(v1.FDate)<='3'
	--and (v2.FName like '%187-21%' or v2.Fname like '%250-25F%')
    AND u1.FItemID IN (SELECT FItemID FROM cte WHERE FAuxQty<100)
    AND v3.FName IN('电气连接事业部','电气连接国内事业部','电气连接国内驻外办事处')
	and v1.FTranType=21 
	group by v4.FName,v1.FSupplyID,v3.FName
)
SELECT t1.*,t3.FName FROM cte1 t1
left JOIN t_Organization t2 ON t1.FSupplyID=t2.FItemID
LEFT JOIN t_Emp t3 ON t2.Femployee=t3.FItemID