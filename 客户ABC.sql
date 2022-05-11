SELECT 
		distinct v2.FName,
		v3.FName,
		v2.FAddress,
		v2.FPhone,
		v2.FFax,
		V2.FContact,
		V2.f_101
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
WHERE v1.FTranType=21 And
	v1.FDate>='2010-01-01' AND v1.FDate<='2010-12-31'
	
select * from t_Organization