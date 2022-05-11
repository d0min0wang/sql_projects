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
(select t3.FName as 收样公司,
	t3.FAddress as 地址,
	t3.FPhone as 电话,
	t3.FContact as 联系人,
--	t3.FName as 客户所属行业,
	t3.F_118 as 方普行业结构,
	t3.F_112 as 配套产品,
	t2.FText3 as 样品名称, 
	t2.Ftext1 as 样品料号,
	t2.FDate as 填写日期,
	t4.FName as 寄样人,
	t5.FName as 负责部门,
	tt1.FText5,
	t1.FConsignAmount,
	'有报价的样品转化成产品未出单' as 状态 from #market_3 t1
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
	t3.FName as 收样公司,
	t3.FAddress as 地址,
	t3.FPhone as 电话,
	t3.FContact as 联系人,
--	t3.FName as 客户所属行业,
	t3.F_118 as 方普行业结构,
	t3.F_112 as 配套产品,
	tt1.FText3 as 样品名称, 
	tt1.Ftext1 as 样品料号,
	tt1.FDate as 填写日期,
	t4.FName as 寄样人,
	t5.FName as 负责部门,
	tt2.FText5,
	0,
	'有报价的样品未转化成产品' 
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
ORDER BY v1.[填写日期]

drop table #market_3


--select * from t_organization
