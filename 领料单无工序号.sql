--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
--select top 100 * from ICStockBillEntry

update ICStockBillEntry set ICStockBillEntry.fopersn=10,ICStockBillEntry.foperid=40026
--select *
from(Select top 10000
		u1.finterid,
		u1.fentryid,
		u1.fopersn,
		u1.foperid,
		u1.ficmointerid,
		u1.ficmobillno
	from ICStockBill v1 
		INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
		LEFT OUTER JOIN t_Base_CostCenter cc ON   u1.FCostCenterID = cc.FItemID  AND cc.FItemID<>0 
	where 1=1 
		and (fopersn=0 and foperid=0 and ficmointerid>0 and ficmobillno>0)
		AND (     
		ISNULL(cc.FName,'') = '成型'
--		AND  
--		v1.Fdate >=  '2011-05-01' 
		)  AND (v1.FTranType=24 AND (v1.FROB=1 AND  v1.FCancellation = 0)))t
where ICStockBillEntry.finterid=t.finterid and ICStockBillEntry.fentryid=t.fentryid

--64041

--select * from t_tabledescription where fdescription like '%出入%'
--select * from t_fielddescription where ftableid=210009