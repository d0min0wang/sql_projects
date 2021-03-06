USE [AIS20100618152307]
GO
/****** Object:  StoredProcedure [dbo].[p_xy_JianweiQuery_Sort]    Script Date: 07/24/2010 16:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER       PROCEDURE [dbo].[p_xy_JianweiQuery_Sort]
	@FBeginDate datetime, --查询开工日期
	@FEndDate datetime --查询完工日期
AS

SET NOCOUNT ON

CREATE TABLE #t_xy_jianweiBeforeSort(
	FFlowCardNO nvarchar(200),
	FGongxuName nvarchar(200),
	fDeviceName nvarchar(200),
	FWorkName nvarchar(200),
	FModel nvarchar(200),
	FHelpCode nvarchar(200),
	FAuxQtyPass decimal(18,4),
	FAuxWhtPass decimal(18,4),
	FAuxQtyForItem decimal(18,4),
	FAuxWhtForItem decimal(18,4),
	FAuxQtyScrap decimal(18,4),
	FAuxWhtScrap decimal(18,4))
	
CREATE TABLE #t_xy_jianweiAfterSort(
	FFlowCardNO nvarchar(200),
	FGongxuName nvarchar(200),
	fDeviceName nvarchar(200),
	FWorkName nvarchar(200),
	FModel nvarchar(200),
	FHelpCode nvarchar(200),
	IsFWorkName int, 
    IsFDeviceName int, 
    IsFModel int, 
    IsFHelpCode int, 
	FAuxQtyPass decimal(18,4),
	FAuxWhtPass decimal(18,4),
	FAuxQtyForItem decimal(18,4),
	FAuxWhtForItem decimal(18,4),
	FAuxQtyScrap decimal(18,4),
	FAuxWhtScrap decimal(18,4))
	
INSERT INTO #t_xy_jianweiBeforeSort(
	FFlowCardNO,
	FGongxuName,
	fDeviceName,
	FWorkName,
	FModel,
	FHelpCode, 
	FAuxQtyPass,
	FAuxWhtPass,
	FAuxQtyForItem,
	FAuxWhtForItem,
	FAuxQtyScrap,
	FAuxWhtScrap)
SELECT i.FFlowCardNO AS 流转卡号,l.FName AS 工序,o.fname,
m.FName AS 质检人员,k.FModel AS 规格,k.FHelpCode AS 材料,
i.FAuxQtyPass AS 生产数量K,i.FAuxWhtPass AS 生产重量KG,i.FAuxQtyForItem AS 因料报废K,
i.FAuxWhtForItem AS 因料报废KG,i.FAuxQtyScrap AS 因工报废K,i.FAuxWhtScrap AS 因工报废KG
FROM SHProcRpt i
LEFT JOIN SHProcRptMain j ON i.FInterID=j.FInterID
LEFT JOIN t_ICItem k ON i.FItemID=k.FItemID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID 
LEFT JOIN t_Emp m ON i.FWorkerID=m.FItemID
LEFT JOIN t_SubMessage n ON i.FTeamID=n.FInterID
LEFT JOIN t_Resource o ON i.FdeviceID=o.FInterID
WHERE l.FName='剪尾' 
AND j.FDate>=@FBeginDate AND j.FDate<=@FEndDate

INSERT INTO #t_xy_jianweiAfterSort(
	FWorkName,	
	fDeviceName,
	FModel,
	FHelpCode, 
	FAuxQtyPass,
	FAuxWhtPass,
	FAuxQtyForItem,
	FAuxWhtForItem,
	FAuxQtyScrap,
	FAuxWhtScrap,
	IsFWorkName, 
    IsFDeviceName, 
    IsFModel, 
    IsFHelpCode
 )
SELECT CASE WHEN (GROUPING(FWorkName) = 1) THEN 'ALL' 
            ELSE ISNULL(FWorkName, 'UNKNOWN') 
       END AS FWorkName, 
       CASE WHEN (GROUPING(FDeviceName) = 1) THEN 'ALL' 
            ELSE ISNULL(FDeviceName, 'UNKNOWN') 
       END AS FDeviceName, 
--       CASE WHEN (GROUPING(FFlowCardNO) = 1) THEN 'ALL' 
--            ELSE ISNULL(FFlowCardNO, 'UNKNOWN') 
--       END AS FFlowCardNO, 
       CASE WHEN (GROUPING(FModel) = 1) THEN 'ALL' 
            ELSE ISNULL(FModel, 'UNKNOWN') 
       END AS FModel, 
       CASE WHEN (GROUPING(FHelpCode) = 1) THEN 'ALL' 
            ELSE ISNULL(FHelpCode, 'UNKNOWN') 
       END AS FHelpCode, 
		SUM(FAuxQtyPass),
		SUM(FAuxWhtPass),
		SUM(FAuxQtyForItem),
		SUM(FAuxWhtForItem),
		SUM(FAuxQtyScrap),
		SUM(FAuxWhtScrap),
		GROUPING(FWorkName)AS IsFWorkName, 
        GROUPING(FDeviceName) AS IsFDeviceName, 
        GROUPING(FModel) AS IsFModel, 
        GROUPING(FHelpCode) AS IsFHelpCode 
FROM #t_xy_jianweiBeforeSort 
GROUP BY FWorkName, 
       FDeviceName, 
--       FFlowCardNO, 
       FModel, 
       FHelpCode
 WITH ROLLUP

DROP TABLE #t_xy_jianweiBeforeSort

select 	FWorkName AS 员工,	
	fDeviceName AS 设备,
	FModel AS 规格,
	FHelpCode AS 助记码, 
	FAuxQtyPass AS 生产数量K,
	FAuxWhtPass AS 生产重量KG,
	FAuxQtyForItem AS 因料报废K,
	FAuxWhtForItem AS 因料报废KG,
	FAuxQtyScrap AS 因工报废K,
	FAuxWhtScrap AS 因工报废KG
 from #t_xy_jianweiAfterSort
WHERE (IsFWorkName=0 AND IsFDeviceName=0 AND IsFModel=0 AND IsFHelpCode=0)
	OR (IsFWorkName=0 AND IsFDeviceName=1 AND IsFModel=1 AND IsFHelpCode=1)
	OR (IsFWorkName=0 AND IsFDeviceName=0 AND IsFModel=1 AND IsFHelpCode=1)
	OR (IsFWorkName=1 AND IsFDeviceName=1 AND IsFModel=1 AND IsFHelpCode=1)


DROP TABLE #t_xy_jianweiAfterSort

-- =============================================
-- example to execute the store procedure
-- =============================================
--EXECUTE p_xy_JianweiQuery_Sort '2010-07-01','2010-07-31'