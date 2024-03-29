Set NoCount On Set Ansi_Warnings Off

DECLARE @FStartDate NVARCHAR(10)
DECLARE @FEndDate NVARCHAR(10)

set @FStartDate=DATEFROMPARTS(YEAR(GETDATE()), 1, 1)
set @fenddate= DATEFROMPARTS(YEAR(GETDATE()), 12, 31)

--SELECT @fstartdate,@fenddate

 Create Table #Happen_New(
        FItemID int Null,
        FStockID int Null,
        FStockPlaceID int Null, 
        FBatchNo Varchar(200),
        FMTONo NVarchar(100),
        FAuxPropID INT NOT NULL DEFAULT(0),
        FBegQty decimal(28,10),
        FBegBal decimal(28,10),
        FInQty  decimal(28,10),
        FInPrice  decimal(28,10),
        FInAmount decimal(28,10),
        FOutQty decimal(28,10),
        FOutPrice  decimal(28,10),
        FOutAmount decimal(28,10),
FInSecQty Decimal(28,10) Default(0),
FOutSecQty Decimal(28,10) Default(0),
FBegSecQty Decimal(28,10) Default(0),        FBegCUUnitQty decimal(28,10),
        FInCUUnitQty decimal(28,10),
        FOutCUUnitQty decimal(28,10))
 Insert Into #Happen_New
 Select  v2.FItemID,v2.FStockID,Isnull(v2.FStockPlaceID,0),v2.FBatchNo,v2.FMTONo,v2.FAuxPropID,
      Sum (v2.FBegQty), case when t1.FTrack = 81 Then Sum(Round(v2.FBegBal,2) - Round(v2.FBegDiff,2)) Else Sum(Round(v2.FBegBal,2)) End ,0,0,0,0,0,0,
      0,0,Sum(v2.FSecBegQty),0,0,0
 From (Select 
ic.FBrNo, ic.FYear, ic.FPeriod, ic.FStockID, ic.FItemID, ic.FBatchNo, ic.FBegQty,
ic.FReceive, ic.FSend, ic.FYtdReceive, ic.FYtdSend, ic.FEndQty, ic.FBegBal,
ic.FDebit, ic.FCredit, ic.FYtdDebit, ic.FYtdCredit, ic.FEndBal, ic.FBegDiff,
ic.FReceiveDiff, ic.FSendDiff, ic.FEndDiff, ic.FBillInterID, ic.FStockPlaceID,
ic.FKFPeriod, ic.FKFDate, ic.FYtdReceiveDiff, ic.FYtdSendDiff, ic.FSecBegQty,
ic.FSecReceive, ic.FSecSend, ic.FSecYtdReceive, ic.FSecYtdSend,
ic.FSecEndQty , ic.FAuxPropID, ic.FStockInDate, ic.FMTONo, ic.FSupplyID
From ICInvBal ic
Left Join t_Stock tzz on tzz.FItemid=ic.FStockID
Where tzz.FTypeID <> 504
Union All
select
FBrNo, FYear, FPeriod, FStockID, FItemID, FBatchNo, FBegQty,
FReceive, FSend, FYtdReceive, FYtdSend, FEndQty, FBegBal,
FDebit, FCredit, FYtdDebit, FYtdCredit, FEndBal, FBegDiff,
FReceiveDiff, FSendDiff, FEndDiff, FBillInterID, FStockPlaceID,
FKFPeriod, FKFDate, FYtdReceiveDiff, FYtdSendDiff, FSecBegQty,
FSecReceive, FSecSend, FSecYtdReceive, FSecYtdSend,
FSecEndQty , FAuxPropID, FStockInDate, FMTONo, FSupplyID
From ICVMIInvBal 
Union All
--Select '0',2023,1,v2.FDCStockID,v2.FItemID,isnull(v2.FBatchNo,''),0,
Select '0',year(@fstartdate),month(@fstartdate),v2.FDCStockID,v2.FItemID,isnull(v2.FBatchNo,''),0,

0,0,0,0,0,Round(v2.FAmount,2) as FBegBal,
0,0,0,0,0,0,
0,0,0,0,Isnull(v2.FDCSPID,0),
v2.FKFPeriod,isnull(v2.FKFDate,''),0,0,0,
0,0,0,0,
0,v2.FAuxPropID,v1.FDate, isnull(v2.FMTONo,''),v2.FEntrySupply
 From ICStockBill v1 
 Inner Join ICStockBillEntry v2  On v1.FInterID=v2.FInterID 
 Left Join t_Stock t2 On v2.FDCStockID=t2.FItemID 
 Where v1.FTranType = 101 
 --And v1.FDate < '2023-01-01'
 And v1.FDate < @fstartdate

 And v1.FStatus>0 And v1.FCancelLation=0 
 And isnull(v1.FPoMode,0)=36681 AND t2.FTypeID=504 
 AND isnull(t2.FIncludeAccounting,0) =1 
) v2 
 Left Join t_ICItem t1  On v2.FItemID=t1.FItemID
 Left Join t_Stock t2 On v2.FStockID=t2.FItemID
 Left Join t_StockPlace t11 On v2.FStockPlaceID=t11.FSPID

 --Where v2.FYear=2023 And v2.FPeriod=1
 Where v2.FYear=year(@fstartdate) And v2.FPeriod=month(@fstartdate)

 AND isnull(t2.FIncludeAccounting,0) =1
 And t1.FNumber>='93.A.DLT.DGJDL250-14-11GJ' And t1. FNumber<='93.C.STφ.STφ34-2800(30)-KA31' And t2.FNumber>='13' AND t2.FNumber<='13' AND t2.FIncludeAccounting<>0 


 Group By v2.FItemID,v2.FStockID,v2.FStockPlaceID,v2.FMTONo,v2.FBatchNo,v2.FAuxPropID,t1.FTrack
