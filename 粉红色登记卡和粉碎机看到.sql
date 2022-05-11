Select u1.FItemID,v1.FSupplyID,sum(CASE WHEN u1.FAuxQty>0 THEN u1.FAuxQty END) 
From ICStockBill v1 inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
Where v1.FTranType=21 
And v1.FCheckerID>0 
And Year(v1.FDate)=' + CAST(@FYear as varchar(4)) + ' 
And Month(v1.FDate)=' + CAST(@FIndex as varchar(2))
Group by v1.FSupplyID,u1.FItemID'

select * from t_Submessage where fname like '%³ö¿â%'

select * from t_tabledescription where fdescription like '%³öÈë%'

select * from t_fielddescription where ftableid=210008

select top 100 FBillTypeID from ICStockbill

--210008
--210009