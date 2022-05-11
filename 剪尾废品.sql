SELECT DISTINCT 
	t_Emp.FName,
	vw_Device_Resource.FName,
	t_ICItem.FModel,
	t_ICItem.FHelpCode,
	SHProcRpt.FAuxQtyPass AS 生产合格数量K,
	SHProcRpt.FAuxWhtPass AS 生产合格重量KG,
	SHProcRpt.FAuxQtyFinish AS 生产实做数量K,
	SHProcRpt.FAuxWhtFinish AS 生产实做重量KG,
	SHProcRpt.FAuxQtyForItem AS 因料报废K,
	SHProcRpt.FAuxWhtForItem AS 因料报废KG,
	SHProcRpt.FAuxQtyScrap AS 因工报废K,
	SHProcRpt.FAuxWhtScrap AS 因工报废KG
FROM  SHProcRptMain  
INNER JOIN SHProcRpt  ON SHProcRptMain.FInterID=SHProcRpt.FInterID
 LEFT  JOIN t_SubMessage t_SubMessage6 ON SHProcRpt.FOperID=t_SubMessage6.FInterID AND t_SubMessage6.FInterID<>0
-- LEFT  JOIN v_ICSHOP_TeamTime  ON SHProcRpt.FTeamTimeID=v_ICSHOP_TeamTime.FID
-- LEFT  JOIN t_SubMessage t_SubMessage7 ON SHProcRpt.FTeamID=t_SubMessage7.FInterID AND t_SubMessage7.FInterID<>0
 LEFT  JOIN t_Emp  ON SHProcRpt.FWorkerID=t_Emp.FItemID AND t_Emp.FItemID<>0
 LEFT  JOIN vw_Device_Resource  ON SHProcRpt.FDeviceID=vw_Device_Resource.FID
 LEFT  JOIN t_ICItem  ON SHProcRpt.FItemID=t_ICItem.FItemID AND t_ICItem.FItemID<>0
 WHERE (DateDiff(Second,'2011-01-01 00:00:01',SHProcRpt.FEndWorkDate)  >= 0  AND
DateDiff(Second,'2011-05-01 00:00:01',SHProcRpt.FEndWorkDate)  <= 0  AND
t_SubMessage6.FName = '剪尾'
) AND SHProcRptMain.FClassTypeID=1002520