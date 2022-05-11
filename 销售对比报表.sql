TRUNCATE TABLE t_xy_EmpTable

CREATE TABLE t_xy_EmpTable(
    FEmpID INT,
    FEmpName nvarchar(10),
    FYear INT,
    FXS1 decimal(18,4),
    FXS2 decimal(18,4),
    FXS3 decimal(18,4),
    FXS4 decimal(18,4),
    FXS5 decimal(18,4),
    FXS6 decimal(18,4),
    FXS7 decimal(18,4),
    FXS8 decimal(18,4),
    FXS9 decimal(18,4),
    FXS10 decimal(18,4),
    FXS11 decimal(18,4),
    FXS12 decimal(18,4),
    FXSAll decimal(18,4))

INSERT into t_xy_EmpTable VALUES(20226,'刘嫦娟',2021,1960000,880000,1800000,1800000,1700000,1680000,1410000,1200000,1300000,1200000,1250000,1280000, 17460000)
INSERT into t_xy_EmpTable VALUES(34877,'李家明',2021,1130000,780000,1180000,1100000,1050000,1000000,980000,1140000,1170000,1060000,1050000,1100000,12740000)
INSERT into t_xy_EmpTable VALUES(36249,'梁静雯',2021,1450000,580000,1350000,1280000,1300000,1300000,970000,610000,530000,700000,850000,980000,11900000)
INSERT into t_xy_EmpTable VALUES(31018,'罗金华',2021,380000,130000,370000,380000,330000,320000,250000,260000,280000,320000,300000,320000,3640000)
INSERT into t_xy_EmpTable VALUES(37877,'朱锦梅',2021,880000,430000,800000,740000,720000,700000,640000,790000,820000,820000,950000,970000,9260000)

INSERT into t_xy_EmpTable VALUES(27765,'冯江毅',2021,700000,100000,250000,400000,400000,350000,350000,350000,450000,350000,400000,400000,4500000)
INSERT into t_xy_EmpTable VALUES(33038,'梁婉雯',2021,350000,100000,380000,360000,400000,400000,420000,400000,420000,320000,450000,500000,4500000)
INSERT into t_xy_EmpTable VALUES(39402,'吴培祥',2021,850000,250000,500000,680000,660000,680000,650000,700000,750000,700000,780000,800000,8000000)
INSERT into t_xy_EmpTable VALUES(43724,'汤智慧',2021,450000,140000,400000,400000,430000,400000,500000,480000,500000,400000,400000,500000,5000000)

INSERT into t_xy_EmpTable VALUES(207,'刘伙兰',2021,400000,200000,380000,400000,400000,360000,360000,380000,400000,400000,420000,450000,4550000)
INSERT into t_xy_EmpTable VALUES(21424,'朱明霞',2021,890000,300000,650000,600000,580000,530000,530000,530000,600000,580000,680000,730000,7200000)
INSERT into t_xy_EmpTable VALUES(49965,'吕俊杰',2021,280000,120000,240000,230000,230000,240000,250000,250000,260000,250000,260000,290000,2900000)
INSERT into t_xy_EmpTable VALUES(41859,'林劲',2021,600000,280000,450000,430000,400000,370000,360000,360000,380000,380000,420000,420000,4850000)

INSERT into t_xy_EmpTable VALUES(22099,'杨佳纯',2021,0,0,0,0,0,0,0,0,0,0,0,0,0)
INSERT into t_xy_EmpTable VALUES(133,'谭凯旋',2021,0,0,0,0,0,0,0,0,0,0,0,0,0)
INSERT into t_xy_EmpTable VALUES(45658,'龚春红',2021,0,0,0,0,0,0,0,0,0,0,0,0,0)
INSERT into t_xy_EmpTable VALUES(49120,'曾桓春',2021,0,0,0,0,0,0,0,0,0,0,0,0,0)

