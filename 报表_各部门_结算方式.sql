declare @FStartDate date
declare @FEndDate date
declare @FDepartment varchar(20)
set @FStartDate='2020-04-01'
set @FEndDate='2020-05-01'
set @FDepartment='端子套国内事业部'


select
 s1.FName '结算方式'
 ,tt0.FYear '年份'
 ,tt0.FMonth '月份'
 ,tt0.FDepartment '部门'
 ,isnull(tt0.FCustomerQty,0) '月交易客户数'
 ,cast(cast(isnull(tt0.FCustomerQty,0)*100 as decimal(38,2))/tt1.cou as decimal(38,2)) '月客户数占比'
 ,isnull(tt0.FAmount,0) '月交易额'
 ,isnull(tt2.FC,0) '月回款客户数'
 ,isnull(tt0.FCustomerQty,0)-isnull(tt2.FC,0) '月未回客户数'
 ,isnull(tt2.FSettleAmountFor,0) '月回款额'
 ,case when isnull(tt3.FSettleAmountFor,0)=0 then 0 else cast(isnull(tt2.FSettleAmountFor,0)*100/isnull(tt3.FSettleAmountFor,0) as decimal(38,2))end '回款占比'
from
  t_Settle s1

  -- 出库信息 客户数 出库额 部门划分 结算方式划分
  left join (
    select case when s1.FItemID in (7,17) then 7 when s1.FItemID in (1,13) then 1 else s1.FItemID end FItemID
	 ,count(distinct i1.FSupplyID) FCustomerQty,sum(i2.FConsignAmount)FAmount,d1.FName FDepartment,year(i1.FDate)FYear,month(i1.FDate)FMonth
	from ICStockBill i1
	 left join ICStockBillEntry i2 on i1.FInterID=i2.FInterID
     left join t_Organization o1 on i1.FSupplyID=o1.FItemID
	 left join t_Settle s1 on o1.FSetID=s1.FItemID
	 left join t_Department d1 on o1.Fdepartment=d1.FItemID
   where --s1.FItemID in (1,6,7,8,9,10,11,13,14,15,16) and 
   i1.FTranType=21 and i1.FDate>=@FStartDate and i1.FDate<@FEndDate
   group by case when s1.FItemID in (7,17) then 7 when s1.FItemID in (1,13) then 1 else s1.FItemID end,d1.FName,year(i1.FDate),month(i1.FDate)
  ) tt0 on s1.FItemID=tt0.FItemID

  -- 总出库信息 部门划分
  left join (
   select count(distinct i1.FSupplyID)cou,d1.FName FDepartment,year(i1.FDate)FYear,month(i1.FDate)FMonth
   from ICStockBill i1 
   left join t_Organization o1 on i1.FSupplyID=o1.FItemID
   left join t_Settle s1 on o1.FSetID=s1.FItemID 
   left join t_Department d1 on o1.Fdepartment=d1.FItemID
   where --s1.FItemID in (1,6,7,8,9,10,11,13,14,15,16) and 
   i1.FTranType=21 and i1.FDate>=@FStartDate and i1.FDate<@FEndDate
   group by d1.FName,year(i1.FDate),month(i1.FDate)
  )tt1 on tt0.FDepartment=tt1.FDepartment and tt0.FYear=tt1.FYear and tt0.FMonth=tt1.FMonth

  -- 收款信息 客户数 收款额 部门划分 结算方式划分
  left join (
	select case when s1.FItemID in (7,17) then 7 when s1.FItemID in (1,13) then 1 else s1.FItemID end FItemID
	  ,count(distinct n1.FCustomer)FC,sum(n1.FSettleAmountFor)FSettleAmountFor,d1.FName FDepartment,n1.FYear,n1.FPeriod FMonth
	from t_RP_NewReceiveBill n1 
	 --left join t_Item i1 on n1.FCustomer=i1.FItemID
	 left join t_Organization o1 on n1.FCustomer=o1.FItemID
	 left join t_Settle s1 on o1.FSetID=s1.FItemID AND s1.FItemID<>0
	 left join t_Department d1 on n1.FDepartment=d1.FItemID
	where
	  ((n1.FYear=year(@FStartDate) and n1.FPeriod=month(@FStartDate))
	  or (n1.FYear=year(dateadd(month,-1,@FEndDate)) and n1.FPeriod=month(dateadd(month,-1,@FEndDate))))-- and d1.FName=@FDepartment
	  and n1.FClassTypeID=1000005 --and s1.FItemID in (1,6,7,8,9,10,11,13,14,15,16)
	group by case when s1.FItemID in (7,17) then 7 when s1.FItemID in (1,13) then 1 else s1.FItemID end,d1.FName,n1.FYear,n1.FPeriod
  )tt2 on s1.FItemID=tt2.FItemID and tt0.FDepartment=tt2.FDepartment and tt0.FYear=tt2.FYear and tt0.FMonth=tt2.FMonth

  -- 总收款信息 部门划分
  left join (
	select 
	  sum(n1.FSettleAmountFor)FSettleAmountFor,d1.FName FDepartment,n1.FYear,n1.FPeriod FMonth
	from t_RP_NewReceiveBill n1 
	 --left join t_Item i1 on n1.FCustomer=i1.FItemID
	 --left join t_Organization o1 on n1.FCustomer=o1.FItemID
	 left join t_Settle s1 on n1.FSettle=s1.FItemID AND s1.FItemID<>0
	 left join t_Department d1 on n1.FDepartment=d1.FItemID
	where
	  ((n1.FYear=year(@FStartDate) and n1.FPeriod=month(@FStartDate))
	  or (n1.FYear=year(dateadd(month,-1,@FEndDate)) and n1.FPeriod=month(dateadd(month,-1,@FEndDate))))-- and d1.FName=@FDepartment
	  and n1.FClassTypeID=1000005 --and s1.FItemID in (1,6,7,8,9,10,11,13,14,15,16)
	group by d1.FName,n1.FYear,n1.FPeriod
  )tt3 on tt0.FDepartment=tt3.FDepartment and tt0.FYear=tt3.FYear and tt0.FMonth=tt3.FMonth
  where isnull(tt0.FYear,0)<>0
