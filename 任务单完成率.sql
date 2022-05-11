USE [AIS20100618152307]
GO
/****** ����:  StoredProcedure [dbo].[p_xy_ICMO_Per]    �ű�����: 12/05/2011 10:12:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[p_xy_ICMO_Per]
	@Year as nvarchar(4)
AS
SET NOCOUNT ON
DECLARE @Max as nvarchar(10)
DECLARE @Min as nvarchar(10)
DECLARE @Avg as nvarchar(10)
--FStatus=0 �ƻ�
--FStatus=5 ȷ��
--FStatus=1 OR FStatus=2 �´�
--FStatus=3 �᰸ 
Select IDENTITY(INT,1,1) AS autoID,
	v1.FInterID as FInterID,
	v1.Fauxqty as Fauxqty, --�ƻ���������
	v1.FAuxStockQty as FAuxStockQty, --�깤�������
	v1.FAuxStockQty-v1.Fauxqty as FCompare,
	cast((v1.FAuxStockQty-v1.Fauxqty)/v1.Fauxqty as decimal(10,2)) as FComparePer,
	v1.FStatus as FStatus, --״̬
	v1.FPlanCommitDate AS FPlanCommitDate
into #ICMO_temp
from ICMO v1 
--INNER JOIN t_ICItem t9 ON   v1.FItemID = t9.FItemID  AND t9.FItemID<>0 
 where 1=1 
AND CAST(YEAR(v1.FPlanCommitDate) as varchar(4))= @Year  
--AND (CONVERT(VARCHAR(10),v1.FPlanCommitDate,120)<= (case when CONVERT(VARCHAR(10),@EndDate,120)='1900-01-01' then getdate() else @EndDate end))
AND v1.FTranType = 85 
AND v1.FType <> 11060
AND v1.FCancellation = 0

select @Max=cast(cast(max(FComparePer) as decimal(10,2)) as varchar)+'%' from #ICMO_temp
select @Min=cast(cast(min(FComparePer) as decimal(10,2)) as varchar)+'%' from #ICMO_temp
select @Avg=cast(cast(avg(FComparePer) as decimal(10,2)) as varchar)+'%' from #ICMO_temp

select
	[ʱ��]='' + @Year + '��ϼ�',
	[����]=ISNULL(COUNT(autoID),0),
	[��������]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[���������]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[�ѽ᰸����]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[�ѽ᰸���񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[�ѽ᰸��������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[�ѽ᰸���������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[δ�᰸�����>�ƻ�����]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[δ�᰸�����>�ƻ��������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[��������]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[�������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp
--���²�ѯ��ϸ����
union ALL
select
	[ʱ��]='01��',
	[����]=ISNULL(COUNT(autoID),0),
	[��������]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[���������]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[�ѽ᰸����]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[�ѽ᰸���񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[�ѽ᰸��������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[�ѽ᰸���������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[δ�᰸�����>�ƻ�����]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[δ�᰸�����>�ƻ��������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[��������]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[�������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='01'
union ALL
select
	[ʱ��]='02��',
	[����]=ISNULL(COUNT(autoID),0),
	[��������]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[���������]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[�ѽ᰸����]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[�ѽ᰸���񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[�ѽ᰸��������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[�ѽ᰸���������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[δ�᰸�����>�ƻ�����]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[δ�᰸�����>�ƻ��������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[��������]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[�������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='02'
union ALL
select
	[ʱ��]='03��',
	[����]=ISNULL(COUNT(autoID),0),
	[��������]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[���������]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[�ѽ᰸����]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[�ѽ᰸���񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[�ѽ᰸��������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[�ѽ᰸���������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[δ�᰸�����>�ƻ�����]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[δ�᰸�����>�ƻ��������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[��������]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[�������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='03'
union ALL
select
	[ʱ��]='04��',
	[����]=ISNULL(COUNT(autoID),0),
	[��������]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[���������]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[�ѽ᰸����]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[�ѽ᰸���񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[�ѽ᰸��������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[�ѽ᰸���������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[δ�᰸�����>�ƻ�����]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[δ�᰸�����>�ƻ��������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[��������]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[�������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='04'
union ALL
select
	[ʱ��]='05��',
	[����]=ISNULL(COUNT(autoID),0),
	[��������]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[���������]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[�ѽ᰸����]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[�ѽ᰸���񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[�ѽ᰸��������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[�ѽ᰸���������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[δ�᰸�����>�ƻ�����]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[δ�᰸�����>�ƻ��������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[��������]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[�������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='05'
union ALL
select
	[ʱ��]='06��',
	[����]=ISNULL(COUNT(autoID),0),
	[��������]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[���������]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[�ѽ᰸����]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[�ѽ᰸���񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[�ѽ᰸��������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[�ѽ᰸���������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[δ�᰸�����>�ƻ�����]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[δ�᰸�����>�ƻ��������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[��������]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[�������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='06'
union ALL
select
	[ʱ��]='07��',
	[����]=ISNULL(COUNT(autoID),0),
	[��������]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[���������]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[�ѽ᰸����]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[�ѽ᰸���񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[�ѽ᰸��������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[�ѽ᰸���������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[δ�᰸�����>�ƻ�����]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[δ�᰸�����>�ƻ��������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[��������]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[�������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='07'
union ALL
select
	[ʱ��]='08��',
	[����]=ISNULL(COUNT(autoID),0),
	[��������]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[���������]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[�ѽ᰸����]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[�ѽ᰸���񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[�ѽ᰸��������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[�ѽ᰸���������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[δ�᰸�����>�ƻ�����]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[δ�᰸�����>�ƻ��������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[��������]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[�������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='08'
union ALL
select
	[ʱ��]='09��',
	[����]=ISNULL(COUNT(autoID),0),
	[��������]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[���������]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[�ѽ᰸����]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[�ѽ᰸���񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[�ѽ᰸��������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[�ѽ᰸���������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[δ�᰸�����>�ƻ�����]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[δ�᰸�����>�ƻ��������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[��������]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[�������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='09'
union ALL
select
	[ʱ��]='10��',
	[����]=ISNULL(COUNT(autoID),0),
	[��������]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[���������]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[�ѽ᰸����]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[�ѽ᰸���񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[�ѽ᰸��������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[�ѽ᰸���������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[δ�᰸�����>�ƻ�����]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[δ�᰸�����>�ƻ��������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[��������]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[�������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='10'
UNION ALL
select
	[ʱ��]='11��',
	[����]=ISNULL(COUNT(autoID),0),
	[��������]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[���������]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[�ѽ᰸����]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[�ѽ᰸���񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[�ѽ᰸��������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[�ѽ᰸���������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[δ�᰸�����>�ƻ�����]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[δ�᰸�����>�ƻ��������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[��������]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[�������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='11'
UNION ALL
select
	[ʱ��]='12��',
	[����]=ISNULL(COUNT(autoID),0),
	[��������]=CAST(ISNULL(SUM(Fauxqty),0) as decimal(10,3)),
	[���������]=CAST(ISNULL(sum(FAuxStockQty),0) as decimal(10,3)),
	[�ѽ᰸����]=ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0),
	[�ѽ᰸���񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus=3 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[�ѽ᰸��������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN Fauxqty END),0) as decimal(10,3)),
	[�ѽ᰸���������]=CAST(ISNULL(SUM(CASE WHEN FStatus=3 THEN FAuxStockQty END),0) as decimal(10,3)),
	[δ�᰸�����>�ƻ�����]=ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0),
	[δ�᰸�����>�ƻ��������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FStatus<>3 AND FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%',
	[��������]=ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0),
	[�������񵥰ٷֱ�]=CAST(CAST(ISNULL(COUNT(CASE WHEN FCompare>0 THEN autoID END),0)*100/CAST(COUNT(autoID) as decimal(10,2)) as decimal(10,2)) AS VARCHAR)+'%'
FROM #ICMO_temp WHERE MONTH(FPlanCommitDate)='12'
UNION ALL
select
	[ʱ��]='���г����������Ϊ:' +@Max+ '',
	[����]=NULL,
	[��������]=NULL,
	[���������]=NULL,
	[�ѽ᰸����]=NULL,
	[�ѽ᰸���񵥰ٷֱ�]='',
	[�ѽ᰸��������]=NULL,
	[�ѽ᰸���������]=NULL,
	[δ�᰸�����>�ƻ�����]=NULL,
	[δ�᰸�����>�ƻ��������񵥰ٷֱ�]='',
	[��������]=NULL,
	[�������񵥰ٷֱ�]=''
UNION ALL
select
	[ʱ��]='����������СΪ:' +@Min+ '',
	[����]=NULL,
	[��������]=NULL,
	[���������]=NULL,
	[�ѽ᰸����]=NULL,
	[�ѽ᰸���񵥰ٷֱ�]='',
	[�ѽ᰸��������]=NULL,
	[�ѽ᰸���������]=NULL,
	[δ�᰸�����>�ƻ�����]=NULL,
	[δ�᰸�����>�ƻ��������񵥰ٷֱ�]='',
	[��������]=NULL,
	[�������񵥰ٷֱ�]=''
UNION ALL
select
	[ʱ��]='ƽ��ֵΪ:' +@Avg+ '',
	[����]=NULL,
	[��������]=NULL,
	[���������]=NULL,
	[�ѽ᰸����]=NULL,
	[�ѽ᰸���񵥰ٷֱ�]='',
	[�ѽ᰸��������]=NULL,
	[�ѽ᰸���������]=NULL,
	[δ�᰸�����>�ƻ�����]=NULL,
	[δ�᰸�����>�ƻ��������񵥰ٷֱ�]='',
	[��������]=NULL,
	[�������񵥰ٷֱ�]=''


--select * from #ICMO_temp

DROP TABLE #ICMO_temp

-- =============================================
-- example to execute the store procedure
-- =============================================
--EXECUTE p_xy_ICMO_Per '2011'