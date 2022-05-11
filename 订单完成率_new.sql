USE [AIS20100618152307]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER   PROCEDURE [dbo].[p_xy_order_fulfillment_rate]
	@QueryTime as datetime --��ѯʱ�䣬��ʽ��YYYY-MM-DD
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
select [����]=CASE WHEN GROUPING(FDeptName)=1 THEN '�ϼ�' ELSE FDeptName END,
	[��������]=ISNULL(COUNT(FOStockBillNo),0),
	[�ѽ���������]=ISNULL(COUNT(CASE WHEN FMRPClosed=1 THEN FOStockBillNo END),0),
	[�ѽ����������ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FMRPClosed=1 THEN FOStockBillNo END),0)*100/CAST(COUNT(FOStockBillNo) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[δ����������]=ISNULL(COUNT(CASE WHEN FMRPClosed<>1 THEN FOStockBillNo END),0),
	[δ�����������ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FMRPClosed<>1 THEN FOStockBillNo END),0)*100/CAST(COUNT(FOStockBillNo) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[��ǰ����������]=ISNULL(COUNT(CASE WHEN FOverTime<0 THEN FOStockBillNo END),0),
	[��ǰ�����������ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FOverTime<0 THEN FOStockBillNo END),0)*100/CAST(COUNT(FOStockBillNo) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[��ʱ����������]=ISNULL(COUNT(CASE WHEN FOverTime=0 THEN FOStockBillNo END),0),
	[��ʱ�����������ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FOverTime=0 THEN FOStockBillNo END),0)*100/CAST(COUNT(FOStockBillNo) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[����7���ڽ���������]=ISNULL(COUNT(CASE WHEN FOverTime>0 AND FOverTime<=7 THEN FOStockBillNo END),0),
	[����7���ڽ����������ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FOverTime>0 AND FOverTime<=7 THEN FOStockBillNo END),0)*100/CAST(COUNT(FOStockBillNo) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[����1�����ڽ���������]=ISNULL(COUNT(CASE WHEN FOverTime>7 AND FOverTime<=30 THEN FOStockBillNo END),0),
	[����1�����ڽ����������ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FOverTime>7 AND FOverTime<=30 THEN FOStockBillNo END),0)*100/CAST(COUNT(FOStockBillNo) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[����1���½���������]=ISNULL(COUNT(CASE WHEN FOverTime>30 THEN FOStockBillNo END),0),
	[����1���½����������ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FOverTime>30 THEN FOStockBillNo END),0)*100/CAST(COUNT(FOStockBillNo) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%' 
from #temp_Overtime_to_Outcome
group by FDeptName with rollup
INSERT INTO #temp_order_fulfillment_rate(FDeptName)
VALUES('��ע:')
INSERT INTO #temp_order_fulfillment_rate(FDeptName)
VALUES('1.��������Ϊ��ѯ���ڿ�ʼ��ǰ������������δɾ��������˵Ķ������ѽ���������Ϊ��ҵ��رձ�־ΪY�����۶�����')
INSERT INTO #temp_order_fulfillment_rate(FDeptName)
VALUES('2.�ѽ���������Ϊ��ҵ��رձ�־ΪY�����۶�������ٷֱȹ�ʽ:�ѽ���������/��������*100%��')
INSERT INTO #temp_order_fulfillment_rate(FDeptName)
VALUES('3.δ����������Ϊ��ҵ��رձ�־ΪN�����۶�������ٷֱȹ�ʽ:δ����������/��������*100%��')
INSERT INTO #temp_order_fulfillment_rate(FDeptName)
VALUES('4.��ǰ����������Ϊ�������������۶����н������������ǰ�Ķ�������ٷֱȹ�ʽ:��ǰ����������/��������*100%��')
INSERT INTO #temp_order_fulfillment_rate(FDeptName)
VALUES('5.��ʱ����������Ϊ�������ڵ������۶����н������ڵĶ�������ٷֱȹ�ʽ:��ʱ����������/��������*100%��')
INSERT INTO #temp_order_fulfillment_rate(FDeptName)
VALUES('6.����7���ڽ���������Ϊ�������ڲ��������۶����н�������7��ĳ��ڶ�������ٷֱȹ�ʽ:����7���ڽ���������/��������*100%��')
INSERT INTO #temp_order_fulfillment_rate(FDeptName)
VALUES('7.����1�����ڽ���������Ϊ�������ڲ��������۶����н�������1���µĳ��ڶ���(����������7���ڽ�������)����ٷֱȹ�ʽ:����1�����ڽ���������/��������*100%��')
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
select [����]=FDeptName,
	[��������]=FOrderBillCount,
	[�ѽ���������]=FDeliveriedCount,
	[�ѽ����������ٷֱ�]=FDeliveriedRate,
	[δ����������]=FDelayCount,
	[δ�����������ٷֱ�]=FDelayRate,
	[��ǰ����������]=FAdvanceCount,
	[��ǰ�����������ٷֱ�]=FAdvanceRate,
	[��ʱ����������]=FOntimeCount,
	[��ʱ�����������ٷֱ�]=FOntimeRate,
	[����7���ڽ���������]=FDelay7Count,
	[����7���ڽ����������ٷֱ�]=FDelay7Rate,
	[����1�����ڽ���������]=FDelay1mCount,
	[����1�����ڽ����������ٷֱ�]=FDelay1mRate,
	[����1���½���������]=FDelayAbove1mCount,
	[����1���½����������ٷֱ�]=FDelayAbove1mRate 
from #temp_order_fulfillment_rate

DROP TABLE #temp_Ontime_to_Delivery
DROP TABLE #temp_Overtime_to_Outcome
DROP TABLE #temp_order_fulfillment_rate
-- =============================================
-- EXECUTE p_xy_order_fulfillment_rate '2010-03-01'
-- =============================================