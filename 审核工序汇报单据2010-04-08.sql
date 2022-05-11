
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
SET @DateEnd='2019-12-31'

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
'201812171381003',
'20190121023',
'201901270201015',
'201901270201016',
'201901280551004',
'20190313001',
'201903110271001',
'201903230771017',
'201903250411034',
'201903250431047',
'201903280761013',
'201903290951014',
'201903290621002',
'201903290911039',
'201903290951038',
'201904030461057',
'201904080731006',
'201904090701021',
'20190319008',
'201904110851001',
'201904140181034',
'201904150551012',
'201904170761012',
'201904160891011',
'201904220521002',
'201904220391036',
'201904220391041',
'201904240821003',
'201904230631014',
'201904241031002',
'201904250441001',
'201904260531024',
'201904250031005',
'201904260691013',
'201904280251002',
'201904260531080',
'20190429068',
'201904220661047',
'201904290451009',
'201904280041037',
'201904280691001',
'201904280041047',
'201904260591023',
'201904280251012',
'201904250541136',
'201905030811041',
'201905040131004',
'20190504062',
'201905060541001',
'201905050301044',
'201905060721007',
'201905040211026',
'201905070901019',
'201905040211053',
'201904290631016',
'201905080571025',
'201905080461038',
'201905080461039',
'201905100821010',
'201905110321001',
'201905110321002',
'201905080481041',
'201905080481042',
'201905090041020',
'201905130081038',
'201905110231005',
'201905110231006',
'201905081031055',
'201905150671030',
'201905110231001',
'201905110231002',
'201905110231003',
'201905110231004',
'201905160641006',
'201905150721034',
'201905160381011',
'201905150581036',
'201904130951097',
'201905180711003',
'201905180461010',
'201905180601003',
'201905180601004',
'201905110231011',
'201904290471072',
'201905180451013',
'201905160621001',
'201905160621002',
'201905230331002',
'201905230011005',
'20190521006',
'201905240781002',
'20190524019',
'201905240651016',
'201905240561009',
'201905210791070',
'201905270461015',
'201905250481013',
'201905280021001',
'201905220011114',
'201905270711008',
'201905280451011',
'201905280451012',
'201905280451015',
'201905280451016',
'201905290141001',
'201905270241027',
'201904300411050',
'201905290271007',
'201905250731013',
'201905291081013',
'201906010681008',
'201906010311001',
'201906010491010',
'201906030381005',
'201906010551024',
'201906040581014',
'201905240561094',
'201906020391008',
'201906010841033',
'201906030081014',
'201906020431024',
'201906050541014',
'201906050701003',
'201906051021017',
'201906051031013',
'201906090281001',
'201906090281003',
'201906051031046',
'201906100061007',
'201905310111083',
'201906100061019',
'201906030371021',
'201906030371022',
'201906030371024',
'201906040561024',
'201906030371025',
'201906090151067',
'201906110131023',
'201906100291037',
'20190612080',
'201906050551013',
'201906110521011',
'201906120811004',
'201906120381010',
'201906120381011',
'201906130441005',
'201906050551017',
'201905160551026',
'201906130471007',
'201906020411058',
'201906010801070',
'201906010801072',
'201906120821014',
'201906140091025',
'201906140551002',
'201906170101006',
'201906170561005',
'201906170561032',
'201906050061005',
'201906180321010',
'201906190611003',
'201906200231001',
'201906200231002',
'201906200231009',
'201906200231010',
'201906200801014',
'201906050061006',
'201906100041001',
'201906200621003',
'201906190151006',
'201906170481007',
'201906210461020',
'201906210521021',
'201906240761001',
'201906240611001',
'201906250461007',
'201906140361046',
'201906240811001',
'201906250231001',
'201906250231002',
'201906030521001',
'201906260151001',
'201906260151002',
'201906260451008',
'201906260151003')

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