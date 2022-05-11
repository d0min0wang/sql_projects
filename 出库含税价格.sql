USE [AIS20140921170539]
GO
/****** Object:  StoredProcedure [dbo].[p_xy_order_fulfillment_Detail]    Script Date: 2014/10/28 15:06:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER   PROCEDURE [dbo].[p_xy_Outbound_Price]
	@QueryStartTime as datetime, --查询时间，格式：YYYY-MM-DD
	@QueryEndTime as datetime --查询时间，格式：YYYY-MM-DD
--SET @Querytime='2011-02-28'
AS
SET NOCOUNT ON
--SET ANSI_WARNINGS OFF

select --top 40 
--u1.FDetailID AS FListEntryID,
--0  AS FSel,
--t14.FName AS FPlanVchTplName,
--t13.FName AS FActualVchTplName,
--v1.FPlanVchTplID AS FPlanVchTplID,
--v1.FActualVchTplID AS FActualVchTplID,
--v1.FVchInterID AS FVchInterID,
--v1.FTranType AS FTranType,
--v1.FInterID AS FInterID,
--u1.FEntryID AS FEntryID,
'其他出库' AS FBillType,
v1.Fdate AS Fdate,
case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end AS FCheck,
--case when v1.FCancellation=1 then 'Y' else '' end AS FCancellation,
t4.FName AS FDeptIDName,
--v1.Fuse AS Fuse,
v1.FBillNo AS FBillNo,
t7.FName AS FDCStockIDName,
--t12.FNumber AS FFullNumber,
u1.FItemID AS FItemID,
t12.Fname AS FItemName,
t12.Fmodel AS FItemModel,
t15.FName AS FUnitIDName,
u1.Fauxqty AS Fauxqty,
u1.Fauxprice AS Fauxprice,
u1.Famount AS Famount,
t8.FName AS FFManagerIDName,
--t9.FName AS FSManagerIDName,
--t10.FName AS FuserName,
--t24.FName AS FCheckerName,
--u1.FNote AS FNote,
(SELECT (SELECT FName FROM t_VoucherGroup WHERE FGroupID=t_Voucher.FGroupID)+'-'+CONVERT(Varchar(30),FNumber)   FROM  t_Voucher  WHERE  FVoucherid=v1.FVchInterID)  AS FVoucherNumber,
--v1.FCheckDate AS FCheckDate,
--t34.FName AS FSupplyIDName,
--u1.FOrderBillNo AS FOrderBillNo,
--u1.FSourceBillNo AS FSourceBillNo,
--t70.FName AS FSourceTranType,
--t106.FName AS FEmpIDName,
--t107.FName AS FManagerIDName,
--t12.FQtyDecimal AS FQtyDecimal,
--t12.FPriceDecimal AS FPriceDecimal,
--t30.FName AS FBaseUnitID,
--u1.FQty AS FBaseQty,
--u1.FAuxPlanPrice AS FAuxPlanPrice,
--u1.FPlanAmount AS FPlanAmount,
--Case WHEN t12.FStoreUnitID=0 THEN '' Else  t500.FName end AS FCUUnitName,
--Case When v1.FCurrencyID is Null Or v1.FCurrencyID='' then (Select FScale From t_Currency Where FCurrencyID=1) else t503.FScale end   AS FAmountDecimal,
-- (CASE t510.FName WHEN '*' THEN '' ELSE t510.FName END)  AS FSPName,
--u1.FKFPeriod AS FKFPeriod,
--u1.FKFDate AS FKFDate,
--u1.FPeriodDate AS FPeriodDate,
--case when (v1.FROB <> 1) then 'Y' else '' end AS FRedFlag,
t530.FName AS FBillTypeName
--v1.FBillTypeID AS FBillTypeID,
--u1.FMapName AS FMapName,
--u1.FMapNumber AS FMapNumber,
-- (CASE t550.FName WHEN '*' THEN '' ELSE t550.FName END)  AS FRelateBrIDName,
--(CASE v1.FBrID WHEN 0 THEN NULL ELSE t560.FName END) AS FBrID,
--CASE WHEN v1.FTranStatus=1 THEN 'Y' ELSE '' END AS FTranStatus,
--t7.FNumber AS FDCStockIDNumber,
--t554.FName AS FSecUnitName,
--u1.FSecCoefficient AS FSecCoefficient,
--u1.FSecQty AS FSecQty,
--t1012.FName AS FHeadSelfB0935,
--t1013.FHELPCODE AS FEntrySelfB0936,
--t1014.FName AS FEntrySelfB0939 
into #temp_outstock
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
 LEFT OUTER JOIN t_Department t4 ON     v1.FDeptID = t4.FItemID   AND t4.FItemID <>0 
 INNER JOIN t_Stock t7 ON     u1.FDCStockID = t7.FItemID   AND t7.FItemID <>0 
 LEFT OUTER JOIN t_Emp t8 ON     v1.FFManagerID = t8.FItemID   AND t8.FItemID <>0 
 LEFT OUTER JOIN t_Emp t9 ON     v1.FSManagerID = t9.FItemID   AND t9.FItemID <>0 
 INNER JOIN t_User t10 ON     v1.FBillerID = t10.FUserID   AND t10.FUserID <>0 
 INNER JOIN t_ICItem t12 ON     u1.FItemID = t12.FItemID   AND t12.FItemID <>0 
 INNER JOIN t_MeasureUnit t15 ON     u1.FUnitID = t15.FItemID   AND t15.FItemID <>0 
 LEFT OUTER JOIN t_User t24 ON     v1.Fcheckerid = t24.FUserID   AND t24.FUserID <>0 
 LEFT OUTER JOIN t_MeasureUnit t30 ON     t12.FUnitID = t30.FMeasureUnitID   AND t30.FMeasureUnitID <>0 
 LEFT OUTER JOIN t_Organization t34 ON     v1.FSupplyID = t34.FItemID   AND t34.FItemID <>0 
 LEFT OUTER JOIN v_ICTransType t70 ON     u1.FSourceTranType = t70.FID   AND t70.FID <>0 
 LEFT OUTER JOIN ICVoucherTpl t14 ON     v1.FPlanVchTplID = t14.FInterID   AND t14.FInterID <>0 
 LEFT OUTER JOIN ICVoucherTpl t13 ON     v1.FActualVchTplID = t13.FInterID   AND t13.FInterID <>0 
 LEFT OUTER JOIN t_Emp t106 ON     v1.FEmpID = t106.FItemID   AND t106.FItemID <>0 
 LEFT OUTER JOIN t_Emp t107 ON     v1.FManagerID = t107.FItemID   AND t107.FItemID <>0 
 LEFT OUTER JOIN t_MeasureUnit t500 ON     t12.FStoreUnitID = t500.FItemID   AND t500.FItemID <>0 
 LEFT OUTER JOIN t_Currency t503 ON     v1.FCurrencyID = t503.FCurrencyID   AND t503.FCurrencyID <>0 
 LEFT OUTER JOIN t_StockPlace t510 ON     u1.FDCSPID = t510.FSPID   AND t510.FSPID <>0 
 LEFT OUTER JOIN ICBillType t530 ON     v1.FBillTypeID = t530.FID   AND t530.FID <>0 
 LEFT OUTER JOIN t_SonCompany t550 ON     v1.FRelateBrID = t550.FItemID   AND t550.FItemID <>0 
 LEFT OUTER JOIN t_MeasureUnit t554 ON     t12.FSecUnitID = t554.FItemID   AND t554.FItemID <>0 
 LEFT OUTER JOIN t_SonCompany t560 ON     v1.FBrID = t560.FItemID   AND t560.FItemID <>0 
 LEFT OUTER JOIN t_SubMessage t1012 ON   v1.FHeadSelfB0935 = t1012.FInterID  AND t1012.FInterID<>0 
 LEFT OUTER JOIN t_ICItem t1013 ON   u1.FItemID = t1013.FItemID  AND t1013.FItemID<>0 
 LEFT OUTER JOIN t_Account t1014 ON   u1.FEntrySelfB0939 = t1014.FAccountID  AND t1014.FAccountID<>0 
 where  
 (     
CONVERT(VARCHAR(10),v1.Fdate,120)>=CONVERT(VARCHAR(10),@QueryStarttime,120)
AND 
CONVERT(VARCHAR(10),v1.Fdate,120)<=CONVERT(VARCHAR(10),@QueryEndtime,120)   
--  AND  
--ISNULL(t4.FName,'') LIKE '%端子%'
  AND  
ISNULL(t7.FName,'') LIKE '%辅助%'
)  AND (v1.FTranType=29) --其他出库单
 --(v1.FInterID=1010749 and u1.FEntryID=1) or (v1.FInterID=1010749 and u1.FEntryID=2) or (v1.FInterID=1010749 and u1.FEntryID=4) or (v1.FInterID=1010749 and u1.FEntryID=5) or (v1.FInterID=1010749 and u1.FEntryID=10) or (v1.FInterID=1010749 and u1.FEntryID=6) or (v1.FInterID=1010749 and u1.FEntryID=9) or (v1.FInterID=1010749 and u1.FEntryID=3) or (v1.FInterID=1010749 and u1.FEntryID=7) or (v1.FInterID=1010749 and u1.FEntryID=8) 
 order by ISNULL(t4.FName,'')  ASC ,ISNULL(t530.FName,'')  ASC, v1.FInterID,u1.FEntryID

 INSERT INTO #temp_outstock 
select --top 40 
--u1.FDetailID AS FListEntryID,
--0  AS FSel,
--t14.FName AS FPlanVchTplName,
--t15.FName AS FActualVchTplName,
--v1.FPlanVchTplID AS FPlanVchTplID,
--v1.FActualVchTplID AS FActualVchTplID,
--v1.FVchInterID AS FVchInterID,
--v1.FTranType AS FTranType,
--v1.FInterID AS FInterID,
--u1.FEntryID AS FEntryID,
'生产领料',
v1.Fdate AS Fdate,
case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end AS FCheck,
--case when v1.FCancellation=1 then 'Y' else '' end AS FCancellation,
t4.FName AS FDeptIDName,
v1.FBillNo AS FBillNo,
t8.FName AS FSCStockIDName,
--t13.FNumber AS FFullNumber,
u1.FItemID AS FItemID,
t13.Fname AS FItemName,
t13.Fmodel AS FItemModel,
t16.FName AS FUnitIDName,
u1.Fauxqty AS Fauxqty,
u1.Fauxprice AS Fauxprice,
u1.Famount AS Famount,
--t23.Fname AS FBaseUnit,
t9.FName AS FSManagerIDName,
(SELECT (SELECT FName FROM t_VoucherGroup WHERE FGroupID=t_Voucher.FGroupID)+'-'+CONVERT(Varchar(30),FNumber)   FROM  t_Voucher  WHERE  FVoucherid=v1.FVchInterID)  AS FVoucherNumber,
'生产领料'
--t13.FQtyDecimal AS FQtyDecimal,
--t13.FPriceDecimal AS FPriceDecimal,
--t30.FName AS FBaseUnitID,
--Case WHEN t13.FStoreUnitID=0 THEN '' Else  t500.FName end AS FCUUnitName,
--Case When v1.FCurrencyID is Null Or v1.FCurrencyID='' then (Select FScale From t_Currency Where FCurrencyID=1) else t503.FScale end   AS FAmountDecimal,
--case when (v1.FROB <> 1) then 'Y' else '' end AS FRedFlag,
--t512.FName AS FSecUnitName,
--u1.FSecCoefficient AS FSecCoefficient,
--u1.FSecQty AS FSecQty,
--tic.FFinClosed AS FFinClosed 
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
 LEFT OUTER JOIN t_Department t4 ON     v1.FDeptID = t4.FItemID   AND t4.FItemID <>0 
 INNER JOIN t_Stock t8 ON     u1.FSCStockID = t8.FItemID   AND t8.FItemID <>0 
 LEFT OUTER JOIN t_Emp t9 ON     v1.FSManagerID = t9.FItemID   AND t9.FItemID <>0 
 INNER JOIN t_ICItem t13 ON     u1.FItemID = t13.FItemID   AND t13.FItemID <>0 
 INNER JOIN t_MeasureUnit t16 ON     u1.FUnitID = t16.FItemID   AND t16.FItemID <>0 
 INNER JOIN t_MeasureUnit t23 ON     t13.FUnitID = t23.FItemID   AND t23.FItemID <>0 
 LEFT OUTER JOIN t_MeasureUnit t30 ON     t13.FUnitID = t30.FMeasureUnitID   AND t30.FMeasureUnitID <>0 
 LEFT OUTER JOIN ICMO tic ON   u1.FICMOInterID = tic.FInterID  AND tic.FInterID<>0 
 LEFT OUTER JOIN ICVoucherTpl t14 ON     v1.FPlanVchTplID = t14.FInterID   AND t14.FInterID <>0 
 LEFT OUTER JOIN ICVoucherTpl t15 ON     v1.FActualVchTplID = t15.FInterID   AND t15.FInterID <>0 
 LEFT OUTER JOIN t_MeasureUnit t500 ON     t13.FStoreUnitID = t500.FItemID   AND t500.FItemID <>0 
 LEFT OUTER JOIN t_Currency t503 ON     v1.FCurrencyID = t503.FCurrencyID   AND t503.FCurrencyID <>0 
 LEFT OUTER JOIN t_MeasureUnit t512 ON     t13.FSecUnitID = t512.FItemID   AND t512.FItemID <>0 
where(  
CONVERT(VARCHAR(10),v1.Fdate,120)>=CONVERT(VARCHAR(10),@QueryStarttime,120)
AND 
CONVERT(VARCHAR(10),v1.Fdate,120)<=CONVERT(VARCHAR(10),@QueryEndtime,120)   
--  AND  
--ISNULL(t4.FName,'') LIKE '%端子%'
--  AND  
--ISNULL(t7.FName,'') LIKE '%辅助%'
)  AND (v1.FTranType=24) --生产领料单
 --(v1.FInterID=1010749 and u1.FEntryID=1) or (v1.FInterID=1010749 and u1.FEntryID=2) or (v1.FInterID=1010749 and u1.FEntryID=4) or (v1.FInterID=1010749 and u1.FEntryID=5) or (v1.FInterID=1010749 and u1.FEntryID=10) or (v1.FInterID=1010749 and u1.FEntryID=6) or (v1.FInterID=1010749 and u1.FEntryID=9) or (v1.FInterID=1010749 and u1.FEntryID=3) or (v1.FInterID=1010749 and u1.FEntryID=7) or (v1.FInterID=1010749 and u1.FEntryID=8) 
 order by ISNULL(t4.FName,'')  ASC , v1.FInterID,u1.FEntryID


 --select distinct FItemID from #temp_outstock

select CONVERT(char(6),v1.FDate,112) AS FDate,
	u1.FItemID ,
	AVG(u1.FEntrySelfA0154) AS FEntrySelfA0154
into #temp_Price
from ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
where u1.FItemID IN (select distinct FItemID from #temp_outstock)
and u1.FEntrySelfA0154>0
group by u1.FItemID,CONVERT(char(6),v1.FDate,112)

select max(FDate) AS FDate,FItemID as FItemID into #Tmp from #temp_Price group by FItemID

select t1.FDate,t1.FItemID,t2.FEntrySelfA0154  
into #Tmp2
from #Tmp t1
left join #temp_Price t2 on t1.FDate =t2.FDate and t1.FItemID =t2.FItemID 

truncate table #temp_Price

insert into #temp_Price select * from #Tmp2

--select * from #temp_Price
 --v1.Fdate AS Fdate,
-- u1.FEntrySelfA0154 AS FEntrySelfA0154, --含税单价
--u1.FEntrySelfA0152 AS FEntrySelfA0152 --含税价格 from ICStockBill v1 
--INNER JOIN ICStockBillEntry u1
--v1.FTranType=1

select t1.FBillType AS 单据类型,
	t1.Fdate AS 出库日期,
	t1.FCheck AS 审核标志,
	t1.FDeptIDName AS 领用部门,
	t1.FBillNo AS 单据编号,
	t1.FDCStockIDName AS 发货仓库,
	t1.FItemName AS 产品名称,
	t1.FItemModel AS 规格型号,
	t1.FUnitIDName AS 单位,
	t1.Fauxqty AS 数量,
	t1.Fauxprice AS 单价,
	t1.Famount AS 金额,
	t2.FEntrySelfA0154 AS 含税单价,
	t2.FEntrySelfA0154*t1.Fauxqty AS 含税价格,
	t1.FFManagerIDName AS 领料人,
	t1.FVoucherNumber AS 凭证字号,
	t1.FBillTypeName AS 出库类型
from #temp_outstock t1
left join #temp_Price t2 on t1.FItemID=t2.FItemID 


drop table #temp_outstock
drop table #temp_Price
drop table #Tmp
drop table #Tmp2

-- =============================================
-- EXECUTE p_xy_Outbound_Price '2014-09-01','2014-09-08'
-- =============================================