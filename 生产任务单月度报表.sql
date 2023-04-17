--SELECT * FROM t_TableDescription where FTableName='ICMO' --470000

--SELECT * FROM t_FieldDescription where  FTableID=470000 AND FDescription LIKE '%人%'
--计划部门 FHeadSelfJ01133                                                                 
--顾客名称 FHeadSelfJ0195                                                                  
--标签要求 FHeadSelfJ01102                                                                 
--任务单数量 FAuxQty

;WITH CTE_Origin
AS
(
    SELECT t1.fcheckdate,
        t2.FName AS FDepartmentName,
        t3.FName AS FUserName,
        t4.FName AS FCustName,
        ISNULL(t5.FName,'*') AS FLabel,
        t1.FAuxQty
    FROM ICMO t1
    LEFT JOIN t_Department t2 ON t1.FHeadSelfJ01133=t2.FItemID
    LEFT JOIN t_User t3 ON t1.FBillerID=t3.FUserID AND t3.FUserID<>0
    LEFT JOIN t_Organization t4 on t1.FHeadSelfJ0195=t4.FItemID
    LEFT JOIN t_Item t5 ON t1.FHeadSelfJ01102=t5.FItemID
    WHERE year(t1.fcheckdate)='2023'
    AND t2.FName IN('电气连接国内事业部','电气连接事业部')
),
CTE_Total
AS
(
    SELECT FDepartmentName,
    FUserName,
    COUNT(*) AS FTotal,
    SUM(FAuxQty) AS FTotalQty,
    SUM(case MONTH(FCheckDate) when '1' then 1 end) AS FTotal1,
    SUM(case MONTH(FCheckDate) when '1' then FAuxQty end) AS FTotalQty1,
    SUM(case MONTH(FCheckDate) when '2' then 1 end) AS FTotal2,
    SUM(case MONTH(FCheckDate) when '2' then FAuxQty end) AS FTotalQty2,
    SUM(case MONTH(FCheckDate) when '3' then 1 end) AS FTotal3,
    SUM(case MONTH(FCheckDate) when '3' then FAuxQty end) AS FTotalQty3,
    SUM(case MONTH(FCheckDate) when '4' then 1 end) AS FTotal4,
    SUM(case MONTH(FCheckDate) when '4' then FAuxQty end) AS FTotalQty4,
    SUM(case MONTH(FCheckDate) when '5' then 1 end) AS FTotal5,
    SUM(case MONTH(FCheckDate) when '5' then FAuxQty end) AS FTotalQty5,
    SUM(case MONTH(FCheckDate) when '6' then 1 end) AS FTotal6,
    SUM(case MONTH(FCheckDate) when '6' then FAuxQty end) AS FTotalQty6,
    SUM(case MONTH(FCheckDate) when '7' then 1 end) AS FTotal7,
    SUM(case MONTH(FCheckDate) when '7' then FAuxQty end) AS FTotalQty7,
    SUM(case MONTH(FCheckDate) when '8' then 1 end) AS FTotal8,
    SUM(case MONTH(FCheckDate) when '8' then FAuxQty end) AS FTotalQty8,
    SUM(case MONTH(FCheckDate) when '9' then 1 end) AS FTotal9,
    SUM(case MONTH(FCheckDate) when '9' then FAuxQty end) AS FTotalQty9,
    SUM(case MONTH(FCheckDate) when '10' then 1 end) AS FTotal10,
    SUM(case MONTH(FCheckDate) when '10' then FAuxQty end) AS FTotalQty10,
    SUM(case MONTH(FCheckDate) when '11' then 1 end) AS FTotal11,
    SUM(case MONTH(FCheckDate) when '11' then FAuxQty end) AS FTotalQty11,
    SUM(case MONTH(FCheckDate) when '12' then 1 end) AS FTotal12,
    SUM(case MONTH(FCheckDate) when '12' then FAuxQty end) AS FTotalQty12
    FROM CTE_Origin
    GROUP BY FDepartmentName,FUserName
),
CTE_UnNormal
AS
(
    SELECT FDepartmentName,
    FUserName,
    SUM(case when FCustName='' or FLabel='*' then 1 else 0 end) AS FUnNormal,
    SUM(case when FCustName='' or FLabel='*' then FAuxQty else 0 end) AS FUnNormalFAuxQty,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='1' then 1 else 0 end) AS FUnNormal1,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='1' then FAuxQty else 0 end) AS FUnNormalFAuxQty1,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='2' then 1 else 0 end) AS FUnNormal2,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='2' then FAuxQty else 0 end) AS FUnNormalFAuxQty2,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='3' then 1 else 0 end) AS FUnNormal3,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='3' then FAuxQty else 0 end) AS FUnNormalFAuxQty3,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='4' then 1 else 0 end) AS FUnNormal4,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='4' then FAuxQty else 0 end) AS FUnNormalFAuxQty4,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='5' then 1 else 0 end) AS FUnNormal5,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='5' then FAuxQty else 0 end) AS FUnNormalFAuxQty5,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='6' then 1 else 0 end) AS FUnNormal6,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='6' then FAuxQty else 0 end) AS FUnNormalFAuxQty6,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='7' then 1 else 0 end) AS FUnNormal7,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='7' then FAuxQty else 0 end) AS FUnNormalFAuxQty7,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='8' then 1 else 0 end) AS FUnNormal8,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='8' then FAuxQty else 0 end) AS FUnNormalFAuxQty8,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='9' then 1 else 0 end) AS FUnNormal9,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='9' then FAuxQty else 0 end) AS FUnNormalFAuxQty9,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='10' then 1 else 0 end) AS FUnNormal10,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='10' then FAuxQty else 0 end) AS FUnNormalFAuxQty10,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='11' then 1 else 0 end) AS FUnNormal11,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='11' then FAuxQty else 0 end) AS FUnNormalFAuxQty11,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='12' then 1 else 0 end) AS FUnNormal12,
    SUM(case when (FCustName='' or FLabel='*') and MONTH(FCheckDate)='12' then FAuxQty else 0 end) AS FUnNormalFAuxQty12
    FROM CTE_Origin
    GROUP BY FDepartmentName,FUserName
)


