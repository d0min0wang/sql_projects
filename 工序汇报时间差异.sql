--select * from t_tabledescription where fdescription like '%出入%'
--
--select * from t_fielddescription where ftableid=210009
--工序流转卡序时簿
update ICShop_FlowCardEntry set ICShop_FlowCardEntry.FActFinishDate=t.FActFDB
from(select 
		a.FID,
		a.FIndex,
		a.FOperSN,
		a.FFlowCardNo,
		a.FActStartDate,	
		a.FActFinishDate as FActFDA,
		b.findex as FIndexB,
		b.FActFinishDate as FActFDB,
		DATEDIFF(day,a.FActFinishDate,b.FActFinishDate) AS FDif 
	from ICShop_FlowCardEntry  as a
	left join ICShop_FlowCardEntry as b 
	on a.FID=b.FID and a.findex+1=b.findex
	where CONVERT(VARCHAR(7),a.FActFinishDate,120)>'2011-09' and CONVERT(VARCHAR(7),b.FActFinishDate,120)<='2011-09'
--	where DATEDIFF(day,a.FActFinishDate,b.FActFinishDate)<0
	)t
where ICShop_FlowCardEntry.fid=t.fid and ICShop_FlowCardEntry.findex=t.findex


select 
		a.FID,
		a.FIndex,
		a.FOperSN,
		a.FFlowCardNo,
		a.FActStartDate,	
		a.FActFinishDate as FActFDA,
		b.findex as FIndexB,
		b.FActFinishDate as FActFDB,
		DATEDIFF(day,a.FActFinishDate,b.FActFinishDate) AS FDif 
	from ICShop_FlowCardEntry  as a
	left join ICShop_FlowCardEntry as b 
	on a.FID=b.FID and a.findex+1=b.findex
	where CONVERT(VARCHAR(7),a.FActFinishDate,120)>'2011-10' and CONVERT(VARCHAR(7),b.FActFinishDate,120)<='2011-10'
--	where DATEDIFF(day,a.FActFinishDate,b.FActFinishDate)<0

--select FID,
--	FIndex,
--	FOperSN,
--	FFlowCardNo,
--	FActStartDate,	
--	FActFinishDate
--from ICShop_FlowCardEntry
--where FActStartDate>FActFinishDate
--
--update ICShop_FlowCardEntry set FActStartDate=FActFinishDate
--where FActStartDate>FActFinishDate

--工序流转卡汇报

select top 10000
		a.FInterID,
		a.FEntryID,
		a.FOperSN,
		a.FFlowCardNo,
		a.FStartWorkDate,	
		a.FEndWorkDate as FActFDA,
		b.FEntryID as FIndexB,
		b.FEndWorkDate as FActFDB,
		DATEDIFF(day,a.FEndWorkDate,b.FEndWorkDate) AS FDif 
--	into #temp_compare
	from SHProcRpt  as a
	left join SHProcRpt as b 
	on a.FInterID=b.FInterID and a.FEntryID+1=b.FEntryID
	where CONVERT(VARCHAR(7),a.FEndWorkDate,120)>'2011-09' and CONVERT(VARCHAR(7),b.FEndWorkDate,120)<='2011-09'
--	where DATEDIFF(day,a.FEndWorkDate,b.FEndWorkDate)<0 and b.FEndWorkDate IS NOT NULL--and a.fflowcardno='201012060191021'
--	where a.fflowcardno='201012060191021'
order by a.finterID

update SHProcRpt set SHProcRpt.FEndWorkDate=t.FActFDB from 
(select top 10000
		a.FInterID,
		a.FEntryID,
		a.FOperSN,
		a.FFlowCardNo,
		a.FStartWorkDate,	
		a.FEndWorkDate as FActFDA,
		b.FEntryID as FIndexB,
		b.FEndWorkDate as FActFDB,
		DATEDIFF(day,a.FEndWorkDate,b.FEndWorkDate) AS FDif 
--	into #temp_compare
	from SHProcRpt  as a
	left join SHProcRpt as b 
	on a.FInterID=b.FInterID and a.FEntryID+1=b.FEntryID
	where CONVERT(VARCHAR(7),a.FEndWorkDate,120)>'2011-09' and CONVERT(VARCHAR(7),b.FEndWorkDate,120)<='2011-09'
--	where DATEDIFF(day,a.FEndWorkDate,b.FEndWorkDate)<0 and b.FEndWorkDate IS NOT NULL--and a.fflowcardno='201103070091003'
order by a.finterID)t
where SHProcRpt.Finterid=t.finterid and SHProcRpt.fentryid=t.fentryid

