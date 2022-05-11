IF OBJECT_ID('tempdb.dbo.#t_TempInOut','U') IS NOT NULL DROP TABLE dbo.#t_TempInOut;
IF OBJECT_ID('tempdb.dbo.#temp_Material','U') IS NOT NULL DROP TABLE dbo.#temp_Material;

DECLARE @FWeight decimal(28,10)
DECLARE @FRemainWeight decimal(18,3)
DECLARE @FItemID AS INT
DECLARE @FNumber AS NVARCHAR(100)
DECLARE @FName AS NVARCHAR(100)
DECLARE @Num AS INT
--SELECT @FWeight=sum(t1.FQty) FROM ICInventory t1 LEFT JOIN t_ICItem t2 ON t1.FItemID=t2.FItemID
--  WHERE t2.FName='101-A' AND t1.fstockid=356 --结存
CREATE TABLE #t_TempInOut
(
     FNumber NVARCHAR(100),
     FName NVARCHAR(100),
     FBegQty Decimal(28,10) Default(0),
     FInQty Decimal(28,10) Default(0),
     FOutQty Decimal(28,10) Default(0),
     FEndQty Decimal(28,10) Default(0)
)
INSERT into #t_TempInOut
EXECUTE p_xy_All_0 '2022','03'


----SQL SERVER通过临时表遍历数据
-- 判断是否存在（object(‘objectname’,‘type’)）
--IF OBJECT_ID('tempdb.dbo.#temp_Material','U') IS NOT NULL DROP TABLE dbo.#temp_Material;
 
--GO
-- 声明变量
-- DECLARE
-- @FItemID AS INT,
-- @FNumber AS NVARCHAR(100),
-- @FName AS NVARCHAR(100),
-- @Num AS INT
 
--数据插入临时表（select * INTO #Temp from 来源表）

SELECT t3.FName AS FTypeName,t1.FItemID,t1.FNumber,t1.fName  
INTO #temp_Material
FROM t_ICItem t1
LEFT JOIN t_Item t2 ON t1.FParentID=t2.FItemID
LEFT JOIN t_Item t3 ON t2.FParentID=t3.FItemID
WHERE t3.FName='主原材料'
 
--查询临时表中数据
--SELECT * FROM #temp  
 
set @Num=0 --赋初始值
 
--查询是否存在记录，只要存在会一直循环直到不存在（WHILE EXISTS）
WHILE EXISTS(SELECT FItemID FROM #temp_Material)
 BEGIN
      
         set @Num= @Num + 1
                  
         -- 取值(把临时表中的值赋值给定义的变量)
         SELECT top 1 @FItemID=FItemID,@FNumber=FNumber,@FName=FName FROM #temp_Material;
         --取出库数和剩余数量
         SELECT @FWeight=FOutQty,@FRemainWeight=FEndQty 
          FROM #t_TempInOut WHERE FName=@FName
         
         --计算

     ;WITH InStock
     AS
     (
          SELECT t3.FName,t2.FEntrySelfA0154,t2.FAuxQty,t1.FDate 
          FROM ICStockBill t1
          LEFT join ICStockBillEntry t2 on t1.FInterID=t2.FInterID
          LEFT JOIN t_ICItem t3 ON t2.FItemID=t3.FItemID
          where t3.fname=@FName
          AND (t1.FTranType=1 AND (t1.FROB=1 AND  t1.FCancellation = 0))
          AND t2.FAuxQty>0
          AND t1.FDate<'2022-04-01'
          --ORDER BY t1.FDate DESC
     ),
     sort_details AS
     (SELECT d.FDate
        ,d.FName
        ,d.FEntrySelfA0154
        ,d.FAuxQty
        ,SUM(d.FAuxQty) over(ORDER BY d.Fdate desc, d.FAuxQty) as sum_qty
     FROM InStock d
     ),
     --SELECT * FROM sort_details
     result AS
     (
     SELECT s.FDate
      ,s.FName
      ,s.FEntrySelfA0154
      ,s.FAuxQty
      ,s.sum_qty
      ,CASE
         WHEN s.sum_qty <= @FRemainWeight THEN
          0
         WHEN s.sum_qty - @FRemainWeight <= s.FAuxQty THEN
          s.sum_qty - @FRemainWeight
         ELSE
          s.FAuxQty
       END new_qty
       ,CASE
         WHEN s.sum_qty <= @FRemainWeight THEN
          'Y'
         WHEN s.sum_qty - @FRemainWeight <= s.FAuxQty THEN
          'Y'
         ELSE
          'N'
       END YN
     FROM sort_details s
     ),
     sort_details_remain AS
     (SELECT d.FDate
        ,d.FName
        ,d.FEntrySelfA0154
        ,d.FAuxQty
        ,d.new_qty
        ,d.YN
        ,SUM(d.new_qty) over(ORDER BY d.Fdate desc, d.new_qty) as sum_qty_remain
     FROM result d
     ),
     --SELECT * FROM sort_details_remain
     result_remain AS
     (
     SELECT s.FDate
      ,s.FName
      ,s.FEntrySelfA0154
      ,s.FAuxQty
      ,s.new_qty
      ,s.YN
      ,s.sum_qty_remain
      ,CASE
         WHEN s.sum_qty_remain <= @FWeight THEN
          0
         WHEN s.sum_qty_remain - @FWeight <= s.new_qty THEN
          s.sum_qty_remain - @FWeight
         ELSE
          s.new_qty
       END new_qty_remain
       ,CASE
         WHEN s.sum_qty_remain <= @FWeight THEN
          'Y'
         WHEN s.sum_qty_remain - @FWeight <= s.new_qty THEN
          'Y'
         ELSE
          'N'
       END YN_remain
     FROM sort_details_remain s
     )

     --SELECT * FROM result_remain --where YN='Y'
     --SELECT * FROM result1 where remainYN='Y' AND new_qty>0
     SELECT @FName,SUM(case when YN='Y' then FEntrySelfA0154*(FAuxQty-new_qty) end),
          SUM(case when YN='Y' then FEntrySelfA0154*(FAuxQty-new_qty) end)/@FRemainWeight,
          SUM(case when YN_remain='Y' and new_qty>0 then FEntrySelfA0154*(new_qty-new_qty_remain) end),
          SUM(case when YN_remain='Y' and new_qty>0 then FEntrySelfA0154*(new_qty-new_qty_remain) end)/@FWeight
     FROM result_remain --where YN_remain='Y'-- AND new_qty>0
         -- 输出操作（用于查看执行效果）
         --select @FItemID,@FNumber,@FName
           
     -- 删除本次操临时表中的数据（避免无限循环）
         DELETE FROM #temp_Material WHERE FItemID=@FItemID;
 END
 
--删除临时表 #temp
drop table #temp_Material

--取数
--SELECT @FWeight=FOutQty,@FRemainWeight=FEndQty 
--FROM #t_TempInOut WHERE FName='101-A'

--select @FWeight,@FRemainWeight


DROP TABLE #t_TempInOut






  --SELECT t1.FQty FROM ICInventory t1 LEFT JOIN t_ICItem t2 ON t1.FItemID=t2.FItemID
  --WHERE t2.FName='101-A' AND t1.fstockid=356

