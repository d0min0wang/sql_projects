select * from t_TableDescription where FDescription like '%成本%'

select * from ICReportProfile
--1====================================================
SET NOCOUNT ON 
 Create Table #Rpt2005002(
 FYearPeriod varchar(20) default(''),
 FICMOID int NOT NULL Default(0),
 FICMONO  varchar(255)   default(''),
 FMTONo  varchar(255)   default(''),
 FCostObjID int NOT NULL default (0),
 FCostObjNumber varchar(255),
 FCostObjName varchar(255),
 FMode varchar(255),
 FUnit varchar(20),
 FPlanQty  Decimal(28,10) Not Null Default(0),
 FCstGrpID int ,
 FCostCenterID int NOT NULL Default(0), 
 FCostCenterNumber  varchar(255),
 FCostCenterName    varchar(255),
 FCostItemID      int,
 FCostItemNumber  varchar(255),
 FCostItemName    varchar(255),
 FQty1_1 Decimal(28,10) Not Null Default(0),  --期初在产
 FQty1_2 Decimal(28,10) Not Null Default(0),
 FAmount1  Decimal(28,10) Not Null Default(0),
 FQty2 Decimal(28,10) Not Null Default(0),    --本期投入
 FAmount2 Decimal(28,10) Not Null Default(0),
 FProductCount  Decimal(28,10) Not Null Default(0),
 FQty3_1 Decimal(28,10) Not Null Default(0),  --期末在产
 FQty3_2 Decimal(28,10) Not Null Default(0),
 FAmount3 Decimal(28,10) Not Null Default(0),
 FCount3 Decimal(28,10) Not Null Default(0),
 FQty4 Decimal(28,10) Not Null Default(0),    --本期完工
 FAmount4 Decimal(28,10) Not Null Default(0),
 FCount Decimal(28,10) Not Null Default(0),
 FUnitCount Decimal(28,10) Not Null Default(0),
 FTotalQty Decimal(28,10) Not Null Default(0),
 FTotalAmount Decimal(28,10) Not Null Default(0),
 FType smallint,
 FLS smallint Not Null Default(0),
 FSumSort smallint Not Null Default(0) 
 )
--2=======================================================
  ----期初在产品产量----
 Insert Into #Rpt2005002 (FYearPeriod,FICMOID,FICMONO,FMTONo,FCostObjID,FCostObjNumber,FCostObjName,FMode,FUnit,FPlanQty,FCostCenterID,FCostCenterNumber,FCostCenterName,
                          FQty1_1,FQty1_2,FType)
      select w1.FYearPeriod,w1.FICMOInterID,w5.FBillno as FICMONO,w5.FMTONo as FMTONo,w5.FCostObjID,w8.FNumber as FCostObjNumber,w8.FName as FCostObjName, n1.FModel as FMode,n5.FName as FUnit,
           w5.FQty as FPlanQty,w1.FCostCenterID,n8.FNumber as FCostCenterNumber ,n8.FName as FCostCenterName, 
           w1.FBegNotStockQty as FQty1_1, w1.FQty as FQty1_2, 7 
      from opcostbalance w1
           inner join  icmo w5 on w1.FICMOInterID=w5.FInterID
           inner join cbcostobj w8 on w8.FItemID=w5.FCostObjID
           inner join t_icitem n1 on n1.FItemID=w5.FItemID
           inner join t_measureunit n5 on n5.FMeasureUnitID=n1.FUnitID
           left join t_base_costcenter n8 on n8.FItemID=w1.FCostCenterID
      Where w1.FTypeID=1 
  ----期初在产品成本----
  ------汇总------
 Insert Into #Rpt2005002 (FYearPeriod,FICMOID,FICMONO,FMTONo,FCostObjID,FCostObjNumber,FCostObjName,FMode,FUnit,FPlanQty,FCostCenterID,FCostCenterNumber,FCostCenterName,
                          FAmount1,FType)
      select  w1.FYearPeriod,w1.FICMOInterID,w5.FBillno as FICMONO,w5.FMTONo as FMTONo,w5.FCostObjID,w8.FNumber as FCostObjNumber,w8.FName as FCostObjName, n1.FModel as FMode,n5.FName as FUnit,
           w5.FQty as FPlanQty,w1.FCostCenterID,n8.FNumber as FCostCenterNumber ,n8.FName as FCostCenterName, 
            w1.FBegBal as FAmount1, 7 
      from opcostbalance w1
           inner join  icmo w5 on w1.FICMOInterID=w5.FInterID
           inner join cbcostobj w8 on w8.FItemID=w5.FCostObjID
           inner join t_icitem n1 on n1.FItemID=w5.FItemID
           inner join t_measureunit n5 on n5.FMeasureUnitID=n1.FUnitID
           left join t_base_costcenter n8 on n8.FItemID=w1.FCostCenterID
           inner join cbcostItem t1 on t1.FItemID =w1.FCostItemID
  AND w1.FBegBal<>0 
  AND w1.FCostItemID<>-1 
      Where w1.FTypeID=2 
  ------分成本项目------
 Insert Into #Rpt2005002 (FYearPeriod,FICMOID,FICMONO,FMTONo,FCostObjID,FCostObjNumber,FCostObjName,FMode,FUnit,FPlanQty,FCostCenterID,FCostCenterNumber,FCostCenterName,FCostItemID,FCostItemNumber,FCostItemName,
                          FAmount1,FType)
      select  w1.FYearPeriod,w1.FICMOInterID,w5.FBillno as FICMONO,w5.FMTONo as FMTONo,w5.FCostObjID,w8.FNumber as FCostObjNumber,w8.FName as FCostObjName, n1.FModel as FMode,n5.FName as FUnit,
           w5.FQty as FPlanQty,w1.FCostCenterID,n8.FNumber as FCostCenterNumber ,n8.FName as FCostCenterName, t1.FItemID as FCostItemID, t1.FNumber AS FCostItemNumber, t1.FName as FCostItemName, 
            w1.FBegBal as FAmount1, 2 
      from opcostbalance w1
           inner join  icmo w5 on w1.FICMOInterID=w5.FInterID
           inner join cbcostobj w8 on w8.FItemID=w5.FCostObjID
           inner join t_icitem n1 on n1.FItemID=w5.FItemID
           inner join t_measureunit n5 on n5.FMeasureUnitID=n1.FUnitID
           left join t_base_costcenter n8 on n8.FItemID=w1.FCostCenterID
           inner join cbcostItem t1 on t1.FItemID =w1.FCostItemID
  AND w1.FBegBal<>0 
  AND w1.FCostItemID<>-1 
      Where w1.FTypeID=2 
