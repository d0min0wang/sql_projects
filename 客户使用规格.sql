SELECT 
	v3.FName,
	v2.FName,
	v4.FName    
FROM ICStockBill v1 
left JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID
where v2.FName LIKE '%格力%'
and v1.ftrantype=21 and v1.fdate>='2010-07-01' and v1.fdate<='2010-07-31'


select t2.fname,* from seorder t1
left join t_Organization t2 on t1.fcustid=t2.FItemID
where t2.Fname like '%美的%'
