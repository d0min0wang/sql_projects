
---FInterID=40026
update t2 set t2.FOperID =(select FInterID from t_SubMessage where FName='����'),t2.FOperSN=10--40026
--select t1.FBillNo,t2.FOperSN,t2.FOperID,t2.FSourceBillNo,*
from icstockbill t1  
left join icstockbillentry t2 on t1.finterid=t2.finterid
LEFT JOIN t_Department t3 ON     t1.FDeptID = t3.FItemID   AND t3.FItemID <>0
INNER JOIN t_Stock t4 ON     t2.FSCStockID = t4.FItemID   AND t4.FItemID <>0 
where t1.ftrantype=24 
--	and fdeptid=86 
	and (t2.FOperID is null or t2.FOperID='')
	and t3.FName IN ('����','�Զ�����','���泵��','�ֹ�����','��������','������')
	and t4.FName='���ϲ�'
	and t2.FSourceBillNo IN('68639','68790','69002')
--FOperSN
update t2 set t2.FOperID=(select FInterID from t_SubMessage where FName='����'),t2.FOperSN=10
--select t1.FBillNo,t2.FOperSN,t2.FOperID,t2.FSourceBillNo,*
from icstockbill t1  
left join icstockbillentry t2 on t1.finterid=t2.finterid
LEFT JOIN t_Department t3 ON     t1.FDeptID = t3.FItemID   AND t3.FItemID <>0
INNER JOIN t_Stock t4 ON     t2.FSCStockID = t4.FItemID   AND t4.FItemID <>0 
where t1.ftrantype=24 
--	and fdeptid=86 
--	and t2.FOperSN=0 
--	and t2.FOperID=0
--	and t3.FName IN ('����','�Զ�����','���泵��','�ֹ�����','��������','������')
	and t4.FName<>'���ϲ�'
	and t2.FSourceBillNo IN('68639','68790','69002')

--select * from t_Stock  where FName='���ϲ�'