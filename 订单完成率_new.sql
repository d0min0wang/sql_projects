USE [AIS20100618152307]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER   PROCEDURE [dbo].[p_xy_order_fulfillment_rate]
	@QueryTime as datetime --查询时间，格式：YYYY-MM-DD
--SET @Querytime='2011-02-28'
AS
SET NOCOUNT ON

CREATE TABLE #temp_Ontime_to_Delivery(
	FDeptName nvarchar(255),
	FOrderBillNo nvarchar(255),
	FOrderEntryID int,
	FFetchtime datetime,
	FMRPClosed int)

CREATE TABLE #temp_Overtime_to_Outcome(
	FDeptName nvarchar(255),
	FOrderBillNo nvarchar(255),
	FMRPClosed int,
	FOrderEntryID int,
	FFetchtime datetime,
	FOStockBillNo nvarchar(255),
	FOStocktime datetime,
	FOverTime decimal(10,2))


CREATE TABLE #temp_order_fulfillment_rate(
	FDeptName nvarchar(255),
	FOrderBillCount int,
	FDeliveriedCount int,
	FDeliveriedRate nvarchar(255),
	FDelayCount int,
	FDelayRate nvarchar(255),
	FAdvanceCount int,
	FAdvanceRate nvarchar(255),	
	FOntimeCount int,
	FOntimeRate nvarchar(255),	
	FDelay7Count int,
	FDelay7Rate nvarchar(255),	
	FDelay1mCount int,
	FDelay1mRate nvarchar(255),	
	FDelayAbove1mCount int,
	FDelayAbove1mRate nvarchar(255))

INSERT INTO #temp_Ontime_to_Delivery
Select t2.FName,v1.FBillNo,u1.FEntryID,u1.FDate,u1.FMRPClosed
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON  v1.FInterID = u1.FInterID AND u1.FInterID <>0
LEFT JOIN t_Department t2 on v1.FDeptID=t2.FItemID
 where 1=1
--AND u1.FMRPClosed=1
--AND (case when u1.FMRPClosed=1 then 'Y' else '' end IS NULL OR case when u1.FMRPClosed=1 then 'Y' else '' end='')
AND (case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end='Y')
AND (case when v1.FCancellation=1 then 'Y' else '' end IS NULL OR case when v1.FCancellation=1 then 'Y' else '' end ='')
AND (v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007100))
AND u1.FDate>=DateAdd(M,-1,@Querytime)
AND u1.FDate<=@Querytime
--AND v1.FBillNo='A101100348'

INSERT INTO #temp_Overtime_to_Outcome
select t1.FDeptName,t1.FOrderBillNo,t1.FMRPClosed,t1.FOrderEntryID,t1.FFetchtime,t3.FBillNo,t3.FCheckDate,DATEDIFF(day,t1.FFetchtime,t3.FCheckDate) AS FOverTime
from #temp_Ontime_to_Delivery t1
left join ICStockBillEntry t2 ON t1.FOrderBillNo=t2.FOrderBillNo AND t1.FOrderEntryID=t2.FOrderEntryID
left join ICStockBill t3 ON t2.FInterID=t3.FInterID
where t3.FTranType=21 And t3.FCheckerID>0 
--AND t2.FOrderBillNo='A101100348'

