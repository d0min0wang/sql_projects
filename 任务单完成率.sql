USE [AIS20100618152307]
GO
/****** 对象:  StoredProcedure [dbo].[p_xy_ICMO_Per]    脚本日期: 12/05/2011 10:12:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[p_xy_ICMO_Per]
	@Year as nvarchar(4)
AS
SET NOCOUNT ON
DECLARE @Max as nvarchar(10)
DECLARE @Min as nvarchar(10)
DECLARE @Avg as nvarchar(10)
--FStatus=0 计划
--FStatus=5 确认
--FStatus=1 OR FStatus=2 下达
--FStatus=3 结案 
Select IDENTITY(INT,1,1) AS autoID,
	v1.FInterID as FInterID,
	v1.Fauxqty as Fauxqty, --计划生产数量
	v1.FAuxStockQty as FAuxStockQty, --完工入库数量
	v1.FAuxStockQty-v1.Fauxqty as FCompare,
	cast((v1.FAuxStockQty-v1.Fauxqty)/v1.Fauxqty as decimal(10,2)) as FComparePer,
	v1.FStatus as FStatus, --状态
	v1.FPlanCommitDate AS FPlanCommitDate
into #ICMO_temp
from ICMO v1 
--INNER JOIN t_ICItem t9 ON   v1.FItemID = t9.FItemID  AND t9.FItemID<>0 
 where 1=1 
AND CAST(YEAR(v1.FPlanCommitDate) as varchar(4))= @Year  
--AND (CONVERT(VARCHAR(10),v1.FPlanCommitDate,120)<= (case when CONVERT(VARCHAR(10),@EndDate,120)='1900-01-01' then getdate() else @EndDate end))
AND v1.FTranType = 85 
AND v1.FType <> 11060
AND v1.FCancellation = 0

select @Max=cast(cast(max(FComparePer) as decimal(10,2)) as varchar)+'%' from #ICMO_temp
select @Min=cast(cast(min(FComparePer) as decimal(10,2)) as varchar)+'%' from #ICMO_temp
select @Avg=cast(cast(avg(FComparePer) as decimal(10,2)) as varchar)+'%' from #ICMO_temp

select
	[时间]='' + @Year + '年合计',
	[任务单]=ISNULL(COUNT(autoID),0),
	[任务单数量]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[总入库数量]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[已结案任务单]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[已结案任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[已结案任务单数量]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[已结案任务单入库数]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[未结案、入库>计划数量]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[未结案、入库>计划数量任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[超产任务单]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[超产任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp
--逐月查询明细数据
union ALL
select
	[时间]='01月',
	[任务单]=ISNULL(COUNT(autoID),0),
	[任务单数量]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[总入库数量]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[已结案任务单]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[已结案任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[已结案任务单数量]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[已结案任务单入库数]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[未结案、入库>计划数量]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[未结案、入库>计划数量任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[超产任务单]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[超产任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='01'
union ALL
select
	[时间]='02月',
	[任务单]=ISNULL(COUNT(autoID),0),
	[任务单数量]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[总入库数量]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[已结案任务单]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[已结案任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[已结案任务单数量]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[已结案任务单入库数]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[未结案、入库>计划数量]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[未结案、入库>计划数量任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[超产任务单]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[超产任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='02'
union ALL
select
	[时间]='03月',
	[任务单]=ISNULL(COUNT(autoID),0),
	[任务单数量]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[总入库数量]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[已结案任务单]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[已结案任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[已结案任务单数量]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[已结案任务单入库数]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[未结案、入库>计划数量]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[未结案、入库>计划数量任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[超产任务单]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[超产任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='03'
union ALL
select
	[时间]='04月',
	[任务单]=ISNULL(COUNT(autoID),0),
	[任务单数量]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[总入库数量]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[已结案任务单]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[已结案任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[已结案任务单数量]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[已结案任务单入库数]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[未结案、入库>计划数量]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[未结案、入库>计划数量任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[超产任务单]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[超产任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='04'
union ALL
select
	[时间]='05月',
	[任务单]=ISNULL(COUNT(autoID),0),
	[任务单数量]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[总入库数量]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[已结案任务单]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[已结案任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[已结案任务单数量]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[已结案任务单入库数]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[未结案、入库>计划数量]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[未结案、入库>计划数量任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[超产任务单]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[超产任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='05'
union ALL
select
	[时间]='06月',
	[任务单]=ISNULL(COUNT(autoID),0),
	[任务单数量]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[总入库数量]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[已结案任务单]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[已结案任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[已结案任务单数量]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[已结案任务单入库数]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[未结案、入库>计划数量]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[未结案、入库>计划数量任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[超产任务单]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[超产任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='06'
union ALL
select
	[时间]='07月',
	[任务单]=ISNULL(COUNT(autoID),0),
	[任务单数量]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[总入库数量]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[已结案任务单]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[已结案任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[已结案任务单数量]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[已结案任务单入库数]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[未结案、入库>计划数量]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[未结案、入库>计划数量任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[超产任务单]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[超产任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='07'
union ALL
select
	[时间]='08月',
	[任务单]=ISNULL(COUNT(autoID),0),
	[任务单数量]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[总入库数量]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[已结案任务单]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[已结案任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[已结案任务单数量]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[已结案任务单入库数]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[未结案、入库>计划数量]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[未结案、入库>计划数量任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[超产任务单]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[超产任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='08'
union ALL
select
	[时间]='09月',
	[任务单]=ISNULL(COUNT(autoID),0),
	[任务单数量]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[总入库数量]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[已结案任务单]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[已结案任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[已结案任务单数量]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[已结案任务单入库数]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[未结案、入库>计划数量]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[未结案、入库>计划数量任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[超产任务单]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[超产任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='09'
union ALL
select
	[时间]='10月',
	[任务单]=ISNULL(COUNT(autoID),0),
	[任务单数量]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[总入库数量]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[已结案任务单]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[已结案任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[已结案任务单数量]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[已结案任务单入库数]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[未结案、入库>计划数量]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[未结案、入库>计划数量任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[超产任务单]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[超产任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='10'
UNION ALL
select
	[时间]='11月',
	[任务单]=ISNULL(COUNT(autoID),0),
	[任务单数量]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[总入库数量]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[已结案任务单]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[已结案任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[已结案任务单数量]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[已结案任务单入库数]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[未结案、入库>计划数量]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[未结案、入库>计划数量任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[超产任务单]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[超产任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='11'
UNION ALL
select
	[时间]='12月',
	[任务单]=ISNULL(COUNT(autoID),0),
	[任务单数量]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[总入库数量]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[已结案任务单]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[已结案任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[已结案任务单数量]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[已结案任务单入库数]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[未结案、入库>计划数量]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[未结案、入库>计划数量任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[超产任务单]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[超产任务单百分比]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='12'
UNION ALL
select
	[时间]='其中超产比例最大为:' +@Max+ '',
	[任务单]=NULL,
	[任务单数量]=NULL,
	[总入库数量]=NULL,
	[已结案任务单]=NULL,
	[已结案任务单百分比]='',
	[已结案任务单数量]=NULL,
	[已结案任务单入库数]=NULL,
	[未结案、入库>计划数量]=NULL,
	[未结案、入库>计划数量任务单百分比]='',
	[超产任务单]=NULL,
	[超产任务单百分比]=''
UNION ALL
select
	[时间]='超产比例最小为:' +@Min+ '',
	[任务单]=NULL,
	[任务单数量]=NULL,
	[总入库数量]=NULL,
	[已结案任务单]=NULL,
	[已结案任务单百分比]='',
	[已结案任务单数量]=NULL,
	[已结案任务单入库数]=NULL,
	[未结案、入库>计划数量]=NULL,
	[未结案、入库>计划数量任务单百分比]='',
	[超产任务单]=NULL,
	[超产任务单百分比]=''
UNION ALL
select
	[时间]='平均值为:' +@Avg+ '',
	[任务单]=NULL,
	[任务单数量]=NULL,
	[总入库数量]=NULL,
	[已结案任务单]=NULL,
	[已结案任务单百分比]='',
	[已结案任务单数量]=NULL,
	[已结案任务单入库数]=NULL,
	[未结案、入库>计划数量]=NULL,
	[未结案、入库>计划数量任务单百分比]='',
	[超产任务单]=NULL,
	[超产任务单百分比]=''


--select * from #ICMO_temp

DROP TABLE #ICMO_temp

-- =============================================
-- example to execute the store procedure
-- =============================================
--EXECUTE p_xy_ICMO_Per '2011'