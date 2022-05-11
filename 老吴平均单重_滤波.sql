--select ttt1.*,ttt2.FGrossWeight,ttt1.AVGGrossWeightAfterAdj-ttt2.FGrossWeight AS compare 
--from (select tt2.FNumber, AVG(tt1.FAuxWhtSingle) AS AVGGrossWeightAfterAdj
--from SHProcRpt tt1
--LEFT JOIN t_ICItem tt2 ON tt1.FItemID=tt2.FItemID
--LEFT JOIN t_SubMessage tt3 ON tt1.FOperID=tt3.FInterID 
--LEFT JOIN (select t2.FNumber,
--	t2.FGrossWeight
--from SHProcRpt t1
--LEFT JOIN t_ICItem t2 ON t1.FItemID=t2.FItemID
--LEFT JOIN t_SubMessage t3 ON t1.FOperID=t3.FInterID 
--where 
--	t3.FName='包装'
--	and year(t1.fstartworkdate)='2010'
----	and month(t1.fstartworkdate)='10'
--) tt4 ON tt2.FNumber=tt4.FNumber	
--where 
--	tt3.FName='包装'
--	and year(tt1.fstartworkdate)='2010'
----	and month(tt1.fstartworkdate)='10'
--	and tt1.FAuxWhtSingle<1.3826*tt4.FGrossWeight
--	and tt1.FAuxWhtSingle>tt4.FGrossWeight/1.3826
--group by tt2.FNumber)ttt1
--left join t_ICItem ttt2 ON ttt1.FNumber=ttt2.FNumber
--order by compare


--Create Table #lvbo_1(FItemNumber nvarchar(200),FGrossWeight decimal(18,4))
Create Table #lvbo_1(FItemNumber nvarchar(200),FAVGGrossWeightAfterAdj decimal(18,4))
--insert into #lvbo_1(FItemNumber,FGrossWeight)
--select t2.FNumber,
--	t2.FGrossWeight
--from SHProcRpt t1
--LEFT JOIN t_ICItem t2 ON t1.FItemID=t2.FItemID
--LEFT JOIN t_SubMessage t3 ON t1.FOperID=t3.FInterID 
--where 
--	t3.FName='包装'
--	and year(t1.fstartworkdate)='2010'
----	and month(t1.fstartworkdate)='10'

insert into #lvbo_1(FItemNumber,FAVGGrossWeightAfterAdj)
select t2.FNumber, AVG(t1.FAuxWhtSingle) AS FAVGGrossWeightAfterAdj
from SHProcRpt t1
LEFT JOIN t_ICItem t2 ON t1.FItemID=t2.FItemID
LEFT JOIN t_SubMessage t3 ON t1.FOperID=t3.FInterID 
--LEFT JOIN #lvbo_1 t4 ON t2.FNumber=t4.FItemNumber	
where 
	t3.FName='包装'
	and year(t1.fstartworkdate)='2010'
--	and month(t1.fstartworkdate)='10'
	and t1.FAuxWhtSingle<5.3826*t2.FGrossWeight
	and t1.FAuxWhtSingle>t2.FGrossWeight/5.3826
group by t2.FNumber

--select * from #lvbo_2
select t1.*,t2.FGrossWeight,t1.FAVGGrossWeightAfterAdj-t2.FGrossWeight AS compare 
from #lvbo_1 t1
left join t_ICItem t2 ON t1.FItemNumber=t2.FNumber
order by compare

drop table #lvbo_1
--drop table #lvbo_2










