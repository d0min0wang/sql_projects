USE [AIS20100618152307]
GO
/****** 对象:  StoredProcedure [dbo].[p_xy_SamplePORFQ]    脚本日期: 06/26/2013 16:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER    PROCEDURE [dbo].[p_xy_SamplePORFQ]
	@StartDate as DateTime,
	@EndDate   as datetime
--	@EmpName as nvarchar(50),
--	@DeptName as nvarchar(50),
--	@ProdName as nvarchar(50)
AS

SET NOCOUNT ON


select tt1.FDeptName AS 部门,
	tt1.F_123 AS 登记日期,
	tt1.FCustName AS 客户名称,
	tt1.FProvince AS 省份, 
	tt1.FTradeName AS 行业,
	tt1.F_118 AS 行业结构,
	tt1.F_112 AS 配套产品,
	tt2.FCountSample AS 样品数,
	tt3.FCountPORFQ AS 报价次数, 
	tt1.FFlat AS 是否交易客户
from
(select t1.FItemID,
	t1.Fdepartment,
	t3.FName AS FDeptName,
	t1.F_123,
	t1.FName AS FCustName,
	t1.FProvince,
	t2.FName AS FTradeName,
	t1.F_118,
	t1.F_112,
	t1.FFlat 
from t_organization t1
left join t_Item t2 on t1.F_117=t2.FItemID
left join t_Department t3 on t1.Fdepartment=t3.FItemID
where 
t1.F_123>= @StartDate 
AND 
t1.F_123<= @EndDate
)tt1
left join
(select FCustomerID,
	count(FID) AS FCountSample 
from CRM_SampleReq
where 
FCustomerID IN (select FItemID from t_Organization where F_123>= @StartDate AND F_123<= @EndDate) 
group by FCustomerID)tt2 on tt1.FItemID=tt2.FCustomerID
left join
(select FCustID,
	count(FInterID) AS FCountPORFQ 
from PORFQ 
where 
FCustID IN (select FItemID from t_Organization where F_123>= @StartDate AND F_123<= @EndDate) 
group by FCustID)tt3 on tt1.FItemID=tt3.FCustID

-- =============================================
-- example to execute the store procedure
-- =============================================
--EXECUTE p_xy_SamplePORFQ '2013-03-01','2013-06-21'