SET NOCOUNT ON

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

DECLARE @FStockBillNo varchar(255)
DECLARE @FStockTime varchar(255)

SELECT OS.* INTO #Temp FROM(
SELECT 0 AS FDepart,
	0 AS FSumSort,
	u1.FInterID,
	u1.FEntryID,
	u1.FItemID as FItemID,
	v1.FEmpID as FEmpID,
	t5.FDeptID as FDeptID,
	v1.FSupplyID as FSupplyID,
	ts.FNumber AS FSupplierNumber,
	ts.FName AS FSupplierName,
	v1.FBillNo,
	td.FName AS FDeptName,
	v1.FDate AS FDate,
	u1.FDate AS FDateDelivery,
	t.FNumber AS FNumber,
	t.FName AS FName,
	t.FModel,
	ta.FName AS FAuxPropName,
	tm.FName AS FUnitName,
	tc.FName AS FCurrencyName,
	u1.FAuxQty,u1.FAuxPriceDiscount,
	u1.FAllAmount,
	u1.FAllAmount * v1.FExchangeRate AS FAllAmountFor,
	@FStockBillNo AS FStockBillNo,
	@FStockTime AS FStockDate,
	0 AS FOverdue,
	ISNULL(u1.FAuxStockQty,0) AS FAuxStockQtyCommit,
	u1.FAuxQty-ISNULL(u1.FAuxStockQty,0) AS FAuxStockQtyUnCommit,
	ISNULL(u1.FAuxQtyInvoice,0) AS FAuxQtyInvoice,
	u1.FAuxQty-ISNULL(u1.FAuxQtyInvoice,0) AS FAuxQtyInvoiceUnCommit,
	ISNULL(tp.FStdAllAmount,0)/v1.FExchangeRate AS FAmountInvoice,
	u1.FAllAmount-ISNULL(tp.FStdAllAmount,0)/v1.FExchangeRate AS FAmountInvoiceUnCommit,
	ISNULL(u1.FReceiveAmountFor_Commit,0) AS FReceiveAmountForCommit,
	u1.FAllAmount-ISNULL(u1.FReceiveAmountFor_Commit,0) AS FReceiveAmountForUnCommit,
	CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END AS FClosed,
	CASE WHEN u1.FMrpClosed = 1 THEN 'Y' ELSE '' END AS FMrpClosed,t.FPriceDecimal,t.FQtyDecimal
FROM POOrder v1
LEFT JOIN POOrderEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN t_Supplier ts ON ts.FItemID=v1.FSupplyID
LEFT JOIN t_AuxItem ta ON ta.FItemID=u1.FAuxPropID
LEFT JOIN t_MeasureUnit tm ON tm.FMeasureUnitID = u1.FUnitID
LEFT JOIN t_Currency tc ON tc.FCurrencyID=v1.FCurrencyID
LEFT JOIN t_ICItem t ON t.FItemID=u1.FItemID
LEFT JOIN t_Emp te ON te.FItemID=v1.FEmpID
left join PORequestEntry  t4 on u1.FSourceInterID=t4.FInterID and u1.FSourceEntryID=t4.FEntryID
left join PORequest  t5 on t4.FInterID=t5.FInterID
LEFT JOIN t_Department td ON td.FItemID=t5.FDeptID
LEFT JOIN (
          SELECT FOrderInterID,
				FOrderEntryID,
				SUM(FStdAllAmount) AS FStdAllAmount 
			FROM (
                 SELECT ui.FOrderInterID,
						ui.FOrderEntryID,
                        SUM(ui.FStdAmount + CASE WHEN vi.FTranType IN(76,603) THEN 0 ELSE ui.FStdTaxAmount END) AS FStdAllAmount
                 FROM ICPurchase vi
                 LEFT JOIN ICPurchaseEntry ui ON vi.FInterID=ui.FInterID
                 WHERE ISNULL(vi.FCancellation, 0) = 0 And ui.FOrderInterID > 0 And ui.FEntryID > 0 AND ui.FOrderType=71 AND vi.FInterID NOT IN(SELECT DIStINCT FBillID FROM ICBillRelations_Purchase)
                 GROUP BY ui.FOrderInterID,ui.FOrderEntryID
          UNION ALL
                 SELECT ti.FOrderInterID,
						ti.FOrderEntryID,
						SUM(tl.FQty*ui.FPrice*FExchangeRate + CASE WHEN vi.FTranType IN(76,603) THEN 0 ELSE tl.FQty*ui.FPrice*ui.FTaxRate*FExchangeRate/100 END) AS FStdAllAmount
                 FROM ICPurchase vi
                 LEFT JOIN ICPurchaseEntry ui ON vi.FInterID=ui.FInterID
                 INNER JOIN ICBillRelations_Purchase tl ON vi.FInterID=tl.FBillID
                 INNER JOIN ICStockBillEntry ti ON ti.FInterID=tl.FMultiInterID AND ti.FEntryID=tl.FMultiEntryID
                 WHERE ISNULL(vi.FCancellation, 0) = 0 And ui.FOrderInterID > 0 And ui.FEntryID > 0 AND ui.FOrderType=71
                 GROUP BY ti.FOrderInterID,ti.FOrderEntryID) t GROUP BY FOrderInterID,FOrderEntryID
          ) tp ON u1.FInterID=tp.FOrderInterID AND u1.FEntryID=tp.FOrderEntryID
