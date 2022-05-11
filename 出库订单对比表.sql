;WITH CTE_Order
AS
(
    SELECT t1.FCustID,
        t1.FDeptID,
        sum(t2.FEntrySelfS0156) AS FAmount,
        SUM(t2.FAuxQty) AS FAuxQty
    FROM SEOrder t1
    LEFT join SEOrderEntry t2 ON t1.FInterID=t2.FInterID
    WHERE CONVERT(VARCHAR(10),t1.FFetchDate,120)>='2021-10-01'
    GROUP BY t1.FCustID,t1.FDeptID 
),
CTE_OutStock
AS
(
    SELECT 
		t1.FSupplyID AS FCustID,
        t1.FDeptID,
        ISNULL(SUM(t2.FConsignAmount),0) AS FAmount,
		ISNULL(SUM(t2.FAuxQty),0) AS FAuxQty
    FROM ICStockBill t1 
	INNER JOIN ICStockBillEntry t2 ON t2.FInterID=t1.FInterID
	where CONVERT(VARCHAR(10),t1.FDate,120)>='2021-10-01'
    GROUP BY t1.FSupplyID,t1.FDeptID
),
CTE
AS
(
    SELECT FCustID,FDeptID FROM CTE_Order
    UNION
    SELECT FCustID,FDeptID FROM CTE_OutStock
),
CTE_All
AS
(
    SELECT t1.FCustID,
        t1.FDeptID,
        t2.FAmount AS FOrderAmount,
        t2.FAuxQty AS FOrderAuxQty,
        t3.FAmount AS FOutStockAmount,
        t3.FAuxQty AS FOutStockQty 
    FROM CTE t1
    LEFT join CTE_Order t2 ON t1.FCustID=t2.FCustID AND t1.FDeptID=t2.FDeptID
    LEFT join CTE_OutStock t3 ON t1.FCustID=t3.FCustID AND t1.FDeptID=t3.FDeptID
)

SELECT t2.FName,
    case when t3.FName='电气连接事业部' then t1.FOrderAmount else 0 END AS 电气连接事业部订单金额,
    case when t3.FName='电气连接事业部' then t1.FOrderAuxQty else 0 END AS 电气连接事业部订单数量,
    case when t3.FName='电气连接事业部' then t1.FOutStockAmount else 0 END AS 电气连接事业部出库金额,
    case when t3.FName='电气连接事业部' then t1.FOutStockQty else 0 END AS 电气连接事业部出库数量,

    case when t3.FName='电气连接国内事业部' then t1.FOrderAmount else 0 END AS 电气连接国内事业部订单金额,
    case when t3.FName='电气连接国内事业部' then t1.FOrderAuxQty else 0 END AS 电气连接国内事业部订单数量,
    case when t3.FName='电气连接国内事业部' then t1.FOutStockAmount else 0 END AS 电气连接国内事业部出库金额,
    case when t3.FName='电气连接国内事业部' then t1.FOutStockQty else 0 END AS 电气连接国内事业部出库数量,

    case when t3.FName='通信事业部' then t1.FOrderAmount else 0 END AS 通信事业部订单金额,
    case when t3.FName='通信事业部' then t1.FOrderAuxQty else 0 END AS 通信事业部订单数量,
    case when t3.FName='通信事业部' then t1.FOutStockAmount else 0 END AS 通信事业部出库金额,
    case when t3.FName='通信事业部' then t1.FOutStockQty else 0 END AS 通信事业部出库数量,

    case when t3.FName='新能源事业部' then t1.FOrderAmount else 0 END AS 新能源事业部订单金额,
    case when t3.FName='新能源事业部' then t1.FOrderAuxQty else 0 END AS 新能源事业部订单数量,
    case when t3.FName='新能源事业部' then t1.FOutStockAmount else 0 END AS 新能源事业部出库金额,
    case when t3.FName='新能源事业部' then t1.FOutStockQty else 0 END AS 新能源事业部出库数量,

    case when t3.FName='健康事业部' then t1.FOrderAmount else 0 END AS 健康事业部订单金额,
    case when t3.FName='健康事业部' then t1.FOrderAuxQty else 0 END AS 健康事业部订单数量,
    case when t3.FName='健康事业部' then t1.FOutStockAmount else 0 END AS 健康事业部出库金额,
    case when t3.FName='健康事业部' then t1.FOutStockQty else 0 END AS 健康事业部出库数量,

    case when t3.FName='食品事业部' then t1.FOrderAmount else 0 END AS 食品事业部订单金额,
    case when t3.FName='食品事业部' then t1.FOrderAuxQty else 0 END AS 食品事业部订单数量,
    case when t3.FName='食品事业部' then t1.FOutStockAmount else 0 END AS 食品事业部出库金额,
    case when t3.FName='食品事业部' then t1.FOutStockQty else 0 END AS 食品事业部出库数量,

    case when t3.FName='医疗事业部' then t1.FOrderAmount else 0 END AS 医疗事业部订单金额,
    case when t3.FName='医疗事业部' then t1.FOrderAuxQty else 0 END AS 医疗事业部订单数量,
    case when t3.FName='医疗事业部' then t1.FOutStockAmount else 0 END AS 医疗事业部出库金额,
    case when t3.FName='医疗事业部' then t1.FOutStockQty else 0 END AS 医疗事业部出库数量,
    t1.FOrderAmount AS 合计订单金额,
    t1.FOrderAuxQty AS 合计订单数量,
    t1.FOutStockAmount AS 合计出库金额,
    t1.FOutStockQty AS 合计出库数量 
FROM CTE_All t1 
LEFT JOIN t_Organization t2 ON t1.FCustID=t2.FItemID
LEFT JOIN t_Department t3 ON t1.FDeptID=t3.FItemID
--WHERE FCustID=17598


--SELECT * FROM t_TableDescription WHERE FDescription LIKE '%销售%'

--SELECT * from t_FieldDescription WHERE FTableID=230004 AND FDescription LIKE '%日期%'