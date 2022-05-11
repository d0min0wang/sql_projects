use AIS20140921170539
DECLARE @Period char(6)
SET @Period='201701' --ͳ�Ƶ�����


--ͳ�ƴ���
DECLARE 
	--@Last_Period char(6),
	@Period_1 char(6),
	@Period_2 char(6),
	@Period_3 char(6),
	@Period_4 char(6),
	@Period_5 char(6),
	@Period_6 char(6),
	@Period_7 char(6),
	@Period_8 char(6),
	@Period_9 char(6),
	@Period_10 char(6),
	@Period_11 char(6),
	@Period_12 char(6),
	@FMonth int,
	@FIndex int
SELECT 
	--@Last_Period=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112),
	@Period_1=@Period,
	@Period_2=CONVERT(char(6),DATEADD(Month,1,@Period+'01'),112),
	@Period_3=CONVERT(char(6),DATEADD(Month,2,@Period+'01'),112),
	@Period_4=CONVERT(char(6),DATEADD(Month,3,@Period+'01'),112),
	@Period_5=CONVERT(char(6),DATEADD(Month,4,@Period+'01'),112),
	@Period_6=CONVERT(char(6),DATEADD(Month,5,@Period+'01'),112),
	@Period_7=CONVERT(char(6),DATEADD(Month,6,@Period+'01'),112),
	@Period_8=CONVERT(char(6),DATEADD(Month,7,@Period+'01'),112),
	@Period_9=CONVERT(char(6),DATEADD(Month,8,@Period+'01'),112),
	@Period_10=CONVERT(char(6),DATEADD(Month,9,@Period+'01'),112),
	@Period_11=CONVERT(char(6),DATEADD(Month,10,@Period+'01'),112),
	@Period_12=CONVERT(char(6),DATEADD(Month,11,@Period+'01'),112)

SELECT FDepartment AS ��ҵ��,FBigTrade AS ��ҵ,
	P_Money AS '�����۶�',
	P_AuxQty AS '�������',
    P_Money_1 AS '1�����۶�',
    P_Money_2 AS '2�����۶�',
    P_Money_3 AS '3�����۶�',
    P_Money_4 AS '4�����۶�',
    P_Money_5 AS '5�����۶�',
    P_Money_6 AS '6�����۶�',
    P_Money_7 AS '7�����۶�',
    P_Money_8 AS '8�����۶�',
    P_Money_9 AS '9�����۶�',
    P_Money_10 AS '10�����۶�',
    P_Money_11 AS '11�����۶�',
    P_Money_12 AS '12�����۶�',
    P_AuxQty_1 AS '1�³�����',
    P_AuxQty_2 AS '2�³�����',
    P_AuxQty_3 AS '3�³�����',
    P_AuxQty_4 AS '4�³�����',
    P_AuxQty_5 AS '5�³�����',
    P_AuxQty_6 AS '6�³�����',
    P_AuxQty_7 AS '7�³�����',
    P_AuxQty_8 AS '8�³�����',
    P_AuxQty_9 AS '9�³�����',
    P_AuxQty_10 AS '10�³�����',
    P_AuxQty_11 AS '11�³�����',
    P_AuxQty_12 AS '12�³�����'
FROM(
    SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<���۲��ϼ�>' ELSE (v3.FName) END,
        FBigTrade=CASE WHEN GROUPING(v5.FName)=1 THEN '<��ҵ���ϼ�>' ELSE (v5.FName) END,    
		P_Money=ISNULL(SUM(u1.FConsignAmount),0),
        P_AuxQty=ISNULL(SUM(u1.FAuxQty),0),
        P_Money_1=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_1 THEN u1.FConsignAmount END),0),
        P_Money_2=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_2 THEN u1.FConsignAmount END),0),
        P_Money_3=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_3 THEN u1.FConsignAmount END),0),
        P_Money_4=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_4 THEN u1.FConsignAmount END),0),
        P_Money_5=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_5 THEN u1.FConsignAmount END),0),
        P_Money_6=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_6 THEN u1.FConsignAmount END),0),
        P_Money_7=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_7 THEN u1.FConsignAmount END),0),
        P_Money_8=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_8 THEN u1.FConsignAmount END),0),
        P_Money_9=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_9 THEN u1.FConsignAmount END),0),
        P_Money_10=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_10 THEN u1.FConsignAmount END),0),
        P_Money_11=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_11 THEN u1.FConsignAmount END),0),
        P_Money_12=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_12 THEN u1.FConsignAmount END),0),
        P_AuxQty_1=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_1 THEN u1.FAuxQty END),0),
        P_AuxQty_2=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_2 THEN u1.FAuxQty END),0),
        P_AuxQty_3=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_3 THEN u1.FAuxQty END),0),
        P_AuxQty_4=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_4 THEN u1.FAuxQty END),0),
        P_AuxQty_5=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_5 THEN u1.FAuxQty END),0),
        P_AuxQty_6=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_6 THEN u1.FAuxQty END),0),
        P_AuxQty_7=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_7 THEN u1.FAuxQty END),0),
        P_AuxQty_8=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_8 THEN u1.FAuxQty END),0),
        P_AuxQty_9=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_9 THEN u1.FAuxQty END),0),
        P_AuxQty_10=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_10 THEN u1.FAuxQty END),0),
        P_AuxQty_11=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_11 THEN u1.FAuxQty END),0),
        P_AuxQty_12=ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period_12 THEN u1.FAuxQty END),0)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID
	left join t_Item v5 ON v2.F_117=v5.FItemID
    WHERE v1.FTranType=21 And v1.FCheckerID>0 AND
		year(v1.FDate) =left(@Period,4)
		--and month(v1.FDate)<month(getdate()) 
		--and v3.FName='����ñ��ҵ��'

    GROUP BY v3.FName,v5.FName  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FDepartment,P_Money DESC
--
--select   RIGHT(CONVERT(char(6),getdate(),112),2)    
--select month(getdate())


--select * from t_Organization where FNumber='01.CZ.0001'
----F_123 �������� 

