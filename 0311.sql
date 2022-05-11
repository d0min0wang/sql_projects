



--select * from sysobjects where name like '%plan%' and xtype='u'


--select * from t_RP_Plan_Ar where finterid=1107


select t1.* from icsale t1
left join  t_RP_Plan_Ar t2
on t1.finterid=t2.finterid
where t1.fbillno like '%08184985%' 





