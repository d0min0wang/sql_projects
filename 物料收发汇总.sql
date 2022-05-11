USE [AIS20100618152307]
GO
/****** 对象:  StoredProcedure [dbo].[p_xy_SunyiShengchan_1]    脚本日期: 03/20/2013 17:01:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER   PROCEDURE [dbo].[p_xy_SunyiShengchan_2]
	@FYear int, --查询年份
	@FYearMonth int --查询月份
AS
SET NOCOUNT ON

Create Table #Happen(
        FItemID int Null,
        FStockID int Null,
        FStockPlaceID int Null, 
        FBatchNo Varchar(200),
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
 Insert Into #Happen
 Select  v2.FItemID,v2.FStockID,Isnull(v2.FStockPlaceID,0),v2.FBatchNo,v2.FAuxPropID,
      Sum (v2.FBegQty), case when t1.FTrack = 81 Then Sum(Round(v2.FBegBal,2) - Round(v2.FBegDiff,2)) Else Sum(Round(v2.FBegBal,2)) End ,0,0,0,0,0,0,
      0,0,Sum(v2.FSecBegQty),0,0,0
 From ICInvbal v2 
 Left Join t_ICItem t1  On v2.FItemID=t1.FItemID
 Left Join t_Stock t2 On v2.FStockID=t2.FItemID
 Left Join t_StockPlace t11 On v2.FStockPlaceID=t11.FSPID
Where v2.FYear=2013 And v2.FPeriod=01
-- Where v2.FYear=@FYear And v2.FPeriod=@FYearMonth
 And t2.FNumber>='01' AND t2.FNumber<='18'


 Group By v2.FItemID,v2.FStockID,v2.FStockPlaceID,v2.FBatchNo,v2.FAuxPropID,t1.FTrack
 Insert Into #Happen Select v2.FItemID,t2.FItemID,Isnull(v2.FDCSPID,0),v2.FBatchNo,v2.FAuxPropID,0,0,
 Sum(IsNull(v2.FQty,0)),
 Case When v1.FTranType In(1,2,5,10,40,100,101,102) And t1.FTrack<>81 Then Max(IsNull(v2.FPrice,0))
      When v1.FTranType In(1,2,5,10,40,100,101,102,41) And t1.FTrack=81 Then Max(IsNull(v2.FPlanPrice,0)) 
      When v1.FTranType = 41 Then Max(IsNull(v2.FPriceRef,0)) Else 0 End,
 Case When v1.FTranType In(1,2,5,10,40,100,101,102) And t1.FTrack<>81 Then  Sum(IsNull(Round(v2.FAmount,2),0))
      When v1.FTranType In(1,2,5,10,40,100,101,102,41) And t1.FTrack=81 Then Sum(IsNull(Round(v2.FPlanAmount,2),0))
      When v1.FTranType =41 Then Sum(IsNull(Round(v2.FAmtRef,2),0)) Else 0 End ,
 0,0,0,Sum(IsNull(v2.FSecQty,0)),0,0,0,0,0
 From ICStockBill v1 
 Inner Join ICStockBillEntry v2  On v1.FInterID=v2.FInterID
 Left Join t_ICItem t1 On v2.FItemID=t1.FItemID
 Left Join t_Stock t2 On v2.FDCStockID=t2.FItemID 
 Left Join t_StockPlace t11 On v2.FDCSPID=t11.FSPID


 Where (v1.FTranType In (1,2,5,10,40,101,102,41) Or (V1.FTranType=100 And V1.FBillTypeID=12542)) And v1.FDate >='2013-03-01'
 And v1.FDate <'2013-04-01'
 And t2.FNumber>='01' AND t2.FNumber<='18'

 And v1.FStatus>0 And v1.FCancelLation=0 


 Group By v2.FItemID,t2.FItemID,v2.FDCSPID,v2.FBatchNo,v2.FAuxPropID,v1.FTranType,t1.FTrack
 Insert Into #Happen Select v2.FItemID,t2.FItemID,Isnull(v2.FDCSPID,0),v2.FBatchNo,v2.FAuxPropID,0,0,
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


 Where (v1.FTranType In (21,28,29,43) Or (V1.FTranType=100 And V1.FBillTypeID=12541)) And v1.FDate >='2013-03-01'
 And v1.FDate <'2013-04-01'
 And t2.FNumber>='01' AND t2.FNumber<='18'

 And v1.FStatus>0 And v1.FCancelLation=0 


 Group By v2.FItemID,t2.FItemID,v2.FDCSPID,v2.FBatchNo,v2.FAuxPropID,v1.FTranType,t1.FTrack
Insert Into #Happen Select v2.FItemID,t2.FItemID,Case When v1.FTranType=41 Then v2.FSCSPID Else v2.FDCSPID End,v2.FBatchNo,v2.FAuxPropID,
    0,0,0,0,0,
    Sum(IsNull(v2.FQty,0)),
    Case When t1.FTrack<>81 Then  Max(IsNull(v2.FPrice,0)) Else Max(IsNull(v2.FPlanPrice,0)) End,
    Case When t1.FTrack<>81 Then  Sum(IsNull(Round(v2.FAmount,2),0)) Else Sum(IsNull(Round(v2.FPlanAmount,2),0)) End,
    0,0,Sum(IsNull(v2.FSecQty,0)),0,0,0
 From ICStockBill v1 
 Inner Join ICStockBillEntry v2  On v1.FInterID=v2.FInterID
 Left Join t_ICItem t1 On v2.FItemID=t1.FItemID
 Left Join t_Stock t2 On v2.FSCStockID=t2.FItemID 
 Left Join t_MeasureUnit t3  On t1.FStoreUnitID=t3.FMeasureUnitID
 Left Join t_StockPlace t11 On (Case When v1.FTranType=41 Then v2.FSCSPID Else v2.FDCSPID End)=t11.FSPID



 Where v1.FTranType In (24,41) 
 And v1.FDate >='2013-03-01'
 And v1.FDate <'2013-04-01'
 And t2.FNumber>='01' AND t2.FNumber<='18'

 And v1.FStatus>0 And v1.FCancelLation=0 



 Group By v2.FItemID,t2.FItemID,Case When v1.FTranType=41 Then v2.FSCSPID Else v2.FDCSPID End,v2.FBatchNo,v2.FAuxPropID,v1.FTranType,t1.FTrack
 update #Happen set FBegCUUnitQty =isnull(FBegQty,0)/cast(t3.FCoefficient As Decimal(28,10)), 
 FInCUUnitQty =isnull(FInQty,0)/cast(t3.FCoefficient As Decimal(28,10)), 
 FOutCUUnitQty =isnull(FOutQty,0)/cast(t3.FCoefficient As Decimal(28,10)) 
 from #Happen v2 
 inner Join t_ICItem t1 On v2.FItemID=t1.FItemID 
 inner Join t_MeasureUnit t3  On t1.FStoreUnitID=t3.FMeasureUnitID 
 Select v1.FItemID,v1.FStockID,v1.FStockPlaceID,v1.FBatchNo,v1.FAuxPropID,
       Sum(v1.FBegQty) As FBegQty,Sum(v1.FBegBal) As FBegBal,
       Sum(v1.FInQty) As FInQty,Max(v1.FInPrice) As FInPrice,Sum(v1.FInAmount) As FInAmount,
       Sum(v1.FOutQty) As FOutQty,Max(v1.FOutPrice) As FOutPrice,Sum(v1.FOutAmount) As FOutAmount,
       Sum(v1.FInSecQty) As FInSecQty,Sum(v1.FOutSecQty) As FOutSecQty,Sum(v1.FBegSecQty) As FBegSecQty,
       sum(v1.FBegCUUnitQty) as FBegCUUnitQty,sum(v1.FInCUUnitQty) as FInCUUnitQty,sum(v1.FOutCUUnitQty) as FOutCUUnitQty 
 Into #Happen1 From #Happen v1 
 Where 1 = 1 

 Group By v1.FItemID,v1.FStockID,v1.FStockPlaceID,v1.FBatchNo,v1.FAuxPropID
SET NOCOUNT ON
CREATE TABLE #ItemLevel( 
 FNumber1 Varchar(355),
 FName1 Varchar(355),
 FNumber2 Varchar(355),
 FName2 Varchar(355),
 FNumber3 Varchar(355),
 FName3 Varchar(355),
 FNumber4 Varchar(355),
 FName4 Varchar(355),
 FItemID int,
 FNumber Varchar(355))

 INSERT INTO #ItemLevel SELECT  
 CASE WHEN CHARINDEX('.',FFullNumber)-1= -1 or FLevel<2 THEN NULL ELSE SUBSTRING(FNumber, 1,CHARINDEX('.',FFullNumber)-1)  END, 
 '',
 CASE WHEN CHARINDEX('.',FFullNumber,CHARINDEX('.',FFullNumber)+1)-1= -1 or FLevel<3 THEN NULL ELSE SUBSTRING(FNumber, 1,CHARINDEX('.',FFullNumber,CHARINDEX('.',FFullNumber)+1)-1)  END, 
 '',
 CASE WHEN CHARINDEX('.',FFullNumber,CHARINDEX('.',FFullNumber,CHARINDEX('.',FFullNumber)+1)+1)-1= -1 or FLevel<4 THEN NULL ELSE SUBSTRING(FNumber, 1,CHARINDEX('.',FFullNumber,CHARINDEX('.',FFullNumber,CHARINDEX('.',FFullNumber)+1)+1)-1)  END, 
 '',
 CASE WHEN CHARINDEX('.',FFullNumber,CHARINDEX('.',FFullNumber,CHARINDEX('.',FFullNumber,CHARINDEX('.',FFullNumber)+1)+1)+1)-1= -1 or FLevel<5 THEN NULL ELSE SUBSTRING(FNumber, 1,CHARINDEX('.',FFullNumber,CHARINDEX('.',FFullNumber,CHARINDEX('.',FFullNumber,CHARINDEX('.',FFullNumber)+1)+1)+1)-1)  END, 
 '',
 FItemID,FNumber FROM t_Item
 WHERE FItemClassID=4
 AND FDetail=1  And exists (Select FItemID From #Happen Where #Happen.FItemID=t_Item.FItemID)
 UPDATE t0 SET t0.FName1=t1.FName,t0.FName2=t2.FName,t0.FName3=t3.FName,t0.FName4=t4.FName
  FROM #ItemLevel t0 left join t_Item t1 On t0.FNumber1=t1.FNumber  AND t1.FItemClassID=4 AND t1.FDetail=0 
 left join t_Item t2 On t0.FNumber2=t2.FNumber  AND t2.FItemClassID=4 AND t2.FDetail=0 
 left join t_Item t3 On t0.FNumber3=t3.FNumber  AND t3.FItemClassID=4 AND t3.FDetail=0 
 left join t_Item t4 On t0.FNumber4=t4.FNumber  AND t4.FItemClassID=4 AND t4.FDetail=0 

Create Table #Data(
FName1 Varchar(355) Null,
FName2 Varchar(355) Null,
FName3 Varchar(355) Null,
FName4 Varchar(355) Null,
     FNumber  Varchar(355) null,
     FShortNumber  Varchar(355) null,
     FName  Varchar(355) null,
     FModel  Varchar(355) null,
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
 Insert Into #Data 
select FName1, 
FName2, 
FName3, 
FName4, 
FNumber,'','','','',max(col5) ,max(col6),sum(FBegQty),case when sum(FBegQty) <> 0 then cast(sum(FBegBal) as Decimal(28,10))/cast(sum(FBegQty)as Decimal(28,10)) else 0 end,sum(FBegBal),sum(FInQty),case when sum(FInQty) <> 0 then cast(sum(FInAmount) as Decimal(28,10)) / cast(sum(FInQty) as Decimal(28,10))  else 0 end,sum(FInAmount),sum(FOutQty)
,case when sum(FOutQty) <> 0 then cast(sum(FOutAmount)as Decimal(28,10)) /cast(sum(FOutQty)as Decimal(28,10))  Else 0 end,sum(FOutAmount),sum(FEndQty) as FEndQty,case when sum(FEndQty)<>0 then cast(sum(FEndAmount)as Decimal(28,10)) /cast(sum(FEndQty)as Decimal(28,10))  else 0 end,sum(FEndAmount),
Case   When   Grouping(FName1)=1 THEN 106
  When   Grouping(FName2)=1 THEN 107
  When   Grouping(FName3)=1 THEN 108
  When   Grouping(FName4)=1 THEN 109
  When   Grouping(FNumber)=1 THEN 110  Else   0 END 
,Sum (FBegSecQty), Sum(FInSecQty), Sum(FOutSecQty), Sum(FBalSecQty) ,'',sum(FBegCUUnitQty),case when sum(FBegCUUnitQty)<>0 then cast(sum(FBegBal)as Decimal(28,10)) /cast(sum(FBegCUUnitQty) as Decimal(28,10)) else 0 end,sum(FInCUUnitQty),case when sum(FInCUUnitQty)<>0 then cast(sum(FInAmount)as Decimal(28,10)) /cast(sum(FInCUUnitQty)as Decimal(28,10))  else 0 end,sum(FOutCUUnitQty),case when sum(FOutCUUnitQty)<>0 then cast(sum(FOutAmount)as Decimal(28,10)) /cast(sum(FOutCUUnitQty)as Decimal(28,10))  else 0 end,sum(FEndCUUnitQty),case when sum(FEndCUUnitQty)<>0 then cast(sum(FEndAmount)as Decimal(28,10)) /cast(sum(FEndCUUnitQty)as Decimal(28,10))  else 0 end FROM ( Select tt1.FName1 as FName1,tt1.FName2 as FName2,tt1.FName3 as FName3,tt1.FName4 as FName4,t1.FNumber as FNumber,'' as col1,'' as col2,'' as col3,'' as col4,max(t1.FQtyDecimal) as col5,max(t1.FPriceDecimal) as col6,
SUM(ISNULL(v2.FBegQty,0)) as FBegQty,Case When SUM(ISNULL(v2.FBegQty,0))<>0 then cast(SUM(ISNULL(FBegBal,0))as Decimal(28,10))/cast(SUM(ISNULL(FBegQty,0)) as Decimal(28,10)) Else 0 End as FBegPrice,
SUM(ISNULL(v2.FBegBal,0)) as FBegBal,SUM(ISNULL(FInQty,0)) as FInQty,Case When SUM(ISNULL(FInQty,0))<>0 Then cast(SUM(ISNULL(FInAmount,0))as Decimal(28,10))/cast(SUM(FInQty) as Decimal(28,10)) Else 0 End as FInPrice,
SUM(ISNULL(FInAmount,0)) as FInAmount,SUM(ISNULL(FOutQty,0)) as FOutQty, Case When SUM(ISNULL(FOutQty,0))<>0 Then cast(SUM(ISNULL(FOutAmount,0))as Decimal(28,10))/cast(SUM(ISNULL(FOutQty,0)) as Decimal(28,10)) Else 0 End as FOutPrice,
SUM(ISNULL(FOutAmount,0)) as FOutAmount,SUM(ISNULL(FBegQty,0))+SUM(ISNULL(FInQty,0))-SUM(ISNULL(FOutQty,0)) as FEndQty,
Case When SUM(ISNULL(FBegQty,0))+SUM(ISNULL(FInQty,0))-SUM(ISNULL(FOutQty,0))<>0 Then cast((SUM(ISNULL(FBegBal,0))+SUM(ISNULL(FInAmount,0))-SUM(ISNULL(FOutAmount,0))) as Decimal(28,10))/cast((SUM(ISNULL(FBegQty,0))+SUM(ISNULL(FInQty,0))-SUM(ISNULL(FOutQty,0))) as Decimal(28,10)) Else 0 End as FEndPrice,
Sum(ISNULL(FBegBal,0))+Sum(ISNULL(FInAmount,0))-Sum(ISNULL(FOutAmount,0)) as FEndAmount,0 as FSumSort,Sum(ISNULL(v2.FBegSecQty,0)) as FBegSecQty,Sum(ISNULL(v2.FInSecQty,0)) as FInSecQty,Sum(ISNULL(v2.FOutSecQty,0)) as FOutSecQty,Sum(ISNULL(v2.FBegSecQty,0))+Sum(ISNULL(v2.FInSecQty,0))-Sum(ISNULL(v2.FOutSecQty,0)) as FBalSecQty,
'' as FCUUnitName,Sum(ISNULL(v2.FBegCUUnitQty,0)) as FBegCUUnitQty,Sum(ISNULL(v2.FInCUUnitQty,0)) as FInCUUnitQty,Sum(ISNULL(v2.FOutCUUnitQty,0)) as FOutCUUnitQty,
Sum(ISNULL(v2.FBegCUUnitQty,0)) +Sum(ISNULL(v2.FInCUUnitQty,0)) -Sum(ISNULL(v2.FOutCUUnitQty,0)) as FEndCUUnitQty 
 From #Happen1 v2
 Inner Join t_ICItem t1 On v2.FItemID=t1.FItemID
 Left Join t_Stock t2 On v2.FStockID=t2.FItemID
 Left Join t_AuxItem ta On v2.FAuxPropID=ta.FItemID
,#ItemLevel tt1
 Where 1=1  
 AND t1.FItemID=tt1.FItemID

 Group By tt1.FName1,tt1.FName2,tt1.FName3,tt1.FName4,t1.FNumber
 ) t  Group by FName1, 
FName2, 
FName3, 
FName4, 
FNumber with rollup
 Update t1 Set t1.FName=isnull(t2.FName,''),t1.FShortNumber=isnull(t2.FShortNumber,''),t1.FModel=isnull(t2.FModel,''),
 t1.FUnitName=t3.FName,t1.FQtyDecimal=t2.FQtyDecimal,t1.FPriceDecimal=t2.FPriceDecimal,t1.FCUUnitName=t4.FName
 From #DATA t1 Left Join t_ICItem t2 On t1.FNumber = t2.FNumber 
 Left Join t_MeasureUnit t3 On t2.FUnitID=t3.FMeasureUnitID 
 Left Join t_MeasureUnit t4 On t2.FStoreUnitID=t4.FMeasureUnitID
 Where t3.FStandard=1
update #data set FshortNumber = '合计' where fnumber = '合计'
Update #Data Set  FName1=FName1+'(小计)'  Where FSumSort=107
Update #Data Set  FName2=FName2+'(小计)'  Where FSumSort=108
Update #Data Set  FName3=FName3+'(小计)'  Where FSumSort=109
Update #Data Set  FName4=FName4+'(小计)'  Where FSumSort=110
Update #Data Set FName1='合计' Where FSumSort=106
Update #Data Set FSumSort=101   Where FSumSort=106

Select td.*,tm.FName As FSecUnitName From #Data td
 Left Join t_ICItem t On t.FNumber=td.FNumber
 Left Join t_MeasureUnit tm On t.FSecUnitID=tm.FMeasureUnitID
Where 1=1

 And td.FSumSort>100
 Order by td.FID Drop Table #Data  
Drop Table #ItemLevel
 Drop Table #Happen
 Drop Table #Happen1

-- =============================================
-- example to execute the store procedure
-- =============================================
--EXECUTE p_xy_SunyiShengchan_2 '2013','01'
