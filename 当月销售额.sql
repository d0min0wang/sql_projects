--DECLARE @Period char(6)
--SET @Period='201601' --ͳ�Ƶ�����


----ͳ�ƴ���
----DECLARE 
----	--@Last_Period char(6),
----	@Fyear char(4),
----	@FMonth char(2),
----	@FIndex int
----SELECT 
----	@FYear=year(getdate()),
----	@FMonth=month(getdate())

SELECT FDepartment AS ��ҵ��,--FBigTrade AS ��ҵ,
	--P_Money AS '�����۶�',
	--P_AuxQty AS '�������',
    P_Money AS '�������۶�'
    --P_AuxQty_1 AS '1�³�����',
    --P_AuxQty_2 AS '2�³�����',
    --P_AuxQty_3 AS '3�³�����',
    --P_AuxQty_4 AS '4�³�����',
    --P_AuxQty_5 AS '5�³�����',
    --P_AuxQty_6 AS '6�³�����',
    --P_AuxQty_7 AS '7�³�����',
    --P_AuxQty_8 AS '8�³�����',
    --P_AuxQty_9 AS '9�³�����',
    --P_AuxQty_10 AS '10�³�����',
    --P_AuxQty_11 AS '11�³�����',
    --P_AuxQty_12 AS '12�³�����'
FROM(
    SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '���۲��ϼ�' ELSE (v3.FName) END,
        --FBigTrade=CASE WHEN GROUPING(v5.FName)=1 THEN '<��ҵ���ϼ�>' ELSE (v5.FName) END,    
		P_Money=ISNULL(SUM(u1.FConsignAmount),0),
        P_AuxQty=ISNULL(SUM(u1.FAuxQty),0)
        --P_AuxQty_1=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_1 THEN u1.FAuxQty END),0),
        --P_AuxQty_2=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_2 THEN u1.FAuxQty END),0),
        --P_AuxQty_3=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_3 THEN u1.FAuxQty END),0),
        --P_AuxQty_4=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_4 THEN u1.FAuxQty END),0),
        --P_AuxQty_5=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_5 THEN u1.FAuxQty END),0),
        --P_AuxQty_6=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_6 THEN u1.FAuxQty END),0),
        --P_AuxQty_7=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_7 THEN u1.FAuxQty END),0),
        --P_AuxQty_8=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_8 THEN u1.FAuxQty END),0),
        --P_AuxQty_9=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_9 THEN u1.FAuxQty END),0),
        --P_AuxQty_10=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_10 THEN u1.FAuxQty END),0),
        --P_AuxQty_11=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_11 THEN u1.FAuxQty END),0),
        --P_AuxQty_12=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_12 THEN u1.FAuxQty END),0)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	--LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID
	--left join t_Item v5 ON v2.F_117=v5.FItemID
    WHERE v1.FTranType=21 And v1.FCheckerID>0 AND
		year(v1.FDate) =year(getdate())
		and month(v1.FDate)=month(getdate()) 
		--and v3.FName='����ñ��ҵ��'

    GROUP BY v3.FName  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FDepartment,P_Money DESC