DECLARE @Period char(4)
DECLARE @Department char(12)
select @Period='2012'
select @Department='��������ҵ��'

--select @Period
--select @Department


select tt4.FName,tt5.FName,tt6.FName,
tt1.[���۶�ϼ�],
tt1.[1�����۶�],tt2.[1����Ʒ],tt3.[1�±���],
tt1.[2�����۶�],tt2.[2����Ʒ],tt3.[2�±���],
tt1.[3�����۶�],tt2.[3����Ʒ],tt3.[3�±���],
tt1.[4�����۶�],tt2.[4����Ʒ],tt3.[4�±���],
tt1.[5�����۶�],tt2.[5����Ʒ],tt3.[5�±���],
tt1.[6�����۶�],tt2.[6����Ʒ],tt3.[6�±���],
tt1.[7�����۶�],tt2.[7����Ʒ],tt3.[7�±���],
tt1.[8�����۶�],tt2.[8����Ʒ],tt3.[8�±���],
tt1.[9�����۶�],tt2.[9����Ʒ],tt3.[9�±���],
tt1.[10�����۶�],tt2.[10����Ʒ],tt3.[10�±���],
tt1.[11�����۶�],tt2.[11����Ʒ],tt3.[11�±���],
tt1.[12�����۶�],tt2.[12����Ʒ],tt3.[12�±���]
from
(SELECT v2.Fdepartment,
		v2.F_117,    
--        CONVERT(char(7),v1.FDate,120),
--		ISNULL(SUM(CASE CONVERT(char(6),v1.FDate,112) WHEN @Period THEN u1.FConsignAmount END),0),
		[���۶�ϼ�]=ISNULL(SUM(u1.FConsignAmount),0),
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
		[12�����۶�]=ISNULL(SUM(CASE month(v1.FDate) when '12' then u1.FConsignAmount END),0)
--		sum(u1.FConsignAmount)
    --FROM t_xySaleReporttest
    --select v1.FDate,v3.FName,v2.F_110,v2.Fname,u1.FAuxQty,u1.FConsignAmount
    FROM ICStockBill v1 
	INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
	LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
	LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
	LEFT JOIN t_Item v4 ON v2.F_117=v4.FItemID
	LEFT JOIN t_Item v5 ON v4.FParentID=v5.FItemID
	LEFT JOIN t_Item v6 ON v5.FParentID=v6.FItemID
where year(v1.FDate)=@Period
--and month(v1.FDate)<='6'
and v1.FTranType=21 and v3.FName=@Department 
--and v4.FName IN ('���ÿյ���','΢��¯','����\���','��ˮ��','�緹��/ѹ����')
group by v2.Fdepartment,v2.F_117--,year(v1.FDate)
--CONVERT(char(7),v1.FDate,120) 
--with rollup
--order by [2013] desc--v5.FName,v4.FName,[2011]
--order by v4.FName,[2013] desc
)tt1

left join
--��Ʒ

(select 
	t2.Fdepartment,t2.F_117,
	[1����Ʒ]=ISNULL(count(CASE month(t1.FDate) when '1' then t1.FID END),0),
	[2����Ʒ]=ISNULL(count(CASE month(t1.FDate) when '2' then t1.FID END),0),
	[3����Ʒ]=ISNULL(count(CASE month(t1.FDate) when '3' then t1.FID END),0),
	[4����Ʒ]=ISNULL(count(CASE month(t1.FDate) when '4' then t1.FID END),0),
	[5����Ʒ]=ISNULL(count(CASE month(t1.FDate) when '5' then t1.FID END),0),
	[6����Ʒ]=ISNULL(count(CASE month(t1.FDate) when '6' then t1.FID END),0),
	[7����Ʒ]=ISNULL(count(CASE month(t1.FDate) when '7' then t1.FID END),0),
	[8����Ʒ]=ISNULL(count(CASE month(t1.FDate) when '8' then t1.FID END),0),
	[9����Ʒ]=ISNULL(count(CASE month(t1.FDate) when '9' then t1.FID END),0),
	[10����Ʒ]=ISNULL(count(CASE month(t1.FDate) when '10' then t1.FID END),0),
	[11����Ʒ]=ISNULL(count(CASE month(t1.FDate) when '11' then t1.FID END),0),
	[12����Ʒ]=ISNULL(count(CASE month(t1.FDate) when '12' then t1.FID END),0) 
from CRM_SampleReq t1
left join t_Organization t2 ON t1.FCustomerID=t2.FItemID
LEFT JOIN t_Item t3 ON t2.Fdepartment=t3.FItemID
LEFT JOIN t_Item t4 ON t2.F_117=t4.FItemID
where year(t1.FDate)=@Period and t3.FName=@Department
group by t2.Fdepartment,t2.F_117)tt2 
ON tt1.Fdepartment=tt2.Fdepartment and tt1.F_117=tt2.F_117

left join
--����
(select 
	t2.Fdepartment,t2.F_117,
	[1�±���]=ISNULL(count(CASE month(t1.FDate) when '1' then t1.FInterID END),0),
	[2�±���]=ISNULL(count(CASE month(t1.FDate) when '2' then t1.FInterID END),0),
	[3�±���]=ISNULL(count(CASE month(t1.FDate) when '3' then t1.FInterID END),0),
	[4�±���]=ISNULL(count(CASE month(t1.FDate) when '4' then t1.FInterID END),0),
	[5�±���]=ISNULL(count(CASE month(t1.FDate) when '5' then t1.FInterID END),0),
	[6�±���]=ISNULL(count(CASE month(t1.FDate) when '6' then t1.FInterID END),0),
	[7�±���]=ISNULL(count(CASE month(t1.FDate) when '7' then t1.FInterID END),0),
	[8�±���]=ISNULL(count(CASE month(t1.FDate) when '8' then t1.FInterID END),0),
	[9�±���]=ISNULL(count(CASE month(t1.FDate) when '9' then t1.FInterID END),0),
	[10�±���]=ISNULL(count(CASE month(t1.FDate) when '10' then t1.FInterID END),0),
	[11�±���]=ISNULL(count(CASE month(t1.FDate) when '11' then t1.FInterID END),0),
	[12�±���]=ISNULL(count(CASE month(t1.FDate) when '12' then t1.FInterID END),0) 
from PORFQ t1
left join t_Organization t2 ON t1.FCustID=t2.FItemID
LEFT JOIN t_Item t3 ON t2.Fdepartment=t3.FItemID
LEFT JOIN t_Item t4 ON t2.F_117=t4.FItemID
where year(t1.FDate)=@Period and t3.FName=@Department
group by t2.Fdepartment,t2.F_117)tt3
ON tt1.Fdepartment=tt3.Fdepartment and tt1.F_117=tt3.F_117

LEFT JOIN t_Item tt4 ON tt1.Fdepartment=tt4.FItemID
LEFT JOIN t_Item tt5 ON tt1.F_117=tt5.FItemID
LEFT JOIN t_Item tt6 ON tt5.FParentID=tt6.FItemID
order by [���۶�ϼ�] desc


