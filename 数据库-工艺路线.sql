use AIS20110915141051

select * from t_tabledescription where fdescription like '%资源%'

select * from t_routing t1
left join t_routingoper t2 on t1.finterid=t2.finterid
where fbillno='RT000074' and 

update t2 set FWorkCenterID=13589 from
t_routing t1
left join t_routingoper t2 on t1.finterid=t2.finterid
where fbillno='RT000078' and foperid=40026

select FParentID,* from t_resource
--================================================================
update t_icitem set FDefaultRoutingID=1010 where FitemiD=9497 and FDefaultRoutingID=0

select * from t_icitem  where FitemiD=9497

DELETE  T_Routing WHERE  FInterID=1010

INSERT INTO T_RoutingOper (FInterID,FEntryID,FBrNo,FOperSN,FOperID,Fnote,FWorkCenterID,FTimeUnit,FLeadTime,FTimeSetup,FWorkQty,FTimeRun,FMoveQty,FMoveTime,FAutoTD,FAutoOF,FFare,FISOut,FSupplyID,FFee,FQualityChkID,FQualityShcemeID,FFManagerID,FTeamID,FWorkerID,FDeviceID,FResourceCount,FConversion,FPieceRate,FMachStdTimeSetup,FMachStdTimeRun,FPersonStdTimeSetup,FPersonStdTimeRun,FEntrySelfZ0236,FEntrySelfZ0237,FEntrySelfZ0238,FEntrySelfZ0239) VALUES (1010,1,'0',10,40026,'','18500',11082,0,0,1,1,1,0,1059,1059,1059,1059,'0',0,352,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0) 
INSERT INTO T_RoutingOper (FInterID,FEntryID,FBrNo,FOperSN,FOperID,Fnote,FWorkCenterID,FTimeUnit,FLeadTime,FTimeSetup,FWorkQty,FTimeRun,FMoveQty,FMoveTime,FAutoTD,FAutoOF,FFare,FISOut,FSupplyID,FFee,FQualityChkID,FQualityShcemeID,FFManagerID,FTeamID,FWorkerID,FDeviceID,FResourceCount,FConversion,FPieceRate,FMachStdTimeSetup,FMachStdTimeRun,FPersonStdTimeSetup,FPersonStdTimeRun,FEntrySelfZ0236,FEntrySelfZ0237,FEntrySelfZ0238,FEntrySelfZ0239) VALUES (1010,2,'0',20,40034,'','12695',11082,0,0,1,1,1,0,1059,1059,1059,1059,'0',0,352,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0) 
INSERT INTO T_RoutingOper (FInterID,FEntryID,FBrNo,FOperSN,FOperID,Fnote,FWorkCenterID,FTimeUnit,FLeadTime,FTimeSetup,FWorkQty,FTimeRun,FMoveQty,FMoveTime,FAutoTD,FAutoOF,FFare,FISOut,FSupplyID,FFee,FQualityChkID,FQualityShcemeID,FFManagerID,FTeamID,FWorkerID,FDeviceID,FResourceCount,FConversion,FPieceRate,FMachStdTimeSetup,FMachStdTimeRun,FPersonStdTimeSetup,FPersonStdTimeRun,FEntrySelfZ0236,FEntrySelfZ0237,FEntrySelfZ0238,FEntrySelfZ0239) VALUES (1010,3,'0',30,40028,'','12696',11082,0,0,1,1,1,0,1059,1059,1059,1059,'0',0,352,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0) 

INSERT INTO T_Routing(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FRoutingName,FItemID,Fdefault,FParentID) VALUES (1010,'RT000040','0',51,0,0,'产品工艺路线',9497,1059,1001)

SELECT t1.FItemID AS FID,t2.FNumber,t2.FName FROM T_Routing t1  Inner Join t_Item t2 on t1.FItemID =t2.FItemID  WHERE t2.FItemClassID=4 AND t1.FInterID=1010 AND t2.FDetail=1 AND t2.FDeleted=1 