Insert Into #Happen_New(FItemID,FStockID,FStockPlaceID,FBatchNo,FMTONo,FAuxPropID,FBegQty,FBegSecQty,FBegBal)
Select v2.FItemID,t2.FItemID,v2.FDCSPID,v2.FBatchNo,v2.FMTONo, v2.FAuxPropID,Sum(IsNull(v2.FQty,0)),Sum(IsNull(v2.FSecQty,0)),
 Case When v1.FTranType In(1,2,5,10,40,100,101,102) And t1.FTrack<>81 Then  Sum(IsNull(Round(v2.FAmount,2),0))
      When v1.FTranType In(1,2,5,10,40,41,100,101,102) And t1.FTrack=81 Then Sum(IsNull(Round(v2.FPlanAmount,2),0))
      When v1.FTranType =41 Then Sum(IsNull(Round(v2.FAmtRef,2),0)) Else 0 End
From ICStockBill v1 
Inner Join ICStockBillEntry v2  On v1.FInterID=v2.FInterID
Left Join t_ICItem t1 On v2.FItemID=t1.FItemID
Left Join t_Stock t2 On v2.FDCStockID=t2.FItemID 
Left Join t_StockPlace t11 On v2.FDCSPID=t11.FSPID

 Where (v1.FTranType In (1,2,5,10,40,101,102,41) Or (V1.FTranType=100 And V1.FBillTypeID=12542)) 
 --And v1.FDate >='2023-01-01' And v1.FDate <'2023-01-01'
  And v1.FDate >=@fstartdate And v1.FDate <@fstartdate

 And t1.FNumber>='93.A.DLT.DGJDL250-14-11GJ' And t1. FNumber<='93.C.STφ.STφ34-2800(30)-KA31' And t2.FNumber>='13' AND t2.FNumber<='13' AND t2.FIncludeAccounting<>0 
 And v1.FStatus>0 And v1.FCancelLation=0 
 Group By v2.FItemID,t2.FItemID,v2.FDCSPID,v2.FMTONo,v2.FBatchNo,v2.FAuxPropID,v1.FTranType,t1.FTrack
 Insert Into #Happen_New(FItemID,FStockID,FStockPlaceID,FBatchNo,FMTONo,FAuxPropID,FBegQty,FBegSecQty,FBegBal)
Select v2.FItemID,t2.FItemID,v2.FDCSPID,v2.FBatchNo,v2.FMTONo,v2.FAuxPropID,Sum(IsNull(-v2.FQty,0)),-Sum(IsNull(v2.FSecQty,0)),
 Case When t1.FTrack<>81 Then  Sum(IsNull(Round(-v2.FAmount,2),0))
      When t1.FTrack=81 Then Sum(IsNull(Round(-v2.FPlanAmount,2),0)) Else 0 End
 From ICStockBill v1 
 Inner Join ICStockBillEntry v2  On v1.FInterID=v2.FInterID
 Left Join t_ICItem t1 On v2.FItemID=t1.FItemID
 Left Join t_Stock t2 On v2.FDCStockID=t2.FItemID 
 Left Join t_StockPlace t11 On v2.FDCSPID=t11.FSPID

 Where (v1.FTranType In (21,28,29,43) Or (V1.FTranType=100 And V1.FBillTypeID=12541)) 
 --And v1.FDate >='2023-01-01' And v1.FDate <'2023-01-01'
   And v1.FDate >=@fstartdate And v1.FDate <@fstartdate

 And t1.FNumber>='93.A.DLT.DGJDL250-14-11GJ' And t1. FNumber<='93.C.STφ.STφ34-2800(30)-KA31' And t2.FNumber>='13' AND t2.FNumber<='13' AND t2.FIncludeAccounting<>0 
 And v1.FStatus>0 And v1.FCancelLation=0 
 Group By v2.FItemID,t2.FItemID,v2.FDCSPID,v2.FMTONo,v2.FBatchNo,v2.FAuxPropID,v1.FTranType,t1.FTrack
