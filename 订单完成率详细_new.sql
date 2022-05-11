CREATE TABLE #temp_Ontime_to_Delivery(
	FDeptName nvarchar(255),
	FOrderBillNo nvarchar(255),
	FOrderItemName nvarchar(255),
	FOrderEntryID int,
	FFetchtime datetime,
	FMRPClosed int)

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
Select t2.FName,v1.FBillNo,t3.FName,u1.FEntryID,u1.FDate,u1.FMRPClosed
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON  v1.FInterID = u1.FInterID AND u1.FInterID <>0
LEFT JOIN t_Department t2 on v1.FDeptID=t2.FItemID
LEFT JOIN t_ICItem t3 ON u1.FItemID=t3.FItemID
 where 1=1
--AND u1.FMRPClosed=1
--AND (case when u1.FMRPClosed=1 then 'Y' else '' end IS NULL OR case when u1.FMRPClosed=1 then 'Y' else '' end='')
AND (case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end='Y')
AND (case when v1.FCancellation=1 then 'Y' else '' end IS NULL OR case when v1.FCancellation=1 then 'Y' else '' end ='')
AND (v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007100))
AND u1.FDate>=DateAdd(M,-3,getdate())
AND u1.FDate<=getdate()
--AND v1.FBillNo='A101100348'

select 
	[部门]=t1.FDeptName,
	[销售订单号]=t1.FOrderBillNo,
	[产品名称]=t1.FOrderItemName,
--	[行业务标志]=t1.FMRPClosed,
--	t1.FOrderEntryID,
	[交货日期]=t1.FFetchtime,
	[出库单号]=t3.FBillNo,
	[出库日期]=t3.FCheckDate,
	[延期时间]=DATEDIFF(day,t1.FFetchtime,t3.FCheckDate)
from #temp_Ontime_to_Delivery t1
left join ICStockBillEntry t2 ON t1.FOrderBillNo=t2.FOrderBillNo AND t1.FOrderEntryID=t2.FOrderEntryID
left join ICStockBill t3 ON t2.FInterID=t3.FInterID
where t3.FTranType=21 And t3.FCheckerID>0 
AND DATEDIFF(day,t1.FFetchtime,t3.FCheckDate)>=1
AND DATEDIFF(day,t1.FFetchtime,t3.FCheckDate)<=7
--AND t2.FOrderBillNo='A101100348'

--select * from #temp_Overtime_to_Outcome

DROP TABLE #temp_Ontime_to_Delivery
--DROP TABLE #temp_Overtime_to_Outcome
-- =============================================
-- EXECUTE p_xy_order_fulfillment_rate '2010-03-01'
-- =============================================