----包装差异(汇报)
update SHProcRpt set SHProcRpt.fendworkdate=t.fdate from
(select v1.Fdate,
	u1.ficmobillno,
--	u1.FSourceTranType,
	u1.FSourceInterId,
	u1.FSourceBillNo,
	w1.FbillNO,
	y1.FInterID,
	y1.FEntryID,
	y1.Fendworkdate,
	y1.FAuxQtyPass
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 
left join SHProcRptmain w1 on u1.FSourceInterId=w1.finterid
inner join SHProcRpt y1 on w1.FInterID=y1.FInterID
LEFT JOIN t_SubMessage t1 ON y1.FOperID=t1.FInterID 
where 1=1 
and CONVERT(VARCHAR(7),v1.Fdate,120) <=  '2011-09' 
--and ISNULL(u1.FICMOBillNo,'') = '63495'
and v1.FTranType=2 AND v1.FROB=1 AND  v1.FCancellation = 0
and t1.fname='包装'
and CONVERT(VARCHAR(7),y1.Fendworkdate,120)>='2011-10')t
where SHProcRpt.Finterid=t.finterid and SHProcRpt.fentryid=t.fentryid

select v1.Fdate,
	u1.ficmobillno,
--	u1.FSourceTranType,
	u1.FSourceInterId,
	u1.FSourceBillNo,
	w1.FbillNO,
	y1.FInterID,
	y1.FEntryID,
	y1.Fendworkdate,
	y1.FAuxQtyPass
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 
left join SHProcRptmain w1 on u1.FSourceInterId=w1.finterid
inner join SHProcRpt y1 on w1.FInterID=y1.FInterID
LEFT JOIN t_SubMessage t1 ON y1.FOperID=t1.FInterID 
where 1=1 
and CONVERT(VARCHAR(7),v1.Fdate,120) <=  '2011-09' 
--and ISNULL(u1.FICMOBillNo,'') = '63495'
and v1.FTranType=2 AND v1.FROB=1 AND  v1.FCancellation = 0
and t1.fname='包装'
and CONVERT(VARCHAR(7),y1.Fendworkdate,120)>='2011-10'

----包装差异(流转卡)
--
--select top 10000 t1.FFlowCardNo,t1.fsourceinterid,t2.FFlowCardNo --t2.FFlowCardInterID,t2.FFlowCardEntryID
--from ICShop_FlowCardEntry t1 
--left join SHProcRpt t2 on t1.FID =t2.FFlowCardInterID  and t1.fentryid=t2.FflowcardEntryID
--where t1.FFlowCardNo<>t2.FFlowCardNo 

select v1.Fdate,
	u1.ficmobillno,
--	u1.FSourceTranType,
	u1.FSourceInterId,
	u1.FSourceBillNo,
	w1.FbillNO,
	y1.FInterID,
	y1.FEntryID,
	y1.Fendworkdate,
	o1.fid,
	o1.findex,
	o1.FActFinishDate,
	o1.FAuxQtyPass,
	y1.FAuxQtyPass
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 
left join SHProcRptmain w1 on u1.FSourceInterId=w1.finterid
inner join SHProcRpt y1 on w1.FInterID=y1.FInterID
left join ICShop_FlowCardEntry o1 on y1.fflowcardinterid=o1.fid and y1.FflowcardEntryID=o1.fentryid
LEFT JOIN t_SubMessage t1 ON y1.FOperID=t1.FInterID 
where 1=1 
and CONVERT(VARCHAR(7),v1.Fdate,120) <=  '2011-09' 
--and ISNULL(u1.FICMOBillNo,'') = '63495'
and v1.FTranType=2 AND v1.FROB=1 AND  v1.FCancellation = 0
and t1.fname='包装'
and  CONVERT(VARCHAR(7),o1.FActFinishDate,120)>='2011-10'

update ICShop_FlowCardEntry set ICShop_FlowCardEntry.FActFinishDate=t.fdate from
(select v1.Fdate,
	u1.ficmobillno,
--	u1.FSourceTranType,
	u1.FSourceInterId,
	u1.FSourceBillNo,
	w1.FbillNO,
	y1.FInterID,
	y1.FEntryID,
	y1.Fendworkdate,
	o1.fid,
	o1.findex,
	o1.FActFinishDate,
	o1.FAuxQtyPass
--	y1.FAuxQtyPass
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 
left join SHProcRptmain w1 on u1.FSourceInterId=w1.finterid
inner join SHProcRpt y1 on w1.FInterID=y1.FInterID
left join ICShop_FlowCardEntry o1 on y1.fflowcardinterid=o1.fid and y1.FflowcardEntryID=o1.fentryid
LEFT JOIN t_SubMessage t1 ON y1.FOperID=t1.FInterID 
where 1=1 
and CONVERT(VARCHAR(7),v1.Fdate,120) <=  '2011-09' 
--and ISNULL(u1.FICMOBillNo,'') = '63495'
and v1.FTranType=2 AND v1.FROB=1 AND  v1.FCancellation = 0
and t1.fname='包装'
and  CONVERT(VARCHAR(7),o1.FActFinishDate,120)>='2011-10')t
where ICShop_FlowCardEntry.Fid=t.fid and ICShop_FlowCardEntry.findex=t.findex