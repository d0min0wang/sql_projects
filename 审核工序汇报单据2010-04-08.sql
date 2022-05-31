
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
SET @DateEnd='2022-12-31'

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
'202204131381021',
'202204160641003',
'202204110571105',
'20220311153',
'202203120891002',
'202203120881001',
'202203171451001',
'202203171451002',
'202203171451003',
'202204251181001',
'202203220591022',
'202202121471008',
'202202171161009',
'202204210611007',
'202202170891001',
'202202170891002',
'202204130651031',
'202204140951018',
'202202151081015',
'202202171021006',
'202202180701020',
'202203021541002',
'202203040571004',
'202203091551005',
'202203140581008',
'202203150831016',
'202204030631028',
'202203031261001',
'202203031261002',
'202203091131005',
'20220226103',
'202204111381004',
'202204201671001',
'202203151451001',
'202204191411001',
'202201141291006',
'202204071489001',
'202204110571109',
'202203070611009',
'202202190561032',
'202202210951020',
'202203010851009',
'202203010851010',
'202203020961050',
'202203051391011',
'202203080801001',
'202204120571045',
'202203031141010',
'202203110651011',
'202204150651006',
'202203081591010',
'202202280651011',
'202203051311015',
'202203070611001',
'202203070611002',
'202203090811002',
'202203171351006',
'202203221291061',
'202203301421011',
'202204110571114',
'202204160791009',
'202204160891008',
'202204181601004',
'202202120741006',
'202203300531010',
'202203311951052',
'202204180561003',
'202203100751011',
'202204011041024',
'202204070641029',
'202204120761019',
'202203051411005',
'202203030661056',
'202203110561099',
'202203311951003',
'202203311951158',
'202203210581008',
'202204030771004',
'202204060601031',
'202204120651021',
'202204190981042',
'202204221291030',
'202202181511001',
'202203051391013',
'202203051391016',
'202203051391017',
'202203051391018',
'202203080891001',
'202203080891002',
'202203080891003',
'202203160991006',
'202204181091006',
'202202111251002',
'202204120971009',
'202204160711015',
'202203180851018',
'202201071741013',
'202203191711007',
'202203191811001',
'202204090771010',
'202203110561124',
'202203190691156',
'202203311951008',
'202203311951073',
'202203311951085',
'202203311951220',
'202204030571008',
'202202171061001',
'202203170611025',
'202204190671006',
'20220115064',
'20220115065',
'202202231601009',
'202204080871001',
'202204090581029',
'202203071051015',
'202203071051016',
'202204281251005',
'202202261671003',
'202203280821001',
'202203311251016',
'202204021161003',
'202204120651010',
'202204140721045',
'202204181141007',
'202204281301005',
'202203150781007',
'202203281401002',
'202203070611010',
'202203241531014',
'202204080651023',
'20220303059',
'202203261141008',
'202204191261001',
'202204120541004',
'202204120951083',
'202203191971021',
'202203241761089')

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