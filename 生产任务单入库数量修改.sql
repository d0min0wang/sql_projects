select 
t1.FAuxQtyFinish
,t1.FStockQty,t1.FAuxStockQty,
t2.FAuxQty,t1.*
from icmo t1
left join ICStockBillEntry t2 on t1.FInterID=t2.FICMOInterID
left join ICStockBill t3 on t2.FInterID=t3.FInterID
where --t1.FBillNo='106431'
t1.FAuxQtyFinish<>t1.FAuxStockQty
and t3.FTrantype=2
and t1.FCommitDate>='2014-01-01'


select distinct(FInterID)
from icmo
where FAuxQtyFinish<>FAuxStockQty
and FCommitDate>='2014-01-01'


update tt1 set tt1.FStockQty=tt2.FAuxQty,tt1.FAuxStockQty=tt2.FAuxQty

--select tt1.FBillNo,tt1.FInterID,tt2.FICMOInterID,tt1.FStockQty,tt1.FAuxStockQty,tt2.FAuxQty
from icmo tt1
left join 
(select  t2.FICMOInterID,sum(t2.FAuxQty) as FAuxQty from ICStockBill t1
left join ICStockBillEntry t2 on t1.FInterID=t2.FInterID
where  t1.FTrantype=2
and t2.FICMOInterID IN (select distinct(FInterID)
		from icmo
		where --FAuxQtyFinish<>FAuxStockQty
		--and 
		FCommitDate>='2014-01-01')
group by t2.FICMOInterID)tt2 on tt1.FInterID=tt2.FICMOInterID
where tt1.FInterID IN (select distinct(FInterID)
		from icmo
		where --FAuxQtyFinish<>FAuxStockQty
		--and 
		FCommitDate>='2014-01-01')
and tt1.FStockQty<>tt2.FAuxQty