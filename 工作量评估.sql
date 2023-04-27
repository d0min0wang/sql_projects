DECLARE @FDepartmentName NVARCHAR(50)

SET @FDepartmentName='医疗事业部'

SELECT * FROM
(
    --订单量
SELECT YEAR(t1.FDate) AS FYear,
        --t3.Fname AS FDepartmentName,
        '订单数量' AS FCatlog,
        count(*) AS FSEOrderCount,
        SUM(case when MONTH(t1.fdate)='1' then 1 END) AS FSEOrderCount1,
        SUM(case when MONTH(t1.fdate)='2' then 1 END) AS FSEOrderCount2,
        SUM(case when MONTH(t1.fdate)='3' then 1 END) AS FSEOrderCount3,
        SUM(case when MONTH(t1.fdate)='4' then 1 END) AS FSEOrderCount4,
        SUM(case when MONTH(t1.fdate)='5' then 1 END) AS FSEOrderCount5,
        SUM(case when MONTH(t1.fdate)='6' then 1 END) AS FSEOrderCount6,
        SUM(case when MONTH(t1.fdate)='7' then 1 END) AS FSEOrderCount7,
        SUM(case when MONTH(t1.fdate)='8' then 1 END) AS FSEOrderCount8,
        SUM(case when MONTH(t1.fdate)='9' then 1 END) AS FSEOrderCount9,
        SUM(case when MONTH(t1.fdate)='10' then 1 END) AS FSEOrderCount10,
        SUM(case when MONTH(t1.fdate)='11' then 1 END) AS FSEOrderCount11,
        SUM(case when MONTH(t1.fdate)='12' then 1 END) AS FSEOrderCount12
    FROM SEOrder t1
    --left join SEOrderEntry t2 on t1.FInterID=t2.FInterID
    LEFT JOIN t_Department t3 ON t1.FDeptID=t3.FItemID
    WHERE YEAR(t1.FDate) in ('2016','2017','2018','2019','2020','2021','2022','2023')
    AND (t1.FChangeMark=0 AND ( Isnull(t1.FClassTypeID,0)<>1007100) AND (t1.FCancellation = 0))
    AND t3.FName=@FDepartmentName
    GROUP BY YEAR(t1.FDate)--,t3.fname
UNION ALL
--订单量
SELECT YEAR(t1.FDate) AS FYear,
        --t3.Fname AS FDepartmentName,
        '订单分录数量' AS FCatlog,
        count(*) AS FSEOrderCount,
        SUM(case when MONTH(t1.fdate)='1' then 1 END) AS FSEOrderCount1,
        SUM(case when MONTH(t1.fdate)='2' then 1 END) AS FSEOrderCount2,
        SUM(case when MONTH(t1.fdate)='3' then 1 END) AS FSEOrderCount3,
        SUM(case when MONTH(t1.fdate)='4' then 1 END) AS FSEOrderCount4,
        SUM(case when MONTH(t1.fdate)='5' then 1 END) AS FSEOrderCount5,
        SUM(case when MONTH(t1.fdate)='6' then 1 END) AS FSEOrderCount6,
        SUM(case when MONTH(t1.fdate)='7' then 1 END) AS FSEOrderCount7,
        SUM(case when MONTH(t1.fdate)='8' then 1 END) AS FSEOrderCount8,
        SUM(case when MONTH(t1.fdate)='9' then 1 END) AS FSEOrderCount9,
        SUM(case when MONTH(t1.fdate)='10' then 1 END) AS FSEOrderCount10,
        SUM(case when MONTH(t1.fdate)='11' then 1 END) AS FSEOrderCount11,
        SUM(case when MONTH(t1.fdate)='12' then 1 END) AS FSEOrderCount12
    FROM SEOrder t1
    left join SEOrderEntry t2 on t1.FInterID=t2.FInterID
    LEFT JOIN t_Department t3 ON t1.FDeptID=t3.FItemID
    WHERE YEAR(t1.FDate) in ('2016','2017','2018','2019','2020','2021','2022','2023')
    AND (t1.FChangeMark=0 AND ( Isnull(t1.FClassTypeID,0)<>1007100) AND (t1.FCancellation = 0))
    AND t3.FName=@FDepartmentName
    GROUP BY YEAR(t1.FDate)--,t3.fname
UNION ALL
--订单销售额
SELECT YEAR(t1.FDate) AS FYear,
        --t3.Fname AS FDepartmentName,
        '订单销售额' AS FCatlog,
        sum(t2.FEntrySelfS0156) AS FSEOrderCount,
        SUM(case when MONTH(t1.fdate)='1' then t2.FEntrySelfS0156 else 0 END) AS FSEOrderCount1,
        SUM(case when MONTH(t1.fdate)='2' then t2.FEntrySelfS0156 else 0 END) AS FSEOrderCount2,
        SUM(case when MONTH(t1.fdate)='3' then t2.FEntrySelfS0156 else 0 END) AS FSEOrderCount3,
        SUM(case when MONTH(t1.fdate)='4' then t2.FEntrySelfS0156 else 0 END) AS FSEOrderCount4,
        SUM(case when MONTH(t1.fdate)='5' then t2.FEntrySelfS0156 else 0 END) AS FSEOrderCount5,
        SUM(case when MONTH(t1.fdate)='6' then t2.FEntrySelfS0156 else 0 END) AS FSEOrderCount6,
        SUM(case when MONTH(t1.fdate)='7' then t2.FEntrySelfS0156 else 0 END) AS FSEOrderCount7,
        SUM(case when MONTH(t1.fdate)='8' then t2.FEntrySelfS0156 else 0 END) AS FSEOrderCount8,
        SUM(case when MONTH(t1.fdate)='9' then t2.FEntrySelfS0156 else 0 END) AS FSEOrderCount9,
        SUM(case when MONTH(t1.fdate)='10' then t2.FEntrySelfS0156 else 0 END) AS FSEOrderCount10,
        SUM(case when MONTH(t1.fdate)='11' then t2.FEntrySelfS0156 else 0 END) AS FSEOrderCount11,
        SUM(case when MONTH(t1.fdate)='12' then t2.FEntrySelfS0156 else 0 END) AS FSEOrderCount12
    FROM SEOrder t1
    left join SEOrderEntry t2 on t1.FInterID=t2.FInterID
    LEFT JOIN t_Department t3 ON t1.FDeptID=t3.FItemID
    WHERE YEAR(t1.FDate) in ('2016','2017','2018','2019','2020','2021','2022','2023')
    AND (t1.FChangeMark=0 AND ( Isnull(t1.FClassTypeID,0)<>1007100) AND (t1.FCancellation = 0))
    AND t3.FName=@FDepartmentName
    GROUP BY YEAR(t1.FDate)--,t3.fname
UNION ALL
--规格数
SELECT YEAR(t1.FDate) AS FYear,
        --t3.Fname AS FDepartmentName,
        '规格数' AS FCatlog,
        count(DISTINCT t2.FItemID) AS FItemCount,
        count(DISTINCT(case when MONTH(t1.fdate)='1' then t2.FItemID else '' END))-1 AS FItemCount1,
        count(DISTINCT(case when MONTH(t1.fdate)='2' then t2.FItemID else '' END))-1 AS FItemCount2,
        count(DISTINCT(case when MONTH(t1.fdate)='3' then t2.FItemID else '' END))-1 AS FItemCount3,
        count(DISTINCT(case when MONTH(t1.fdate)='4' then t2.FItemID else '' END))-1 AS FItemCount4,
        count(DISTINCT(case when MONTH(t1.fdate)='5' then t2.FItemID else '' END))-1 AS FItemCount5,
        count(DISTINCT(case when MONTH(t1.fdate)='6' then t2.FItemID else '' END))-1 AS FItemCount6,
        count(DISTINCT(case when MONTH(t1.fdate)='7' then t2.FItemID else '' END))-1 AS FItemCount7,
        count(DISTINCT(case when MONTH(t1.fdate)='8' then t2.FItemID else '' END))-1 AS FItemCount8,
        count(DISTINCT(case when MONTH(t1.fdate)='9' then t2.FItemID else '' END))-1 AS FItemCount9,
        count(DISTINCT(case when MONTH(t1.fdate)='10' then t2.FItemID else '' END))-1 AS FItemCount10,
        count(DISTINCT(case when MONTH(t1.fdate)='11' then t2.FItemID else '' END))-1 AS FItemCount11,
        count(DISTINCT(case when MONTH(t1.fdate)='12' then t2.FItemID else '' END))-1 AS FItemCount12
    FROM SEOrder t1
    left join SEOrderEntry t2 on t1.FInterID=t2.FInterID
    LEFT JOIN t_Department t3 ON t1.FDeptID=t3.FItemID
    WHERE YEAR(t1.FDate) in ('2016','2017','2018','2019','2020','2021','2022','2023')
    AND (t1.FChangeMark=0 AND ( Isnull(t1.FClassTypeID,0)<>1007100) AND (t1.FCancellation = 0))
    AND t3.FName=@FDepartmentName
    GROUP BY YEAR(t1.FDate)--,t3.fname
)tt1 ORDER BY tt1.fyear,tt1.FCatlog 

