SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[p_xy_raw_material_price_calculation]
	@FYear nvarchar(4),
    @FMonth nVARCHAR(2)
AS
SET NOCOUNT ON

--EXEC p_xy_raw_material_price_calculation '2022','08'

--原材料单价计算
IF OBJECT_ID('tempdb.dbo.#t_TempOutput','U') IS NOT NULL DROP TABLE dbo.#t_TempOutput;
IF OBJECT_ID('tempdb.dbo.#t_TempInOut','U') IS NOT NULL DROP TABLE dbo.#t_TempInOut;
IF OBJECT_ID('tempdb.dbo.#temp_Material','U') IS NOT NULL DROP TABLE dbo.#temp_Material;

--处理存储过程默认值
IF @FYear=''  SET @FYear=YEAR(GETDATE());
IF @FMonth='' SET @FMonth=MONTH(GETDATE());
--SELECT @FYear,@FMonth


DECLARE @FWeight decimal(28,10)
DECLARE @FRemainWeight decimal(18,3)
DECLARE @FItemID AS INT
DECLARE @FNumber AS NVARCHAR(100)
DECLARE @FName AS NVARCHAR(100)
DECLARE @Num AS INT
DECLARE @ThisMonthFirstDay NVARCHAR(10)
DECLARE @NextMonthFirstDay NVARCHAR(10)

SET @ThisMonthFirstDay=DATEFROMPARTS ( @FYear, @FMonth, 1 )
--SET @ThisMonthFirstDay=cast(CONCAT( @FYear,RIGHT('00' + @FMonth, 2),'01' ) as date)
SET @NextMonthFirstDay=DATEADD(MONTH,1,cast(@ThisMonthFirstDay as date))

--SELECT @FYear,@FMonth,@ThisMonthFirstDay,@NextMonthFirstDay
--convert(varchar(10),DATEADD(MONTH,1,DATEFROMPARTS ( @FYear, @FMonth, 1 )),120)

--SELECT @FWeight=sum(t1.FQty) FROM ICInventory t1 LEFT JOIN t_ICItem t2 ON t1.FItemID=t2.FItemID
--  WHERE t2.FName='101-A' AND t1.fstockid=356 --结存
--创建输出表
CREATE TABLE #t_TempOutput
(
   FNumber NVARCHAR(100),
   FName NVARCHAR(100),
   FOutQty Decimal(28,10) Default(0),
   FOutCost Decimal(28,10) Default(0),
   FRemainQty Decimal(28,10) Default(0),
   FRemainCost Decimal(28,10) Default(0)
)
--创建简化版物料收发汇总表
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
--EXECUTE p_xy_All_0 '2022','04','2022-04-01','2022-05-01'
EXECUTE p_xy_All_0 @FYear,@FMonth

--获取原材料数据插入临时表

SELECT t3.FName AS FTypeName,t1.FItemID,t1.FNumber,t1.fName  
INTO #temp_Material
FROM t_ICItem t1
LEFT JOIN t_Item t2 ON t1.FParentID=t2.FItemID
LEFT JOIN t_Item t3 ON t2.FParentID=t3.FItemID
WHERE t3.FName='主原材料' --AND t1.FName='1902-D'

 
--查询临时表中数据
--SELECT * FROM #temp  
 
set @Num=0 --赋初始值
 
