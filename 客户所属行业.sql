select F_117,t2.FName,F_118,* from t_organization t1
left join t_Item t2 on t1.F_117=t2.FItemID
where 
--t1.fname like '%����%'
t1.F_117<>0 and t1.F_117 IS NOT NULL


select * from t_item where fitemid=12093

--F_117 �ͻ�������ҵ
--F_118 ������ҵ�ṹ