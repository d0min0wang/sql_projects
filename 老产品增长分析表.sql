--整体
;WITH cte
AS
(
SELECT  
    u1.FItemID,
    sum(case when YEAR(v1.FDate)='2013' then u1.FConsignAmount else 0 END) AS '2013',
    sum(case when YEAR(v1.FDate)='2014' then u1.FConsignAmount else 0 END) AS '2014',
    sum(case when YEAR(v1.FDate)='2015' then u1.FConsignAmount else 0 END) AS '2015',
    sum(case when YEAR(v1.FDate)='2016' then u1.FConsignAmount else 0 END) AS '2016',
    sum(case when YEAR(v1.FDate)='2017' then u1.FConsignAmount else 0 END) AS '2017',
    sum(case when YEAR(v1.FDate)='2018' then u1.FConsignAmount else 0 END) AS '2018',
    sum(case when YEAR(v1.FDate)='2019' then u1.FConsignAmount else 0 END) AS '2019',
    sum(case when YEAR(v1.FDate)='2020' then u1.FConsignAmount else 0 END) AS '2020',
    sum(case when YEAR(v1.FDate)='2021' then u1.FConsignAmount else 0 END) AS '2021',
    sum(case when YEAR(v1.FDate)='2022' then u1.FConsignAmount else 0 END) AS '2022',
    sum(case when YEAR(v1.FDate)='2023' then u1.FConsignAmount else 0 END) AS '2023'
FROM ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
WHERE 
--YEAR(t2.FCreateDate) in ('2023') AND MONTH(t2.FCreateDate)='10'
--where year(v1.FDate)IN ('2022') 
--and year(t2.FCreateDate) in ('2022')
--and month(v1.FDate)<='6'
v1.FTranType=21 
GROUP BY u1.FItemID
)
SELECT t1.FName AS fitemname,
    t2.FCreateDate,
    t6.FName,
    t0.*
FROM cte t0
LEFT JOIN t_ICItem t1 ON t0.FItemID=t1.FItemID
LEFT JOIN t_BaseProperty t2 on	 t1.FItemID=t2.FItemID AND t2.FTypeID=3 
LEFT JOIN t_Department t6 ON t1.FSource=t6.FItemID

--按部门
;WITH cte
AS
(
SELECT  
    u1.FItemID,
    t3.Fdepartment,
    sum(case when YEAR(v1.FDate)='2013' then u1.FConsignAmount else 0 END) AS '2013',
    sum(case when YEAR(v1.FDate)='2014' then u1.FConsignAmount else 0 END) AS '2014',
    sum(case when YEAR(v1.FDate)='2015' then u1.FConsignAmount else 0 END) AS '2015',
    sum(case when YEAR(v1.FDate)='2016' then u1.FConsignAmount else 0 END) AS '2016',
    sum(case when YEAR(v1.FDate)='2017' then u1.FConsignAmount else 0 END) AS '2017',
    sum(case when YEAR(v1.FDate)='2018' then u1.FConsignAmount else 0 END) AS '2018',
    sum(case when YEAR(v1.FDate)='2019' then u1.FConsignAmount else 0 END) AS '2019',
    sum(case when YEAR(v1.FDate)='2020' then u1.FConsignAmount else 0 END) AS '2020',
    sum(case when YEAR(v1.FDate)='2021' then u1.FConsignAmount else 0 END) AS '2021',
    sum(case when YEAR(v1.FDate)='2022' then u1.FConsignAmount else 0 END) AS '2022',
    sum(case when YEAR(v1.FDate)='2023' then u1.FConsignAmount else 0 END) AS '2023'
FROM ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
LEFT JOIN t_Organization t3 ON v1.FSupplyID=t3.FItemID
WHERE 
--YEAR(t2.FCreateDate) in ('2023') AND MONTH(t2.FCreateDate)='10'
--where year(v1.FDate)IN ('2022') 
--and year(t2.FCreateDate) in ('2022')
--and month(v1.FDate)<='6'
v1.FTranType=21 
GROUP BY u1.FItemID,t3.Fdepartment
)
SELECT t1.FName AS fitemname,
    t2.FCreateDate,
    t6.FName,
    t0.*
FROM cte t0
LEFT JOIN t_ICItem t1 ON t0.FItemID=t1.FItemID
LEFT JOIN t_BaseProperty t2 on	 t1.FItemID=t2.FItemID AND t2.FTypeID=3 
LEFT JOIN t_Department t6 ON t0.Fdepartment=t6.FItemID
ORDER BY t1.FName,t6.FName

