DECLARE @FCreateDate NVARCHAR(4)
DECLARE @FCreateUser NVARCHAR(100)
DECLARE @FDepartment NVARCHAR(100)
DECLARE @FItemNumber NVARCHAR(100)

SET @FCreateDate='2023'
SET @fcreateuser=''
SET @FDepartment='电气连接事业部'
set @FItemNumber='90.A'

CREATE TABLE #t_XY_TempWuliaoHuiZong
(
    FItemID int Null,
    FNumber NVarchar(100),
    FEndCUUnitQty Decimal(28,10) Default(0)
)

INSERT into #t_XY_TempWuliaoHuiZong EXECUTE p_xy_All_1 @FCreateDate

;with cte_Items
AS
(
    select t1.FItemID
    --t3.fname,t1.fname,t1.FNumber,t2.FCreateDate,t2.fcreateuser 
    from t_ICItem t1
    LEFT JOIN t_BaseProperty t2 on	 t1.FItemID=t2.FItemID AND t2.FTypeID=3 
    LEFT JOIN t_Department t3 ON t1.FSource=t3.FItemID
    WHERE YEAR(t2.FCreateDate) in (@FCreateDate) 
    AND t3.fname=@FDepartment
    AND (CASE WHEN @FCreateUser='' THEN t2.FCreateUser ELSE @FCreateUser END=t2.FCreateUser)
    and isnull(t1.fnumber,'') like '%'+@FItemNumber+'%'
),
cte_Trade
as
(
    SELECT t0.FItemID,
        COUNT(distinct t2.FSupplyID) as FCountSupply,
        SUM(case when MONTH(t2.FDate)='1' then t1.FConsignAmount else 0 end) AS FAmount1,
        SUM(case when MONTH(t2.FDate)='2' then t1.FConsignAmount else 0 end) AS FAmount2,
        SUM(case when MONTH(t2.FDate)='3' then t1.FConsignAmount else 0 end) AS FAmount3,
        SUM(case when MONTH(t2.FDate)='4' then t1.FConsignAmount else 0 end) AS FAmount4,
        SUM(case when MONTH(t2.FDate)='5' then t1.FConsignAmount else 0 end) AS FAmount5,
        SUM(case when MONTH(t2.FDate)='6' then t1.FConsignAmount else 0 end) AS FAmount6,
        SUM(case when MONTH(t2.FDate)='7' then t1.FConsignAmount else 0 end) AS FAmount7,
        SUM(case when MONTH(t2.FDate)='8' then t1.FConsignAmount else 0 end) AS FAmount8,
        SUM(case when MONTH(t2.FDate)='9' then t1.FConsignAmount else 0 end) AS FAmount9,
        SUM(case when MONTH(t2.FDate)='10' then t1.FConsignAmount else 0 end) AS FAmount10,
        SUM(case when MONTH(t2.FDate)='11' then t1.FConsignAmount else 0 end) AS FAmount11,
        SUM(case when MONTH(t2.FDate)='12' then t1.FConsignAmount else 0 end) AS FAmount12
    FROM cte_items t0
    left join ICStockBillEntry t1 on t0.fitemid=t1.FItemID
    LEFT JOIN icstockbill t2 on t1.finterid=t2.finterid
    LEFT JOIN t_Organization t3 on t2.FSupplyID=t3.FItemID
    left JOIN t_Department t4 on t3.Fdepartment=t4.FItemID
    WHERE year(t2.FDate)=@FCreateDate
    AND t4.fname=@FDepartment
    and (t2.FTranType=21 AND (t2.FROB=1 AND  t2.FCancellation = 0))
    GROUP BY t0.FItemID
)
SELECT t4.fname,
    t5.FCreateUser,
    t5.FCreateDate,
    t3.FName,
    t3.FNumber,
    t1.FCountSupply,
    t1.FAmount1,
    t1.FAmount2,
    t1.FAmount3,
    t1.FAmount4,
    t1.FAmount5,
    t1.FAmount6,
    t1.FAmount7,
    t1.FAmount8,
    t1.FAmount9,
    t1.FAmount10,
    t1.FAmount11,
    t1.FAmount12,
    t1.FAmount1+t1.FAmount2+t1.FAmount3+t1.FAmount4+t1.FAmount5+t1.FAmount6+t1.FAmount7+t1.FAmount8+t1.FAmount9+t1.FAmount10+t1.FAmount11+t1.FAmount12 as FAmount,
    t2.FEndCUUnitQty 
FROM cte_Trade t1
LEFT JOIN #t_XY_TempWuliaoHuiZong t2 ON t1.FItemID=t2.FItemID
LEFT JOIN t_ICItem t3 on t1.fitemid=t3.fitemid
LEFT JOIN t_Department t4 ON t3.FSource=t4.FItemID
LEFT JOIN t_BaseProperty t5 on t3.FItemID=t5.FItemID AND t5.FTypeID=3 

drop table #t_XY_TempWuliaoHuiZong



