SET NOCOUNT ON

USE [AIS20140731101633]
GO
/****** Object:  StoredProcedure [dbo].[p_xy_SupplierCompare]    Script Date: 2014/8/20 10:12:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER	PROCEDURE [dbo].[p_xy_SupplierCompare]
	@FStartDate datetime,
	@FEndDate datetime
AS
SET NOCOUNT ON

select tt1.FItemID,
	tt1.FSupplyID,
	sum(tt1.FAuxQty) as FAuxQty,
	avg(tt1.FTaxPrice) AS FTaxPriceAvg, 
	max(tt1.FTaxPrice) AS FTaxPriceMax, 
	min(tt1.FTaxPrice) AS FTaxPriceMin, 
	sum(tt1.FOverdue) as FOverdue,
	sum(tt1.FRejection) as FRejection,
	sum(tt1.FRework) as FRework,
	sum(tt1.FExchange) as FExchange,
	sum(tt1.FDishonour) as FDishonour,
	sum(tt1.FComplain) as FComplain
into #temp_Supplier
from (select 
	t2.FItemID,
	t1.FSupplyID,
	t2.FAuxQty,
	t2.FEntrySelfA0156 AS FTaxPrice,--含税单价
	case when DATEDIFF(DAY,t6.FDate,t1.FDate)>0 then 1 else 0 end as FOverdue,--超期
	case when (t1.FROB <> 1) then 1 else 0 end as FRejection , --退货（红字）
	0 AS FRework, --返工
	0 AS FExchange, --换货
	0 AS FDishonour, --拒收
	0 AS FComplain
from ICStockBill t1
left join ICStockBillEntry t2 on t1.FInterID=t2.FInterID
left join POOrder t5 on t2.FSourceInterID=t5.FInterID
left join POOrderEntry t6 on t2.FSourceInterID=t6.FInterID and t2.FSourceEntryID=t6.FEntryID
where t1.FTrantype=1
and
t1.FDate>=@FStartDate
and
t1.FDate<=@FEndDate
UNION ALL
select 
	t2.FItemID,
	t1.FSupplyID,
	t2.FAuxQty,
	t2.FEntrySelfA0156,
	0,
	0,
	case when (t1.FROB <> 1) and ISNULL(t7.FName,'') = '返修订单' then 1 else 0 end as FRework,
	case when (t1.FROB <> 1) then 1 else 0 end as FExchange,  --红字入库
	0,
	0
from ICStockBill t1
left join ICStockBillEntry t2 on t1.FInterID=t2.FInterID
left join POOrder t5 on t2.FSourceInterID=t5.FInterID
left join POOrderEntry t6 on t2.FSourceInterID=t6.FInterID and t2.FSourceEntryID=t6.FEntryID
LEFT OUTER JOIN t_Submessage t7 ON   t1.FPurposeID = t7.FInterID  AND t7.FInterID<>0 
where t1.FTrantype=5
and
t1.FDate>=@FStartDate
and
t1.FDate<=@FEndDate
UNION ALL

select t2.FShortNumber,
	t1.FSullyID,
	0,
	0,
	0,
	0,
	0,
	0,
	case when t2.FCheckResult='不合格' then 1 else 0 end as FDishonour,
	0
from t_BOSInspection t1
left join t_BOSInspectionEntry t2 on t1.FInterID=t2.FInterID
--left join t_Submessage t3 on t2.FCheckResult=t3.FInterID
WHERE
t1.FDate>=@FStartDate
and
t1.FDate<=@FEndDate
) tt1
GROUP BY tt1.FItemID,tt1.FSupplyID

select --v1.FItemID,
	v2.FNumber AS 物料代码,
	v2.FName AS 物料名称,
	v2.FModel AS 规格型号,
	v2.FFixLeadTime AS 标准交期,
	--v1.FSupplyID,
	v3.FNumber AS 供应商代码,
	v3.FName AS 供应商名称,
	v1.FAuxQty AS 入库数量,
	v1.FTaxPriceAvg AS 平均单价, 
	v1.FTaxPriceMax AS 最高单价, 
	v1.FTaxPriceMin AS 最低单价, 
	v1.FOverdue AS 超期次数,
	v1.FRejection AS 退货次数,
	v1.FRework AS 返工次数,
	v1.FExchange AS 换货次数,
	v1.FDishonour AS 拒收次数,
	v1.FComplain AS 投诉次数
from #temp_Supplier v1
left join t_ICItem v2 on v1.FItemID=v2.FItemID
left join t_Supplier v3 on v1.FSupplyID=v3.FItemID
ORDER BY v2.FNumber

drop table #temp_Supplier



--FTrantype=1 入库
--FTrantype=5 委外入库

--FROB=-1 红字

--select * from t_Item where fname like '%返工%'

--select * from t_TableDescription where FDescription like '%出入库%'

--select * from t_FieldDescription where FDescription like '%单价%' and FTableID=210009

--select * from ICStockBillEntry

--select * from [dbo].[t_BOSInspection]
--select * from [dbo].[t_BOSInspectionEntry]

--select t2.FItemName,
--	t1.FSullyID,
--	case when t3.FName='不合格' then 1 else 0 end 
--from t_BOSInspection t1
--left join t_BOSInspectionEntry t2 on t1.FInterID=t2.FInterID
--left join t_Submessage t3 on t2.FCheckResult=t3.FInterID


--select t1.FSourceInterID,
--	t1.FSourceEntryID,t1.FEntrySelfA0156,t3.FTaxPrice from ICStockBillEntry t1
----update t1 set t1.FEntrySelfA0156=t3.FTaxPrice
----from ICStockBillEntry t1
--left join ICStockBill t2 on t1.FInterID=t2.FInterID
--left join POOrderEntry t3 on t1.FSourceInterID=t3.FInterID and t1.FSourceEntryID=t3.FEntryID
--where t2.FTrantype=1

-- =============================================
-- example to execute the store procedure
-- EXECUTE p_xy_SupplierCompare '2014-08-01','2014-08-30'
-- =============================================

