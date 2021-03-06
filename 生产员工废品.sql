USE [AIS20100618152307]
GO
/****** 对象:  StoredProcedure [dbo].[p_xy_EmpScrapQuery]    脚本日期: 10/20/2011 08:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER    PROCEDURE [dbo].[p_xy_EmpScrapQuery_1]
	@FChejian nvarchar(50), --车间
	@FYuangong nvarchar(50), --生产员工
	@FBeginDate datetime, --查询开工日期
	@FEndDate datetime --查询完工日期
AS
SET NOCOUNT ON

CREATE TABLE #t_xy_EmpScrapQuery(
	FInterID int,
	FFlowCardNO nvarchar(200),-- 流转卡号,
	FGongxu nvarchar(200),-- 工序,
	FBanzu nvarchar(200),-- 班组,
	FBanci nvarchar(200),--班次
	FDevice nvarchar(200),--设备
	FEmp nvarchar(200),-- 员工名,
	FItem nvarchar(200),--产品
	FHelpCode nvarchar(200),--助记码
	FStartWorkDate datetime,--实际开工日期
	FAuxWhtSingle decimal(18,4),--单重
	FAuxQtyPass decimal(18,4),FAuxWhtPass decimal(18,4),
	FAuxQtyFinish decimal(18,4),FAuxWhtFinish decimal(18,4),
	FAuxQtyForItem decimal(18,4),FAuxWhtForItem decimal(18,4),
	FAuxQtyScrap decimal(18,4),FAuxWhtScrap decimal(18,4),
	FJWAuxQtyForItem decimal(18,4),FJWAuxWhtForItem decimal(18,4),
	FJWAuxQtyScrap decimal(18,4),FJWAuxWhtScrap decimal(18,4),
	FZJAuxQtyForItem decimal(18,4),FZJAuxWhtForItem decimal(18,4),
	FZJAuxQtyScrap decimal(18,4),FZJAuxWhtScrap decimal(18,4))


INSERT INTO #t_xy_EmpScrapQuery(
	FInterID,
	FFlowCardNO,-- 流转卡号,
	FGongxu,-- 工序,
	FBanzu,-- 班组,
	FBanci,--班次
	FDevice,--设备
	FEmp,-- 员工名,
	FItem,--产品
	FHelpCode,--助记码
	FStartWorkDate,--实际开工日期
	FAuxWhtSingle,--单重
	FAuxQtyPass,FAuxWhtPass,
	FAuxQtyFinish,FAuxWhtFinish,
	FAuxQtyForItem,FAuxWhtForItem,
	FAuxQtyScrap,FAuxWhtScrap)
SELECT 
	t1.FInterID,
	t1.FFlowCardNO,-- 流转卡号,
	t3.FName,-- 工序,
	t4.FName,-- 班组,
	t8.FName,--班次
	t6.FName,--设备
	t5.FName,-- 员工名,
	t7.FModel,--产品
	t7.FHelpCode,--助记码
	t1.FStartWorkDate,--实际开工日期
	t1.FAuxWhtSingle,--单重
	t1.FAuxQtyPass,t1.FAuxWhtPass,
	t1.FAuxQtyFinish,t1.FAuxWhtFinish,
	t1.FAuxQtyForItem,t1.FAuxWhtForItem,
	t1.FAuxQtyScrap,t1.FAuxWhtScrap
FROM SHProcRpt t1
LEFT JOIN t_ICItem t2 ON t1.FItemID=t2.FItemID
LEFT JOIN t_SubMessage t3 ON t1.FOperID=t3.FInterID 
LEFT JOIN t_SubMessage t4 ON t1.FTeamID=t4.FInterID
LEFT JOIN t_Emp t5 ON t1.FWorkerID=t5.FItemID
LEFT JOIN vw_Device_Resource t6 ON t1.FDeviceID=t6.FID
LEFT JOIN t_ICItem t7 ON t1.FItemID=t7.FItemID
LEFT  JOIN v_ICSHOP_TeamTime t8 ON t1.FTeamTimeID=t8.FID
WHERE 
t3.FName='成型'
AND
CASE WHEN @FChejian='' THEN t4.FName ELSE @FChejian END=t4.FName
AND
CASE WHEN @FYuangong='' THEN t5.FName ELSE @FYuangong END=t5.FName 
AND
CASE WHEN @FBeginDate='' THEN t1.FStartWorkDate ELSE @FBeginDate END <=CONVERT(VARCHAR(10),t1.FStartWorkDate,120)
AND
CASE WHEN @FEndDate='' THEN t1.FStartWorkDate ELSE @FEndDate END >=CONVERT(VARCHAR(10),t1.FStartWorkDate,120)


UPDATE #t_xy_EmpScrapQuery
SET #t_xy_EmpScrapQuery.FJWAuxQtyForItem=t2.FAuxQtyForItem,#t_xy_EmpScrapQuery.FJWAuxWhtForItem=t2.FAuxWhtForItem,
	#t_xy_EmpScrapQuery.FJWAuxQtyScrap=t2.FAuxQtyScrap,#t_xy_EmpScrapQuery.FJWAuxWhtScrap=t2.FAuxWhtScrap
FROM #t_xy_EmpScrapQuery with (nolock)
LEFT JOIN SHProcRpt t2 ON #t_xy_EmpScrapQuery.FInterID=t2.FInterID
LEFT JOIN t_SubMessage t3 ON t2.FOperID=t3.FInterID 
WHERE t3.FName='剪尾'

UPDATE #t_xy_EmpScrapQuery
SET #t_xy_EmpScrapQuery.FZJAuxQtyForItem=t2.FAuxQtyForItem,#t_xy_EmpScrapQuery.FZJAuxWhtForItem=t2.FAuxWhtForItem,
	#t_xy_EmpScrapQuery.FZJAuxQtyScrap=t2.FAuxQtyScrap,#t_xy_EmpScrapQuery.FZJAuxWhtScrap=t2.FAuxWhtScrap
FROM #t_xy_EmpScrapQuery with (nolock)
LEFT JOIN SHProcRpt t2 ON #t_xy_EmpScrapQuery.FInterID=t2.FInterID
LEFT JOIN t_SubMessage t3 ON t2.FOperID=t3.FInterID 
WHERE t3.FName='质检'

select 
	FFlowCardNO AS 流转卡号,
	FGongxu AS 工序,
	FBanzu AS 班组,
	FBanci AS 班次,
	FDevice AS 设备,
	FEmp AS 员工名,
	FItem AS 产品,
	FHelpCode AS 材料,
	FStartWorkDate AS 实际开工日期,
	FAuxWhtSingle AS 单重,
	FAuxQtyPass AS 生产合格数量,
	FAuxWhtPass AS 生产合格重量,
	FAuxQtyFinish AS 生产实做数量,
	FAuxWhtFinish AS 生产实做重量,
	FAuxQtyForItem AS 生产因料报废数量,
	FAuxWhtForItem AS 生产因料报废重量,
	FAuxQtyScrap AS 生产因工报废数量,
	FAuxWhtScrap AS 生产因工报废重量,
	FJWAuxQtyForItem AS 剪尾因料报废数量,
	FJWAuxWhtForItem AS 剪尾因料报废重量,
	FJWAuxQtyScrap AS 剪尾因工报废数量,
	FJWAuxWhtScrap  AS 剪尾因工报废重量,
	FZJAuxQtyForItem AS 质检因料报废数量,
	FZJAuxWhtForItem AS 质检因料报废重量,
	FZJAuxQtyScrap AS 质检因工报废数量,
	FZJAuxWhtScrap AS 质检因工报废重量,
	FAuxQtyForItem+FAuxQtyScrap+FJWAuxQtyForItem+FJWAuxQtyScrap+FZJAuxQtyForItem+FZJAuxQtyScrap AS [Total of Qty],
	FAuxWhtForItem+FAuxWhtScrap+FJWAuxWhtForItem+FJWAuxWhtScrap+FZJAuxWhtForItem+FZJAuxWhtScrap AS [Total of Wht]
from #t_xy_EmpScrapQuery


--SELECT 	FYuangongName 生产员工,
--	FFlowCardNO AS 流转卡号,		
--	--FGongxuName AS 工序名称,
--	FChejianName AS 车间名称,
--	FRenyuanName AS 员工,
--	FModel AS 规格,
--	FHelpCode AS 材料,
--	FAuxQtyPass AS 生产合格数量汇总,
--	FAuxWhtPass AS 生产合格重量汇总,
--	FAuxQtyFinish AS 生产实做数量汇总,
--	FAuxWhtFinish AS 生产实做重量汇总,
--	FAuxQtyForItem AS 因料报废数量汇总,
--	FAuxWhtForItem AS 因料报废重量汇总,
--	FAuxQtyScrap AS 因工报废数量汇总,
--	FAuxWhtScrap AS 因工报废重量汇总
--FROM
--(
--   SELECT FYuangongName,
--	FFlowCardNO,		
--	--FGongxuName,
--	FChejianName,
--	FRenyuanName,
--	FModel,
--	FHelpCode,  
--	FAuxQtyPass,
--	FAuxWhtPass,
--	FAuxQtyFinish,
--	FAuxWhtFinish,
--	FAuxQtyForItem,
--	FAuxWhtForItem,
--	FAuxQtyScrap,
--	FAuxWhtScrap,s1=0,s2=FYuangongName
--   FROM #t_xy_EmpScrapQuery1
--   UNION ALL
--   SELECT '小计:','','','','','',SUM(FAuxQtyPass) AS FAuxQtyPass,
--	MAX(FAuxWhtPass) AS FAuxWhtPass,
--	MAX(FAuxQtyFinish) AS FAuxQtyFinish,
--	SUM(FAuxWhtFinish) AS FAuxWhtFinish,
--	SUM(FAuxQtyForItem) AS FAuxQtyForItem,
--	SUM(FAuxWhtForItem) AS FAuxWhtForItem,
--	SUM(FAuxQtyScrap) AS FAuxQtyScrap,
--	SUM(FAuxWhtScrap) AS FAuxWhtScrap,s1=1,s2=FYuangongName
--   FROM #t_xy_EmpScrapQuery1
--   GROUP BY FYuangongName
--) AS T
--ORDER BY s2,s1



DROP TABLE #t_xy_EmpScrapQuery

-- =============================================
-- example to execute the store procedure
-- =============================================
--EXECUTE p_xy_EmpScrapQuery_1 '','','2011-05-05','2012-05-10'


--SET QUOTED_IDENTIFIER OFF 

--select top 100 * from SHProcRpt
