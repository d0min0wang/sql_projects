select t1.fnumber,t1.FName,t1.FSetID,t2.fname fname_1 from t_organization t1
left join t_settle t2 on t1.fsetid=t2.fitemid
where t1.fname like '%．#顺德安爱工业有限公司%'
--select * from t_organization

----fsetid
----t_settle

--select * from t_settle


