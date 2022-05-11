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
	t2.FName as 收样公司,
--	t3.FName as 客户所属行业,
	t2.F_118 as 方普行业结构,
	t2.F_112 as 配套产品,
	t1.FText3 as 样品名称, 
	t1.Ftext1 as 样品料号,
	t1.FDecimal2 as 剪尾前单重, 
	t1.FDecimal3 as 剪尾后单重,
	t1.Fdate3 as 样品完成日期,
	t1.Fdate5 as 寄样日期,
	t1.FDecimal4 as 寄样数量,
	t4.FName as 寄样人,
	t1.FReqNote as 其他要求
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
--EXECUTE p_xy_SampleReq '','','陈晓林'

--select getdate()
