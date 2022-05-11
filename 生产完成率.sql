SELECT 
--	i.FFlowCardNO AS 需剪尾流转卡号,
--	i.FICMOBillNO AS 生产任务单号,
	j.FName AS 产品名称,
	i.FAuxQtyFinish AS 实做数量K,
	i.FAuxWhtFinish AS 实做重量KG,
--	i.FOperSN AS 工序号,
--	l.FName AS 工序,
	l.FName,
	m.FName,
	i.FStartWorkDate,
	i.FEndWorkDate,
	datediff(hour,i.FStartWorkDate,i.FEndWorkDate) as WorkHour
--	i.FAuxWhtFinish/datediff(hour,i.FStartWorkDate,i.FEndWorkDate)
FROM SHProcRpt i
LEFT JOIN t_ICItem j ON i.FItemID=j.FItemID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID
LEFT JOIN t_SubMessage m ON i.FteamID=m.FInterID
LEFT JOIN t_SubMessage n ON i.FTeamTimeID=n.FInterID
WHERE
l.FName='成型'
AND
CONVERT(varchar(10),i.FEndWorkDate,120)>='2011-03-01'
AND
CONVERT(varchar(10),i.FEndWorkDate,120)<='2011-03-31'
and 
datediff(hour,i.FStartWorkDate,i.FEndWorkDate)>0
--
--select * from t_tabledescription where fdescription like '%汇报%'
----1450020
----1450019
--
--select * from t_fielddescription where ftableid=1450020