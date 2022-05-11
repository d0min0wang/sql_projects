USE [AIS20100618152307]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER    PROCEDURE [dbo].[p_xy_SampleReq]
	@StartDate as DateTime,
	@EndDate   as datetime,
	@EmpName as nvarchar(50),
	@ProdName as nvarchar(50)
AS

SET NOCOUNT ON
--declare @End varchar(10)
--set @EndDate=(case when @EndDate IS NOT NULL then @EndDate else getdate() end)
--
--select @StartDate

select 
	t2.FName as ������˾,
--	t3.FName as �ͻ�������ҵ,
	t2.F_118 as ������ҵ�ṹ,
	t2.F_112 as ���ײ�Ʒ,
	t1.FText3 as ��Ʒ����, 
	t1.Ftext1 as ��Ʒ�Ϻ�,
	t1.FDecimal2 as ��βǰ����, 
	t1.FDecimal3 as ��β����,
	t1.Fdate3 as ��Ʒ�������,
	t1.Fdate5 as ��������,
	t1.FDecimal4 as ��������,
	t4.FName as ������,
	t1.FReqNote as ����Ҫ��
from CRM_samplereq t1 
left join t_organization t2 ON t1.FCustomerID=t2.FItemID
left join t_Emp t4 on t1.FReqestID=t4.FItemID
where 
(t1.Fdate>= (case when CONVERT(VARCHAR(10),@StartDate,120)='1900-01-01' then '2009-01-01' else @StartDate end)) 
and 
(t1.Fdate<= (case when CONVERT(VARCHAR(10),@EndDate,120)='1900-01-01' then getdate() else @StartDate end))
and t4.FName like '%'+@EmpName+'%'
and t1.FText3 like '%'+@ProdName+'%'

-- =============================================
-- example to execute the store procedure
-- =============================================
--EXECUTE p_xy_SampleReq '','','������'

--select getdate()