Insert Into #Happen_New(FItemID,FStockID,FStockPlaceID,FBatchNo,FMTONo,FAuxPropID,FBegQty,FBegSecQty,FBegBal)
Select v2.FItemID,t2.FItemID,Case When v1.FTranType=41 Then v2.FSCSPID Else v2.FDCSPID End,v2.FBatchNo,v2.FMTONo,v2.FAuxPropID,Sum(IsNull(-v2.FQty,0)),Sum(IsNull(-v2.FSecQty,0)),
    Case When t1.FTrack<>81 Then  Sum(IsNull(Round(-v2.FAmount,2),0)) Else Sum(IsNull(Round(-v2.FPlanAmount,2),0)) End
 From ICStockBill v1 
 Inner Join ICStockBillEntry v2  On v1.FInterID=v2.FInterID
 Left Join t_ICItem t1 On v2.FItemID=t1.FItemID
 Left Join t_Stock t2 On v2.FSCStockID=t2.FItemID 
 Left Join t_MeasureUnit t3  On t1.FStoreUnitID=t3.FMeasureUnitID
 Left Join t_StockPlace t11 On (Case When v1.FTranType=41 Then v2.FSCSPID Else v2.FDCSPID End)=t11.FSPID


 Where v1.FTranType In (24,41) 
 --And v1.FDate >='2023-01-01' And v1.FDate <'2023-01-01'
   And v1.FDate >=@fstartdate And v1.FDate <@fstartdate

 And t1.FNumber>='93.A.DLT.DGJDL250-14-11GJ' And t1. FNumber<='93.C.STφ.STφ34-2800(30)-KA31' And t2.FNumber>='13' AND t2.FNumber<='13' AND t2.FIncludeAccounting<>0 
 And v1.FStatus>0 And v1.FCancelLation=0 
 Group By v2.FItemID,t2.FItemID,Case When v1.FTranType=41 Then v2.FSCSPID Else v2.FDCSPID End,v2.FMTONo,v2.FBatchNo,v2.FAuxPropID,v1.FTranType,t1.FTrack

Insert Into #Happen_New(FItemID,FStockID,FStockPlaceID,FBatchNo,FMTONo,FAuxPropID,FBegQty,FBegBal)

