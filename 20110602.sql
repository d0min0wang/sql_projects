SELECT * FROM t_tabledescription where fdescription like '%ÁìÁÏ%'


SELECT FKey,FValue FROM t_SystemProfile WHERE FCategory IN('IC','Base') AND FKey IN
('IsLocalBatch','ICClosed','SInvoiceDecimal','UseShortNumber','DoubleUnit','AuditChoice','AlertDiffStock','MoneyVisForRequestFromOrder','UpStockWhenSave','PoInvSynInPrice','SEOrderTaxInPrice','POOrderTaxInPrice','PoInvSynInPrice','NoAlertForExistsBillNO','PurTaxRateOption','SaleTaxRateOption','AutoCreateBatNo','BatchManual','PurchaseSupportPartiallyHook','SaleSupportPartiallyHook','POOrderAutoTransAfterApproval','SEOrderAutoTransAfterApproval','CarryInvAutoTransAfterAffirm','BillStatus','IsOkToModAfterClose','PrecisionOfDiscountRate','CurrentPeriod','CurrentYear','ApplyMapInPurchase','ApplyMapInSale','ApplyMapInStock','DoubleUnit','SecUnit','EnableATP','SEOrderOOSAlert','TransferBillType','BrID','ISUsePriceManage','AutoRSupplyWhenPOS','POOrderCanAppendItem','SEOrderCanAppendItem','EditSelfBill','PurHPriceControl','PurHPricePSW','PurHPriceZero','PurHPriceContrlPoint','IsUsePurPrcMgr','AlertHighPriceWhenCheck','AlertSELowPrice','AlertSELowPriceWhenCheck','ControlSelBillQty','AllowPurchase','ISUseMultiCheck','CreditEnable','OutBillBatchNoAuto','ISUsePriceManage','HookFutureBillAllowed','POQtyLargeStock','OrdStockOutByProportion','NumberControl','MakeZanGuVoucher','EnableMtoPlanMode','BillDiscount','DisCountIncludeTax','AffirmPayableDate','CalCostByBatch')
Union  Select FKey,FValue From ICPrcOpt where ((FKey='PrcSynBInv' OR FKey='IsTaxInPrc' OR FKey='ISUsePrcMgr' OR FKey='SOrdAutoUpdPrc') And FCategory='ICPrcPlyEls')  OR (FCategory='LowPrcCtrl' and FKey='CtrlTime')
Union  SELECT FKey,FValue FROM t_RP_SystemProfile WHERE  FKey IN ('FCheckAccount', 'FFinishInitAP', 'FFinishInitAR')
Union  SELECT FKey,FValue FROM t_SystemProfile WHERE FCategory='StdCost' AND FKey='StdCostStart'
Union  SELECT FKey,FValue FROM t_SystemProfile WHERE FCategory='IC_SUBC' AND FKey IN('AutoClientVerAfterCheck')

SELECT FName AS FName ,FTemplateID,FHeadTable,FEntryTable,FID, FCheckPRO,FROB,FFormWidth,FFormHeight,FFixCols  FROM ICTransactionType Where FID IN (24)
SELECT t1.FID,t1.FCtlIndex,t1.FTabIndex,t1.FCaption AS FCaption,t1.FCtlType,t1.FLookupCls,t1.FNeedSave,t1.FValueType,t1.FSaveValue,t1.FFieldName,t1.FLeft,t1.FTop,t1.FWidth,t1.FHeight,t1.FEnable,t1.FPrint,t1.FSelBill,t1.FMustInput,t1.FFilter,t1.FRelationID,
t1.FAction,t1.FLockA,t1.FROB,t1.FDefaultCtl,t1.FVisForBillType,t1.FVBACtlType,t1.FRelateOutTbl,t1.FSysMustInputItem,t1.FInEntryForSPrint,t1.FRMustInput,t1.FFormat,t1.FMaxValue,t1.FMinValue,t1.FDefaultValue,t1.FCtlIndex AS FNewCtlIndex,t1.FTabIndex AS FNewTabIndex,t1.FMaxValue,t1.FMinValue,t1.FAllowCopy, t1.FFontName, t1.FFontSize,t1.FLookUpType
FROM ICTemplate t1 INNER JOIN ICTransactionType t2 ON t1.FID=t2.FTemplateID
WHERE t2.FID= 24
 AND t1.FCtlType NOT IN ( 25) 