----汇总--本期投入数量2---投入金额是反算的---
 Insert Into #Rpt2005002 (FYearPeriod,FICMOID,FICMONO,FMTONo,FCostObjID,FCostObjNumber,FCostObjName,FMode,FUnit,FPlanQty,FCostCenterID,FCostCenterNumber,FCostCenterName,
                           FQty2,FAmount2, FType)
       select w1.FYearPeriod,w1.FICMOInterID,w5.FBillno as FICMONO,w5.FMTONo as FMTONo,w5.FCostObjID,w8.FNumber as FCostObjNumber,w8.FName as FCostObjName, n1.FModel as FMode,n5.FName as FUnit,
               w5.FQty as FPlanQty,w1.FCostCenterID,n8.FNumber as FCostCenterNumber ,n8.FName as FCostCenterName,
               w1.FInputQty as FQty2, 0, 7 
       from OPCostWIPCheck w1
               inner join  icmo w5 on w1.FICMOInterID=w5.FInterID
               inner join cbcostobj w8 on w8.FItemID=w5.FCostObjID
               inner join t_icitem n1 on n1.FItemID=w5.FItemID
               inner join t_measureunit n5 on n5.FMeasureUnitID=n1.FUnitID
               left join t_base_costcenter n8 on n8.FItemID=w1.FCostCenterID
      Where 1=1 
  ----期末在产产量3----
 Insert Into #Rpt2005002 (FYearPeriod,FICMOID,FICMONO,FMTONo,FCostObjID,FCostObjNumber,FCostObjName,FMode,FUnit,FPlanQty,FCostCenterID,FCostCenterNumber,FCostCenterName,
                           FQty3_1,FQty3_2,FType)
       select  w1.FYearPeriod,w1.FICMOInterID,w5.FBillno as FICMONO,w5.FMTONo as FMTONo,w5.FCostObjID,w8.FNumber as FCostObjNumber,w8.FName as FCostObjName, n1.FModel as FMode,n5.FName as FUnit,
               w5.FQty as FPlanQty,w1.FCostCenterID,n8.FNumber as FCostCenterNumber ,n8.FName as FCostCenterName,
               w1.FNotStockQty as FQty3_1, w1.FWipQty as FQty3_2, 7 
       from OPCostCalICMODetailQty w1
               inner join  icmo w5 on w1.FICMOInterID=w5.FInterID
               inner join cbcostobj w8 on w8.FItemID=w5.FCostObjID
               inner join t_icitem n1 on n1.FItemID=w5.FItemID
               inner join t_measureunit n5 on n5.FMeasureUnitID=n1.FUnitID
               left join t_base_costcenter n8 on n8.FItemID=w1.FCostCenterID
      Where 1=1 
  ----本期完工数量----
 Insert Into #Rpt2005002 (FYearPeriod,FICMOID,FICMONO,FMTONo,FCostObjID,FCostObjNumber,FCostObjName,FMode,FUnit,FPlanQty,FCostCenterID,FCostCenterNumber,FCostCenterName,FQty4,FType)
       select  Distinct w1.FYearPeriod,w1.FICMOInterID,w5.FBillno as FICMONO,w5.FMTONo as FMTONo,w5.FCostObjID,w8.FNumber as FCostObjNumber,w8.FName as FCostObjName, n1.FModel as FMode,n5.FName as FUnit,
               w5.FQty as FPlanQty,t5.FCostCenterID,n8.FNumber as FCostCenterNumber ,n8.FName as FCostCenterName,w1.FCompleteQty as FQty4, 7 
       from OPCostCalICMOInfo w1
               inner join  icmo w5 on w1.FICMOInterID=w5.FInterID
               inner join cbcostobj w8 on w8.FItemID=w5.FCostObjID
               inner join t_icitem n1 on n1.FItemID=w5.FItemID
               inner join t_measureunit n5 on n5.FMeasureUnitID=n1.FUnitID
               inner join OPCostCalInfo t5 on t5.FICMOInterID = w1.FICMOInterID and w1.FYearPeriod=t5.FYearPeriod 
               left join t_base_costcenter n8 on t5.FCostCenterID= n8.FItemID
      Where 1=1 
  ----本期完工成本和在产品成本4----
  ------汇总----
 Insert Into #Rpt2005002 (FYearPeriod,FICMOID,FICMONO,FMTONo,FCostObjID,FCostObjNumber,FCostObjName,FMode,FUnit,FPlanQty,FCostCenterID,FCostCenterNumber,FCostCenterName,FAmount4,FAmount3,FType)
       select  w1.FYearPeriod,w1.FICMOInterID,w5.FBillno as FICMONO,w5.FMTONo as FMTONo,w5.FCostObjID,w8.FNumber as FCostObjNumber,w8.FName as FCostObjName, n1.FModel as FMode,n5.FName as FUnit,
               w5.FQty as FPlanQty,t5.FCostCenterID,n8.FNumber as FCostCenterNumber ,n8.FName as FCostCenterName,t5.FOverAmount as FAmount4, t5.FOnlineAmount as FAmount3, 7 
       from OPCostCalICMOInfo w1
               inner join  icmo w5 on w1.FICMOInterID=w5.FInterID
               inner join cbcostobj w8 on w8.FItemID=w5.FCostObjID
               inner join t_icitem n1 on n1.FItemID=w5.FItemID
               inner join t_measureunit n5 on n5.FMeasureUnitID=n1.FUnitID
               inner join OPCostCalInfo t5 on t5.FICMOInterID = w1.FICMOInterID and w1.FYearPeriod=t5.FYearPeriod 
               left join t_base_costcenter n8 on t5.FCostCenterID= n8.FItemID
      Where 1=1 
  ------分成本项目----
 Insert Into #Rpt2005002 (FYearPeriod,FICMOID,FICMONO,FMTONo,FCostObjID,FCostObjNumber,FCostObjName,FMode,FUnit,FPlanQty,FCostCenterID,FCostCenterNumber,FCostCenterName,FCostItemID,FCostItemNumber,FCostItemName,
                          FAmount4,FAmount3,FType)
       select  w1.FYearPeriod,w1.FICMOInterID,w5.FBillno as FICMONO,w5.FMTONo as FMTONo,w5.FCostObjID,w8.FNumber as FCostObjNumber,w8.FName as FCostObjName, n1.FModel as FMode,n5.FName as FUnit,
               w5.FQty as FPlanQty,t5.FCostCenterID,n8.FNumber as FCostCenterNumber ,n8.FName as FCostCenterName,t1.FItemID as FCostItemID,t1.FNumber As FCostItemNumber,t1.FName as FCostItemName,
               t5.FOverAmount as FAmount4, t5.FOnlineAmount as FAmount3, 2 
       from OPCostCalICMOInfo w1
               inner join  icmo w5 on w1.FICMOInterID=w5.FInterID
               inner join cbcostobj w8 on w8.FItemID=w5.FCostObjID
               inner join t_icitem n1 on n1.FItemID=w5.FItemID
               inner join t_measureunit n5 on n5.FMeasureUnitID=n1.FUnitID
               left join OPCostCalInfo t5 on t5.FICMOInterID = w1.FICMOInterID and w1.FYearPeriod=t5.FYearPeriod 
               left join t_base_costcenter n8 on t5.FCostCenterID= n8.FItemID
               inner join cbcostItem t1 on t1.FItemID =t5.FCostItemID
      Where 1=1 
