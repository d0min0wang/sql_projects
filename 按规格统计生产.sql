SELECT i.FFlowCardNO,
	i.FICMOBillNO,
	j.FName as FProdName,
	l.FName as FGXName,
	i.FAuxQtyPass,
	i.FAuxWhtPass
	--i.FOperSN AS �����
	--l.FName AS ����
FROM SHProcRpt i
LEFT JOIN t_ICItem j ON i.FItemID=j.FItemID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID
LEFT JOIN SHProcRptMain m ON i.FInterID=m.FInterID
WHERE
i.FInterID in(SELECT i.FInterID
			FROM SHProcRpt i
			--LEFT JOIN t_ICItem j ON i.FItemID=j.FItemID
			LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID
			--LEFT JOIN SHProcRptMain m ON i.FInterID=m.FInterID
			WHERE
			--m.FCheckStatus=1059
			--AND
			l.FName='����'
			AND
			i.FEndWorkDate>='2014-03-01')

--select * from SHProcRpt where finterid=604699