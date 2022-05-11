SELECT * FROM t_TableDescription WHERE FDescription LIKE '%收款%'

SELECT * FROM t_FieldDescription WHERE FTableID=50040

SELECT sum(t2.fremainamount) FROM ICSale t1
LEFT JOIN ICSaleEntry t2 ON t1.FInterID=t2.FInterID
LEFT JOIN t_Emp t3 ON t1.FEmpID=t3.FItemID
WHERE t3.FName='冯江毅'
and t1.FCheckStatus=0


SELECT *     
FROM  t_RP_ARPBill t1
LEFT JOIN t_rp_arpbillentry t2 ON t1.FBillID=t2.FBillID
LEFT  JOIN t_Emp t3 ON t1.FEmployee=t3.FItemID AND t3.FItemID<>0
WHERE isnull(t1.FCheckStatus,0)=0 AND t1.FClassTypeID=1000021 
and t3.FName='冯江毅'


SELECT *
FROM  t_RP_NewReceiveBill  t1
LEFT JOIN t_rp_Exchange t2 ON t1.FBillID=t2.FBillID
LEFT  JOIN t_Emp t3 ON t1.FEmployee=t3.FItemID AND t3.FItemID<>0
WHERE isnull(t1.FCheckStatus,0)=0 AND t1.FClassTypeID=1000005 
AND t3.FName='冯江毅'

