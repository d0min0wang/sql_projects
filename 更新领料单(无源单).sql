update ICStockBillEntry set fSourceinterid=40115,fSourcebillno='66639'
from
(Select top 10000
		u1.finterid,
		u1.fentryid,
		u1.fopersn,
		u1.foperid,
		u1.fSourceinterid,
		u1.fSourcebillno--,u1.*
	from ICStockBill v1 
		INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
		LEFT OUTER JOIN t_Base_CostCenter cc ON   u1.FCostCenterID = cc.FItemID  AND cc.FItemID<>0 
	where 1=1 
		and (FBillNo='SOUT018320'
		)  AND (v1.FTranType=24 AND (v1.FROB=1 AND  v1.FCancellation = 0)))t
where ICStockBillEntry.finterid=t.finterid and ICStockBillEntry.fentryid=t.fentryid

select * from icmo where fbillno='66639'