--��ҵ���۶�
select  v8.FName,
		v7.FName,
		v2.FProvince,
		v2.FName AS FName,
		v3.FName,
		v5.FName,
		v4.FName as FTradeName,
		t1.*
from
(
SELECT --v3.FName,
		--v5.FName,
		--v4.FName as FTradeName,
		--v2.FName AS FName,  
		v1.FSupplyID,  
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
--		[2009]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then u1.FConsignAmount END),0),
--		[2010]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then u1.FConsignAmount END),0),
		--[2014���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2014' then u1.FConsignAmount END),0),
		[2017���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2017' then u1.FConsignAmount END),0),
		[1�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '1' then u1.FConsignAmount END),0),
		[2�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '2' then u1.FConsignAmount END),0),
		[3�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '3' then u1.FConsignAmount END),0),
		[4�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '4' then u1.FConsignAmount END),0),
		[5�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '5' then u1.FConsignAmount END),0),
		[6�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '6' then u1.FConsignAmount END),0),
		[7�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '7' then u1.FConsignAmount END),0),
		[8�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '8' then u1.FConsignAmount END),0),
		[9�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '9' then u1.FConsignAmount END),0),
		[10�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '10' then u1.FConsignAmount END),0),
		[11�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '11' then u1.FConsignAmount END),0),
		[12�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FConsignAmount END),0),
		[2017������]=ISNULL(SUM(CASE year(v1.FDate) when '2017' then u1.FAuxQty END),0),
		[1�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '1' then u1.FAuxQty END),0),
		[2�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '2' then u1.FAuxQty END),0),
		[3�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '3' then u1.FAuxQty END),0),
		[4�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '4' then u1.FAuxQty END),0),
		[5�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '5' then u1.FAuxQty END),0),
		[6�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '6' then u1.FAuxQty END),0),
		[7�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '7' then u1.FAuxQty END),0),
		[8�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '8' then u1.FAuxQty END),0),
		[9�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '9' then u1.FAuxQty END),0),
		[10�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '10' then u1.FAuxQty END),0),
		[11�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '11' then u1.FAuxQty END),0),
		[12�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FAuxQty END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	where year(v1.FDate)IN ('2017') 
	--and month(v1.FDate)<='2'
	
	and v1.FTranType=21 
	group by v1.FSupplyID) t1

LEFT JOIN t_Organization v2 ON t1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
LEFT JOIN t_SubMessage v7 ON v2.FRegionID=v7.FInterID
LEFT JOIN t_Emp v8 ON v2.Femployee=v8.FItemID
where v3.FName='����ñ��ҵ��'
----where v4.FName='΢��¯'
order by [2017���۶�] desc



where year(v1.FDate)IN ('2014') 
and month(v1.FDate)<='12' 
and v1.FTranType=21 
--and v2.F_123>='2013-09-01' --�¿���
--and v3.FName='����ñ��ҵ��' --and v5.FName='������Ʒ' 
--and v4.FName IN ('ͨ���豸','����������','��Ƶ������','����','����\����','�������')

group by --v3.FName,v5.FName,
v4.FName,v2.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
with rollup
order by v4.FName,
[12] desc

FRegionID t_SubMessage
select * from t_Organization
select * from t_SubMessage where FName like '%����%'

--��ҵ���

DECLARE @Period char(4)
SET @Period='2011' --ͳ�Ƶ�����


--ͳ�ƴ���
DECLARE 
	--@Last_Period char(6),
	@Period_1 char(4),
	@Period_2 char(4),
	@Period_3 char(6),
	@Period_4 char(6),
	@Period_5 char(6),
	@Period_6 char(6),
	@Period_7 char(6),

	@FMonth int,
	@FIndex int
SELECT 
	--@Last_Period=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112),
	--@Period_1=@Period,
	@Period_2=CONVERT(char(4),DATEADD(Year,1,@Period),112),
	@Period_3=CONVERT(char(4),DATEADD(Year,2,@Period),112),
	@Period_4=CONVERT(char(4),DATEADD(Year,3,@Period),112),
	@Period_5=CONVERT(char(4),DATEADD(Year,4,@Period),112),
	@Period_6=CONVERT(char(4),DATEADD(Year,5,@Period),112),
	@Period_7=CONVERT(char(4),DATEADD(Year,6,@Period),112)
SELECT FDepartment AS ��ҵ��,FBigTrade AS ��ҵ,
	--P_Money AS '�����۶�',
	--P_AuxQty AS '�������',
	--P_Money_1 AS '2009���۶�',
    P_Money_2 AS '2012���۶�',
    P_Money_3 AS '2013���۶�',
    P_Money_4 AS '2014���۶�',
    P_Money_5 AS '2015���۶�',
    P_Money_6 AS '2016���۶�',
	P_Money_7 AS '2017���۶�',
	--P_AuxQty_1 AS '2009������',
    P_AuxQty_2 AS '2012������',
    P_AuxQty_3 AS '2013������',
    P_AuxQty_4 AS '2014������',
    P_AuxQty_5 AS '2015������',
    P_AuxQty_6 AS '2016������',
	P_AuxQty_7 AS '2017������'
