--select * from t_tabledescription where fdescription like '%��Ʊ%'
--select * from t_fielddescription where ftableid=60038

--select * from ICStockBill   where FBillNo like 'WIN%'                                                                

select t1.FBillNo,t1.FSupplyID,t5.FName,t1.FYear,t1.FPeriod,t1.FTotalCost,
t2.FEntryID,t2.FItemID,t6.FName,t2.FAuxQty,t2.FAuxPrice,t2.FAuxTaxPrice,
t2.FAmount,t2.FTaxAmount,t2.FSourceBillNo,--t2.*,
t3.FEntryID,t3.FItemID,
t3.FAuxQty,--t3.FAuxPrice,--FAuxPlanPrice,
--t3.FAmount,
t3.FEntrySelfA0154,--��˰����
t3.FEntrySelfA0152,--��˰�ϼ�
t3.FOrderBillNo,--t4.FItemID,
t4.FAuxQty,
t4.FAuxTaxPrice,
t4.FAllAmount,--��˰�ϼ�
t4.FStockQty,--�������
t4.FEntrySelfP0254 --����˰
 
from  ICPurchase t1
left join ICPurchaseEntry t2 on t1.FInterID=t2.FInterID
left join ICStockBillEntry t3 on t2.FSourceInterID=t3.FInterID
							and t2.FSourceEntryID=t3.FEntryID
left join POOrderEntry t4 on t3.FOrderInterID=t4.FInterID
							and t3.FOrderEntryID=t4.FEntryID

left join t_Supplier t5 on t1.FSupplyID=t5.FItemID
left join t_Item t6 on t2.FItemID=t6.FItemID


--select * from POOrderEntry

--select * from  t_Item