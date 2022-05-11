SELECT t_ICItem.FQtyDecimal AS FItemID_FQtyDecimal,t_ICItem.FPriceDecimal AS FItemID_FPriceDecimal,v_ICSHOP_TeamTime.FName AS FTeamTimeID_DSPName,vw_Device_Resource.FName AS FDeviceID_DSPName,t_Emp.FName AS FWorkerID_DSPName,SHProcRpt.FStartWorkDate,
t_ICItem.FModel AS FSpecification_DSPName,SHProcRpt.FAuxQtyfinish,SHProcRpt.FAuxWhtFinish AS FDecimal1,SHProcRpt.FFlowCardNO,SHProcRpt.FAuxWhtSingle AS FDecimal,SHProcRpt.FAuxWhtScrap AS FDecimal2,
SHProcRpt.FAuxWhtPass AS FDecimal6,SHProcRpt.FEndWorkDate,SHProcRpt.FMOPlanStartDate,SHProcRpt.FMOPlanFinishDate,SHProcRptMain.FDate FROM SHProcRptMain  INNER JOIN SHProcRpt  ON SHProcRptMain.FInterID=SHProcRpt.FInterID
 LEFT  JOIN v_ICSHOP_TeamTime  ON SHProcRpt.FTeamTimeID=v_ICSHOP_TeamTime.FID
 LEFT  JOIN t_Emp  ON SHProcRpt.FWorkerID=t_Emp.FItemID AND t_Emp.FItemID<>0
 LEFT  JOIN vw_Device_Resource  ON SHProcRpt.FDeviceID=vw_Device_Resource.FID
 LEFT  JOIN t_ICItem  ON SHProcRpt.FItemID=t_ICItem.FItemID AND t_ICItem.FItemID<>0
 --INNER  JOIN #tmpID ON #tmpID.FEntryID = SHProcRpt.FEntryIndex ORDER BY id_num
