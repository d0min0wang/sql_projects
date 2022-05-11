CREATE Table #JRNewA(FCustID int,FDate datetime,FCustType int default(0))
--CREATE Table #JRNewB(FCustID int,FDate datetime,FCustType int default(0))
CREATE Table #JRNew(FCustID int,FDate datetime,FCustType int default(0))

insert into #JRNewA(FCustID,FDate)
select top 10000
	v1.FSupplyID,
	min(v1.FDate) as FDate
From ICStockBill v1 
inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID 
where v1.FTranType=21
GROUP BY v1.FSupplyID

--insert into #JRNewB(FCustID,FDate)
--select top 10000
--	v1.FSupplyID,
--	min(v1.FDate) as FDate
--From ICStockBill v1 
--inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID 
--where v1.FTranType=21 and year(v1.FDate)='2011'
--GROUP BY v1.FSupplyID

Update #JRNewA SET FCustType=1
WHERE year(FDate)<>'2011' and (SELECT COUNT(*) 
	FROM ICStockBill i 
	WHERE i.FTranType=21 And Year(i.FDate)=2011 And i.FSupplyID=FCustID)>0
Update #JRNewA SET FCustType=1
WHERE  (SELECT COUNT(*) 
	FROM ICStockBill i 
	WHERE i.FTranType=21 And Year(i.FDate)=2010 And i.FSupplyID=FCustID)>0

INSERT INTO #JRNew
select * from #JRNewA where FCustType=0
--union all
--select * from #JRNewB where FCustType=0

select * from #JRNew
drop Table #JRNewA
--drop Table #JRNewB
drop Table #JRNew
--DATEADD(mm, DATEDIFF(mm,0,FMinDate), 0)