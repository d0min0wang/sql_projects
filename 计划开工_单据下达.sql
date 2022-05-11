--USE [AIS20110907091814]
--select top 100 * from ICMO
--select * from t_Tabledescription where Fdescription like '%生产任务%'
select * from t_fielddescription where ftableid=470000 and fdescription like '%完工%'

update icmo set FPlanCommitDate=FCommitDate 
select FPlanCommitDate,FCommitDate from icmo
where (year(FPlanCommitDate)<>year(FCommitDate) 
or month(FPlanCommitDate)<>month(FCommitDate))
--and (FPlanCommitDate>='2011-08-30' or FCommitDate>='2011-08-30')
and (FStatus=1 OR FStatus=2 or FStatus=3)


update icmo set FPlanFinishDate=FPlanCommitDate+3
where FPlanCommitDate>FPlanFinishDate
--and (FPlanCommitDate>='2011-08-30' or FCommitDate>='2011-08-30')
and (FStatus=1 OR FStatus=2 or FStatus=3)

--修改计划开工日期FPlanCommitDate\下达日期FCommitDate 
update icmo set FCloseDate='2017-04-30'
--update icmo set FCommitDate='2017-04-08',FPlanCommitDate='2017-04-08',FPlanFinishDate='2017-04-08'
--update icmo set FCommitDate='2014-11-01'
--update icmo set FCommitDate=FCloseDate,FPlanCommitDate=FCloseDate,FPlanFinishDate=FCloseDate
--select FCommitDate,FPlanFinishDate,FPlanCommitDate,FCloseDate,* from icmo
where --(year(FPlanCommitDate)<>year(FCommitDate) 
--or month(FPlanCommitDate)<>month(FCommitDate))
--and (FPlanCommitDate>='2011-08-30' or FCommitDate>='2011-08-30')
--and (FStatus=1 OR FStatus=2 or FStatus=3)
 fbillNo IN (
'165135')
and FCloseDate is null 
select getdate()+3

------------------------------------------
update icmo set FPlanFinishDate='2012-10-30'--,FPlanCommitDate='2012-08-14'
--select FCommitDate,FPlanFinishDate,FPlanCommitDate,FCloseDate,* 
from icmo where fbillNo IN ('78535'
)

--计划开工和结案日期不在同一个月
select fbillno,FCommitDate,FPlanFinishDate,FPlanCommitDate,FCloseDate
from icmo
where CONVERT(char(7),FPlanCommitDate,112)<>CONVERT(char(7),FCloseDate,112)

