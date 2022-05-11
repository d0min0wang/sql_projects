
--select * from master..t_kdaccount_gl

-- 
-- select * from icclasstype where fname_chs like '%π§–Ú¡˜◊™%'
-- 1002520	π§–Ú¡˜◊™ø®ª„±®	π§–Ú¡˜ﬁDø®è°àÛ	Process Flow Card Report	0	SHProcRptMain
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
--Ω·∞∏ 3


DECLARE @BeginDate datetime
DECLARE @DateEnd datetime
SET @BeginDate='2000-01-31'
SET @DateEnd='2023-12-31'

--…æ≥˝¡Ÿ ±±Ì
if exists (select * from sysobjects where name ='Lyz' and xtype='u')
begin
	drop table Lyz
end
if exists (select * from sysobjects where name ='Lyz1' and xtype='u')
begin
	drop table Lyz1
end
------∞—À˘”–∑˚∫œº«¬ºµƒµ•æ›ƒ⁄¬Î≤Â»Î¡Ÿ ±±Ì1
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
'202005220141009',
'202005220141008',
'202005220141006',
'202005220141001',
'202005220141002',
'20200520111111490011003',
'20200520111111490011003',
'202006170731004',
'202006230271002',
'202006230271003',
'202006230271004',
'202007310011006',
'202007281001001',
'202007281001005',
'202008111201017',
'202008120601017',
'202008120601018',
'202008111111106',
'202008171061023',
'202008240341017',
'202008240341018',
'202009010471006',
'202009010471007',
'202009010471004',
'202009010471005',
'202008170701001',
'202009010471001',
'20200904088',
'202009070171002',
'202008250061005',
'202009050381032',
'202009040761007',
'202009030021001',
'202009020511003',
'202009080701001',
'202009080701002',
'202009070751006',
'202009090091002',
'202009090091003',
'202009071121005',
'202009080751005',
'202009080691017',
'202008290321001',
'202009080901001',
'202009030531026',
'202009030531027',
'202009030531029',
'202009030531023',
'202009030531024',
'20200910032',
'202009071101015',
'202009080081026',
'202009110091001',
'202009110461002',
'202009100301007',
'202009100301008',
'202009100961041',
'202009120911007',
'202009120791024',
'202009090851075',
'202009120791034',
'202009120811023',
'202009110351001',
'202009110351002',
'202009130211015',
'202009130511024',
'202009130511066',
'202009160991001',
'202009170681001',
'202009170111019',
'202009170041009',
'202009210251005',
'202009210251003',
'202009210031002',
'202009170431030',
'202009170431031',
'202009170151046',
'202009211151006',
'202009180361001',
'202009180361002',
'202009180361003',
'202009221011001',
'202009220941006',
'202009210741003',
'202009230361011',
'202009220971009',
'202009210131009',
'202009220071006',
'202009230051003',
'202009080511060',
'202009100611001',
'202009181081024',
'202009230331021',
'202009240841003',
'202009080511072',
'202009240651005',
'202009250571004',
'202009250981001',
'202009250981002',
'202009250721005',
'202009220141091',
'202009220641012',
'202009270741005',
'202009250101001',
'202009280361004',
'202009290321007',
'202009290561010',
'202009271051009',
'202009210021106',
'202009210021114',
'202009250481020',
'202009290601008',
'202009270771025',
'202009271101009',
'202010050301003',
'202010050081008',
'202010050081009',
'202010060691006',
'202010050081027',
'202009290841017',
'202010050351023',
'202010050351030',
'202010050461040',
'202010050461041',
'202010050461042',
'202010050461043',
'20201006095',
'202010060741001',
'202010060671001',
'202009280971010',
'202010050341015',
'202010060971013',
'202009290011035',
'202009290011036',
'202010070651008',
'202009290731055',
'202010070931008',
'202010070641017',
'202010050351105',
'202010050351106',
'202009290631004',
'202010090891006',
'202009290731091',
'202010070311027',
'202010120011001',
'202010101301005',
'202010061111141',
'202010120461001',
'202009280971100',
'202010100761059',
'202010080281008',
'202010120511002',
'202010120541006',
'202010110131032',
'202010140361008',
'202010120481015',
'202010120501016',
'202010120501017',
'202010120511010',
'202010120531019',
'202009150881030',
'202010140141009',
'202010130551035',
'202010130491020',
'202010120471031',
'202010110151036',
'202009150881044',
'202010150361011',
'202010150361012',
'202010130511032',
'202010120481062',
'202009300081014',
'202010150981004',
'202009150881063',
'202010120491091',
'202010071091001',
'202010170771016',
'202009150881072',
'202010200881004',
'202010170221034',
'202010170791020',
'202010210651010',
'202010210661016',
'202010160681103',
'202010210641033',
'202010221021005',
'202010230941006',
'202010230961004',
'202010231221007',
'202010231221009',
'202010231221010',
'202010220751008',
'20201023123',
'202010250641002',
'202010250641007',
'202010170761047',
'202010260771001',
'202010200851094',
'202010260771002',
'202010242041008',
'202010261211008',
'202010240691009',
'202010260731010',
'202010260631001',
'202010260731012',
'202010241091014',
'202010241091015',
'202010090031052',
'202010220861023',
'202010281071003',
'202010280751008',
'202010250691008',
'202010220731086',
'202010281041010',
'202010280681001',
'202010301141004',
'202010281031012')

