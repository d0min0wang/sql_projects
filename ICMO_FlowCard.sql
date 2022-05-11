SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
Select top 1000000 v1.FStatus as FStatus,v1.FTranType as FTranType,
	v1.FInterID as FInterID,v1.FBillNo as FBillNo,
	case when v1.FCancellation=1 then 'Y' else '' end as FCancellation,
	CASE  V1.FSuspend WHEN 0 THEN '' ELSE 'Y' END as FSuspend,
	v1.FType as FICMOType2,v1.FWorktypeID as FWorkTypeID2, 0 As FBOSCloseFlag 
from  ICMO v1  where 1=1 AND (     
ISNULL(v1.FBillNo,'') LIKE '%53464%'
)  AND (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FStatus=0))

select top 100 t1.FBillNo,
	t1.FItemID,
	t2.FName,
	t1.FAuxQty,
	t1.FAuxStockQty,
	t1.FAuxInHighLimitQty,
	t1.FPlanCommitDate,
	t1.FCommitDate,
	t1.fcheckdate
from ICMO t1
left join t_ICItem t2 on t1.FItemID=t2.FItemID
LEFT JOIN SHProcRpt t2 ON t1.FInterID=t2.FICMOInterID
LEFT JOIN SHProcRptMain t3 ON t2.FInterID=t3.FInterID


select * from t_tabledescription where ftablename='ICMO'

select * from t_fielddescription where ftableid=470000