INSERT INTO #temp_order_fulfillment_rate
select [部门]=CASE WHEN GROUPING(FDeptName)=1 THEN '合计' ELSE FDeptName END,
	[订单总数]=ISNULL(COUNT(FOStockBillNo),0),
	[已交货订单数]=ISNULL(COUNT(CASE WHEN FMRPClosed=1 THEN FOStockBillNo END),0),
	[已交货订单数百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FMRPClosed=1 THEN FOStockBillNo END),0)*100/CAST(COUNT(FOStockBillNo) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[未交货订单数]=ISNULL(COUNT(CASE WHEN FMRPClosed<>1 THEN FOStockBillNo END),0),
	[未交货订单数百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FMRPClosed<>1 THEN FOStockBillNo END),0)*100/CAST(COUNT(FOStockBillNo) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[提前交货订单数]=ISNULL(COUNT(CASE WHEN FOverTime<0 THEN FOStockBillNo END),0),
	[提前交货订单数百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FOverTime<0 THEN FOStockBillNo END),0)*100/CAST(COUNT(FOStockBillNo) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[按时交货订单数]=ISNULL(COUNT(CASE WHEN FOverTime=0 THEN FOStockBillNo END),0),
	[按时交货订单数百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FOverTime=0 THEN FOStockBillNo END),0)*100/CAST(COUNT(FOStockBillNo) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[超期7天内交货订单数]=ISNULL(COUNT(CASE WHEN FOverTime>0 AND FOverTime<=7 THEN FOStockBillNo END),0),
	[超期7天内交货订单数百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FOverTime>0 AND FOverTime<=7 THEN FOStockBillNo END),0)*100/CAST(COUNT(FOStockBillNo) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[超期1个月内交货订单数]=ISNULL(COUNT(CASE WHEN FOverTime>7 AND FOverTime<=30 THEN FOStockBillNo END),0),
	[超期1个月内交货订单数百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FOverTime>7 AND FOverTime<=30 THEN FOStockBillNo END),0)*100/CAST(COUNT(FOStockBillNo) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[超期1个月交货订单数]=ISNULL(COUNT(CASE WHEN FOverTime>30 THEN FOStockBillNo END),0),
	[超期1个月交货订单数百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FOverTime>30 THEN FOStockBillNo END),0)*100/CAST(COUNT(FOStockBillNo) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%' 
from #temp_Overtime_to_Outcome
group by FDeptName with rollup
INSERT INTO #temp_order_fulfillment_rate(FDeptName)
VALUES('备注:')
INSERT INTO #temp_order_fulfillment_rate(FDeptName)
VALUES('1.订单总数为查询日期开始往前三个月内所有未删除、已审核的订单；已交货订单数为行业务关闭标志为Y的销售订单；')
INSERT INTO #temp_order_fulfillment_rate(FDeptName)
VALUES('2.已交货订单数为行业务关闭标志为Y的销售订单，其百分比公式:已交货订单数/订单总数*100%；')
INSERT INTO #temp_order_fulfillment_rate(FDeptName)
VALUES('3.未交货订单数为行业务关闭标志为N的销售订单，其百分比公式:未交货订单数/订单总数*100%；')
INSERT INTO #temp_order_fulfillment_rate(FDeptName)
VALUES('4.提前交货订单数为出库日期与销售订单中交货日期相比提前的订单，其百分比公式:提前交货订单数/订单总数*100%；')
INSERT INTO #temp_order_fulfillment_rate(FDeptName)
VALUES('5.按时交货订单数为出库日期等于销售订单中交货日期的订单，其百分比公式:按时交货订单数/订单总数*100%；')
INSERT INTO #temp_order_fulfillment_rate(FDeptName)
VALUES('6.超期7天内交货订单数为出库日期不超过销售订单中交货日期7天的超期订单，其百分比公式:超期7天内交货订单数/订单总数*100%；')
INSERT INTO #temp_order_fulfillment_rate(FDeptName)
VALUES('7.超期1个月内交货订单数为出库日期不超过销售订单中交货日期1个月的超期订单(不包括超期7天内交货订单)，其百分比公式:超期1个月内交货订单数/订单总数*100%；')
--CAST(CAST(ABS(C_Money-L_Money)*100/(CASE WHEN L_Money =0 THEN 1 ELSE L_Money END) as decimal(10,2)) as varchar)+'%'

--select FDeptName,FOverTime,COUNT(FOStockBillNo) from #temp_Overtime_to_Outcome
--group by FDeptName,FOverTime
--order by FDeptName,FOverTime
--

--select t1.FBillNo,t2.FOrderBillNo,t2.FOrderEntryID,t2.FOrderInterID,t1.FCheckDate
--from ICStockBill t1
--LEFT JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
--where t1.FTranType=21 And t1.FCheckerID>0 
--AND t2.FOrderBillNo='A101100348'
select [部门]=FDeptName,
	[订单总数]=FOrderBillCount,
	[已交货订单数]=FDeliveriedCount,
	[已交货订单数百分比]=FDeliveriedRate,
	[未交货订单数]=FDelayCount,
	[未交货订单数百分比]=FDelayRate,
	[提前交货订单数]=FAdvanceCount,
	[提前交货订单数百分比]=FAdvanceRate,
	[按时交货订单数]=FOntimeCount,
	[按时交货订单数百分比]=FOntimeRate,
	[超期7天内交货订单数]=FDelay7Count,
	[超期7天内交货订单数百分比]=FDelay7Rate,
	[超期1个月内交货订单数]=FDelay1mCount,
	[超期1个月内交货订单数百分比]=FDelay1mRate,
	[超期1个月交货订单数]=FDelayAbove1mCount,
	[超期1个月交货订单数百分比]=FDelayAbove1mRate 
from #temp_order_fulfillment_rate

DROP TABLE #temp_Ontime_to_Delivery
DROP TABLE #temp_Overtime_to_Outcome
DROP TABLE #temp_order_fulfillment_rate
-- =============================================
-- EXECUTE p_xy_order_fulfillment_rate '2010-03-01'
-- =============================================