select FBillNo as [���ݱ��],
	FPlanCommitDate as [�ƻ�����],
	FCommitDate as [ʵ�ʿ���],
	datediff(month,FPlanCommitDate,FCommitDate) as [���]
from ICMO
where datediff(month,FPlanCommitDate,FCommitDate)<>0
and
FPlanCommitDate>='2010-01-01'