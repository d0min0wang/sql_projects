USE [AIS20100618152307]
GO
/****** 对象:  StoredProcedure [dbo].[p_xy_SaleByCust]    脚本日期: 03/11/2011 09:40:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER	PROCEDURE [dbo].[p_xy_toGewu]
	@FStartDate datetime,
	@FEndDate datetime
AS
SET NOCOUNT ON

--IF @FStartDate='' AND @FEndDate=''
--	SET @FStartDate=GETDATE()
--	SET @FEndDate=GETDATE()
IF @FStartDate='' AND @FEndDate<>''
	SET @FStartDate=@FEndDate
IF @FStartDate<>'' AND @FEndDate=''
	SET @FEndDate=@FStartDate

--DECLARE @FYear nvarchar(20)
--DECLARE @FMonth nvarchar(20)
DECLARE @FIndex int
DECLARE @FDay int
DECLARE @Sql nvarchar(1000)
DECLARE @FProcess nvarchar(20)

SET @FDay=DATEDIFF(day,@FStartDate,@FEndDate)

SET @FIndex=0
SET @Sql='CREATE TABLE ##t_temp_cal(FProcessName nvarchar(255)'
While(@FIndex<=@FDay)
BEGIN
	SET @sql=@sql + ',FQty'+ CAST(@FIndex as varchar(2)) +' DECIMAL(18,4)'
	SET @FIndex=@FIndex+1
END
set @Sql=@Sql+')'
Execute(@Sql)
--
--select CAST(FORMAT(DATEADD(DAY,@FIndex,@FStartDate),'YYYY-MM-DD'),as varchar(10))
--CAST(YEAR(DATEADD(DAY,@FIndex,@FStartDate)),

SET @FIndex=0
While(@FIndex<=@FDay)
BEGIN
	SET @Sql='Insert Into ##t_temp_cal(fprocessname,FQty'+CAST(@FIndex as varchar(2))+')' +
	' SELECT m.FName AS fname,'+
	' ISNULL(sum(i.FAuxQtyPass),0) as FQty'+
	' FROM SHProcRpt i LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID'+
	' LEFT JOIN t_SubMessage m ON i.FTeamID=m.FInterID'+
	' WHERE year(i.FStartWorkDate)='+ CAST(YEAR(DATEADD(DAY,@FIndex,@FStartDate)) as varchar(4)) +''+ 
	' and month(i.FStartWorkDate)='+ CAST(Month(DATEADD(DAY,@FIndex,@FStartDate)) as varchar(2)) +''+ 
	' and day(i.FStartWorkDate)='+CAST(DAY(DATEADD(DAY,@FIndex,@FStartDate)) as varchar(2))+''+ 
	' group by m.FName'
	Execute(@Sql)
	set @sql='Insert Into ##t_temp_cal(fprocessname,FQty'+CAST(@FIndex as varchar(2))+')' +
	' Select case when v1.FTranType=21 then ''出库'' end,ISNULL(sum(CASE WHEN u1.FAuxQty>0 THEN u1.FAuxQty END),0)'+ 
	' From ICStockBill v1 inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID'+
	' Where v1.FTranType=21'+
	' And v1.FCheckerID>0 '+
	' And Year(v1.FDate)='+ CAST(YEAR(DATEADD(DAY,@FIndex,@FStartDate)) as varchar(4)) +''+ 
	' And Month(v1.FDate)='+ CAST(Month(DATEADD(DAY,@FIndex,@FStartDate)) as varchar(2)) +''+ 
	' And Day(v1.FDate)='+ CAST(DAY(DATEADD(DAY,@FIndex,@FStartDate)) as varchar(2)) +''+ 
	' Group by v1.FTrantype'
	Execute(@Sql)
	SET @FIndex=@FIndex+1
END


SET @FIndex=0
SET @Sql='select FProcessName AS 工序'

While(@FIndex<=@FDay)
BEGIN
	SET @sql=@sql + ',ISNULL(SUM(FQty'+ CAST(@FIndex as varchar(2)) +'),0) AS ['+ CAST(YEAR(DATEADD(DAY,@FIndex,@FStartDate)) as varchar(4)) +'年'+ CAST(MONTH(DATEADD(DAY,@FIndex,@FStartDate)) as varchar(2)) +'月'+ CAST(DAY(DATEADD(DAY,@FIndex,@FStartDate)) as varchar(2)) +'日]'
	SET @FIndex=@FIndex+1
END
set @Sql=@Sql+' from ##t_temp_cal where FProcessName in (''自动大S机'' , ''小S自动机'' , ''手工炉'' , ''麻面炉'' , ''剪尾'' , ''出库'' , ''包装'') group by FProcessName ORDER BY FProcessName DESC'
Execute(@Sql)

--select FProcessName,FQty1 from ##t_temp_cal group by FProcessName

DROP TABLE ##t_temp_cal

-- =============================================
-- example to execute the store procedure
-- EXECUTE p_xy_toGewu '2011-03-10',''
-- =============================================
