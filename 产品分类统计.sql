--产品代码93开头的为外购硅胶产品；产品助记码GQ开头为硅胶产品

Select t4.FName, sum(u1.FConsignAmount) From ICStockBill v1 inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID AND u1.FInterID <> 0
left join t_ICItem t3 on u1.FItemID=t3.FItemID
LEFT JOIN t_Organization t4 ON v1.fsupplyid=t4.FItemID
Where (v1.FTranType = 21 AND (v1.FCancellation = 0)) and t3.FHelpCode like 'GQ%' --And Year(v1.FDate)='2022'
AND t4.FName LIKE '%将军%'
Group by t4.FName

Select v1.FSupplyID, sum(u1.FConsignAmount) From ICStockBill v1 inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID AND u1.FInterID <> 0
left join t_ICItem t3 on u1.FItemID=t3.FItemID
LEFT JOIN t_Organization t4 ON v1.fsupplyid=t4.FItemID
Where (v1.FTranType = 21 AND (v1.FCancellation = 0)) and t3.FNumber like '93.%' --And Year(v1.FDate)='2022'
AND t4.FName LIKE '%将军%'
Group by v1.FSupplyID

SELECT * FROM t_Organization where 

SELECT FHelpCode,* FROM t_ICItem where --fnumber like '93.%' or 
FHelpCode LIKE 'GQ%'


Select FORMAT(v1.FDate, 'yyyy-MM'), 
    sum(case when t3.fnumber like '93.%' then u1.FConsignAmount else 0 END) AS 外购硅胶销售额,
    sum(case when t3.fnumber like '93.%' then u1.FAuxQty else 0 END) AS 外购硅胶销售数量,
    sum(case when t3.FHelpCode like 'GQ%' then u1.FConsignAmount else 0 end) AS 硅胶销售额, 
     sum(case when t3.FHelpCode like 'GQ%' then u1.FAuxQty else 0 end) AS 硅胶销售数量, 
    sum(u1.FConsignAmount) AS 销售额合计, 
    sum(u1.FAuxQty) AS 销售数量合计
From ICStockBill v1 
inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID AND u1.FInterID <> 0
left join t_ICItem t3 on u1.FItemID=t3.FItemID
LEFT JOIN t_Organization t4 ON v1.fsupplyid=t4.FItemID
Where (v1.FTranType = 21 AND (v1.FCancellation = 0)) and (t3.FNumber like '93.%' or t3.FHelpCode LIKE 'GQ%' )
And Year(v1.FDate) in('2019','2020','2021','2022','2023')
AND t4.fname LIKE '%富士通%'
Group by FORMAT(v1.FDate, 'yyyy-MM')
order by FORMAT(v1.FDate, 'yyyy-MM') ASC

Select year(v1.FDate), 
    sum(case when t3.fnumber like '93.%' then v1.FConsignAmount else 0 END) AS 外购硅胶销售额,
    sum(case when t3.fnumber like '93.%' then v1.FAuxQty else 0 END) AS 外购硅胶销售数量,
    sum(case when t3.FHelpCode like 'GQ%' then v1.FConsignAmount else 0 end) AS 硅胶销售额, 
     sum(case when t3.FHelpCode like 'GQ%' then v1.FAuxQty else 0 end) AS 硅胶销售数量, 
    sum(v1.FConsignAmount) AS 销售额合计, 
    sum(v1.FAuxQty) AS 销售数量合计
From 
(
	select t1.FSupplyID,t1.FDate,t2.FItemID,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID,t1.FCancellation 
	from [AIS20130811090352].[dbo].ICStockBill t1 
	INNER JOIN [AIS20130811090352].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	where year(t1.FDate)<='2012'
	union all
	select t1.FSupplyID,t1.FDate,t2.FItemID,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID ,t1.FCancellation 
	from [AIS20140921170539].[dbo].ICStockBill t1 
	INNER JOIN [AIS20140921170539].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	where year(t1.FDate)>='2013') v1
left join t_ICItem t3 on v1.FItemID=t3.FItemID
Where (v1.FTranType = 21 AND (v1.FCancellation = 0)) and t3.FNumber like '93.%' or t3.FHelpCode LIKE 'GQ%' --And Year(v1.FDate)='2022'
Group by year(v1.FDate)
order by year(v1.FDate) ASC


Select FORMAT(v1.FDate, 'yyyy-MM'), t3.fname,avg(u1.FConsignPrice)
    
From ICStockBill v1 
inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID AND u1.FInterID <> 0
left join t_ICItem t3 on u1.FItemID=t3.FItemID
Where (v1.FTranType = 21 AND (v1.FCancellation = 0)) and (t3.FNumber like '93.%' or t3.FHelpCode LIKE 'GQ%' )
And Year(v1.FDate) in('2019','2020','2021','2022','2023')
Group by FORMAT(v1.FDate, 'yyyy-MM'),t3.FName
order by FORMAT(v1.FDate, 'yyyy-MM') ASC


select * FROM t_TableDescription where FTableName='ICStockBillEntry'

SELECT * FROM t_FieldDescription where FTableID=210009 and FDescription LIKE '%单价%'

--按客户
Select Year(v1.FDate),
    t4.fname, 
    sum(case when t3.fnumber like '93.%' then u1.FConsignAmount else 0 END) AS 外购硅胶销售额,
    sum(case when t3.fnumber like '93.%' then u1.FAuxQty else 0 END) AS 外购硅胶销售数量,
    sum(case when t3.FHelpCode like 'GQ%' then u1.FConsignAmount else 0 end) AS 硅胶销售额, 
     sum(case when t3.FHelpCode like 'GQ%' then u1.FAuxQty else 0 end) AS 硅胶销售数量, 
    sum(u1.FConsignAmount) AS 销售额合计, 
    sum(u1.FAuxQty) AS 销售数量合计
From ICStockBill v1 
inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID AND u1.FInterID <> 0
left join t_ICItem t3 on u1.FItemID=t3.FItemID
LEFT JOIN t_Organization t4 ON v1.fsupplyid=t4.FItemID
Where (v1.FTranType = 21 AND (v1.FCancellation = 0)) and (t3.FNumber like '93.%' or t3.FHelpCode LIKE 'GQ%' )
And Year(v1.FDate) in('2019','2020','2021','2022','2023')
and MONTH(v1.fdate)<='6'
AND t4.f_131 LIKE '%富士通%'
Group by Year(v1.FDate),t4.fname
order by Year(v1.FDate),sum(u1.FConsignAmount) desc