--查询是否存在记录，只要存在会一直循环直到不存在（WHILE EXISTS）
WHILE EXISTS(SELECT FItemID FROM #temp_Material)
 BEGIN
      
      set @Num= @Num + 1
      --将变量置零
      SET @FWeight=0
      SET @FRemainWeight=0
                  
      -- 取值(把临时表中的值赋值给定义的变量)
      SELECT top 1 @FItemID=FItemID,@FNumber=FNumber,@FName=FName FROM #temp_Material;
      --取本期发出数量和期末结存数量
      SELECT @FWeight=ISNULL(FOutQty,0),@FRemainWeight=ISNULL(FEndQty,0) 
         FROM #t_TempInOut WHERE FNumber=@FNumber
         
      --计算
     ;WITH InStock_Pre
     AS
     (
          SELECT t3.FName,t2.FEntrySelfA0154,t2.FAuxQty,t1.FDate,t1.FInterID,t2.FEntryID 
          FROM ICStockBill t1
          LEFT join ICStockBillEntry t2 on t1.FInterID=t2.FInterID
          LEFT JOIN t_ICItem t3 ON t2.FItemID=t3.FItemID
          where t3.FNumber=@FNumber
          AND (t1.FTranType=1 AND (t1.FROB=1 AND  t1.FCancellation = 0))
          AND t2.FAuxQty>0
          AND convert(nvarchar(10),t1.FDate,120)<@NextMonthFirstDay
          --ORDER BY t1.FDate DESC
     ),
     InStock
     AS
     (
         SELECT FName,
            SUM(FEntrySelfA0154*FAuxQty)/SUM(FAuxQty) AS FEntrySelfA0154,
            SUM(FAuxQty) AS FAuxQty,FDate 
         FROM InStock_Pre 
         GROUP BY FName,FDate --ORDER BY FDate DESC
     ),
     sort_details_of_remain AS
     (SELECT d.FInterID
        ,d.FDate
        ,d.FName
        ,d.FEntrySelfA0154
        ,d.FAuxQty
        ,SUM(d.FAuxQty) over(ORDER BY d.Fdate desc,d.finterid desc, d.FAuxQty) as sum_qty_of_remain
     FROM InStock d
     ),
     --SELECT * FROM sort_details
     result_of_remain AS
     (
      SELECT s.FInterID,
         s.FDate,
         s.FName,
         s.FEntrySelfA0154,
         s.FAuxQty,
         s.sum_qty_of_remain,
         CASE
            WHEN s.sum_qty_of_remain <= @FRemainWeight THEN
            0
            WHEN s.sum_qty_of_remain - @FRemainWeight <= s.FAuxQty THEN
            s.sum_qty_of_remain - @FRemainWeight
         ELSE
            s.FAuxQty
         END new_qty_of_remain,
         CASE
            WHEN s.sum_qty_of_remain <= @FRemainWeight THEN
            'Y'
            WHEN s.sum_qty_of_remain - @FRemainWeight <= s.FAuxQty THEN
            'Y'
         ELSE
            'N'
         END YN_of_Remain
      FROM sort_details_of_remain s
     ),
     sort_details_of_out AS
     (
      SELECT d.FInterID,
         d.FDate,
         d.FName,
         d.FEntrySelfA0154,
         d.FAuxQty,
         d.new_qty_of_remain,
         d.YN_of_Remain,
         SUM(d.new_qty_of_remain) over(ORDER BY d.Fdate desc,d.finterid desc, d.new_qty_of_remain) as sum_qty_of_out
      FROM result_of_remain d
     ),
     --SELECT * FROM sort_details_remain
     result_of_out AS
     (
      SELECT s.FInterID,
         s.FDate,
         s.FName,
         s.FEntrySelfA0154,
         s.FAuxQty,
         s.new_qty_of_remain,
         s.YN_of_Remain,
         s.sum_qty_of_out,
      CASE
         WHEN s.sum_qty_of_out <= @FWeight THEN
          0
         WHEN s.sum_qty_of_out - @FWeight <= s.new_qty_of_remain THEN
          s.sum_qty_of_out - @FWeight
         ELSE
          s.new_qty_of_remain
      END new_qty_of_out,
      CASE
         WHEN s.sum_qty_of_out <= @FWeight THEN
          'Y'
         WHEN s.sum_qty_of_out - @FWeight <= s.new_qty_of_remain THEN
          'Y'
         ELSE
          'N'
      END YN_of_out
      FROM sort_details_of_out s
     )

      --SELECT * FROM result_of_out --where YN='Y'
      --SELECT * FROM result1 where remainYN='Y' AND new_qty>0
      --输出计算结果
      INSERT into #t_TempOutput(FNumber,
         FName,
         --FRemainQty,
         FRemainCost,
         --FOutQty,
         FOutCost
      )
      SELECT @FNumber,@FName,
         --SUM(case when YN_of_remain='Y' then FEntrySelfA0154*(FAuxQty-new_qty_of_remain) end),
         SUM(case when YN_of_remain='Y' then FEntrySelfA0154*(FAuxQty-new_qty_of_remain) end)/nullif(@FRemainWeight,0),
         --SUM(case when YN_of_out='Y' and new_qty_of_remain>0 then FEntrySelfA0154*(new_qty_of_remain-new_qty_of_out) end),
         SUM(case when YN_of_out='Y' and new_qty_of_remain>0 then FEntrySelfA0154*(new_qty_of_remain-new_qty_of_out) end)/nullif(@FWeight,0)
      FROM result_of_out --where YN_remain='Y'-- AND new_qty>0
           
      -- 删除本次操临时表中的数据（避免无限循环）
      DELETE FROM #temp_Material WHERE FItemID=@FItemID;
 END
 
SELECT t1.FNumber AS 代码,
   t1.FName 规格型号,
   ROUND(t2.FBegQty,2) 起初结存,
   ROUND(t2.FInQty,2) 本期收入,
   ROUND(t2.FOutQty,2) 本期发出,
   --t1.FOutQty,
   ROUND(t1.FOutCost,2) 本期发出单价,
   ROUND(t1.FOutCost*t2.FOutQty,2) 本期发出成本,
   ROUND(t2.FEndQty,2) 期末结存,
   --t1.FRemainQty,
   ROUND(t1.FRemainCost,2) 期末结存单价,
   ROUND(t1.FRemainCost*t2.FEndQty,2) 期末结存成本
FROM #t_TempOutput t1
LEFT JOIN #t_TempInOut t2 ON t1.FNumber=t2.FNumber
WHERE ISNULL(t2.FOutQty,0)<>0 OR ISNULL(t2.FEndQty,0)<>0
ORDER BY t1.FNumber

--删除临时表 #temp
DROP TABLE #temp_Material
DROP TABLE #t_TempInOut
DROP TABLE #t_TempOutput

--SELECT t1.FQty FROM ICInventory t1 LEFT JOIN t_ICItem t2 ON t1.FItemID=t2.FItemID
--WHERE t2.FName='101-A' AND t1.fstockid=356

GO