SELECT * FROM
(
    --出库单分录量
    SELECT YEAR(t1.FDate) AS FYear,
        '出库单分录数量' AS FCatlog,
        count(*) AS FICStockBillCount,
        SUM(case when MONTH(t1.fdate)='1' then 1 END) AS FICStockBillCount1,
        SUM(case when MONTH(t1.fdate)='2' then 1 END) AS FICStockBillCount2,
        SUM(case when MONTH(t1.fdate)='3' then 1 END) AS FICStockBillCount3,
        SUM(case when MONTH(t1.fdate)='4' then 1 END) AS FICStockBillCount4,
        SUM(case when MONTH(t1.fdate)='5' then 1 END) AS FICStockBillCount5,
        SUM(case when MONTH(t1.fdate)='6' then 1 END) AS FICStockBillCount6,
        SUM(case when MONTH(t1.fdate)='7' then 1 END) AS FICStockBillCount7,
        SUM(case when MONTH(t1.fdate)='8' then 1 END) AS FICStockBillCount8,
        SUM(case when MONTH(t1.fdate)='9' then 1 END) AS FICStockBillCount9,
        SUM(case when MONTH(t1.fdate)='10' then 1 END) AS FICStockBillCount10,
        SUM(case when MONTH(t1.fdate)='11' then 1 END) AS FICStockBillCount11,
        SUM(case when MONTH(t1.fdate)='12' then 1 END) AS FICStockBillCount12
    FROM ICStockBill t1 
    --INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
    LEFT JOIN t_Department t3 ON t1.FDeptID=t3.FItemID
    WHERE YEAR(t1.FDate) in ('2016','2017','2018','2019','2020','2021','2022','2023')
    and t3.FName =@FDepartmentName
    AND (t1.FTranType=21 AND (t1.FCancellation = 0))
    GROUP BY YEAR(t1.FDate)
    UNION ALL
    --出库单分录量
    SELECT YEAR(t1.FDate) AS FYear,
        '出库单分录数量' AS FCatlog,
        count(*) AS FICStockBillCount,
        SUM(case when MONTH(t1.fdate)='1' then 1 END) AS FICStockBillCount1,
        SUM(case when MONTH(t1.fdate)='2' then 1 END) AS FICStockBillCount2,
        SUM(case when MONTH(t1.fdate)='3' then 1 END) AS FICStockBillCount3,
        SUM(case when MONTH(t1.fdate)='4' then 1 END) AS FICStockBillCount4,
        SUM(case when MONTH(t1.fdate)='5' then 1 END) AS FICStockBillCount5,
        SUM(case when MONTH(t1.fdate)='6' then 1 END) AS FICStockBillCount6,
        SUM(case when MONTH(t1.fdate)='7' then 1 END) AS FICStockBillCount7,
        SUM(case when MONTH(t1.fdate)='8' then 1 END) AS FICStockBillCount8,
        SUM(case when MONTH(t1.fdate)='9' then 1 END) AS FICStockBillCount9,
        SUM(case when MONTH(t1.fdate)='10' then 1 END) AS FICStockBillCount10,
        SUM(case when MONTH(t1.fdate)='11' then 1 END) AS FICStockBillCount11,
        SUM(case when MONTH(t1.fdate)='12' then 1 END) AS FICStockBillCount12
    FROM ICStockBill t1 
    INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
    LEFT JOIN t_Department t3 ON t1.FDeptID=t3.FItemID
    WHERE YEAR(t1.FDate) in ('2016','2017','2018','2019','2020','2021','2022','2023')
    and t3.FName =@FDepartmentName
    AND (t1.FTranType=21 AND (t1.FCancellation = 0))
    GROUP BY YEAR(t1.FDate)
    UNION ALL
    --出库单销售额
    SELECT YEAR(t1.FDate) AS FYear,
        '出库单销售额' AS FCatlog,
        sum(t2.FConsignAmount) AS FSEOrderCount,
        SUM(case when MONTH(t1.fdate)='1' then t2.FConsignAmount else 0 END) AS FSEOrderCount1,
        SUM(case when MONTH(t1.fdate)='2' then t2.FConsignAmount else 0 END) AS FSEOrderCount2,
        SUM(case when MONTH(t1.fdate)='3' then t2.FConsignAmount else 0 END) AS FSEOrderCount3,
        SUM(case when MONTH(t1.fdate)='4' then t2.FConsignAmount else 0 END) AS FSEOrderCount4,
        SUM(case when MONTH(t1.fdate)='5' then t2.FConsignAmount else 0 END) AS FSEOrderCount5,
        SUM(case when MONTH(t1.fdate)='6' then t2.FConsignAmount else 0 END) AS FSEOrderCount6,
        SUM(case when MONTH(t1.fdate)='7' then t2.FConsignAmount else 0 END) AS FSEOrderCount7,
        SUM(case when MONTH(t1.fdate)='8' then t2.FConsignAmount else 0 END) AS FSEOrderCount8,
        SUM(case when MONTH(t1.fdate)='9' then t2.FConsignAmount else 0 END) AS FSEOrderCount9,
        SUM(case when MONTH(t1.fdate)='10' then t2.FConsignAmount else 0 END) AS FSEOrderCount10,
        SUM(case when MONTH(t1.fdate)='11' then t2.FConsignAmount else 0 END) AS FSEOrderCount11,
        SUM(case when MONTH(t1.fdate)='12' then t2.FConsignAmount else 0 END) AS FSEOrderCount12
    FROM ICStockBill t1 
    INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
    LEFT JOIN t_Department t3 ON t1.FDeptID=t3.FItemID
    WHERE YEAR(t1.FDate) in ('2016','2017','2018','2019','2020','2021','2022','2023')
    and t3.FName =@FDepartmentName
    AND (t1.FTranType=21 AND (t1.FCancellation = 0))
    GROUP BY YEAR(t1.FDate)
    UNION ALL
    --出库单规格数
    SELECT YEAR(t1.FDate) AS FYear,
        '出库单规格数' AS FCatlog,
        count(DISTINCT t2.FItemID) AS FItemCount,
        count(DISTINCT(case when MONTH(t1.fdate)='1' then t2.FItemID else '' END))-1 AS FItemCount1,
        count(DISTINCT(case when MONTH(t1.fdate)='2' then t2.FItemID else '' END))-1 AS FItemCount2,
        count(DISTINCT(case when MONTH(t1.fdate)='3' then t2.FItemID else '' END))-1 AS FItemCount3,
        count(DISTINCT(case when MONTH(t1.fdate)='4' then t2.FItemID else '' END))-1 AS FItemCount4,
        count(DISTINCT(case when MONTH(t1.fdate)='5' then t2.FItemID else '' END))-1 AS FItemCount5,
        count(DISTINCT(case when MONTH(t1.fdate)='6' then t2.FItemID else '' END))-1 AS FItemCount6,
        count(DISTINCT(case when MONTH(t1.fdate)='7' then t2.FItemID else '' END))-1 AS FItemCount7,
        count(DISTINCT(case when MONTH(t1.fdate)='8' then t2.FItemID else '' END))-1 AS FItemCount8,
        count(DISTINCT(case when MONTH(t1.fdate)='9' then t2.FItemID else '' END))-1 AS FItemCount9,
        count(DISTINCT(case when MONTH(t1.fdate)='10' then t2.FItemID else '' END))-1 AS FItemCount10,
        count(DISTINCT(case when MONTH(t1.fdate)='11' then t2.FItemID else '' END))-1 AS FItemCount11,
        count(DISTINCT(case when MONTH(t1.fdate)='12' then t2.FItemID else '' END))-1 AS FItemCount12
    FROM ICStockBill t1 
    INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
    LEFT JOIN t_Department t3 ON t1.FDeptID=t3.FItemID
    WHERE YEAR(t1.FDate) in ('2016','2017','2018','2019','2020','2021','2022','2023')
    and t3.FName =@FDepartmentName
    AND (t1.FTranType=21 AND (t1.FCancellation = 0))
    GROUP BY YEAR(t1.FDate)
)tt1 ORDER BY tt1.FYear,tt1.FCatlog