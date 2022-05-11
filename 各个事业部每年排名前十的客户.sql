;WITH cte
AS
(
--企业销售额
select  v8.FName,
		v2.FName AS FCustName,
        v3.FName AS FDeptName,
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
		FConsignAmount=ISNULL(SUM(u1.FConsignAmount),0),
		FAuxQty=ISNULL(SUM(u1.FAuxQty),0),
        FPrice=ISNULL(SUM(u1.FConsignAmount/u1.FAuxQty),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	where year(v1.FDate)IN ('2019')
    AND FConsignAmount<>0 
	--and month(v1.FDate)<='2'
	
	and v1.FTranType=21 
	group by v1.FSupplyID) t1

LEFT JOIN t_Organization v2 ON t1.FSupplyID=v2.FItemID
LEFT JOIN t_Department v3 ON v2.Fdepartment=v3.FItemID
LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
LEFT JOIN t_SubMessage v7 ON v2.FRegionID=v7.FInterID
LEFT JOIN t_Emp v8 ON v2.Femployee=v8.FItemID
--where v3.FName='新能源事业部'
),
cte_rank
AS
(
select *,Rank() over( partition by FDeptName order by FConsignAmount desc) AS FConsignAmount_Rank
from cte
--where FConsignAmount_rank<=10
)
SELECT * FROM cte_rank WHERE FConsignAmount_Rank<=10