Select v2.FItemID,t2.FItemID,Isnull(v2.FSPID,0),v2.FBatchNo,v2.FMTONo, v2.FAuxPropID,
Sum(IsNull(v2.FQty,0)),
Sum(IsNull(Round(v2.FAmount,2),0)) 
 From ICVMIInStock v1
 Inner Join ICVMIInStockEntry v2  On v1.FID=v2.FID
 Left Join t_ICItem t1 On v2.FItemID=t1.FItemID
 Left Join t_Stock t2 On v2.FStockID=t2.FItemID
 Left Join t_StockPlace t11 On v2.FSPID=t11.FSPID




 Where v1.FClassTypeID = 1007601 And 
 --v1.FDate >='2023-01-01' And v1.FDate <'2023-01-01'
 v1.FDate >=@fstartdate And v1.FDate <@fstartdate

 And t1.FNumber>='93.A.DLT.DGJDL250-14-11GJ' And t1. FNumber<='93.C.STφ.STφ34-2800(30)-KA31' And t2.FNumber>='13' AND t2.FNumber<='13' AND t2.FIncludeAccounting<>0 
 And v1.FStatus>0 
 Group By v2.FItemID,t2.FItemID,v2.FSPID,v2.FMTONo, v2.FBatchNo,v2.FAuxPropID,t1.FTrack
 Insert Into #Happen_New Select v2.FItemID,t2.FItemID,Isnull(v2.FDCSPID,0),v2.FBatchNo,v2.FMTONo, v2.FAuxPropID,0,0,
 Sum(IsNull(v2.FQty,0)),
 Case When v1.FTranType In(1,2,5,10,40,100,101,102) And t1.FTrack<>81 Then Max(IsNull(v2.FPrice,0))
      When v1.FTranType In(1,2,5,10,40,100,101,102) And t1.FTrack=81 Then Max(IsNull(v2.FPlanPrice,0)) Else 0 End,
 Case When v1.FTranType In(1,2,5,10,40,100,101,102) And t1.FTrack<>81 Then  Sum(IsNull(Round(v2.FAmount,2),0))
      When v1.FTranType In(1,2,5,10,40,100,101,102) And t1.FTrack=81 Then Sum(IsNull(Round(v2.FPlanAmount,2),0)) Else 0 End ,
 0,0,0,Sum(IsNull(v2.FSecQty,0)),0,0,0,0,0
 From ICStockBill v1 
 Inner Join ICStockBillEntry v2  On v1.FInterID=v2.FInterID
 Left Join t_ICItem t1 On v2.FItemID=t1.FItemID
 Left Join t_Stock t2 On v2.FDCStockID=t2.FItemID 
 Left Join t_StockPlace t11 On v2.FDCSPID=t11.FSPID


 Where (v1.FTranType In (1,2,5,10,40,101,102) Or (V1.FTranType=100 And V1.FBillTypeID=12542)) 
 --And v1.FDate >='2023-01-01' And v1.FDate <'2024-01-01'
   And v1.FDate >=@fstartdate And v1.FDate <=@fenddate

 And t1.FNumber>='93.A.DLT.DGJDL250-14-11GJ' And t1. FNumber<='93.C.STφ.STφ34-2800(30)-KA31' And t2.FNumber>='13' AND t2.FNumber<='13' AND t2.FIncludeAccounting<>0 

 And v1.FStatus>0 And v1.FCancelLation=0 
 And (Not (v1.FTranType=1 And isnull(v1.FPoMode,0)=36681))

 AND isnull(t2.FIncludeAccounting,0) =1
 Group By v2.FItemID,t2.FItemID,v2.FDCSPID,v2.FMTONo, v2.FBatchNo,v2.FAuxPropID,v1.FTranType,t1.FTrack
 Insert Into #Happen_New Select v2.FItemID,t2.FItemID,Isnull(v2.FDCSPID,0),v2.FBatchNo,v2.FMTONo, v2.FAuxPropID,0,0,
 Sum(IsNull(v2.FQty,0)),
 Case When  v1.FTranType In(41) And t1.FTrack=81 Then Max(IsNull(v2.FPlanPrice,0)) 
      When v1.FTranType = 41 Then Max(IsNull(v2.FPriceRef,0)) Else 0 End,
 Case When v1.FTranType In(41) And t1.FTrack=81 Then Sum(IsNull(Round(v2.FPlanAmount,2),0))
      When v1.FTranType =41 Then Sum(IsNull(Round(v2.FAmtRef,2),0)) Else 0 End ,
 0,0,0,Sum(IsNull(v2.FSecQty,0)),0,0,0,0,0
 From ICStockBill v1 
 Inner Join ICStockBillEntry v2  On v1.FInterID=v2.FInterID
 Left Join t_ICItem t1 On v2.FItemID=t1.FItemID
 Left Join t_Stock t2 On v2.FDCStockID=t2.FItemID 
 Left Join t_StockPlace t11 On v2.FDCSPID=t11.FSPID
 Where v1.FTranType =41 
 --And v1.FDate >='2023-01-01' And v1.FDate <'2024-01-01'
 And v1.FDate >=@fstartdate And v1.FDate <=@fenddate

 And t1.FNumber>='93.A.DLT.DGJDL250-14-11GJ' And t1. FNumber<='93.C.STφ.STφ34-2800(30)-KA31' And t2.FNumber>='13' AND t2.FNumber<='13' AND t2.FIncludeAccounting<>0 

 And v1.FStatus>0 And v1.FCancelLation=0 
 AND isnull(t2.FIncludeAccounting,0) =1
 And (Not (v1.FTranType=1 And isnull(v1.FPoMode,0)=36681)) Group By v2.FItemID,t2.FItemID,v2.FDCSPID,v2.FMTONo, v2.FBatchNo,v2.FAuxPropID,v1.FTranType,t1.FTrack

 Insert Into #Happen_New
  Select v2.FItemID,t2.FItemID,Isnull(v2.FSPID,0),v2.FBatchNo,v2.FMTONo,  v2.FAuxPropID,0,0,
 Sum(IsNull(v2.FQty,0)),
 Max(Round(IsNull(v2.FAuxPrice,0)/tzz.FCoefficient,2)),
 Sum(IsNull(Round(v2.FAmount,2),0)) ,
 0,0,0,Sum(IsNull(v2.FSecQty,0)),0,0,0,0,0
 From ICVMIInStock v1
 Inner Join ICVMIInStockEntry v2  On v1.FID=v2.FID
 Left Join t_ICItem t1 On v2.FItemID=t1.FItemID
 Left Join t_Stock t2 On v2.FStockID=t2.FItemID
 Left Join t_StockPlace t11 On v2.FSPID=t11.FSPID
 Left Join t_MeasureUnit tzz  On v2.FAuxUnitID=tzz.FMeasureUnitID



 Where v1.FClassTypeID = 1007601 
 --And v1.FDate >='2023-01-01' And v1.FDate <'2024-01-01'
  And v1.FDate >=@fstartdate And v1.FDate <=@fenddate

 And t1.FNumber>='93.A.DLT.DGJDL250-14-11GJ' And t1. FNumber<='93.C.STφ.STφ34-2800(30)-KA31' And t2.FNumber>='13' AND t2.FNumber<='13' AND t2.FIncludeAccounting<>0 

 And v1.FStatus>0 

 Group By v2.FItemID,t2.FItemID,v2.FSPID,v2.FMTONo, v2.FBatchNo,v2.FAuxPropID,t1.FTrack
 Insert Into #Happen_New Select v2.FItemID,t2.FItemID,Isnull(v2.FDCSPID,0),v2.FBatchNo,v2.FMTONo, v2.FAuxPropID,0,0,
 0,0,0,
 Sum(IsNull(v2.FQty,0)),
 Case When t1.FTrack<>81 Then  Max(IsNull(v2.FPrice,0))
      When t1.FTrack=81 Then Max(IsNull(v2.FPlanPrice,0)) Else 0 End,
 Case When t1.FTrack<>81 Then  Sum(IsNull(Round(v2.FAmount,2),0))
      When t1.FTrack=81 Then Sum(IsNull(Round(v2.FPlanAmount,2),0)) Else 0 End,
