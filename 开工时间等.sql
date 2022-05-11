SELECT k.FName,j.FBillNo,i.FFlowCardNo,m.FName,l.FName,i.FAuxQtyfinish,
	i.FAuxQtyPass,i.FAuxWhtfinish,i.FAuxWhtpass,0.75 AS FUnitPrice,i.FAuxQtyPass*0.75 AS FAmount,
	i.FStartWorkdate,i.FEndWorkdate
--update i set i.FStartWorkdate='2011-01-29',i.FEndWorkdate='2011-01-29'
--update i set i.FAuxWhtfinish=0,i.FAuxWhtpass=0
FROM SHProcRpt i
LEFT JOIN SHProcRptMain j ON i.FInterID=j.FInterID
LEFT JOIN t_Emp k ON i.FWorkerID=k.FItemID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID
LEFT JOIN t_ICItem m ON i.FItemID=m.FItemID
WHERE
--l.FName='°ü×°' and
i.FFlowCardNo='201101290151001'
--and i.FAuxWhtpass>0
--and year(i.FEndworkDate)='2011'

select t1.FBillNo,t1.FPlanCommitDate,t2.* 
--update t1 set t1.FPlanCommitDate=t2.planstart
from ICMO t1
inner join [t_ImportICMO_ Modify] t2 ON t2.billno=t1.FBillNo
where FBillNo='54743'

drop table [t_ImportICMO_ Modify]
select * from t_TableDescription where FDescription like '%ËðÒæ%'

select * from t_FieldDescription where FTableID=1450020

select * from t_Rpt_Profile