FROM(
    SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<���۲��ϼ�>' ELSE (v3.FName) END,
        FBigTrade=CASE WHEN GROUPING(v5.FName)=1 THEN '<��ҵ���ϼ�>' ELSE (v5.FName) END,    
		--P_Money=ISNULL(SUM(u1.FConsignAmount),0),
        --P_AuxQty=ISNULL(SUM(u1.FAuxQty),0),
        P_Money_1=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_1 THEN v1.FConsignAmount END),0),
        P_Money_2=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_2 THEN v1.FConsignAmount END),0),
        P_Money_3=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_3 THEN v1.FConsignAmount END),0),
        P_Money_4=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_4 THEN v1.FConsignAmount END),0),
        P_Money_5=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_5 THEN v1.FConsignAmount END),0),
		P_Money_6=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_6 THEN v1.FConsignAmount END),0),
		P_Money_7=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_7 THEN v1.FConsignAmount END),0),
        P_AuxQty_1=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_1 THEN v1.FAuxQty END),0),
        P_AuxQty_2=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_2 THEN v1.FAuxQty END),0),
        P_AuxQty_3=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_3 THEN v1.FAuxQty END),0),
        P_AuxQty_4=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_4 THEN v1.FAuxQty END),0),
        P_AuxQty_5=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_5 THEN v1.FAuxQty END),0),
        P_AuxQty_6=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_6 THEN v1.FAuxQty END),0),
        P_AuxQty_7=ISNULL(SUM(CASE Year(v1.FDate) WHEN @Period_7 THEN v1.FAuxQty END),0)
   --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM (
	select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	from [AIS20130811090352].[dbo].ICStockBill t1 
	INNER JOIN [AIS20130811090352].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	where year(t1.FDate)<='2012'
	union all
	select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	from [AIS20140921170539].[dbo].ICStockBill t1 
	INNER JOIN [AIS20140921170539].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	where year(t1.FDate)>='2013') v1
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	--LEFT JOIN t_Item v4 ON v1.FItemID=v4.FItemID
	left join t_Item v5 ON v2.F_117=v5.FItemID
    WHERE v1.FTranType=21 And v1.FCheckerID>0 
	AND
		year(v1.FDate) >=@Period
		and month(v1.FDate)<='12'

    GROUP BY v3.FName,v5.FName  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FDepartment,P_Money_7 DESC
--     
--select   RIGHT(CONVERT(char(6),getdate(),112),2)    
--select month(getdate())


--��ҵ����

SELECT --v3.FName,
		--v5.FName,
		v4.FName as FTradeName,
		v2.FName AS FName,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
		--[2008���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FConsignAmount END),0),
		--[2009���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FConsignAmount END),0),
		--[2010���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then v1.FConsignAmount END),0),
		--[2011���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2011' then v1.FConsignAmount END),0),
		--[2012���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2012' then v1.FConsignAmount END),0),
		[2014���۶�]=ISNULL(SUM(CASE when year(v1.FDate) = '2014' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
		[2015���۶�]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
		[2016���۶�]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' AND Month(v1.FDate)<='12'  then v1.FConsignAmount END),0),
		--[2008������]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FAuxQty END),0),
		--[2009������]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FAuxQty END),0),
		--[2010������]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then v1.FAuxQty END),0),
		--[2011������]=ISNULL(SUM(CASE year(v1.FDate) when '2011' then v1.FAuxQty END),0),
		--[2012������]=ISNULL(SUM(CASE year(v1.FDate) when '2012' then v1.FAuxQty END),0),
		[2014������]=ISNULL(SUM(CASE when year(v1.FDate) = '2014' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
		[2015������]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0),
		[2016������]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' AND Month(v1.FDate)<='12'  then v1.FAuxQty END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM 
	(
	--select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	--from [AIS20130811090352].[dbo].ICStockBill t1 
	--INNER JOIN [AIS20130811090352].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	--where year(t1.FDate)<='2012' and t1.FTranType =21
	--union all
	select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	from [AIS20140921170539].[dbo].ICStockBill t1 
	INNER JOIN [AIS20140921170539].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	where year(t1.FDate)>='2013') v1
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
	LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
	LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
where --year(v1.FDate) <= '2013')
month(v1.FDate)<='12' 
and 
v1.FTranType=21 
And v1.FCheckerID>0 
and v3.FName='����ñ��ҵ��' --and v5.FName='������Ʒ' 
--and v4.FName IN ('ͨ���豸','����������','��Ƶ������','����','����\����','�������')

group by --v3.FName,v5.FName,
v4.FName,v2.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
with rollup
order by v4.FName,
[2016���۶�] desc


--��ҵ���갴ҵ��Ա��

