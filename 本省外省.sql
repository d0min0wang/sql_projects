declare @FYear char(4)
declare @FMonthBegin char(2)
declare @FMonthEnd char(2)

set @FYear='2018'
set @FMonthBegin='01'
set @FMonthEnd='01'

select Fprovince,FName,count(FSupplyID) AS FCount into #shengneiwai1
from
	(
		select distinct 
			CASE WHEN t3.FProvince like '�㶫%' then '�㶫' 
			when t3.FProvince like '����%' then '����'
			else 'ʡ��' end as FProvince,
			t4.FName,
			t1.FSupplyID
		from ICStockBill t1
		inner join ICStockBillEntry t2 on t1.FInterID=t2.FInterID
		left join t_Organization t3 ON t1.FSupplyID=t3.FItemID
		left join t_Department t4 on t3.Fdepartment=t4.FItemID
		WHERE t1.FTranType=21 
			And t1.FCheckerID>0 
			and year(t1.FDate)=@FYear
			and month(t1.FDate)>=@FMonthBegin
			and month(t1.FDate)<=@FMonthEnd
--			and CONVERT(varchar(7),t1.FDate,120)<='2011-10'
		) #T1
		--	and CONVERT(varchar(10),t1.FCheckDate,120)<='2011-08-31'
		GROUP BY FProvince,FName
		ORDER BY FProvince,FName

select CASE WHEN t3.FProvince like '�㶫%' then '�㶫' 
			when t3.FProvince like '����%' then '����'
			else 'ʡ��' end as FProvince,
		--t3.FProvince,
		t4.FName,
		count(t4.FItemID) as [����],
		sum(t2.FAuxQty) as FAuxQty,
		sum(t2.FConsignAmount) as FConsignAmount 
into #shengneiwai2
from ICStockBill t1
		inner join ICStockBillEntry t2 on t1.FInterID=t2.FInterID
		left join t_Organization t3 ON t1.FSupplyID=t3.FItemID
		left join t_Department t4 on t3.Fdepartment=t4.FItemID
WHERE t1.FTranType=21 
		And t1.FCheckerID>0 
		and year(t1.FDate)=@FYear
		and month(t1.FDate)>=@FMonthBegin
		and month(t1.FDate)<=@FMonthEnd
--		and CONVERT(varchar(7),t1.FDate,120)<='2011-10'
	--	and CONVERT(varchar(10),t1.FCheckDate,120)<='2011-08-31'
GROUP BY CASE WHEN t3.FProvince like '�㶫%' then '�㶫' 
			when t3.FProvince like '����%' then '����'
			else 'ʡ��' end ,t4.FName
ORDER BY t3.FProvince,t4.FName

select u1.Fprovince as ʡ��,
	u1.FName as ��ҵ��,
	u1.FCount as �ͻ���,
	u2.FAuxQty as ������,
	u2.FConsignAmount as �������
from #shengneiwai1 u1 left join #shengneiwai2 u2 on u1.Fprovince=u2.FProvince and u1.FName=u2.FName

drop table #shengneiwai1
drop table #shengneiwai2