0,Sum(IsNull(v2.FSecQty,0)),0,0,0,0
 From ICStockBill v1 
 Inner Join ICStockBillEntry v2  On v1.FInterID=v2.FInterID
 Left Join t_ICItem t1 On v2.FItemID=t1.FItemID
 Left Join t_Stock t2 On v2.FDCStockID=t2.FItemID 
 Left Join t_StockPlace t11 On v2.FDCSPID=t11.FSPID


 Where (v1.FTranType In (21,28,29,43) Or (V1.FTranType=100 And V1.FBillTypeID=12541)) 
 --And v1.FDate >='2023-01-01' And v1.FDate <'2024-01-01'
  And v1.FDate >=@fstartdate And v1.FDate <=@fenddate

 And t1.FNumber>='93.A.DLT.DGJDL250-14-11GJ' And t1. FNumber<='93.C.STφ.STφ34-2800(30)-KA31' And t2.FNumber>='13' AND t2.FNumber<='13' AND t2.FIncludeAccounting<>0 

 And v1.FStatus>0 And v1.FCancelLation=0 
 AND isnull(t2.FIncludeAccounting,0) =1


 Group By v2.FItemID,t2.FItemID,v2.FDCSPID,v2.FMTONo, v2.FBatchNo,v2.FAuxPropID,v1.FTranType,t1.FTrack
Insert Into #Happen_New Select v2.FItemID,t2.FItemID, v2.FDCSPID ,v2.FBatchNo,v2.FMTONo, v2.FAuxPropID,
    0,0,0,0,0,
    Sum(IsNull(v2.FQty,0)),
    Case When t1.FTrack<>81 Then  Max(IsNull(v2.FPrice,0)) Else Max(IsNull(v2.FPlanPrice,0)) End,
    Case When t1.FTrack<>81 Then  Sum(IsNull(Round(v2.FAmount,2),0)) Else Sum(IsNull(Round(v2.FPlanAmount,2),0)) End,
    0,Sum(IsNull(v2.FSecQty,0)),0,0,0,0
 From ICStockBill v1 
 Inner Join ICStockBillEntry v2  On v1.FInterID=v2.FInterID
 Left Join t_ICItem t1 On v2.FItemID=t1.FItemID
 Left Join t_Stock t2 On v2.FSCStockID=t2.FItemID 
 Left Join t_MeasureUnit t3  On t1.FStoreUnitID=t3.FMeasureUnitID
 Left Join t_StockPlace t11 On  v2.FDCSPID =t11.FSPID



 Where v1.FTranType In (24) 
 --And v1.FDate >='2023-01-01' And v1.FDate <'2024-01-01'
  And v1.FDate >=@fstartdate And v1.FDate <=@fenddate

 And t1.FNumber>='93.A.DLT.DGJDL250-14-11GJ' And t1. FNumber<='93.C.STφ.STφ34-2800(30)-KA31' And t2.FNumber>='13' AND t2.FNumber<='13' AND t2.FIncludeAccounting<>0 

 And v1.FStatus>0 And v1.FCancelLation=0 
 AND isnull(t2.FIncludeAccounting,0) =1



 Group By v2.FItemID,t2.FItemID, v2.FDCSPID,v2.FMTONo, v2.FBatchNo,v2.FAuxPropID,v1.FTranType,t1.FTrack
Insert Into #Happen_New Select v2.FItemID,t2.FItemID, v2.FSCSPID ,v2.FBatchNo,v2.FMTONo, v2.FAuxPropID,
    0,0,0,0,0,
    Sum(IsNull(v2.FQty,0)),
    Case When t1.FTrack<>81 Then  Max(IsNull(v2.FPrice,0)) Else Max(IsNull(v2.FPlanPrice,0)) End,
    Case When t1.FTrack<>81 Then  Sum(IsNull(Round(v2.FAmount,2),0)) Else Sum(IsNull(Round(v2.FPlanAmount,2),0)) End,
    0,Sum(IsNull(v2.FSecQty,0)),0,0,0,0
 From ICStockBill v1 
 Inner Join ICStockBillEntry v2  On v1.FInterID=v2.FInterID
 Left Join t_ICItem t1 On v2.FItemID=t1.FItemID
 Left Join t_Stock t2 On v2.FSCStockID=t2.FItemID 
 Left Join t_MeasureUnit t3  On t1.FStoreUnitID=t3.FMeasureUnitID
 Left Join t_StockPlace t11 On  v2.FSCSPID =t11.FSPID
 Where v1.FTranType In (41) 
 --And v1.FDate >='2023-01-01' And v1.FDate <'2024-01-01'
  And v1.FDate >=@fstartdate And v1.FDate <=@fenddate

 And t1.FNumber>='93.A.DLT.DGJDL250-14-11GJ' And t1. FNumber<='93.C.STφ.STφ34-2800(30)-KA31' And t2.FNumber>='13' AND t2.FNumber<='13' AND t2.FIncludeAccounting<>0 

 And v1.FStatus>0 And v1.FCancelLation=0 
 AND isnull(t2.FIncludeAccounting,0) =1
 Group By v2.FItemID,t2.FItemID,v2.FSCSPID,v2.FMTONo, v2.FBatchNo,v2.FAuxPropID,v1.FTranType,t1.FTrack
 update #Happen_New set FBegCUUnitQty =isnull(FBegQty,0)/cast(t3.FCoefficient As Decimal(28,10)), 
 FInCUUnitQty =isnull(FInQty,0)/cast(t3.FCoefficient As Decimal(28,10)), 
 FOutCUUnitQty =isnull(FOutQty,0)/cast(t3.FCoefficient As Decimal(28,10)) 
 from #Happen_New v2 
 inner Join t_ICItem t1 On v2.FItemID=t1.FItemID 
 inner Join t_MeasureUnit t3  On t1.FStoreUnitID=t3.FMeasureUnitID 
 Select v1.FItemID,v1.FStockID,v1.FStockPlaceID,v1.FBatchNo,v1.FMTONo,v1.FAuxPropID,
       Sum(v1.FBegQty) As FBegQty,Sum(v1.FBegBal) As FBegBal,
       Sum(v1.FInQty) As FInQty,Max(v1.FInPrice) As FInPrice,Sum(v1.FInAmount) As FInAmount,
       Sum(v1.FOutQty) As FOutQty,Max(v1.FOutPrice) As FOutPrice,Sum(v1.FOutAmount) As FOutAmount,
       Sum(v1.FInSecQty) As FInSecQty,Sum(v1.FOutSecQty) As FOutSecQty,Sum(v1.FBegSecQty) As FBegSecQty,
       sum(v1.FBegCUUnitQty) as FBegCUUnitQty,sum(v1.FInCUUnitQty) as FInCUUnitQty,sum(v1.FOutCUUnitQty) as FOutCUUnitQty 
 Into #Happen_New1 From #Happen_New v1 
 Where 1 = 1 

 Group By v1.FItemID,v1.FStockID,v1.FStockPlaceID,v1.FMTONo,v1.FBatchNo,v1.FAuxPropID
