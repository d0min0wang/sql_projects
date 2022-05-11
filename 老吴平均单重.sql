select t1.*,t2.FGrossWeight from (
SELECT 	j.FNumber ,
	MIN(i.FAuxWhtSingle) '最小单重',
	MAX(i.FAuxWhtSingle) '最大单重',
	MAX(i.FAuxWhtSingle)-MIN(i.FAuxWhtSingle) '单重差值',
	AVG(i.FAuxWhtSingle) 'AvgGroWht'
FROM SHProcRpt i
LEFT JOIN t_ICItem j ON i.FItemID=j.FItemID
LEFT JOIN t_SubMessage k ON i.FOperID=k.FInterID 
where 
	k.FName='包装'
	and year(i.fstartworkdate)='2010'
	and month(i.fstartworkdate)='10'
	and FAuxWhtSingle>0
group by j.FNumber)t1
left join t_ICItem t2 on t1.FNumber=t2.FNumber
where t1.[最大单重]/t2.FGrossWeight>=2 or t2.FGrossWeight/t1.[最小单重]>=2

----90.A.FTT.FTT187-30-18A-BA20

--SELECT 	j.FNumber,
--	i.FAuxWhtSingle
--FROM SHProcRpt i
--LEFT JOIN t_ICItem j ON i.FItemID=j.FItemID
--LEFT JOIN t_SubMessage k ON i.FOperID=k.FInterID 
--where 
--	k.FName='包装'
--	and year(i.fstartworkdate)='2010'
--	and month(i.fstartworkdate)='10'
--	and FAuxWhtSingle>0
--	and j.fnumber='90.A.FTT.FTT187-30-18A-BA20'