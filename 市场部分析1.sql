create table #market_1(FID int)
create table #market_2(FID int,FConsignAmount decimal(18,4))

insert into #market_1
select distinct tt1.FID  from
(select t1.FID,t1.FBillNo,t1.FText3,t1.FText1,t1.FDate,t2.FItemID,t3.FAmount from CRM_SampleReq t1
left join t_ICItem t2 on t1.FText3=t2.FModel and t1.FText1=FHelpCode
left join ICStockBillEntry t3 on t2.FItemID=t3.FItemID
inner join ICStockBill t4 on t3.FInterID=t4.FInterID
where t2.FItemID IS NOT NULL
and
t1.Fdate>='2013-10-01' and t1.FDate<='2013-10-31'
and t4.FDate<=t1.FDate)tt1

select * from #market_1

insert into #market_2
select t1.FID--,t1.FBillNo,t1.FText3,t1.FText1,t1.FDate,t2.FItemID,t4.FDate
,sum(t3.FConsignAmount) 
from CRM_SampleReq t1
left join t_ICItem t2 on t1.FText3=t2.FModel and t1.FText1=FHelpCode
left join ICStockBillEntry t3 on t2.FItemID=t3.FItemID
inner join ICStockBill t4 on t3.FInterID=t4.FInterID
where t2.FItemID IS NOT NULL
and
t1.Fdate>='2013-10-01' and t1.FDate<='2013-10-31'
and
t4.FDate>t1.FDate
and
t1.FID NOT IN(
select FID from #market_1)
group by t1.FID

select t3.FName as 收样公司,
--	t3.FName as 客户所属行业,
	t3.F_118 as 方普行业结构,
	t3.F_112 as 配套产品,
	t2.FText3 as 样品名称, 
	t2.Ftext1 as 样品料号,
	t2.FDate as 填写日期,
	t4.FName as 寄样人,
	t5.FName as 负责部门,
	t1.FConsignAmount from #market_2 t1
left join CRM_SampleReq t2 on t1.FID=t2.FID
left join t_organization t3 ON t2.FCustomerID=t3.FItemID
left join t_Emp t4 on t2.FReqestID=t4.FItemID
left join t_Department t5 on t3.FDepartment=t5.Fitemid
where t1.FConsignAmount>0

drop table #market_1
drop table #market_2

---所有样品
select t1.FID,t1.FBillNo,t2.FName as 收样公司,
--	t3.FName as 客户所属行业,
	t2.F_118 as 方普行业结构,
	t2.F_112 as 配套产品,
	t1.FText3 as 样品名称, 
	t1.Ftext1 as 样品料号,
	t3.FName,
	t1.FDate as 填写日期,
	t4.FName as 寄样人,
	t5.FName as 负责部门,
	t1.FReqNote from CRM_SampleReq t1
left join t_organization t2 ON t1.FCustomerID=t2.FItemID
left join t_ICItem t3 on t1.FText3=t3.FModel and t1.FText1=t3.FHelpCode
left join t_Emp t4 on t1.FReqestID=t4.FItemID
left join t_Department t5 on t2.FDepartment=t5.Fitemid
where t3.FItemID IS NULL


create table #market_3(FID int,FConsignAmount decimal(18,4))

insert into #market_3
select t1.FID--,t1.FBillNo,t1.FText3,t1.FText1,t1.FDate,t2.FItemID,t4.FDate
,sum(t3.FConsignAmount) 
from CRM_SampleReq t1
left join t_ICItem t2 on t1.FText3=t2.FModel and t1.FText1=FHelpCode
left join ICStockBillEntry t3 on t2.FItemID=t3.FItemID
inner join ICStockBill t4 on t3.FInterID=t4.FInterID
where t2.FItemID IS NOT NULL
and
t1.Fdate>='2014-05-01' --and t1.FDate<='2013-10-31'
and
t4.FDate>t1.FDate
group by t1.FID

select t3.FName as 收样公司,
--	t3.FName as 客户所属行业,
	t3.F_118 as 方普行业结构,
	t3.F_112 as 配套产品,
	t2.FText3 as 样品名称, 
	t2.Ftext1 as 样品料号,
	t2.FDate as 填写日期,
	t4.FName as 寄样人,
	t5.FName as 负责部门,
	t1.FConsignAmount from #market_3 t1
left join CRM_SampleReq t2 on t1.FID=t2.FID
left join t_organization t3 ON t2.FCustomerID=t3.FItemID
left join t_Emp t4 on t2.FReqestID=t4.FItemID
left join t_Department t5 on t3.FDepartment=t5.Fitemid
left join (select t1.FCustID,t2.FText5 
from PORFQ t1
left join PORFQEntry t2 on t1.FInterID=t2.FInterID
)tt1 on t2.FCustomerID=tt1.FCustID and t2.FText3=tt1.FText5
where t1.FConsignAmount=0 and tt1.FText5 IS NOT NULL

drop table #market_3

select * from CRM_SampleReq where year(fdate)='2011'


select t2.FName ,t4.FName,t3.FName,t1.FBillDate ,
	FNoteDescription=replace(replace(t1.FNoteDescription,char(10), ''),char(13),''),
	FNoteResult=replace(replace(t1.FNoteResult,char(10), ''),char(13),'')   from [dbo].[CRM_Activity] t1
left join t_Department t2 on t1.FDepartmentID =t2.FItemID 
left join t_Organization t3 on t1.FCustomerID =t3.FItemID 
left join t_Emp t4 on t1.FUserID =t4.FItemID 
where year(t1.FBillDate)='2015' 