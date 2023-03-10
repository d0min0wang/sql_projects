
--select * from master..t_kdaccount_gl

-- 
-- select * from icclasstype where fname_chs like '%������ת%'
-- 1002520	������ת���㱨	�������D������	Process Flow Card Report	0	SHProcRptMain
-- 
--select * from icclasstableinfo where fclasstypeid=1002520 and ffieldname like '%date%'
-- select * from sysobjects where xtype='u' and name like '%SHProcRptMain%'
-- 
-- select * from sysobjects where xtype='u' and name like '%icclasscheck%'
-- ICClassCheckRecords1005003
-- ICClassCheckStatus1107011
-- 
-- select * from ICClassCheckStatus1002520 
-- select top 100 * from ICClassCheckRecords1002520  

----
--select distinct t1.FInterID,t2.FICMOInterID,t2.FICMOBillNo,t3.FBillNo,t3.FStatus
--from SHProcRptMain t1
--inner join SHProcRpt t2 ON t1.Finterid=t2.finterid
--left join ICMO t3 ON t2.FICMOInterID=t3.FInterID
--where t2.FStartWorkDate<'2013-10-31' and t2.FStartWorkDate>='2002-01-01' 
--	and (isnull(t1.fcheckerid,0)=0 or isnull(t1.fcheckstatus,0)=1059)
--	and t3.fstatus=3
--�᰸ 3


DECLARE @BeginDate datetime
DECLARE @DateEnd datetime
SET @BeginDate='2000-01-31'
SET @DateEnd='2023-12-31'

--ɾ����ʱ��
if exists (select * from sysobjects where name ='Lyz' and xtype='u')
begin
	drop table Lyz
end
if exists (select * from sysobjects where name ='Lyz1' and xtype='u')
begin
	drop table Lyz1
end
------�����з��ϼ�¼�ĵ������������ʱ��1
select distinct t1.FInterID,t2.FICMOInterID,t2.FICMOBillNo,t3.FBillNo,t3.FStatus
into Lyz1
from SHProcRptMain t1
inner join SHProcRpt t2 ON t1.Finterid=t2.finterid
left join ICMO t3 ON t2.FICMOInterID=t3.FInterID
where --t2.FStartWorkDate<@DateEnd and t2.FStartWorkDate>=@BeginDate 
	 (isnull(t1.fcheckerid,0)=0 or isnull(t1.fcheckstatus,0)=1059)
	and 
	t3.fstatus=3
	and 
	t2.FFlowCardNo IN(
'202212080641002',
'202212070841011',
'202210070621020',
'202210070621021',
'202210261741007',
'202211081271003',
'202211240571001',
'202211210731004',
'202211281301003',
'202211250541031',
'202212012031040')

-----		������˼�¼    ----
select 1 as FPage,t1.finterid FBillID,0 FBillEntryID,t1.fbillno FBillNo,0 FBillEntryIndex,
	-99 FCheckLevel,-1 FCheckLevelTo,0 FMode,16394 FCheckMan,' ' FCheckIdea,getdate() FCheckDate,'���'  FDescriptions
Into Lyz
from SHProcRptMain t1
where finterid in (select distinct finterid from lyz1)
order by t1.finterid

insert into lyz
select distinct 1 as FPage,t1.finterid FBillID,0 FBillEntryID,t1.fbillno FBillNo,0 FBillEntryIndex,
	-1 FCheckLevel,1 FCheckLevelTo,0 FMode,16394 FCheckMan,' ' FCheckIdea,getdate() FCheckDate,'���'  FDescriptions
from SHProcRptMain t1
where finterid in (select distinct finterid from lyz1)
order by t1.finterid


-----		����˼�¼ ������˼�¼����    ----
INSERT INTO ICClassCheckRecords1002520
           (FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex
           ,FCheckLevel,FCheckLevelTo,FMode,FCheckMan,FCheckIdea
           ,FCheckDate,FDescriptions)
select * 
from lyz order by FBillID,FCheckLevel

------------ ���µ��ݵ����״̬    ----------
--��ɾ�������ڵ����е��ݵ����״̬��¼
delete from ICClassCheckStatus1002520 where FBillID in ( select distinct finterid from lyz1) 

--Ȼ������������е��ݵ����״̬��¼�������
--select * from ICClassCheckStatus1002520
INSERT INTO ICClassCheckStatus1002520
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
select 1,t1.finterid,0,t1.fbillno,0,1,16394,'',getdate(),
	0,'',null,0,'',null,0,'',null,0,'',null,0,'',null,0,'',null,0,'',null,0,'',null,
	0,'',null,0,'',null,0,'',null,0,'',null,0,'',null,0,'',null
from SHProcRptMain t1
where t1.finterid in (select distinct finterid from lyz1)
order by t1.finterid

---�����¹���㱨����������ֶ�
update t1 set t1.fcheckerid=16505,t1.FCheckDate=convert(varchar(10),getdate(),121),FCheckStatus=1058,FStatus=1
from SHProcRptMain t1
where finterid in (select distinct finterid from lyz1)

--ɾ����ʱ��
if exists (select * from sysobjects where name ='Lyz' and xtype='u')
begin
	drop table Lyz
end
if exists (select * from sysobjects where name ='Lyz1' and xtype='u')
begin
	drop table Lyz1
end

--select * from shprocrptmain where fcheckerid=16394 and fstatus=0

--update t1 set t1.FCheckStatus=1058,t1.FStatus=1
--from shprocrptmain t1 
--where fcheckerid=16394 and fstatus=0
--select * from ICMO where FBillNO='75962'
--select * from t_user where FUserID=16505