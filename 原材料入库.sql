Select 
	v1.Fdate as Fdate,
	u1.FAuxQty
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
INNER JOIN t_Stock t7 ON     u1.FDCStockID = t7.FItemID   AND t7.FItemID <>0 
where 1=1 AND (     
ISNULL(t7.FName,'') = 'ºýÁÏ²Ö'
  AND  
v1.Fdate >=  '2011-08-28' 
  AND  
v1.Fdate <=  '2011-09-04' 
)  AND (v1.FTranType=2 AND ((v1.FCheckerID>0)  AND  v1.FCancellation = 0))