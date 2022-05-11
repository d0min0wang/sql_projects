CREATE TABLE #temp_Ontime_to_Delivery(
	FDeptName nvarchar(255),
	FOrderBillNo nvarchar(255),
	FOrderInterID int,
	FOrderItemName nvarchar(255),
	FOrderEntryID int,
	FFetchtime datetime,
	FMRPClosed int)

--CREATE TABLE #temp_Link_1(
--	sutoID int,
--	FDeptName nvarchar(255),
--	FOrderBillNo nvarchar(255),
--	FOrderInterID int,
--	FOrderItemName nvarchar(255),
--	FOrderEntryID int,
--	FFetchTime datetime,
--	FMRPClosed int,
--	FFlowcardNo nvarchar(255),
--	FName nvarchar(255),
--	FEndWorkDate datetime)

CREATE TABLE #temp_Result(
	autoID int,
	FDeptName nvarchar(255),
	FOrderBillNo nvarchar(255),
	FOrderInterID int,
	FOrderItemName nvarchar(255),
	FOrderEntryID int,
	FFetchTime datetime,
	FMRPClosed int,
	FFlowcardNo nvarchar(255),
	FChengxing nvarchar(255),
	FCXEndWorkDate datetime)
--	FJianwei nvarchar(255),
--	FJWEndWorkDate datetime,
--	FBaozhuang nvarchar(255),
--	FBZEndWorkDate datetime)

--CREATE TABLE #temp_Overtime_to_Outcome(
--	FDeptName nvarchar(255),
--	FOrderBillNo nvarchar(255),
--	FOrderItemName nvarchar(255),
--	FMRPClosed int,
--	FOrderEntryID int,
--	FFetchtime datetime,
--	FOStockBillNo nvarchar(255),
--	FOStocktime datetime,
--	FOverTime decimal(10,2))



INSERT INTO #temp_Ontime_to_Delivery
Select t2.FName,v1.FBillNo,v1.FInterID,t3.FName,u1.FEntryID,u1.FDate,u1.FMRPClosed
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON  v1.FInterID = u1.FInterID AND u1.FInterID <>0
LEFT JOIN t_Department t2 on v1.FDeptID=t2.FItemID
LEFT JOIN t_ICItem t3 ON u1.FItemID=t3.FItemID
 where 1=1
AND u1.FMRPClosed=1
--AND (case when u1.FMRPClosed=1 then 'Y' else '' end IS NULL OR case when u1.FMRPClosed=1 then 'Y' else '' end='')
AND (case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end='Y')
AND (case when v1.FCancellation=1 then 'Y' else '' end IS NULL OR case when v1.FCancellation=1 then 'Y' else '' end ='')
AND (v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007100))
AND u1.FDate>=DateAdd(M,-3,getdate())
AND u1.FDate<=getdate()
--AND v1.FBillNo='A101100348'

select identity(int,1,1) as autoID,t1.*,t2.FFlowCardNo,t4.FName,t2.FEndWorkDate
into #template_OTD
from #temp_Ontime_to_Delivery t1
INNER JOIN SHProcRpt t2 ON t1.FOrderBillNo=t2.FOrderBillNo
left join SHProcRptMain t3 ON t2.FInterID=t3.FInterID
LEFT JOIN t_SubMessage t4 ON t2.FOperID=t4.FInterID

select MIN(autoID) as autoID,FOrderBillNo,FOrderEntryID,FName,MAX(FEndWorkDate) as FEndWorkDate into #template_OTD_1
from #template_OTD 
GROUP BY FOrderBillNo,FOrderEntryID,FName
ORDER BY FOrderBillNo,FOrderEntryID,FName

INSERT INTO #temp_Result(
	autoID,
	FOrderBillNo,
	FOrderEntryID,
	FChengxing,
	FCXEndWorkDate)
SELECT * FROM #template_OTD_1 WHERE FNAME='成型'

UPDATE #temp_Result
SET #temp_Result.FDeptName=t2.FdeptName,
	#temp_Result.FOrderInterID=t2.FOrderInterID,
	#temp_Result.FOrderItemName=t2.FOrderItemName,
	#temp_Result.FOrderEntryID=t2.FOrderEntryID,
	#temp_Result.FFetchTime=t2.FFetchTime,
	#temp_Result.FMRPClosed=t2.FMRPClosed,
	#temp_Result.FFlowcardNo=t2.FFlowcardNo
FROM #temp_Result
	LEFT JOIN #template_OTD t2 ON #temp_Result.autoID=t2.autoID

SELECT t1.*,
	t2.FName AS FJianwei,t2.FEndWorkDate AS FJWEndWorkDate,
	t3.FName AS FBaozhuang,t3.FEndWorkDate AS FBZEndWorkDate
FROM #temp_Result t1
	LEFT JOIN #template_OTD_1 t2 ON t1.FOrderBillNo=t2.FOrderBillNo AND t1.FOrderEntryID=t2.FOrderEntryID
	LEFT JOIN #template_OTD_1 t3 ON t1.FOrderBillNo=t3.FOrderBillNo AND t1.FOrderEntryID=t3.FOrderEntryID
where t2.fname='剪尾' AND t3.FName='包装'
	

--select * from #temp_Result	
--select 
--	[部门]=t1.FDeptName,
--	[销售订单号]=t1.FOrderBillNo,
--	[产品名称]=t1.FOrderItemName,
----	[行业务标志]=t1.FMRPClosed,
----	t1.FOrderEntryID,
--	[交货日期]=t1.FFetchtime,
--	[出库单号]=t3.FBillNo,
--	[出库日期]=t3.FCheckDate
--from #temp_Ontime_to_Delivery t1
--left join ICStockBillEntry t2 ON t1.FOrderBillNo=t2.FOrderBillNo AND t1.FOrderEntryID=t2.FOrderEntryID
--left join ICStockBill t3 ON t2.FInterID=t3.FInterID
--where t3.FTranType=21 And t3.FCheckerID>0 

--select * from #temp_Overtime_to_Outcome

DROP TABLE #temp_Ontime_to_Delivery
DROP TABLE #template_OTD
DROP TABLE #template_OTD_1
DROP TABLE #temp_Result
--DROP TABLE #temp_Overtime_to_Outcome
-- =============================================
-- EXECUTE p_xy_order_fulfillment_rate '2010-03-01'
-- =============================================

--select * from t_TableDescription where FDescription like '%工序%'
----210008
----210009
----470000
----1450019
----1450020
--select * from t_FieldDescription where ftableid=1450019
--
--select top 100 FOrderBillNo from SHProcRpt


