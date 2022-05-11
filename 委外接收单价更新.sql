select * from t_tabledescription where fdescription like '%Ω” ’%'

select * from t_fielddescription where ftableid=1450022

FUnitPrice
FBaseUnitPrice
FAmount=FUnitPrice*FReceiveQty

update t2 set t2.FAmount=t2.FUnitPrice*t2.FReceiveQty
--t2.FUnitPrice=300,t2.FBaseUnitPrice=300

--select t2.FUnitID,* 
from   ICShop_SubcIn t1
left join    ICShop_SubcInEntry   t2 on t1.finterid=t2.finterid
where    fbillno in('WWJS913','WWJS914','WWJS915','WWJS916','WWJS917','WWJS918','WWJS919','WWJS920')                                                                                                                                                                                                                                         
