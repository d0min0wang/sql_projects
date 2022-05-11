--SELECT  sum(round(isnull(SHProcRpt.FAuxQtyfinish,0),t_ICItem.FQtyDecimal)) AS FAuxQtyfinish, sum(isnull(SHProcRpt.FAuxWhtFinish,0)) AS FDecimal1, sum(isnull(SHProcRpt.FAuxWhtScrap,0)) AS FDecimal2  FROM  SHProcRptMain  INNER JOIN SHProcRpt  ON SHProcRptMain.FInterID=SHProcRpt.FInterID
-- LEFT  JOIN t_User t_User1 ON SHProcRptMain.FCheckerID=t_User1.FUserID AND t_User1.FUserID<>0
-- LEFT  JOIN t_SubMessage t_SubMessage5 ON SHProcRptMain.FCheckStatus=t_SubMessage5.FInterID AND t_SubMessage5.FInterID<>0
-- LEFT  JOIN v_ICSHOP_TeamTime  ON SHProcRpt.FTeamTimeID=v_ICSHOP_TeamTime.FID
-- LEFT  JOIN t_Emp  ON SHProcRpt.FWorkerID=t_Emp.FItemID AND t_Emp.FItemID<>0
-- LEFT  JOIN vw_Device_Resource  ON SHProcRpt.FDeviceID=vw_Device_Resource.FID
-- LEFT  JOIN t_ICItem  ON SHProcRpt.FItemID=t_ICItem.FItemID AND t_ICItem.FItemID<>0
-- WHERE (SHProcRpt.FICMOBillNO = '55731'   AND
--t_SubMessage5.FID = 'N'
--) AND SHProcRptMain.FClassTypeID=1002520

SELECT IDENTITY(INT,1,1) AS autoID,
	t1.FBillNo,
	t1.FAuxQty,
	t1.FAuxStockQty,
	t1.FAuxInHighLimitQty,
	CASE WHEN t1.FStatus=3 THEN 'Y' END AS FEnd,
	t2.FFlowCardNo,
	t5.FName,
	t2.FStartWorkDate,
	t2.FEndWorkDate,
	t4.FID AS FCheckStatus,
	t3.FCheckerID
INTO #TEMP_icmo_FlowCard
FROM ICMO t1
LEFT JOIN SHProcRpt t2 ON t1.FInterID=t2.FICMOInterID
LEFT JOIN SHProcRptMain t3 ON t2.FInterID=t3.FInterID
LEFT  JOIN t_SubMessage t4 ON t3.FCheckStatus=t4.FInterID AND t4.FInterID<>0
LEFT JOIN t_SubMessage t5 ON t2.FOperID=t5.FInterID 
WHERE t4.FID = 'N'
AND t1.FStatus=3
AND t1.FTranType = 85 
AND t1.FType <> 11060

SELECT FFlowCardNo,MIN(autoID) AS autoID
INTO #TEMP_icmo_FlowCard_pre
FROM #TEMP_icmo_FlowCard
GROUP BY FFlowCardNo

SELECT FBillNo as [生产任务单号],
	FAuxQty AS [生产任务单数量],
	FAuxStockQty AS [入库数量],
	FAuxInHighLimitQty AS [入库上限],
	FEnd AS [结案],
	FFlowCardNo AS [流转卡编号],
	FName AS [工序],
	FStartWorkDate AS [实际开工时间],
	FEndWorkDate AS [实际完工时间],
	FCheckStatus AS [审核]
FROM #TEMP_icmo_FlowCard
WHERE autoID IN (SELECT autoID FROM #TEMP_icmo_FlowCard_pre)
ORDER BY FBillNo

DROP TABLE #TEMP_icmo_FlowCard
DROP TABLE #TEMP_icmo_FlowCard_pre




--Select top 1000000 v1.FTranType as FTranType,v1.FInterID as FInterID,v1.Fauxqty as Fauxqty,v1.FAuxStockQty as FAuxStockQty,t9.FQtyDecimal as FQtyDecimal,t9.FPriceDecimal as FPriceDecimal,v1.FAuxInHighLimitQty as FAuxInHighLimitQty from ICMO v1 INNER JOIN t_ICItem t9 ON   v1.FItemID = t9.FItemID  AND t9.FItemID<>0 
-- where 1=1 AND (     
--ISNULL(v1.FBillNo,'') = '55731'
--)  AND (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FStatus=3))
--select top 100 * from SHProcRpt