CREATE TABLE #t_xy_yejiBeforeSift(
	FJitaiName nvarchar(200),
	FRenyuanName nvarchar(200),
	FstartWorkDate nvarchar(200),
	FTeamName nvarchar(200),
	FDeviceName nvarchar(200),
	FAuxQtyPass decimal(18,4),
	FAuxWhtPass decimal(18,4),
	ISFJitaiName bit,
	ISFRenyuanName bit,
	ISFDate bit,
	ISFDeviceName bit)

INSERT INTO #t_xy_yejiBeforeSift(
	FJitaiName,
	FRenyuanName,
	FstartWorkDate,
	FTeamName,
	FDeviceName,
	FAuxQtyPass,
	FAuxWhtPass,
	ISFJitaiName,
	ISFRenyuanName,
	ISFDate,
	ISFDeviceName)
SELECT	o.FName AS FJitaiName,
	m.FName AS FRenyuanName,
	day(i.FstartWorkDate) AS FstartWorkDate,
	p.FClass AS FTeamName,
	k.FModel AS FDeviceName,
	sum(i.FAuxQtyPass) AS FAuxQtyPass,
	sum(i.FAuxWhtPass) AS FAuxWhtPass,
	GROUPING(o.FName) AS ISFName1,
	GROUPING(m.FName) AS ISFName2,
	GROUPING(day(i.FstartWorkDate)) AS ISFDate,
	GROUPING(k.FModel) AS ISFModel
FROM SHProcRpt i
--LEFT JOIN SHProcRptMain j ON i.FInterID=j.FInterID
LEFT JOIN t_ICItem k ON i.FItemID=k.FItemID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID 
LEFT JOIN t_Emp m ON i.FWorkerID=m.FItemID
LEFT JOIN t_SubMessage n ON i.FTeamID=n.FInterID
LEFT JOIN t_Resource o ON i.FdeviceID=o.FInterID
LEFT JOIN t_ICTeamTimeEntry p ON i.FteamtimeID=p.FEntryID
WHERE l.FName='³ÉÐÍ' 
	AND year(i.FstartWorkDate)='2010' 
	AND month(i.FstartWorkDate)='9'
GROUP BY o.FName,
	m.FName,
	day(i.FstartWorkDate),
	p.FClass,
	k.FModel
with rollup

select * from #t_xy_yejiBeforeSift
where ISFJitaiName=0 and ISFRenyuanName=0 and ISFDate=0 and ISFDeviceName=0

drop table #t_xy_yejiBeforeSift

