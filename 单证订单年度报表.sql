SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[p_xy_clerk_Order_Annual_Report]
	@FYear nvarchar(4)
AS
SET NOCOUNT ON


--EXEC p_xy_clerk_Order_Annual_Report '2022'

--SELECT * FROM t_TableDescription where fdescription like '发货通知%' --230006

--SELECT * FROM t_TableDescription where FTableName='ICStockBillEntry' --230004

--SELECT * FROM t_FieldDescription where  FTableID=210008 AND FDescription LIKE '%购货%'
--计划部门 FHeadSelfJ01133                                                                 
--顾客名称 FHeadSelfJ0195                                                                  
--标签要求 FHeadSelfJ01102                                                                 
--任务单数量 FAuxQty
--销售订单制单 FBillerID
--发货通知单二级审核 FMultiCheckLevel2



;WITH CTE_SEOrder
AS
(
    SELECT CASE WHEN GROUPING(t1.FBillerID)=1 THEN 1 ELSE t1.FBillerID END AS FBillerID,
        count(*) AS FSEOrderCount,
        SUM(case when MONTH(t1.fdate)='1' then 1 END) AS FSEOrderCount1,
        SUM(case when MONTH(t1.fdate)='2' then 1 END) AS FSEOrderCount2,
        SUM(case when MONTH(t1.fdate)='3' then 1 END) AS FSEOrderCount3,
        SUM(case when MONTH(t1.fdate)='4' then 1 END) AS FSEOrderCount4,
        SUM(case when MONTH(t1.fdate)='5' then 1 END) AS FSEOrderCount5,
        SUM(case when MONTH(t1.fdate)='6' then 1 END) AS FSEOrderCount6,
        SUM(case when MONTH(t1.fdate)='7' then 1 END) AS FSEOrderCount7,
        SUM(case when MONTH(t1.fdate)='8' then 1 END) AS FSEOrderCount8,
        SUM(case when MONTH(t1.fdate)='9' then 1 END) AS FSEOrderCount9,
        SUM(case when MONTH(t1.fdate)='10' then 1 END) AS FSEOrderCount10,
        SUM(case when MONTH(t1.fdate)='11' then 1 END) AS FSEOrderCount11,
        SUM(case when MONTH(t1.fdate)='12' then 1 END) AS FSEOrderCount12
    FROM SEOrder t1
    left join SEOrderEntry t2 on t1.FInterID=t2.FInterID
    LEFT JOIN t_User t3 ON t1.FBillerID=t3.FUserID
    WHERE t3.FName IN ('黄艳红','范鸿文','邓剑萍','郑晓纯','端子套01','端子套02')
    AND YEAR(t1.FDate)=@FYear
    GROUP BY rollup(t1.FBillerID)
),
CTE_ICStockBill
AS
(
    SELECT CASE WHEN GROUPING(t4.FMultiCheckLevel2)=1 THEN 1 ELSE t4.FMultiCheckLevel2 END AS FMultiCheckLevel2,
        count(*) AS FICStockBillCount,
        SUM(t2.FConsignAmount) AS FICStockBillAmount,
        SUM(case when MONTH(t1.fdate)='1' then 1 END) AS FICStockBillCount1,
        SUM(case when MONTH(t1.fdate)='1' then t2.FConsignAmount END) AS FICStockBillAmount1,
        SUM(case when MONTH(t1.fdate)='2' then 1 END) AS FICStockBillCount2,
        SUM(case when MONTH(t1.fdate)='2' then t2.FConsignAmount END) AS FICStockBillAmount2,
        SUM(case when MONTH(t1.fdate)='3' then 1 END) AS FICStockBillCount3,
        SUM(case when MONTH(t1.fdate)='3' then t2.FConsignAmount END) AS FICStockBillAmount3,
        SUM(case when MONTH(t1.fdate)='4' then 1 END) AS FICStockBillCount4,
        SUM(case when MONTH(t1.fdate)='4' then t2.FConsignAmount END) AS FICStockBillAmount4,
        SUM(case when MONTH(t1.fdate)='5' then 1 END) AS FICStockBillCount5,
        SUM(case when MONTH(t1.fdate)='5' then t2.FConsignAmount END) AS FICStockBillAmount5,
        SUM(case when MONTH(t1.fdate)='6' then 1 END) AS FICStockBillCount6,
        SUM(case when MONTH(t1.fdate)='6' then t2.FConsignAmount END) AS FICStockBillAmount6,
        SUM(case when MONTH(t1.fdate)='7' then 1 END) AS FICStockBillCount7,
        SUM(case when MONTH(t1.fdate)='7' then t2.FConsignAmount END) AS FICStockBillAmount7,
        SUM(case when MONTH(t1.fdate)='8' then 1 END) AS FICStockBillCount8,
        SUM(case when MONTH(t1.fdate)='8' then t2.FConsignAmount END) AS FICStockBillAmount8,
        SUM(case when MONTH(t1.fdate)='9' then 1 END) AS FICStockBillCount9,
        SUM(case when MONTH(t1.fdate)='9' then t2.FConsignAmount END) AS FICStockBillAmount9,
        SUM(case when MONTH(t1.fdate)='10' then 1 END) AS FICStockBillCount10,
        SUM(case when MONTH(t1.fdate)='10' then t2.FConsignAmount END) AS FICStockBillAmount10,
        SUM(case when MONTH(t1.fdate)='11' then 1 END) AS FICStockBillCount11,
        SUM(case when MONTH(t1.fdate)='11' then t2.FConsignAmount END) AS FICStockBillAmount11,
        SUM(case when MONTH(t1.fdate)='12' then 1 END) AS FICStockBillCount12,
        SUM(case when MONTH(t1.fdate)='12' then t2.FConsignAmount END) AS FICStockBillAmount12
    FROM ICStockBill t1 
    INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
    LEFT JOIN SEOutStockEntry t3 ON t2.FSEOutInterID=t3.FInterID AND t2.FSEOutEntryID=t3.FEntryID
    LEFT JOIN SEOutStock t4 ON t3.FInterID=t4.FInterID
    LEFT JOIN t_User t5 ON t4.FMultiCheckLevel2=t5.FUserID
    WHERE t5.FName IN ('黄艳红','范鸿文','邓剑萍','郑晓纯','端子套01','端子套02')
    and year(t1.fdate)=@FYear
    and t1.ftrantype=21
    GROUP BY rollup(t4.FMultiCheckLevel2)
),
CTE_ICStockBill_Cust
AS
(
    SELECT CASE WHEN GROUPING(t4.FMultiCheckLevel2)=1 THEN 1 ELSE t4.FMultiCheckLevel2 END AS FMultiCheckLevel2,
        count(DISTINCT t1.FSupplyID) AS FICStockBillCount,
        count(DISTINCT(case when MONTH(t1.fdate)='1' then t1.FSupplyID else '' END))-1 AS FICStockBillCount1,
        count(DISTINCT(case when MONTH(t1.fdate)='2' then t1.FSupplyID else '' END))-1 AS FICStockBillCount2,
        count(DISTINCT(case when MONTH(t1.fdate)='3' then t1.FSupplyID else '' END))-1 AS FICStockBillCount3,
        count(DISTINCT(case when MONTH(t1.fdate)='4' then t1.FSupplyID else '' END))-1 AS FICStockBillCount4,
        count(DISTINCT(case when MONTH(t1.fdate)='5' then t1.FSupplyID else '' END))-1 AS FICStockBillCount5,
        count(DISTINCT(case when MONTH(t1.fdate)='6' then t1.FSupplyID else '' END))-1 AS FICStockBillCount6,
        count(DISTINCT(case when MONTH(t1.fdate)='7' then t1.FSupplyID else '' END))-1 AS FICStockBillCount7,
        count(DISTINCT(case when MONTH(t1.fdate)='8' then t1.FSupplyID else '' END))-1 AS FICStockBillCount8,
        count(DISTINCT(case when MONTH(t1.fdate)='9' then t1.FSupplyID else '' END))-1 AS FICStockBillCount9,
        count(DISTINCT(case when MONTH(t1.fdate)='10' then t1.FSupplyID else '' END))-1 AS FICStockBillCount10,
        count(DISTINCT(case when MONTH(t1.fdate)='11' then t1.FSupplyID else '' END))-1 AS FICStockBillCount11,
        count(DISTINCT(case when MONTH(t1.fdate)='12' then t1.FSupplyID else '' END))-1 AS FICStockBillCount12
    FROM ICStockBill t1 
    INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
    LEFT JOIN SEOutStockEntry t3 ON t2.FSEOutInterID=t3.FInterID AND t2.FSEOutEntryID=t3.FEntryID
    LEFT JOIN SEOutStock t4 ON t3.FInterID=t4.FInterID
    LEFT JOIN t_User t5 ON t4.FMultiCheckLevel2=t5.FUserID
    WHERE t5.FName IN ('黄艳红','范鸿文','邓剑萍','郑晓纯','端子套01','端子套02')
    and year(t1.fdate)=@FYear
    and t1.ftrantype=21
    GROUP BY rollup(t4.FMultiCheckLevel2)
)
SELECT case when t1.FBillerID=1 then '合计' else t4.FName end AS [姓名],
    
    t1.FSEOrderCount1 AS [一月+下单],
    t2.FICStockBillCount1 AS [一月+出单],
    t2.FICStockBillAmount1 AS [一月+出库总金额],
    t3.FICStockBillCount1 AS [一月+出库客户数],
    
    t1.FSEOrderCount2 AS [二月+下单],
    t2.FICStockBillCount2 AS [二月+出单],
    t2.FICStockBillAmount2 AS [二月+出库总金额],
    t3.FICStockBillCount2 AS [二月+出库客户数],
    
    t1.FSEOrderCount3 AS [三月+下单],
    t2.FICStockBillCount3 AS [三月+出单],
    t2.FICStockBillAmount3 AS [三月+出库总金额],
    t3.FICStockBillCount3 AS [三月+出库客户数],
    
    t1.FSEOrderCount4 AS [四月+下单],
    t2.FICStockBillCount4 AS [四月+出单],
    t2.FICStockBillAmount4 AS [四月+出库总金额],
    t3.FICStockBillCount4 AS [四月+出库客户数],
    
    t1.FSEOrderCount5 AS [五月+下单],
    t2.FICStockBillCount5 AS [五月+出单],
    t2.FICStockBillAmount5 AS [五月+出库总金额],
    t3.FICStockBillCount5 AS [五月+出库客户数],
    
    t1.FSEOrderCount6 AS [六月+下单],
    t2.FICStockBillCount6 AS [六月+出单],
    t2.FICStockBillAmount6 AS [六月+出库总金额],
    t3.FICStockBillCount6 AS [六月+出库客户数],
    
    t1.FSEOrderCount7 AS [七月+下单],
    t2.FICStockBillCount7 AS [七月+出单],
    t2.FICStockBillAmount7 AS [七月+出库总金额],
    t3.FICStockBillCount7 AS [七月+出库客户数],
    
    t1.FSEOrderCount8 AS [八月+下单],
    t2.FICStockBillCount8 AS [八月+出单],
    t2.FICStockBillAmount8 AS [八月+出库总金额],
    t3.FICStockBillCount8 AS [八月+出库客户数],
    
    t1.FSEOrderCount9 AS [九月+下单],
    t2.FICStockBillCount9 AS [九月+出单],
    t2.FICStockBillAmount9 AS [九月+出库总金额],
    t3.FICStockBillCount9 AS [九月+出库客户数],
    
    t1.FSEOrderCount10 AS [十月+下单],
    t2.FICStockBillCount10 AS [十月+出单],
    t2.FICStockBillAmount10 AS [十月+出库总金额],
    t3.FICStockBillCount10 AS [十月+出库客户数],
    
    t1.FSEOrderCount11 AS [十一月+下单],
    t2.FICStockBillCount11 AS [十一月+出单],
    t2.FICStockBillAmount11 AS [十一月+出库总金额],
    t3.FICStockBillCount11 AS [十一月+出库客户数],
    
    t1.FSEOrderCount12 AS [十二月+下单],
    t2.FICStockBillCount12 AS [十二月+出单],
    t2.FICStockBillAmount12 AS [十二月+出库总金额],
    t3.FICStockBillCount12 AS [十二月+出库客户数],
    
    t1.FSEOrderCount AS [合计+下单],
    t2.FICStockBillCount AS [合计+出单],
    (t1.FSEOrderCount*1.0)/(select FSEOrderCount from CTE_SEOrder where FBillerID=1) AS [下单占比],
    (t2.FICStockBillCount*1.0)/(select FICStockBillCount from CTE_ICStockBill where FMultiCheckLevel2=1) AS [出单占比]
    --t2.FICStockBillAmount AS [合计+出库总金额],
    --t3.FICStockBillCount1+t3.FICStockBillCount2+t3.FICStockBillCount3+t3.FICStockBillCount4+t3.FICStockBillCount5+t3.FICStockBillCount6
    --    +t3.FICStockBillCount7+t3.FICStockBillCount8+t3.FICStockBillCount9+t3.FICStockBillCount10+t3.FICStockBillCount11+t3.FICStockBillCount12 AS [合计+出库客户数]
FROM CTE_SEOrder t1
LEFT JOIN CTE_ICStockBill t2 ON t1.FBillerID=t2.FMultiCheckLevel2
LEFT JOIN CTE_ICStockBill_Cust t3 ON t1.FBillerID=t3.FMultiCheckLevel2
LEFT JOIN t_User t4 ON t1.FBillerID=t4.FUserID
ORDER BY t1.FBillerID DESC

