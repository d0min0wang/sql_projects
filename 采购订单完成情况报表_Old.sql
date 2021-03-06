USE [AIS20140731101633]
GO
/****** Object:  StoredProcedure [dbo].[p_xy_POOerQueryRpt]    Script Date: 2014/8/20 10:12:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER	PROCEDURE [dbo].[p_xy_POOerQueryRpt]
	@FStartDate datetime,
	@FEndDate datetime
AS
SET NOCOUNT ON

select 
	tt1.FDeptName as 部门,
	tt1.FDate as 日期,
	tt1.FBillNo as 订单号,
	tt1.FSupplierName as 供应商,
	tt1.FNumber as 物料代码,
	tt1.FProdName as 物料名称,
	tt1.FDeliverDate as 采购日期,
	tt1.FAPurchTime as 建议交期,
	tt1.FAuxTaxPrice as 单价,
	tt1.FAllAmount as 金额,
	tt1.FEntrySelfP0247 as 订单余量,
	tt1.FEntrySelfP0248 as 订单余额,
	tt1.FEntrySelfP0249 as 超交期天数,
	tt1.FEntrySelfP0250 as 付款状况	 
from
(
select --t5.FDeptID,
	t6.FName  AS FDeptName,
	t1.FDate AS FDate,
	t1.FBillNo,
	--t1.FSupplyID,
	t7.FName as FSupplierName,
	--t2.FItemID,
	t3.FNumber,
	t3.FName as FProdName,
	t2.FDate AS FDeliverDate,
	--t2.FSourceInterID,
	--t2.FSourceEntryID,
	t4.FAPurchTime,
	t2.FAuxTaxPrice,
	t2.FAllAmount,
	t2.FEntrySelfP0247,
	t2.FEntrySelfP0248,
	t2.FEntrySelfP0249,
	t2.FEntrySelfP0250,
	0 AS FOrderCol
from POOrder t1
left join POOrderEntry t2 on t1.FInterID=t2.FInterID
left join t_Item t3 on t2.FItemID=t3.FItemID
left join PORequestEntry  t4 on t2.FSourceInterID=t4.FInterID and t2.FSourceEntryID=t4.FEntryID
left join PORequest  t5 on t4.FInterID=t5.FInterID
left join t_Department t6 on t5.FDeptID=t6.FItemID
left join t_Supplier t7 on t1.FSupplyID=t7.FItemID
where 
CONVERT(varchar(10), t1.FDate, 23)>=@FStartDate
and
CONVERT(varchar(10), t1.FDate, 23)<=@FEndDate

union all

select --t5.FDeptID,
	t6.FName+'合计' AS FDeptName,
	'',
	'',
	--t1.FSupplyID,
	'',
	--t2.FItemID,
	'',
	'',
	'',
	--t2.FSourceInterID,
	--t2.FSourceEntryID,
	'',
	sum(t2.FAuxTaxPrice),
	sum(t2.FAllAmount),
	sum(t2.FEntrySelfP0247) as 订单余量,
	sum(t2.FEntrySelfP0248) as 订单余额,
	avg(t2.FEntrySelfP0249) as 超交期天数,
	sum(t2.FEntrySelfP0250) as 付款状况,
	1
from POOrder t1
left join POOrderEntry t2 on t1.FInterID=t2.FInterID
left join t_Item t3 on t2.FItemID=t3.FItemID
left join PORequestEntry  t4 on t2.FSourceInterID=t4.FInterID and t2.FSourceEntryID=t4.FEntryID
left join PORequest  t5 on t4.FInterID=t5.FInterID
left join t_Department t6 on t5.FDeptID=t6.FItemID
left join t_Supplier t7 on t1.FSupplyID=t7.FItemID
where
CONVERT(varchar(10), t1.FDate, 23)>=@FStartDate
and
CONVERT(varchar(10), t1.FDate, 23)<=@FEndDate
group by t6.FName)tt1

order by FDeptName,FOrderCol


--select * from t_TableDescription where Ftablename='ICSubContractEntry'

--select * from t_FieldDescription where ftableid=1440015
--select * from ICSubContractEntry

--select * from t_Item

-- =============================================
-- example to execute the store procedure
-- EXECUTE p_xy_POOerQueryRpt '2014-08-01','2014-08-30'
-- =============================================