SELECT t1.FDepartmentName,
    t1.FUserName,
    --一月
    t1.FTotal1 AS [1月总任务单数],
    t1.FTotal1-t2.FUnNormal1 AS [1月特殊张数],
    t1.FTotalQty1-t2.FUnNormalFAuxQty1 AS [1月特殊数量],
    (t1.FTotal1-t2.FUnNormal1)*1.0/t1.FTotal1 AS [1月特殊张数占比],
    t2.FUnNormal1 AS [1月非特殊张数],
    t2.FUnNormalFAuxQty1 AS [1月非特殊数量],
    t2.FUnNormal1*1.0/t1.FTotal1 AS [1月非特殊张数占比],
    --二月
    t1.FTotal2 AS [2月总任务单数],
    t1.FTotal2-t2.FUnNormal2 AS [2月特殊张数],
    t1.FTotalQty2-t2.FUnNormalFAuxQty2 AS [2月特殊数量],
    (t1.FTotal2-t2.FUnNormal2)*1.0/t1.FTotal2,
    t2.FUnNormal2,
    t2.FUnNormalFAuxQty2,
    t2.FUnNormal2*1.0/t1.FTotal2,
    --三月
    t1.FTotal3 AS [3月总任务单数],
    t1.FTotal3-t2.FUnNormal3 AS [3月特殊张数],
    t1.FTotalQty3-t2.FUnNormalFAuxQty3 AS [3月特殊数量],
    (t1.FTotal3-t2.FUnNormal3)*1.0/t1.FTotal3,
    t2.FUnNormal3,
    t2.FUnNormalFAuxQty3,
    t2.FUnNormal3*1.0/t1.FTotal3,
    --四月
    t1.FTotal4 AS [4月总任务单数],
    t1.FTotal4-t2.FUnNormal4 AS [4月特殊张数],
    t1.FTotalQty4-t2.FUnNormalFAuxQty4 AS [4月特殊数量],
    (t1.FTotal4-t2.FUnNormal4)*1.0/t1.FTotal4,
    t2.FUnNormal4,
    t2.FUnNormalFAuxQty4,
    t2.FUnNormal4*1.0/t1.FTotal4,
    --五月
    t1.FTotal5 AS [5月总任务单数],
    t1.FTotal5-t2.FUnNormal5 AS [5月特殊张数],
    t1.FTotalQty5-t2.FUnNormalFAuxQty5 AS [5月特殊数量],
    (t1.FTotal5-t2.FUnNormal5)*1.0/t1.FTotal5,
    t2.FUnNormal5,
    t2.FUnNormalFAuxQty5,
    t2.FUnNormal5*1.0/t1.FTotal5,
    --六月
    t1.FTotal6 AS [6月总任务单数],
    t1.FTotal6-t2.FUnNormal6 AS [6月特殊张数],
    t1.FTotalQty6-t2.FUnNormalFAuxQty6 AS [6月特殊数量],
    (t1.FTotal6-t2.FUnNormal6)*1.0/t1.FTotal6,
    t2.FUnNormal6,
    t2.FUnNormalFAuxQty6,
    t2.FUnNormal6*1.0/t1.FTotal6,
    --七月
    t1.FTotal7 AS [7月总任务单数],
    t1.FTotal7-t2.FUnNormal7 AS [7月特殊张数],
    t1.FTotalQty7-t2.FUnNormalFAuxQty7 AS [7月特殊数量],
    (t1.FTotal7-t2.FUnNormal7)*1.0/t1.FTotal7,
    t2.FUnNormal7,
    t2.FUnNormalFAuxQty7,
    t2.FUnNormal7*1.0/t1.FTotal7,
    --八月
    t1.FTotal8 AS [8月总任务单数],
    t1.FTotal8-t2.FUnNormal8 AS [8月特殊张数],
    t1.FTotalQty8-t2.FUnNormalFAuxQty8 AS [8月特殊数量],
    (t1.FTotal8-t2.FUnNormal8)*1.0/t1.FTotal8,
    t2.FUnNormal8,
    t2.FUnNormalFAuxQty8,
    t2.FUnNormal8*1.0/t1.FTotal8,
    --九月
    t1.FTotal9 AS [9月总任务单数],
    t1.FTotal9-t2.FUnNormal9 AS [9月特殊张数],
    t1.FTotalQty9-t2.FUnNormalFAuxQty9 AS [9月特殊数量],
    (t1.FTotal9-t2.FUnNormal9)*1.0/t1.FTotal9,
    t2.FUnNormal9,
    t2.FUnNormalFAuxQty9,
    t2.FUnNormal9*1.0/t1.FTotal9,
    --十月
    t1.FTotal10 AS [10月总任务单数],
    t1.FTotal10-t2.FUnNormal10 AS [10月特殊张数],
    t1.FTotalQty10-t2.FUnNormalFAuxQty10 AS [10月特殊数量],
    (t1.FTotal10-t2.FUnNormal10)*1.0/t1.FTotal10,
    t2.FUnNormal10,
    t2.FUnNormalFAuxQty10,
    t2.FUnNormal10*1.0/t1.FTotal10,
    --十一月
    t1.FTotal11 AS [11月总任务单数],
    t1.FTotal11-t2.FUnNormal11 AS [11月特殊张数],
    t1.FTotalQty11-t2.FUnNormalFAuxQty11 AS [11月特殊数量],
    (t1.FTotal11-t2.FUnNormal11)*1.0/t1.FTotal11,
    t2.FUnNormal11,
    t2.FUnNormalFAuxQty11,
    t2.FUnNormal11*1.0/t1.FTotal11,
    --十二月
    t1.FTotal12 AS [12月总任务单数],
    t1.FTotal12-t2.FUnNormal12 AS [12月特殊张数],
    t1.FTotalQty12-t2.FUnNormalFAuxQty12 AS [12月特殊数量],
    (t1.FTotal12-t2.FUnNormal12)*1.0/t1.FTotal12,
    t2.FUnNormal12,
    t2.FUnNormalFAuxQty12,
    t2.FUnNormal12*1.0/t1.FTotal12

FROM CTE_Total t1
LEFT JOIN CTE_UnNormal t2 ON t1.FDepartmentName=t2.FDepartmentName AND t1.FUserName=t2.FUserName