WHERE v1.FStatus>0 AND v1.FCancellation =0 
AND v1.FClassTypeID<>1007101 
AND v1.FDate>=@FStartDate AND v1.FDate<=@FEndDate 
--AND td.FNumber>='04.02' AND td.FNumber<='04.03'
UNION ALL
SELECT 0 AS FDepart,
	0 AS FSumSort,
	u1.FInterID,
	u1.FEntryID,
	u1.FItemID as FItemID,
	v1.FEmployee as FEmpID,
	v1.FDepartment as FDeptID,
	v1.FSupplyID as FSupplyID,
	ts.FNumber AS FSupplierNumber,
	ts.FName AS FSupplierName,
	v1.FBillNo,
	td.FName AS FDeptName,
	v1.FDate AS FDate,
	u1.FFetchDate AS FDateDelivery,
	t.FNumber AS FNumber,
	t.FName AS FName,
	t.FModel,ta.FName AS FAuxPropName,
	tm.FName AS FUnitName,
	tc.FName AS FCurrencyName,
	u1.FAuxQty,
	u1.FAuxPriceDiscount,
	u1.FAllAmount,
	u1.FAllAmount * v1.FExchangeRate AS FAllAmountFor,
	@FStockBillNo AS FStockBillNo,
	@FStockTime AS FStockDate,
	0 AS FOverdue,
	ISNULL(u1.FAuxStockQty,0) AS FAuxStockQtyCommit,u1.FAuxQty-ISNULL(u1.FAuxStockQty,0) AS FAuxStockQtyUnCommit,
	ISNULL(u1.FAuxQtyInvoice,0) AS FAuxQtyInvoice,u1.FAuxQty-ISNULL(u1.FAuxQtyInvoice,0) AS FAuxQtyInvoiceUnCommit,
	ISNULL(tp.FStdAllAmount,0)/v1.FExchangeRate AS FAmountInvoice,
	u1.FAllAmount-ISNULL(tp.FStdAllAmount,0)/v1.FExchangeRate AS FAmountInvoiceUnCommit,
	ISNULL(u1.FReceiveAmountFor_Commit,0) AS FReceiveAmountForCommit,
	u1.FAllAmount-ISNULL(u1.FReceiveAmountFor_Commit,0) AS FReceiveAmountForUnCommit,
	CASE WHEN v1.FClosed = 1 THEN 'Y' ELSE '' END AS FClosed,
	CASE WHEN u1.FMrpClosed = 1 THEN 'Y' ELSE '' END AS FMrpClosed,t.FPriceDecimal,t.FQtyDecimal
