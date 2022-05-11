--select * from t_tabledescription where fdescription like '%ÈÎÎñ%'

select * from t_fielddescription where ftableID=470000

select FOrderInterID from ICMO where FCheckDate>='2010-09-01' and fmrp=1052 and forderinterid <>0

select FBillNo,FMRP,FOrderInterID from ICMO where FCheckDate>='2010-09-01' and FMRP=11061 and
 forderinterid in(
select FOrderInterID from ICMO where FCheckDate>='2010-09-01' and fmrp=1052 and forderinterid <>0)