Create Table #Data_New( ForderByID int Default(0),
     FNumber  Varchar(355) null,
     FShortNumber  Varchar(355) null,
     FName  Varchar(355) null,
     FModel  Varchar(355) null,
     FSUnitName  Varchar(355) null,
     FCUnitName  Varchar(355) null,
     FUnitName  Varchar(355) null,
     FQtyDecimal smallint null, 
     FPriceDecimal smallint null, 
     FBegQty Decimal(28,10),
     FBegPrice Decimal(28,10),
     FBegBal Decimal(28,10),
     FInQty  Decimal(28,10),
     FInPrice  Decimal(28,10),
     FInAmount Decimal(28,10),
     FOutQty Decimal(28,10),
     FOutPrice Decimal(28,10),
     FOutAmount Decimal(28,10),
     FEndQty Decimal(28,10),
     FEndPrice Decimal(28,10),
     FEndAmount Decimal(28,10),
     FSumSort smallint not null Default(0),
     FID int IDENTITY,
FBegSecQty Decimal(28,10) Default(0),FInSecQty Decimal(28,10) Default(0),
FOutSecQty Decimal(28,10) Default(0),
FBalSecQty Decimal(28,10) Default(0),
     FCUUnitName  Varchar(355) null,
     FBegCUUnitQty decimal(28,10) Default(0),
     FBegCUUnitPrice decimal(28,10) Default(0),
     FInCUUnitQty Decimal(28,10) Default(0),
     FInCUUnitPrice Decimal(28,10) Default(0),
     FOutCUUnitQty Decimal(28,10) Default(0),
     FOutCUUnitPrice Decimal(28,10) Default(0),
     FEndCUUnitQty Decimal(28,10) Default(0),
     FEndCUUnitPrice Decimal(28,10) Default(0))

  Insert Into #Data_New (
FNumber,FShortNumber,FName,FModel,FSUnitName,FCUnitName,FUnitName,FQtyDecimal,FPriceDecimal,
 FBegQty,FBegPrice,FBegBal,FInQty,FInPrice,FInAmount,FOutQty,
 FOutPrice,FOutAmount,FEndQty,FEndPrice,FEndAmount,FSumSort,FBegSecQty,FInSecQty,FOutSecQty,FBalSecQty,
 FCUUnitName,FBegCUUnitQty,FBegCUUnitPrice,FInCUUnitQty,FInCUUnitPrice,FOutCUUnitQty,FOutCUUnitPrice,FEndCUUnitQty,FEndCUUnitPrice)

 Select Case   When Grouping(FNumber)=1 THEN '小计' 
 Else FNumber END, 
'','','','','','',max(col5) ,max(col6),sum(FBegQty),case when sum(FBegQty) <> 0 then cast(sum(FBegBal)as Decimal(28,10))/cast(sum(FBegQty)as Decimal(28,10)) else 0 end,sum(FBegBal),sum(FInQty),case when sum(FInQty) <> 0 then cast(sum(FInAmount) as Decimal(28,10))/ cast(sum(FInQty) as Decimal(28,10)) else 0 end,sum(FInAmount),sum(FOutQty)
,case when sum(FOutQty) <> 0 then cast(sum(FOutAmount)as Decimal(28,10)) /cast(sum(FOutQty)as Decimal(28,10))  Else 0 end,sum(FOutAmount),sum(FEndQty) as FEndQty,case when sum(FEndQty)<>0 then cast(sum(FEndAmount)as Decimal(28,10)) /cast(sum(FEndQty)as Decimal(28,10))  else 0 end,sum(FEndAmount),

 Case  When Grouping(FNumber)=1 THEN 101 Else 0 END ,
