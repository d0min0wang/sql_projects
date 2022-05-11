update t2 set t2.FPrice=117.6
--½ð¶îupdate t2 set t2.FAmount=t2.FPrice*t2.FQty
--select top 100000 t2.FAmount,t2.FPrice,t2.FAuxPrice,* 
from icstockbill t1
left join icstockbillentry t2 on t1.FinterID=t2.FInterID
where FBillNo IN ('CIN334896')