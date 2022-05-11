SELECT i.FFlowCardNO AS 流转卡号,
	i.FICMOBillNO AS 生产任务单号,
	k.FName AS 班次,
	i.FOperSN AS 工序号,
	l.FName AS 工序,
	m.FName AS 生产车间,
	n.FName AS 质检人员,
	i.FEndWorkDate AS 实际完工时间,
	FAuxQtyPass,FAuxWhtPass,
	FAuxQtyFinish,FAuxWhtFinish
FROM SHProcRpt i
LEFT JOIN t_ICItem j ON i.FItemID=j.FItemID
LEFT JOIN v_ICSHOP_TeamTime k ON i.FTeamTimeID=k.FID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID 
LEFT JOIN t_SubMessage m ON i.FTeamID=m.FInterID
LEFT JOIN t_Emp n ON i.FWorkerID=n.FItemID
WHERE 
l.FName='成型' 

--select top 100 * FROM SHProcRpt