ORDER BY t1.FCtlIndex

SELECT t1.FID,t1.FCtlOrder,t1.FCtlIndex,t1.FCtlType,t1.FLookupCls,t1.FNeedSave,t1.FValueType,t1.FSaveValue,t1.FFieldName,t1.FEnable,t1.FPrint,t1.FHeadCaption AS FHeadCaption,CASE WHEN tu.FWidth IS NULL THEN t1.FWidth ELSE tu.FWidth END AS FWidth,t1.FNeedCount,CASE WHEN ISNULL(ta.FRelationID,'') ='' THEN t1.FRelationID ELSE ta.FRelationID END FRelationID,CASE WHEN ISNULL(ta.FAction,'') ='' THEN t1.FAction ELSE ta.FAction END AS FAction,t1.FMustInput,t1.FFilter,t1.FSaveRule,t1.FDefaultCtl,
CASE WHEN tu.FVisForBillType IS NULL THEN t1.FVisForBillType ELSE tu.FVisForBillType END AS FVisForBillType,t1.FRelateOutTbl,t1.FSysMustInputItem,t1.FStatCount,t1.FFormat,t1.FMaxValue,t1.FMinValue,t1.FDefaultValue,t1.FCtlOrder AS FNewCtlOrder,t1.FCtlIndex AS FNewCtlIndex,t1.FMaxValue,t1.FMinValue,t1.FAllowCopy,t1.FLookUpType,t1.FVisForBillType AS FVisForBillTypeSys,t1.FOptionExt
FROM ICTemplateEntry t1 INNER JOIN ICTransactionType t2 ON t1.FID=t2.FTemplateID
LEFT JOIN ICBillAction ta ON ta.FTransType = t2.FID AND ta.FFieldName=t1.FFieldName AND FFuncID = 3
LEFT JOIN ICUserTemplateEntry tu ON tu.FTemplateID= t1.FID AND tu.FFieldName= t1.FFieldName AND tu.FUserID = 16439
WHERE t2.FID= 24
ORDER BY t1.FCtlOrder