INSERT into t_xy_EmpTable VALUES(175,'陈晓林',2021,970000,200000,980000,1060000,1060000,1100000,1100000,1080000,1080000,1080000,1080000,1080000,11870000)
INSERT into t_xy_EmpTable VALUES(14904,'容少燕',2021,0,0,0,0,0,0,0,0,0,0,0,0,0)
INSERT into t_xy_EmpTable VALUES(46570,'李冬阳',2021,0,0,0,0,0,0,0,0,0,0,0,0,0)
INSERT into t_xy_EmpTable VALUES(47554,'云大明',2021,430000,100000,670000,640000,660000,620000,620000,690000,690000,720000,720000,870000,7430000)

INSERT into t_xy_EmpTable VALUES(19287,'梁邑全',2021,500000,160000,350000,360000,350000,390000,360000,370000,370000,390000,410000,390000,4400000)

INSERT into t_xy_EmpTable VALUES(10986,'蒙勇煊',2021,270000,150000,190000,190000,190000,250000,240000,240000,270000,270000,270000,270000,2800000)
INSERT into t_xy_EmpTable VALUES(41443,'侯登峰',2021,50000,50000,70000,90000,90000,90000,100000,110000,130000,140000,140000,140000,1200000)

--SELECT FItemID,* FROM t_Emp WHERE fname='侯登峰'

;WITH CTE_OutStock
AS
(
    select v1.FEmpID, 
       sum(case format(v1.FDate, 'MM') when '01' then u1.FAmount else 0 end) AS FAmount1,
       sum(case format(v1.FDate, 'MM') when '02' then u1.FAmount else 0 end) AS FAmount2,
       sum(case format(v1.FDate, 'MM') when '03' then u1.FAmount else 0 end) AS FAmount3,
       sum(case format(v1.FDate, 'MM') when '04' then u1.FAmount else 0 end) AS FAmount4,
       sum(case format(v1.FDate, 'MM') when '05' then u1.FAmount else 0 end) AS FAmount5,
       sum(case format(v1.FDate, 'MM') when '06' then u1.FAmount else 0 end) AS FAmount6,
       sum(case format(v1.FDate, 'MM') when '07' then u1.FAmount else 0 end) AS FAmount7,
       sum(case format(v1.FDate, 'MM') when '08' then u1.FAmount else 0 end) AS FAmount8,
       sum(case format(v1.FDate, 'MM') when '09' then u1.FAmount else 0 end) AS FAmount9,
       sum(case format(v1.FDate, 'MM') when '10' then u1.FAmount else 0 end) AS FAmount10,
       sum(case format(v1.FDate, 'MM') when '11' then u1.FAmount else 0 end) AS FAmount11,
       sum(case format(v1.FDate, 'MM') when 'All' then u1.FAmount else 0 end) AS FAmount12,
       sum(u1.FAmount) AS FAmountAll
    FROM ICStockBill v1 
    INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 
    where 1=1 
    AND      
    year(v1.Fdate) =  '2021' 
    AND (v1.FTranType=21 AND ((v1.FCheckerID>0)))
    GROUP BY v1.FEmpID
),
CTE_Receivable
AS
(
    SELECT t1.FEmployee AS FEmpID,
        sum(case format(t1.FDate, 'MM') when '01' then t1.FAmount else 0 end) AS FAmount1,
       sum(case format(t1.FDate, 'MM') when '02' then t1.FAmount else 0 end) AS FAmount2,
       sum(case format(t1.FDate, 'MM') when '03' then t1.FAmount else 0 end) AS FAmount3,
       sum(case format(t1.FDate, 'MM') when '04' then t1.FAmount else 0 end) AS FAmount4,
       sum(case format(t1.FDate, 'MM') when '05' then t1.FAmount else 0 end) AS FAmount5,
       sum(case format(t1.FDate, 'MM') when '06' then t1.FAmount else 0 end) AS FAmount6,
       sum(case format(t1.FDate, 'MM') when '07' then t1.FAmount else 0 end) AS FAmount7,
       sum(case format(t1.FDate, 'MM') when '08' then t1.FAmount else 0 end) AS FAmount8,
       sum(case format(t1.FDate, 'MM') when '09' then t1.FAmount else 0 end) AS FAmount9,
       sum(case format(t1.FDate, 'MM') when '10' then t1.FAmount else 0 end) AS FAmount10,
       sum(case format(t1.FDate, 'MM') when '11' then t1.FAmount else 0 end) AS FAmount11,
       sum(case format(t1.FDate, 'MM') when '12' then t1.FAmount else 0 end) AS FAmount12,
       sum(t1.FAmount) AS FAmountAll
    FROM t_RP_arpBill t1
    LEFT JOIN t_Item t2 ON t1.FBase=t2.FItemID
    WHERE t1.FClassTypeID=1000021 
    and
    t2.FName IN('单价调整','单据调整','税款差额','模具费','样品费')
    AND
    YEAR(t1.FDate)='2021'
    GROUP BY t1.FEmployee
)


