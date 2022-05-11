--select @finterid=finterid,@fdeptid=fdeptid from icstockbill where ftrantype=24 and fcancellation=0 and fstatus=0
--and fdeptid =(select fitemid from t_Department where fname='配料班')
--
--update icstockbillentry set  fcostcenterid =(select fitemid from t_BASE_CostCenter where fdeptid=@fdeptid and fcctype=14153)
--where finterid=@finterid and ficmointerid <>0 and foperid=0
--
select t1.finterid,t1.fdeptid,t2.fcostcenterid,t1.*,t2.* from icstockbill t1  
left join icstockbillentry t2 on t1.finterid=t2.finterid
where t1.ftrantype=24  
--and t1.FBillNo='SOUT018320'
and t2.fcostcenterid=0
----fdeptid=86 自动车间 fcostcenterid=18504
----fdeptid=87 手工 fcostcenterid=18504
----fdeptid=13489 麻面 fcostcenterid=18504
----fdeptid=14566 生产部 fcostcenterid=18504
----fdeptid=83 生产本部 fcostcenterid=18504
----fdeptid=18495 成型 fcostcenterid=18504
----fdeptid=88 后加工
----fdeptid=87 手工车间
--select fitemid,* from t_BASE_CostCenter where fcctype=14153

--配料
update t2 set t2.fcostcenterid =(select fitemid from t_BASE_CostCenter where fdeptid=85 and fcctype=14153)
from icstockbill t1  
left join icstockbillentry t2 on t1.finterid=t2.finterid
where t1.ftrantype=24 and fdeptid=85 and t2.fcostcenterid=0
--and t1.FBillNo='SOUT018320'
--and t1.fdate>='2010-01-01'

--全部
select t2.fcostcenterid,t2.foperid,t2.FOperSN,t2.FSCStockID
--update t2 set t2.fcostcenterid =18504,t2.foperid=40026,t2.FOperSN=10
from icstockbill t1  
left join icstockbillentry t2 on t1.finterid=t2.finterid
where t1.ftrantype=24 and fdeptid IN (86,87,18495,13489,14566,83) and t2.fcostcenterid=0
and t2.FSCStockID=12662
order by t2.FSCStockID
--and t1.fdate>='2010-01-01'

--成型
update t2 set t2.fcostcenterid =18504
--select * 
from icstockbill t1  
left join icstockbillentry t2 on t1.finterid=t2.finterid
where t1.ftrantype=24 and fdeptid=18495 and t2.fcostcenterid=0
and t2.FSCStockID=12662
--and t1.fdate>='2010-01-01'

--手工
update t2 set t2.fcostcenterid =18504
--select * 
from icstockbill t1  
left join icstockbillentry t2 on t1.finterid=t2.finterid
where t1.ftrantype=24 and fdeptid=87 and t2.fcostcenterid=0
and t2.FSCStockID=12662
--and t1.fdate>='2010-01-01'

--麻面
update t2 set t2.fcostcenterid =18504
--select * 
from icstockbill t1  
left join icstockbillentry t2 on t1.finterid=t2.finterid
where t1.ftrantype=24 and fdeptid=13489 and t2.fcostcenterid=0
and t2.FSCStockID=12662
--and t1.fdate>='2010-01-01'

--生产部
update t2 set t2.fcostcenterid =18504
from icstockbill t1  
left join icstockbillentry t2 on t1.finterid=t2.finterid
where t1.ftrantype=24 and fdeptid=14566 and t2.fcostcenterid=0
and t2.FSCStockID=12662
--and t1.fdate>='2010-01-01'

--生产本部
update t2 set t2.fcostcenterid =18504
from icstockbill t1  
left join icstockbillentry t2 on t1.finterid=t2.finterid
where t1.ftrantype=24 and fdeptid=83 and t2.fcostcenterid=0
and t2.FSCStockID=12662
--and t1.fdate>='2010-01-01'

--修改辅助材料领料部门
select distinct fbillno,t2.fcostcenterid,t2.foperid,t2.FOperSN,t1.fdeptid,t2.FSCStockID,t1.FDate
--update t1 set t1.fdeptid=0
from icstockbill t1  
left join icstockbillentry t2 on t1.finterid=t2.finterid
INNER JOIN t_Stock t3 ON  t2.FSCStockID = t3.FItemID   AND t3.FItemID <>0
LEFT OUTER JOIN t_Department t4 ON t1.FDeptID = t4.FItemID   AND t4.FItemID <>0 
--where t4.fName in('成型','后加工车间','自动车间','麻面车间','手工车间','生产本部','生产部') and t3.FName = '辅助材料仓' and t1.FTranType=24
--and t1.FDate>='2013-01-01' and t1.FDate<='2013-03-31'
where fbillno in ('SOUT033808') and t3.FName = '辅助材料仓'
--'SOUT025441','SOUT025482','SOUT026040'原为生产部
--'SOUT025434','SOUT025481','SOUT025581','SOUT025642','SOUT025662'原为后加工
--FSCStockID=10345 辅助材料仓

select * from t_Stock where fitemid=12662

--2012-10-12 'SOUT026602','SOUT026829','SOUT027393','SOUT027855' fdptid=18495
--2012-10-12 'SOUT026600,','SOUT026677','SOUT026818','SOUT027134' fdptid=88
--2012-10-12 'SOUT027109','SOUT027133',fdeptid=14566
--2012-10-12 'SOUT027388' fdeptid=87
fbillno	fcostcenterid	fdeptid
SOUT028856	0	88
SOUT028859	0	88
SOUT028898	0	88

--select t2.fcostcenterid
----update t2 set t2.fcostcenterid =0
--from icstockbill t1  
--left join icstockbillentry t2 on t1.finterid=t2.finterid
--LEFT JOIN t_Department t3 ON     t1.FDeptID = t3.FItemID   AND t3.FItemID <>0
--INNER JOIN t_Stock t4 ON     t2.FSCStockID = t4.FItemID   AND t4.FItemID <>0 
--where t1.ftrantype=24 and t2.fcostcenterid>0
--and t3.FName IN ('成型','自动车间','麻面车间','手工车间','生产本部','生产部')
--	and t4.FName<>'糊料仓'
--
--select * from t_Department