Sum (FBegSecQty), Sum(FInSecQty), Sum(FOutSecQty), Sum(FBalSecQty) ,'',sum(FBegCUUnitQty),case when sum(FBegCUUnitQty)<>0 then cast(sum(FBegBal)as Decimal(28,10)) /cast(sum(FBegCUUnitQty) as Decimal(28,10)) else 0 end,sum(FInCUUnitQty),case when sum(FInCUUnitQty)<>0 then cast(sum(FInAmount)as Decimal(28,10)) /cast(sum(FInCUUnitQty)as Decimal(28,10))  else 0 end,sum(FOutCUUnitQty),case when sum(FOutCUUnitQty)<>0 then cast(sum(FOutAmount)as Decimal(28,10)) /cast(sum(FOutCUUnitQty)as Decimal(28,10))  else 0 end,sum(FEndCUUnitQty),case when sum(FEndCUUnitQty)<>0 then cast(sum(FEndAmount)as Decimal(28,10)) /cast(sum(FEndCUUnitQty)as Decimal(28,10))  else 0 end FROM ( 
 select t1.FNumber as FNumber,
'' as col1,'' as col2,'' as col3,'' as col4,max(t1.FQtyDecimal) as col5,max(t1.FPriceDecimal) as col6,
SUM(ISNULL(v2.FBegQty,0)) as FBegQty,Case When SUM(ISNULL(v2.FBegQty,0))<>0 then cast(SUM(ISNULL(FBegBal,0))as Decimal(28,10))/cast(SUM(ISNULL(FBegQty,0)) as Decimal(28,10)) Else 0 End as FBegPrice,
SUM(ISNULL(v2.FBegBal,0)) as FBegBal,SUM(ISNULL(FInQty,0)) as FInQty,Case When SUM(ISNULL(FInQty,0))<>0 Then cast(SUM(ISNULL(FInAmount,0))as Decimal(28,10))/cast(SUM(FInQty) as Decimal(28,10)) Else 0 End as FInPrice,
SUM(ISNULL(FInAmount,0)) as FInAmount,SUM(ISNULL(FOutQty,0)) as FOutQty, Case When SUM(ISNULL(FOutQty,0))<>0 Then cast(SUM(ISNULL(FOutAmount,0))as Decimal(28,10))/cast(SUM(ISNULL(FOutQty,0)) as Decimal(28,10)) Else 0 End as FOutPrice,
SUM(ISNULL(FOutAmount,0)) as FOutAmount,SUM(ISNULL(FBegQty,0))+SUM(ISNULL(FInQty,0))-SUM(ISNULL(FOutQty,0)) as FEndQty,
Case When SUM(ISNULL(FBegQty,0))+SUM(ISNULL(FInQty,0))-SUM(ISNULL(FOutQty,0))<>0 Then cast((SUM(ISNULL(FBegBal,0))+SUM(ISNULL(FInAmount,0))-SUM(ISNULL(FOutAmount,0))) as Decimal(28,10))/cast((SUM(ISNULL(FBegQty,0))+SUM(ISNULL(FInQty,0))-SUM(ISNULL(FOutQty,0))) as Decimal(28,10)) Else 0 End as FEndPrice,
Sum(ISNULL(FBegBal,0))+Sum(ISNULL(FInAmount,0))-Sum(ISNULL(FOutAmount,0)) as FEndAmount,
0 as FSumSort ,Sum(ISNULL(v2.FBegSecQty,0)) as FBegSecQty,Sum(ISNULL(v2.FInSecQty,0)) as FInSecQty,Sum(ISNULL(v2.FOutSecQty,0)) as FOutSecQty,Sum(ISNULL(v2.FBegSecQty,0))+Sum(ISNULL(v2.FInSecQty,0))-Sum(ISNULL(v2.FOutSecQty,0)) as FBalSecQty,
'' as FCUUnitName,Sum(ISNULL(v2.FBegCUUnitQty,0)) as FBegCUUnitQty,Sum(ISNULL(v2.FInCUUnitQty,0)) as FInCUUnitQty,Sum(ISNULL(v2.FOutCUUnitQty,0)) as FOutCUUnitQty,
Sum(ISNULL(v2.FBegCUUnitQty,0)) +Sum(ISNULL(v2.FInCUUnitQty,0)) -Sum(ISNULL(v2.FOutCUUnitQty,0)) as FEndCUUnitQty 
 From #Happen_New1 v2
 Inner Join t_ICItem t1 On v2.FItemID=t1.FItemID
 Left Join t_Stock t2 On v2.FStockID=t2.FItemID
 Left Join t_AuxItem ta On v2.FAuxPropID=ta.FItemID
 Where 1=1  



Group by t1.FNumber 
 HAVING NOT (SUM(ISNULL(FBegQty,0))+SUM(ISNULL(FInQty,0))-SUM(ISNULL(FOutQty,0))=0 AND Sum(ISNULL(FBegBal,0))+Sum(ISNULL(FInAmount,0))-Sum(ISNULL(FOutAmount,0))=0) 
) t  Group by FNumber WITH ROLLUP  Update t1 Set t1.FName=isnull(t2.FName,''),t1.FShortNumber=isnull(t2.FShortNumber,''),t1.FModel=isnull(t2.FModel,''),
 t1.FSUnitName=t3.FName,t1.FCUnitName=t4.FName,
 t1.FUnitName=t3.FName,t1.FQtyDecimal=t2.FQtyDecimal,t1.FPriceDecimal=t2.FPriceDecimal,t1.FCUUnitName=t4.FName
 From #Data_New t1 Left Join t_ICItem t2 On t1.FNumber = t2.FNumber 
 Left Join t_MeasureUnit t3 On t2.FUnitID=t3.FMeasureUnitID and t3.FStandard=1
 Left Join t_MeasureUnit t4 On t2.FStoreUnitID=t4.FMeasureUnitID and t3.FStandard=1
  WHERE t1.FNumber <>'小计' and  t1.FNumber <>'合计'
