 if exists (select * from sysobjects where id = object_id(N'[dbo].[#tmpArContStmbak]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 drop table [dbo].[#tmpArContStmbak] ; 
 select FContactID,sum(FCheckAmount) as FCheckAmount, sum(FCheckAmountFor) as FCheckAmountFor into #tmpArContStmbak from t_rp_newcheckinfo c join t_rp_contact d on c.FContactID=d.FID join t_item i on c.fcustomer=i.fitemid left join t_item ii on c.FDepartment=ii.fitemid left join t_item iii on c.FEmployee=iii.fitemid where (c.FRP=1 or(c.FRP=0 and c.FTransfer>0))
 and c.FCheckDate<='2022-12-31' and d.FItemClassID=1 and i.FNumber>='01.ZS.DF.0074' and i.FNumber<='01.ZS.DF.0074' and i.FNumber >= '01.ZS.DF.0074' and i.FNumber <= '01.ZS.DF.0074' group by c.FContactID

  select 0 FBillType,c.FCurrencyID,c.FInvoiceType,c.FID,c.FIsBad,c.FPre,c.FType,c.FIsinit,c.FK3Import,c.FRP,c.FInvoiceID,c.FRPBillID,c.FBillID,c.FBegID,c.FDate,c.FFIncDate,c.FNumber,
 c.FCustomer,i.FNumber FCustomerNumber,i.FName FCustomerName,ii.FNumber FDepartmentNumber,ii.FName FDepartmentName,
 iii.FNumber FEmployeeNumber,iii.FName FEmployeeName,v.FNumber FVchNumber,v.FName FVchName,s.FDate FRPDate,
 c.FAmount,c.FAmountFor,
 case when c.FIsBad=1 and 1=1 then c.FRemainAmount - isnull(y.FBadAdjustAmount,0) when c.FIsBad=1 and 1=0 then c.FRemainAmount - isnull(y.FBadAdjustAmount,0)- isnull(y.FAdjustAmount,0) else c.FAmount-isnull(t.FCheckAmount,0) +isnull(y.FAdjustAmount,0) end  as FRemainAmount, case when c.FIsBad=1 then 0 else c.FAmountFor-isnull(t.FCheckAmountFor,0) end as FRemainAmountFor,
 isnull(r.FSettleDiscount,0) FDiscountAmount,isnull(r.FSettleDiscountFor,0) FDiscountAmountfor,
 isnull(c.FContractNo,t3.FCompactNo) as FContractNo,0 FSortCheckID,c.FDate FSortDate,c.FType FSortType,c.FIsInit FSortIsInit,
 (case c.FIsinit when 1 then c.FBegID else(case when c.FType>=1 and c.FType<=2 then c.FRPBillID when c.FType>=3 and c.FType<=4 then c.FInvoiceID else c.FBillID end) end)FSortBillID,
 c.FExplanation,(case c.FIsinit when 1 then t1.FClassTypeID else (case when c.FType>=1 and c.FType<=2 then t2.FClassTypeID when c.FType>=3 and c.FType<=4 then t3.FClassTypeID when c.FType>=5 and c.FType<=6 then t4.FClassTypeID end)end)FClassTypeID,0 FTranType
,(case c.FIsInit when 1 then '*' else (case when c.FType>=1 and c.FType<=2 then '*' when c.FType>=3 and c.FType<=4 then isnull(t6.FName,'*') when c.FType>=5 and c.FType<=6 then t5.FName else '*' end)end) FSettleName
,(case c.FIsInit when 1 then '*' else (case when c.FType>=1 and c.FType<=2 then '*' when c.FType>=3 and c.FType<=4 then '*'  when c.FType>=5 and c.FType<=6 then t4.FSettleNo else '*' end)end) FSettleNo
 into #tempStmtMain
 from t_rp_contact c
 left join(select FContactID,sum(case when FDate<='2022-12-31' then FAdjustAmount else 0 end) as FAdjustAmount, sum(case when FDate>'2022-12-31' then FAdjustAmount else 0 end) as FBadAdjustAmount from t_rp_adjustRate group by FContactID)y on c.FID=y.FContactID
 join t_item i on c.FCustomer=i.FItemID
 left join t_item ii on c.FDepartment=ii.FItemID
 left join t_item iii on c.FEmployee=iii.FItemID
 left join t_rp_begData t1 on c.FBegID=t1.FinterID
 left join t_rp_arpbill t2 on c.FRPBillID=t2.FBillID
 left join icsale t3 on c.FInvoiceID=t3.FInterID
 left join t_rp_newReceivebill t4 on c.FBillID=t4.FBillID
 left join t_Settle t5 on t4.FSettle=t5.FItemID
 left join t_Settle t6 on t3.FSettleID=t6.FItemID
 left join (select FOrgID,Max(FDate) FDate from t_rp_plan_Ar group by FOrgID)s on c.FID=s.FOrgID
 left join #tmpArContStmbak t on c.FID=t.FContactID
 left join(select FBillID,sum(FDiscount)FSettleDiscount,sum(FDiscountFor)FSettleDiscountFor from t_rp_arbillofsh group by FBIllID)r
 on c.FBillID=r.FBillID
 left join(select a.FVoucherID,a.FNumber,b.FName from t_voucher a join t_voucherGroup b on a.FGroupID=b.FGroupID)v
 on c.FVoucherID=v.FVoucherID
 where c.FRP=1 and c.FDate>='2021-01-01' and c.FDate<='2022-12-31' and c.FItemClassID=1 and c.FInvoiceType in(0,1,2) and i.FNumber>='01.ZS.DF.0074' and i.FNumber<='01.ZS.DF.0074' and ( c.FStatus & 16 )=0
 and ( (c.FType=3 or c.FType=13) or (c.FType=1 or c.FType=11) or (c.FType in (5,15) and (c.FPre = 0 and c.FIsinit=0)))

 --插入应收冲应付数据
INSERT INTO #tempStmtMain (FBillType,FCurrencyID,FInvoiceType,FID,FIsBad,FPre,FType,FIsinit,FK3Import,FRP,FInvoiceID,
   FRPBillID,FBillID,FBegID,FDate,FFincDate,FNumber,FCustomer,FCustomerNumber,FCustomerName,
   FDepartmentNumber,FDepartmentName,FEmployeeNumber,FEmployeeName,FVchNumber,FVchName,FRPDate,
   FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FDiscountAmount,FDiscountAmountFor,FContractNo,
   FSortCheckID,FSortDate,FSortType,FSortIsinit,FSortBillID,FExplanation,FClassTypeID,FTranType,FSettleName,FSettleNo
   )
 select 0 FBillType,c.FCurrencyID,c.FInvoiceType,c.FID,c.FIsBad,c.FPre,c.FType,c.FIsinit,c.FK3Import,c.FRP,c.FInvoiceID,c.FRPBillID,c.FBillID,c.FBegID,c.FDate,c.FFIncDate,c.FNumber,
       c.FCustomer,k.FNumber FCustomerNumber,k.FName FCustomerName,d.FNumber FDepartmentNumber,d.FName FDepartmentName,
       e.FNumber FEmployeeNumber,e.FName FEmployeeName,v.FNumber FVchNumber,v.FName FVchName,NULL FRPDate,
       sum(t.FCheckAmount) FAmount ,sum(t.FCheckAmountFor) FAmountFor ,0 FRemainAmountIC,0 FRemainAmountForIC,
       0 FDiscountAmount,0 FDiscountAmountfor,c.FContractNo,
       0 FSortCheckID,c.FDate FSortDate,c.FType FSortType,c.FIsInit FSortIsInit,
       (case c.FIsinit when 1 then c.FBegID else(case when c.FType>=1 and c.FType<=2 then c.FRPBillID when c.FType>=3 and c.FType<=4 then c.FInvoiceID else c.FBillID end) end)FSortBillID,
       c.FExplanation,0 FClassTypeID,0 FTranType
       ,(case c.FIsInit when 1 then '' else isnull(p1.FSettleName,'') end) FSettleName
       ,(case c.FIsInit when 1 then '' else isnull(p1.FSettleNo,'') end) FSettleNo
 from t_rp_contact c
 join t_rp_checkentry t on t.ftype_src=9 and c.fid=t.fbillid_src and t.FType in (3,13,1,11)
 join t_item k on c.FCustomer = k.FItemID
 left join t_item d on c.FDepartment = d.FItemID 
 left join t_item e on c.FEmployee = e.FItemID  
 left join(select a.FVoucherID,a.FNumber,b.FName from t_voucher a join t_voucherGroup b on a.FGroupID=b.FGroupID)v
       on c.FVoucherID=v.FVoucherID

 left join ( select f2.FEntryID,f1.FNote FNote,f2.FInterID,f3.FName FName,f7.FName FAuxName,
      f4.FModel FModel,F4.FNumber,f6.FName FMeasureUnitName, f4.FPricedecimal FPriceScale,f4.FQtyDecimal FQtyScale,
      f2.FAuxTaxPrice*(1-f2.FDisCountRate/100) FPrice,f2.FAuxQty FQuantity,f5.FCheckQuantity FCheckQuantity,
      (case f1.FClassTypeID when 1000002 then f2.FAmountIncludeTax  else FAmount end) FAmountFor,
      (case f1.FClassTypeID when 1000002 then f2.FStdAmountIncludeTax+isnull(t10.FAdjustAmount,0)  else FStdAmount+isnull(t10.FAdjustAmount,0) end) FAmount,
      f5.FRAmount FRAmount,f5.FRAmountFor FRAmountFor
      ,isnull(f8.FName,'') as  FSettleName,'*' as FSettleNo
      ,isnull(f2.FClassID_SRC,'') as FSourceBillType,isnull(f2.FSourceBillNo,'') as FSourceBillNo,isnull(f2.FContractBillNo,'') as FContractBillNo,isnull(f2.FOrderBillNo,'') as  FOrderBillNo
      from  ICSaleEntry f2
  left join ICSale f1 on f2.FInterID = f1.FInterID
  left join t_item f3 on f2.FItemID = f3.FItemID
  left join t_icitem f4 on f2.FItemID = f4.FItemID
  left join t_measureunit f6 on f2.funitid=f6.fmeasureunitid
  left join t_auxitem f7 on f2.FAuxpropID=f7.FItemID
  left join t_Settle f8 on f1.FSettleID=f8.FItemID
  left join(select a.FBillID,a.FEntryID,sum(a.FAdjustAmount)FAdjustAmount
          from t_rp_AdjustRateEntry a join t_rp_adjustrate b on a.FType=b.FType and a.FBillID=b.FBillID and a.FIsinit=b.FIsinit
              and a.FAdjustID=b.FAdjustID where a.FIsinit=0 and a.FType=3 and b.FDate<='2022-12-31'
          group by a.FBillID,a.FEntryID)t10 on f2.FInterID=t10.FBillID and f2.FEntryID=t10.FEntryID
  Left join (select f01.FBillID,f01.FEntryID,
              sum(f01.Fcheckquantity) FcheckQuantity,sum(f01.fcheckAmount) FRAmount,
              sum(f01.fcheckAmountFor) FRAmountFor from (
                  select a.FCheckQuantity,a.FCheckAmount,a.FCheckAmountFor,a.FBillID,a.FEntryID,b.FCheckDate
                  from t_rp_checkentry a join t_rp_newcheckinfo b on a.FInterID=b.FInterID
                  where a.FIsinit=0 and a.FType=3 Union All
                  select a.FQty,a.FAmount,a.FAmountFor,a.FID_SRC,a.FEntryID_SRC,b.FDate
                  from  t_rp_newbaddebtentry a join t_rp_newbaddebt b on a.FDebtID=b.FDebtID
                  join t_rp_contact c on a.FContactID=c.FID
                  Where c.FISinit = 0 and c.FType=3 and b.FBack=0)f01
          where f01.FCheckDate<='2022-12-31'
          group by f01.FBillID,f01.FEntryID) f5
  on  f2.FInterID=f5.FBillID and  f2.FEntryID=f5.FEntryID
  where   1=1) p1 on c.FInvoiceID=p1.FInterID and t.FEntryID=p1.FEntryID
 left join ( select f2.FEntryID,f1.FExplanation FExplanation,f1.FInterID,'' FAuxName,
       f3.FNumber,f3.fname fname,f4.fmodel fmodel,f6.fname FMeasureUnitName,f4.FPricedecimal FPriceScale,f4.FQtyDecimal FQtyScale,
       f2.FRealTaxPriceFor fprice,f2.fquantity fquantity,f5.FcheckQuantity FcheckQuantity,
       f2.fAmount +isnull(t10.FAdjustAmount,0) famount,f2.fAmountFor FAmountFor,
       f5.FRAmount FRAmount,f5.FRAmountFor FRAmountFor
       ,'*' as FSettleName,'*' as FSettleNo,f2.FClassID_SRC as FSourceBillType,f2.FBillNo_SRC as FSourceBillNo,f2.FContractNo as FContractBillNo,'' as  FOrderBillNo
   from t_rp_begDataEntry f2
   join t_rp_begdata f1 on  f2.FInterID=F1.FInterID
   left join t_item f3 on  f2.fproductID = f3.FItemID
   left join t_icitem f4 on f2.fproductID = f4.FItemID
   left join t_measureunit f6 on f2.funitid=f6.fmeasureunitid
   left join(select a.FBillID,a.FEntryID,sum(a.FAdjustAmount)FAdjustAmount
       from t_rp_AdjustRateEntry a join t_rp_adjustrate b on a.FType=b.FType and a.FBillID=b.FBillID and a.FIsinit=b.FIsinit 
           and a.FAdjustID=b.FAdjustID where a.FIsinit=1 and b.FDate<='2022-12-31'
       group by a.FBillID,a.FEntryID)t10 on f2.FInterID=t10.FBillID and f2.FEntryID=t10.FEntryID
   Left join (select f01.FBillID,f01.FEntryID,
               sum(f01.Fcheckquantity) FcheckQuantity,sum(f01.fcheckAmount) FRAmount,
               sum(f01.fcheckAmountFor) FRAmountFor from (
                   select a.FCheckQuantity,a.FCheckAmount,a.FCheckAmountFor,a.FBillID,a.FEntryID,b.FCheckDate
                   from t_rp_checkentry a join t_rp_newcheckinfo b on a.FInterID=b.FInterID
                   where a.FIsinit=1 Union All
                   select a.FQty,a.FAmount,a.FAmountFor,a.FID_SRC,a.FEntryID_SRC,b.FDate
                   from  t_rp_newbaddebtentry a join t_rp_newbaddebt b on a.FDebtID=b.FDebtID
                   join t_rp_contact c on a.FContactID=c.FID
                   Where c.FISinit = 1 and b.FBack=0)f01
           where f01.FCheckDate<='2022-12-31'
           group by f01.FBillID,f01.FEntryID) f5
   on f2.FInterID=f5.FBillID and  f2.FEntryID=f5.FEntryID 
   where f1.FType in(3,13,4,14) and  1=1) p2 on c.FBegID=p2.FInterID and t.FEntryID=p2.FEntryID
 where c.FRP=1 and c.FItemClassID=1 and c.FInvoiceType in(0,1,2) and k.FNumber>='01.ZS.DF.0074' and k.FNumber<='01.ZS.DF.0074' and ( c.FStatus & 16 )=0
 and c.FDate>='2021-01-01' and c.FDate<='2022-12-31'
 and c.FType=9
 group by c.FCurrencyID,c.FInvoiceType,c.FID,c.FIsBad,c.FPre,c.FType,c.FIsinit,c.FK3Import,c.FRP,c.FInvoiceID,c.FRPBillID,c.FBillID,c.FBegID,c.FDate,c.FFIncDate,c.FNumber,
       c.FCustomer,k.FNumber,k.FName,d.FNumber,d.FName,
       e.FNumber,e.FName,v.FNumber,v.FName,c.FContractNO,c.FDate,c.FType,c.FIsInit,c.FExplanation,p1.FSettleName,p1.FSettleNo
--插入坏账数据
INSERT INTO #tempStmtMain (FBillType,FCurrencyID,FInvoiceType,FID,FIsBad,FPre,FType,FIsinit,FK3Import,FRP,FInvoiceID,
   FRPBillID,FBillID,FBegID,FDate,FFincDate,FNumber,FCustomer,FCustomerNumber,FCustomerName,
   FDepartmentNumber,FDepartmentName,FEmployeeNumber,FEmployeeName,FVchNumber,FVchName,FRPDate,
   FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FDiscountAmount,FDiscountAmountFor,FContractNo,
   FSortCheckID,FSortDate,FSortType,FSortIsinit,FSortBillID,FExplanation,FClassTypeID,FTranType
   ,FSettleName,FSettleNo
   )
 select 0 FBillType,c.FCurrencyID,c.FInvoiceType,c.FID,c.FIsBad,c.FPre,8 FType,c.FIsinit,c.FK3Import,c.FRP,c.FInvoiceID,c.FRPBillID,c.FBillID,c.FBegID,b.FDate,b.FDate,c.FNumber,
       c.FCustomer,k.FNumber FCustomerNumber,k.FName FCustomerName,d.FNumber FDepartmentNumber,d.FName FDepartmentName,
       e.FNumber FEmployeeNumber,e.FName FEmployeeName,v.FNumber FVchNumber,v.FName FVchName,NULL FRPDate,
       sum(t.FAmount),sum(t.FAmountFor),0 FRemainAmount,0 FRemainAmountFor,
       0 FDiscountAmount,0 FDiscountAmountfor,c.FContractNo,
       0 FSortCheckID,b.FDate FSortDate,c.FType FSortType,0 FSortIsInit,

       (case c.FIsinit when 1 then c.FBegID else(case when c.FType>=1 and c.FType<=2 then c.FRPBillID when c.FType>=3 and c.FType<=4 then c.FInvoiceID else c.FBillID end) end)FSortBillID,
       c.FExplanation,0 FClassTypeID,0 FTranType
       ,(case c.FIsInit when 1 then '' else isnull(p1.FSettleName,'') end) FSettleName
       ,(case c.FIsInit when 1 then '' else isnull(p1.FSettleNo,'') end) FSettleNo
 from t_rp_contact c
 join t_rp_newbaddebt b on c.fid=b.fcontactid and b.FType in (3,13,1,11)
 join t_rp_newbaddebtentry t  on b.fdebtid=t.fdebtid and b.fcontactid=t.fcontactid
 join t_item k on c.FCustomer = k.FItemID
 left join t_item d on c.FDepartment = d.FItemID 
 left join t_item e on c.FEmployee = e.FItemID  
 left join(select a.FVoucherID,a.FNumber,b.FName from t_voucher a join t_voucherGroup b on a.FGroupID=b.FGroupID)v
       on b.FVoucherID=v.FVoucherID
 left join ( select f2.FEntryID,f1.FNote FNote,f2.FInterID,f3.FName FName,f7.FName FAuxName,
      f4.FModel FModel,F4.FNumber,f6.FName FMeasureUnitName, f4.FPricedecimal FPriceScale,f4.FQtyDecimal FQtyScale,
      f2.FAuxTaxPrice*(1-f2.FDisCountRate/100) FPrice,f2.FAuxQty FQuantity,f5.FCheckQuantity FCheckQuantity,
      (case f1.FClassTypeID when 1000002 then f2.FAmountIncludeTax  else FAmount end) FAmountFor,
      (case f1.FClassTypeID when 1000002 then f2.FStdAmountIncludeTax+isnull(t10.FAdjustAmount,0)  else FStdAmount+isnull(t10.FAdjustAmount,0) end) FAmount,
      f5.FRAmount FRAmount,f5.FRAmountFor FRAmountFor
      ,isnull(f8.FName,'') as  FSettleName,'*' as FSettleNo
      ,isnull(f2.FClassID_SRC,'') as FSourceBillType,isnull(f2.FSourceBillNo,'') as FSourceBillNo,isnull(f2.FContractBillNo,'') as FContractBillNo,isnull(f2.FOrderBillNo,'') as  FOrderBillNo
      from  ICSaleEntry f2
  left join ICSale f1 on f2.FInterID = f1.FInterID
  left join t_item f3 on f2.FItemID = f3.FItemID
  left join t_icitem f4 on f2.FItemID = f4.FItemID
  left join t_measureunit f6 on f2.funitid=f6.fmeasureunitid
  left join t_auxitem f7 on f2.FAuxpropID=f7.FItemID
  left join t_Settle f8 on f1.FSettleID=f8.FItemID
  left join(select a.FBillID,a.FEntryID,sum(a.FAdjustAmount)FAdjustAmount
          from t_rp_AdjustRateEntry a join t_rp_adjustrate b on a.FType=b.FType and a.FBillID=b.FBillID and a.FIsinit=b.FIsinit
              and a.FAdjustID=b.FAdjustID where a.FIsinit=0 and a.FType=3 and b.FDate<='2022-12-31'
          group by a.FBillID,a.FEntryID)t10 on f2.FInterID=t10.FBillID and f2.FEntryID=t10.FEntryID
  Left join (select f01.FBillID,f01.FEntryID,
              sum(f01.Fcheckquantity) FcheckQuantity,sum(f01.fcheckAmount) FRAmount,
              sum(f01.fcheckAmountFor) FRAmountFor from (
                  select a.FCheckQuantity,a.FCheckAmount,a.FCheckAmountFor,a.FBillID,a.FEntryID,b.FCheckDate
                  from t_rp_checkentry a join t_rp_newcheckinfo b on a.FInterID=b.FInterID
                  where a.FIsinit=0 and a.FType=3 Union All
                  select a.FQty,a.FAmount,a.FAmountFor,a.FID_SRC,a.FEntryID_SRC,b.FDate
                  from  t_rp_newbaddebtentry a join t_rp_newbaddebt b on a.FDebtID=b.FDebtID
                  join t_rp_contact c on a.FContactID=c.FID
                  Where c.FISinit = 0 and c.FType=3 and b.FBack=0)f01
          where f01.FCheckDate<='2022-12-31'
          group by f01.FBillID,f01.FEntryID) f5
  on  f2.FInterID=f5.FBillID and  f2.FEntryID=f5.FEntryID
  where   1=1) p1 on c.FInvoiceID=p1.FInterID and t.FEntryID_SRC=p1.FEntryID
 left join ( select f2.FEntryID,f1.FExplanation FExplanation,f1.FInterID,'' FAuxName,
       f3.FNumber,f3.fname fname,f4.fmodel fmodel,f6.fname FMeasureUnitName,f4.FPricedecimal FPriceScale,f4.FQtyDecimal FQtyScale,
       f2.FRealTaxPriceFor fprice,f2.fquantity fquantity,f5.FcheckQuantity FcheckQuantity,
       f2.fAmount +isnull(t10.FAdjustAmount,0) famount,f2.fAmountFor FAmountFor,
       f5.FRAmount FRAmount,f5.FRAmountFor FRAmountFor
       ,'*' as FSettleName,'*' as FSettleNo,f2.FClassID_SRC as FSourceBillType,f2.FBillNo_SRC as FSourceBillNo,f2.FContractNo as FContractBillNo,'' as  FOrderBillNo
   from t_rp_begDataEntry f2
   join t_rp_begdata f1 on  f2.FInterID=F1.FInterID
   left join t_item f3 on  f2.fproductID = f3.FItemID
   left join t_icitem f4 on f2.fproductID = f4.FItemID
   left join t_measureunit f6 on f2.funitid=f6.fmeasureunitid
   left join(select a.FBillID,a.FEntryID,sum(a.FAdjustAmount)FAdjustAmount
       from t_rp_AdjustRateEntry a join t_rp_adjustrate b on a.FType=b.FType and a.FBillID=b.FBillID and a.FIsinit=b.FIsinit 
           and a.FAdjustID=b.FAdjustID where a.FIsinit=1 and b.FDate<='2022-12-31'
       group by a.FBillID,a.FEntryID)t10 on f2.FInterID=t10.FBillID and f2.FEntryID=t10.FEntryID
   Left join (select f01.FBillID,f01.FEntryID,
               sum(f01.Fcheckquantity) FcheckQuantity,sum(f01.fcheckAmount) FRAmount,
               sum(f01.fcheckAmountFor) FRAmountFor from (
                   select a.FCheckQuantity,a.FCheckAmount,a.FCheckAmountFor,a.FBillID,a.FEntryID,b.FCheckDate
                   from t_rp_checkentry a join t_rp_newcheckinfo b on a.FInterID=b.FInterID
                   where a.FIsinit=1 Union All
                   select a.FQty,a.FAmount,a.FAmountFor,a.FID_SRC,a.FEntryID_SRC,b.FDate
                   from  t_rp_newbaddebtentry a join t_rp_newbaddebt b on a.FDebtID=b.FDebtID
                   join t_rp_contact c on a.FContactID=c.FID
                   Where c.FISinit = 1 and b.FBack=0)f01
           where f01.FCheckDate<='2022-12-31'
           group by f01.FBillID,f01.FEntryID) f5
   on f2.FInterID=f5.FBillID and  f2.FEntryID=f5.FEntryID 
   where f1.FType in(3,13,4,14) and  1=1) p2 on c.FBegID=p2.FInterID and t.FEntryID_SRC=p2.FEntryID
 where c.FRP=1 and c.FItemClassID=1 and c.FInvoiceType in(0,1,2) and k.FNumber>='01.ZS.DF.0074' and k.FNumber<='01.ZS.DF.0074' and ( c.FStatus & 16 )=0
 and b.FDate>='2021-01-01' and b.FDate<='2022-12-31'
 group by c.FCurrencyID,c.FInvoiceType,c.FID,c.FIsBad,c.FPre,c.FIsinit,c.FK3Import,c.FRP,c.FInvoiceID,c.FRPBillID,c.FBillID,c.FBegID,b.FDate,b.FDate,c.FNumber,
       c.FCustomer,k.FNumber,k.FName,d.FNumber,d.FName,
       e.FNumber,e.FName,v.FNumber,v.FName,c.FContractNo,c.FDate,c.FType,c.FIsInit,c.FExplanation,p1.FSettleName,p1.FSettleNo




