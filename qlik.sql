SELECT i.FFlowCardNO AS ��ת����,
	i.FICMOBillNO AS �������񵥺�,
	k.FName AS ���,
	i.FOperSN AS �����,
	l.FName AS ����,
	m.FName AS ��������,
	n.FName AS �ʼ���Ա,
	i.FEndWorkDate AS ʵ���깤ʱ��,
	FAuxQtyPass,FAuxWhtPass,
	FAuxQtyFinish,FAuxWhtFinish
FROM SHProcRpt i
LEFT JOIN t_ICItem j ON i.FItemID=j.FItemID
LEFT JOIN v_ICSHOP_TeamTime k ON i.FTeamTimeID=k.FID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID 
LEFT JOIN t_SubMessage m ON i.FTeamID=m.FInterID
LEFT JOIN t_Emp n ON i.FWorkerID=n.FItemID
WHERE 
l.FName='����' 

--select top 100 * FROM SHProcRpt