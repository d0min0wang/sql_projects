select t1.FNumber,t1.FName,t2.FSettleID from t_Organization t1
left join SEOrder t2 ON t1.FItemID=t2.FCustID
--49
--230004
--230005
--230031

select * from t_fielddescription where ftableid=230004

select * from t_tabledescription where fdescription like '%销售%'

select t1.FCustID,t1.FSettleID from SEOrder t1
left join 