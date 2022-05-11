select top 100000 FEntrySelfS0162,FEntrySelfS0169,FEntrySelfS0162*FTaxPrice,FTaxPrice,* from seorder t1
left join seorderentry t2 on t1.FinterID=t2.FInterID
where --FBillNo IN ('A120100371','A120100369')
FEntryselfS0162>0 and FEntryselfS0169>0

update t2 set t2.FEntrySelfS0169=t2.FEntrySelfS0162*t2.FAuxTaxPrice
from seorder t1
left join seorderentry t2 on t1.FinterID=t2.FInterID
where FBillNo IN ('A120100371')

