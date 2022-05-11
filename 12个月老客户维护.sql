CREATE Table #JROld(FCustID int,
	FConsignAmount1 decimal(18,4),
	FConsignAmount2 decimal(18,4),
	FConsignAmount3 decimal(18,4),
	FConsignAmount4 decimal(18,4),
	FConsignAmount5 decimal(18,4),
	FConsignAmount6 decimal(18,4),
	FConsignAmount7 decimal(18,4),
	FConsignAmount8 decimal(18,4),
	FConsignAmount9 decimal(18,4),
	FConsignAmount10 decimal(18,4),
	FConsignAmount11 decimal(18,4),
	FConsignAmount12 decimal(18,4),
	FDate datetime)
--CREATE Table #JROldRecode(FCustID int,FDate datetime)


insert into #JROld(FCustID,
	FConsignAmount1,
	FConsignAmount2,
	FConsignAmount3,
	FConsignAmount4,
	FConsignAmount5,
	FConsignAmount6,
	FConsignAmount7,
	FConsignAmount8,
	FConsignAmount9,
	FConsignAmount10,
	FConsignAmount11,
	FConsignAmount12,
	FDate)
select top 100000
	v1.FSupplyID,
	sum(isnull(case month(v1.FDate) when '1' then u1.FConsignAmount end,0)) as [month1],
	sum(isnull(case month(v1.FDate) when '2' then u1.FConsignAmount end,0)) as [month2],
	sum(isnull(case month(v1.FDate) when '3' then u1.FConsignAmount end,0)) as [month3],
	sum(isnull(case month(v1.FDate) when '4' then u1.FConsignAmount end,0)) as [month4],
	sum(isnull(case month(v1.FDate) when '5' then u1.FConsignAmount end,0)) as [month5],
	sum(isnull(case month(v1.FDate) when '6' then u1.FConsignAmount end,0)) as [month6],
	sum(isnull(case month(v1.FDate) when '7' then u1.FConsignAmount end,0)) as [month7],
	sum(isnull(case month(v1.FDate) when '8' then u1.FConsignAmount end,0)) as [month8],
	sum(isnull(case month(v1.FDate) when '9' then u1.FConsignAmount end,0)) as [month9],
	sum(isnull(case month(v1.FDate) when '10' then u1.FConsignAmount end,0)) as [month10],
	sum(isnull(case month(v1.FDate) when '11' then u1.FConsignAmount end,0)) as [month11],
	sum(isnull(case month(v1.FDate) when '12' then u1.FConsignAmount end,0)) as [month12],
	min(v1.FDate) as FDate
From ICStockBill v1
inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
where v1.FTranType=21 and year(v1.FDate)='2012'
GROUP BY v1.FSupplyID

delete from #JROld
where
FConsignAmount1=0 or
FConsignAmount2=0 or
FConsignAmount3=0 or
FConsignAmount4=0 or
FConsignAmount5=0 or
FConsignAmount6=0 or
FConsignAmount7=0 or
FConsignAmount8=0 or
FConsignAmount9=0 or
FConsignAmount10=0 or
FConsignAmount11=0 or
FConsignAmount12=0

select * from #JROld

select ttt4.FName,
	ttt3.FName,
	ttt6.FName,
	ttt1.[2012],
	ttt1.[2013] from
(
select FSupplyID,
	sum([2012]) as [2012],
	sum([2013]) as [2013] from
(
Select v1.FSupplyID,
	case year(v1.FDate) when '2012' then u1.FConsignAmount end as [2012],
	case year(v1.FDate) when '2013' then u1.FConsignAmount end as [2013]
From ICStockBill v1 
inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
Where v1.FTranType=21 And v1.FDate>='2012-01-31'
and v1.FSupplyID in (select FCustID from #JROld)
--Group by v1.FSupplyID
) tt1
Group by FSupplyID
)ttt1
left join t_Organization ttt3 on ttt1.FSupplyID=ttt3.FItemID 
left join t_Department ttt4 on ttt4.FItemID=ttt3.FDepartment 
left join t_Emp ttt6 on ttt6.FItemID=ttt3.Femployee
--where ttt1.[2012]>=200000 

drop table #JROld
