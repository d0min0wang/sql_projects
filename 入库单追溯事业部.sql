SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--出入库单追溯事业部
ALTER   PROCEDURE [dbo].[p_xy_ICStockTraceBack]
	@QueryStartTime as datetime, --查询时间，格式：YYYY-MM-DD
	@QueryEndTime as datetime --查询时间，格式：YYYY-MM-DD
--SET @Querytime='2011-02-28'
AS
SET NOCOUNT ON

--EXEC p_xy_ICStockTraceBack '2022-01-01','2022-01-30'

;WITH CTE_InStock
AS
(
    SELECT --t1.FBillNo,t2.FSourceEntryID,t2.FSourceInterId,t3.FEntryIndex,t5.FText2,t5.* 
        --t7.FName,
        CASE WHEN grouping(t2.FItemID) = '1' THEN -1
             ELSE t2.FItemID 
        END FitemID,
        sum(case when t7.FName='电气连接事业部' then t2.FAuxQty else 0 END) AS FAuxQty1, 
        sum(case when t7.FName='电气连接国内事业部' then t2.FAuxQty else 0 END) AS FAuxQty2, 
        sum(case when t7.FName='通信事业部' then t2.FAuxQty else 0 END) AS FAuxQty3, 
        sum(case when t7.FName='新能源事业部' then t2.FAuxQty else 0 END) AS FAuxQty4, 
        sum(case when t7.FName='健康事业部' then t2.FAuxQty else 0 END) AS FAuxQty5,
        sum(case when t7.FName='食品设备事业部' then t2.FAuxQty else 0 END) AS FAuxQty6,
        sum(case when t7.FName='医疗事业部' then t2.FAuxQty else 0 END) AS FAuxQty7,
        sum(case when t7.FName is null then t2.FAuxQty else 0 END) AS FAuxQty8,
        SUM(t2.FAuxQty) AS FAuxQtyAll   
    FROM ICStockBill t1
    LEFT JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
    LEFT JOIN SHProcRpt t3 ON t2.FSourceInterId=t3.FInterID AND t2.FSourceEntryID=t3.FEntryIndex
    LEFT JOIN ICShop_FlowCardEntry t4 ON t3.FFlowCardInterID=t4.FID AND t3.FFlowCardEntryID=t4.FEntryID
    INNER JOIN ICShop_FlowCard t5 ON t4.FID=t5.FID
    LEFT JOIN ICMO t6 ON t5.FSRCInterID=t6.FInterID
    left JOIN t_Department t7 ON t6.FHeadSelfJ01133=t7.FItemID
    WHERE 
    t1.FDate>=@QueryStartTime
    AND
    t1.FDate<=@QueryEndTime
    and
    t1.FTranType=2
    GROUP BY t2.FItemID with ROLLUP
),
CTE_OutStock
AS
(
    SELECT 
		--t1.FDeptID,
        CASE WHEN grouping(t2.FItemID) = '1' THEN -1
             ELSE t2.FItemID 
        END FitemID,
        SUM(case when t3.FName='电气连接事业部' then t2.FAuxQty else 0 END) AS FAuxQty1, 
        SUM(case when t3.FName='电气连接国内事业部' then t2.FAuxQty else 0 END) AS FAuxQty2, 
        SUM(case when t3.FName='通信事业部' then t2.FAuxQty else 0 END) AS FAuxQty3, 
        SUM(case when t3.FName='新能源事业部' then t2.FAuxQty else 0 END) AS FAuxQty4, 
        SUM(case when t3.FName='健康事业部' then t2.FAuxQty else 0 END) AS FAuxQty5,
        SUM(case when t3.FName='食品设备事业部' then t2.FAuxQty else 0 END) AS FAuxQty6,
        SUM(case when t3.FName='医疗事业部' then t2.FAuxQty else 0 END) AS FAuxQty7,
        SUM(case when t3.FName is null then t2.FAuxQty else 0 END) AS FAuxQty8,
        SUM(t2.FAuxQty) AS FAuxQtyAll     
    FROM ICStockBill t1 
	INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
    left join t_Department t3 ON t1.FDeptID=t3.FItemID
	where 
    t1.FDate>=@QueryStartTime
    AND
    t1.FDate<=@QueryEndTime
	AND t1.FTranType=21 
    GROUP BY t2.FItemID WITH ROLLUP
),
CTE_Items
AS
(
    SELECT FItemID FROM CTE_InStock
    UNION
    select FItemID FROM CTE_OutStock
)
SELECT --t4.FName AS 事业部,
    CASE WHEN t1.FItemID = -1 THEN '合计'
             ELSE t5.FName 
        END AS 产品名称,
    coalesce(t2.FAuxQty1,0) AS 电气连接事业部入库数量,
    coalesce(t3.FAuxQty1,0) AS 电气连接事业部出库数量,
    coalesce(t2.FAuxQty2,0) AS 电气连接国内事业部入库数量,
    coalesce(t3.FAuxQty2,0) AS 电气连接国内事业部出库数量,
    coalesce(t2.FAuxQty3,0) AS 通信事业部入库数量,
    coalesce(t3.FAuxQty3,0) AS 通信事业部出库数量,
    coalesce(t2.FAuxQty4,0) AS 新能源事业部入库数量,
    coalesce(t3.FAuxQty4,0) AS 新能源事业部出库数量,
    coalesce(t2.FAuxQty5,0) AS 健康事业部入库数量,
    coalesce(t3.FAuxQty5,0) AS 健康事业部出库数量,
    coalesce(t2.FAuxQty6,0) AS 食品设备事业部入库数量,
    coalesce(t3.FAuxQty6,0) AS 食品设备事业部出库数量,
    coalesce(t2.FAuxQty7,0) AS 医疗事业部入库数量,
    coalesce(t3.FAuxQty7,0) AS 医疗事业部出库数量,
    coalesce(t2.FAuxQty8,0) AS 其他事业部入库数量,
    coalesce(t3.FAuxQty8,0) AS 其他事业部出库数量,
    coalesce(t2.FAuxQtyAll,0) AS 合计入库数量,
    coalesce(t3.FAuxQtyAll,0) AS 合计出库数量        
FROM CTE_Items t1
LEFT JOIN CTE_InStock t2 ON t1.FItemID=t2.FItemID
LEFT JOIN CTE_OutStock t3 ON t1.FItemID=t3.FItemID
--LEFT JOIN t_Department t4 ON t1.FDeptID=t4.FItemID
LEFT JOIN t_ICItem t5 ON t1.FItemID=t5.FItemID
ORDER BY t1.FitemID DESC


--select top 10000 * from icshop_flowcardentry 
