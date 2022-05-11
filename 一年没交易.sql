--	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID

CREATE TABLE #temp_Overtime_to_Outcome(
	FSuppName nvarchar(255),
	FDeptName nvarchar(255),
	FEmpName NVARCHAR(255),
	FOrderBillNo nvarchar(255),
	FOrdertime datetime)
INSERT INTO #temp_Overtime_to_Outcome
Select v2.FName,t2.FName,v3.FName,v1.FBillNo,v1.FDate
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON  v1.FInterID = u1.FInterID AND u1.FInterID <>0
LEFT JOIN t_Department t2 on v1.FDeptID=t2.FItemID
LEFT JOIN t_Organization v2 ON v1.FCustID=v2.FItemID
LEFT JOIN t_Emp v3 ON v2.Femployee=v3.FItemID
 where 1=1
AND u1.FMRPClosed=1
--AND (case when u1.FMRPClosed=1 then 'Y' else '' end IS NULL OR case when u1.FMRPClosed=1 then 'Y' else '' end='')
AND (case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end='Y')
AND (case when v1.FCancellation=1 then 'Y' else '' end IS NULL OR case when v1.FCancellation=1 then 'Y' else '' end ='')
AND (v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007100))
--AND u1.FDate>=DateAdd(M,-1,@Querytime)
AND u1.FDate<=getdate()
--ANd t2.FName LIKE '%����ñ%'

--select * from #temp_Overtime_to_Outcome
--select DateAdd(yy,-1,getdate())
select * from (
select rowid = row_number() over(partition by FSuppName order by FOrdertime desc),* from #temp_Overtime_to_Outcome
) a where rowid = 1 and FOrderTime<=DateAdd(yy,-1,getdate())
AND
FEmpName='周维维'

DROP TABLE #temp_Overtime_to_Outcome
--select * from t_tabledescription where fdescription like '%����%'
----210008 210009 230004 230005
--select * from t_fielddescription where ftableid=230004
--
--select top 100 * from SEOrderEntry
