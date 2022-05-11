USE [AIS20140921170539]
GO
/****** Object:  StoredProcedure [dbo].[p_xy_order_amiba]    Script Date: 2014/10/27 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER   PROCEDURE [dbo].[p_xy_order_amiba]
	@QueryStartTime as datetime, --查询时间，格式：YYYY-MM-DD
	@QueryEndTime as datetime --查询时间，格式：YYYY-MM-DD
--SET @Querytime='2011-02-28'
AS
SET NOCOUNT ON
--SET ANSI_WARNINGS OFF
--
--
--

IF OBJECT_ID('TEMMPDB..#temp_OrderIDs') IS NOT NULL 
   DROP TABLE  #temp_OrderIDs

IF OBJECT_ID('TEMMPDB..#template_OTD') IS NOT NULL 
	drop table #template_OTD

IF OBJECT_ID('TEMMPDB..#template_OTD_1') IS NOT NULL 
drop table #template_OTD_1

IF OBJECT_ID('TEMMPDB..#template_OTD_2') IS NOT NULL 
drop table #template_OTD_2

IF OBJECT_ID('TEMMPDB..#template_OTD_3') IS NOT NULL 
drop table #template_OTD_3

IF OBJECT_ID('TEMMPDB..#temp_to_delivery_group') IS NOT NULL 
drop table #temp_to_delivery_group

IF OBJECT_ID('TEMMPDB..#temp_to_Delivery') IS NOT NULL 
drop table #temp_to_Delivery

IF OBJECT_ID('TEMMPDB..#TEMP_Stock') IS NOT NULL 
drop table #TEMP_Stock

IF OBJECT_ID('TEMMPDB..#temp_Overtime_to_Outcome') IS NOT NULL 
drop table #temp_Overtime_to_Outcome

IF OBJECT_ID('TEMMPDB..#temp_delivery_table') IS NOT NULL 
drop table #temp_delivery_table

IF OBJECT_ID('TEMMPDB..#temp_Overtime_to_Outcome_table') IS NOT NULL 
drop table #temp_Overtime_to_Outcome_table

IF OBJECT_ID('TEMMPDB..#template_OTD_table') IS NOT NULL 
drop table #template_OTD_table

IF OBJECT_ID('TEMMPDB..#template_OTD_1_table') IS NOT NULL 
drop table #template_OTD_1_table

IF OBJECT_ID('TEMMPDB..#template_OTD_2_table') IS NOT NULL 
drop table #template_OTD_2_table

IF OBJECT_ID('TEMMPDB..#template_OTD_3_table') IS NOT NULL 
drop table #template_OTD_3_table



select FItemID,FQty 
into #TEMP_Stock 
from ICInventory 
where FStockID=14403

--订单数量
Select --identity(int,1,1) as autoID,
	u1.FItemID,
	u1.FAuxQty as FAuxQty,
	u1.FEntrySelfS0156 as FAmount, --含税金额
	u1.FAuxTaxPrice as FPrice,
	u1.FEntrySelfS0162 as FRemailQty, --未出库数
	v1.FInterID as FOrderInterID,
	u1.FEntryID as FOrderEntryID
into #temp_to_Delivery
from SEOrder v1 
LEFT JOIN SEOrderEntry u1 ON  v1.FInterID = u1.FInterID AND u1.FInterID <>0
LEFT JOIN t_Department t2 on v1.FDeptID=t2.FItemID
LEFT JOIN t_ICItem t3 on u1.FItemID=t3.FItemID

LEFT JOIN t_Organization t6 ON v1.FCustID=t6.FItemID
 where 1=1
--AND u1.FMRPClosed=1
--AND (case when u1.FMRPClosed=1 then 'Y' else '' end IS NULL OR case when u1.FMRPClosed=1 then 'Y' else '' end='')
AND (case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end='Y')
AND (case when v1.FCancellation=1 then 'Y' else '' end IS NULL OR case when v1.FCancellation=1 then 'Y' else '' end ='')
AND (v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007100))
--AND (t4.FStockID=14403 OR t4.FStockID IS NULL)
AND CONVERT(VARCHAR(10),u1.FDate,120)>=CONVERT(VARCHAR(10),@QueryStarttime,120)
AND CONVERT(VARCHAR(10),u1.FDate,120)<=CONVERT(VARCHAR(10),@QueryEndtime,120)

select FItemID,
	sum(FAuxQty) AS FAuxQty,
	sum(FAmount) as FAmount,
	avg(FPrice) AS FPrice,
	sum(FRemailQty) as FRemainQty
into #temp_to_delivery_group
from #temp_to_Delivery
group by FItemID

select t1.FItemID,
	t1.FAuxQty,
	t1.FAmount,
	--t1.FPrice,
	t1.FRemainQty,
	t2.FQty AS FImStockQty
into #temp_delivery_table
from #temp_to_delivery_group t1
left join #TEMP_Stock t2 on t1.FItemID=t2.FItemID

select distinct FOrderInterID,FOrderEntryID
into #temp_OrderIDs
from #temp_to_Delivery

--出库数量
select t2.FItemID,
	t2.FAuxQty
INTO #temp_Overtime_to_Outcome
from #temp_OrderIDs t1
left join ICStockBillEntry t2 ON (t1.FOrderInterID=t2.FOrderInterID and t1.FOrderEntryID=t2.FOrderEntryID)
inner join ICStockBill t3 ON t2.FInterID=t3.FInterID
where t3.FTranType=21 And t3.FCheckerID>0 

select FItemID,
	sum(FAuxQty) as FAuxQtyOFOutStock
into #temp_Overtime_to_Outcome_table
from #temp_Overtime_to_Outcome
group by FItemID

--成型数量
select --identity(int,1,1) as autoID_1,
	--t1.autoID AS autoID_2,
	t3.FInterID AS FInterID,
	t3.FItemID,
	t3.FAuxQtyPass AS FAuxQtyPass,
	t3.FAuxWhtPass AS FAuxWhtPass
into #template_OTD
from #temp_OrderIDs t1
LEFT JOIN ICMO t2 ON (t1.FOrderInterID=t2.FOrderInterID AND t1.FOrderEntryID=t2.FSourceEntryID)
left join SHProcRpt t3 ON t2.FInterID=t3.FICMOInterID
left join SHProcRptMain t4 ON t3.FInterID=t4.FInterID
LEFT JOIN t_SubMessage t5 ON t3.FOperID=t5.FInterID
where (t5.FName='成型' OR t5.FName is null) 
--and (CONVERT(VARCHAR(10),t3.FEndWorkDate,120)<=CONVERT(VARCHAR(10),@DeadTimeLine,120)
--OR t3.FEndWorkDate IS NULL)

select FItemID,
	'成型' AS FChengxing,
	sum(FAuxQtyPass) AS FAuxQtyPassCX,
	sum(FAuxWhtPass) AS FAuxWhtPassCX
into #template_OTD_table
from #template_OTD
where FInterID IS NOT NULL
group by FItemID


--剪尾数量
select t1.FInterID AS FInterID,
	t1.FItemID,
	t1.FAuxQtyPass AS FAuxQtyPass,
	t1.FAuxWhtPass AS FAuxWhtPass 
into #template_OTD_1
from SHProcRpt t1
left join t_Submessage t2 ON t1.FOperID=t2.FInterID
where t1.FInterID IN (select distinct FInterID from #template_OTD)
and (t2.FName='剪尾' OR t2.FName is null) 

select FItemID,
	'剪尾' AS FJianwei,
	sum(FAuxQtyPass) AS FAuxQtyPassJW,
	sum(FAuxWhtPass) AS FAuxWhtPassJW
into #template_OTD_1_table
from #template_OTD_1
where FInterID IS NOT NULL
group by FItemID


--包装数量
select t1.FInterID AS FInterID,
	t1.FItemID,
	t1.FAuxQtyPass AS FAuxQtyPass,
	t1.FAuxWhtPass AS FAuxWhtPass 
into #template_OTD_2
from SHProcRpt t1
left join t_Submessage t2 ON t1.FOperID=t2.FInterID
where t1.FInterID IN (select distinct FInterID from #template_OTD)
and (t2.FName='包装' OR t2.FName is null) 

select FItemID,
	'包装' AS FBaozhuang,
	sum(FAuxQtyPass) AS FAuxQtyPassBZ,
	sum(FAuxWhtPass) AS FAuxWhtPassBZ
into #template_OTD_2_table
from #template_OTD_2
where FInterID IS NOT NULL
group by FItemID

--入库数量
select t2.FItemID,
	t2.FAuxQty
INTO #template_OTD_3
FROM ICStockBill t1
left join ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
where t2.FSourceInterId IN (select distinct FInterID from #template_OTD)

select FItemID,
	sum(FAuxQty) AS FAuxQtyOFInstock
into #template_OTD_3_table
from #template_OTD_3
group by FItemID


--合并
select --t1.FItemID ,
	t7.FName as 产品名称,
	t1.FAuxQty as 订单数量,
	t1.FAmount as 金额,
	t1.FImStockQty as 库存,
	t2.FAuxQtyOFOutStock as 出库数,
	t1.FRemainQty as 未出库数,
	--t3.FChengxing as 工序,
	t3.FAuxQtyPassCX as 成型数量,
	--t4.FJianwei as 工序,
	t4.FAuxQtyPassJW as 剪尾数量,
	--t5.FBaozhuang as 工序,
	t5.FAuxQtyPassBZ as 包装数量,
	t6.FAuxQtyOFInstock as 入库数,
	CAST(CAST((t2.FAuxQtyOFOutStock/t1.FAuxQty)*100  as decimal(10,2)) as varchar)+'%' AS 完成率
--into #temp_join_table
from #temp_delivery_table t1
left join #temp_Overtime_to_Outcome_table t2 on t1.FItemID=t2.FItemID
left join #template_OTD_table t3 on t1.FItemID =t3.FItemID 
left join #template_OTD_1_table t4 on t1.FItemID =t4.FItemID 
left join #template_OTD_2_table t5 on t1.FItemID =t5.FItemID 
left join #template_OTD_3_table t6 on t1.FItemID =t6.FItemID 
left join t_ICItem t7 on t1.FItemID=t7.FItemID
union all
select --t1.FItemID ,
	'合计',
	sum(t1.FAuxQty) as 订单数量,
	sum(t1.FAmount) as 金额,
	sum(t1.FImStockQty) as 库存,
	sum(t2.FAuxQtyOFOutStock) as 出库数,
	sum(t1.FRemainQty) as 未出库数,
	--'成型',
	sum(t3.FAuxQtyPassCX) as 成型数量,
	--'剪尾',
	sum(t4.FAuxQtyPassJW) as 剪尾数量,
	--'包装',
	sum(t5.FAuxQtyPassBZ) as 包装数量,
	sum(t6.FAuxQtyOFInstock) as 入库数,
	--CAST(CAST(ABS(C_Money-P_Money)*100/P_Money as decimal(10,2)) as varchar)+'%'
	CAST(CAST((sum(t2.FAuxQtyOFOutStock)/sum(t1.FAuxQty) )*100  as decimal(10,2)) as varchar)+'%'
--into #temp_join_table
from #temp_delivery_table t1
left join #temp_Overtime_to_Outcome_table t2 on t1.FItemID=t2.FItemID
left join #template_OTD_table t3 on t1.FItemID =t3.FItemID 
left join #template_OTD_1_table t4 on t1.FItemID =t4.FItemID 
left join #template_OTD_2_table t5 on t1.FItemID =t5.FItemID 
left join #template_OTD_3_table t6 on t1.FItemID =t6.FItemID

drop table #temp_OrderIDs
drop table #template_OTD
drop table #template_OTD_1
drop table #template_OTD_2
drop table #template_OTD_3
drop table #temp_to_delivery_group
drop table #temp_to_Delivery
drop table #TEMP_Stock
drop table #temp_Overtime_to_Outcome

drop table #temp_delivery_table
drop table #temp_Overtime_to_Outcome_table
drop table #template_OTD_table
drop table #template_OTD_1_table
drop table #template_OTD_2_table
drop table #template_OTD_3_table

--drop table #temp_join_table


--select *
--from ICInventory 
--where FStockID=14403

-- =============================================
-- EXECUTE p_xy_order_amiba '2014-09-09','2014-09-09'
-- =============================================