INSERT INTO #tempStmtMain (FBillType,FCurrencyID,FInvoiceType,FID,FIsBad,FPre,FType,FIsinit,FK3Import,FRP,FInvoiceID,
   FRPBillID,FBillID,FBegID,FDate,FFincDate,FNumber,FCustomer,FCustomerNumber,FCustomerName,
   FDepartmentNumber,FDepartmentName,FEmployeeNumber,FEmployeeName,FVchNumber,FVchName,FRPDate,
   FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FDiscountAmount,FDiscountAmountFor,FContractNo,
   FSortCheckID,FSortDate,FSortType,FSortIsinit,FSortBillID,FExplanation,FClassTypeID,FTranType
   ,FSettleName,FSettleNo)
SELECT 0 FBillType,1 as FCurrencyID,0 FInvoiceType,0 FID,0 FIsBad,0 FPre,c.FType FType,0 FIsinit,0 FK3Import,1 FRP,0 FInvoiceID,
   0 FRPBillID,c.FInterID FBillID,0 FBegID,c.FDate,c.FFincDate,c.FNumber,c.FCustomer,k.FNumber,k.FName,
   d.FNumber,d.FName,e.FNumber,e.FName,c.FVchNumber,c.FVchName,c.FSettleDate,
   sum(case ty.FEquityHook when 1 then 0 else case when c.FQty=0  then c.FAmount else (c.FQty-isnull(tz.FHookQty,0))*c.FAmount/c.FQty end end) FAmount,
   sum(case ty.FEquityHook when 1 then 0 else case when c.FQty=0  then c.FAmount else (c.FQty-isnull(tz.FHookQty,0))*c.FAmount/c.FQty end end) FAmountFor,
   sum(case ty.FEquityHook when 1 then 0 else case when c.FQty=0  then c.FAmount else (c.FQty-isnull(tz.FHookQty,0))*c.FAmount/c.FQty end end) FRemainAmount,
   sum(case ty.FEquityHook when 1 then 0 else case when c.FQty=0  then c.FAmount else (c.FQty-isnull(tz.FHookQty,0))*c.FAmount/c.FQty end end) FRemainAmountFor,
   0 FDiscountAmount,0 FDiscountAmountFor,'' FContractNo,
   0 FSortCheckID,c.FDate FSortDate,80 FSortType,0 FSortIsInit,c.FInterID,c.FExplanation,c.FClassTypeID FClassTypeID,c.FTranType
 ,'*' as FSettleName,'*' as FSettleNo
