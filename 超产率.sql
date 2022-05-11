USE [AIS20130811090352]
GO
/****** 对象:  StoredProcedure [dbo].[p_xy_Salary_part_of_OverRate]    脚本日期: 10/06/2013 15:19:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER   PROCEDURE [dbo].[p_xy_Salary_part_of_OverRate]
	@QueryStartTime as datetime, --查询时间，格式：YYYY-MM-DD 
	@QueryEndTime as datetime --查询时间，格式：YYYY-MM-DD
AS
SET NOCOUNT ON


create table #temp_chaochanlv(
	FEmpNo nvarchar(200),
	FEmpName nvarchar(200),
    FBillNo nvarchar(200),
    FModel nvarchar(200),
    FAuxQty decimal(18,4),
    FAuxStockQty decimal(18,4),
	FOver decimal(18,4),
	FOverRate decimal(18,4),
	FPrice decimal(18,4),
    FOperName nvarchar(200),
    FTeamName nvarchar(200),
	FDeduct decimal(18,4))

insert into #temp_chaochanlv(FEmpNo,FEmpName,
    FBillNo,
    FModel,
    FAuxQty,
    FAuxStockQty,
	FOver,
	FOverRate,
	FPrice,
    FOperName,
    FTeamName)
Select distinct
--    t1.FInterID,
	  t3.F_102 as FEmpNo,
      t3.FName AS FEmpName,
      t1.FBillNo as FBillNo,
      t5.FModel AS FModel,
      t1.Fauxqty AS FAuxQty,
      isnull(t1.FAuxStockQty,0) AS FAuxStockQty,
	  isnull(t1.FAuxStockQty,0)-t1.Fauxqty as FOver,
	  (isnull(t1.FAuxStockQty,0)-t1.Fauxqty)/t1.Fauxqty as FOverRate,
	  case t6.FName
			when '自动大S机' then t5.F_111
			when '小S自动机' then t5.F_112
			when '麻面炉' then t5.F_113
			when '手工炉' then t5.F_114
	  end as FPrice,
      t4.FName AS FOperName,
      t6.FName AS FTeamName
from  ICMO t1
LEFT JOIN SHProcRpt t2 ON t1.FInterID=t2.FICMOInterID
LEFT JOIN t_Emp t3 ON t2.FworkerID=t3.FItemID
LEFT JOIN t_SubMessage t4 ON t2.FOperID=t4.FInterID
LEFT JOIN t_ICItem t5 ON t1.FItemID=t5.FItemID
LEFT JOIN t_SubMessage t6 ON t2.FTeamID=t6.FInterID
where 1=1
AND
CONVERT(VARCHAR(10),t1.FCloseDate,120)>=@QueryStartTime
AND
CONVERT(VARCHAR(10),t1.FCloseDate,120)<=@QueryEndTime
--AND   
--CONVERT(char(6),t1.FCloseDate,112) =CONVERT(char(6),DATEADD(month,-1,getdate()),112)
AND
t1.Fauxqty < t1.FAuxStockQty
AND
t1.FTranType = 85
AND
t1.FType <> 11060
AND
t1.FCancellation = 0
AND
t4.FName='成型'

update #temp_chaochanlv set FDeduct=FOver*FPrice

SELECT FEmpNo AS 员工编号,
	  FEmpName AS 员工名称 ,
      FBillNo AS 流转卡编号,
      FModel AS 产品名称,
      FOperName AS 工序,
      FTeamName AS 班组,
      FAuxQty AS 任务单数量,
      FAuxStockQty AS 入库数量,
      FOver AS 超产量 ,
      FPrice AS 单价,
      FOverRate AS 超产率,
      FDeduct AS 扣款
FROM
(	select
		FEmpNo,
		FEmpName,
		FBillNo,
		FModel,
		FOperName,
		FTeamName,
		FAuxQty,
		FAuxStockQty,
		FOver,
		FPrice,
		FOverRate,
		FDeduct,
		s0=0
	from #temp_chaochanlv
	union all
	select
		'合计',
		FEmpName,
		'',
		'',
		'',
		'',
		sum(FAuxQty),
		sum(FAuxStockQty),
		sum(FOver),
		0,
		0,
		sum(FDeduct),
		s0=1
	from #temp_chaochanlv
	group by FEmpName
)table1
order by FEmpName,s0

drop table #temp_chaochanlv


-- =============================================
-- example to execute the store procedure
-- =============================================
-- EXECUTE p_xy_Salary_part_of_OverRate '2013-09-01','2013-09-30'