SELECT v3.FName,
		--v5.FName,
		v4.FName as FTradeName,
		v7.FName AS FEmpName,
		v2.FName AS FName,
		max(v2.FProvince) AS FProvince,
		max(v2.FCity) AS FCity,
		max(v8.FName) AS FSettle,
		max(v2.F_101) AS F_101,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
		--[2008���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FConsignAmount END),0),
		--[2009���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FConsignAmount END),0),
		--[2010���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then v1.FConsignAmount END),0),
		--[2011���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2011' then v1.FConsignAmount END),0),
		--[2012���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2012' then v1.FConsignAmount END),0),
		[2014���۶�]=ISNULL(SUM(CASE when year(v1.FDate)= '2014' then v1.FConsignAmount END),0),
		[2015���۶�]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' then v1.FConsignAmount END),0),
		[2016���۶�]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' then v1.FConsignAmount END),0),
		[1�����۶�]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '1' then v1.FConsignAmount END),0),
		[2�����۶�]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '2' then v1.FConsignAmount END),0),
		[3�����۶�]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '3' then v1.FConsignAmount END),0),
		[4�����۶�]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '4' then v1.FConsignAmount END),0),
		[5�����۶�]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '5' then v1.FConsignAmount END),0),
		[6�����۶�]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '6' then v1.FConsignAmount END),0),
		--[7�����۶�]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '7' then v1.FConsignAmount END),0),
		--[8�����۶�]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '8' then v1.FConsignAmount END),0),
		--[9�����۶�]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '9' then v1.FConsignAmount END),0),
		--[10�����۶�]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '10' then v1.FConsignAmount END),0),
		--[11�����۶�]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '11' then v1.FConsignAmount END),0),
		--[12�����۶�]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '12' then v1.FConsignAmount END),0),
		--[2008������]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FAuxQty END),0),
		--[2009������]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FAuxQty END),0),
		--[2010������]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then v1.FAuxQty END),0),
		--[2011������]=ISNULL(SUM(CASE year(v1.FDate) when '2011' then v1.FAuxQty END),0),
		--[2012������]=ISNULL(SUM(CASE year(v1.FDate) when '2012' then v1.FAuxQty END),0),
		[2014������]=ISNULL(SUM(CASE when year(v1.FDate)= '2014'  then v1.FAuxQty END),0),
		[2015������]=ISNULL(SUM(CASE when year(v1.FDate) = '2015'  then v1.FAuxQty END),0),
		[2016������]=ISNULL(SUM(CASE when year(v1.FDate) = '2016'  then v1.FAuxQty END),0),
		[1�³�����]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '1' then v1.FAuxQty END),0),
		[2�³�����]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '2' then v1.FAuxQty END),0),
		[3�³�����]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '3' then v1.FAuxQty END),0),
		[4�³�����]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '4' then v1.FAuxQty END),0),
		[5�³�����]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '5' then v1.FAuxQty END),0),
		[6�³�����]=ISNULL(SUM(CASE when year(v1.FDate) = '2016' and month(v1.FDate)= '6' then v1.FAuxQty END),0)
		--[7�³�����]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '7' then v1.FAuxQty END),0),
		--[8�³�����]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '8' then v1.FAuxQty END),0),
		--[9�³�����]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '9' then v1.FAuxQty END),0),
		--[10�³�����]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '10' then v1.FAuxQty END),0),
		--[11�³�����]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '11' then v1.FAuxQty END),0),
		--[12�³�����]=ISNULL(SUM(CASE when year(v1.FDate) = '2015' and month(v1.FDate)= '12' then v1.FAuxQty END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM 
	(
	--select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	--from [AIS20130811090352].[dbo].ICStockBill t1 
	--INNER JOIN [AIS20130811090352].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	--where year(t1.FDate)<='2012'
	--union all
	select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	from ICStockBill t1 
	INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	where year(t1.FDate)>='2013' and month(t1.FDate)<='6')  v1
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
	LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
	LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
	LEFT JOIN t_Emp v7 ON v2.Femployee=v7.FItemID
	left join t_settle v8 on v2.fsetid=v8.fitemid
where --year(v1.FDate) <= '2013')
--and month(v1.FDate)<='11' 
--and 
v1.FTranType=21 
And v1.FCheckerID>0 
and v3.FName='��������ҵ��' --and v5.FName='������Ʒ' 
----and v4.FName IN ('ͨ���豸','����������','��Ƶ������','����','����\����','�������')
--and v7.FName='����ϼ'
--and [2014���۶�]<>0
group by v3.FName,--v5.FName,
v4.FName,v7.FName,v2.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
with rollup
order by v4.FName,v7.FName,
[2016���۶�] desc

--select t2.FName,t1.* from t_Organization t1
--left join t_Emp t2 on t1.Femployee=t2.FItemID

--��ҵ����

DECLARE @Period char(4)
SET @Period='2009' --ͳ�Ƶ�����


--ͳ�ƴ���
DECLARE 
	--@Last_Period char(6),
	@Period_1 char(4),
	@Period_2 char(4),
	@Period_3 char(6),
	@Period_4 char(6),
	@Period_5 char(6),
	@Period_6 char(6),
	@Period_7 char(6),

	@FMonth int,
	@FIndex int
SELECT 
	--@Last_Period=CONVERT(char(6),DATEADD(Year,-1,@Period+'01'),112),
	--@Period_1=@Period,
	--@Period_2=CONVERT(char(4),DATEADD(Year,1,@Period),112),
	--@Period_3=CONVERT(char(4),DATEADD(Year,2,@Period),112),
	--@Period_4=CONVERT(char(4),DATEADD(Year,3,@Period),112),
	@Period_5=CONVERT(char(4),DATEADD(Year,5,@Period),112),
	@Period_6=CONVERT(char(4),DATEADD(Year,6,@Period),112),
	@Period_7=CONVERT(char(4),DATEADD(Year,7,@Period),112)
SELECT FDepartment AS ��ҵ��,FBigTrade AS ��ҵ,
	--P_Money AS '�����۶�',
	--P_AuxQty AS '�������',
	--P_Money_1 AS '2008���۶�',
 --   P_Money_2 AS '2009���۶�',
 --   P_Money_3 AS '2010���۶�',
 --   P_Money_4 AS '2011���۶�',
    P_Money_5 AS '2014���۶�',
    P_Money_6 AS '2015���۶�',
	P_Money_7 AS '2016���۶�',
	--P_AuxQty_1 AS '2008������',
 --   P_AuxQty_2 AS '2009������',
 --   P_AuxQty_3 AS '2010������',
 --   P_AuxQty_4 AS '2011������',
    P_AuxQty_5 AS '2014������',
    P_AuxQty_6 AS '2015������',
	P_AuxQty_7 AS '2016������'
FROM(
    SELECT FDepartment=CASE WHEN GROUPING(v3.FName)=1 THEN '<���۲��ϼ�>' ELSE (v3.FName) END,
        FBigTrade=CASE WHEN GROUPING(v5.FName)=1 THEN '<��ҵ���ϼ�>' ELSE (v5.FName) END,    
		--P_Money=ISNULL(SUM(u1.FConsignAmount),0),
        --P_AuxQty=ISNULL(SUM(u1.FAuxQty),0),
        P_Money_1=ISNULL(SUM(CASE WHEN Year(v1.FDate)=@Period_1 AND Month(v1.FDate)<='6' THEN v1.FConsignAmount END),0),
        P_Money_2=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_2 AND Month(v1.FDate)<='6' THEN v1.FConsignAmount END),0),
        P_Money_3=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_3 AND Month(v1.FDate)<='6' THEN v1.FConsignAmount END),0),
        P_Money_4=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_4 AND Month(v1.FDate)<='6' THEN v1.FConsignAmount END),0),
        P_Money_5=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_5 AND Month(v1.FDate)<='6' THEN v1.FConsignAmount END),0),
		P_Money_6=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_6 AND Month(v1.FDate)<='6' THEN v1.FConsignAmount END),0),
		P_Money_7=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_7 AND Month(v1.FDate)<='6' THEN v1.FConsignAmount END),0),
        P_AuxQty_1=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_1 AND Month(v1.FDate)<='6' THEN v1.FAuxQty END),0),
        P_AuxQty_2=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_2 AND Month(v1.FDate)<='6' THEN v1.FAuxQty END),0),
        P_AuxQty_3=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_3 AND Month(v1.FDate)<='6' THEN v1.FAuxQty END),0),
        P_AuxQty_4=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_4 AND Month(v1.FDate)<='6' THEN v1.FAuxQty END),0),
        P_AuxQty_5=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_5 AND Month(v1.FDate)<='6' THEN v1.FAuxQty END),0),
        P_AuxQty_6=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_6 AND Month(v1.FDate)<='6' THEN v1.FAuxQty END),0),
        P_AuxQty_7=ISNULL(SUM(CASE WHEN Year(v1.FDate) = @Period_7 AND Month(v1.FDate)<='6' THEN v1.FAuxQty END),0)
   FROM 
   (
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
 --   FROM (select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	--from [AIS20131027152019].[dbo].ICStockBill t1 
	--INNER JOIN [AIS20131027152019].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	--where year(t1.FDate)<='2012'
	--union all
	select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	from ICStockBill t1 
	INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	where year(t1.FDate)>='2013') v1
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	--LEFT JOIN t_Item v4 ON v1.FItemID=v4.FItemID
	left join t_Item v5 ON v2.F_117=v5.FItemID
    WHERE v1.FTranType=21 And v1.FCheckerID>0 
	AND
		year(v1.FDate) >=@Period
		and month(v1.FDate)<=month(getdate()) 

    GROUP BY v3.FName,v5.FName  WITH ROLLUP	
	--ORDER BY u1.FConsignAmount
    --HAVING GROUPING(FDepartment)=0 AND GROUPING(FbigTrade)=0 
    )a
    ORDER BY a.FDepartment,P_Money_7 DESC
