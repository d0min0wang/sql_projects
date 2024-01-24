select t3.fname,t1.fname,t1.FNumber,t2.FCreateDate,t2.fcreateuser from t_ICItem t1
LEFT JOIN t_BaseProperty t2 on	 t1.FItemID=t2.FItemID AND t2.FTypeID=3 
LEFT JOIN t_Department t3 ON t1.FSource=t3.FItemID
WHERE YEAR(t2.FCreateDate) in ('2023') 
AND t3.fname='电气连接事业部'


select * FROM t_TableDescription WHERE ftablename='t_BaseProperty'
SELECT * FROM t_FieldDescription WHERE FDescription LIKE '%创建%'


SELECT t3.fname,count(DISTINCT t1.fsupplyid) FROM icstockbill t1
left join t_organization t2 on t1.fsupplyid=t2.FItemID
LEFT JOIN t_Department t3 ON t2.Fdepartment=t3.FItemID
WHERE year(t1.FDate)='2021' 
group BY t3.FName WITH ROLLUP

SELECT t3.fname,count(DISTINCT t1.fsupplyid),sum(t4.FConsignAmount)/10000 FROM icstockbill t1
left join t_organization t2 on t1.fsupplyid=t2.FItemID
LEFT JOIN t_Department t3 ON t2.Fdepartment=t3.FItemID
LEFT JOIN ICStockBillEntry t4 on t1.FInterID=t4.FInterID
WHERE year(t1.FDate)='2021' 
group BY t3.FName WITH ROLLUP