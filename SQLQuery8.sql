DECLARE @StartPeriod char(10)
DECLARE @EndPeriod char(10)
SET @StartPeriod='2010-03-09' --ͳ�Ƶ�����
SET @EndPeriod='2010-03-11' --ͳ�Ƶ�����
SELECT 
	FWorkerID,
	FAuxWhtPass,
	sum(FAuxWhtPass) over() as sum
FROM SHProcRpt
WHERE CONVERT(char(10),FStartWorkDate,23) BETWEEN @StartPeriod AND @EndPeriod
order by FWorkerID