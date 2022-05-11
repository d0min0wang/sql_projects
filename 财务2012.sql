USE [AIS20100618152307]
GO
/****** ����:  StoredProcedure [dbo].[p_xy_SaleByNewCust]    �ű�����: 07/02/2012 14:47:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER	PROCEDURE [dbo].[p_xy_SaleByNewCust]
	@FYear int --��ѯ���
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
--����
INSERT INTO #JRE
select FCustID,
	sum(FAmount)
from #JRC where FDate>=FMinDate and year(FDate)= CAST(@FYear as varchar(4))
Group BY FCustID
--�ڶ���
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
	--�����۳��ⵥ��ȡ���۽��
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


select t3.FName AS "�ͻ�",t4.FName AS "����",t5.FName AS "����",t6.FName AS "ҵ��Ա", 
t3.F_118 AS "��ҵ",t8.FName AS "�ؿʽ",	
CONVERT(VARCHAR(10),t2.FDate,120) AS "�״ν�������", 
ISNULL(t1.FAmount1,0) AS "����1��" , 
ISNULL(t1.FAmount2,0) AS "����2��" , 
ISNULL(t1.FAmount3,0) AS "����3��" , 
ISNULL(t1.FAmount4,0) AS "����4��" , 
ISNULL(t1.FAmount5,0) AS "����5��" , 
ISNULL(t1.FAmount6,0) AS "����6��" , 
ISNULL(t1.FAmount7,0) AS "����7��" , 
ISNULL(t1.FAmount8,0) AS "����8��" , 
ISNULL(t1.FAmount9,0) AS "����9��" , 
ISNULL(t1.FAmount10,0) AS "����10��" , 
ISNULL(t1.FAmount11,0) AS "����11��" , 
ISNULL(t1.FAmount12,0) AS "����12��" , 
ISNULL(t10.FAmountAll,0) AS "����ϼ�" , 
ISNULL(t1.FAmount13,0) AS "����1��" , 
ISNULL(t1.FAmount14,0) AS "����2��" , 
ISNULL(t1.FAmount15,0) AS "����3��" , 
ISNULL(t1.FAmount16,0) AS "����4��" , 
ISNULL(t1.FAmount17,0) AS "����5��" , 
ISNULL(t1.FAmount18,0) AS "����6��" , 
ISNULL(t1.FAmount19,0) AS "����7��" , 
ISNULL(t1.FAmount20,0) AS "����8��" , 
ISNULL(t1.FAmount21,0) AS "����9��" , 
ISNULL(t1.FAmount22,0) AS "����10��" , 
ISNULL(t1.FAmount23,0) AS "����11��" , 
ISNULL(t1.FAmount24,0) AS "����12��" , 
ISNULL(t11.FAmountAll,0) AS "����ϼ�" , 
ISNULL(t9.FAmountAll,0) AS "�ϼ�" 
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
--	'select t3.FName AS "�ͻ�",t4.FName AS "����",t5.FName AS "����",t6.FName AS "ҵ��Ա", '+
--	't3.F_118 AS "��ҵ",t8.FName AS "�ؿʽ",	'+
--	'CONVERT(VARCHAR(10),t2.FDate,120) AS "�״ν�������", '+
--	'ISNULL(t1.FAmount1,0) AS "'+ CAST(@FYear as varchar(4)) +'��1��" , '+
--	'ISNULL(t1.FAmount2,0) AS "'+ CAST(@FYear as varchar(4)) +'��2��" , '+
--	'ISNULL(t1.FAmount3,0) AS "'+ CAST(@FYear as varchar(4)) +'��3��" , '+
--	'ISNULL(t1.FAmount4,0) AS "'+ CAST(@FYear as varchar(4)) +'��4��" , '+
--	'ISNULL(t1.FAmount5,0) AS "'+ CAST(@FYear as varchar(4)) +'��5��" , '+
--	'ISNULL(t1.FAmount6,0) AS "'+ CAST(@FYear as varchar(4)) +'��6��" , '+
--	'ISNULL(t1.FAmount7,0) AS "'+ CAST(@FYear as varchar(4)) +'��7��" , '+
--	'ISNULL(t1.FAmount8,0) AS "'+ CAST(@FYear as varchar(4)) +'��8��" , '+
--	'ISNULL(t1.FAmount9,0) AS "'+ CAST(@FYear as varchar(4)) +'��9��" , '+
--	'ISNULL(t1.FAmount10,0) AS "'+ CAST(@FYear as varchar(4)) +'��10��" , '+
--	'ISNULL(t1.FAmount11,0) AS "'+ CAST(@FYear as varchar(4)) +'��11��" , '+
--	'ISNULL(t1.FAmount12,0) AS "'+ CAST(@FYear as varchar(4)) +'��12��" , '+
--	'ISNULL(t10.FAmountAll,0) AS "'+ CAST(@FYear as varchar(4)) +'��ϼ�" , '+
--	'ISNULL(t1.FAmount13,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'��1��" , '+
--	'ISNULL(t1.FAmount14,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'��2��" , '+
--	'ISNULL(t1.FAmount15,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'��3��" , '+
--	'ISNULL(t1.FAmount16,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'��4��" , '+
--	'ISNULL(t1.FAmount17,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'��5��" , '+
--	'ISNULL(t1.FAmount18,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'��6��" , '+
--	'ISNULL(t1.FAmount19,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'��7��" , '+
--	'ISNULL(t1.FAmount20,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'��8��" , '+
--	'ISNULL(t1.FAmount21,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'��9��" , '+
--	'ISNULL(t1.FAmount22,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'��10��" , '+
--	'ISNULL(t1.FAmount23,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'��11��" , '+
--	'ISNULL(t1.FAmount24,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'��12��" , '+
--	'ISNULL(t11.FAmountAll,0) AS "'+ CAST(@FYear+1 as varchar(4)) +'��ϼ�" , '+
--	'ISNULL(t9.FAmountAll,0) AS "�ϼ�" '+
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