--修改结案日期
--原因1、[63421生产任务单存在本期结案但没有产品入库，产品成本将归集在在产品中
update icmo set FCloseDate='2013-08-29'
--select FBillNo,FCommitDate,FPlanFinishDate,FPlanCommitDate,FCloseDate
from icmo where fbillNo IN 
('092416')
--and FClosedate is not null
order by fclosedate
--原因2、单据[64721]生产任务单存在以前期间下达且未结案但期初在产品的数量和金额均为零”
update icmo set FCloseDate='2011-11-30'
--select FCommitDate,FPlanFinishDate,FPlanCommitDate,FCloseDate,* 
from icmo where fbillNo IN ('64721','64811','64820','64871','64878',
'64997','65131','65204','65369','65396','65515')
-----------------------------------------------------------------------
update icmo set FPlanCommitDate=FPlanFinishDate-3
where fbillNo IN ('66162')

--修改结案日期
update icmo set FCloseDate='2016-10-12'
--update icmo set FPlanCommitDate='2016-10-01',FPlanFinishDate='2016-10-01',FCommitDate='2016-10-01'
--update icmo set FPlanFinishDate=FCloseDate,FPlanCommitDate=FCloseDate
--select FCommitDate,FPlanFinishDate,FPlanCommitDate,FCloseDate,*  from icmo
where fbillNo IN ('161452')

update icmo set FPlanFinishDate='2013-03-31'
where fbillNo IN ('85306')

update icmo set FCloseDate='2013-03-30'
--select FCommitDate,FPlanFinishDate,FPlanCommitDate,FCloseDate,*  from icmo
where fbillNo IN ('133332',
'133544')

---任务单[64814]成本中心[成型]期末转出未入库数或期末未转出数量不为零
--update OPCostWIPCheck set fnotstockqty=0
--select fnotstockqty from OPCostWIPCheck
where fyearperiod='2017.07'
and fnotstockqty<>0
and ficmointerid in(
select finterid from icmo where fbillno in(
'167227',
'165437',
'167285'))
--0.36


select fnotstockqty from OPCostWIPCheck
where fyearperiod='2013.05'
--and fnotstockqty<>0
and ficmointerid in(
select finterid from icmo where fbillno in('84889'
))

--根据生产任务单修改领料单
--update t1 set t1.FDate='2017-08-03'
--update t1 set t1.FDate=t3.FCloseDate
--update t3 set t3.FCloseDate='2017-06-30'
--update t3 set t3.FCommitDate=t1.FDate,t3.FPlanCommitDate=t1.FDate,t3.FPlanFinishDate=t1.FDate
--update t3 set t3.FCommitDate=t3.FCloseDate,t3.FPlanCommitDate=t3.FCloseDate,t3.FPlanFinishDate=t3.FCloseDate
--update t3 set t3.FCommitDate='2016-02-08',t3.FPlanCommitDate='2016-02-08',t3.FPlanFinishDate='2016-02-08'
--update t3 set t3.FCloseDate=NULL
--update t3 set t3.FCloseDate=t1.FDate
--select t1.FDate,t1.FBillNo,t3.FBillNo,t3.FCommitDate,t3.FPlanFinishDate,t3.FPlanCommitDate,t3.FCloseDate,t3.FStatus 
from icstockbill t1
inner join icstockbillentry t2 on t1.Finterid=t2.finterid
left join icmo t3 on t2.FSourceInterId=t3.FInterID
where t2.FSourceBillNo in (
'166860')
------and t3.FCloseDate <'2017-06-01 00:00:00.000'
------and t1.FDate>='2017-06-01 00:00:00.000'
----and t3.FCloseDate is not null


where 
t1.FBillNo IN (
'SOUT099558',
'SOUT107819',
'SOUT107820',
'SOUT107828',
'SOUT107829',
'SOUT107848',
'SOUT107848',
'SOUT107848',
'SOUT107848',
'SOUT107848',
'SOUT107848',
'SOUT107849',
'SOUT107849',
'SOUT107849',
'SOUT107849',
'SOUT107849',
'SOUT107849',
'SOUT107850',
'SOUT107850',
'SOUT107850',
'SOUT107850',
'SOUT107850',
'SOUT107850',
'SOUT107851',
'SOUT107851',
'SOUT107851',
'SOUT107851',
'SOUT107851',
'SOUT107851',
'SOUT107851')
and t3.FCloseDate is  null
and t3.FBillNo is null

select u1.fprice,* 
--update u1 set fprice=6.74
From ICStockBill v1 inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
where FBillNo='CIN426275'

--入库单
--2014-09-17
update t1 set t1.FDate='2017-03-28'
--select t1.FDate,* 
from icstockbill t1
inner join icstockbillentry t2 on t1.Finterid=t2.finterid
where t1.FBillNo IN('CIN1147565')

select t3.FBillNo,max(t3.FCommitDate),max(t3.FPlanFinishDate),max(t3.FPlanCommitDate),max(t3.FCloseDate),max(t1.FDate) from icstockbill t1
inner join icstockbillentry t2 on t1.Finterid=t2.finterid
left join icmo t3 on t2.FICMOInterId=t3.FInterID
where  --t1.FBillNo like '%CIN518969%'
 t2.FICMOBillNo in (
'162307',
'162322') 
group by t3.FBillNo

--update t1 set t1.FDate='2013-09-30'
--update t3 set t3.FCommitDate='2013-09-30',t3.FPlanCommitDate='2013-09-30',t3.FPlanFinishDate='2013-09-30'
--update t3 set t3.FCloseDate='2013-10-30'
--select t1.FDate,t3.FBillNo,t3.FCommitDate,t3.FPlanFinishDate,t3.FPlanCommitDate,t3.FCloseDate,t5.FDate 
from icstockbill t1
inner join icstockbillentry t2 on t1.Finterid=t2.finterid
left join icmo t3 on t2.FSourceInterId=t3.FInterID
left join  icstockbillentry t4 on t2.FSourceInterId=t4.FICMOInterId
inner join icstockbill t5 on t4.Finterid=t5.finterid
 where t2.FSourceBillNo in
 (
'165605',
'165870',
'165926',
'165932',
'165955',
'166113',
'166114',
'166296',
'166407',
'166435',
'166493',
'166501',
'166532',
'166535',
'166708',
'166773',
'166815',
'166863',
'166891',
'166896',
'167014',
'167079',
'167080',
'167083',
'167088',
'167089',
'167093',
'167144',
'167194',
'167195',
'167196',
'167197',
'167198',
'167199',
'167200',
'167201',
'167210',
'167216',
'167217',
'167302',
'167351',
'167390',
'167392',
'167525',
'167531',
'167574')
and t3.FCloseDate>='2013-11-01'

select * from t_tabledescription where fdescription like '%废品%'

--update OPCostScrap set FDate='2014-07-01'
--select FDate,* from OPCostScrap
where FBillNo='SY00000182'