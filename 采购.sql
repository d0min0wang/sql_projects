select * from t_TableDescription where fdescription like '%客户%'

select * from PORequest

SELECT  Top 500 t2.FName AS 客户名称,
	t1.FNumber as 商机编号,
	t1.FName as 商机名称,
	t1.FResultDate as 赢单时间   
FROM  CRM_Opportunity t1
left join t_Organization t2 ON t1.FCustomerID=t2.FItemID
 WHERE t1.FStatus =  N'1'
and t1.FResultDate>='2012-06-01'

SELECT  Top 500 t2.FName,t1.*   FROM  CRM_Opportunity t1
left join t_Organization t2 ON t1.FCustomerID=t2.FItemID
 WHERE t1.FStatus =  N'1' AND
 t1.FNumber =  'OPP0055'  
AND t1.FClassTypeID=1012002 
AND 
ORDER BY t1.FNumber

select * from CRM_OppShare

select * from t_Organization

