
--select * from master..t_kdaccount_gl


select * from icclasstype where fname_chs like '%工序流转%'
1002520	工序流转卡汇报	工序流轉卡彙報	Process Flow Card Report	0	SHProcRptMain


select * from sysobjects where xtype='u' and name like '%SHProcRptMain%'

select * from sysobjects where xtype='u' and name like '%icclasscheck%'
ICClassCheckRecords1005003
ICClassCheckStatus1107011

select * from ICClassCheckStatus1002520 
select top 100 * from ICClassCheckRecords1002520  

-----		生成审核记录    ----
select 1 as FPage,t1.finterid FBillID,0 FBillEntryID,t1.fbillno FBillNo,0 FBillEntryIndex,
	-99 FCheckLevel,-1 FCheckLevelTo,0 FMode,16394 FCheckMan,' ' FCheckIdea,getdate() FCheckDate,'审核'  FDescriptions
Into Lyz
from SHProcRptMain t1
where fdate<'2009-11-01' and fdate>='2009-08-01' 
	and isnull(t1.fcheckerid,0)=0
order by fdate

insert into lyz
select 1 as FPage,t1.finterid FBillID,0 FBillEntryID,t1.fbillno FBillNo,0 FBillEntryIndex,
	-1 FCheckLevel,1 FCheckLevelTo,0 FMode,16394 FCheckMan,' ' FCheckIdea,getdate() FCheckDate,'审核'  FDescriptions
from SHProcRptMain t1
where fdate<'2009-11-01' and fdate>='2009-08-01' 
	and isnull(t1.fcheckerid,0)=0
order by fdate
-----		插入审核记录    ----
INSERT INTO AIS20100318142540.dbo.ICClassCheckRecords1002520
           (FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex
           ,FCheckLevel,FCheckLevelTo,FMode,FCheckMan,FCheckIdea
           ,FCheckDate,FDescriptions)
select * 
from lyz order by FBillID,FCheckLevel

------------ 插入审核状态    ----------

--select * from ICClassCheckStatus1002520
INSERT INTO AIS20100318142540.dbo.ICClassCheckStatus1002520
           (FPage,FBillID,FBillEntryID,FBillNo
           ,FBillEntryIndex
           ,FCurrentLevel
           ,FCheckMan1
           ,FCheckIdea1
           ,FCheckDate1
           ,FCheckMan2
           ,FCheckIdea2
           ,FCheckDate2
           ,FCheckMan3
           ,FCheckIdea3
           ,FCheckDate3
           ,FCheckMan4
           ,FCheckIdea4
           ,FCheckDate4
           ,FCheckMan5
           ,FCheckIdea5
           ,FCheckDate5
           ,FCheckMan6
           ,FCheckIdea6
           ,FCheckDate6
           ,FCheckMan7
           ,FCheckIdea7
           ,FCheckDate7
           ,FCheckMan8
           ,FCheckIdea8
           ,FCheckDate8
           ,FCheckMan9
           ,FCheckIdea9
           ,FCheckDate9
           ,FCheckMan10
           ,FCheckIdea10
           ,FCheckDate10
           ,FCheckMan11
           ,FCheckIdea11
           ,FCheckDate11
           ,FCheckMan12
           ,FCheckIdea12
           ,FCheckDate12
           ,FCheckMan13
           ,FCheckIdea13
           ,FCheckDate13
           ,FCheckMan14
           ,FCheckIdea14
           ,FCheckDate14
           ,FCheckMan15
           ,FCheckIdea15
           ,FCheckDate15)
select 1,t1.finterid,0,t1.fbillno,0,1,16394,'',getdate(),null,0,'',null,0,'',null,0,'',null,0,'',
	null,0,'',null,0,'',null,0,'',null,0,'',null,0,'',null,0,'',null,0,'',null,0,'',null,0,'',null,0,''
from SHProcRptMain t1
where fdate<'2009-11-01' and fdate>='2009-08-01' 
	and isnull(t1.fcheckerid,0)=0
order by fdate


select fcheckerid,* from SHProcRptMain
