DECLARE @Period char(5)
SET @Period='2013' --ͳ�Ƶ����

--ͳ�ƴ���
DECLARE @Last_Period char(5)
SELECT  @Last_Period=CAST(CAST(@Period AS int)-1 as varchar)

SELECT FDepartment,FBigTrade,FTrade,
    C_Money AS C_Money,
    L_Money AS L_Money,
    CL_Money=C_Money-L_Money,
    CL_Money_Rate=CASE
            WHEN L_Money=0 THEN '----'
            ELSE SUBSTRING('������',CAST(SIGN(C_Money-L_Money) as int)+2,1)
                +CAST(CAST(ABS(C_Money-L_Money)*100/(CASE WHEN L_Money =0 THEN 1 ELSE L_Money END) as decimal(10,2)) as varchar)+'%'
        END,
--    P_Money AS �������۶�,
--    ���۶��=C_Money-P_Money,
--    ���۶�Ȱٷֱ�=CASE
--            WHEN P_Money=0 THEN '----'
----            ELSE SUBSTRING('������',CAST(SIGN(C_Money-P_Money) as int)+2,1)
--                +CAST(CAST(ABS(C_Money-P_Money)*100/P_Money as decimal(10,2)) as varchar)+'%'
--       END,
    C_AuxQty AS C_AuxQty,
    L_AuxQty AS L_AuxQty,
    CL_AuxQty=C_AuxQty-L_AuxQty,
    CL_AuxQty_Rate=CASE
            WHEN L_AuxQty=0 THEN '----'
            ELSE SUBSTRING('������',CAST(SIGN(C_AuxQty-L_AuxQty) as int)+2,1)
                +CAST(CAST(ABS(C_AuxQty-L_AuxQty)*100/(CASE WHEN L_AuxQty =0 THEN 1 ELSE L_AuxQty END) as decimal(10,2)) as varchar)+'%'
        END
 --   P_AuxQty AS ���ڳ�����,
--    ����������=C_AuxQty-P_AuxQty,
--    ���������Ȱٷֱ�=CASE
--            WHEN P_AuxQty=0 THEN '----'
--            ELSE SUBSTRING('������',CAST(SIGN(C_AuxQty-P_AuxQty) as int)+2,1)
--                +CAST(CAST(ABS(C_AuxQty-P_AuxQty)*100/P_AuxQty as decimal(10,2)) as varchar)+'%'
--        END
into #nianduduibi
FROM(
    SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<���۲��ϼ�>' ELSE (v3.FName) END,
        FBigTrade=CASE WHEN GROUPING(v2.F_118)=1 THEN '<��ҵ���ϼ�>' ELSE (v2.F_118) END,
		FTrade=convert(varchar(10),min(v2.F_117)),    
        C_Money=ISNULL(SUM(CASE CAST(DATEPART(year,v1.FDate) AS varchar) WHEN @Period THEN u1.FConsignAmount END),0),
        L_Money=ISNULL(SUM(CASE CAST(DATEPART(year,v1.FDate) AS varchar) WHEN @Last_Period THEN u1.FConsignAmount END),0),
--        P_Money=ISNULL(SUM(CASE CAST(DATEPART(year,v1.FDate) AS varchar) WHEN @Previous_Period THEN u1.FConsignAmount END),0),
        C_AuxQty=ISNULL(SUM(CASE CAST(DATEPART(year,v1.FDate) AS varchar) WHEN @Period THEN u1.FAuxQty END),0),
        L_AuxQty=ISNULL(SUM(CASE CAST(DATEPART(year,v1.FDate) AS varchar) WHEN @Last_Period THEN u1.FAuxQty END),0)
--        P_AuxQty=ISNULL(SUM(CASE CAST(DATEPART(year,v1.FDate) AS varchar)+CAST(DATEPART(quarter,v1.FDate) AS varchar) WHEN @Previous_Period THEN u1.FAuxQty END),0)

    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID

    WHERE v1.FTranType=21 

    GROUP BY v3.FName,v2.F_118  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FDepartment,a.C_Money DESC
	
	
   --SELECT   CAST(DATEPART(year,GETDATE()) AS varchar)+CAST(DATEPART(quarter,GETDATE()) AS varchar)
   --select CAST(DATEPART(year,v1.FDate) AS varchar)+CAST(DATEPART(quarter,v1.FDate) AS varchar)

select 
	t1.FDepartment AS ��ҵ��,
	t1.FBigTrade AS ������ҵ�ṹ,
	t2.FName AS ��ҵ,
    C_Money AS ����ͬ�����۶�,
    L_Money AS ȥ��ͬ�����۶�,
    CL_Money AS ���۶�ͬ��,
    CL_Money_Rate AS ���۶�ͬ�Ȱٷֱ�,
	C_AuxQty AS ����ͬ�ڳ�����,
    L_AuxQty AS ȥ��ͬ�ڳ�����,
    CL_AuxQty AS ������ͬ��,
    CL_AuxQty_Rate AS ������ͬ�Ȱٷֱ�
from #nianduduibi t1
left join t_Item t2 ON t1.FTrade=t2.FItemID

drop table #nianduduibi
