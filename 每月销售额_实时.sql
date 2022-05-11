
    SELECT rtrim(cast(month(v1.FDate) as char(10)))+'��' AS '�·�',
        --FBigTrade=CASE WHEN GROUPING(v5.FName)=1 THEN '<��ҵ���ϼ�>' ELSE (v5.FName) END,    
		ISNULL(SUM(u1.FConsignAmount),0) AS '���۲����۶�',
        ISNULL(SUM(CASE when v3.FName='��������ҵ��' THEN u1.FConsignAmount END),0) AS '���������۶�',
        ISNULL(SUM(CASE when v3.FName='����ñ��ҵ��' THEN u1.FConsignAmount END),0) AS '����ñ���۶�',
        ISNULL(SUM(CASE when v3.FName='�ְ�����ҵ��' THEN u1.FConsignAmount END),0) AS '�ְ������۶�',
        ISNULL(SUM(CASE when v3.FName='�ܼ���ҵ��' THEN u1.FConsignAmount END),0) AS '�ܼ����۶�'
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	--LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID
	--left join t_Item v5 ON v2.F_117=v5.FItemID
    WHERE v1.FTranType=21 And v1.FCheckerID>0 AND
		year(v1.FDate) ='2016'
		--and month(v1.FDate)<month(getdate()) 
		--and v3.FName='����ñ��ҵ��'

    GROUP BY month(v1.FDate)
	ORDER BY month(v1.FDate)













 