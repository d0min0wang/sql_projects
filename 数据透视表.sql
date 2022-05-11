;WITH CTE_SingleWht
AS
(
SELECT 
	i.FItemID,
	--count(l.FName) AS FName2,	
	format(i.FendWorkDate,'yyyy-MM') AS FMonth,
	max(isnull(i.FAuxWhtSingle,0)) as FMaxWhtSingle,
	avg(isnull(i.FAuxWhtSingle,0)) as FAvgWhtSingle,
	min(isnull(i.FAuxWhtSingle,0)) as FMinWhtSingle
FROM SHProcRpt i
LEFT JOIN SHProcRptMain j ON i.FInterID=j.FInterID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID
LEFT JOIN t_ICItem m ON i.FItemID=m.FItemID
WHERE
l.FName='包装'
AND
(
	m.FName LIKE 'DL%'
	OR
	m.FName LIKE 'SL%'
)
AND
i.FAuxWhtSingle>0
and
CONVERT(VARCHAR(10),i.FendWorkDate,120)>='2020-01-01'
group by i.FItemID,format(i.FendWorkDate,'yyyy-MM')
),
CTE_OutStock
AS
(
SELECT u1.FItemID,
    format(v1.FDate,'yyyy-MM') AS FMonth,
	sum(u1.FAuxQty) AS FAuxQty
FROM ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
left JOIN t_ICItem t1 ON u1.FItemID=t1.FItemID
where 
v1.FTranType=21 
and
CONVERT(VARCHAR(10),v1.FDate,120)>='2020-01-01'
AND
(
	t1.FName LIKE 'DL%'
	OR
	t1.FName LIKE 'SL%'
)
GROUP BY u1.FItemID,format(v1.FDate,'yyyy-MM')
),
CTE
AS
(
	SELECT FItemID,FMonth FROM CTE_SingleWht
	UNION
	SELECT FItemID,FMonth FROM CTE_OutStock
),
CTE1
AS
(
	
	SELECT t4.FName,
		t1.FMonth,
		t2.FMaxWhtSingle,
		t2.FAvgWhtSingle,
		t2.FMinWhtSingle,
		t3.FAuxQty 
	FROM CTE t1
	LEFT JOIN CTE_SingleWht t2 ON t1.FItemID=t2.FItemID AND t1.FMonth=t2.FMonth
	LEFT join CTE_OutStock t3 ON t1.FItemID=t3.FItemID AND t1.FMonth=t3.FMonth
	LEFT join t_ICItem t4 ON t1.FItemID=t4.FItemID
)	
--SELECT FName,
--	[] FROM CTE1
--PIVOT
--(
--	SUM(FMaxWhtSingle) FOR
--	FMonth IN([2020-01],[2020-02])
--)as PT


