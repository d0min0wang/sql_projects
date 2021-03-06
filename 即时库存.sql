Set Nocount on
Create Table #TempInventory( 
                            [FBrNo] [varchar] (10)  NOT NULL ,
                            [FItemID] [int] NOT NULL ,
                            [FBatchNo] [varchar] (200)  NOT NULL ,
                            [FMTONo] [varchar] (200)  NOT NULL ,
                            [FStockID] [int] NOT NULL ,
                            [FQty] [decimal](28, 10) NOT NULL ,
                            [FBal] [decimal](20, 2) NOT NULL ,
                            [FStockPlaceID] [int] NULL ,
                            [FKFPeriod] [int] NOT NULL Default(0),
                            [FKFDate] [varchar] (255)  NOT NULL ,
                            [FMyKFDate] [varchar] (255), 
                            [FStockTypeID] [Int] NOT NULL,
                            [FQtyLock] [decimal](28, 10) NOT NULL,
                            [FAuxPropID] [int] NOT NULL,
                            [FSecQty] [decimal](28, 10) NOT NULL
                             )
Insert Into #TempInventory 
Select u1.FBrNo,
	u1.FItemID,
	u1.FBatchNo,
	u1.FMTONo,
	u1.FStockID,
	u1.FQty,
	u1.FBal,
	u1.FStockPlaceID,
	u1.FKFPeriod,
	ISNULL(u1.FKFDate,''),
	ISNULL(u1.FKFDate,''),
	500,
	u1.FQtyLock,
	u1.FAuxPropID,
	u1.FSecQty 
From ICInventory u1 where u1.FQty<>0 

Insert Into #TempInventory 
Select 
	u1.FBrNo,
	u1.FItemID,
	u1.FBatchNo,
	u1.FMTONo,
	u1.FStockID,
	u1.FQty,
	u1.FBal,
	u1.FStockPlaceID,
	u1.FKFPeriod,
	ISNULL(u1.FKFDate,''),
	ISNULL(u1.FKFDate,''),
	u1.FStockTypeID,
	0,
	u1.FAuxPropID,
	u1.FSecQty 
From POInventory u1 where u1.FQty<>0 

Select u1.FAuxPropID,
	case when u1.FSecQty=0 then 0 else ROUND(u1.FQty/u1.FSecQty,t1.FQtyDecimal) end as FConvRate,
	u1.FStockTypeID,
	t1.FName as FMaterialName,
	t1.FModel as FMaterialModel,t19.FName as FSecUnitName,t19.FNumber as FSecUnitNumber,
u1.FBatchNo,u1.FMTONo,t2.FName as FStockName ,u1.FQtyLock as FBUQtyLock,u1.FQtyLock/t4.FCoefficient as FCUUQtyLock,
t5.FName as FSPName,u1.FKFPeriod,case when isdate(u1.FKFDate)=1 then Convert(datetime,u1.FKFDate) else null end as FKFDate,
 case when isdate(u1.FMyKFDate)=1 then Convert(datetime,u1.FMyKFDate) else null end as FMyKFDate, t3.FName as FBUUnitName,t3.FNumber as FBUUnitNumber,ROUND(u1.FQty,t1.FQtydecimal) as FBUQty,
t4.FName as FCUUnitName ,ROUND(u1.FQty/t4.FCoefficient,t1.FQtyDecimal) as FCUUQty,t1.FQtyDecimal, t1.FPriceDecimal,0 as FSumSort,
Case when isdate(u1.FKFDate)=0 then '' else Convert(datetime,u1.FKFDate) + u1.FKFPeriod END AS FMaturityDate,
t2.FNumber AS FStockNumber, t1.FNumber AS FMaterialNumber,t1.FNumber AS FLongNumber,t5.FNumber as FSPNumber,t4.FNumber as FCUUnitCode,t4.FMeasureunitID as FCUUnitID
,t1.FitemID ,T2.FitemID FStockID,T5.FSPID FSPID,t9.FName as FAuxPropName,t9.FNumber as FAuxPropNumber,ROUND(u1.FSecQty,t1.FQtyDecimal) AS FSecQty,t1.FSecCoefficient AS FItemSecCoefficient From #TempInventory u1
 left join t_ICItem t1 on u1.FItemID = t1.FItemID
left join t_Stock t2 on u1.FStockID=t2.FItemID
left join t_MeasureUnit t3 on t1.FUnitID=t3.FMeasureUnitID
left join t_MeasureUnit t4 on t1.FStoreUnitID=t4.FMeasureUnitID
left join t_StockPlace t5 on u1.FStockPlaceID=t5.FSPID
 left join t_AuxItem t9 on u1.FAuxPropID=t9.FItemID left join t_Measureunit t19 on t1.FSecUnitID=t19.FMeasureunitID  where (Round(u1.FQty,t1.FQtyDecimal)<>0 OR Round(u1.FQty/t4.FCoefficient,t1.FQtyDecimal)<>0) 
 and t1.FDeleted=0 

 AND t2.FItemID=14403
 AND t2.FTypeID in (500,20291,20293)
 Order By t1.FNumber,u1.FBatchNo
,u1.FMTONo Drop Table #TempInventory