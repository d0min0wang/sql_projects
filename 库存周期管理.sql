select t1.FDeptID,t2.FItemID,sum(t2.FAuxQty),count(t2.finterid) --,t2.FDate 
from SEOrder t1
left join SEOrderEntry t2 on t1.FInterID=t2.FInterID
where year(t2.FDate)='2015'
group by t1.FDeptID,t2.FItemID

select * from t_FieldDescription where FTableID=230005

select * from t_TableDescription where FDescription like '%œ˙ €%'