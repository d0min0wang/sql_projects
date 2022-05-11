DECLARE @StartPeriod char(10)
DECLARE @EndPeriod char(10)
SET @StartPeriod='2010-03-09' --统计的年月
SET @EndPeriod='2010-03-11' --统计的年月
SELECT 
--	n.FClass,
--	o.FName,
	m.FName,
	i.FAuxWhtPass,
--	CONVERT(char(10),i.FStartWorkDate,23),
--	k.FName,
	sum(i.FAuxWhtPass) over (partition by m.fname) as sum
--	sum(i.FAuxWhtSingle)over(partition by k.FModel) FSingle,
--	sum(i.FAuxWhtForItem)over(partition by k.FModel) FScrapforItem,
--	sum(i.FAuxWhtScrap)over(partition by k.FModel) FScrapforWork
FROM SHProcRpt i
LEFT JOIN t_ICItem k ON i.FItemID=k.FItemID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID 
LEFT JOIN t_Emp m ON i.FWorkerID=m.FItemID
LEFT JOIN t_ICTeamTimeEntry n ON i.FTeamTimeID=n.FEntryID 
LEFT JOIN vw_Device_Resource o ON i.FDeviceID=o.FInterID 
WHERE l.FName='成型'
	AND CONVERT(char(10),i.FStartWorkDate,23) BETWEEN @StartPeriod AND @EndPeriod
order by m.fname