From (
        select 0 FClassTypeID,b.FInterID as FInterID,a.FEntryID as FEntryID,0 as FID,0 FYear,0 FPeriod, 1 as FRP,
               80 FType,b.FDate as FDate, isnull(v.fdate,b.FDate) as FFincDate,b.FSettleDate FSettleDate,b.FBillNo as FNumber,0 as FPre,
               b.FSupplyID as FCustomer,isnull(b.FDeptID,0) as FDepartment,isnull(b.FEmpID,0) as FEmployee,1 FCurrencyID,1 FExchangeRate,a.FQty as FQty,
               a.FConsignAmount FAmount,a.FConsignAmount FAmountFor,
               a.FConsignAmount FRemainAmount,a.FConsignAmount FRemainAmountFor,
               0 as FIsBad,b.FVchInterID as FVoucherID,v.FGroupID as FGroupID,b.FCussentAcctID as FAccountID,0 as FIsInit,case when b.FStatus=0 then 0 else 1 end as FStatus,
               a.FConsignprice FPrice,'' as FDetailBillType,'' as FDetailBillTypeName,0 as FInvoiceType,
               1 FItemClassID,b.FExplanation FExplanation,0 FSubSystemID,v.FNumber FVchNumber,v1.FName FVchName,
               b.FTranType as FTranType,CAST(v1.FName AS Nvarchar(30))+'-'+CAST(v.FNumber AS Nvarchar(30))  as FVoucherNo,'' as FBillTypeName,
               f7.FName FAuxName, f4.FModel FModel,f6.FName FMeasureUnitName,f3.FNumber FInvNumber,f3.FName FInvName,f4.FPricedecimal FPriceScale,f4.FQtyDecimal FQtyScale,f6.FCoefficient 
               ,a.FOrderBillNo,a.FContractBillNo,a.FSourceBillNo,a.FSourceTranType 
            from icstockbill b
             join icstockbillentry a on b.FInterID=a.FInterID
             left join t_voucher v on b.FVchInterID=v.FVoucherID
             left join t_VoucherGroup v1 on v.FGroupID=v1.FGroupID
             left join t_item f3 on a.FItemID = f3.FItemID
             left join t_icitem f4 on a.FItemID = f4.FItemID
             left join t_measureunit f6 on a.funitid=f6.fmeasureunitid
             left join t_auxitem f7 on a.FAuxpropID=f7.FItemID
            where b.ftrantype = 21 and b.FCancellation<>1  and b.FInterID not in (select distinct FIBInterID From ICHookRelations Where FIBTag=4 And Ftrantype = 21 )) c
 left join (select fibinterid,fentryid,FEquityHook,ftrantype, sum(fhookqty) as fhookqty from  icHookRelations a
                join t_PeriodDate b on a.FYear=b.FYear and a.FPeriod=b.FPeriod
              where a.FIBTag=1  and b.FStartDate <='2022-12-31'
              group by fibinterid,fentryid,FEquityHook,ftrantype ) tz on c.finterid=tz.fibinterid and c.fentryid=tz.fentryid and c.ftrantype=tz.ftrantype
 left join (select distinct fibinterid,FEquityHook,ftrantype from  icHookRelations a
                join t_PeriodDate b on a.FYear=b.FYear and a.FPeriod=b.FPeriod
              where a.FIBTag=1   and b.FStartDate <='2022-12-31'
              group by fibinterid,FEquityHook,ftrantype ) ty on c.finterid=ty.fibinterid and c.ftrantype=ty.ftrantype 
 left join t_item k on c.FCustomer = k.FItemID 
 left join t_item d on c.FDepartment = d.FItemID 
 left join t_item e on c.FEmployee = e.FItemID  
 where 1=1  and c.FDate>='2021-01-01' and c.FDate<='2022-12-31'
 and c.FItemClassID=1
 and k.FNumber>='01.ZS.DF.0074'
 and k.FNumber<='01.ZS.DF.0074'

 and (case ty.FEquityHook when 1 then 0 else case when c.FQty=0  then c.FAmount else (c.FQty-isnull(tz.FHookQty,0)) end end) <> 0
 group by c.FInterID,d.FNumber,d.FName,e.FNumber,e.FName,c.FVchNumber,c.FVchName,c.FDate,c.FFincDate,
          c.FNumber,c.FCustomer,k.FNumber,k.FName,c.FExplanation,c.FTranType,c.FType,c.FSettleDate,c.FClassTypeID



 if exists (select * from sysobjects where id = object_id(N'[dbo].[#tmpArContStm]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 drop table [dbo].[#tmpArContStm] ; select FContactID,sum(FCheckAmount) as FCheckAmount, sum(FCheckAmountFor) as FCheckAmountFor into #tmpArContStm from t_rp_newcheckinfo c join t_rp_contact d on c.FContactID=d.FID join t_item i on c.fcustomer=i.fitemid left join t_item ii on c.FDepartment=ii.fitemid left join t_item iii on c.FEmployee=iii.fitemid where (c.FRP=1 or(c.FRP=0 and c.FTransfer>0))
 and c.FCheckDate<'2021-01-01' and d.FItemClassID=1 and i.FNumber>='01.ZS.DF.0074' and i.FNumber<='01.ZS.DF.0074' and i.FNumber >= '01.ZS.DF.0074' and i.FNumber <= '01.ZS.DF.0074' group by c.FContactID


 select t.FContactID,t.FEntryID,t.FBillID_Src,t.FIsinit_Src,t.FType_Src,t.FEntryID_Src,sum(t.FCheckAmount) as FCheckAmount,sum(t.FCheckQuantity) FCheckQuantity,sum(t.FCheckAmountFor) as FCheckAmountFor 
 into #tmpArDetailStm
 from t_rp_newcheckinfo b
 join t_rp_checkentry t on b.FID=t.FID and b.FInterID=t.FInterID and b.FContactID=t.FContactID
 join t_rp_contact c on b.FContactID=c.FID
 join t_item k on c.FCustomer = k.FItemID
 left join t_item d on c.FDepartment = d.FItemID 
 left join t_item e on c.FEmployee = e.FItemID  
 where c.FRP=1 and c.FItemClassID=1 and c.FInvoiceType in(0,1,2) and k.FNumber>='01.ZS.DF.0074' and k.FNumber<='01.ZS.DF.0074' and ( c.FStatus & 16 )=0 and b.FCheckDate<'2021-01-01'
 group by t.FContactID,t.FEntryID,t.FBillID_Src,t.FIsinit_Src,t.FType_Src,t.FEntryID_Src
 Insert into #tmpArDetailStm
 (FContactID,FEntryID,FEntryID_SRC,FType_SRC,FIsinit_SRC,FBillID_SRC,FCheckAmount,FCheckAmountFor,FCheckQuantity) 
select b.FContactID,b.FEntryID_SRC,0,0,0,b.FEntryID_SRC,sum(b.FAmount) FCheckAmount,sum(b.FAmountFor) FCheckAmountFor,sum(b.FQty) FCheckQuantity
 From t_rp_newbaddebt a
 join t_rp_newbaddebtEntry b on a.FDebtID = b.FDebtID And a.FContactID = b.FContactID
 where a.FBack = 0 
 and a.FDate<'2021-01-01'
group by b.FContactID,b.FEntryID_SRC



 SELECT FContactID,sum(FCheckAmount) as FCheckAmount,sum(FCheckAmountFor) as FCheckAmountFor,sum(FCheckQuantity) as FCheckQuantity
 INTO #tmpRPCheckInfo 
 FROM #tmpArDetailStm
 GROUP BY FContactID


 insert #tempStmtMain (FCurrencyID,FInvoiceType,FID,FIsbad,FPre,FType,FIsinit,FK3Import,FRP,FInvoiceID,FRPBillID,FBillID,FBegID,FDate,FFIncDate,FNumber,
 FCustomer,FCustomerNumber,FCustomerName,FDepartmentNumber,FDepartmentName,FContractNo,
 FEmployeeName,FEmployeeNumber,FVchNumber,FVchName,FRPDate,
 FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,
 FDiscountAmount,FDiscountAmountfor,
 FSortCheckID,FSortDate,FSortType,FSortIsInit,FSortBillID,FBillType,FExplanation,FClassTypeID,FTranType,FSettleName,FSettleNo)
 select 0 FCurrencyID,  0 FInvoiceType,
  0 FID,0 FIsbad,0 FPre,-1 FType,3 FIsinit,0 Fk3import,0 FRP,0 FInvoiceID,0 FRPBillID,0 FBillID,0 FBegID, 
  '1900-01-01' FDate,'1900-01-01' FFincDate,''FNumber,a.FCustomer,a.FCustomerNo FCustomerNumber,a.FCustomerName FCustomerNumber, 
 '' FDeptNumber,''FDeptName,'' FContractNO,''FEmpNumber,''FEmpName,''FVchNumber,''FVchName,null FRPDate,0 FAmount,0 FAmountFor,
 a.FEndBal FRemainAmount,a.FEndBalFor FRemainAmountFor,0 FDiscountAmount,0 FDiscountAmountfor,
 0 FSortID,'1900-01-01' FSortDate,-1 FSortType,3 FSortIsInit,-2 FSortBillID,0 FBillType,
 '' FExplanation,-1 FClassTypeID,0 FTranType,'*' as FSettleName,'*' as FSettleNo
 from ( select distinct i.FNumber FCustomerNo,i.FName FCustomerName,c.FCustomer FCustomer,  sum(
   case   when c.ftype>=1  and c.ftype<=4 or c.ftype>=11  and c.ftype<=14 then (c.FAmountFor-isnull(hh.FcheckAmountFor,0))
   when c.ftype=100 then (c.FAmountFor-isnull(hh.FcheckAmountFor,0))
   when c.ftype=8   then (c.FAmountFor-isnull(hh.FcheckAmountFor,0))*(-1)
   when c.ftype=9   then (c.FAmountFor-isnull(hh.FcheckAmountFor,0))*(-1)
   when c.ftype=101 then (c.FAmountFor-isnull(hh.FcheckAmountFor,0))*(-1)
   when c.fIsBad=0 and (c.ftype>=5  and c.ftype<=6  or c.ftype>=15  and c.ftype<=16) then (c.FAmountFor-isnull(hh.FcheckAmountFor,0))*(-1)
   when c.fIsBad=1 and (c.ftype>=5  and c.ftype<=6  or c.ftype>=15  and c.ftype<=16) then 0 
   end )  FEndBalFor,
 sum(
   Case
      when c.ftype>=1  and c.ftype<=4  or c.ftype>=11  and c.ftype<=14 then (c.FAmount-isnull(hh.FcheckAmount,0))+isnull(y.FAdjustAmount,0)
      when c.ftype=100 then (c.FAmount-isnull(hh.FcheckAmount,0))+isnull(y.FAdjustAmount,0)
      when c.ftype=8   then (c.FAmount-isnull(hh.FcheckAmount,0))*(-1)+isnull(y.FAdjustAmount,0)
      when c.ftype=9   then (c.FAmount-isnull(hh.FcheckAmount,0))*(-1)+isnull(y.FAdjustAmount,0)
      when c.ftype=101 then (c.FAmount-isnull(hh.FcheckAmount,0))*(-1)+isnull(y.FAdjustAmount,0)
      when c.fIsBad=1 and (c.ftype>=5  and c.ftype<=6  or c.ftype>=15  and c.ftype<=16) then (c.FRemainAmount-isnull(y.FBadAdjustAmount,0))*(-1)
      when c.fIsBad=0 and (c.ftype>=5  and c.ftype<=6  or c.ftype>=15  and c.ftype<=16) then ((c.FAmount-isnull(hh.FcheckAmount,0))+isnull(y.FAdjustAmount,0))*(-1)
    end)  FEndBal,
    sum(ttt.FEndQty)  FEndQty
  From 
  t_rp_contact c
 left join(select FContactID,sum(case when FDate<'2021/1/1' then FAdjustAmount else 0 end) as FAdjustAmount, sum(case when FDate>='2021/1/1' then FAdjustAmount else 0 end) as FBadAdjustAmount from t_rp_adjustRate group by FContactID)y on c.FID=y.FContactID
 join t_item i on c.FCustomer=i.FItemID
  left join #tmpRPCheckInfo hh on c.FID=hh.FContactID
 left join t_item ii on c.FDepartment=ii.fitemid
 left join t_item iii on c.FEmployee=iii.fitemid
 left join #tmpArContStm h on c.FID=h.FContactID
 left join (select distinct FType_Src,FBillID_Src,FType From t_rp_checkentry) td on td.ftype_src=9 and c.fid=td.fbillid_src 
 left join (Select distinct FType,FVoucherID From t_rp_newbaddebt) tb on c.FVoucherID=tb.FVoucherID 
 left join (SELECT a.FID,a.FAuxQty - isnull(b.FCheckQuantity,0) as FEndQty    From    (        SELECT t1.FID,case when t1.FIsinit=1 then sum(t4.FQuantity) when t1.FIsinit=0 and t1.FRP=1 then sum(t2.FAuxQty) when t1.FIsinit=0 and t1.FRP=0 then sum(t3.FAuxQty) else 0 end as FAuxQty            FROM t_rp_Contact t1                left join ICSaleEntry t2 on t1.FRP=1 and t1.FInvoiceID=t2.FInterID                left join ICPurchaseEntry t3 on t1.FRP=0 and t1.FInvoiceID=t3.FInterID                left join t_rp_begdataEntry t4 on t1.FIsinit=1 and t1.FBegID = t4.FInterID        WHERE t1.FType in (3,4,13,14)        GROUP BY t1.FID,t1.FRP,t1.FIsinit    ) a    left join #tmpRPCheckInfo b on a.FID=b.FContactID) ttt on c.FID=ttt.FID  where c.FRP=1
 and c.FDate<'2021-01-01'
 and c.FItemClassID=1
 and i.FNumber>='01.ZS.DF.0074'
 and i.FNumber<='01.ZS.DF.0074'
 and ( c.FStatus & 16 )=0
 and c.FInvoiceType in(0,1,2)
 and c.FType not in(8,9) 
 and ( (c.FType=3 or c.FType=13 or (c.FType=9 and td.FType in (3,13)) or (c.FType=8 and tb.FType in (3,13))) or (c.FType=1 or c.FType=11 or (c.FType=9 and td.FType in (1,11)) or (c.FType=8 and tb.FType in (1,11))) or (c.FType in (5,15) and (c.FPre = 0 and c.FIsinit=0)))
 group by c.FCustomer,i.FNumber,i.FName
)a 




select c.FID,c.FBillID,d.FType,d.FIsinit
into #CheckEntry_SRC
From
(select distinct FID ,FContactID,FBillID
from t_rp_checkentry ) c 
join t_rp_Contact d on c.FContactID=d.FID and d.FDate>='2021-01-01' and d.FDate<='2022-12-31'




 insert #tempStmtMain (FCurrencyID,FInvoiceType,FID,FIsbad,FPre,FType,FIsinit,FK3Import,FRP,FInvoiceID,FRPBillID,FBillID,FBegID,FDate,FFIncDate,FNumber,
 FCustomer,FCustomerNumber,FCustomerName,FDepartmentNumber,FDepartmentName,FContractNo,
 FEmployeeName,FEmployeeNumber,FVchNumber,FVchName,FRPDate,
 FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,
 FDiscountAmount,FDiscountAmountfor,
 FSortCheckID,FSortDate,FSortType,FSortIsInit,FSortBillID,FBillType,FExplanation,FClassTypeID,FTranType,FSettleName,FSettleNo)
 select  1 FCurrencyID, 0 FInvoiceType,

  0 FID,0 FIsbad,0 FPre,-1 FType,3 FIsinit,0 Fk3import,0 FRP,0 FInvoiceID,0 FRPBillID,0 FBillID,0 FBegID, 
  '1900-01-01' FDate,'1900-01-01' FFincDate,''FNumber,c.FCustomer,k.FNumber FCustomerNumber,k.FName FCustomerNumber, 
 '' FDeptNumber,''FDeptName,'' FContractNO,''FEmpNumber,''FEmpName,''FVchNumber,''FVchName,null FRPDate,0 FAmount,0 FAmountFor,
 sum(case ty.FEquityHook when 1 then 0 else case when c.FQty=0  then c.FAmount else (c.FQty-isnull(tz.FHookQty,0))*c.FAmount/c.FQty end end) FRemainAmount,
 sum(case ty.FEquityHook when 1 then 0 else case when c.FQty=0  then c.FAmount else (c.FQty-isnull(tz.FHookQty,0))*c.FAmount/c.FQty end end) FRemainAmountFor,0 FDiscountAmount,0 FDiscountAmountfor,
 0 FSortID,'1900-01-01' FSortDate,-1 FSortType,3 FSortIsInit,-2 FSortBillID,0 FBillType,
 '' FExplanation,-1 FClassTypeID,0 FTranType,'*' as FSettleName,'*' as FSettleNo
From (
        select 0 FClassTypeID,b.FInterID as FInterID,a.FEntryID as FEntryID,0 as FID,0 FYear,0 FPeriod, 1 as FRP,
               80 FType,b.FDate as FDate, isnull(v.fdate,b.FDate) as FFincDate,b.FSettleDate FSettleDate,b.FBillNo as FNumber,0 as FPre,
               b.FSupplyID as FCustomer,isnull(b.FDeptID,0) as FDepartment,isnull(b.FEmpID,0) as FEmployee,1 FCurrencyID,1 FExchangeRate,a.FQty as FQty,
               a.FConsignAmount FAmount,a.FConsignAmount FAmountFor,
               a.FConsignAmount FRemainAmount,a.FConsignAmount FRemainAmountFor,
               0 as FIsBad,b.FVchInterID as FVoucherID,v.FGroupID as FGroupID,b.FCussentAcctID as FAccountID,0 as FIsInit,case when b.FStatus=0 then 0 else 1 end as FStatus,
               a.FConsignprice FPrice,'' as FDetailBillType,'' as FDetailBillTypeName,0 as FInvoiceType,
               1 FItemClassID,b.FExplanation FExplanation,0 FSubSystemID,v.FNumber FVchNumber,v1.FName FVchName,
               b.FTranType as FTranType,CAST(v1.FName AS Nvarchar(30))+'-'+CAST(v.FNumber AS Nvarchar(30))  as FVoucherNo,'' as FBillTypeName,
               f7.FName FAuxName, f4.FModel FModel,f6.FName FMeasureUnitName,f3.FNumber FInvNumber,f3.FName FInvName,f4.FPricedecimal FPriceScale,f4.FQtyDecimal FQtyScale,f6.FCoefficient 
               ,a.FOrderBillNo,a.FContractBillNo,a.FSourceBillNo,a.FSourceTranType 
            from icstockbill b
             join icstockbillentry a on b.FInterID=a.FInterID
             left join t_voucher v on b.FVchInterID=v.FVoucherID
             left join t_VoucherGroup v1 on v.FGroupID=v1.FGroupID
             left join t_item f3 on a.FItemID = f3.FItemID
             left join t_icitem f4 on a.FItemID = f4.FItemID
             left join t_measureunit f6 on a.funitid=f6.fmeasureunitid
             left join t_auxitem f7 on a.FAuxpropID=f7.FItemID
            where b.ftrantype = 21 and b.FCancellation<>1  and b.FInterID not in (select distinct FIBInterID From ICHookRelations Where FIBTag=4 And Ftrantype = 21 )) c
 left join (select fibinterid,fentryid,FEquityHook, sum(fhookqty) as fhookqty,ftrantype from  icHookRelations a
                join t_PeriodDate b on a.FYear=b.FYear and a.FPeriod=b.FPeriod
              where a.FIBTag=1 and b.FStartDate <='2022-12-31'
              group by fibinterid,fentryid,FEquityHook,ftrantype ) tz on c.finterid=tz.fibinterid and c.fentryid=tz.fentryid and c.ftrantype = tz.ftrantype
 left join (select distinct fibinterid,FEquityHook,ftrantype from  icHookRelations a
                join t_PeriodDate b on a.FYear=b.FYear and a.FPeriod=b.FPeriod
              where a.FIBTag=1 and b.FStartDate <='2022-12-31'
              group by fibinterid,FEquityHook,ftrantype ) ty on c.finterid=ty.fibinterid and c.ftrantype=ty.ftrantype
 left join t_item k on c.FCustomer = k.FItemID 
 left join t_item d on c.FDepartment = d.FItemID 
 left join t_item e on c.FEmployee = e.FItemID  
 where 1=1
 and c.FDate<'2021-01-01'
 and c.FItemClassID=1
 and k.FNumber>='01.ZS.DF.0074'
 and k.FNumber<='01.ZS.DF.0074'

 group by c.FCustomer,k.FNumber,k.FName
 insert #tempStmtMain (FCurrencyID,FInvoiceType,FID,FIsbad,FPre,FType,FIsinit,FK3Import,FRP,FInvoiceID,FRPBillID,FBillID,FBegID,FDate,FFIncDate,FNumber,
 FCustomer,FCustomerNumber,FCustomerName,FDepartmentNumber,FDepartmentName,FContractNo,
 FEmployeeName,FEmployeeNumber,FVchNumber,FVchName,FRPDate,
 FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,
 FDiscountAmount,FDiscountAmountfor,
 FSortCheckID,FSortDate,FSortType,FSortIsInit,FSortBillID,FBillType,FExplanation,FClassTypeID,FTranType,FSettleName,FSettleNo)
 select 0 FCurrencyID,   0 FInvoiceType,0 FID,0 FIsBad,0 FPre,-2 FType,2 FIsInit,0 Fk3import,0 FRP,0 FInvoiceID,0 FRPBillID,0 FBillID,0 FBegID, 
  '1900-01-01' FDate,'1900-01-01' FFincDate,''FNumber,a.FCustomer,a.FNumber FCustomerNumber,a.FName FCustomerNumber, 
 '' FDeptNumber,''FDeptName,'' FContractNo,''FEmpNumber,''FEmpName,''FVchNumber,''FVchName,null FRPDate,0 FAmount,0 FAmountFor,
