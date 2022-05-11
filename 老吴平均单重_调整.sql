select tt1.*,tt2.FGrossWeight,tt1.AvgGroWht_AfterAdjust-tt2.FGrossWeight AS compare from
(select t2.FNumber,
	AVG(t1.FAuxWhtSingle) 'AvgGroWht_AfterAdjust' from SHProcRpt t1
LEFT JOIN t_ICItem t2 ON t1.FItemID=t2.FItemID
LEFT JOIN t_SubMessage t3 ON t1.FOperID=t3.FInterID 
LEFT JOIN (SELECT 	j.FNumber ,
	MIN(i.FAuxWhtSingle) 'min',
	MAX(i.FAuxWhtSingle) 'max',
	MAX(i.FAuxWhtSingle)-MIN(i.FAuxWhtSingle) '单重差值',
	AVG(i.FAuxWhtSingle) 'AvgGroWht'
FROM SHProcRpt i
LEFT JOIN t_ICItem j ON i.FItemID=j.FItemID
LEFT JOIN t_SubMessage k ON i.FOperID=k.FInterID 
where 
	k.FName='包装'
	and year(i.fstartworkdate)='2010'
--	and month(i.fstartworkdate)='10'
	and FAuxWhtSingle>0
group by j.FNumber)t4 ON t2.FNumber=t4.FNumber

where 
	t3.FName='包装'
	and year(t1.fstartworkdate)='2010'
--	and month(t1.fstartworkdate)='10'
	and t1.FAuxWhtSingle<1.4826*t4.AvgGroWht
	and t1.FAuxWhtSingle>t4.AvgGroWht/1.4826
group by t2.FNumber)tt1
left join t_ICItem tt2 on tt1.FNumber=tt2.FNumber
order by compare