--where s1.FItemID in (1,6,7,8,9,10,11,13,14,15,16)-- and tt0.FDepartment=@FDepartment
--where s1.FItemID in (1,6,7,8,9,10,11,15) and i1.FTranType=21 and i1.FDate>=@FStartDate and i1.FDate<@FEndDate-- and d1.FName=@FDepartment
--group by s1.FName,tt1.cou,tt2.FC,tt2.FSettleAmountFor,tt3.FSettleAmountFor,d1.FName


union all 


select
 '总计'
 ,tt0.FYear '年份'
 ,tt0.FMonth '月份'
 ,tt0.FDepartment '部门'
 ,isnull(tt0.FCustomerQty,0) '月交易客户数'
 ,cast(cast(isnull(tt0.FCustomerQty,0)*100 as decimal(38,2))/tt1.cou as decimal(38,2)) '月客户数占比'
 ,isnull(tt0.FAmount,0) '月交易额'
 ,isnull(tt2.FC,0) '月回款客户数'
 ,isnull(tt0.FCustomerQty,0)-isnull(tt2.FC,0) '月未回客户数'
 ,isnull(tt2.FSettleAmountFor,0) '月回款额'
 ,case when isnull(tt3.FSettleAmountFor,0)=0 then 0 else cast(isnull(tt2.FSettleAmountFor,0)*100/isnull(tt3.FSettleAmountFor,0) as decimal(38,2))end '回款占比'
