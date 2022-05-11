USE [AIS20100618152307]
GO
/****** 对象:  StoredProcedure [dbo].[p_xy_SaleByNewCust]    脚本日期: 07/02/2012 14:47:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER	PROCEDURE [dbo].[p_xy_SaleByNewCust]
	@FYear int --查询年份
AS
SET NOCOUNT ON

IF OBJECT_ID('TEMMPDB.dbo.#JRA') IS NOT NULL 
   DROP TABLE  #JRA
IF OBJECT_ID('TEMMPDB.dbo.#JRB') IS NOT NULL 
   DROP TABLE  #JRB
IF OBJECT_ID('TEMMPDB.dbo.#JRC') IS NOT NULL 
   DROP TABLE  #JRC
IF OBJECT_ID('TEMMPDB.dbo.#JRD') IS NOT NULL 
   DROP TABLE  #JRD
IF OBJECT_ID('TEMMPDB.dbo.#JRE') IS NOT NULL 
   DROP TABLE  #JRE
IF OBJECT_ID('TEMMPDB.dbo.#JRF') IS NOT NULL 
   DROP TABLE  #JRF
IF OBJECT_ID('TEMMPDB.dbo.#JRNew') IS NOT NULL 
   DROP TABLE  #JRNew
IF OBJECT_ID('TEMMPDB.dbo.#JRTempA') IS NOT NULL 
   DROP TABLE  #JRTempA
--IF (@FYear IS NULL)
--BEGIN
--	select @FYear=year(getdate())
--END
--DECLARE @FYear int
DECLARE @FIndex int
DECLARE @Sql nvarchar(2000)

CREATE Table #JRNew(FCustID int,FDate datetime)

Create Table #JRA(FCustID int,
	FAmount1 decimal(18,4),	FAmount2 decimal(18,4),
	FAmount3 decimal(18,4),	FAmount4 decimal(18,4),
	FAmount5 decimal(18,4),	FAmount6 decimal(18,4),
	FAmount7 decimal(18,4),	FAmount8 decimal(18,4),
	FAmount9 decimal(18,4),	FAmount10 decimal(18,4),
	FAmount11 decimal(18,4),FAmount12 decimal(18,4),
	FAmount13 decimal(18,4),FAmount14 decimal(18,4),
	FAmount15 decimal(18,4),FAmount16 decimal(18,4),
	FAmount17 decimal(18,4),FAmount18 decimal(18,4),
	FAmount19 decimal(18,4),FAmount20 decimal(18,4),
	FAmount21 decimal(18,4),FAmount22 decimal(18,4),
	FAmount23 decimal(18,4),FAmount24 decimal(18,4))
Create Table #JRB(FCustID int,
	FAmount1 decimal(18,4),	FAmount2 decimal(18,4),
	FAmount3 decimal(18,4),	FAmount4 decimal(18,4),
	FAmount5 decimal(18,4),	FAmount6 decimal(18,4),
	FAmount7 decimal(18,4),	FAmount8 decimal(18,4),
	FAmount9 decimal(18,4),	FAmount10 decimal(18,4),
	FAmount11 decimal(18,4),FAmount12 decimal(18,4),
	FAmount13 decimal(18,4),FAmount14 decimal(18,4),
	FAmount15 decimal(18,4),FAmount16 decimal(18,4),
	FAmount17 decimal(18,4),FAmount18 decimal(18,4),
	FAmount19 decimal(18,4),FAmount20 decimal(18,4),
	FAmount21 decimal(18,4),FAmount22 decimal(18,4),
	FAmount23 decimal(18,4),FAmount24 decimal(18,4))
CREATE TABLE #JRC(FCustID int,FMinDate datetime,
	FMaxDate datetime,FDate datetime,FAmount decimal(18,4))
CREATE TABLE #JRD(FCustID int,FAmountAll decimal(18,4))
CREATE TABLE #JRE(FCustID int,FAmountAll decimal(18,4))
CREATE TABLE #JRF(FCustID int,FAmountAll decimal(18,4))

insert into #JRNew
select * from 
(select top 10000
	v1.FSupplyID,
	min(v1.FDate) as FDate
From ICStockBill v1 
inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID 
where v1.FTranType=21
GROUP BY v1.FSupplyID) t1
where year(t1.FDate)= CAST(@FYear as varchar(4))

--select * from #JRNew order by FCustID

Select v1.FSupplyID,v1.FDate,u1.FConsignAmount 
INTO #JRTempA
From ICStockBill v1 inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
Where v1.FTranType=21 
and v1.FSupplyID in (select FCustID from #JRNew)

--select * from #JRTempA

insert into #JRC
select t1.FSupplyID,t2.FDate,dateadd(m,12,t2.FDate),t1.FDate,t1.FConsignAmount
from #JRTempA t1
left join #JRNew t2 ON t1.FSupplyID=t2.FCustID

INSERT INTO #JRD
select FCustID,
	sum(FAmount)
from #JRC where FDate>=FMinDate and FDate<=FMaxDate
Group BY FCustID
--首年
INSERT INTO #JRE
select FCustID,
	sum(FAmount)
from #JRC where FDate>=FMinDate and year(FDate)= CAST(@FYear as varchar(4))
Group BY FCustID
--第二年
INSERT INTO #JRF
select FCustID,
	sum(FAmount)
from #JRC where year(FDate)= CAST(@FYear+1 as varchar(4)) and FDate<=FMaxDate
Group BY FCustID
--
--select * from #JRD t1
--left join #JRE t2 on t1.FCustID=t2.FCustID
--left join #JRF t3 on t1.FCustID=t3.FCustID

SET @FIndex=1
While(@FIndex<=12)
BEGIN
	--从销售出库单中取销售金额
	SET @Sql='Insert Into #JRA(FCustID,FAmount' + CAST(@FIndex as varchar(2)) + ')' +
	' Select v1.FSupplyID,sum(u1.FConsignAmount) From ICStockBill v1 inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID' +
	' Where v1.FTranType=21 And Year(v1.FDate)=' + CAST(@FYear as varchar(4)) + ' And Month(v1.FDate)=' + CAST(@FIndex as varchar(2)) +
	' and v1.FSupplyID in (select FCustID from #JRNew)'+
	' Group by v1.FSupplyID,u1.FItemID'
	Execute(@Sql)

	SET @Sql='Insert Into #JRA(FCustID,FAmount' + CAST(@FIndex+12 as varchar(2)) + ')' +
	' Select v1.FSupplyID,sum(u1.FConsignAmount) From ICStockBill v1 inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID' +
	' Where v1.FTranType=21 And Year(v1.FDate)=' + CAST(@FYear+1 as varchar(4)) + ' And Month(v1.FDate)=' + CAST(@FIndex as varchar(2)) +
	' and v1.FSupplyID in (select FCustID from #JRNew)'+
	' Group by v1.FSupplyID,u1.FItemID'
	Execute(@Sql)
	SET @FIndex=@FIndex+1
END

INSERT INTO #JRB
select FCustID,SUM(FAmount1),SUM(FAmount2),SUM(FAmount3),
	SUM(FAmount4),SUM(FAmount5),SUM(FAmount6),
	SUM(FAmount7),SUM(FAmount8),SUM(FAmount9),
	SUM(FAmount10),SUM(FAmount11),SUM(FAmount12),
	SUM(FAmount13),SUM(FAmount14),SUM(FAmount15),
	SUM(FAmount16),SUM(FAmount17),SUM(FAmount18),
	SUM(FAmount19),SUM(FAmount20),SUM(FAmount21),
	SUM(FAmount22),SUM(FAmount23),SUM(FAmount24)
from #JRA 
GROUP BY FCustID


select t3.FName AS "客户",t4.FName AS "部门",t5.FName AS "区域",t6.FName AS "业务员", 
t3.F_118 AS "行业",t8.FName AS "回款方式",	
CONVERT(VARCHAR(10),t2.FDate,120) AS "首次交易日期", 
ISNULL(t1.FAmount1,0) AS "本年1月" , 
ISNULL(t1.FAmount2,0) AS "本年2月" , 
ISNULL(t1.FAmount3,0) AS "本年3月" , 
ISNULL(t1.FAmount4,0) AS "本年4月" , 
ISNULL(t1.FAmount5,0) AS "本年5月" , 
ISNULL(t1.FAmount6,0) AS "本年6月" , 
ISNULL(t1.FAmount7,0) AS "本年7月" , 
ISNULL(t1.FAmount8,0) AS "本年8月" , 
ISNULL(t1.FAmount9,0) AS "本年9月" , 
ISNULL(t1.FAmount10,0) AS "本年10月" , 
ISNULL(t1.FAmount11,0) AS "本年11月" , 
ISNULL(t1.FAmount12,0) AS "本年12月" , 
ISNULL(t10.FAmountAll,0) AS "本年合计" , 
ISNULL(t1.FAmount13,0) AS "次年1月" , 
ISNULL(t1.FAmount14,0) AS "次年2月" , 
ISNULL(t1.FAmount15,0) AS "次年3月" , 
ISNULL(t1.FAmount16,0) AS "次年4月" , 
ISNULL(t1.FAmount17,0) AS "次年5月" , 
ISNULL(t1.FAmount18,0) AS "次年6月" , 
ISNULL(t1.FAmount19,0) AS "次年7月" , 
ISNULL(t1.FAmount20,0) AS "次年8月" , 
ISNULL(t1.FAmount21,0) AS "次年9月" , 
ISNULL(t1.FAmount22,0) AS "次年10月" , 
ISNULL(t1.FAmount23,0) AS "次年11月" , 
ISNULL(t1.FAmount24,0) AS "次年12月" , 
ISNULL(t11.FAmountAll,0) AS "次年合计" , 
ISNULL(t9.FAmountAll,0) AS "合计" 
from #JRB t1 
left join #JRNew t2 ON t1.FCustID=t2.FCustID 
left join t_Organization t3 on t1.FCustID=t3.FItemID 
left join t_Department t4 on t4.FItemID=t3.FDepartment 
left join t_SubMessage t5 on t5.FInterID=t3.FRegionID 
left join t_Emp t6 on t6.FItemID=t3.Femployee 
left join t_settle t8 on t8.FItemID=t3.FSetID 
left join #JRD t9 on t1.FCustID=t9.FCustID 
left join #JRE t10 on t1.FCustID=t10.FCustID 
left join #JRF t11 on t1.FCustID=t11.FCustID 


--SET @Sql=
--	'select t3.FName AS "客户",t4.FName AS "部门",t5.FName AS "区域",t6.FName AS "业务员", '+
--	't3.F_118 AS "行业",t8.FName AS "回款方式",	'+
--	'CONVERT(VARCHAR(10),t2.FDate,120) AS "首次交易日期", '+
--	'ISNULL(t1.FAmount1,0) AS "'+ CAST(@FYear as varchar(4)) +'年1月" , '+
--	'ISNULL(t1.FAmount2,0) AS "'+ CAST(@FYear as varchar(4)) +'年2月" , '+
--	'ISNULL(t1.FAmount3,0) AS "'+ CAST(@FYear as varchar(4)) +'年3月" , '+
--	'ISNULL(t1.FAmount4,0) AS "'+ CAST(@FYear as varchar(4)) +'年4月" , '+
--	'ISNULL(t1.FAmount5,0) AS "'+ CAST(@FYear as varchar(4)) +'年5月" , '+
--	'ISNULL(t1.FAmount6,0) AS "'+ CAST(@FYear as varchar(4)) +'年6月" , '+
--	'ISNULL(t1.FAmount7,0) AS "'+ CAST(@FYear as varchar(4)) +'年7月" , '+
--	'ISNULL(t1.FAmount8,0) AS "'+ CAST(@FYear as varchar(4)) +'年8月" , '+
--	'ISNULL(t1.FAmount9,0) AS "'+ CAST(@FYear as varchar(4)) +'年9月" , '+
--	'ISNULL(t1.FAmount10,0) AS "'+ CAST(@FYear as varchar(4)) +'年10月" , '+
--	'ISNULL(t1.FAmount11,0) AS "'+ CAST(@FYear as varchar(4)) +'年11月" , '+
--	'ISNULL(t1.FAmount12,0) AS "'+ CAST(@FYear as varchar(4)) +'年12月" , '+
--	'ISNULL(t10.FAmountAll,0) AS "'+ CAST(@FYear as varchar(4)) +'年合计" , '+
--	'ISNULL(t1.FAmount13,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'年1月" , '+
--	'ISNULL(t1.FAmount14,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'年2月" , '+
--	'ISNULL(t1.FAmount15,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'年3月" , '+
--	'ISNULL(t1.FAmount16,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'年4月" , '+
--	'ISNULL(t1.FAmount17,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'年5月" , '+
--	'ISNULL(t1.FAmount18,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'年6月" , '+
--	'ISNULL(t1.FAmount19,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'年7月" , '+
--	'ISNULL(t1.FAmount20,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'年8月" , '+
--	'ISNULL(t1.FAmount21,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'年9月" , '+
--	'ISNULL(t1.FAmount22,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'年10月" , '+
--	'ISNULL(t1.FAmount23,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'年11月" , '+
--	'ISNULL(t1.FAmount24,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'年12月" , '+
--	'ISNULL(t11.FAmountAll,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'年合计" , '+
--	'ISNULL(t9.FAmountAll,0) AS "合计" '+
--	'from #JRB t1 '+
--	'left join #JRNew t2 ON t1.FCustID=t2.FCustID '+
--	'left join t_Organization t3 on t1.FCustID=t3.FItemID '+
--	'left join t_Department t4 on t4.FItemID=t3.FDepartment '+
--	'left join t_SubMessage t5 on t5.FInterID=t3.FRegionID '+
--	'left join t_Emp t6 on t6.FItemID=t3.Femployee '+
--	'left join t_settle t8 on t8.FItemID=t3.FSetID '+
--	'left join #JRD t9 on t1.FCustID=t9.FCustID '+
--	'left join #JRE t10 on t1.FCustID=t10.FCustID '+
--	'left join #JRF t11 on t1.FCustID=t11.FCustID '	
--Execute(@Sql)

drop table #JRA
drop table #JRB
drop table #JRC
drop table #JRD
drop table #JRE
drop table #JRF
drop table #JRNew
drop table #JRTempA


-- =============================================
-- EXECUTE p_xy_SaleByNewCust '2011'
-- =============================================
