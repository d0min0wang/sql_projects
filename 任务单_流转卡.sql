SELECT --IDENTITY(INT,1,1) AS autoID,
	t1.FBillNo,
	t1.FItemID,
	t6.FName AS FItemName,
	t1.FAuxQty,
	t1.FAuxStockQty,
	t1.FAuxInHighLimitQty,
	t1.FPlanCommitDate,
	t1.FCommitDate, 
	CASE WHEN t1.FStatus=3 THEN 'Y' END AS FEnd,
	t1.FPlanFinishDate,
	t1.FCloseDate,
--	t2.FFlowcardInterID,
--	t2.FFlowcardEntryID,
	t2.FID,
	t2.FFlowCardNo,
	t5.FName,
	t3.FActStartDate,
	t3.FActFinishDate,
	t3.FAuxQty AS FAuxQty_0,
	t3.FAuxQtyPass
--	DATEDIFF(day,t1.FPlanFinishDate,t2.FEndWorkDate) as FOverTime,
--	t4.FID AS FCheckStatus,
--	t3.FCheckerID
--INTO #TEMP_icmo_FlowCard
FROM ICMO t1
LEFT JOIN ICShop_FlowCard t2 ON t1.FInterID=t2.FSRCInterID
INNER JOIN ICShop_FlowCardEntry t3  ON t2.FID=t3.FID
--LEFT  JOIN t_SubMessage t4 ON t3.FCheckStatus=t4.FInterID AND t4.FInterID<>0
LEFT JOIN t_SubMessage t5 ON t3.FOperID=t5.FInterID AND t5.FInterID<>0
LEFT JOIN t_ICItem t6 ON t1.FItemID=t6.FItemID AND t6.FItemID<>0
WHERE 
t1.FTranType = 85 
AND t1.FType <> 11060
--AND t5.FName='³ÉÐÍ'
AND t3.FStatus NOT IN (0,1,2)
AND CONVERT(VARCHAR(10),t3.FMOPlanFinishDate,120)>='2011-06-01'
AND CONVERT(VARCHAR(10),t3.FMOPlanFinishDate,120)<='2011-07-10'