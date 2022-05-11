SELECT DISTINCT 
	t_Emp.FName,
	vw_Device_Resource.FName,
	t_ICItem.FModel,
	t_ICItem.FHelpCode,
	SHProcRpt.FAuxQtyPass AS �����ϸ�����K,
	SHProcRpt.FAuxWhtPass AS �����ϸ�����KG,
	SHProcRpt.FAuxQtyFinish AS ����ʵ������K,
	SHProcRpt.FAuxWhtFinish AS ����ʵ������KG,
	SHProcRpt.FAuxQtyForItem AS ���ϱ���K,
	SHProcRpt.FAuxWhtForItem AS ���ϱ���KG,
	SHProcRpt.FAuxQtyScrap AS �򹤱���K,
	SHProcRpt.FAuxWhtScrap AS �򹤱���KG
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
t_SubMessage6.FName = '��β'
) AND SHProcRptMain.FClassTypeID=1002520