
--select * from icmo where fbillno='39544'

select * from t_tabledescription where fdescription like '%��������%'
--470000

select * from t_fielddescription where ftableid=470000 and fdescription like '%����%'

select fbillno,FPlanCommitDate,FCommitDate from icmo where fbillno='50686'

UPDATE icmo
SET FPlanCommitDate=FCommitDate
WHERE fbillno in (select fbillno from xy_t_self001)

drop table xy_t_self001
