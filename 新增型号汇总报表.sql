select t3.fname,t1.fname,t1.FNumber,t1.f_102,t1.f_105,t2.FCreateDate,t2.fcreateuser from t_ICItem t1
LEFT JOIN t_BaseProperty t2 on	 t1.FItemID=t2.FItemID AND t2.FTypeID=3 
LEFT JOIN t_Department t3 ON t1.FSource=t3.FItemID
WHERE (YEAR(t2.FCreateDate) in ('2023') OR year(t1.f_105)='2023')
AND t3.fname='电气连接事业部'


select * FROM t_TableDescription WHERE ftablename='t_BaseProperty'
SELECT * FROM t_FieldDescription WHERE FDescription LIKE '%创建%'