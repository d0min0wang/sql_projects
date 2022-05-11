SELECT DISTINCT OPCostStandardData.FID,
	OPCostStandardData.FClassTypeID  ,
	OPCostStandardDataEntry.FEntryID,
	OPCostStandardDataEntry.FIndex,
	cbCostObj.FName,
	t_BASE_CostCenter.Fname,
	OPCostStandardDataEntry.*  
FROM  OPCostStandardData  
INNER JOIN OPCostStandardDataEntry  ON OPCostStandardData.FID=OPCostStandardDataEntry.FID
 LEFT  JOIN cbCostObj  ON OPCostStandardDataEntry.FCostObjNum=cbCostObj.FItemID
 LEFT  JOIN t_Department  ON OPCostStandardDataEntry.FDeptNum=t_Department.FItemID
 LEFT  JOIN t_BASE_CostCenter  ON OPCostStandardDataEntry.FCostCenter=t_BASE_CostCenter.FItemID AND t_BASE_CostCenter.FItemID<>0
 LEFT  JOIN t_SubMessage  ON OPCostStandardDataEntry.FWorkProcNum=t_SubMessage.FInterID
 WHERE (t_BASE_CostCenter.FNumber = '0602'
) AND OPCostStandardData.FClassTypeID=1011111 Order By OPCostStandardData.FID,OPCostStandardDataEntry.FIndex

--select * from cbCostObj t1 left join t_Item t2 on t1.FItemID=t2.FItemID 

select * from t_BASE_CostCenter