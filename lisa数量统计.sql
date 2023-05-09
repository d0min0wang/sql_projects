;WITH CTE_Supply
AS
(
    --交易客户数
    SELECT t1.FDeptID,
        count(distinct t1.FSupplyID) AS FSupplyCount
    FROM ICStockBill t1 
    --INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
    LEFT JOIN t_Department t3 ON t1.FDeptID=t3.FItemID
    WHERE YEAR(t1.FDate) ='2023'
    and month(t1.FDate) <='4'
    AND (t1.FTranType=21 AND (t1.FCancellation = 0))
    GROUP BY t1.FDeptID
),
CTE_Price
AS
(
    --价格管理
    SELECT t3.fdepartment,
    COUNT(*) AS FPriceCount
    FROM vw_ICCtoIGroup t1
    INNER JOIN vw_ICPrcPly_CtoI t2 ON t1.FInterID=t2.FInterID AND t1.FID = t2.FID
    LEFT  JOIN t_Organization t3 ON t2.FRelatedID=t3.FItemID AND t3.FItemID<>0
    LEFT JOIN t_Department t4 ON t3.fdepartment=t4.FItemID
    WHERE 
    t2.FNumber='fangpu' 
    And t2.FPlyType='PrcAsm1' 
    And t1.FDetail<>0 AND t1.FClassTypeID=1007701 AND t1.FDiscontinued=0 
    and YEAR(t2.fcheckdate)='2023'
    AND MONTH(t2.fcheckdate)<='4'
    GROUP BY t3.fdepartment
),
CTE_NewSupply
AS
(
    --新增客户数
    select Fdepartment,
        COUNT(*) AS FNewSupply
    from t_Organization 
    where 
    year(F_123)='2023'
    and month(f_123) <='4'
    GROUP BY Fdepartment
),
CTE_NewItem
AS
(
    --新增规格数
    SELECT t1.FSource,
        count(*) AS fitemscount
    FROM t_ICItem t1
    LEFT JOIN t_BaseProperty t2 on	 t1.FItemID=t2.FItemID AND t2.FTypeID=3 
    left join t_Item t4 ON t1.FParentID=t4.FItemID
    left join t_Item t5 ON t4.FParentID=t5.FItemID
    left join t_Item t6 ON t5.FParentID=t6.FItemID
    LEFT JOIN t_Department t3 on t1.FSource=t3.FItemID
    WHERE YEAR(t2.FCreateDate)='2023'
    and month(t2.FCreateDate)<='4'
    --AND (t6.FNumber in ('90','91','92','93') OR t5.FNumber in ('90','91','92','93') OR t4.FNumber in ('90','91','92','93'))
    AND t3.FName IN ('电气连接国内事业部','电气连接事业部','医疗事业部','食品设备事业部','健康事业部','通信事业部','新能源事业部')
    group by t1.FSource
)

SELECT t1.fname,
    t2.FSupplyCount AS '交易客户数',
    t3.FPriceCount AS '单价K3录入条数',
    t4.fnewsupply AS '新增客户数', 
    t5.fitemscount AS  'K3规格新增数'
FROM t_Department t1
LEFT JOIN CTE_Supply t2 ON t1.fitemid=t2.FDeptID
LEFT JOIN CTE_Price t3 ON t1.fitemid=t3.fdepartment
LEFT JOIN CTE_NewSupply t4 on t1.fitemid=t4.fdepartment
LEFT JOIN CTE_NewItem t5 ON t1.fitemid=t5.FSource
WHERE t1.FName IN ('电气连接国内事业部','电气连接事业部','医疗事业部','食品设备事业部','健康事业部','通信事业部','新能源事业部')