SELECT DISTINCT CAST(t4.FPlanPrice AS FLOAT) * CAST(t7.FCoefficient AS FLOAT) AS FAuxPlanPrice,t4.FUnitGroupID as FItemUnitGroupID,t4.FAuxClassID AS FAuxPropCls,
	0 AS FAuxPropID,'' AS FAuxPropName,'' AS FAuxPropNum,CASE WHEN (u1.FAuxQtyMust+u1.FAuxQtySupply-u1.FAuxQty)>0 THEN (u1.FAuxQtyMust+u1.FAuxQtySupply-u1.FAuxQty) ELSE 0 END AS FAuxQtyMust,
	t10.FName AS FBaseUnitName,u1.FBatchNo,v2.FBillNO,u1.FBomInterID,t73.FBomNumber AS FBomName,
	t73.FBomNumber,Case When FTraceTypeID=1 then (SELECT DISTINCT FCostCenterID FROM SHWorkBill s1 inner join SHWORKBillEntry s2 on s1.finterid=s2.finterid inner join t_WorkCenter wc on wc.FItemID=s2.FWorkCenterID where s1.FICMOInterID=v2.FInterID and s2.FOperSN=u1.FOperSN) else 0 END AS FCostCenterID,
	Case When FTraceTypeID=1 then (SELECT DISTINCT cc.FName FROM SHWorkBill s1 inner join SHWORKBillEntry s2 on s1.finterid=s2.finterid inner join t_WorkCenter wc on wc.FItemID=s2.FWorkCenterID inner join t_Base_CostCenter cc on cc.FItemID=wc.FCostCenterID where s1.FICMOInterID=v2.FInterID and s2.FOperSN=u1.FOperSN) else '' END AS FCostCenterName,
	Case When FTraceTypeID=1 then (SELECT DISTINCT cc.FNumber FROM SHWorkBill s1 inner join SHWORKBillEntry s2 on s1.finterid=s2.finterid inner join t_WorkCenter wc on wc.FItemID=s2.FWorkCenterID inner join t_Base_CostCenter cc on cc.FItemID=wc.FCostCenterID where s1.FICMOInterID=v2.FInterID and s2.FOperSN=u1.FOperSN) else '' END AS FCostCenterNumber,
	v2.FCostOBJID,(SELECT FModel FROM t_ICItem WHERE FItemID=t41.FStdProductID) AS FCostOBJModel,
	t41.FName AS FCostOBJName,t41.FNumber AS FCostOBJNumber,u1.FEntryID,(SELECT FBillNO FROM ICMO WHERE ICMO.FInterID=u1.FICMOInterID) AS FICMOBillNo,
	u1.FICMOInterID,v1.FInterID,u1.FItemID,GetDate() AS FKFDate,t4.FKFPeriod,t4.Fmodel,
	u1.FMTONo,t4.FName,u1.FNote,t4.FNumber,u1.FOperID,t15.FName AS FOperIDName,t15.FID AS FOperIDNumber,
	u1.FOperSN,u1.FPlanMode,tPlanMode.FName AS FPlanModeName,tPlanMode.FID AS FPlanModeNumber,
	u1.FEntryID AS FPPBomEntryID,CASE WHEN (SELECT ISNULL(FValue,'1') FROM T_SystemProfile WHERE FCategory='IC' AND FKey='DefaultStockQtyLessInv')='1' THEN (CASE WHEN t4.FAuxClassID>0 THEN 0 ELSE (CASE WHEN (u1.FAuxQtyMust+u1.FAuxQtySupply-u1.FAuxQty)>0 THEN (CASE WHEN (u1.FAuxQtyMust+u1.FAuxQtySupply-u1.FAuxQty)>ISNULL(t444.FQty,0)/CAST(t7.FCoefficient AS FLOAT) THEN (CASE WHEN ISNULL(t444.FQty,0)>0 THEN ISNULL(t444.FQty,0)/CAST(t7.FCoefficient AS FLOAT) ELSE 0 END) ELSE (u1.FAuxQtyMust+u1.FAuxQtySupply-u1.FAuxQty)END)ELSE 0 END)END) ELSE (CASE WHEN (u1.FAuxQtyMust+u1.FAuxQtySupply-u1.FAuxQty)>0 THEN u1.FAuxQtyMust+u1.FAuxQtySupply-u1.FAuxQty ELSE 0 END) END AS FPPomAuxQty,
	CASE WHEN (SELECT ISNULL(FValue,'1') FROM T_SystemProfile WHERE FCategory='IC' AND FKey='DefaultStockQtyLessInv')='1' THEN (CASE WHEN t4.FAuxClassID>0 THEN 0 ELSE (CASE WHEN (u1.FQtyMust+u1.FQtySupply-u1.FQty)>0 THEN (CASE WHEN (u1.FQtyMust+u1.FQtySupply-u1.FQty)>ISNULL(t444.FQty,0) THEN(CASE WHEN ISNULL(t444.FQty,0)>0 THEN ISNULL(t444.FQty,0)ELSE 0 END) ELSE (u1.FQtyMust+u1.FQtySupply-u1.FQty)END)ELSE 0 END)END) ELSE (CASE WHEN (u1.FQtyMust+u1.FQtySupply-u1.FQty)>0 THEN u1.FQtyMust+u1.FQtySupply-u1.FQty ELSE 0 END) END AS FPPomQty,
	t4.FPriceDecimal,(SELECT FNAME FROM t_SubMessage WHERE FInterID=(CASE WHEN v2.FType = 1055 THEN 12001 ELSE 12000 END)) AS FPurposeFNumber,
	(CASE WHEN v2.FType = 1055 THEN 12001 ELSE 12000 END) AS FPurposeID,(SELECT FNAME FROM t_SubMessage WHERE FInterID=(CASE WHEN v2.FType = 1055 THEN 12001 ELSE 12000 END)) AS FPurposeName,
	t4.FQtyDecimal,CASE WHEN (u1.FQtyMust+u1.FQtySupply-u1.FQty)>0 THEN (u1.FQtyMust+u1.FQtySupply-u1.FQty) ELSE 0 END AS FQtyMust,
	(SELECT FNAME FROM t_SubMessage WHERE FInterID=(CASE WHEN v2.FType = 1055 AND u1.FItemID IN (SELECT FProductID FROM cb_CostObj_Product WHERE FCostObjID=v2.FCostObjID AND FISDeputy<>1) THEN 1058 ELSE 1059 END)) AS FReProduceTypeFNumber,
	(CASE WHEN v2.FType = 1055 AND u1.FItemID IN (SELECT FProductID FROM cb_CostObj_Product WHERE FCostObjID=v2.FCostObjID AND FISDeputy<>1) THEN 1058 ELSE 1059 END) AS FReProduceTypeID,
	(SELECT FNAME FROM t_SubMessage WHERE FInterID=(CASE WHEN v2.FType = 1055 AND u1.FItemID IN (SELECT FProductID FROM cb_CostObj_Product WHERE FCostObjID=v2.FCostObjID AND FISDeputy<>1) THEN 1058 ELSE 1059 END)) AS FReProduceTypeName,
	Case When t4.FSecCoefficient>0 Then t4.FSecCoefficient Else t501.FCoefficient End  AS FSecCoefficient,
	(Case When t4.FSecCoefficient>0 Then (CASE WHEN (SELECT ISNULL(FValue,'1') FROM T_SystemProfile WHERE FCategory='IC' AND FKey='DefaultStockQtyLessInv')='1' THEN (CASE WHEN t4.FAuxClassID>0 THEN 0 ELSE (CASE WHEN (u1.FQtyMust+u1.FQtySupply-u1.FQty)>0 THEN (CASE WHEN (u1.FQtyMust+u1.FQtySupply-u1.FQty)>ISNULL(t444.FQty,0) THEN(CASE WHEN ISNULL(t444.FQty,0)>0 THEN ISNULL(t444.FQty,0)ELSE 0 END) ELSE (u1.FQtyMust+u1.FQtySupply-u1.FQty)END)ELSE 0 END)END) ELSE (CASE WHEN (u1.FQtyMust+u1.FQtySupply-u1.FQty)>0 THEN u1.FQtyMust+u1.FQtySupply-u1.FQty ELSE 0 END) END)/t4.FSecCoefficient Else (Case When t501.FCoefficient>0 Then (CASE WHEN (SELECT ISNULL(FValue,'1') FROM T_SystemProfile WHERE FCategory='IC' AND FKey='DefaultStockQtyLessInv')='1' THEN (CASE WHEN t4.FAuxClassID>0 THEN 0 ELSE (CASE WHEN (u1.FQtyMust+u1.FQtySupply-u1.FQty)>0 THEN (CASE WHEN (u1.FQtyMust+u1.FQtySupply-u1.FQty)>ISNULL(t444.FQty,0) THEN(CASE WHEN ISNULL(t444.FQty,0)>0 THEN ISNULL(t444.FQty,0)ELSE 0 END) ELSE (u1.FQtyMust+u1.FQtySupply-u1.FQty)END)ELSE 0 END)END) ELSE (CASE WHEN (u1.FQtyMust+u1.FQtySupply-u1.FQty)>0 THEN u1.FQtyMust+u1.FQtySupply-u1.FQty ELSE 0 END) END)/t501.FCoefficient Else 0 End) End) AS FSecQty,
	t501.FName AS FSecUnitName,v2.FTranType AS FSelTranTypeID,(SELECT FName FROM v_ICTransType WHERE FID=v2.FTranType) AS FSelTranTypeName,
	(SELECT FName FROM v_ICTransType WHERE FID=v2.FTranType) AS FSelTranTypeNumber,
	v2.FBillNo AS FSourceBillNo,u1.FEntryID AS FSourceEntryID,v2.FInterId AS FSourceInterID,
	v2.FTranType AS FSourceTranType,(CASE WHEN u1.FSPID>0 AND t5.FTypeID NOT IN (501,502,503) THEN u1.FSPID ELSE (SELECT ISNULL(t_StockPlace.FSPID,0) FROM t_StockPlace INNER JOIN t_Stock ON t_StockPlace.FSPGroupID = t_Stock.FSPGroupID WHERE t_StockPlace.FSPID = t4.FSPID AND t4.FDefaultLoc = t_Stock.FItemID AND t_Stock.FTypeID NOT IN (501,502,503)) END) AS FSPID,
	(CASE WHEN u1.FSPID>0 AND t5.FTypeID NOT IN (501,502,503) THEN t8.FName ELSE (SELECT ISNULL(t_StockPlace.FName,'') FROM t_StockPlace INNER JOIN t_Stock ON t_StockPlace.FSPGroupID = t_Stock.FSPGroupID WHERE t_StockPlace.FSPID = t4.FSPID AND t4.FDefaultLoc = t_Stock.FItemID AND t_Stock.FTypeID NOT IN (501,502,503)) END) AS FSPIDName,
	(CASE WHEN u1.FSPID>0 AND t5.FTypeID NOT IN (501,502,503) THEN t8.FNumber ELSE (SELECT ISNULL(t_StockPlace.FNumber,'') FROM t_StockPlace INNER JOIN t_Stock ON t_StockPlace.FSPGroupID = t_Stock.FSPGroupID WHERE t_StockPlace.FSPID = t4.FSPID AND t4.FDefaultLoc = t_Stock.FItemID AND t_Stock.FTypeID NOT IN (501,502,503)) END) AS FSPIDNumber,
	(CASE WHEN u1.FStockID>0 AND t5.FTypeID NOT IN (501,502,503) THEN u1.FStockID ELSE (SELECT ISNULL(t_Stock.FItemID,0) FROM t_Stock WHERE FItemID = t4.FDefaultLoc AND FTypeID NOT IN (501,502,503)) END) AS FStockID,
	(CASE WHEN u1.FStockID>0 AND t5.FTypeID NOT IN (501,502,503) THEN t5.FName ELSE (SELECT ISNULL(t_Stock.FName,'') FROM t_Stock WHERE FItemID = t4.FDefaultLoc AND FTypeID NOT IN (501,502,503)) END) AS FStockName,
	(CASE WHEN u1.FStockID>0 AND t5.FTypeID NOT IN (501,502,503) THEN t5.FNumber ELSE (SELECT ISNULL(t_Stock.FNumber,'') FROM t_Stock WHERE FItemID = t4.FDefaultLoc AND FTypeID NOT IN (501,502,503)) END) AS FStockNumber,
	t4.FTrack,u1.FUnitID,t7.FName AS FUnitName,t7.FNumber AS FUnitNumber,u1.FWIPAuxQty,
	u1.FWIPQty,v2.FWorkShop,t2.FName AS FWorkShopName,t2.FNumber AS FWorkShopNumber
 FROM ICMO v2 WITH (READPAST)
	LEFT OUTER JOIN t_Department t2 ON  v2.FWorkShop=t2.FItemID
	INNER JOIN PPBOM v1 WITH (READPAST) ON  v2.FInterID=v1.FICMOInterID
	LEFT OUTER JOIN cbCostObj t41 ON  v2.FCostObjID=t41.FItemID
	INNER JOIN t_WorkType tw ON  v2.FWorktypeID=tw.FInterID
	INNER JOIN PPBOMEntry u1 WITH (READPAST) ON  v1.FInterID=u1.FInterID
	INNER JOIN t_ICItem t4 ON  u1.FItemID=t4.FItemID
	INNER JOIN t_MeasureUnit t7 ON  u1.FUnitID=t7.FItemID
	LEFT OUTER JOIN t_Stock t5 ON  u1.FStockID=t5.FItemID
	LEFT OUTER JOIN t_StockPlace t8 ON  u1.FSPID=t8.FSPID
	LEFT OUTER JOIN t_SubMessage t15 ON  u1.FOperID=t15.FInterID
	LEFT OUTER JOIN ICBOM t73 ON  u1.FBomINTerID=t73.FINTerID
	LEFT OUTER JOIN ICInventory t444 ON  u1.FStockID=t444.FStockID AND u1.FSPID=t444.FStockPlaceID AND u1.FItemID=t444.FItemID AND u1.FBatchNO=t444.FBatchNO AND u1.FMTONo=t444.FMTONo
	LEFT OUTER JOIN t_SubMessage tplanmode ON  u1.FPlanMode=tplanmode.FInterID
	INNER JOIN t_MeasureUnit t10 ON  t4.FUnitID=t10.FItemID
	LEFT OUTER JOIN t_MeasureUnit t501 ON  t4.FSecUnitID=t501.FItemID
WHERE ((v1.FInterID=32306 AND u1.FEntryID=1))  And (t4.FISKFPeriod=0 OR t444.FKFDate IS NULL OR t444.FKFDate  in (Select Max(FKFDate) From ICInventory t4444 Where u1.FStockID=t4444.FStockID AND u1.FSPID=t4444.FStockPlaceID AND u1.FItemID=t4444.FItemID AND u1.FBatchNO=t4444.FBatchNO)) 
ORDER BY v1.FInterID, u1.FEntryID
