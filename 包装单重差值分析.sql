--日度
;WITH CTE
AS
(
SELECT 
	i.FItemID,
    --sum(isnull(i.FAuxWhtfinish,0)) as FAuxWhtfinish,
	avg(isnull(i.FAuxWhtSingle,0)) as FAvgWhtSingle
FROM SHProcRpt i
LEFT JOIN SHProcRptMain j ON i.FInterID=j.FInterID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID
LEFT JOIN t_ICItem m ON i.FItemID=m.FItemID
LEFT JOIN t_Item n ON m.FParentID=n.FItemID
WHERE
l.FName='包装'
AND
(
	n.FShortNumber in ('FTT','FFT','DLT','SLT')
)
AND
i.FAuxWhtSingle>0
and
CONVERT(VARCHAR(10),i.FendWorkDate,120)>='2020-01-01'
and
CONVERT(VARCHAR(10),i.FendWorkDate,120)<'2021-01-01'
group by i.FItemID
),
CTE_ForDiff
AS
(
SELECT 
	t1.FItemID,
    format(t1.FendWorkDate,'yyyy-MM-dd') AS FDate,
    sum(isnull(t1.FAuxQtyPass,0)) as FAuxQtyPass,
	avg(isnull(t1.FAuxWhtSingle,0)) as FAvgWhtSingle
    --avg(isnull(t1.FAuxWhtSingle,0))-t3.FAvgWhtSingle AS FDifference
FROM SHProcRpt t1
LEFT JOIN t_SubMessage t2 ON t1.FOperID=t2.FInterID
LEFT JOIN CTE t3 ON t1.FItemID=t3.FItemID
WHERE
t2.FName='包装'
AND
(
	t1.FItemID IN(select FItemID from cte)
)
AND
t1.FAuxWhtSingle>0
and
CONVERT(VARCHAR(10),t1.FendWorkDate,120)>='2021-01-01'
group by t1.FItemID,format(t1.FendWorkDate,'yyyy-MM-dd')
),
CTE_Diff
AS
(
SELECT case t4.FShortNumber 
            when 'FTT' then '直型'
            when 'FFT' then '后置式'
            when 'DLT' then '旗型'
            when 'SLT' then '旗型'
        END AS FShortNumber,
    t1.FItemID,
    t1.FDate,
    --t1.FAvgWhtSingle,
    t1.FAvgWhtSingle-t2.FAvgWhtSingle AS FSingleDiff,
    (t1.FAvgWhtSingle-t2.FAvgWhtSingle)*t1.FAuxQtyPass AS FWhtDiff
FROM CTE_ForDiff t1
LEFT JOIN CTE t2 ON t1.FItemID=t2.FItemID
LEFT JOIN t_ICItem t3 ON t1.FItemID=t3.FItemID
LEFT JOIN t_Item t4 ON t3.FParentID=t4.FItemID
)



SELECT FShortNumber ,
    FDate,
    SUM(FWhtDiff) AS FWhtDiff,
    SUM(FSingleDiff) AS FSingleDiff 
FROM CTE_Diff
GROUP BY FShortNumber,FDate
ORDER BY FShortNumber,FDate


--周度
--SELECT datepart(week, GETDATE()) 
;WITH CTE
AS
(
SELECT 
	i.FItemID,
    --sum(isnull(i.FAuxWhtfinish,0)) as FAuxWhtfinish,
	avg(isnull(i.FAuxWhtSingle,0)) as FAvgWhtSingle
FROM SHProcRpt i
LEFT JOIN SHProcRptMain j ON i.FInterID=j.FInterID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID
LEFT JOIN t_ICItem m ON i.FItemID=m.FItemID
LEFT JOIN t_Item n ON m.FParentID=n.FItemID
WHERE
l.FName='包装'
AND
(
	n.FShortNumber in ('FTT','FFT','DLT','SLT')
)
AND
i.FAuxWhtSingle>0
and
CONVERT(VARCHAR(10),i.FendWorkDate,120)>='2020-01-01'
and
CONVERT(VARCHAR(10),i.FendWorkDate,120)<'2021-01-01'
group by i.FItemID
),
CTE_ForDiff
AS
(
SELECT 
	t1.FItemID,
    datepart(week, t1.FendWorkDate) AS FWeek,
    sum(isnull(t1.FAuxQtyPass,0)) as FAuxQtyPass,
	avg(isnull(t1.FAuxWhtSingle,0)) as FAvgWhtSingle
    --avg(isnull(t1.FAuxWhtSingle,0))-t3.FAvgWhtSingle AS FDifference
FROM SHProcRpt t1
LEFT JOIN t_SubMessage t2 ON t1.FOperID=t2.FInterID
LEFT JOIN CTE t3 ON t1.FItemID=t3.FItemID
WHERE
t2.FName='包装'
AND
(
	t1.FItemID IN(select FItemID from cte)
)
AND
t1.FAuxWhtSingle>0
and
CONVERT(VARCHAR(10),t1.FendWorkDate,120)>='2021-01-01'
group by t1.FItemID,datepart(week, t1.FendWorkDate) 
),
CTE_Diff
AS
(
SELECT case t4.FShortNumber 
            when 'FTT' then '直型'
            when 'FFT' then '后置式'
            when 'DLT' then '旗型'
            when 'SLT' then '旗型'
        END AS FShortNumber,
    t1.FItemID,
    t1.FWeek,
    --t1.FAvgWhtSingle,
    t1.FAvgWhtSingle-t2.FAvgWhtSingle AS FSingleDiff,
    (t1.FAvgWhtSingle-t2.FAvgWhtSingle)*t1.FAuxQtyPass AS FWhtDiff
FROM CTE_ForDiff t1
LEFT JOIN CTE t2 ON t1.FItemID=t2.FItemID
LEFT JOIN t_ICItem t3 ON t1.FItemID=t3.FItemID
LEFT JOIN t_Item t4 ON t3.FParentID=t4.FItemID
)



