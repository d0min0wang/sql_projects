Select 
	t2.FName as FDeptName,
	v1.FBillNo as FOrderBillNo,
	v1.FInterID as FOrderInterID,
	u1.FEntryID as FOrderEntryID,
	u1.FDate as FFetchtime,
	u1.FMRPClosed as FMRPClosed,
	v1.FClosed as FClosed
from SEOrder v1 
LEFT JOIN SEOrderEntry u1 ON  v1.FInterID = u1.FInterID AND u1.FInterID <>0
LEFT JOIN t_Department t2 on v1.FDeptID=t2.FItemID
 where 1=1
--AND u1.FMRPClosed=1
--AND (case when u1.FMRPClosed=1 then 'Y' else '' end IS NULL OR case when u1.FMRPClosed=1 then 'Y' else '' end='')
AND (case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end='Y')
AND (case when v1.FCancellation=1 then 'Y' else '' end IS NULL OR case when v1.FCancellation=1 then 'Y' else '' end ='')
AND (v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007100))
AND CONVERT(VARCHAR(10),u1.FDate,120)>='2011-03-01'
AND CONVERT(VARCHAR(10),u1.FDate,120)<='2011-03-31'
AND v1.FInterID NOT IN (SELECT FOrderInterID FROM ICStockBillEntry WHERE FSourceTranType=83 )

select * from t_Item
----------------------test-------------
--17736 FTT250-3.7-21B/B02

select * from t_tabledescription where ftablename like '%source%'
--250012
select * from ICBillType
--250014

select * from t_fielddescription where ftableid=17

select * from ICMrpResult


LEFT JOIN t_Routing t1 ON i.FItemID=t1.FItemID
left join t_RoutingOper t2 ON t1.FInterID=t2.FInterID
left join t_submessage t3 ON t2.FOperID=t3.FName

select * from ICBOMCHILD where foperid=40027

SELECT DISTINCT t3.FInterID, t3.FParentID, t3.FName, t3.FNumber, t3.FBootID, t3.FIsShowDetail 
FROM IcBom t1 
INNER JOIN ICBomChild t2 ON t1.FInterID = t2.FInterID 
--INNER JOIN #IcBomGroup t3 ON t1.FParentID = t3.FinterID 
INNER JOIN t_IcItem t4 ON t1.FItemID = t4.FItemID 
LEFT JOIN t_User t5 ON t1.FCheckerID = t5.FUserID 
LEFT JOIN t_User t6 ON t1.FCheckID = t6.FUserID 

WHERE 1 = 1  AND t4.FNumber >= '90.A.FTT.FTT250-37-21B-BA20'
 AND t4.FNumber <= '90.A.FTT.FTT250-37-21B-BA20'
 AND ((t1.FAudDate BETWEEN '2007-09-01' AND '2100-03-03') OR t1.FAudDate IS NULL) 
 AND ((t1.FCheckDate BETWEEN '2007-09-30' AND '2100-01-03') OR t1.FCheckDate IS NULL)

select t1.FItemID,t1.FRoutingID,t3.FOperID from IcBom t1
LEFT JOIN t_Routing t2 ON t1.FRoutingID=t2.FInterID
left join t_RoutingOper t3 ON t2.FInterID=t3.FInterID
where t1.FItemID=14921
where t3.foperid=40034 --剪尾
--40026 成型
--40027 --剪尾
--40028 包装
--40033 质检
select t1.FBomNumber,t1.FRoutingID,t2.FName from IcBom t1
left join t_ICItem t2 ON t1.FItemID=t2.FItemID
where t1.FRoutingID='' OR t1.FRoutingID is null

select distinct FSourceTranType from ICStockBillEntry
--0
--1
--10
--24
--29
--41
--71
--75
--82
--83
--85
--551
--1002519
--1002520

select FSourceTranType,FSourceInterID,FSourceBillNo from ICStockBillEntry where FSourceTranType=41

select top 100000 FICMOBillNo,* from ICStockBillEntry where FICMOBillNo<>'' and 

select top 1000000 FOrderInterID,FSourceTranType,FSourceInterID,FSourceBillNo from ICStockBillEntry where FOrderInterID>0

select FOrderInterID,FSourceTranType,FSourceInterID,FSourceBillNo from ICStockBillEntry where FOrderInterID>0 and FSourceBillNo like '%B%'
