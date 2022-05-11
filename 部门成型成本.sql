USE [AIS20131027183315]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER	PROCEDURE [dbo].[p_xy_CostOFDept]
	@FStartDate datetime,
	@FEndDate datetime
AS
SET NOCOUNT ON

CREATE TABLE #t_temp_CostOFDept(FProdName varchar(255),
	FCount integer,
	FAuxWhtfinish decimal(18,4),
	FAuxWhtSingle decimal(18,4),
	FAuxQtyfinish decimal(18,4),
	FDeptName1 varchar(255),
	FAuxQty1 decimal(18,4),
	FDeptName2 varchar(255),
	FAuxQty2 decimal(18,4),
	FDeptName3 varchar(255),
	FAuxQty3 decimal(18,4),
	FDeptName4 varchar(255),
	FAuxQty4 decimal(18,4),
	FDeptName5 varchar(255),
	FAuxQty5 decimal(18,4)
	)

SELECT 
	m.FName AS FName1,
	count(l.FName) AS FName2,	
	sum(isnull(i.FAuxWhtfinish,0)) as FAuxWhtfinish,
	avg(isnull(i.FAuxWhtSingle,0)) as FAuxWhtSingle
into #temp_SHProRptforBMCB
FROM SHProcRpt i
LEFT JOIN SHProcRptMain j ON i.FInterID=j.FInterID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID
LEFT JOIN t_ICItem m ON i.FItemID=m.FItemID
WHERE
l.FName='����'
AND
CONVERT(VARCHAR(10),i.FEndWorkDate,120)>=@FStartDate
AND
CONVERT(VARCHAR(10),i.FEndWorkDate,120)<=@FEndDate
group by m.FName

SELECT 
		u4.FName as FDeptName,
		u5.FName as FProdName,  
		sum(ISNULL(u2.FAuxQty,0)) as FAuxQty
into #temp_ICStockBillforBMCB
FROM ICStockBill u1 
INNER JOIN ICStockBillEntry u2 ON u2.FInterID=u1.FInterID
LEFT JOIN t_Organization u3 ON u1.FSupplyID=u3.FItemID
LEFT JOIN t_Item u4 ON u3.Fdepartment=u4.FItemID
LEFT JOIN t_Item u5 ON u2.FItemID=u5.FItemID
where
CONVERT(VARCHAR(10),u1.FDate,120)>=@FStartDate
AND
CONVERT(VARCHAR(10),u1.FDate,120)<=@FEndDate
and u1.FTranType=21 
and u1.FCheckerID>0
group by u5.FName,u4.FName

insert into #t_temp_CostOFDept(FProdName,
	FCount,
	FAuxWhtfinish,
	FAuxWhtSingle,
	FAuxQtyfinish,
	--FDeptName1,
	FAuxQty1,
	--FDeptName2,
	FAuxQty2,
	--FDeptName3,
	FAuxQty3,
	--FDeptName4,
	FAuxQty4,
	--FDeptName5,
	FAuxQty5)
select t1.FName1,
	t1.FName2,
	t1.FAuxWhtfinish,
	t1.FAuxWhtSingle,
	t1.FAuxWhtfinish/t1.FAuxWhtSingle,
	--case when t2.FDeptName='��������ҵ��' then t2.FDeptName end,
	case when t2.FDeptName='��������ҵ��' then t2.FAuxQty end,
	--case when t2.FDeptName='����ñ��ҵ��' then t2.FDeptName end,
	case when t2.FDeptName='����ñ��ҵ��' then t2.FAuxQty end,
	--case when t2.FDeptName='�ְ�����ҵ��' then t2.FDeptName end,
	case when t2.FDeptName='�ְ�����ҵ��' then t2.FAuxQty end,
	--case when t2.FDeptName='�ܼ���ҵ��' then t2.FDeptName end,
	case when t2.FDeptName='�ܼ���ҵ��' then t2.FAuxQty end,
	--case when t2.FDeptName='��������' then t2.FDeptName end,
	case when t2.FDeptName='��������' then t2.FAuxQty end
from #temp_SHProRptforBMCB t1
left join #temp_ICStockBillforBMCB t2 on t1.FName1=t2.FProdName
--where t2.FDeptName='��������ҵ��'
--order by FName1

select FProdName as ����ͺ�,
	FCount as ��������,
	FAuxWhtfinish as ��������,
	FAuxWhtSingle as ���͵���,
	FAuxQtyfinish as ��������,
	--FDeptName1 as ��������ҵ��,
	FAuxQty1 as �����׳�����,
	--FDeptName2 as ����ñ��ҵ��,
	FAuxQty2 as ����ñ������,
	--FDeptName3 as �ְ�����ҵ��,
	FAuxQty3 as �ְ��׳�����,
	--FDeptName4 as �ܼ���ҵ��,
	FAuxQty4 as �ܼ�������,
	--FDeptName5 as ��������,
	FAuxQty5 as �������������
from #t_temp_CostOFDept

drop table #temp_SHProRptforBMCB
drop table #temp_ICStockBillforBMCB
--select top 100 * from dbo.SHProcRpt

-- =============================================
-- example to execute the store procedure
-- EXECUTE p_xy_CostOFDept '2014-08-01','2014-08-30'
-- =============================================

--183.61.49.150

��� �ռ��� �ļ����� ����