SELECT t1.fempname AS 业务员,
    t1.FXS1 AS 一月份计划,
    t2.FAmount1 AS 一月份出库金额,
    t3.FAmount1 AS 一月份调整额,
    t2.FAmount1+t3.FAmount1 AS 一月份实绩销售额,
    CASE t1.fxs1 WHEN 0 THEN 0 ELSE (t2.FAmount1+t3.FAmount1)/t1.fxs1 end AS 一月份完成度,
    t1.FXS1-(t2.FAmount1+t3.FAmount1) AS 一月份差额,

    t1.FXS2 AS 二月份计划,
    t2.FAmount2 AS 二月份出库金额,
    t3.FAmount2 AS 二月份调整额,
    t2.FAmount2+t3.FAmount2 AS 二月份实绩销售额,
    CASE t1.fxs2 WHEN 0 THEN 0 ELSE (t2.FAmount2+t3.FAmount2)/t1.fxs2 end AS 二月份完成度,
    t1.FXS2-(t2.FAmount2+t3.FAmount2) AS 二月份差额,

    t1.FXS3 AS 三月份计划,
    t2.FAmount3 AS 三月份出库金额,
    t3.FAmount3 AS 三月份调整额,
    t2.FAmount3+t3.FAmount3 AS 三月份实绩销售额,
    CASE t1.fxs3 WHEN 0 THEN 0 ELSE (t2.FAmount3+t3.FAmount3)/t1.fxs3 end AS 三月份完成度,
    t1.FXS3-(t2.FAmount3+t3.FAmount3) AS 三月份差额,


    t1.FXS4 AS 四月份计划,
    t2.FAmount4 AS 四月份出库金额,
    t3.FAmount4 AS 四月份调整额,
    t2.FAmount4+t3.FAmount4 AS 四月份实绩销售额,
    CASE t1.fxs4 WHEN 0 THEN 0 ELSE (t2.FAmount4+t3.FAmount4)/t1.fxs4 end AS 四月份完成度,
    t1.FXS4-(t2.FAmount4+t3.FAmount4) AS 四月份差额,

    t1.FXS5 AS 五月份计划,
    t2.FAmount5 AS 五月份出库金额,
    t3.FAmount5 AS 五月份调整额,
    t2.FAmount5+t3.FAmount5 AS 五月份实绩销售额,
    CASE t1.fxs5 WHEN 0 THEN 0 ELSE (t2.FAmount5+t3.FAmount5)/t1.fxs5 end AS 五月份完成度,
    t1.FXS5-(t2.FAmount5+t3.FAmount5) AS 五月份差额,

    t1.FXS6 AS 六月份计划,
    t2.FAmount6 AS 六月份出库金额,
    t3.FAmount6 AS 六月份调整额,
    t2.FAmount6+t3.FAmount6 AS 六月份实绩销售额,
    CASE t1.fxs6 WHEN 0 THEN 0 ELSE (t2.FAmount6+t3.FAmount6)/t1.fxs6 end AS 六月份完成度,
    t1.FXS6-(t2.FAmount6+t3.FAmount6) AS 六月份差额,

    t1.FXS7 AS 七月份计划,
    t2.FAmount7 AS 七月份出库金额,
    t3.FAmount7 AS 七月份调整额,
    t2.FAmount7+t3.FAmount7 AS 七月份实绩销售额,
    CASE t1.fxs7 WHEN 0 THEN 0 ELSE (t2.FAmount7+t3.FAmount7)/t1.fxs7 end AS 七月份完成度,
    t1.FXS7-(t2.FAmount7+t3.FAmount7) AS 七月份差额,

    t1.FXS8 AS 八月份计划,
    t2.FAmount8 AS 八月份出库金额,
    t3.FAmount8 AS 八月份调整额,
    t2.FAmount8+t3.FAmount8 AS 八月份实绩销售额,
    CASE t1.fxs8 WHEN 0 THEN 0 ELSE (t2.FAmount8+t3.FAmount8)/t1.fxs8 end AS 八月份完成度,
    t1.FXS8-(t2.FAmount8+t3.FAmount8) AS 八月份差额,

    t1.FXS9 AS 九月份计划,
    t2.FAmount9 AS 九月份出库金额,
    t3.FAmount9 AS 九月份调整额,
    t2.FAmount9+t3.FAmount9 AS 九月份实绩销售额,
    CASE t1.fxs9 WHEN 0 THEN 0 ELSE (t2.FAmount9+t3.FAmount9)/t1.fxs9 end AS 九月份完成度,
    t1.FXS9-(t2.FAmount9+t3.FAmount9) AS 九月份差额,

    t1.FXS10 AS 十月份计划,
    t2.FAmount10 AS 十月份出库金额,
    t3.FAmount10 AS 十月份调整额,
    t2.FAmount10+t3.FAmount10 AS 十月份实绩销售额,
    CASE t1.fxs10 WHEN 0 THEN 0 ELSE (t2.FAmount10+t3.FAmount10)/t1.fxs10 end AS 十月份完成度,
    t1.FXS10-(t2.FAmount10+t3.FAmount10) AS 十月份差额,

    t1.FXS11 AS 十一月份计划,
    t2.FAmount11 AS 十一月份出库金额,
    t3.FAmount11 AS 十一月份调整额,
    t2.FAmount11+t3.FAmount11 AS 十一月份实绩销售额,
    CASE t1.fxs11 WHEN 0 THEN 0 ELSE (t2.FAmount11+t3.FAmount11)/t1.fxs11 end AS 十一月份完成度,
    t1.FXS11-(t2.FAmount11+t3.FAmount11) AS 十一月份差额,

    t1.FXS12 AS 十二月份计划,
    t2.FAmount12 AS 十二月份出库金额,
    t3.FAmount12 AS 十二月份调整额,
    t2.FAmount12+t3.FAmount12 AS 十二月份实绩销售额,
    CASE t1.fxs12 WHEN 0 THEN 0 ELSE (t2.FAmount12+t3.FAmount12)/t1.fxs12 end AS 十二月份完成度,
    t1.FXS12-(t2.FAmount12+t3.FAmount12) AS 十二月份差额,

    t1.FXSAll AS 年度计划,
    t2.FAmountAll AS 年度出库金额,
    t3.FAmountAll AS 年度调整额,
    t2.FAmountAll+t3.FAmountAll AS 年度实绩销售额,
    CASE t1.fxsAll WHEN 0 THEN 0 ELSE (t2.FAmountAll+t3.FAmountAll)/t1.fxsAll end AS 年度完成度,
    t1.FXSAll-(t2.FAmountAll+t3.FAmountAll) AS 年度差额
FROM t_xy_EmpTable t1
left JOIN CTE_OutStock t2 ON t1.FEmpID=t2.FEmpID
LEFT JOIN CTE_Receivable t3 ON t1.FEmpID=t3.FEmpID
WHERE t1.FYear=2021