a.FCheckAmount FRemainAmount,a.FCheckAmountFor FRemainAmountFor,0 FDiscountAmount,0 FDiscountAmountfor,
 0 FSortCheckID,'1900-01-01' FSortDate,-1 FSortType, 2 FSortIsInit,0 FSortBillID,0 FBillType,
 '' FExplanation,0 FClassTypeID,0 FTranType,'*' as FSettleName,'*' as FSettleNo
 from (
select x.FNumber,x.FName,x.FCustomer,isnull(sum(x.FCheckAmount*x.FBillType),0)FCheckAmount,
isnull(sum(x.FCheckAmountFor*x.FBillType),0)FCheckAmountFor from(
select  c.FNumber,c.FName,c.FCustomer, (case when ((c.ftype>=1  and c.ftype<=4) or(c.ftype>=11  and c.ftype<=14))  then -1
 when ((c.ftype>=5 and c.ftype<=6) or(c.ftype>=15  and c.ftype<=16)) then 1 end) FBillType,
 isnull(c.FCheckAmountFor,0) FCheckAmountFor,isnull(c.FCheckAmount,0) FCheckAmount from(select c.FContactID,c.FType,c.FCustomer, i.FNumber,i.FName,sum(isnull(c.FCheckAmount,0)) FCheckAmount,sum(isnull(c.FCheckAmountFor,0)) FCheckAmountFor from  ( Select a.FContactID,b.FCustomer,b.FDepartment,b.FEmployee,e.FTransfer,b.FCurrencyID,b.FType,e.FCheckDate,
b.FItemClassID , b.FRP, a.FCheckAmount, a.FCheckAmountFor
From (select FID,FContactID,FBillID,FType,FIsinit,FBillID_Src,FType_Src,FIsinit_Src,sum(FCheckAmount) FCheckAmount,sum(FCheckAmountFor) FCheckAmountFor
    From t_rp_checkentry
    Group By FID,FContactID,FBillID,FType,FIsinit,FBillID_Src,FType_Src,FIsinit_Src) a
join t_rp_Contact b on a.FContactID=b.FID and b.FDate<'2021-01-01'
join (select distinct FID,FCheckDate,FContactID,FTransFer,FisBad From t_rp_NewCheckInfo) e on a.FID=e.FID and e.FContactID=a.FContactID and isnull(e.fisbad,0)<>1 and e.FCheckDate>='2021-01-01' and e.FCheckDate<='2022-12-31'
join #CheckEntry_SRC c on a.FID=c.FID and a.FBillID_Src=c.FBillID and a.FType_Src=c.FType and a.FIsinit_Src = c.FIsinit union all
 select FContactID,FCustomer,FDepartment,FEmployee,FTransfer,FCurrencyID,FType,FCheckDate,FItemClassID,FRP,FCheckAmount,FCheckAmountFor
 from t_rp_newcheckinfo where fisbad=1
Union All
select FContactID,FCustomer,FDepartment,FEmployee,FTransfer,FCurrencyID,FType,FCheckDate,FItemClassID,FRP,FCheckAmount,FCheckAmountFor
 from t_rp_newcheckinfo where funtread = 1
 union all
 select a.fcontactid fcontactid,d.FCustomer , d.fdepartment, d.femployee, d.ftransfer, d.FCurrencyID, d.FType, d.fcheckdate, d.FItemClassID, d.frp, a.fcheckamount, a.fcheckamountfor       from t_rp_checkentry a     join t_rp_newcheckinfo d on d.fcontactid=a.fcontactid and d.fid=a.fid and d.fcheckdate>='2021-01-01' and d.fcheckdate<='2022-12-31'
     where a.ftype_src=9
 union all
 select FContactID,FCustomer,FDepartment,FEmployee,0 FTransfer,FCurrencyID,(case when ((ftype>=1  and ftype<=4) or(ftype>=11  and ftype<=14)) then 5 else 3 end)FType, FDate FCheckDate,FItemClassID,FRP, FAdjustAmount FCheckAmount,0 FCheckAmountFor
 from t_rp_adjustRate 
)c join t_rp_contact d on c.FContactID=d.FID
 join t_item i on c.fcustomer=i.fitemid
 left join t_item ii on c.FDepartment=ii.fitemid
 left join t_item iii on c.FEmployee=iii.fitemid
 left join (select distinct FType_Src,FBillID_Src,FType From t_rp_checkentry) td on td.ftype_src=9 and d.fid=td.fbillid_src 
 left join (Select distinct FType,FVoucherID From t_rp_newbaddebt) tb on d.FVoucherID=tb.FVoucherID 
 where (c.FRP=1 or(c.FRP=0 and c.FTransfer>0))
 and d.FRP=1
 and c.FCheckDate>='2021-01-01'
 and c.FCheckDate<='2022-12-31'
 and d.FDate<'2021-01-01'
 and c.FItemClassID=1
 and i.FNumber>='01.ZS.DF.0074'
 and i.FNumber<='01.ZS.DF.0074'
 and ( (d.FType=3 or d.FType=13 or (d.FType=9 and td.FType in (3,13)) or (d.FType=8 and tb.FType in (3,13))) or (d.FType=1 or c.FType=11 or (d.FType=9 and td.FType in (1,11)) or (d.FType=8 and tb.FType in (1,11))) or (d.FType in (5,15) and (d.FPre = 0 and d.FIsinit=0)))
 and ( d.FStatus & 16 )=0
 group by c.FContactID,c.FType,i.FNumber,i.FName,c.FCustomer )c
) x group by x.FNumber,x.FName,x.FCustomer
 ) a

SELECT * FROM #tempStmtMain

DROP TABLE #tempStmtMain
