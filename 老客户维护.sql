CREATE Table #JROld(FCustID int,FDate datetime)
CREATE Table #JROldRecode(FCustID int,FDate datetime)


insert into #JROld(FCustID,FDate)
select top 10000
	FSupplyID,
	min(FDate) as FDate
From ICStockBill 
where FTranType=21 and FDate<='2012-01-31'
GROUP BY FSupplyID

insert into #JROld(FCustID,FDate)
select top 10000
	FSupplyID,
	min(FDate) as FDate
From AIS20131027152019.dbo.ICStockBill
where FTranType=21 and FDate<='2012-01-31'
GROUP BY FSupplyID

insert into #JROldRecode(FCustID,FDate)
select FCustID,
	min(FDate)
from #JROld
group by FCustID


select* from
(
select FSupplyID,sum([2012]),sum([2013]) from
(
Select v1.FSupplyID,
	case year(v1.FDate) when '2012' then u1.FConsignAmount end as [2012],
	case year(v1.FDate) when '2013' then u1.FConsignAmount end as [2013]
From ICStockBill v1 
inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
Where v1.FTranType=21 And v1.FDate>='2012-01-31'
and v1.FSupplyID in (select FCustID from #JROldRecode)
--Group by v1.FSupplyID
) tt1
Group by FSupplyID
)ttt1
left join t_Organization ttt3 on ttt1.FCustID=ttt3.FItemID 
left join t_Department ttt4 on t4.FItemID=ttt3.FDepartment 
left join t_Emp t6 on ttt6.FItemID=ttt3.Femployee 

drop table #JROld
drop table #JROldRecode
