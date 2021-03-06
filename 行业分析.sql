USE [AIS20100618152307]
GO
/****** 对象:  StoredProcedure [dbo].[FP_LoadVocationOutStockAmount]    脚本日期: 09/06/2011 09:24:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER Proc [dbo].[FP_LoadVocationOutStockAmountBak]
@StartDate as DateTime,
@EndDate   as DateTiME,
@FPVocation       as varchar(60),
@FCustVocation    as varchar(60),
@FOneofSet       as varchar(60),
@FStartClientNo  as varchar(80),
@FEndClientNo    as varchar(80),
@FStartItemNo    as varchar(80),
@FEndItemNo      as varchar(80)

AS

Set NoCount ON


Select 0 as flag,
	  Max(t4.Fname) as FCustName,
      t4.F_118 as FFPVocation,
      t7.Fname as FCustVocation,
      t4.F_112 as FOneofSet,
      Max(t5.Fnumber )as  FProdID,
      Max(t5.Fname) as FProdName,
    Sum(Fauxqty) as FAuxQty, --实发数量
      Sum(FQty) as FStockQty, --出库数量
      Max(t6.Fname) as FMeasurement,
      avg(t2.FConsignPrice) as FConsignPrice, --销售出库单价
      Sum(FAmount) as FAmount, --出库金额,
    Sum(FAuxQtyInvoice) as FAuxQtyInvoice, --开票数量,
      Sum(Fauxqty)-Sum(FAuxQtyInvoice) AS FAuxQtyUnInvoice, --未开票数量,
      Round(Sum(FAmount)*0.85472,2) as FAmountInvoice --开票金额
Into   #temp_VocationTable
From ICStockBill  t1
Left join ICStockBillEntry    t2 On t1.FinterID=t2.FinterID
Left join t_Organization      t4 On t4.FitemID=t1.FSupplyID
left join t_ICitem            t5 ON t2.FitemID=t5.FitemID
Left join t_MeasureUnit       t6 On t5.FProductUnitID=t6.FItemid
Left join t_Item              t7 On t4.F_117=t7.FitemID
--Left join t_Item              t8 On t7.FParentID=t8.FitemID

Where t1.Fdate>=@StartDate and t1.Fdate<=@EndDate
	and t1.FTranType=21
	and isnull(t7.Fname,'') like '%'+@FCustVocation+'%'
	and isnull(t4.F_118,'') Like '%'+@FPVocation+'%'
	and isnull(t4.F_112,'') Like '%'+@FOneofSet+'%'
	AND CASE WHEN @FStartItemNo='' THEN t5.Fnumber ELSE @FStartItemNo END<=t5.Fnumber
	AND CASE WHEN @FEndItemNo='' THEN t5.Fnumber ELSE @FEndItemNo END>=t5.Fnumber
	AND CASE WHEN @FStartClientNo='' THEN t4.Fnumber ELSE @FStartClientNo END<=t4.Fnumber
	AND CASE WHEN @FEndClientNo=''  THEN t4.Fnumber ELSE @FEndClientNo END>=t4.Fnumber

Group by t1.FSupplyID,t2.FitemID,t4.F_118,t7.Fname,t4.F_112

select FCustName as 客户名称,
      FFPVocation as 方普行业结构,
      FCustVocation as 客户所属行业,
      FOneofSet as 配套件,
      FProdID as 产品代码,
      FProdName as 产品名称,
    FAuxQty as 实发数量,
      FStockQty as 出库数量,
      FMeasurement as 计量单位,
      FConsignPrice as 销售出库单价,
      FAmount as 出库金额,
    FAuxQtyInvoice as 开票数量,
      FAuxQtyUnInvoice as 未开票数量,
      FAmountInvoice as 开票金额
from
(
Select FCustName,
      FFPVocation,
      FCustVocation,
      FOneofSet,
      FProdID,
      FProdName,
    FAuxQty, --实发数量
      FStockQty, --出库数量
      FMeasurement,
      FConsignPrice, --销售出库单价
      FAmount, --出库金额,
    FAuxQtyInvoice, --开票数量,
      FAuxQtyUnInvoice, --未开票数量,
      FAmountInvoice, --开票金额
      s0=0,s1=0,s2=FFPVocation,s3= FCustVocation,s4=FOneofSet
FROM #temp_VocationTable
UNION ALL
SELECT '小计','','','','','',sum(FAuxQty),sum(FStockQty),'',avg(FConsignPrice),
            sum(FAmount),sum(FAuxQtyInvoice),sum(FAuxQtyUnInvoice),
            sum(FAmountInvoice),s0=0,s1=1,s2=FFPVocation,s3= FCustVocation,s4=FOneofSet
FROM #temp_VocationTable
GROUP BY FFPVocation,FCustVocation,FOneofSet
UNION ALL
SELECT '合计','','','','','',sum(FAuxQty),sum(FStockQty),'',avg(FConsignPrice),
            sum(FAmount),sum(FAuxQtyInvoice),sum(FAuxQtyUnInvoice),
            sum(FAmountInvoice),s0=1,s1=2,s2='',s3='',s4=''
FROM #temp_VocationTable
GROUP BY flag
) as T
ORDER BY s0,s2,s3,s4,s1


--Select * From #temp_VocationTable1 Order by Flg,方普行业分类

Drop table #temp_VocationTable

Set NoCount OFF

-- =============================================
-- example to execute the store procedure
-- =============================================
--EXECUTE FP_LoadVocationOutStockAmountBak '2011-01-01','2011-09-09','','','','','','',''
