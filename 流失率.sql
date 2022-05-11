--Á÷Ê§ÂÊ

select *,(tt1.FCount2013-tt2.FCount2014)/tt1.FCount2013 FROM
(select v3.FName as FDeptName,
	count(v1.FSupplyID) AS FCount2013
FROM (select distinct FSupplyID
FROM ICStockBill
where 
FTranType=21 And FCheckerID>0 AND
year(FDate) ='2013')v1
LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
GROUP BY V3.FName)tt1
left join 
(select v3.FName as FDeptName,
	count(v1.FSupplyID) AS FCount2014
FROM (select distinct FSupplyID FROM ICStockBill
	where 
	FTranType=21 And FCheckerID>0 AND
	year(FDate) ='2014' and FSupplyID IN
		(select distinct FSupplyID
			FROM ICStockBill
			where 
			FTranType=21 And FCheckerID>0 AND
			year(FDate) ='2013'))v1
LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
GROUP BY V3.FName)tt2 on tt1.FDeptName=tt2.FDeptName


--Ã÷Ï¸


select 
	v3.FName as FDeptName,
	v2.FName AS FCustName,
	v1.FConsignAmount,
	v1.FAuxQty
FROM 
(select * from 
	(select t1.FSupplyID,sum(t2.FConsignAmount) AS FConsignAmount,sum(t2.FAuxQty) AS FAuxQty FROM ICStockBill  t1
	INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	where 
	FTranType=21 And FCheckerID>0 AND
	year(FDate) ='2013' group by FSupplyID) aa
left join (select distinct FSupplyID as FSupplyID2014
			FROM ICStockBill
			where 
			FTranType=21 And FCheckerID>0 AND
			year(FDate) ='2014') bb on aa.FSupplyID=bb.FSupplyID2014) v1
LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
where v1.FSupplyID2014 IS NULL
order by v3.FName,v1.FAuxQty DESC