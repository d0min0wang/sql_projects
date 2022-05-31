

--EXEC p_xy_raw_material_price_calculation '2022','04'
--TRUNCATE TABLE t_xy_Raw_Material_Price

--原材料单价计算
IF OBJECT_ID('tempdb.dbo.#t_TempOutput','U') IS NOT NULL DROP TABLE dbo.#t_TempOutput;
IF OBJECT_ID('tempdb.dbo.#t_TempInOut','U') IS NOT NULL DROP TABLE dbo.#t_TempInOut;
IF OBJECT_ID('tempdb.dbo.#temp_Material','U') IS NOT NULL DROP TABLE dbo.#temp_Material;

IF OBJECT_ID('AIS20140921170539.dbo.t_xy_Raw_Material_Price','U') IS NOT NULL 
   BEGIN
      TRUNCATE TABLE dbo.t_xy_Raw_Material_Price;
   END
ELSE
   BEGIN
      CREATE TABLE [dbo].[t_xy_Raw_Material_Price](
	      [FNumber] [varchar](255) NULL,
	      [FName] [varchar](255) NULL,
	      [FBegQty] [decimal](38, 10) NULL,
	      [FInQty] [decimal](38, 10) NULL,
         [FOutQty] [decimal](38, 10) NULL,
         [FOutPrice] [decimal](38, 10) NULL,
         [FOutCost] [decimal](38, 10) NULL,
         [FEndQty] [decimal](38, 10) NULL,
         [FRemainPrice] [decimal](38, 10) NULL,
         [FRemainCost] [decimal](38, 10) NULL
      ) ON [PRIMARY]
   END

DECLARE @FYear nvarchar(4)
DECLARE @FMonth nVARCHAR(2)
DECLARE @FWeight decimal(28,10)
DECLARE @FRemainWeight decimal(18,3)
DECLARE @FItemID AS INT
DECLARE @FNumber AS NVARCHAR(100)
DECLARE @FName AS NVARCHAR(100)
DECLARE @Num AS INT
DECLARE @ThisMonthFirstDay NVARCHAR(10)
DECLARE @NextMonthFirstDay NVARCHAR(10)