FROM ICSubContract v1
LEFT JOIN ICSubContractEntry u1 ON v1.FInterID=u1.FInterID
LEFT JOIN t_Supplier ts ON ts.FItemID=v1.FSupplyID
LEFT JOIN t_AuxItem ta ON ta.FItemID=u1.FAuxPropID
LEFT JOIN t_MeasureUnit tm ON tm.FMeasureUnitID = u1.FUnitID
LEFT JOIN t_Currency tc ON tc.FCurrencyID=v1.FCurrencyID
LEFT JOIN t_ICItem t ON t.FItemID=u1.FItemID
LEFT JOIN t_Emp te ON te.FItemID=v1.FEmployee
left join PORequestEntry  t4 on u1.FInterID_SRC=t4.FInterID and u1.FEntryID_SRC=t4.FEntryID
left join PORequest  t5 on t4.FInterID=t5.FInterID
LEFT JOIN t_Department td ON td.FItemID=t5.FDeptID
LEFT JOIN (
          SELECT FOrderInterID,FOrderEntryID,SUM(FStdAllAmount) AS FStdAllAmount FROM (
                 SELECT ui.FOrderInterID,ui.FOrderEntryID,
                        SUM(ui.FStdAmount + CASE WHEN vi.FTranType IN(76,603) THEN 0 ELSE ui.FStdTaxAmount END) AS FStdAllAmount
                 FROM ICPurchase vi
                 LEFT JOIN ICPurchaseEntry ui ON vi.FInterID=ui.FInterID
                 WHERE ISNULL(vi.FCancellation, 0) = 0 And ui.FOrderInterID > 0 And ui.FEntryID > 0 AND ui.FOrderType=1007105 AND vi.FInterID NOT IN(SELECT DIStINCT FBillID FROM ICBillRelations_Purchase)
                 GROUP BY ui.FOrderInterID,ui.FOrderEntryID
          UNION ALL
                 SELECT ti.FOrderInterID,ti.FOrderEntryID,
                 SUM(tl.FQty*ui.FPrice*FExchangeRate + CASE WHEN vi.FTranType IN(76,603) THEN 0 ELSE tl.FQty*ui.FPrice*ui.FTaxRate*FExchangeRate/100 END) AS FStdAllAmount
                 FROM ICPurchase vi
                 LEFT JOIN ICPurchaseEntry ui ON vi.FInterID=ui.FInterID
                 INNER JOIN ICBillRelations_Purchase tl ON vi.FInterID=tl.FBillID
                 INNER JOIN ICStockBillEntry ti ON ti.FInterID=tl.FMultiInterID AND ti.FEntryID=tl.FMultiEntryID
                 WHERE ISNULL(vi.FCancellation, 0) = 0 And ui.FOrderInterID > 0 And ui.FEntryID > 0 AND ui.FOrderType=1007105
                 GROUP BY ti.FOrderInterID,ti.FOrderEntryID) t GROUP BY FOrderInterID,FOrderEntryID
          ) tp ON u1.FInterID=tp.FOrderInterID AND u1.FEntryID=tp.FOrderEntryID
WHERE v1.FStatus>0 AND v1.FCancellation =0  
AND v1.FDate>=@FStartDate AND v1.FDate<=@FEndDate
--AND td.FNumber>='04.02' AND td.FNumber<='04.03'
--UNION ALL

) OS
IF EXISTS(SELECT TOP 1 FSumSort FROM #Temp WHERE FSumSort=0)
BEGIN
INSERT INTO #Temp(FDepart,
		FSumSort,
		FSupplierNumber,
		FItemID,
		FEmpID,
		FDeptID,
		FSupplyID,
		FBillNo,
		FClosed,
		FMrpClosed,
		FAuxQty,
		FAllAmount,
		FAllAmountFor,
		FStockDate,
		FOverdue,
		FAuxStockQtyCommit,
		FAuxStockQtyUnCommit,
		FAuxQtyInvoice,
		FAuxQtyInvoiceUnCommit,
		FAmountInvoice , 
		FAmountInvoiceUnCommit, 
		FReceiveAmountForCommit,
		FReceiveAmountForUnCommit) 
SELECT 1,101,
	'合计',
	0,
	0,
	0,
	0,
	'',
	'',
	'',
	SUM(ISNULL(FAuxQty,0)),
	SUM(ISNULL(FAllAmount,0)),
	SUM(ISNULL(FAllAmountFor,0)),
	'',
	0,
	SUM(ISNULL(FAuxStockQtyCommit,0)),
	SUM(ISNULL(FAuxStockQtyUnCommit,0)),
	SUM(ISNULL(FAuxQtyInvoice,0)),
	SUM(ISNULL(FAuxQtyInvoiceUnCommit,0)),
	SUM(ISNULL(FAmountInvoice,0)),
	SUM(ISNULL(FAmountInvoiceUnCommit,0)),
	SUM(ISNULL(FReceiveAmountForCommit,0)),
	SUM(ISNULL(FReceiveAmountForUnCommit,0))  
FROM #Temp
END 

--IF EXISTS(SELECT TOP 1 FSumSort FROM #Temp WHERE FSumSort=0)
--BEGIN
--INSERT INTO #Temp(FDepart,
--		FSumSort,
--		--FSupplierNumber,
--		FItemID,
--		FEmpID,
--		FDeptID,
--		FSupplyID,
--		FBillNo,
--		FDeptName,
--		FClosed,
--		FMrpClosed,
--		FAuxQty,
--		FAllAmount,
--		FAllAmountFor,
--		FStockDate,
--		FOverdue,
--		FAuxStockQtyCommit,
--		FAuxStockQtyUnCommit,
--		FAuxQtyInvoice,
--		FAuxQtyInvoiceUnCommit,
--		FAmountInvoice , 
--		FAmountInvoiceUnCommit, 
--		FReceiveAmountForCommit,
--		FReceiveAmountForUnCommit) 
--SELECT 1,101,
--	--0,
--	0,
--	0,
--	0,
--	0,
--	'',
--	FDeptName+' 合计',
--	'',
--	'',
--	SUM(ISNULL(FAuxQty,0)),
--	SUM(ISNULL(FAllAmount,0)),
--	SUM(ISNULL(FAllAmountFor,0)),
--	'1900-01-01',
--	0,
--	SUM(ISNULL(FAuxStockQtyCommit,0)),
--	SUM(ISNULL(FAuxStockQtyUnCommit,0)),
--	SUM(ISNULL(FAuxQtyInvoice,0)),
--	SUM(ISNULL(FAuxQtyInvoiceUnCommit,0)),
--	SUM(ISNULL(FAmountInvoice,0)),
--	SUM(ISNULL(FAmountInvoiceUnCommit,0)),
--	SUM(ISNULL(FReceiveAmountForCommit,0)),
--	SUM(ISNULL(FReceiveAmountForUnCommit,0))  
--FROM #Temp
--GROUP BY  FDeptName
--END 