Insert Into #Rpt2005002 (FYearPeriod,FICMOID,FICMONO,FMTONo,FCostObjID,FCostObjNumber,FCostObjName,FMode,FUnit,
             FPlanQty,FCostCenterID, FCostCenterNumber,FCostCenterName,
             FCostItemID,FCostItemNumber,FCostItemName,FQty1_1,FQty1_2,FAmount1,
             FQty2,FAmount2,FProductCount,FQty3_1,FQty3_2,FAmount3,FCount3,
             FQty4,FAmount4,FCount,FUnitCount,FTotalQty,FTotalAmount,FSumSort)
       select distinct w1.FYearPeriod,w1.FICMOID,w1.FICMONO,w1.FMTONo,w1.FCostObjID,w1.FCostObjNumber,w1.FCostObjName,w1.FMode,w1.FUnit,
             w1.FPlanQty,w1.FCostCenterID, w1.FCostCenterNumber,w1.FCostCenterName,
             w2.FItemID,w2.FNumber,w2.FName,w1.FQty1_1,w1.FQty1_2,w1.FAmount1,
             w1.FQty2,w1.FAmount2,w1.FProductCount,w1.FQty3_1,w1.FQty3_2,w1.FAmount3,w1.FCount3,
             w1.FQty4 , w1.FAmount4, w1.FCount, w1.FUnitCount, w1.FTotalQty, w1.FTotalAmount, w1.FSumSort
       from #Rpt2005002 w1
             cross join (select distinct aa.* from cbcostitem aa inner join opcostcalinfo bb on aa.FItemID=bb.FCostItemID) w2
       Where 1 = 1 And ( (w1.FCostItemNumber Is Null)) and w1.FICMOID not in 
             ( select distinct FICMOID from #Rpt2005002 where FCostItemID>0 ) 
             
       order by w1.FYearPeriod,w1.FICMOID,w1.FICMONO,w1.FCostObjID,w1.FCostObjNumber,w1.FCostObjName
--3=========================================================

 Insert into #RptR2005002 ( 
   FYearPeriod,FICMOID,FICMONo,FMTONo,FCostObjID,FCostObjNumber,FCostObjName,FMode,FUnit,
   FPlanQty,FCstGrpID,FCostCenterID,FCostCenterNumber,FCostCenterName,FCostItemID, FCostItemNumber, FCostItemName,
   FQty1_1,FQty1_2,FAmount1,FQty2,FAmount2,FProductCount,FQty3_1,FQty3_2,FAmount3,FCount3,
   FQty4,FAmount4,FCount,FUnitCount,FTotalQty,FTotalAmount,FColorType,FSumSort)
