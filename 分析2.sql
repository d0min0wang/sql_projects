DECLARE @Period char(4)
DECLARE @Department char(12)
select @Period='2012'
select @Department='端子套事业部'

--select @Period
--select @Department


select tt4.FName,tt5.FName,tt6.FName,
tt1.[销售额合计],
tt1.[1月销售额],tt2.[1月样品],tt3.[1月报价],
tt1.[2月销售额],tt2.[2月样品],tt3.[2月报价],
tt1.[3月销售额],tt2.[3月样品],tt3.[3月报价],
tt1.[4月销售额],tt2.[4月样品],tt3.[4月报价],
tt1.[5月销售额],tt2.[5月样品],tt3.[5月报价],
tt1.[6月销售额],tt2.[6月样品],tt3.[6月报价],
tt1.[7月销售额],tt2.[7月样品],tt3.[7月报价],
tt1.[8月销售额],tt2.[8月样品],tt3.[8月报价],
tt1.[9月销售额],tt2.[9月样品],tt3.[9月报价],
tt1.[10月销售额],tt2.[10月样品],tt3.[10月报价],
tt1.[11月销售额],tt2.[11月样品],tt3.[11月报价],
tt1.[12月销售额],tt2.[12月样品],tt3.[12月报价]
from
(SELECT v2.Fdepartment,
		v2.F_117,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
		[销售额合计]=ISNULL(SUM(u1.FConsignAmount),0),
		[1月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '1' then u1.FConsignAmount END),0),
		[2月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '2' then u1.FConsignAmount END),0),
		[3月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '3' then u1.FConsignAmount END),0),
		[4月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '4' then u1.FConsignAmount END),0),
		[5月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '5' then u1.FConsignAmount END),0),
		[6月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '6' then u1.FConsignAmount END),0),
		[7月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '7' then u1.FConsignAmount END),0),
		[8月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '8' then u1.FConsignAmount END),0),
		[9月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '9' then u1.FConsignAmount END),0),
		[10月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '10' then u1.FConsignAmount END),0),
		[11月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '11' then u1.FConsignAmount END),0),
		[12月销售额]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FConsignAmount END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
	LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
	LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
where year(v1.FDate)=@Period
--and month(v1.FDate)<='6'
and v1.FTranType=21 and v3.FName=@Department 
--and v4.FName IN ('家用空调器','微波炉','冰箱\冷柜','热水器','电饭煲/压力锅')
group by v2.Fdepartment,v2.F_117--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
--with rollup
--order by [2013] desc--v5.FName,v4.FName,[2011]
--order by v4.FName,[2013] desc
)tt1

left join
--样品

(select 
	t2.Fdepartment,t2.F_117,
	[1月样品]=ISNULL(count(CASE month(t1.FDate) when '1' then t1.FID END),0),
	[2月样品]=ISNULL(count(CASE month(t1.FDate) when '2' then t1.FID END),0),
	[3月样品]=ISNULL(count(CASE month(t1.FDate) when '3' then t1.FID END),0),
	[4月样品]=ISNULL(count(CASE month(t1.FDate) when '4' then t1.FID END),0),
	[5月样品]=ISNULL(count(CASE month(t1.FDate) when '5' then t1.FID END),0),
	[6月样品]=ISNULL(count(CASE month(t1.FDate) when '6' then t1.FID END),0),
	[7月样品]=ISNULL(count(CASE month(t1.FDate) when '7' then t1.FID END),0),
	[8月样品]=ISNULL(count(CASE month(t1.FDate) when '8' then t1.FID END),0),
	[9月样品]=ISNULL(count(CASE month(t1.FDate) when '9' then t1.FID END),0),
	[10月样品]=ISNULL(count(CASE month(t1.FDate) when '10' then t1.FID END),0),
	[11月样品]=ISNULL(count(CASE month(t1.FDate) when '11' then t1.FID END),0),
	[12月样品]=ISNULL(count(CASE month(t1.FDate) when '12' then t1.FID END),0) 
from CRM_SampleReq t1
left join t_Organization t2 ON t1.FCustomerID=t2.FItemID
LEFT JOIN t_Item t3 ON t2.Fdepartment=t3.FItemID
LEFT JOIN t_Item t4 ON t2.F_117=t4.FItemID
where year(t1.FDate)=@Period and t3.FName=@Department
group by t2.Fdepartment,t2.F_117)tt2 
ON tt1.Fdepartment=tt2.Fdepartment and tt1.F_117=tt2.F_117

left join
--报价
(select 
	t2.Fdepartment,t2.F_117,
	[1月报价]=ISNULL(count(CASE month(t1.FDate) when '1' then t1.FInterID END),0),
	[2月报价]=ISNULL(count(CASE month(t1.FDate) when '2' then t1.FInterID END),0),
	[3月报价]=ISNULL(count(CASE month(t1.FDate) when '3' then t1.FInterID END),0),
	[4月报价]=ISNULL(count(CASE month(t1.FDate) when '4' then t1.FInterID END),0),
	[5月报价]=ISNULL(count(CASE month(t1.FDate) when '5' then t1.FInterID END),0),
	[6月报价]=ISNULL(count(CASE month(t1.FDate) when '6' then t1.FInterID END),0),
	[7月报价]=ISNULL(count(CASE month(t1.FDate) when '7' then t1.FInterID END),0),
	[8月报价]=ISNULL(count(CASE month(t1.FDate) when '8' then t1.FInterID END),0),
	[9月报价]=ISNULL(count(CASE month(t1.FDate) when '9' then t1.FInterID END),0),
	[10月报价]=ISNULL(count(CASE month(t1.FDate) when '10' then t1.FInterID END),0),
	[11月报价]=ISNULL(count(CASE month(t1.FDate) when '11' then t1.FInterID END),0),
	[12月报价]=ISNULL(count(CASE month(t1.FDate) when '12' then t1.FInterID END),0) 
from PORFQ t1
left join t_Organization t2 ON t1.FCustID=t2.FItemID
LEFT JOIN t_Item t3 ON t2.Fdepartment=t3.FItemID
LEFT JOIN t_Item t4 ON t2.F_117=t4.FItemID
where year(t1.FDate)=@Period and t3.FName=@Department
group by t2.Fdepartment,t2.F_117)tt3
ON tt1.Fdepartment=tt3.Fdepartment and tt1.F_117=tt3.F_117

LEFT JOIN t_Item tt4 ON tt1.Fdepartment=tt4.FItemID
LEFT JOIN t_Item tt5 ON tt1.F_117=tt5.FItemID
LEFT JOIN t_Item tt6 ON tt5.FParentID=tt6.FItemID
order by [销售额合计] desc


