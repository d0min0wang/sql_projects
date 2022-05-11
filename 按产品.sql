select v7.FName,
		v2.FProvince,
		v2.FName AS FName,
		v3.FName,
		v5.FName,
		v4.FName as FTradeName,
		t1.*
from
(
SELECT --v3.FName,
		--v5.FName,
		--v4.FName as FTradeName,
		--v3.FName AS FName, 
		v1.FSupplyID, 
		v2.FName,  
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
--		[2009]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then u1.FConsignAmount END),0),
--		[2010]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then u1.FConsignAmount END),0),
		[2013]=ISNULL(SUM(CASE year(v1.FDate) when '2013' then u1.FAuxQty END),0),
		[201301]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)='1' then u1.FAuxQty END),0),
		[201302]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)= '2' then u1.FAuxQty END),0),
		[201303]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)= '3' then u1.FAuxQty END),0),
		[201304]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)='4' then u1.FAuxQty END),0),
		[201305]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)= '5' then u1.FAuxQty END),0),
		[201306]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)= '6' then u1.FAuxQty END),0),
		[201307]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)='7' then u1.FAuxQty END),0),
		[201308]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)= '8' then u1.FAuxQty END),0),
		[201309]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)= '9' then u1.FAuxQty END),0),
		[2013010]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)='10' then u1.FAuxQty END),0),
		[2013011]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)= '11' then u1.FAuxQty END),0),
		[2013012]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)= '12' then u1.FAuxQty END),0)
		--[2014]=ISNULL(SUM(CASE year(v1.FDate) when '2014' then u1.FConsignAmount END),0),
		--[201401]=ISNULL(SUM(CASE when year(v1.FDate) ='2014' and month(v1.FDate)='1' then u1.FAuxQty END),0),
		--[201402]=ISNULL(SUM(CASE when year(v1.FDate) ='2014' and month(v1.FDate)= '2' then u1.FAuxQty END),0),
		--[201403]=ISNULL(SUM(CASE when year(v1.FDate) ='2014' and month(v1.FDate)= '3' then u1.FAuxQty END),0)
		--[4]=ISNULL(SUM(CASE month(v1.FDate) when '4' then u1.FConsignAmount END),0),
		--[5]=ISNULL(SUM(CASE month(v1.FDate) when '5' then u1.FConsignAmount END),0),
		--[6]=ISNULL(SUM(CASE month(v1.FDate) when '6' then u1.FConsignAmount END),0),
		--[7]=ISNULL(SUM(CASE month(v1.FDate) when '7' then u1.FConsignAmount END),0),
		--[8]=ISNULL(SUM(CASE month(v1.FDate) when '8' then u1.FConsignAmount END),0),
		--[9]=ISNULL(SUM(CASE month(v1.FDate) when '9' then u1.FConsignAmount END),0),
		--[10]=ISNULL(SUM(CASE month(v1.FDate) when '10' then u1.FConsignAmount END),0),
		--[11]=ISNULL(SUM(CASE month(v1.FDate) when '11' then u1.FConsignAmount END),0),
		--[12]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FConsignAmount END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Item v2 ON u1.FItemID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.FParentID=v3.FItemID
	where year(v1.FDate)IN ('2013') 
	--and month(v1.FDate)<='3'
	--and (v2.FName like '%187-21%' or v2.Fname like '%250-25F%')
	and v1.FTranType=21 
	group by v1.FSupplyID,v2.FName) t1

LEFT JOIN t_Organization v2 ON t1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
LEFT JOIN t_SubMessage v7 ON v2.FRegionID=v7.FInterID
where --v2.FName like '%格兰仕%'
v4.FName like '%空调%'
and v3.FName='端子套事业部'
order by [2013] desc

--select * from t_ICItem where FItemID=2367

