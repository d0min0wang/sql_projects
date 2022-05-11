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


select tt1.FName AS ���,
	tt1.FItemName AS ����,
	tt1.FSupplyName AS ��Ӧ��, 
	sum(yearFQty) AS [����ɹ�����],
	--avg(yearFTaxPrice) AS [����ƽ���ɹ����ۣ���˰��],
	case when sum(yearFQty)=0 then 0 else sum(yearFTaxAmount)/sum(yearFQty) end AS [����ʵ��ƽ�����ۣ���˰��],
	sum(yearFTaxAmount) AS [����ɹ�����˰��],

	sum(first1FQty) AS [1�·ݲɹ�����],
	--avg(first1FTaxPrice) AS [1�·ݲɹ����ۣ���˰��],
	case when sum(first1FQty)=0 then 0 else sum(first1FTaxAmount)/sum(first1FQty) end AS [1��ʵ��ƽ�����ۣ���˰��],
	sum(first1FTaxAmount) AS [1�·ݲɹ�����˰��],

	sum(first2FQty) AS [2�·ݲɹ�����],
	--avg(first2FTaxPrice) AS [2�·ݲɹ����ۣ���˰��],
	case when sum(first2FQty)=0 then 0 else sum(first2FTaxAmount)/sum(first2FQty) end AS [2��ʵ��ƽ�����ۣ���˰��],
	sum(first2FTaxAmount) AS [2�·ݲɹ�����˰��],

	sum(first3FQty) AS [3�·ݲɹ�����],
	--avg(first3FTaxPrice) AS [3�·ݲɹ����ۣ���˰��],
	case when sum(first3FQty)=0 then 0 else sum(first3FTaxAmount)/sum(first3FQty) end AS [3��ʵ��ƽ�����ۣ���˰��],
	sum(first3FTaxAmount) AS [3�·ݲɹ�����˰��],

	sum(first4FQty) AS [4�·ݲɹ�����],
	--avg(first4FTaxPrice) AS [4�·ݲɹ����ۣ���˰��],
	case when sum(first4FQty)=0 then 0 else sum(first4FTaxAmount)/sum(first4FQty) end AS [4��ʵ��ƽ�����ۣ���˰��],
	sum(first4FTaxAmount) AS [4�·ݲɹ�����˰��],

	sum(first5FQty) AS [5�·ݲɹ�����],
	--avg(first5FTaxPrice) AS [5�·ݲɹ����ۣ���˰��],
	case when sum(first5FQty)=0 then 0 else sum(first5FTaxAmount)/sum(first5FQty) end AS [5��ʵ��ƽ�����ۣ���˰��],
	sum(first5FTaxAmount) AS [5�·ݲɹ�����˰��],

	sum(first6FQty) AS [6�·ݲɹ�����],
	--avg(first6FTaxPrice) AS [6�·ݲɹ����ۣ���˰��],
	case when sum(first6FQty)=0 then 0 else sum(first6FTaxAmount)/sum(first6FQty) end AS [6��ʵ��ƽ�����ۣ���˰��],
	sum(first6FTaxAmount) AS [6�·ݲɹ�����˰��],

	sum(first7FQty) AS [7�·ݲɹ�����],
	--avg(first7FTaxPrice) AS [7�·ݲɹ����ۣ���˰��],
	case when sum(first7FQty)=0 then 0 else sum(first7FTaxAmount)/sum(first7FQty) end AS [7��ʵ��ƽ�����ۣ���˰��],
	sum(first7FTaxAmount) AS [7�·ݲɹ�����˰��],

	sum(first8FQty) AS [8�·ݲɹ�����],
	--avg(first8FTaxPrice) AS [8�·ݲɹ����ۣ���˰��],
	case when sum(first8FQty)=0 then 0 else sum(first8FTaxAmount)/sum(first8FQty) end AS [8��ʵ��ƽ�����ۣ���˰��],
	sum(first8FTaxAmount) AS [8�·ݲɹ�����˰��],

	sum(first9FQty) AS [9�·ݲɹ�����],
	--avg(first9FTaxPrice) AS [9�·ݲɹ����ۣ���˰��],
	case when sum(first9FQty)=0 then 0 else sum(first9FTaxAmount)/sum(first9FQty) end AS [9��ʵ��ƽ�����ۣ���˰��],
	sum(first9FTaxAmount) AS [9�·ݲɹ�����˰��],

	sum(first10FQty) AS [10�·ݲɹ�����],
	--avg(first10FTaxPrice) AS [10�·ݲɹ����ۣ���˰��],
	case when sum(first10FQty)=0 then 0 else sum(first10FTaxAmount)/sum(first10FQty) end AS [10��ʵ��ƽ�����ۣ���˰��],
	sum(first10FTaxAmount) AS [10�·ݲɹ�����˰��],

	sum(first11FQty) AS [11�·ݲɹ�����],
	--avg(first11FTaxPrice) AS [11�·ݲɹ����ۣ���˰��],
	case when sum(first11FQty)=0 then 0 else sum(first11FTaxAmount)/sum(first11FQty) end AS [11��ʵ��ƽ�����ۣ���˰��],
	sum(first11FTaxAmount) AS [11�·ݲɹ�����˰��],

	sum(first12FQty) AS [12�·ݲɹ�����],
	--avg(first12FTaxPrice) AS [12�·ݲɹ����ۣ���˰��],
	case when sum(first12FQty)=0 then 0 else sum(first12FTaxAmount)/sum(first12FQty) end AS [12��ʵ��ƽ�����ۣ���˰��],
	sum(first12FTaxAmount) AS [12�·ݲɹ�����˰��]

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
		--1���ϰ���
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
--and t3.FName='���ϲ�'
) tt1
group by tt1.FName,tt1.FItemName,tt1.FSupplyName
with rollup


--select DATEADD(mm, 0.9, GETDATE() )

--FSupplyID
--FItemID
--FQty
--FTaxAmount
--FTaxPrice
--���ϰ��²ɹ�����
--select * from t_Supplier                                                                      

--select * from t_TableDescription where FDescription like '%��Ӧ��%'

--EXECUTE p_xy_poorder_group_month '2013' 


--select t3.FName,* from poorder t1
--left join poorderentry t2 on t1.finterid=t2.finterid
--left join t_Item t3 on t2.FItemID=t3.FItemID
--where fbillno='POORD002379'