from
  -- 出库信息 客户数 出库额 部门划分 结算方式划分
  (
    select count(distinct i1.FSupplyID) FCustomerQty,sum(i2.FConsignAmount)FAmount,d1.FName FDepartment,year(i1.FDate)FYear,month(i1.FDate)FMonth
	from ICStockBill i1
	 left join ICStockBillEntry i2 on i1.FInterID=i2.FInterID
     left join t_Organization o1 on i1.FSupplyID=o1.FItemID
	 left join t_Settle s1 on o1.FSetID=s1.FItemID
	 left join t_Department d1 on o1.Fdepartment=d1.FItemID
   where  --s1.FItemID in (1,6,7,8,9,10,11,13,14,15,16) and 
   i1.FTranType=21 and i1.FDate>=@FStartDate and i1.FDate<@FEndDate
   group by d1.FName,year(i1.FDate),month(i1.FDate)
  ) tt0

  -- 总出库信息 部门划分
  left join (
   select count(distinct i1.FSupplyID)cou,d1.FName FDepartment,year(i1.FDate)FYear,month(i1.FDate)FMonth
   from ICStockBill i1 
   left join t_Organization o1 on i1.FSupplyID=o1.FItemID
   left join t_Settle s1 on o1.FSetID=s1.FItemID 
   left join t_Department d1 on o1.Fdepartment=d1.FItemID
   where --s1.FItemID in (1,6,7,8,9,10,11,13,14,15,16) and 
   i1.FTranType=21 and i1.FDate>=@FStartDate and i1.FDate<@FEndDate
   group by d1.FName,year(i1.FDate),month(i1.FDate)
  )tt1 on tt0.FDepartment=tt1.FDepartment and tt0.FYear=tt1.FYear and tt0.FMonth=tt1.FMonth

  -- 收款信息 客户数 收款额 部门划分 结算方式划分
  left join (
	select 
	  count(distinct n1.FCustomer)FC,sum(n1.FSettleAmountFor)FSettleAmountFor,d1.FName FDepartment,n1.FYear,n1.FPeriod FMonth
	from t_RP_NewReceiveBill n1 
	 --left join t_Item i1 on n1.FCustomer=i1.FItemID
	 --left join t_Organization o1 on n1.FCustomer=o1.FItemID
	 left join t_Settle s1 on n1.FSettle=s1.FItemID AND s1.FItemID<>0
	 left join t_Department d1 on n1.FDepartment=d1.FItemID
	where
	  ((n1.FYear=year(@FStartDate) and n1.FPeriod=month(@FStartDate))
	  or (n1.FYear=year(dateadd(month,-1,@FEndDate)) and n1.FPeriod=month(dateadd(month,-1,@FEndDate))))-- and d1.FName=@FDepartment
	  and n1.FClassTypeID=1000005 --and s1.FItemID in (1,6,7,8,9,10,11,13,14,15,16)
	group by d1.FName,n1.FYear,n1.FPeriod
  )tt2 on tt0.FDepartment=tt2.FDepartment and tt0.FYear=tt2.FYear and tt0.FMonth=tt2.FMonth

  -- 总收款信息 部门划分
  left join (
	select 
	  sum(n1.FSettleAmountFor)FSettleAmountFor,d1.FName FDepartment,n1.FYear,n1.FPeriod FMonth
	from t_RP_NewReceiveBill n1 
	 --left join t_Item i1 on n1.FCustomer=i1.FItemID
	 --left join t_Organization o1 on n1.FCustomer=o1.FItemID
	 left join t_Settle s1 on n1.FSettle=s1.FItemID AND s1.FItemID<>0
	 left join t_Department d1 on n1.FDepartment=d1.FItemID
	where
	  ((n1.FYear=year(@FStartDate) and n1.FPeriod=month(@FStartDate))
	  or (n1.FYear=year(dateadd(month,-1,@FEndDate)) and n1.FPeriod=month(dateadd(month,-1,@FEndDate))))-- and d1.FName=@FDepartment
	  and n1.FClassTypeID=1000005 --and s1.FItemID in (1,6,7,8,9,10,11,13,14,15,16)
	group by d1.FName,n1.FYear,n1.FPeriod
  )tt3 on tt0.FDepartment=tt3.FDepartment and tt0.FYear=tt3.FYear and tt0.FMonth=tt3.FMonth
order by tt0.FDepartment,tt0.FYear,tt0.FMonth,s1.FName