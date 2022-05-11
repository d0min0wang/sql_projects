select FBillNo as [单据编号],
	FPlanCommitDate as [计划开工],
	FCommitDate as [实际开工],
	datediff(month,FPlanCommitDate,FCommitDate) as [差额]
from ICMO
where datediff(month,FPlanCommitDate,FCommitDate)<>0
and
FPlanCommitDate>='2010-01-01'