SELECT FYearPeriod, FICMOID, FICMONo,FMTONo,FCostObjID, FCostObjNumber, FCostObjName,FMode,FUnit,   Max(FPlanQty) as FPlanQty,FCstGrpID,FCostCenterID, FCostCenterNumber, FCostCenterName,
   FCostItemID, FCostItemNumber, CASE WHEN FType=7 THEN '(小计)' ELSE FCostItemName END AS FCostItemName,
   SUM(FQty1_1) as FQty1_1,SUM(FQty1_2) as FQty1_2,SUM(FAmount1) as FAmount1,
   SUM(FQty2) as FQty2,SUM(FAmount2) as FAmount2,SUM(FProductCount) as FProductCount,
   SUM(FQty3_1) as FQty3_1,SUM(FQty3_2) as FQty3_2,SUM(FAmount3) as FAmount3,SUM(FCount3) as FCount3,
   SUM(FQty4) as FQty4,SUM(FAmount4) as FAmount4,SUM(FCount) as FCount,SUM(FUnitCount) as FUnitCount,
   SUM(FTotalQty) as FTotalQty,SUM(FTotalAmount) as FTotalAmount,
   FType AS FColorType, CASE WHEN FType=7 THEN 113 ELSE 0 END AS FSumSort 
FROM #Rpt2005002 
WHERE 1=1   AND FICMONO >= '68358'  AND FICMONO <= '68358' 
GROUP BY FYearPeriod,FICMONo,FMTONo,FICMOID,FCostObjNumber,FCostObjName,FCostObjID,FMode,FUnit,FCstGrpID,FCostCenterNumber,FCostCenterName,FCostCenterID, FCostItemNumber, FCostItemName,FCostItemID,FType

  DELETE #RptR2005002 WHERE         FICMONO='' AND FCostObjNumber='' AND FCostObjName='' AND FMode='' 
        AND FUnit='' AND FPlanQty=0 AND FCostCenterNumber='' 
        AND FCostCenterName='' AND FCostItemID=0 AND FCostItemName='' AND FQty1_1=0 
        AND FQty1_2=0 AND FProductCount=0 AND FAmount1=0 And FAmount2=0 AND FAmount3=0 AND FAmount4=0 
update #RptR2005002 Set FAmount2 = FAmount4+FAmount3-FAmount1 
 ----成本中心无发生额时不显示----
 Delete from #RptR2005002 
 where FAmount2=0 AND FAmount4=0 