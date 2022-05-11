USE [AIS20100618152307]
GO
/****** 对象:  StoredProcedure [dbo].[p_xy_ICMO_FlowCard]    脚本日期: 10/08/2011 15:12:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER    PROCEDURE [dbo].[p_xy_ICMOFlowCardCal]
	@StartDate as DateTime,
	@EndDate   as datetime,
	@ICMOBillNo as nvarchar(50)
AS
SET NOCOUNT ON

SELECT --IDENTITY(INT,1,1) AS autoID,
	t1.FBillNo,
--	t1.FItemID,
	t6.FName AS FItemName,
--	t1.FAuxQty,
--	t1.FAuxStockQty,
--	t1.FAuxInHighLimitQty,
	t1.FPlanCommitDate,
--	t1.FCommitDate, 
----	CASE WHEN t1.FStatus=3 THEN 'Y' END AS FEnd,
--	t1.FPlanFinishDate,
--	t1.FCloseDate,
--	t2.FInterID,
	t2.FFlowCardNo,
	t5.FName,
	t2.FAuxQtyHandOver, --移交数量
	t2.FAuxQtyRecive, --接收数量
	t2.FAuxQtyForItem, --因料报废
	t2.FAuxQtyScrap --因工报废
--	t2.FStartWorkDate,
--	t2.FEndWorkDate
--	t4.FID AS FCheckStatus,
--	t3.FCheckerID
INTO #ICMOFlowcardCal
FROM ICMO t1
LEFT JOIN ICShop_FlowCardEntry t2 ON t1.FInterID=t2.FICMOInterID
--LEFT JOIN SHProcRptMain t3 ON t2.FInterID=t3.FInterID
--LEFT JOIN t_SubMessage t4 ON t3.FCheckStatus=t4.FInterID AND t4.FInterID<>0
LEFT JOIN t_SubMessage t5 ON t2.FOperID=t5.FInterID 
LEFT JOIN t_ICItem t6 ON t1.FItemID=t6.FItemID
WHERE 
--t1.FTranType = 85 
--AND t1.FType <> 11060
--t5.FName='成型'
CASE WHEN @ICMOBillNo='' THEN ISNULL(t1.FBillNo,'') ELSE @ICMOBillNo END =ISNULL(t1.FBillNo,'')
--AND CONVERT(VARCHAR(10),t1.FPlanCommitDate,120)>='2011-09-01'
AND (t1.FPlanCommitDate>= (case when CONVERT(VARCHAR(10),@StartDate,120)='1900-01-01' then '2009-01-01' else @StartDate end)) 
--AND CONVERT(VARCHAR(10),t1.FPlanCommitDate,120)<=CONVERT(VARCHAR(10),getdate(),120)
AND (t1.FPlanCommitDate<= (case when CONVERT(VARCHAR(10),@EndDate,120)='1900-01-01' then getdate() else @EndDate end))

SELECT 
	FBillNo AS 生产任务单,
	MAX(FItemName) AS 规格型号,
	MAX(FPlanCommitDate) AS 计划开工时间,
	MAX(FFlowCardNo) AS 流转卡号,
	FName AS 工序,
	sum(FAuxQtyHandOver) AS 移交数量,
	sum(FAuxQtyRecive) AS 接收数量,
	sum(FAuxQtyForItem) AS 因料报废,
	sum(FAuxQtyScrap) AS 因工报废
--INTO #ICMOFlowcardCal_1
FROM #ICMOFlowcardCal
GROUP BY FBillNo,FName
ORDER BY FBillNo,FName

--SELECT
--	FBillNo,
--	FItemName,
--	FPlanCommitDate,
--	FFlowCardNo,
--	FName,
--	FAuxQtyHandOver, --移交数量
--	FAuxQtyRecive, --接收数量
--	FAuxQtyForItem, --因料报废
--	FAuxQtyScrap --因工报废
--FROM
--(
--	SELECT
--		FBillNo,
--		FItemName,
--		FPlanCommitDate,
--		FFlowCardNo,
--		FName,
--		FAuxQtyHandOver, --移交数量
--		FAuxQtyRecive, --接收数量
--		FAuxQtyForItem, --因料报废
--		FAuxQtyScrap, --因工报废
--		s0=0,s1=FBillNo,s2=FName
--	FROM #ICMOFlowcardCal
--	UNION ALL
--	SELECT 
--		'小计',
--		'',
--		'',
--		'',
--		'',
--		sum(FAuxQtyHandOver), --移交数量
--		sum(FAuxQtyRecive), --接收数量
--		sum(FAuxQtyForItem), --因料报废
--		sum(FAuxQtyScrap), --因工报废
--		s0=1,s1=FBillNo,s2=FName
--	FROM #ICMOFlowcardCal
--	GROUP BY FBillNo,FName
--) AS #T
--order by s1,s2,s0

DROP TABLE #ICMOFlowcardCal

-- =============================================
-- example to execute the store procedure
-- =============================================
--EXECUTE p_xy_ICMOFlowCardCal '2011-09-01','',''


--select * from t_tabledescription where fdescription like '%流转卡%'
--
--select * from t_fielddescription where ftableid=1450016
--
--select * from ICShop_FlowCardEntry