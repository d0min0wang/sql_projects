DECLARE @Period char(6)
SET @Period='201010' --ͳ�Ƶ�����


--ͳ�ƴ���
DECLARE 
	--@Last_Period char(6),
	@Previous_Period char(6),
	@Previous_Period_1 char(6),
	@Previous_Period_2 char(6)
SELECT 
	--@Last_Period=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112),
	@Previous_Period=CONVERT(char(6),DATEADD(Month,-1,@Period+'01'),112),
	@Previous_Period_1=CONVERT(char(6),DATEADD(Month,-2,@Period+'01'),112),
	@Previous_Period_2=CONVERT(char(6),DATEADD(Month,-3,@Period+'01'),112)
SELECT FDepartment AS ��ҵ��,FBigTrade AS ��ҵ,
    C_Money AS '11�����۶�',
    P_Money AS '10�����۶�',
    '11-10�����۶��'=C_Money-P_Money,
    '11-10�����۶�Ȱٷֱ�'=CASE
            WHEN P_Money=0 THEN '----'
            ELSE SUBSTRING('������',CAST(SIGN(C_Money-P_Money) as int)+2,1)
                +CAST(CAST(ABS(C_Money-P_Money)*100/P_Money as decimal(10,2)) as varchar)+'%'
        END,
    P_Money_1 AS '9�����۶�',
    '11-9�����۶��'=C_Money-P_Money_1,
    '11-9�����۶�Ȱٷֱ�'=CASE
            WHEN P_Money_1=0 THEN '----'
            ELSE SUBSTRING('������',CAST(SIGN(C_Money-P_Money_1) as int)+2,1)
                +CAST(CAST(ABS(C_Money-P_Money_1)*100/P_Money_1 as decimal(10,2)) as varchar)+'%'
        END,
    P_Money_2 AS '8�����۶�',
    '11-8�����۶��'=C_Money-P_Money_2,
    '11-8�����۶�Ȱٷֱ�'=CASE
            WHEN P_Money_2=0 THEN '----'
            ELSE SUBSTRING('������',CAST(SIGN(C_Money-P_Money_2) as int)+2,1)
                +CAST(CAST(ABS(C_Money-P_Money_2)*100/P_Money_2 as decimal(10,2)) as varchar)+'%'
        END,
    C_AuxQty AS '11�³�����',
    P_AuxQty AS '10�³�����',
    '11-10�³���������'=C_AuxQty-P_AuxQty,
    '11-10�³��������Ȱٷֱ�'=CASE
            WHEN P_AuxQty=0 THEN '----'
            ELSE SUBSTRING('������',CAST(SIGN(C_AuxQty-P_AuxQty) as int)+2,1)
                +CAST(CAST(ABS(C_AuxQty-P_AuxQty)*100/P_AuxQty as decimal(10,2)) as varchar)+'%'
        END,
    P_AuxQty_1 AS '9�³�����',
    '11-9�³���������'=C_AuxQty-P_AuxQty_1,
    '11-9�³��������Ȱٷֱ�'=CASE
            WHEN P_AuxQty_1=0 THEN '----'
            ELSE SUBSTRING('������',CAST(SIGN(C_AuxQty-P_AuxQty_1) as int)+2,1)
                +CAST(CAST(ABS(C_AuxQty-P_AuxQty_1)*100/P_AuxQty_1 as decimal(10,2)) as varchar)+'%'
        END,
    P_AuxQty_2 AS '8�³�����',
    '11-8�³���������'=C_AuxQty-P_AuxQty_2,
    '11-8�³��������Ȱٷֱ�'=CASE
            WHEN P_AuxQty_2=0 THEN '----'
            ELSE SUBSTRING('������',CAST(SIGN(C_AuxQty-P_AuxQty_2) as int)+2,1)
                +CAST(CAST(ABS(C_AuxQty-P_AuxQty_2)*100/P_AuxQty_2 as decimal(10,2)) as varchar)+'%'
        END
FROM(
    SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<���۲��ϼ�>' ELSE (v3.FName) END,
        FBigTrade=CASE WHEN GROUPING(v2.F_110)=1 THEN '<��ҵ���ϼ�>' ELSE (v2.F_110) END,    
        C_Money=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
        P_Money=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Previous_Period THEN u1.FConsignAmount END),0),
        P_Money_1=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Previous_Period_1 THEN u1.FConsignAmount END),0),
        P_Money_2=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Previous_Period_2 THEN u1.FConsignAmount END),0),
        C_AuxQty=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FAuxQty END),0),
        P_AuxQty=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Previous_Period THEN u1.FAuxQty END),0),
        P_AuxQty_1=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Previous_Period_1 THEN u1.FAuxQty END),0),
        P_AuxQty_2=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Previous_Period_2 THEN u1.FAuxQty END),0)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID

    WHERE v1.FTranType=21 And
		CONVERT(char(6),FDate,112) IN(@Previous_Period,@Previous_Period_1,@Previous_Period_2,@Period)

    GROUP BY v3.FName,v2.F_110  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FDepartment,a.C_Money DESC