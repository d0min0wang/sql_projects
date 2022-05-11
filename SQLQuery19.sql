  SELECT top 1000 v2.FSourceBillNo,v2.FSourceEntryID,v2.FSourceInterId,v2.FSourceTranType,* FROM ICStockBill v1
  left join icstockbillentry v2
  on v1.finterid=v2.finterid
  where v1.ftrantype=21
  select * from t_tabledescription where fdescription like '%³öÈë%'
  --210008
  --210009
  
   select * from t_fielddescription where ftableid=210009
   
   select top 100 * from seorder 