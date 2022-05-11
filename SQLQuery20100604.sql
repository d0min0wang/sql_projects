select * from t_ICItem 
where fmodel not in(
select distinct t4.FModel from seorder t1
LEFT JOIN t_Item t2 ON t1.FdeptID=t2.FItemID
LEFT JOIN seorderentry t3 ON t1.finterid=t3.finterid
LEFT JOIN t_ICItem t4 ON t3.FItemID=t4.FItemID)

select * from t_item where fitemid=1331
select * from t_item where fitemid=1213
select * from t_item where fitemid=1203



--where t2.fname='管件事业部'


--select t4.Fname,t1.finterid,t2.fname from seorder t1
--LEFT JOIN t_Item t2 ON t1.FdeptID=t2.FItemID
--LEFT JOIN seorderentry t3 ON t1.finterid=t3.finterid
--LEFT JOIN t_Item t4 ON t3.FItemID=t4.FItemID

--select * from seorderentry


--select * from t_SubMessage

--select distinct fmodel from t_ICItem