SELECT FName AS '产品',
    sum(case FMonth when '2020-01' then FMaxWhtSingle else 0 end) AS '2020-01月最大单重',
	sum(case FMonth when '2020-01' then FAvgWhtSingle else 0 end) AS '2020-01月平均单重',
	sum(case FMonth when '2020-01' then FMinWhtSingle else 0 end) AS '2020-01月最小单重',
	sum(case FMonth when '2020-01' then FAuxQty else 0 end) AS '2020-01月出货量',
	sum(case FMonth when '2020-02' then FMaxWhtSingle else 0 end) AS '2020-02月最大单重',
	sum(case FMonth when '2020-02' then FAvgWhtSingle else 0 end) AS '2020-02月平均单重',
	sum(case FMonth when '2020-02' then FMinWhtSingle else 0 end) AS '2020-02月最小单重',
	sum(case FMonth when '2020-02' then FAuxQty else 0 end) AS '2020-02月出货量',
	sum(case FMonth when '2020-03' then FMaxWhtSingle else 0 end) AS '2020-03月最大单重',
	sum(case FMonth when '2020-03' then FAvgWhtSingle else 0 end) AS '2020-03月平均单重',
	sum(case FMonth when '2020-03' then FMinWhtSingle else 0 end) AS '2020-03月最小单重',
	sum(case FMonth when '2020-03' then FAuxQty else 0 end) AS '2020-03月出货量',
	sum(case FMonth when '2020-04' then FMaxWhtSingle else 0 end) AS '2020-04月最大单重',
	sum(case FMonth when '2020-04' then FAvgWhtSingle else 0 end) AS '2020-04月平均单重',
	sum(case FMonth when '2020-04' then FMinWhtSingle else 0 end) AS '2020-04月最小单重',
	sum(case FMonth when '2020-04' then FAuxQty else 0 end) AS '2020-04月出货量',
	sum(case FMonth when '2020-05' then FMaxWhtSingle else 0 end) AS '2020-05月最大单重',
	sum(case FMonth when '2020-05' then FAvgWhtSingle else 0 end) AS '2020-05月平均单重',
	sum(case FMonth when '2020-05' then FMinWhtSingle else 0 end) AS '2020-05月最小单重',
	sum(case FMonth when '2020-05' then FAuxQty else 0 end) AS '2020-05月出货量',
	sum(case FMonth when '2020-06' then FMaxWhtSingle else 0 end) AS '2020-06月最大单重',
	sum(case FMonth when '2020-06' then FAvgWhtSingle else 0 end) AS '2020-06月平均单重',
	sum(case FMonth when '2020-06' then FMinWhtSingle else 0 end) AS '2020-06月最小单重',
	sum(case FMonth when '2020-06' then FAuxQty else 0 end) AS '2020-06月出货量',
	sum(case FMonth when '2020-07' then FMaxWhtSingle else 0 end) AS '2020-07月最大单重',
	sum(case FMonth when '2020-07' then FAvgWhtSingle else 0 end) AS '2020-07月平均单重',
	sum(case FMonth when '2020-07' then FMinWhtSingle else 0 end) AS '2020-07月最小单重',
	sum(case FMonth when '2020-07' then FAuxQty else 0 end) AS '2020-07月出货量',
	sum(case FMonth when '2020-08' then FMaxWhtSingle else 0 end) AS '2020-08月最大单重',
	sum(case FMonth when '2020-08' then FAvgWhtSingle else 0 end) AS '2020-08月平均单重',
	sum(case FMonth when '2020-08' then FMinWhtSingle else 0 end) AS '2020-08月最小单重',
	sum(case FMonth when '2020-08' then FAuxQty else 0 end) AS '2020-08月出货量',
	sum(case FMonth when '2020-09' then FMaxWhtSingle else 0 end) AS '2020-09月最大单重',
	sum(case FMonth when '2020-09' then FAvgWhtSingle else 0 end) AS '2020-09月平均单重',
	sum(case FMonth when '2020-09' then FMinWhtSingle else 0 end) AS '2020-09月最小单重',
	sum(case FMonth when '2020-09' then FAuxQty else 0 end) AS '2020-09月出货量',
	sum(case FMonth when '2020-10' then FMaxWhtSingle else 0 end) AS '2020-10月最大单重',
	sum(case FMonth when '2020-10' then FAvgWhtSingle else 0 end) AS '2020-10月平均单重',
	sum(case FMonth when '2020-10' then FMinWhtSingle else 0 end) AS '2020-10月最小单重',
	sum(case FMonth when '2020-10' then FAuxQty else 0 end) AS '2020-10月出货量',
	sum(case FMonth when '2020-11' then FMaxWhtSingle else 0 end) AS '2020-11月最大单重',
	sum(case FMonth when '2020-11' then FAvgWhtSingle else 0 end) AS '2020-11月平均单重',
	sum(case FMonth when '2020-11' then FMinWhtSingle else 0 end) AS '2020-11月最小单重',
	sum(case FMonth when '2020-11' then FAuxQty else 0 end) AS '2020-11月出货量',
	sum(case FMonth when '2020-12' then FMaxWhtSingle else 0 end) AS '2020-12月最大单重',
	sum(case FMonth when '2020-12' then FAvgWhtSingle else 0 end) AS '2020-12月平均单重',
	sum(case FMonth when '2020-12' then FMinWhtSingle else 0 end) AS '2020-12月最小单重',
	sum(case FMonth when '2020-12' then FAuxQty else 0 end) AS '2020-12月出货量',

	sum(case FMonth when '2021-01' then FMaxWhtSingle else 0 end) AS '2021-01月最大单重',
	sum(case FMonth when '2021-01' then FAvgWhtSingle else 0 end) AS '2021-01月平均单重',
	sum(case FMonth when '2021-01' then FMinWhtSingle else 0 end) AS '2021-01月最小单重',
	sum(case FMonth when '2021-01' then FAuxQty else 0 end) AS '2021-01月出货量',
	sum(case FMonth when '2021-02' then FMaxWhtSingle else 0 end) AS '2021-02月最大单重',
	sum(case FMonth when '2021-02' then FAvgWhtSingle else 0 end) AS '2021-02月平均单重',
	sum(case FMonth when '2021-02' then FMinWhtSingle else 0 end) AS '2021-02月最小单重',
	sum(case FMonth when '2021-02' then FAuxQty else 0 end) AS '2021-02月出货量',
	sum(case FMonth when '2021-03' then FMaxWhtSingle else 0 end) AS '2021-03月最大单重',
	sum(case FMonth when '2021-03' then FAvgWhtSingle else 0 end) AS '2021-03月平均单重',
	sum(case FMonth when '2021-03' then FMinWhtSingle else 0 end) AS '2021-03月最小单重',
	sum(case FMonth when '2021-03' then FAuxQty else 0 end) AS '2021-03月出货量',
	sum(case FMonth when '2021-04' then FMaxWhtSingle else 0 end) AS '2021-04月最大单重',
	sum(case FMonth when '2021-04' then FAvgWhtSingle else 0 end) AS '2021-04月平均单重',
	sum(case FMonth when '2021-04' then FMinWhtSingle else 0 end) AS '2021-04月最小单重',
	sum(case FMonth when '2021-04' then FAuxQty else 0 end) AS '2021-04月出货量',
	sum(case FMonth when '2021-05' then FMaxWhtSingle else 0 end) AS '2021-05月最大单重',
	sum(case FMonth when '2021-05' then FAvgWhtSingle else 0 end) AS '2021-05月平均单重',
	sum(case FMonth when '2021-05' then FMinWhtSingle else 0 end) AS '2021-05月最小单重',
	sum(case FMonth when '2021-05' then FAuxQty else 0 end) AS '2021-05月出货量',
	sum(case FMonth when '2021-06' then FMaxWhtSingle else 0 end) AS '2021-06月最大单重',
	sum(case FMonth when '2021-06' then FAvgWhtSingle else 0 end) AS '2021-06月平均单重',
	sum(case FMonth when '2021-06' then FMinWhtSingle else 0 end) AS '2021-06月最小单重',
	sum(case FMonth when '2021-06' then FAuxQty else 0 end) AS '2021-06月出货量',
	sum(case FMonth when '2021-07' then FMaxWhtSingle else 0 end) AS '2021-07月最大单重',
	sum(case FMonth when '2021-07' then FAvgWhtSingle else 0 end) AS '2021-07月平均单重',
	sum(case FMonth when '2021-07' then FMinWhtSingle else 0 end) AS '2021-07月最小单重',
	sum(case FMonth when '2021-07' then FAuxQty else 0 end) AS '2021-07月出货量',
	sum(case FMonth when '2021-08' then FMaxWhtSingle else 0 end) AS '2021-08月最大单重',
	sum(case FMonth when '2021-08' then FAvgWhtSingle else 0 end) AS '2021-08月平均单重',
	sum(case FMonth when '2021-08' then FMinWhtSingle else 0 end) AS '2021-08月最小单重',
	sum(case FMonth when '2021-08' then FAuxQty else 0 end) AS '2021-08月出货量',
	sum(case FMonth when '2021-09' then FMaxWhtSingle else 0 end) AS '2021-09月最大单重',
	sum(case FMonth when '2021-09' then FAvgWhtSingle else 0 end) AS '2021-09月平均单重',
	sum(case FMonth when '2021-09' then FMinWhtSingle else 0 end) AS '2021-09月最小单重',
	sum(case FMonth when '2021-09' then FAuxQty else 0 end) AS '2021-09月出货量'
FROM cte1
GROUP BY FName
ORDER BY FName