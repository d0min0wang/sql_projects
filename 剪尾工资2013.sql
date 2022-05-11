USE [AIS20130811090352]
GO
/****** 对象:  StoredProcedure [dbo].[p_xy_Salary_of_Jianwei]    脚本日期: 10/06/2013 15:19:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER   PROCEDURE [dbo].[p_xy_Salary_of_Jianwei]
	@QueryStartTime as datetime, --查询时间，格式：YYYY-MM-DD 
	@QueryEndTime as datetime --查询时间，格式：YYYY-MM-DD
AS
SET NOCOUNT ON



create table #jianweigongzi(
	FInterID int,
	FEmpNo nvarchar(200),
	FName nvarchar(200),
	FBillNo nvarchar(200),
	FFlowCardNo nvarchar(200),
	FModel nvarchar(200),
	FName1 nvarchar(200),
	FName2 nvarchar(200),
	FAuxQtyfinish decimal(18,4),
    FAuxQtyPass decimal(18,4),
	FAuxWhtfinish decimal(18,4),
	FAuxWhtForItem decimal(18,4),
	FPrice decimal(18,4),
	FSalary decimal(18,4))

create table #jianweigongzi1(
	FInterID int,
	FAuxWhtForItem decimal(18,4))

create table #jianweigongzi2(
	FInterID int,
	FEmpNo nvarchar(200),
	FName nvarchar(200),
	FBillNo nvarchar(200),
	FFlowCardNo nvarchar(200),
	FModel nvarchar(200),
	FName1 nvarchar(200),
	FName2 nvarchar(200),
	FAuxQtyfinish decimal(18,4),
    FAuxQtyPass decimal(18,4),
	FAuxWhtfinish decimal(18,4),
	FAuxWhtForItem decimal(18,4),
	FPrice decimal(18,4),
	FSalary decimal(18,4))


insert into #jianweigongzi
SELECT i.FInterID,
	k.F_102,
	k.FName,
	j.FBillNo,
	i.FFlowCardNo,
	m.FModel,
	m.FName AS FName1,
	l.FName AS FName2,
	i.FAuxQtyfinish,
    i.FAuxQtyPass,
	i.FAuxWhtfinish,
	i.FAuxWhtForItem,
	m.F_115 AS FPrice,
	i.FAuxWhtfinish *m.F_115 AS FSalary
FROM SHProcRpt i
LEFT JOIN SHProcRptMain j ON i.FInterID=j.FInterID
LEFT JOIN t_Emp k ON i.FWorkerID=k.FItemID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID
LEFT JOIN t_ICItem m ON i.FItemID=m.FItemID
WHERE
l.FName='剪尾'
AND
CONVERT(VARCHAR(10),i.FEndWorkDate,120)>=@QueryStartTime
AND
CONVERT(VARCHAR(10),i.FEndWorkDate,120)<=@QueryEndTime

insert into #jianweigongzi1
select tt1.FInterID,isnull(tt1.FAuxWhtForItem,0) from
SHProcRpt tt1
LEFT JOIN t_SubMessage tt2 ON tt1.FOperID=tt2.FInterID
where
tt2.FName='质检'
and
tt1.FInterID IN (select distinct FInterID from #jianweigongzi)


insert into #jianweigongzi2
select tt1.FInterID,
	tt1.FEmpNo,
	tt1.FName,
	tt1.FBillNo,
	tt1.FFlowCardNo,
	tt1.FModel,
	tt1.FName1,
	tt1.FName2,
	tt1.FAuxQtyfinish,
    tt1.FAuxQtyPass,
	tt1.FAuxWhtfinish,
	isnull(tt1.FAuxWhtForItem,0)+isnull(tt2.FAuxWhtForItem,0),
	tt1.FPrice,
	tt1.FSalary
from #jianweigongzi tt1
left join #jianweigongzi1 tt2 on tt1.FInterID=tt2.FInterID

SELECT FBillNo AS 流转卡编号 ,
	FEmpNo AS 员工编号,
	FName AS 员工名称 ,
	FFlowCardNo AS 流转卡号,
	FName1 AS 产品名称 ,
	FName2 AS 工序,
	FAuxWhtfinish AS 实做重量, 
	FAuxQtyfinish AS 实做数量 ,
	FAuxWhtForItem AS 报废重量,
	FPrice AS 单价,
	FSalary AS 工资
from(
	SELECT FBillNo,
		FEmpNo,
		FName,
		FFlowCardNo,
		FName1,
		FName2,
		FAuxWhtfinish, 
		FAuxQtyfinish,
		FAuxWhtForItem,
		FPrice,
		FSalary,
		s0=0 
	FROM #jianweigongzi2
	union all
	SELECT '合计',
		'',
		FName,
		'',
		'',
		'',
		sum(FAuxWhtfinish), 
		sum(FAuxQtyfinish),
		sum(FAuxWhtForItem),
		0,
		sum(FSalary),
		s0=1 
	FROM #jianweigongzi2
	group by FName
)table1
order by FName,s0

drop table #jianweigongzi
drop table #jianweigongzi1
drop table #jianweigongzi2
-- =============================================
-- example to execute the store procedure
-- =============================================
-- EXECUTE p_xy_Salary_of_Jianwei '2013-09-01','2013-09-30'

--select top 1000 * from SHProcRpt-- t1
----left join SHProcRptMain t2 on t1.FInterID=t2.FInterID
--where FFlowCardNo like '%09270451004%'
