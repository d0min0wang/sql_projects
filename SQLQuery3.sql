select t1.FSupplyID,
	t2.* from ICStockBill t1
left join ICStockBillEntry t2 on t1.FInterID=t2.FInterID
where t1.FTrantype=1

select * from t_Supplier


select * from t_TableDescription where FDescription like '%����%'
select * from t_FieldDescription where FTableID=210009
select * from t_Settle --���㷽ʽ

select * from ICPurchaseEntry --��Ʊ