SET @FYear=YEAR(DATEADD(MONTH,-1,GETDATE()))
SET @FMonth=MONTH(DATEADD(MONTH,-1,GETDATE()))
--SET @ThisMonthFirstDay=DATEFROMPARTS ( @FYear, @FMonth, 1 )
SET @ThisMonthFirstDay=DATEADD(month, DATEDIFF(month, 0, DATEADD(MONTH,-1,GETDATE())), 0)
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
   FOutPrice Decimal(28,10) Default(0),
   FRemainQty Decimal(28,10) Default(0),
   FRemainPrice Decimal(28,10) Default(0)
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
     ;WITH InStock
     AS
     (
          SELECT t3.FName,t2.FEntrySelfA0154,t2.FAuxQty,t1.FDate 
          FROM ICStockBill t1
          LEFT join ICStockBillEntry t2 on t1.FInterID=t2.FInterID
          LEFT JOIN t_ICItem t3 ON t2.FItemID=t3.FItemID
          where t3.FNumber=@FNumber
          AND (t1.FTranType=1 AND (t1.FROB=1 AND  t1.FCancellation = 0))
          AND t2.FAuxQty>0
          AND convert(nvarchar(10),t1.FDate,120)<@NextMonthFirstDay
          --ORDER BY t1.FDate DESC
     ),
     sort_details_of_remain AS
     (SELECT d.FDate
        ,d.FName
        ,d.FEntrySelfA0154
        ,d.FAuxQty
        ,SUM(d.FAuxQty) over(ORDER BY d.Fdate desc, d.FAuxQty) as sum_qty_of_remain
     FROM InStock d
     ),
     --SELECT * FROM sort_details
     result_of_remain AS
     (
      SELECT s.FDate,
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
      SELECT d.FDate,
         d.FName,
         d.FEntrySelfA0154,
         d.FAuxQty,
         d.new_qty_of_remain,
         d.YN_of_Remain,
         SUM(d.new_qty_of_remain) over(ORDER BY d.Fdate desc, d.new_qty_of_remain) as sum_qty_of_out
      FROM result_of_remain d
     ),
     --SELECT * FROM sort_details_remain
     result_of_out AS
     (
      SELECT s.FDate,
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

      --SELECT * FROM result_remain --where YN='Y'
      --SELECT * FROM result1 where remainYN='Y' AND new_qty>0
      --输出计算结果
      INSERT into #t_TempOutput(FNumber,
         FName,
         --FRemainQty,
         FRemainPrice,
         --FOutQty,
         FOutPrice
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
insert into [dbo].[t_xy_Raw_Material_Price](
	FNumber ,--代码,
    FName,-- 规格型号,
    FBegQty, --起初结存,
    FInQty,-- 本期收入,
    FOutQty,-- 本期发出,
    FOutPrice,-- 本期发出单价,
    FOutCost,-- 本期发出成本,
    FEndQty,-- 期末结存,
    FRemainPrice,-- 期末结存单价,
    FRemainCost
) 
SELECT t1.FNumber AS FNumber,--代码,
   t1.FName AS FName,-- 规格型号,
   ROUND(t2.FBegQty,2) AS FBegQty, --起初结存,
   ROUND(t2.FInQty,2) AS FInQty,-- 本期收入,
   ROUND(t2.FOutQty,2) AS FOutQty,-- 本期发出,
   --t1.FOutQty,
   ROUND(t1.FOutPrice,2) AS FOutPrice,-- 本期发出单价,
   ROUND(t1.FOutPrice*t2.FOutQty,2) AS FOutCost,-- 本期发出成本,
   ROUND(t2.FEndQty,2) AS FEndQty,-- 期末结存,
   --t1.FRemainQty,
   ROUND(t1.FRemainPrice,2) AS FRemainPrice,-- 期末结存单价,
   ROUND(t1.FRemainPrice*t2.FEndQty,2) AS FRemainCost-- 期末结存成本
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

--补充本月没有出库单价为0的原材料
;WITH Others
AS
(
SELECT top 1000 t1.FItemID,t1.FNumber FROM t_ICItem t1 
LEFT JOIN t_Item t2 ON t1.FParentID=t2.FItemID
left join t_item t3 on t2.FParentID=t3.FItemID
--LEFT JOIN t_Item t4 ON t3.FParentID=t4.FItemID
WHERE t3.FName='主原材料' 
AND t1.FNumber IN (select FNumber from t_xy_Raw_Material_Price where ISNULL(FOutPrice,0)=0 )
ORDER BY t1.FItemID
)
update t_xy_Raw_Material_Price SET FOutPrice=t2.FEntrySelfA0154
FROM t_xy_Raw_Material_Price t1
LEFT JOIN (
select  b.FNumber,b.FName,a.FEntrySelfA0154
	from (
		select t2.FItemID,t2.FEntrySelfA0154,ROW_NUMBER() over(partition by t2.fitemid order by t1.fdate desc) as rn
		from ICStockBill t1
      LEFT JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
      WHERE t1.FTranType=1
      AND t2.FItemID in(select FItemID from others)
		) a
   LEFT JOIN t_ICItem b ON a.FItemID=b.FItemID
	where a.rn <=1
)t2 ON t1.FNumber=t2.FNumber
WHERE ISNULL(t1.FOutPrice,0)=0

--补充本月没有出库记录的原材料
;WITH Others
AS
(
SELECT top 1000 t1.FItemID,t1.FNumber FROM t_ICItem t1 
LEFT JOIN t_Item t2 ON t1.FParentID=t2.FItemID
left join t_item t3 on t2.FParentID=t3.FItemID
--LEFT JOIN t_Item t4 ON t3.FParentID=t4.FItemID
WHERE t3.FName='主原材料' 
AND t1.FNumber NOT IN (select FNumber from t_xy_Raw_Material_Price)
ORDER BY t1.FItemID
)
INSERT into t_xy_Raw_Material_Price(FNumber,FName,FOutPrice)
select  b.FNumber,b.FName,a.FEntrySelfA0154
	from (
		select t2.FItemID,t2.FEntrySelfA0154,ROW_NUMBER() over(partition by t2.fitemid order by t1.fdate desc) as rn
		from ICStockBill t1
      LEFT JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
      WHERE t1.FTranType=1
      AND t2.FItemID in(select FItemID from others)
		) a
   LEFT JOIN t_ICItem b ON a.FItemID=b.FItemID
	where a.rn <=1;	


select * from t_xy_Raw_Material_Price ORDER BY FName
