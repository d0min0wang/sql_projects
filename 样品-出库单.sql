select 
	t2.FName as ������˾,
--	t3.FName as �ͻ�������ҵ,
--	t2.F_118 as ������ҵ�ṹ,
--	t2.F_112 as ���ײ�Ʒ,
	t1.FText3 as ��Ʒ����, 
	t1.Ftext1 as ��Ʒ�Ϻ�,
--	t1.FDecimal2 as ��βǰ����, 
--	t1.FDecimal3 as ��β����,
--	t1.Fdate3 as ��Ʒ�������,
--	t1.Fdate5 as ��������,
	t1.FDate as ��д����,
--	t1.FDecimal4 as ��������,
	t4.FName as ������,
	t5.FName as ������
--	t1.FReqNote as ����Ҫ��
from CRM_samplereq t1 
left join t_organization t2 ON t1.FCustomerID=t2.FItemID
left join t_Emp t4 on t1.FReqestID=t4.FItemID
left join t_Department t5 on t2.FDepartment=t5.Fitemid


Select u1.FItemID,v1.FSupplyID,sum(CASE WHEN u1.FAuxQty>0 THEN u1.FAuxQty END) 
From ICStockBill v1 inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
Where v1.FTranType=2 And v1.FCheckerID>0 
and
Group by v1.FSupplyID,u1.FItemID'