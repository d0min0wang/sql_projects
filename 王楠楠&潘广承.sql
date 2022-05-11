--select t2.fname,t3.fname,t1.fdate,t1.fbillno,t4.FConsignAmount from icstockbill t1
--left join t_Emp t2 on t1.fempid=t2.fitemid
--left join t_organization t3 on t1.fsupplyid=t3.fitemid
--left join icstockbillentry t4 on t1.finterid=t4.finterid
-- where ftrantype=21 and t1.fdate>'2010-01-01' and t1.fdate<'2010-03-31' and t3.fname in 
-- (select t3.fname from icstockbill t1
--left join t_Emp t2 on t1.fempid=t2.fitemid
--left join t_organization t3 on t1.fsupplyid=t3.fitemid
-- where ftrantype=21 and t2.fname='ÅË¹ã³Ğ' and t1.fdate >'2010-04-01'
-- group by t3.fname)
 
 select distinct t3.fname from icstockbill t1
left join t_Emp t2 on t1.fempid=t2.fitemid
left join t_organization t3 on t1.fsupplyid=t3.fitemid
 where ftrantype=21 and t2.fname='Íõéªéª' and t1.fdate >'2010-04-01'
 
--select * from t_tabledescription where ftablename='icstockbill'

------210008

--select * from t_fielddescription where ftableid=210008


select t2.fname,t3.fname,t1.fdate,t1.fbillno,t4.FConsignAmount from icstockbill t1
left join t_Emp t2 on t1.fempid=t2.fitemid
left join t_organization t3 on t1.fsupplyid=t3.fitemid
left join icstockbillentry t4 on t1.finterid=t4.finterid
 where ftrantype=21 and t1.fdate>'2010-01-01' and t1.fdate<'2010-03-31' and t1.fsupplyid in 
 (select distinct t1.fsupplyid from icstockbill t1
left join t_Emp t2 on t1.fempid=t2.fitemid
--left join t_organization t3 on t1.fsupplyid=t3.fitemid
 where ftrantype=21 and t2.fname='ÅË¹ã³Ğ' and t1.fdate >'2010-04-01'
)
 
 