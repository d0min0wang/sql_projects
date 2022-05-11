USE [AIS20131027183315]
GO
/****** Object:  StoredProcedure [dbo].[p_xy_poorder_group_month]    Script Date: 2014/1/13 8:38:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER   PROCEDURE [dbo].[p_xy_poorder_group_month]
	@FYear as nvarchar(4)
--SET @Querytime='2011-02-28'
AS
SET NOCOUNT ON


select tt1.FName AS 类别,
	tt1.FItemName AS 物料,
	tt1.FSupplyName AS 供应商, 
	sum(yearFQty) AS [整年采购数量],
	--avg(yearFTaxPrice) AS [整年平均采购单价（含税）],
	case when sum(yearFQty)=0 then 0 else sum(yearFTaxAmount)/sum(yearFQty) end AS [整年实际平均单价（含税）],
	sum(yearFTaxAmount) AS [整年采购金额（含税）],

	sum(first1FQty) AS [1月份采购数量],
	--avg(first1FTaxPrice) AS [1月份采购单价（含税）],
	case when sum(first1FQty)=0 then 0 else sum(first1FTaxAmount)/sum(first1FQty) end AS [1月实际平均单价（含税）],
	sum(first1FTaxAmount) AS [1月份采购金额（含税）],

	sum(first2FQty) AS [2月份采购数量],
	--avg(first2FTaxPrice) AS [2月份采购单价（含税）],
	case when sum(first2FQty)=0 then 0 else sum(first2FTaxAmount)/sum(first2FQty) end AS [2月实际平均单价（含税）],
	sum(first2FTaxAmount) AS [2月份采购金额（含税）],

	sum(first3FQty) AS [3月份采购数量],
	--avg(first3FTaxPrice) AS [3月份采购单价（含税）],
	case when sum(first3FQty)=0 then 0 else sum(first3FTaxAmount)/sum(first3FQty) end AS [3月实际平均单价（含税）],
	sum(first3FTaxAmount) AS [3月份采购金额（含税）],

	sum(first4FQty) AS [4月份采购数量],
	--avg(first4FTaxPrice) AS [4月份采购单价（含税）],
	case when sum(first4FQty)=0 then 0 else sum(first4FTaxAmount)/sum(first4FQty) end AS [4月实际平均单价（含税）],
	sum(first4FTaxAmount) AS [4月份采购金额（含税）],

	sum(first5FQty) AS [5月份采购数量],
	--avg(first5FTaxPrice) AS [5月份采购单价（含税）],
	case when sum(first5FQty)=0 then 0 else sum(first5FTaxAmount)/sum(first5FQty) end AS [5月实际平均单价（含税）],
	sum(first5FTaxAmount) AS [5月份采购金额（含税）],

	sum(first6FQty) AS [6月份采购数量],
	--avg(first6FTaxPrice) AS [6月份采购单价（含税）],
	case when sum(first6FQty)=0 then 0 else sum(first6FTaxAmount)/sum(first6FQty) end AS [6月实际平均单价（含税）],
	sum(first6FTaxAmount) AS [6月份采购金额（含税）],

	sum(first7FQty) AS [7月份采购数量],
	--avg(first7FTaxPrice) AS [7月份采购单价（含税）],
	case when sum(first7FQty)=0 then 0 else sum(first7FTaxAmount)/sum(first7FQty) end AS [7月实际平均单价（含税）],
	sum(first7FTaxAmount) AS [7月份采购金额（含税）],

	sum(first8FQty) AS [8月份采购数量],
	--avg(first8FTaxPrice) AS [8月份采购单价（含税）],
	case when sum(first8FQty)=0 then 0 else sum(first8FTaxAmount)/sum(first8FQty) end AS [8月实际平均单价（含税）],
	sum(first8FTaxAmount) AS [8月份采购金额（含税）],

	sum(first9FQty) AS [9月份采购数量],
	--avg(first9FTaxPrice) AS [9月份采购单价（含税）],
	case when sum(first9FQty)=0 then 0 else sum(first9FTaxAmount)/sum(first9FQty) end AS [9月实际平均单价（含税）],
	sum(first9FTaxAmount) AS [9月份采购金额（含税）],

	sum(first10FQty) AS [10月份采购数量],
	--avg(first10FTaxPrice) AS [10月份采购单价（含税）],
	case when sum(first10FQty)=0 then 0 else sum(first10FTaxAmount)/sum(first10FQty) end AS [10月实际平均单价（含税）],
	sum(first10FTaxAmount) AS [10月份采购金额（含税）],

	sum(first11FQty) AS [11月份采购数量],
	--avg(first11FTaxPrice) AS [11月份采购单价（含税）],
	case when sum(first11FQty)=0 then 0 else sum(first11FTaxAmount)/sum(first11FQty) end AS [11月实际平均单价（含税）],
	sum(first11FTaxAmount) AS [11月份采购金额（含税）],

	sum(first12FQty) AS [12月份采购数量],
	--avg(first12FTaxPrice) AS [12月份采购单价（含税）],
	case when sum(first12FQty)=0 then 0 else sum(first12FTaxAmount)/sum(first12FQty) end AS [12月实际平均单价（含税）],
	sum(first12FTaxAmount) AS [12月份采购金额（含税）]

from
(
select case t5.FName when '*' then t4.FName
			else t5.FName END as FName,
		t3.FName as FItemName,
		--t2.FItemID,
		--t1.FSupplyID,
		t6.FName as FSupplyName,
		[yearFQty]=ISNULL(t2.FQty,0),
		[yearFTaxPrice]=ISNULL(t2.FTaxPrice,0),
		[yearFTaxAmount]=ISNULL(t2.FAllAmount,0),
		--1月上半月
		[first1FQty]=ISNULL((CASE when month(t2.FDate)='1' then t2.FQty END),0),
		[first1FTaxPrice]=ISNULL((CASE when month(t2.FDate)='1' then t2.FTaxPrice END),0),
		[first1FTaxAmount]=ISNULL((CASE when month(t2.FDate)='1' then t2.FAllAmount END),0),

		[first2FQty]=ISNULL((CASE when month(t2.FDate)='2' then t2.FQty END),0),
		[first2FTaxPrice]=ISNULL((CASE when month(t2.FDate)='2' then t2.FTaxPrice END),0),
		[first2FTaxAmount]=ISNULL((CASE when month(t2.FDate)='2' then t2.FAllAmount END),0),

		[first3FQty]=ISNULL((CASE when month(t2.FDate)='3' then t2.FQty END),0),
		[first3FTaxPrice]=ISNULL((CASE when month(t2.FDate)='3' then t2.FTaxPrice END),0),
		[first3FTaxAmount]=ISNULL((CASE when month(t2.FDate)='3' then t2.FAllAmount END),0),

		[first4FQty]=ISNULL((CASE when month(t2.FDate)='4' then t2.FQty END),0),
		[first4FTaxPrice]=ISNULL((CASE when month(t2.FDate)='4' then t2.FTaxPrice END),0),
		[first4FTaxAmount]=ISNULL((CASE when month(t2.FDate)='4' then t2.FAllAmount END),0),

		[first5FQty]=ISNULL((CASE when month(t2.FDate)='5' then t2.FQty END),0),
		[first5FTaxPrice]=ISNULL((CASE when month(t2.FDate)='5' then t2.FTaxPrice END),0),
		[first5FTaxAmount]=ISNULL((CASE when month(t2.FDate)='5' then t2.FAllAmount END),0),

		[first6FQty]=ISNULL((CASE when month(t2.FDate)='6' then t2.FQty END),0),
		[first6FTaxPrice]=ISNULL((CASE when month(t2.FDate)='6' then t2.FTaxPrice END),0),
		[first6FTaxAmount]=ISNULL((CASE when month(t2.FDate)='6' then t2.FAllAmount END),0),

		[first7FQty]=ISNULL((CASE when month(t2.FDate)='7' then t2.FQty END),0),
		[first7FTaxPrice]=ISNULL((CASE when month(t2.FDate)='7' then t2.FTaxPrice END),0),
		[first7FTaxAmount]=ISNULL((CASE when month(t2.FDate)='7' then t2.FAllAmount END),0),

		[first8FQty]=ISNULL((CASE when month(t2.FDate)='8' then t2.FQty END),0),
		[first8FTaxPrice]=ISNULL((CASE when month(t2.FDate)='8' then t2.FTaxPrice END),0),
		[first8FTaxAmount]=ISNULL((CASE when month(t2.FDate)='8' then t2.FAllAmount END),0),

		[first9FQty]=ISNULL((CASE when month(t2.FDate)='9' then t2.FQty END),0),
		[first9FTaxPrice]=ISNULL((CASE when month(t2.FDate)='9' then t2.FTaxPrice END),0),
		[first9FTaxAmount]=ISNULL((CASE when month(t2.FDate)='9' then t2.FAllAmount END),0),

		[first10FQty]=ISNULL((CASE when month(t2.FDate)='10' then t2.FQty END),0),
		[first10FTaxPrice]=ISNULL((CASE when month(t2.FDate)='10' then t2.FTaxPrice END),0),
		[first10FTaxAmount]=ISNULL((CASE when month(t2.FDate)='10' then t2.FAllAmount END),0),

		[first11FQty]=ISNULL((CASE when month(t2.FDate)='11' then t2.FQty END),0),
		[first11FTaxPrice]=ISNULL((CASE when month(t2.FDate)='11' then t2.FTaxPrice END),0),
		[first11FTaxAmount]=ISNULL((CASE when month(t2.FDate)='11' then t2.FAllAmount END),0),

		[first12FQty]=ISNULL((CASE when month(t2.FDate)='12' then t2.FQty END),0),
		[first12FTaxPrice]=ISNULL((CASE when month(t2.FDate)='12' then t2.FTaxPrice END),0),
		[first12FTaxAmount]=ISNULL((CASE when month(t2.FDate)='12' then t2.FAllAmount END),0),

		t2.FDate 
from POOrder t1
left join POOrderEntry t2 on t1.FInterID=t2.FInterID
left join t_Item t3 on t2.FItemID=t3.FItemID
left join t_Item t4 on t3.FParentID=t4.FItemID
left join t_Item t5 on t4.FParentID=t5.FItemID
left join t_Supplier t6 on t1.FSupplyID=t6.FItemID
where year(t2.FDate)=@FYear
and t1.FTranType=71
--and t3.FName='资料册'
) tt1
group by tt1.FName,tt1.FItemName,tt1.FSupplyName
with rollup


--select DATEADD(mm, 0.9, GETDATE() )

--FSupplyID
--FItemID
--FQty
--FTaxAmount
--FTaxPrice
--月上半月采购数量
--select * from t_Supplier                                                                      

--select * from t_TableDescription where FDescription like '%供应商%'

--EXECUTE p_xy_poorder_group_month '2013' 


--select t3.FName,* from poorder t1
--left join poorderentry t2 on t1.finterid=t2.finterid
--left join t_Item t3 on t2.FItemID=t3.FItemID
--where fbillno='POORD002379'