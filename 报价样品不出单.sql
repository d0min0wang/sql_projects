create table #market_3(FID int,FConsignAmount decimal(18,4))

insert into #market_3
select t1.FID--,t1.FBillNo,t1.FText3,t1.FText1,t1.FDate,t2.FItemID,t4.FDate
,sum(t3.FConsignAmount) 
from CRM_SampleReq t1
left join t_ICItem t2 on t1.FText3=t2.FModel and t1.FText1=FHelpCode
left join ICStockBillEntry t3 on t2.FItemID=t3.FItemID
inner join ICStockBill t4 on t3.FInterID=t4.FInterID
where t2.FItemID IS NOT NULL
--and
--t1.Fdate>='2014-05-01' --and t1.FDate<='2013-10-31'
and
t4.FDate>t1.FDate
group by t1.FID

select * from
(select t3.FName as ������˾,
	t3.FAddress as ��ַ,
	t3.FPhone as �绰,
	t3.FContact as ��ϵ��,
--	t3.FName as �ͻ�������ҵ,
	t3.F_118 as ������ҵ�ṹ,
	t3.F_112 as ���ײ�Ʒ,
	t2.FText3 as ��Ʒ����, 
	t2.Ftext1 as ��Ʒ�Ϻ�,
	t2.FDate as ��д����,
	t4.FName as ������,
	t5.FName as ������,
	tt1.FText5,
	t1.FConsignAmount,
	'�б��۵���Ʒת���ɲ�Ʒδ����' as ״̬ from #market_3 t1
left join CRM_SampleReq t2 on t1.FID=t2.FID
left join t_organization t3 ON t2.FCustomerID=t3.FItemID
left join t_Emp t4 on t2.FReqestID=t4.FItemID
left join t_Department t5 on t3.FDepartment=t5.Fitemid
left join (select t1.FCustID,t2.FText5 
from PORFQ t1
left join PORFQEntry t2 on t1.FInterID=t2.FInterID
)tt1 on t2.FCustomerID=tt1.FCustID and t2.FText3=tt1.FText5
where t1.FConsignAmount=0 --and tt1.FText5 IS NOT NULL
--ORDER BY t2.FDate
UNION ALL
select --distinct --tt1.FCustomerID,tt1.FText3,tt1.FText1,tt1.FCreateDate,
	t3.FName as ������˾,
	t3.FAddress as ��ַ,
	t3.FPhone as �绰,
	t3.FContact as ��ϵ��,
--	t3.FName as �ͻ�������ҵ,
	t3.F_118 as ������ҵ�ṹ,
	t3.F_112 as ���ײ�Ʒ,
	tt1.FText3 as ��Ʒ����, 
	tt1.Ftext1 as ��Ʒ�Ϻ�,
	tt1.FDate as ��д����,
	t4.FName as ������,
	t5.FName as ������,
	tt2.FText5,
	0,
	'�б��۵���Ʒδת���ɲ�Ʒ' 
from CRM_SampleReq tt1
left join t_organization t3 ON tt1.FCustomerID=t3.FItemID
left join t_Emp t4 on tt1.FReqestID=t4.FItemID
left join t_Department t5 on t3.FDepartment=t5.Fitemid
left join
(select t1.FCustID,t2.FText5 
from PORFQ t1
left join PORFQEntry t2 on t1.FInterID=t2.FInterID
)tt2 on tt1.FCustomerID=tt2.FCustID and tt1.FText3=tt2.FText5
left join t_ICItem tt3 on tt1.FText3=tt3.FModel and tt1.FText1=tt3.FHelpCode
--left join ICStockBillEntry tt4 on tt3.FItemID=tt4.FItemID
--inner join ICStockBill tt5 on tt4.FInterID=tt5.FInterID
where tt3.FItemID IS NULL and tt2.FText5 IS NOT NULL)v1
ORDER BY v1.[��д����]

drop table #market_3


--select * from t_organization