SELECT FShortNumber,
    FWeek,
    SUM(FWhtDiff) AS FWhtDiff,
    SUM(FSingleDiff) AS FSingleDiff 
FROM CTE_Diff
GROUP BY FShortNumber,FWeek
ORDER BY FShortNumber,FWeek



--月度
;WITH CTE
AS
(
SELECT 
	i.FItemID,
    --sum(isnull(i.FAuxWhtfinish,0)) as FAuxWhtfinish,
	avg(isnull(i.FAuxWhtSingle,0)) as FAvgWhtSingle
FROM SHProcRpt i
LEFT JOIN SHProcRptMain j ON i.FInterID=j.FInterID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID
LEFT JOIN t_ICItem m ON i.FItemID=m.FItemID
LEFT JOIN t_Item n ON m.FParentID=n.FItemID
WHERE
l.FName='包装'
AND
(
	n.FShortNumber in ('FTT','FFT','DLT','SLT')
)
AND
i.FAuxWhtSingle>0
and
CONVERT(VARCHAR(10),i.FendWorkDate,120)>='2020-01-01'
and
CONVERT(VARCHAR(10),i.FendWorkDate,120)<'2021-01-01'
group by i.FItemID
),
CTE_ForDiff
AS
(
SELECT 
	t1.FItemID,
    format(t1.FendWorkDate,'yyyy-MM') AS FDate,
    sum(isnull(t1.FAuxQtyPass,0)) as FAuxQtyPass,
	avg(isnull(t1.FAuxWhtSingle,0)) as FAvgWhtSingle
    --avg(isnull(t1.FAuxWhtSingle,0))-t3.FAvgWhtSingle AS FDifference
FROM SHProcRpt t1
LEFT JOIN t_SubMessage t2 ON t1.FOperID=t2.FInterID
LEFT JOIN CTE t3 ON t1.FItemID=t3.FItemID
WHERE
t2.FName='包装'
AND
(
	t1.FItemID IN(select FItemID from cte)
)
AND
t1.FAuxWhtSingle>0
and
CONVERT(VARCHAR(10),t1.FendWorkDate,120)>='2021-01-01'
group by t1.FItemID,format(t1.FendWorkDate,'yyyy-MM')
),
CTE_Diff
AS
(
SELECT t4.FShortNumber,t1.FItemID,
    t1.FDate,
    --t1.FAvgWhtSingle,
    t1.FAvgWhtSingle-t2.FAvgWhtSingle AS FSingleDiff,
    (t1.FAvgWhtSingle-t2.FAvgWhtSingle)*t1.FAuxQtyPass AS FWhtDiff
FROM CTE_ForDiff t1
LEFT JOIN CTE t2 ON t1.FItemID=t2.FItemID
LEFT JOIN t_ICItem t3 ON t1.FItemID=t3.FItemID
LEFT JOIN t_Item t4 ON t3.FParentID=t4.FItemID
)



SELECT FShortNumber,
    FDate,
    SUM(FWhtDiff) AS FWhtDiff,
    SUM(FSingleDiff) AS FSingleDiff 
FROM CTE_Diff
GROUP BY FShortNumber,FDate




--排序
;WITH CTE
AS
(
SELECT 
	i.FItemID,
    --sum(isnull(i.FAuxWhtfinish,0)) as FAuxWhtfinish,
	avg(isnull(i.FAuxWhtSingle,0)) as FAvgWhtSingle
FROM SHProcRpt i
LEFT JOIN SHProcRptMain j ON i.FInterID=j.FInterID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID
LEFT JOIN t_ICItem m ON i.FItemID=m.FItemID
LEFT JOIN t_Item n ON m.FParentID=n.FItemID
WHERE
l.FName='包装'
AND
(
	n.FShortNumber in ('FTT','FFT','DLT','SLT')
)
AND
i.FAuxWhtSingle>0
and
CONVERT(VARCHAR(10),i.FendWorkDate,120)>='2020-01-01'
and
CONVERT(VARCHAR(10),i.FendWorkDate,120)<'2021-01-01'
group by i.FItemID
),
CTE_ForDiff
AS
(
SELECT 
	t1.FItemID,
    sum(isnull(t1.FAuxQtyPass,0)) as FAuxQtyPass,
	avg(isnull(t1.FAuxWhtSingle,0)) as FAvgWhtSingle
    --avg(isnull(t1.FAuxWhtSingle,0))-t3.FAvgWhtSingle AS FDifference
FROM SHProcRpt t1
LEFT JOIN t_SubMessage t2 ON t1.FOperID=t2.FInterID
LEFT JOIN CTE t3 ON t1.FItemID=t3.FItemID
WHERE
t2.FName='包装'
AND
(
	t1.FItemID IN(select FItemID from cte)
)
AND
t1.FAuxWhtSingle>0
and
CONVERT(VARCHAR(10),t1.FendWorkDate,120)>='2021-01-01'
group by t1.FItemID
)

SELECT t3.FName ,
    t1.FAvgWhtSingle,
    t1.FAvgWhtSingle-t2.FAvgWhtSingle AS FSingleDiff,
    (t1.FAvgWhtSingle-t2.FAvgWhtSingle)*t1.FAuxQtyPass AS FWhtDiff
FROM CTE_ForDiff t1
LEFT JOIN CTE t2 ON t1.FItemID=t2.FItemID
LEFT JOIN t_ICItem t3 ON t1.FItemID=t3.FItemID
ORDER BY (t1.FAvgWhtSingle-t2.FAvgWhtSingle)*t1.FAuxQtyPass DESC