-----		…˙≥……Û∫Àº«¬º    ----
select 1 as FPage,t1.finterid FBillID,0 FBillEntryID,t1.fbillno FBillNo,0 FBillEntryIndex,
	-99 FCheckLevel,-1 FCheckLevelTo,0 FMode,16394 FCheckMan,' ' FCheckIdea,getdate() FCheckDate,'…Û∫À'  FDescriptions
Into Lyz
from SHProcRptMain t1
where finterid in (select distinct finterid from lyz1)
order by t1.finterid

insert into lyz
select distinct 1 as FPage,t1.finterid FBillID,0 FBillEntryID,t1.fbillno FBillNo,0 FBillEntryIndex,
	-1 FCheckLevel,1 FCheckLevelTo,0 FMode,16394 FCheckMan,' ' FCheckIdea,getdate() FCheckDate,'…Û∫À'  FDescriptions
from SHProcRptMain t1
where finterid in (select distinct finterid from lyz1)
order by t1.finterid


-----		∞—…Û∫Àº«¬º ≤Â»Î…Û∫Àº«¬º±Ì÷–    ----
INSERT INTO ICClassCheckRecords1002520
           (FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex
           ,FCheckLevel,FCheckLevelTo,FMode,FCheckMan,FCheckIdea
           ,FCheckDate,FDescriptions)
select * 
from lyz order by FBillID,FCheckLevel

------------ ∏¸–¬µ•æ›µƒ…Û∫À◊¥Ã¨    ----------
--œ»…æ≥˝Ãıº˛ƒ⁄µƒÀ˘”–µ•æ›µƒ…Û∫À◊¥Ã¨º«¬º
delete from ICClassCheckStatus1002520 where FBillID in ( select distinct finterid from lyz1) 

--»ª∫Û∞—Ãıº˛ƒ⁄À˘”–µ•æ›µƒ…Û∫À◊¥Ã¨º«¬º≤Â»Î±Ì÷–
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

---◊Ó∫Û∏¸–¬π§–Úª„±®µ•µƒ…Û∫À»À◊÷∂Œ
update t1 set t1.fcheckerid=16505,t1.FCheckDate=convert(varchar(10),getdate(),121),FCheckStatus=1058,FStatus=1
from SHProcRptMain t1
where finterid in (select distinct finterid from lyz1)

--…æ≥˝¡Ÿ ±±Ì
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