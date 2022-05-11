select tt1.FSupplyID 
into #old_supply
from
(select t1.FSupplyID as FSupplyID,
	min(t1.FDate) AS FMinDate
from ICStockBill t1 
INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
where year(t1.FDate)='2015'
and
t1.FTranType=21 
And t1.FCheckerID>0 
group by t1.FSupplyID)tt1
left join
(select t1.FSupplyID as FSupplyID,
	max(t1.FDate) AS FMaxDate
from ICStockBill t1 
INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
where year(t1.FDate)='2014'
and
t1.FTranType=21 
And t1.FCheckerID>0 
group by t1.FSupplyID)tt2 on tt1.FSupplyID=tt2.FSupplyID
where datediff(month,tt2.FMaxDate,tt1.FMinDate)<=12

select tt3.FName AS ����,
	tt6.FName AS ҵ��Ա,
	tt5.FName AS ��ҵ, 
	tt2.FName AS �ͻ�����,
	--CASE tt2.FComboBox 
	--	WHEN '00' THEN '��������'
	--	WHEN '01' THEN 'չ��'
	--	WHEN '02' THEN '�ͻ�����'
	--	WHEN '03' THEN '��־'
	--	WHEN '04' THEN '�ֳ���Ϣ'
	--	WHEN '05' THEN '����Ͱ�'
	--	WHEN '06' THEN '��˾��վ'
	--	ELSE ''
	--END
	--AS ��Դ,
	--tt2.FContact AS ��ϵ��,
	--tt2.FPhone AS �绰,
	--tt2.FFax AS ����,
	--tt2.FAddress AS ��ַ,
	tt2.F_101 AS �ͻ�����,
	tt2.F_123 AS ��������,
	tt1.FConsignAmount2014 AS [2014�����۶�],
	tt1.FConsignAmount2015 AS [2015�����۶�],
	tt1.FAuxQtySum2014 AS [2014�������],
	tt1.FAuxQtySum2015 AS [2015�������]
 from
(select t1.FSupplyID as FSupplyID,
	[FConsignAmount2014]=ISNULL(SUM(CASE when year(t1.FDate)= '2014' then t2.FConsignAmount END),0),
	[FConsignAmount2015]=ISNULL(SUM(CASE when year(t1.FDate)= '2015' then t2.FConsignAmount END),0),
	--sum(t2.FConsignAmount) AS FConsignAmount,
	[FAuxQtySum2014]=ISNULL(SUM(CASE when year(t1.FDate)= '2014' then t2.FAuxQty END),0),
	[FAuxQtySum2015]=ISNULL(SUM(CASE when year(t1.FDate)= '2015' then t2.FAuxQty END),0)
from ICStockBill t1 
INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
where year(t1.FDate) in('2014','2015')
and
t1.FSupplyID in(select FSupplyID from #old_supply)
and
t1.FTranType=21 
And t1.FCheckerID>0 
group by t1.FSupplyID )tt1
LEFT JOIN t_Organization tt2 ON tt1.FSupplyID=tt2.FItemID
LEFT JOIN t_Item tt3 ON tt2.Fdepartment=tt3.FItemID
LEFT JOIN t_Item tt4 ON tt2.F_122=tt4.FItemID
LEFT JOIN t_Item tt5 ON tt2.F_117=tt5.FItemID
LEFT JOIN t_Emp tt6 ON tt2.Femployee=tt6.FItemID
--where --year(tt1.FMinDate)='2015'

drop table #old_supply