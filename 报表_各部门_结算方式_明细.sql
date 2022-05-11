declare @FStartDate date
declare @FEndDate date
declare @FDepartment varchar(20)
set @FStartDate='2020-04-01'
set @FEndDate='2020-05-01'
--set @FDepartment='端子套国内事业部'

select
 --tt1.*,tt2.*
 s1.FName '结算方式'
 ,tt1.FYear '年'
 ,tt1.FMonth '月'
 ,tt1.FDepartment '部门'
 ,tt1.FCustomer '客户'
 ,tt1.FAmount '出库额'
 ,isnull(tt2.FSettleAmountFor,0) '回款额'
 ,tt1.FAmount-isnull(tt2.FSettleAmountFor,0) '差额'
from (
select o1.FName FCustomer,o1.FItemID FCustomerID,case when s1.FItemID in (7,17) then 7 when s1.FItemID in (1,13) then 1 else s1.FItemID end FItemID
 ,sum(i2.FConsignAmount)FAmount,d1.FName FDepartment,year(i1.FDate)FYear,month(i1.FDate)FMonth
from ICStockBill i1
 left join ICStockBillEntry i2 on i1.FInterID=i2.FInterID
 left join t_Organization o1 on i1.FSupplyID=o1.FItemID
 left join t_Settle s1 on o1.FSetID=s1.FItemID
 left join t_Department d1 on o1.Fdepartment=d1.FItemID
where s1.FItemID in (1,6,7,13,17) and 
 i1.FTranType=21 and i1.FDate>=@FStartDate and i1.FDate<@FEndDate-- and d1.FName=@FDepartment
group by o1.FName,o1.FItemID,case when s1.FItemID in (7,17) then 7 when s1.FItemID in (1,13) then 1 else s1.FItemID end,d1.FName,year(i1.FDate),month(i1.FDate)
) tt1
left join (
select o1.FItemID FCustomerID,case when s1.FItemID in (7,17) then 7 when s1.FItemID in (1,13) then 1 else s1.FItemID end FItemID
 ,sum(n1.FSettleAmountFor)FSettleAmountFor,d1.FName FDepartment,n1.FYear,n1.FPeriod FMonth
from t_RP_NewReceiveBill n1 
 --left join t_Item i1 on n1.FCustomer=i1.FItemID
 left join t_Organization o1 on n1.FCustomer=o1.FItemID
 left join t_Settle s1 on n1.FSettle=s1.FItemID AND s1.FItemID<>0
 left join t_Department d1 on n1.FDepartment=d1.FItemID
where
 ((n1.FYear=year(@FStartDate) and n1.FPeriod=month(@FStartDate))
 or (n1.FYear=year(dateadd(month,-1,@FEndDate)) and n1.FPeriod=month(dateadd(month,-1,@FEndDate))))-- and d1.FName=@FDepartment
 and n1.FClassTypeID=1000005 and s1.FItemID in (1,6,7,13,17)
group by o1.FItemID,case when s1.FItemID in (7,17) then 7 when s1.FItemID in (1,13) then 1 else s1.FItemID end,d1.FName,n1.FYear,n1.FPeriod
) tt2 on tt1.FCustomerID=tt2.FCustomerID and tt1.FItemID=tt2.FItemID and tt1.FYear=tt2.FYear and tt1.FMonth=tt2.FMonth
left join t_Settle s1 on tt1.FItemID=s1.FItemID
where tt1.FAmount-isnull(tt2.FSettleAmountFor,0)>0
order by tt1.FDepartment,tt1.FYear,tt1.FMonth,s1.FName