INSERT INTO #Temp(FDepart,
		FSumSort,
		FInterID,
		FEntryID,
		FSupplierNumber,
		FItemID,
		FEmpID,
		FDeptID,
		FSupplyID,
		FBillNo,
		FClosed,
		FMrpClosed,
		FAuxQty,
		FAllAmount,
		FAllAmountFor,
		FStockBillNo,
		FStockDate,
		FOverdue,
		FAuxStockQtyCommit,
		FAuxStockQtyUnCommit,
		FAuxQtyInvoice,
		FAuxQtyInvoiceUnCommit,
		FAmountInvoice , 
		FAmountInvoiceUnCommit, 
		FReceiveAmountForCommit,
		FReceiveAmountForUnCommit
	)
select 
	0,
	1,
	t2.FSourceInterID,
	t2.FSourceEntryID,
	0,
	0,
	0,
	0,
	0,
	t3.FBillNo+' 入库单',
	'',
	'',
	0,
	0,
	0,
	t1.FBillNo,
	CONVERT(varchar(10), t1.FDate, 23),
	DATEDIFF(DAY,t4.FDate,t1.FDate),
	t2.FAuxQty,
	0,
	0,
	0,
	0,
	0,
	0,
	0
from ICStockBill t1
left join ICStockBillEntry t2 on t1.FInterID=t2.FInterID
left join POOrder t3 on t2.FSourceInterID=t3.FInterID
left join POOrderEntry t4 on t2.FSourceInterID=t4.FInterID and t2.FSourceEntryID=t4.FEntryID
where t1.FTrantype=1
and t2.FSourceInterID in 
(Select  FinterID From POOrder where FDate>='2014-08-01' AND FDate<='2014-08-20' )

SELECT
	FSupplierNumber as 供应商代码,
	FSupplierName AS 供应商名称,
	FBillNo as 订单编号,
	FDeptName as 部门,
	FDate AS 单据日期,
	FDateDelivery AS 交货日期,
	FNumber AS 物料代码,
	FName AS 物料名称,
	FModel AS 规格型号,
	FUnitName AS 辅助属性,
	FClosed AS 关闭标志,
	FMrpClosed AS 行业关闭标志,
	FUnitName AS 单位,
	FCurrencyName AS 币别,
	FAuxQty AS 数量,
	FAuxPriceDiscount AS 实际含税单价,
	FAllAmount AS 价税合计,
	FAllAmountFor AS [价税合计(本位币)],
	FStockBillNo AS 入库单编号,
	FStockDate AS 入库日期,
	FOverdue AS 超期天数,
	FAuxStockQtyCommit AS 入库数量,
	FAuxStockQtyUnCommit AS 未入库数量,
	FAuxQtyInvoice AS 已开票数量,
	FAuxQtyInvoiceUnCommit AS 未开票数量,
	FAmountInvoice AS 已开票金额,
	FAmountInvoiceUnCommit AS 未开票金额,
	FReceiveAmountForCommit AS 已付款金额,
	FReceiveAmountForUnCommit AS 未付款金额
FROM #Temp order by FDepart,FInterID,FEntryID,FSumSort,FStockDate
DROP TABLE #Temp

--select 
--	1,
--	t3.FBillNo+' 入库单',
--	t2.FSourceInterID,
--	t2.FSourceEntryID,
--	t2.FAuxQty,
--	t1.FDate
--from ICStockBill t1
--left join ICStockBillEntry t2 on t1.FInterID=t2.FInterID
--left join POOrder t3 on t2.FSourceInterID=t3.FInterID
--where t1.FTrantype=1
--and t2.FSourceInterID in 
--(Select  FinterID From POOrder where FDate>='2014-08-01' AND FDate<='2014-08-20' )

-- =============================================
-- example to execute the store procedure
-- EXECUTE p_xy_POOerQueryRpt '2014-08-01','2014-08-30'
-- =============================================