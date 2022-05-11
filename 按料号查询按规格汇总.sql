Select top 1000000 
	u1.FDetailID as FListEntryID,
	v1.FVchInterID as FVchInterID,
	v1.FTranType as FTranType,
	v1.FInterID as FInterID,
	u1.FEntryID as FEntryID,
	v1.Fdate as Fdate,
	case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FCheck,
	case when v1.FCancellation=1 then 'Y' else '' end as FCancellation,v1.FBillNo as FBillNo,
	CASE WHEN v1.FHookStatus=1 THEN 'P' WHEN V1.FHookStatus=2 THEN 'Y' ELSE '' END  as FHookStatus,
	v1.FStatus as FStatus,
	case when (v1.FROB <> 1) then 'Y' else '' end as FRedFlag, 
	0 As FBOSCloseFlag 
from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
 LEFT OUTER JOIN t_ICItem t2261 ON   u1.FItemID = t2261.FItemID  AND t2261.FItemID<>0 
 where 1=1 AND (     
ISNULL(t2261.FHELPCODE,'') = 'L21'
)  AND (v1.FTranType=21 AND ((v1.FCheckerID>0)  AND  v1.FCancellation = 0))