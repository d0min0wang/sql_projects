SELECT * FROM t_TableDescription WHERE FDescription LIKE '%�㱨%'

SELECT* FROM t_ICItem

SELECT* FROM SHProcRptmain

SELECT i.FFlowCardNO AS ���β��ת����,
	i.FICMOBillNO AS �������񵥺�,
	j.FName AS ��Ʒ����,
	i.FAuxQtyPass AS �ϸ�����K,
	i.FAuxWhtPass AS �ϸ�����KG,
	i.FOperSN AS �����,
	l.FName AS ����
FROM SHProcRpt i
LEFT JOIN t_ICItem j ON i.FItemID=j.FItemID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID
WHERE l.FName='����'