SELECT 
--	i.FFlowCardNO AS ���β��ת����,
--	i.FICMOBillNO AS �������񵥺�,
	j.FName AS ��Ʒ����,
	i.FAuxQtyFinish AS ʵ������K,
	i.FAuxWhtFinish AS ʵ������KG,
--	i.FOperSN AS �����,
--	l.FName AS ����,
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
l.FName='����'
AND
CONVERT(varchar(10),i.FEndWorkDate,120)>='2011-03-01'
AND
CONVERT(varchar(10),i.FEndWorkDate,120)<='2011-03-31'
and 
datediff(hour,i.FStartWorkDate,i.FEndWorkDate)>0
--
--select * from t_tabledescription where fdescription like '%�㱨%'
----1450020
----1450019
--
--select * from t_fielddescription where ftableid=1450020