SELECT --v3.FName,
		--v5.FName,
		--v4.FName as FTradeName,
		--v3.FName AS FName,  
		v2.FModel,  
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
--		[2009]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then u1.FConsignAmount END),0),
--		[2010]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then u1.FConsignAmount END),0),
		[2013]=ISNULL(SUM(CASE year(v1.FDate) when '2013' then u1.FAuxQty END),0),
		[201301]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)='1' then u1.FAuxQty END),0),
		[201302]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)= '2' then u1.FAuxQty END),0),
		[201303]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)= '3' then u1.FAuxQty END),0),
		[201304]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)='4' then u1.FAuxQty END),0),
		[201305]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)= '5' then u1.FAuxQty END),0),
		[201306]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)= '6' then u1.FAuxQty END),0),
		[201307]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)='7' then u1.FAuxQty END),0),
		[201308]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)= '8' then u1.FAuxQty END),0),
		[201309]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)= '9' then u1.FAuxQty END),0),
		[2013010]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)='10' then u1.FAuxQty END),0),
		[2013011]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)= '11' then u1.FAuxQty END),0),
		[2013012]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)= '12' then u1.FAuxQty END),0)
		--[2014]=ISNULL(SUM(CASE year(v1.FDate) when '2014' then u1.FConsignAmount END),0),
		--[201401]=ISNULL(SUM(CASE when year(v1.FDate) ='2014' and month(v1.FDate)='1' then u1.FAuxQty END),0),
		--[201402]=ISNULL(SUM(CASE when year(v1.FDate) ='2014' and month(v1.FDate)= '2' then u1.FAuxQty END),0),
		--[201403]=ISNULL(SUM(CASE when year(v1.FDate) ='2014' and month(v1.FDate)= '3' then u1.FAuxQty END),0)
		--[4]=ISNULL(SUM(CASE month(v1.FDate) when '4' then u1.FConsignAmount END),0),
		--[5]=ISNULL(SUM(CASE month(v1.FDate) when '5' then u1.FConsignAmount END),0),
		--[6]=ISNULL(SUM(CASE month(v1.FDate) when '6' then u1.FConsignAmount END),0),
		--[7]=ISNULL(SUM(CASE month(v1.FDate) when '7' then u1.FConsignAmount END),0),
		--[8]=ISNULL(SUM(CASE month(v1.FDate) when '8' then u1.FConsignAmount END),0),
		--[9]=ISNULL(SUM(CASE month(v1.FDate) when '9' then u1.FConsignAmount END),0),
		--[10]=ISNULL(SUM(CASE month(v1.FDate) when '10' then u1.FConsignAmount END),0),
		--[11]=ISNULL(SUM(CASE month(v1.FDate) when '11' then u1.FConsignAmount END),0),
		--[12]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FConsignAmount END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_ICItem v2 ON u1.FItemID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.FParentID=v3.FItemID
	where year(v1.FDate)IN ('2013') 
	--and month(v1.FDate)<='3'
	and v2.FModel IN ('FF187-21','FF250-25F','TS187-21B')
	--and (v2.FName like '%187-21%' or v2.Fname like '%250-25F%')
	and v1.FTranType=21 
	group by v2.FModel



	select * from t_ICItem where FHelpCode like '%GQ%'


	SELECT --v3.FName,
		--v5.FName,
		--v4.FName as FTradeName,
		--v3.FName AS FName, 
		v1.FSupplyID, 
		v2.FName,  
		max(v2.FHelpCode),
		max(v2.FPlanPrice),
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
--		[2009]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then u1.FConsignAmount END),0),
		[2015出货]=ISNULL(SUM(CASE year(v1.FDate) when '2015' then u1.FAuxQty END),0),
		[2015金额]=ISNULL(SUM(CASE year(v1.FDate) when '2015' then u1.FConsignAmount END),0),
		[2015单价]=ISNULL(AVG(CASE year(v1.FDate) when '2015' then u1.FPrice END),0),
		[201501]=ISNULL(SUM(CASE when year(v1.FDate) ='2015' and month(v1.FDate)='1' then u1.FConsignAmount END),0),
		[201502]=ISNULL(SUM(CASE when year(v1.FDate) ='2015' and month(v1.FDate)= '2' then u1.FConsignAmount END),0),
		[201503]=ISNULL(SUM(CASE when year(v1.FDate) ='2015' and month(v1.FDate)= '3' then u1.FConsignAmount END),0),
		[201504]=ISNULL(SUM(CASE when year(v1.FDate) ='2015' and month(v1.FDate)='4' then u1.FConsignAmount END),0),
		[201505]=ISNULL(SUM(CASE when year(v1.FDate) ='2015' and month(v1.FDate)= '5' then u1.FConsignAmount END),0),
		[201506]=ISNULL(SUM(CASE when year(v1.FDate) ='2015' and month(v1.FDate)= '6' then u1.FConsignAmount END),0),
		[201507]=ISNULL(SUM(CASE when year(v1.FDate) ='2015' and month(v1.FDate)='7' then u1.FConsignAmount END),0),
		[201508]=ISNULL(SUM(CASE when year(v1.FDate) ='2015' and month(v1.FDate)= '8' then u1.FConsignAmount END),0),
		[201509]=ISNULL(SUM(CASE when year(v1.FDate) ='2015' and month(v1.FDate)= '9' then u1.FConsignAmount END),0),
		[2015010]=ISNULL(SUM(CASE when year(v1.FDate) ='2015' and month(v1.FDate)='10' then u1.FConsignAmount END),0),
		[2015011]=ISNULL(SUM(CASE when year(v1.FDate) ='2015' and month(v1.FDate)= '11' then u1.FConsignAmount END),0),
		[2015012]=ISNULL(SUM(CASE when year(v1.FDate) ='2013' and month(v1.FDate)= '12' then u1.FConsignAmount END),0)
		--[2014]=ISNULL(SUM(CASE year(v1.FDate) when '2014' then u1.FConsignAmount END),0),
		--[201401]=ISNULL(SUM(CASE when year(v1.FDate) ='2014' and month(v1.FDate)='1' then u1.FAuxQty END),0),
		--[201402]=ISNULL(SUM(CASE when year(v1.FDate) ='2014' and month(v1.FDate)= '2' then u1.FAuxQty END),0),
		--[201403]=ISNULL(SUM(CASE when year(v1.FDate) ='2014' and month(v1.FDate)= '3' then u1.FAuxQty END),0)
		--[4]=ISNULL(SUM(CASE month(v1.FDate) when '4' then u1.FConsignAmount END),0),
		--[5]=ISNULL(SUM(CASE month(v1.FDate) when '5' then u1.FConsignAmount END),0),
		--[6]=ISNULL(SUM(CASE month(v1.FDate) when '6' then u1.FConsignAmount END),0),
		--[7]=ISNULL(SUM(CASE month(v1.FDate) when '7' then u1.FConsignAmount END),0),
		--[8]=ISNULL(SUM(CASE month(v1.FDate) when '8' then u1.FConsignAmount END),0),
		--[9]=ISNULL(SUM(CASE month(v1.FDate) when '9' then u1.FConsignAmount END),0),
		--[10]=ISNULL(SUM(CASE month(v1.FDate) when '10' then u1.FConsignAmount END),0),
		--[11]=ISNULL(SUM(CASE month(v1.FDate) when '11' then u1.FConsignAmount END),0),
		--[12]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FConsignAmount END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_ICItem v2 ON u1.FItemID=v2.FItemID
	where year(v1.FDate)IN ('2015') 
	and v2.FHelpCode like '%GQ%'
	--and (v2.FName like '%187-21%' or v2.Fname like '%250-25F%')
	and v1.FTranType=21 
	group by v1.FSupplyID,v2.FName


	select v1.FSupplyID,
		v5.FName,
		v2.FName,
		u1.FItemID,  
		v2.FHelpCode,
		v2.FPlanPrice, 
		u1.FPrice,
		u1.FAuxQty,
		v3.FAuxWhtSingle,
		u1.FAuxQty*v3.FAuxWhtSingle AS Wth,  
		u1.FConsignAmount
	FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID 
	LEFT JOIN t_ICItem v2 ON u1.FItemID=v2.FItemID
	left JOIN (
		select t1.FItemID, 
			AVG(t1.FAuxWhtSingle) AS FAuxWhtSingle,
			MAX(t1.FAuxWhtSingle) AS MAXFAuxWhtSingle,
			MIN(t1.FAuxWhtSingle) AS FAVGGrossWeightAfterAdj
		from SHProcRpt t1
		LEFT JOIN t_ICItem t2 ON t1.FItemID=t2.FItemID
		LEFT JOIN t_SubMessage t3 ON t1.FOperID=t3.FInterID 
		where 
		t3.FName='包装'
		--and year(t1.fendworkdate)='2015'
		and t2.FHelpCode like '%GQ%'
		--and t1.FAuxWhtSingle<1.6826*t2.FGrossWeight
		--and t1.FAuxWhtSingle>t2.FGrossWeight/1.6826
		--and t1.FAuxWhtSingle>0
		group by t1.FItemID ) v3 on u1.FItemID=v3.FItemID
	LEFT JOIN t_Organization v4 ON v1.FSupplyID=v4.FItemID
	LEFT JOIN t_Item v5 ON v4.Fdepartment=v5.FItemID
	where year(v1.FDate)IN ('2015') 
	and v2.FHelpCode like '%GQ%'
	--and (v2.FName like '%187-21%' or v2.Fname like '%250-25F%')
	and v1.FTranType=21 

