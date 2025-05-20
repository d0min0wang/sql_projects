SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[p_xy_Items_OutStock_Analysis] 
    --@QueryYear as NVARCHAR(4), 
    --@QueryMonth AS NVARCHAR(2),
    @QueryItemName AS NVARCHAR(255),
    @QueryItemNumber AS NVARCHAR(255)

--exec p_xy_Items_OutStock_Analysis '',''

--DECLARE @QueryDate NVARCHAR(10)
AS
    SET NOCOUNT ON

DECLARE @QueryDate NVARCHAR(10)

;WITH CTE_ICInventory
AS
(
    select t1.FItemID,sum(t1.fqty) as fqty--,t1.fstockid,t2.fname 
    from ICInventory t1
    LEFT JOIN t_Item t2 ON t1.fstockid=t2.fitemid
    where FStockID = 14403
    GROUP BY t1.fitemid
),

CTE_UnStockQty
AS
(
    Select u1.FItemID,
        sum(u1.FAuxQty-u1.FStockQty/t19.FCoefficient) as FUnStockQty
    from SEOrder v1 
    INNER JOIN SEOrderEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
    INNER JOIN t_ICItem t16 ON     u1.FItemID = t16.FItemID   AND t16.FItemID <>0 
    INNER JOIN t_MeasureUnit t19 ON     u1.FUnitID = t19.FItemID   AND t19.FItemID <>0 
    LEFT JOIN t_Department t1 ON v1.FDeptID=t1.FItemID
    where 1=1 AND (     
    (case when u1.FMRPClosed=1 then 'Y' else '' end IS NULL OR case when u1.FMRPClosed=1 then 'Y' else '' end='' or case when u1.FMrpClosed=0 then 'N' else '' end='N')
    AND  
    v1.Fdate >=  DATEADD(MONTH,-2,GETDATE())
    AND  
    u1.FAuxQty-u1.FStockQty  > 0.0000000000
    )  AND (v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007100) AND (v1.FCancellation = 0))
    AND t1.FName in ('电气连接事业部','电气国内连接事业部')
    GROUP BY u1.FItemID
),
CTE_ICMO_UnClosedQty
AS
(
    Select v1.FItemID,
        sum(v1.Fauxqty-v1.FAuxStockQty-v1.FDiscardStockInAuxQty) AS FUnClosedQty
    from ICMO v1 
    INNER JOIN t_ICItem t9 ON   v1.FItemID = t9.FItemID  AND t9.FItemID<>0 
    LEFT OUTER JOIN t_Item t3493 ON   v1.FHeadSelfJ01133 = t3493.FItemID  AND t3493.FItemID<>0 
    where 1=1 AND (     
    v1.FCheckDate >=  DATEADD(MONTH,-2,GETDATE())
    AND  
    case when v1.Fauxqty-v1.FAuxStockQty-v1.FDiscardStockInAuxQty < 0 then 0 else v1.Fauxqty-v1.FAuxStockQty-v1.FDiscardStockInAuxQty end  > '0'
    --AND  
    --t3493.FName = '电气连接事业部'
    )  AND (v1.FTranType = 85 AND ( v1.FType <> 11060 ) AND (v1.FMRPClosed = 0))
    GROUP BY v1.FItemID
),
CTE_OutStock
AS
(
    Select u1.fitemid,
    sum(case when FORMAT(v1.fdate,'yyyy-MM')=FORMAT(DATEADD(Month,-4,GETDATE()),'yyyy-MM') then u1.Fauxqty else 0 end) AS FLast4Month,
    sum(case when FORMAT(v1.fdate,'yyyy-MM')=FORMAT(DATEADD(Month,-3,GETDATE()),'yyyy-MM') then u1.Fauxqty else 0 end) AS FLast3Month,
    sum(case when FORMAT(v1.fdate,'yyyy-MM')=FORMAT(DATEADD(Month,-2,GETDATE()),'yyyy-MM') then u1.Fauxqty else 0 end) AS FLast2Month,
    sum(case when FORMAT(v1.fdate,'yyyy-MM')=FORMAT(DATEADD(Month,-1,GETDATE()),'yyyy-MM') then u1.Fauxqty else 0 end) AS FLast1Month,
    sum(case when FORMAT(v1.fdate,'yyyy-MM')=FORMAT(GetDate(),'yyyy-MM') then u1.Fauxqty else 0 end) AS FThisMonth,
    COUNT(distinct v1.FDeptID) AS FCount
    from ICStockBill v1 
    INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
    LEFT OUTER JOIN t_Department t105 ON     v1.FDeptID = t105.FItemID   AND t105.FItemID <>0 
    where 1=1 AND (     
    v1.Fdate >=  DATEADD(year,-1,GETDATE())
    AND  
    t105.FName in ('电气连接事业部','电气连接国内事业部')
    )  AND (v1.FTranType=21)
    GROUP BY u1.fitemid
)
SELECT t5.fname as [产品类别],
    t0.fname as [产品名称],
    t1.FUnStockQty as [未出库数],
    t2.FUnClosedQty as [未入库数],
    t3.FLast4Month as [前四月出库数],
    t3.FLast3Month as [前三月出库数],
    t3.FLast2Month as [前二月出库数],
    t3.FLast1Month as [前一月出库数],
    t3.FThisMonth as [当月出库数],
    t4.fqty as [实时库存],
    t3.FCount as [客户家数],
    t6.fname as [成型设备类型]
FROM t_ICItem t0
left join CTE_UnStockQty t1 ON t0.fitemid=t1.fitemid
LEFT JOIN CTE_ICMO_UnClosedQty t2 ON t0.fitemid=t2.fitemid
left JOIN CTE_OutStock t3 ON t0.fitemid=t3.fitemid
LEFT JOIN cte_ICInventory t4 ON t0.fitemid=t4.fitemid
LEFT JOIN t_submessage t5 ON t0.f_126=t5.finterid
LEFT JOIN t_submessage t6 ON t0.f_120=t6.finterid
where 
CASE WHEN @QueryItemName = '' THEN t0.fname ELSE @QueryItemName END = t0.fname
AND
CASE WHEN @QueryItemNumber = '' THEN t0.FNumber ELSE @QueryItemNumber END = t0.FNumber
AND
t0.fnumber like '90.A%'
AND
(NOT(isnull(t4.fqty,0)=0
    and ISNULL(t1.FUnStockQty,0)=0
    and ISNULL(t2.FUnClosedQty,0)=0
    and ISNULL(t3.FLast4Month,0)=0
    and ISNULL(t3.FLast3Month,0)=0
    and ISNULL(t3.FLast2Month,0)=0
    and ISNULL(t3.FLast1Month,0)=0
    and ISNULL(t3.FThisMonth,0)=0))
ORDER BY t0.fname
--F_126产品系列
--F_120成型设备类型



