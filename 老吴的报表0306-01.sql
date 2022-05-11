--create table [t_xySaleReporttest](FDate Datetime,FDepartment nvarchar(200),FbigTrade nvarchar(200),FCustomer nvarchar(200),FQty decimal(18,4),FAmount decimal(18,4))

truncate table t_xySaleReporttest
--truncate table t_xySaleTongbi
insert into [t_xySaleReporttest](FDate,FDepartment,FbigTrade,FCustomer,FQty,FAmount)
select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
--SELECT v1.FSupplyID,v4.FShortNumber,v2.FNumber,v2.FName,
--	u1.FConsignPrice,
--	u1.FConsignAmount,
--		u1.FAuxQty,v3.FName,v2.F_110
		--,v2.F_111
--	,v5.FName AS FProdTrade,v4.FName AS FMidTrade,v3.FName AS FBigTrade 
FROM ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID
WHERE v1.FTranType=21 And v1.FDate BETWEEN '2009-01-01' AND '2010-04-30' 

select * from t_xySaleReporttest

DECLARE @Period char(6)
SET @Period='201002' --ͳ�Ƶ�����

--ͳ�ƴ���
DECLARE @Last_Period char(6),@Previous_Period char(6)
SELECT @Last_Period=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112),
 @Previous_Period=CONVERT(char(6),DATEADD(Month,-1,@Period+'01'),112)
SELECT FDepartment AS ����,FbigTrade AS ��ҵ,
    C_Money AS ����ͬ�����۶�,
    L_Money AS ȥ��ͬ�����۶�,
    ���۶�ͬ��=C_Money-L_Money,
    ���۶�ͬ�Ȱٷֱ�=CASE
            WHEN L_Money=0 THEN '----'
            ELSE SUBSTRING('������',CAST(SIGN(C_Money-L_Money) as int)+2,1)
                +CAST(CAST(ABS(C_Money-L_Money)*100/(CASE WHEN P_Money =0 THEN 1 ELSE P_Money END) as decimal(10,2)) as varchar)+'%'
        END,
    P_Money AS �������۶�,
    ���۶��=C_Money-P_Money,
    ���۶�Ȱٷֱ�=CASE
            WHEN P_Money=0 THEN '----'
            ELSE SUBSTRING('������',CAST(SIGN(C_Money-P_Money) as int)+2,1)
                +CAST(CAST(ABS(C_Money-P_Money)*100/P_Money as decimal(10,2)) as varchar)+'%'
        END
FROM(
    SELECT FDepartment=CASE WHEN GROUPING(FDepartment)=1 THEN '<Dept�ϼ�>' ELSE FDepartment END,
        FbigTrade=CASE WHEN GROUPING(FbigTrade)=1 THEN '<Trade�ϼ�>' ELSE FbigTrade END,    
        C_Money=ISNULL(SUM(CASE CONVERT(char(6),FDate,112) WHEN @Period THEN FAmount END),0),
        L_Money=ISNULL(SUM(CASE CONVERT(char(6),FDate,112) WHEN @Last_Period THEN FAmount END),0),
        P_Money=ISNULL(SUM(CASE CONVERT(char(6),FDate,112) WHEN @Previous_Period THEN FAmount END),0)
    FROM t_xySaleReporttest
    WHERE CONVERT(char(6),FDate,112) IN(@Last_Period,@Previous_Period,@Period)
    GROUP BY FDepartment,FbigTrade WITH ROLLUP
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a


