USE [AIS20130811090352]
GO
/****** 对象:  StoredProcedure [dbo].[p_xy_ICMO_Fulfill_Rate]    脚本日期: 10/06/2013 15:19:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER   PROCEDURE [dbo].[p_xy_Salary_of_Chengxing]
	@QueryStartTime as datetime, --查询时间，格式：YYYY-MM-DD 
	@QueryEndTime as datetime --查询时间，格式：YYYY-MM-DD
AS
SET NOCOUNT ON


create table #temp_gongzi(
	FInterID int,
	FEmpNo nvarchar(200),
	FName nvarchar(200),
	FBillNo nvarchar(200),
	FICMOBillNo nvarchar(200),
	FFlowCardNo nvarchar(200),
	FEndWorkDate datetime,
	FModel nvarchar(200),
	FName1 nvarchar(200),
	FName2 nvarchar(200),
	FName3 nvarchar(200),
	FPrice decimal(18,4),		
	FAuxQtyfinish decimal(18,4),
    FAuxQtyPass decimal(18,4),
	FAuxWhtfinish decimal(18,4),
	FAuxWhtScrap decimal(18,4))

create table #temp_gongzi1(
	FInterID int,
	FAuxWhtScrap decimal(18,4))

create table #temp_gongzi2(
	FInterID int,
	FAuxWhtScrap decimal(18,4))

create table #temp_gongzi3(
	FInterID int,
	FEmpNo nvarchar(200),
	FName nvarchar(200),
	FBillNo nvarchar(200),
	FICMOBillNo nvarchar(200),
	FFlowCardNo nvarchar(200),
	FEndWorkDate datetime,
	FModel nvarchar(200),
	FName1 nvarchar(200),
	FName2 nvarchar(200),
	FName3 nvarchar(200),
	FPrice decimal(18,4),
	FAuxQtyfinish decimal(18,4),
	FSalary decimal(18,4),		
    FAuxWhtfinish decimal(18,4),
	FAuxWhtScrap decimal(18,4))

insert into #temp_gongzi
SELECT i.FInterID,
	k.F_102,
	k.FName,
	j.FBillNo,
	i.FICMOBillNo,
	i.FFlowCardNo,
	i.FEndWorkDate,
	m.FModel,
	m.FName AS FName1,
	l.FName AS FName2,
	n.FName AS FName3,
	case n.FName
		when '自动大S机' then m.F_111
		when '小S自动机' then m.F_112
		when '麻面炉' then m.F_113
		when '手工炉' then m.F_114
	end as FPrice,		
	isnull(i.FAuxQtyfinish,0),
    isnull(i.FAuxQtyPass,0),
	isnull(i.FAuxWhtfinish,0),
	isnull(i.FAuxWhtScrap,0)
FROM SHProcRpt i
LEFT JOIN SHProcRptMain j ON i.FInterID=j.FInterID
LEFT JOIN t_Emp k ON i.FWorkerID=k.FItemID
LEFT JOIN dbo.t_SubMessage l ON i.FOperID=l.FInterID
LEFT JOIN t_ICItem m ON i.FItemID=m.FItemID
LEFT JOIN t_SubMessage n ON i.FTeamID=n.FInterID
WHERE
l.FName='成型'
AND
CONVERT(VARCHAR(10),i.FEndWorkDate,120)>=@QueryStartTime
AND
CONVERT(VARCHAR(10),i.FEndWorkDate,120)<=@QueryEndTime


insert into #temp_gongzi1
select tt1.FInterID,isnull(tt1.FAuxWhtScrap,0) from
SHProcRpt tt1
LEFT JOIN t_SubMessage tt2 ON tt1.FOperID=tt2.FInterID
where
tt2.FName='质检'
and
tt1.FInterID IN (select distinct FInterID from #temp_gongzi)

--(SELECT i.FInterID
--FROM AIS20130811090352.dbo.SHProcRpt i
--LEFT JOIN AIS20130811090352.dbo.t_SubMessage l ON i.FOperID=l.FInterID
--WHERE
--l.FName='成型'
--AND
--CONVERT(VARCHAR(10),i.FEndWorkDate,120)>=@QueryStartTime
--AND
--CONVERT(VARCHAR(10),i.FEndWorkDate,120)<=@QueryEndTime)

insert into #temp_gongzi2
select tt1.FInterID,isnull(tt1.FAuxWhtScrap,0) from
SHProcRpt tt1
LEFT JOIN t_SubMessage tt2 ON tt1.FOperID=tt2.FInterID
where
tt2.FName='剪尾'
and
tt1.FInterID IN (select distinct FInterID from #temp_gongzi)

--(SELECT i.FInterID
--FROM AIS20130811090352.dbo.SHProcRpt i
--LEFT JOIN AIS20130811090352.dbo.t_SubMessage l ON i.FOperID=l.FInterID
--WHERE
--l.FName='成型'
--AND CONVERT(VARCHAR(10),i.FEndWorkDate,120)>=@QueryStartTime
--AND CONVERT(VARCHAR(10),i.FEndWorkDate,120)<=@QueryEndTime)


insert into #temp_gongzi3
select 	ttt1.FInterID,
		ttt1.FEmpNo,
		ttt1.FName,
		ttt1.FBillNo,
		ttt1.FICMOBillNo,
		ttt1.FFlowCardNo,
		ttt1.FEndWorkDate,
		ttt1.FModel,
		ttt1.FName1,
		ttt1.FName2,
		ttt1.FName3,
		ttt1.FPrice,		
		ttt1.FAuxQtyfinish,
		isnull(ttt1 .FAuxQtyfinish,0)* isnull(ttt1.Fprice,0),
		ttt1.FAuxWhtfinish,
		ISNULL(ttt1.FAuxWhtScrap,0)+isNULL(ttt2.FAuxWhtScrap,0)+isNULL(ttt3.FAuxWhtScrap,0)
from #temp_gongzi ttt1
left join #temp_gongzi1 ttt2 on ttt1.FInterID=ttt2.FInterID
left join #temp_gongzi2 ttt3 on ttt1.FInterID=ttt3.FInterID

--select * from #temp_gongzi3 where FFlowCardNo='201309270451004'

select
	FBillNo AS 流转卡编号,
	FEmpNo AS 员工编号,
	FName AS 员工名称,
	FICMOBillNo AS 任务单编号,
	FFlowCardNo AS 流转卡编号,
	FEndWorkDate AS 完工日期,
	FModel AS 规格,
	FName1 AS 规格型号,
	FName2 AS 工序, 
	FName3 AS 班组,
	ISNULL(Fprice, 0) AS 单价,		
	ISNULL(FAuxQtyfinish,0) AS 实做数量,
    ISNULL(FSalary,0) AS 工资,
	ISNULL(FAuxWhtfinish,0) AS 实做重量,
	ISNULL(FAuxWhtScrap,0) AS 废品重量,
	ISNULL(FAuxWhtScrap*5 , 0) AS 废品
from(
	select 	FBillNo,
		FEmpNo,
		FName,
		FICMOBillNo,
		FFlowCardNo,
		FEndWorkDate,
		FModel,
		FName1,
		FName2,
		FName3,
		FPrice,		
		FAuxQtyfinish,
		FSalary,
		FAuxWhtfinish,
		FAuxWhtScrap,
		s0=0
	from #temp_gongzi3
	UNION ALL
	select 	'合计',
		'',
		FName,
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		0,		
		sum(FAuxQtyfinish),
		sum(FSalary),
		sum(FAuxWhtfinish),
		sum(FAuxWhtScrap),
		s0=1
	from #temp_gongzi3
	group by FName
)table1
order by FName,s0


drop table #temp_gongzi
drop table #temp_gongzi1
drop table #temp_gongzi2
drop table #temp_gongzi3


-- =============================================
-- example to execute the store procedure
-- =============================================
-- EXECUTE p_xy_Salary_of_Chengxing '2013-09-01','2013-09-30'

--select top 1000 * from SHProcRpt-- t1
----left join SHProcRptMain t2 on t1.FInterID=t2.FInterID
--where FFlowCardNo like '%09270451004%'

--select * from t_emp where fname like '%胡阿妮%'