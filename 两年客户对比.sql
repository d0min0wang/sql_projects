select m1.FSupplyID,m1.FName as FName0,m2.FName as FName1,m4.FName as FName2,m3.FName as FName3,m1.FAuxQty,m1.FConsignAmount 
into #kehuduibi2011
from
(select 	t1.FSupplyID,
		t4.FName,
		sum(t2.FAuxQty) as FAuxQty,
		sum(t2.FConsignAmount) as FConsignAmount 
	from ICStockBill t1
		inner join ICStockBillEntry t2 on t1.FInterID=t2.FInterID
--		left join t_Organization t3 ON t1.FSupplyID=t3.FItemID
		left join t_Department t4 on t1.FDeptID=t4.FItemID
	WHERE t1.FTranType=21 
		And t1.FCheckerID>0 
		and year(t1.FDate)='2011'
		and month(t1.FDate)>='01'
		and month(t1.FDate)<='12'
		and t4.FName='管件事业部'
	group by t1.FSupplyID,t4.FName) m1
left join t_Organization m2 ON m1.FSupplyID=m2.FItemID
LEFT JOIN t_Item m3 ON m2.F_117=m3.FItemID
LEFT JOIN t_Item m4 ON m3.FParentID=m4.FItemID
LEFT JOIN t_Item m5 ON m4.FParentID=m5.FItemID

select m1.FSupplyID,m1.FName as FName0,m2.FName as FName1,m4.FName as FName2,m3.FName as FName3,m1.FAuxQty,m1.FConsignAmount 
into #kehuduibi2012
from
(select 	t1.FSupplyID,
		t4.FName,
		sum(t2.FAuxQty) as FAuxQty,
		sum(t2.FConsignAmount) as FConsignAmount 
	from ICStockBill t1
		inner join ICStockBillEntry t2 on t1.FInterID=t2.FInterID
--		left join t_Organization t3 ON t1.FSupplyID=t3.FItemID
		left join t_Department t4 on t1.FDeptID=t4.FItemID
	WHERE t1.FTranType=21 
		And t1.FCheckerID>0 
		and year(t1.FDate)='2012'
		and month(t1.FDate)>='01'
		and month(t1.FDate)<='12'
		and t4.FName='管件事业部'
	group by t1.FSupplyID,t4.FName) m1
left join t_Organization m2 ON m1.FSupplyID=m2.FItemID
LEFT JOIN t_Item m3 ON m2.F_117=m3.FItemID
LEFT JOIN t_Item m4 ON m3.FParentID=m4.FItemID
LEFT JOIN t_Item m5 ON m4.FParentID=m5.FItemID

select --FName=case when n1.FName0 is not null then n1.FName0 else n2.fname0 end,
* from #kehuduibi2011 n1
full join #kehuduibi2012 n2 on n1.FSupplyID=n2.FSupplyID
--order by FName

drop table #kehuduibi2011
drop table #kehuduibi2012