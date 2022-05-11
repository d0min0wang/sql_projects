Select 
	v1.FBillNo,
	v1.FCustID,
	v3.FName,
	v1.FDeptID,
	v4.FName,
	v1.FEmpID,
	v5.FName,
	v1.Fdate as Fdate,
	v2.FAuxQty,
	v2.FCommitQty,--发货数量
	v2.FAuxPrice,
	v2.FAmount,
	v2.FAuxPriceDiscount,--实际含税单价
	v2.FAllAmount,--价税合计
	v2.FEntrySelfS0162, --未出库数
	v2.FEntrySelfS0169, --未出库金额
	case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end  as FCheck,
	CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,
	case when v1.FCancellation=1 then 'Y' else '' end as FCancellation
from SEOrder v1 
INNER JOIN SEOrderEntry v2 ON  v1.FInterID = v2.FInterID AND v2.FInterID <>0 
left join t_Organization v3 on v1.FCustID=v3.FItemID
left join t_Department v4 on v1.FDeptID=v4.FItemID
left join t_Emp v5 on v1.FEmpID=v5.FItemID
 where 1=1 
AND v1.Fdate>'2013-08-01'  
AND v1.FChangeMark=0 
AND Isnull(v1.FClassTypeID,0)<>1007100 
AND v1.FCheckerID>0  
AND v1.FCancellation=0

--select * from t_fielddescription where ftableid=230005
--230005
--select * from t_tabledescription where fdescription like '%即时%'