update #Data_New set FshortNumber = '合计',FOrderbyID=1 where fnumber = '合计'

;WITH dataNew
AS
(
Select t.*,tm.FName As FSecUnitName From #Data_New t
     Left Join t_ICItem ti On t.FNumber=ti.FNumber
     Left Join t_MeasureUnit tm On ti.FSecUnitID=tm.FMeasureUnitID
     where Not (FBegQty=0 and  FBegBal=0 and FInQty=0 and  FInAmount=0 and FOutQty=0 and FOutAmount=0) 
--Order By t.ForderByID,t.FID,t.FNumber
),
OutStockAmount
AS
(
    SELECT --t3.FNumber,
        Case When Grouping(t3.FNumber)=1 THEN '小计' Else t3.FNumber END as FNumber, 
        sum(case DATEDIFF(MONTH,GETDATE(),t1.fdate) when -1 then t2.FConsignAmount else 0 END) AS FLast1Month,
        sum(case DATEDIFF(MONTH,GETDATE(),t1.fdate) when -2 then t2.FConsignAmount else 0 END) AS FLast2Month,
        sum(case DATEDIFF(MONTH,GETDATE(),t1.fdate) when -3 then t2.FConsignAmount else 0 END) AS FLast3Month
    FROM ICStockBill t1
    left join icstockbillentry t2 on t1.FInterID=t2.FInterID
    LEFT join t_ICItem t3 ON t2.FItemID=t3.FItemID
    WHERE t1.FTranType=21
    AND DATEDIFF(MONTH,GETDATE(),t1.fdate)>=-3
    AND t3.FNumber LIKE '93.%'
    GROUP BY t3.FNumber
    WITH ROLLUP
),
SeOrderUnQty
AS
(
    SELECT --2.FNumber,
    Case When Grouping(t2.FNumber)=1 THEN '小计' Else t2.FNumber END as FNumber, 
    SUM(FEntrySelfS0162) AS FUnQty FROM SEOrderEntry t1
    left join t_ICItem t2 on t1.fitemid=t2.fitemid
    where t2.fnumber LIKE '93.%'
    GROUP BY t2.FNumber
    with ROLLUP
),
POOrderUnQty
AS
(
    SELECT --t2.FNumber,
    Case When Grouping(t2.FNumber)=1 THEN '小计' Else t2.FNumber END as FNumber, 
    SUM(FEntrySelfP0248) AS FUnQty FROM POOrder t0
    left join POOrderEntry t1 on t0.FInterID=t1.FInterID
    left join t_ICItem t2 on t1.fitemid=t2.fitemid
    where t2.fnumber LIKE '93.%'
    AND DATEDIFF(MONTH,GETDATE(),t0.fdate)>=-3
    GROUP BY t2.FNumber
    with ROLLUP
),
CustCountOrigin
AS
(
    SELECT distinct t1.FSupplyID,t3.FNumber FROM ICStockBill t1
    LEFT join ICStockBillEntry t2 on t1.finterid=t2.finterid
    LEFT join t_ICItem t3 on t2.FItemID=t3.FItemID
    where t3.fnumber LIKE '93.%'
    AND DATEDIFF(MONTH,GETDATE(),t1.fdate)>=-3
),
CustCount
AS
(
    SELECT --FNumber,
    Case When Grouping(FNumber)=1 THEN '小计' Else FNumber END as FNumber, 
    COUNT(FSupplyID) FCount
    FROM CustCountOrigin
    GROUP BY FNumber
    with ROLLUP
)


SELECT t1.fname as [物料名称],--t1.FID,
    t1.FInQty as [本月收入],
    t1.FOutCUUnitQty as [本月发出],
    t1.FEndCUUnitQty as [库存],
    t2.FUnQty as [销售订单未出库数量],
    t3.FLast1Month as [前一个月出库数量],
    t3.flast2month as [前二个月出库数量],
    t3.flast3month as [前三个月出库数量],
    t4.FUnQty as [采购未入库数量],
    t5.FCount AS [客户家数]
from  dataNew t1
LEFT JOIN SeOrderUnQty t2 ON t1.FNumber=t2.FNumber
LEFT JOIN OutStockAmount t3 ON t1.FNumber=t3.FNumber
LEFT JOIN POOrderUnQty t4 ON t1.FNumber=t4.FNumber
LEFT JOIN CustCount t5 ON t1.FNumber=t5.FNumber
Order By t1.ForderByID,t1.FID,t1.FNumber

Drop Table #Data_New  
Drop Table #Happen_New
Drop Table #Happen_New1