--     
--select   RIGHT(CONVERT(char(6),getdate(),112),2)    
--select month(getdate())

--��ҵ������
select v7.FName,
		v2.FProvince,
		v2.FName AS FName,
		v3.FName,
		v5.FName,
		v4.FName as FTradeName,
		t1.*
from
(
SELECT --v3.FName,
		--v5.FName,
		--v4.FName as FTradeName,
		--v2.FName AS FName,  
		v1.FSupplyID,  
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
--		[2009]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then u1.FConsignAmount END),0),
--		[2010]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then u1.FConsignAmount END),0),
		[2013]=ISNULL(SUM(CASE year(v1.FDate) when '2013' then u1.FAuxQty END),0),
		[1]=ISNULL(SUM(CASE month(v1.FDate) when '1' then u1.FAuxQty END),0),
		[2]=ISNULL(SUM(CASE month(v1.FDate) when '2' then u1.FAuxQty END),0),
		[3]=ISNULL(SUM(CASE month(v1.FDate) when '3' then u1.FAuxQty END),0),
		[4]=ISNULL(SUM(CASE month(v1.FDate) when '4' then u1.FAuxQty END),0),
		[5]=ISNULL(SUM(CASE month(v1.FDate) when '5' then u1.FAuxQty END),0),
		[6]=ISNULL(SUM(CASE month(v1.FDate) when '6' then u1.FAuxQty END),0),
		[7]=ISNULL(SUM(CASE month(v1.FDate) when '7' then u1.FAuxQty END),0),
		[8]=ISNULL(SUM(CASE month(v1.FDate) when '8' then u1.FAuxQty END),0),
		[9]=ISNULL(SUM(CASE month(v1.FDate) when '9' then u1.FAuxQty END),0),
		[10]=ISNULL(SUM(CASE month(v1.FDate) when '10' then u1.FAuxQty END),0),
		[11]=ISNULL(SUM(CASE month(v1.FDate) when '11' then u1.FAuxQty END),0),
		[12]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FAuxQty END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	where year(v1.FDate)IN ('2013') 
	--and month(v1.FDate)<='6'
	
	and v1.FTranType=21 
	group by v1.FSupplyID) t1

LEFT JOIN t_Organization v2 ON t1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
LEFT JOIN t_SubMessage v7 ON v2.FRegionID=v7.FInterID

--where v3.FName='����ñ��ҵ��'
where v4.FName='΢��¯'
order by [2013] desc


--select * from  t_Organization

--��ҵÿ�°�ҵ��Ա��

