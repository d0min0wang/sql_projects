SELECT * FROM t_TableDescription WHERE FDescription LIKE '%汇报%'

SELECT* FROM t_ICItem

SELECT* FROM SHProcRptmain

SELECT i.FFlowCardNO AS 需剪尾流转卡号,
	i.FICMOBillNO AS 生产任务单号,
	j.FName AS 产品名称,
	i.FAuxQtyPass AS 合格数量K,
	i.FAuxWhtPass AS 合格重量KG,
	i.FOperSN AS 工序号,
	l.FName AS 工序
FROM SHProcRpt i
LEFT JOIN t_ICItem j ON i.FItemID=j.FItemID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID
WHERE l.FName='成型'