SELECT v3.FName,
		--v5.FName,
		v4.FName as FTradeName,
		v7.FName AS FEmpName,
		v2.FName AS FName,
		max(v2.FProvince) AS FProvince,
		max(v2.FCity) AS FCity,
		max(v8.FName) AS FSettle,
		max(v2.F_101) AS F_101,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
		--[2008���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FConsignAmount END),0),
		--[2009���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FConsignAmount END),0),
		--[2010���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then v1.FConsignAmount END),0),
		--[2011���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2011' then v1.FConsignAmount END),0),
		--[2012���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2012' then v1.FConsignAmount END),0),
		[2015���۶�]=ISNULL(SUM(CASE when year(v1.FDate)= '2015' then v1.FConsignAmount END),0),
		[1�����۶�]=ISNULL(SUM(CASE when month(v1.FDate) = '1' then v1.FConsignAmount END),0),
		[2�����۶�]=ISNULL(SUM(CASE when month(v1.FDate) = '2' then v1.FConsignAmount END),0),
		[3�����۶�]=ISNULL(SUM(CASE when month(v1.FDate) = '3' then v1.FConsignAmount END),0),
		[4�����۶�]=ISNULL(SUM(CASE when month(v1.FDate) = '4' then v1.FConsignAmount END),0),
		[5�����۶�]=ISNULL(SUM(CASE when month(v1.FDate) = '5' then v1.FConsignAmount END),0),
		[6�����۶�]=ISNULL(SUM(CASE when month(v1.FDate) = '6' then v1.FConsignAmount END),0),
		[7�����۶�]=ISNULL(SUM(CASE when month(v1.FDate) = '7' then v1.FConsignAmount END),0),
		[8�����۶�]=ISNULL(SUM(CASE when month(v1.FDate) = '8' then v1.FConsignAmount END),0),
		[9�����۶�]=ISNULL(SUM(CASE when month(v1.FDate) = '9' then v1.FConsignAmount END),0),
		[10�����۶�]=ISNULL(SUM(CASE when month(v1.FDate) = '10' then v1.FConsignAmount END),0),
		[11�����۶�]=ISNULL(SUM(CASE when month(v1.FDate) = '11' then v1.FConsignAmount END),0),
		[12�����۶�]=ISNULL(SUM(CASE when month(v1.FDate) = '12' then v1.FConsignAmount END),0),
		--[2008������]=ISNULL(SUM(CASE year(v1.FDate) when '2008' then v1.FAuxQty END),0),
		--[2009������]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then v1.FAuxQty END),0),
		--[2010������]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then v1.FAuxQty END),0),
		--[2011������]=ISNULL(SUM(CASE year(v1.FDate) when '2011' then v1.FAuxQty END),0),
		--[2012������]=ISNULL(SUM(CASE year(v1.FDate) when '2012' then v1.FAuxQty END),0),
		[2015������]=ISNULL(SUM(CASE when year(v1.FDate)= '2015'  then v1.FAuxQty END),0),
		[1�³�����]=ISNULL(SUM(CASE when month(v1.FDate) = '1'  then v1.FAuxQty END),0),
		[2�³�����]=ISNULL(SUM(CASE when month(v1.FDate) = '2'  then v1.FAuxQty END),0),
		[3�³�����]=ISNULL(SUM(CASE when month(v1.FDate) = '3'  then v1.FAuxQty END),0),
		[4�³�����]=ISNULL(SUM(CASE when month(v1.FDate) = '4'  then v1.FAuxQty END),0),
		[5�³�����]=ISNULL(SUM(CASE when month(v1.FDate) = '5'  then v1.FAuxQty END),0),
		[6�³�����]=ISNULL(SUM(CASE when month(v1.FDate) = '6'  then v1.FAuxQty END),0),
		[7�³�����]=ISNULL(SUM(CASE when month(v1.FDate) = '7'  then v1.FAuxQty END),0),
		[8�³�����]=ISNULL(SUM(CASE when month(v1.FDate) = '8'  then v1.FAuxQty END),0),
		[9�³�����]=ISNULL(SUM(CASE when month(v1.FDate) = '9'  then v1.FAuxQty END),0),
		[10�³�����]=ISNULL(SUM(CASE when month(v1.FDate) = '10'  then v1.FAuxQty END),0),
		[11�³�����]=ISNULL(SUM(CASE when month(v1.FDate) = '11'  then v1.FAuxQty END),0),
		[12�³�����]=ISNULL(SUM(CASE when month(v1.FDate) = '12'  then v1.FAuxQty END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM 
	(
	--select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	--from [AIS20130811090352].[dbo].ICStockBill t1 
	--INNER JOIN [AIS20130811090352].[dbo].ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	--where year(t1.FDate)<='2012'
	--union all
	select t1.FSupplyID,t1.FDate,t2.FConsignAmount,t2.FAuxQty,t1.FTranType,t1.FCheckerID 
	from ICStockBill t1 
	INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
	where year(t1.FDate)>='2015' and month(t1.FDate)<='12')  v1
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
	LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
	LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
	LEFT JOIN t_Emp v7 ON v2.Femployee=v7.FItemID
	left join t_settle v8 on v2.fsetid=v8.fitemid
where --year(v1.FDate) <= '2013')
--and month(v1.FDate)<='11' 
--and 
v1.FTranType=21 
And v1.FCheckerID>0 
and v3.FName='��������ҵ��' --and v5.FName='������Ʒ' 
----and v4.FName IN ('ͨ���豸','����������','��Ƶ������','����','����\����','�������')
--and v7.FName='����ϼ'
--and [2014���۶�]<>0
group by v3.FName,--v5.FName,
v7.FName,v4.FName,v2.FName--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
with rollup
order by v7.FName,v4.FName,
[2015���۶�] desc




--�����½��׿ͻ�



SELECT top 20 * FROM
(select tt3.FName AS ����,
	tt5.FName AS ��ҵ, 
	tt2.FName AS �ͻ�����,
	CASE tt2.FComboBox 
		WHEN '00' THEN '��������'
		WHEN '01' THEN 'չ��'
		WHEN '02' THEN '�ͻ�����'
		WHEN '03' THEN '��־'
		WHEN '04' THEN '�ֳ���Ϣ'
		WHEN '05' THEN '����Ͱ�'
		WHEN '06' THEN '��˾��վ'
		ELSE ''
	END
	AS ��Դ,
	tt2.FContact AS ��ϵ��,
	tt2.FPhone AS �绰,
	tt2.FFax AS ����,
	tt2.FAddress AS ��ַ,
	tt2.F_101 AS �ͻ�����,
	tt1.FMinDate AS �״ν�������,
	tt1.FMaxDate AS ���������,
	tt1.FConsignAmount AS ���,
	tt1.FAuxQtySum AS ������,
	tt1.FAuxQtyCount AS ��������,
	tt1.FAuxQtySum/tt1.FAuxQtyCount  AS ƽ��������,
	tt1.FAuxQtyMax AS ������������,
	tt1.FAuxQtyMin AS ������С������
 from
(select t1.FSupplyID as FSupplyID,
	sum(t2.FConsignAmount) AS FConsignAmount,
	sum(t2.FAuxQty) AS FAuxQtySum,
	count(t2.FAuxQty) AS FAuxQtyCount,
	max(t2.FAuxQty) AS FAuxQtyMax,
	min(t2.FAuxQty) AS FAuxQtyMin,
	min(t1.FDate) AS FMinDate,
	max(t1.FDate) AS FMaxDate
from ICStockBill t1 
INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
where --year(t1.FDate)='2016'
t1.FTranType=21 
And t1.FCheckerID>0 
group by t1.FSupplyID )tt1
LEFT JOIN t_Organization tt2 ON tt1.FSupplyID=tt2.FItemID
LEFT JOIN t_Item tt3 ON tt2.Fdepartment=tt3.FItemID
LEFT JOIN t_Item tt4 ON tt2.F_122=tt4.FItemID
LEFT JOIN t_Item tt5 ON tt2.F_117=tt5.FItemID
where year(tt1.FMaxDate)='2016'
and tt2.F_101='C'
)table1
  ORDER BY NEWID()


order by tt3.FName,tt2.F_101,tt1.FConsignAmount DESC



--���������ͻ�
select tt3.FName AS ����,
	tt5.FName AS ��ҵ, 
	tt2.FName AS �ͻ�����,
	CASE tt2.FComboBox 
		WHEN '00' THEN '��������'
		WHEN '01' THEN 'չ��'
		WHEN '02' THEN '�ͻ�����'
		WHEN '03' THEN '��־'
		WHEN '04' THEN '�ֳ���Ϣ'
		WHEN '05' THEN '����Ͱ�'
		WHEN '06' THEN '��˾��վ'
		ELSE ''
	END
	AS ��Դ,
	tt2.FContact AS ��ϵ��,
	tt2.FPhone AS �绰,
	tt2.FFax AS ����,
	tt2.FAddress AS ��ַ,
	tt2.F_101 AS �ͻ�����,
	tt2.F_123 AS ��������,
	tt1.FConsignAmount AS ���,
	tt1.FAuxQtySum AS ������,
	tt1.FAuxQtyCount AS ��������,
	tt1.FAuxQtySum/tt1.FAuxQtyCount  AS ƽ��������,
	tt1.FAuxQtyMax AS ������������,
	tt1.FAuxQtyMin AS ������С������
 from
(select t1.FSupplyID as FSupplyID,
	sum(t2.FConsignAmount) AS FConsignAmount,
	sum(t2.FAuxQty) AS FAuxQtySum,
	count(t2.FAuxQty) AS FAuxQtyCount,
	max(t2.FAuxQty) AS FAuxQtyMax,
	min(t2.FAuxQty) AS FAuxQtyMin,
	min(t1.FDate) AS FMinDate
from ICStockBill t1 
INNER JOIN ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
where 
year(t1.FDate)='2017'
and
month(t1.fdate)='11'
and
t1.FTranType=21 
And t1.FCheckerID>0 
group by t1.FSupplyID )tt1
LEFT JOIN t_Organization tt2 ON tt1.FSupplyID=tt2.FItemID
LEFT JOIN t_Item tt3 ON tt2.Fdepartment=tt3.FItemID
LEFT JOIN t_Item tt4 ON tt2.F_122=tt4.FItemID
LEFT JOIN t_Item tt5 ON tt2.F_117=tt5.FItemID
where --year(tt1.FMinDate)='2015'
year(tt2.F_123)='2017'
and
month(tt2.F_123)<='11'
order by tt3.FName,tt2.F_101,tt1.FConsignAmount DESC

--�ͻ���Դ��FCombobox
--00	��������
--01	չ��
--02	�ͻ�����
--03	��־
--04	�ֳ���Ϣ
--05	����Ͱ�
--06	��˾��վ

select * from t_Organization

FPhone FFax FContact FAddress


select * from t_Organization


--��ҵ���۶�
select  v8.FName,
		v7.FName,
		CASE WHEN v2.FProvince LIKE '�㶫%' then '�㶫' else '��ʡ' end as FPro,
		v2.FProvince,
		v2.FName AS FName,
		v3.FName,
		v5.FName,
		v4.FName as FTradeName,
		t1.*
from
(
SELECT --v3.FName,
		--v5.FName,
		--v4.FName as FTradeName,
		--v2.FName AS FName,  
		v1.FSupplyID,  
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
--		[2009]=ISNULL(SUM(CASE year(v1.FDate) when '2009' then u1.FConsignAmount END),0),
--		[2010]=ISNULL(SUM(CASE year(v1.FDate) when '2010' then u1.FConsignAmount END),0),
		--[2014���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2014' then u1.FConsignAmount END),0),
		[2017���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2017' then u1.FConsignAmount END),0),
		[2017��1�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='1' THEN u1.FConsignAmount END),0),
		[2017��2�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='2' THEN u1.FConsignAmount END),0),
		[2017��3�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='3' THEN u1.FConsignAmount END),0),
		[2017��4�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='4' THEN u1.FConsignAmount END),0),
		[2017��5�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='5' THEN u1.FConsignAmount END),0),
		[2017��6�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='6' THEN u1.FConsignAmount END),0),
		[2017��7�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='7' THEN u1.FConsignAmount END),0),
		[2017��8�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='8' THEN u1.FConsignAmount END),0),
		[2017��9�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='9' THEN u1.FConsignAmount END),0),
		[2017��10�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='10' THEN u1.FConsignAmount END),0),
		[2017��11�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='11' THEN u1.FConsignAmount END),0),
		[2017��12�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='12' THEN u1.FConsignAmount END),0),
		[2016���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2016' then u1.FConsignAmount END),0),
		[2016��1�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='1' THEN u1.FConsignAmount END),0),
		[2016��2�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='2' THEN u1.FConsignAmount END),0),
		[2016��3�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='3' THEN u1.FConsignAmount END),0),
		[2016��4�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='4' THEN u1.FConsignAmount END),0),
		[2016��5�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='5' THEN u1.FConsignAmount END),0),
		[2016��6�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='6' THEN u1.FConsignAmount END),0),
		[2016��7�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='7' THEN u1.FConsignAmount END),0),
		[2016��8�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='8' THEN u1.FConsignAmount END),0),
		[2016��9�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='9' THEN u1.FConsignAmount END),0),
		[2016��10�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='10' THEN u1.FConsignAmount END),0),
		[2016��11�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='11' THEN u1.FConsignAmount END),0),
		[2016��12�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='12' THEN u1.FConsignAmount END),0),
		[2015���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2015' then u1.FConsignAmount END),0),
		[2015��1�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='1' THEN u1.FConsignAmount END),0),
		[2015��2�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='2' THEN u1.FConsignAmount END),0),
		[2015��3�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='3' THEN u1.FConsignAmount END),0),
		[2015��4�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='4' THEN u1.FConsignAmount END),0),
		[2015��5�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='5' THEN u1.FConsignAmount END),0),
		[2015��6�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='6' THEN u1.FConsignAmount END),0),
		[2015��7�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='7' THEN u1.FConsignAmount END),0),
		[2015��8�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='8' THEN u1.FConsignAmount END),0),
		[2015��9�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='9' THEN u1.FConsignAmount END),0),
		[2015��10�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='10' THEN u1.FConsignAmount END),0),
		[2015��11�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='11' THEN u1.FConsignAmount END),0),
		[2015��12�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='12' THEN u1.FConsignAmount END),0),
		[2014���۶�]=ISNULL(SUM(CASE year(v1.FDate) when '2014' then u1.FConsignAmount END),0),
		[2014��1�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='1' THEN u1.FConsignAmount END),0),
		[2014��2�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='2' THEN u1.FConsignAmount END),0),
		[2014��3�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='3' THEN u1.FConsignAmount END),0),
		[2014��4�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='4' THEN u1.FConsignAmount END),0),
		[2014��5�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='5' THEN u1.FConsignAmount END),0),
		[2014��6�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='6' THEN u1.FConsignAmount END),0),
		[2014��7�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='7' THEN u1.FConsignAmount END),0),
		[2014��8�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='8' THEN u1.FConsignAmount END),0),
		[2014��9�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='9' THEN u1.FConsignAmount END),0),
		[2014��10�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='10' THEN u1.FConsignAmount END),0),
		[2014��11�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='11' THEN u1.FConsignAmount END),0),
		[2014��12�����۶�]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='12' THEN u1.FConsignAmount END),0),
		--[7�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '7' then u1.FConsignAmount END),0),
		--[8�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '8' then u1.FConsignAmount END),0),
		--[9�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '9' then u1.FConsignAmount END),0),
		--[10�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '10' then u1.FConsignAmount END),0),
		--[11�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '11' then u1.FConsignAmount END),0),
		--[12�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FConsignAmount END),0),
		[2017������]=ISNULL(SUM(CASE year(v1.FDate) when '2017' then u1.FAuxQty END),0),
		[2017��1�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='1' then u1.FAuxQty END),0),
		[2017��2�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='2' then u1.FAuxQty END),0),
		[2017��3�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='3' then u1.FAuxQty END),0),
		[2017��4�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='4' then u1.FAuxQty END),0),
		[2017��5�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='5' then u1.FAuxQty END),0),
		[2017��6�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='6' then u1.FAuxQty END),0),
		[2017��7�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='7' then u1.FAuxQty END),0),
		[2017��8�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='8' then u1.FAuxQty END),0),
		[2017��9�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='9' then u1.FAuxQty END),0),
		[2017��10�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='10' then u1.FAuxQty END),0),
		[2017��11�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='11' then u1.FAuxQty END),0),
		[2017��12�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2017' AND Month(v1.FDate)='12' then u1.FAuxQty END),0),
		[2016������]=ISNULL(SUM(CASE year(v1.FDate) when '2016' then u1.FAuxQty END),0),
		[2016��1�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='1' then u1.FAuxQty END),0),
		[2016��2�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='2' then u1.FAuxQty END),0),
		[2016��3�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='3' then u1.FAuxQty END),0),
		[2016��4�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='4' then u1.FAuxQty END),0),
		[2016��5�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='5' then u1.FAuxQty END),0),
		[2016��6�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='6' then u1.FAuxQty END),0),
		[2016��7�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='7' then u1.FAuxQty END),0),
		[2016��8�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='8' then u1.FAuxQty END),0),
		[2016��9�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='9' then u1.FAuxQty END),0),
		[2016��10�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='10' then u1.FAuxQty END),0),
		[2016��11�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='11' then u1.FAuxQty END),0),
		[2016��12�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2016' AND Month(v1.FDate)='12' then u1.FAuxQty END),0),
		[2015������]=ISNULL(SUM(CASE year(v1.FDate) when '2015' then u1.FAuxQty END),0),
		[2015��1�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='1' then u1.FAuxQty END),0),
		[2015��2�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='2' then u1.FAuxQty END),0),
		[2015��3�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='3' then u1.FAuxQty END),0),
		[2015��4�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='4' then u1.FAuxQty END),0),
		[2015��5�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='5' then u1.FAuxQty END),0),
		[2015��6�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='6' then u1.FAuxQty END),0),
		[2015��7�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='7' then u1.FAuxQty END),0),
		[2015��8�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='8' then u1.FAuxQty END),0),
		[2015��9�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='9' then u1.FAuxQty END),0),
		[2015��10�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='10' then u1.FAuxQty END),0),
		[2015��11�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='11' then u1.FAuxQty END),0),
		[2015��12�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2015' AND Month(v1.FDate)='12' then u1.FAuxQty END),0),
		[2014������]=ISNULL(SUM(CASE year(v1.FDate) when '2014' then u1.FAuxQty END),0),
		[2014��1�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='1' then u1.FAuxQty END),0),
		[2014��2�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='2' then u1.FAuxQty END),0),
		[2014��3�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='3' then u1.FAuxQty END),0),
		[2014��4�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='4' then u1.FAuxQty END),0),
		[2014��5�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='5' then u1.FAuxQty END),0),
		[2014��6�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='6' then u1.FAuxQty END),0),
		[2014��7�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='7' then u1.FAuxQty END),0),
		[2014��8�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='8' then u1.FAuxQty END),0),
		[2014��9�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='9' then u1.FAuxQty END),0),
		[2014��10�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='10' then u1.FAuxQty END),0),
		[2014��11�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='11' then u1.FAuxQty END),0),
		[2014��12�³�����]=ISNULL(SUM(CASE WHEN Year(v1.FDate)='2014' AND Month(v1.FDate)='12' then u1.FAuxQty END),0)
		--[7�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '7' then u1.FAuxQty END),0),
		--[8�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '8' then u1.FAuxQty END),0),
		--[9�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '9' then u1.FAuxQty END),0),
		--[10�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '10' then u1.FAuxQty END),0),
		--[11�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '11' then u1.FAuxQty END),0),
		--[12�³�����]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FAuxQty END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	where year(v1.FDate)IN ('2017','2016','2015','2014') 
	--and month(v1.FDate)<='12'
	
	and v1.FTranType=21 
	group by v1.FSupplyID) t1

LEFT JOIN t_Organization v2 ON t1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
LEFT JOIN t_SubMessage v7 ON v2.FRegionID=v7.FInterID
LEFT JOIN t_Emp v8 ON v2.Femployee=v8.FItemID
where v3.FName='��������ҵ��'
----where v4.FName='΢��¯'
order by [FPro],[2017���۶�] desc
