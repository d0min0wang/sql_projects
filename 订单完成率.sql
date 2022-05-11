--select * from t_tabledescription where fdescription like '%订单%'
--
--select top 100 * from SEOrderEntry
--
--select t2.FTableName,t2.fdescription ,t1.* from t_fielddescription t1
--left join  t_tabledescription t2 on t1.FTableID=t2.FTableID
--where 
--t1.fdescription like '%关闭%'
--ftableid=230004
--
----t1.fstatus 审核
----t1.fclosed 关闭
--
--select t1.FBillNo,t2.FAuxQty,t2.FDate,t2.FMRPClosed,t1.fclosed,t1.fstatus from SEOrder t1
--left join SEOrderEntry t2 ON t1.FInterID=t2.FInterID
--where t1.FClosed=0 
----and t1.FBillNo='A07083141'
--order by t2.FDate
--
--
--Select top 1000000 v1.FTranType as FTranType,v1.FInterID as FInterID,u1.FEntryID as FEntryID,
--case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end  as FCheck,
--CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,
--v1.Fdate as Fdate,v1.FBillNo as FBillNo,v1.FChangeDate as FChangeDate,
--v1.FVersionNo as FVersionNo,case when v1.FCancellation=1 then 'Y' else '' end as FCancellation, 
--0 As FBOSCloseFlag from SEOrder v1 INNER JOIN SEOrderEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
-- where 1=1
----AND (case when u1.FMRPClosed=1 then 'Y' else '' end IS NULL OR case when u1.FMRPClosed=1 then 'Y' else '' end='')
--AND (ISNULL(v1.FBillNo,'') LIKE '%A11%'
--)  AND (v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007100))
--
--
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
--Select top 1000000 v1.FTranType as FTranType,v1.FInterID as FInterID,u1.FEntryID as FEntryID,u1.Fauxqty as Fauxqty,t16.FQtyDecimal as FQtyDecimal,t16.FPriceDecimal as FPriceDecimal,u1.FAllAmount as FAllAmount,u1.FSecQty as FSecQty 
--from SEOrder v1 INNER JOIN SEOrderEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
-- INNER JOIN t_ICItem t16 ON     u1.FItemID = t16.FItemID   AND t16.FItemID <>0 
-- where 1=1 AND (   
--ISNULL(v1.FBillNo,'') LIKE '%A110101497%'
--  AND  
--(case when u1.FMRPClosed=1 then 'Y' else '' end IS NULL OR case when u1.FMRPClosed=1 then 'Y' else '' end='')
--) AND (v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007100))


----BEGIN
----所有订单(backup)
----SET NOCOUNT ON
----DECLARE @FFetchDate str
----@FFetchDate='2011-01-10'
--
--Select
--v1.FBillNo,w1.FName,
--case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end  as FCheck,
--case when u1.FMRPClosed=1 then 'Y' else '' end as FMRPClosed,
--CASE WHEN v1.FStatus = 3 OR v1.FClosed = 1 THEN 'Y' ELSE '' END as FCloseStatus,
--u1.Fdate as Fdate
--from SEOrder v1 
--INNER JOIN SEOrderEntry u1 ON  v1.FInterID = u1.FInterID AND u1.FInterID <>0
--LEFT JOIN t_Department w1 on v1.FDeptID=w1.FItemID
-- where 1=1
--AND (case when u1.FMRPClosed=1 then 'Y' else '' end IS NULL OR case when u1.FMRPClosed=1 then 'Y' else '' end='')
--AND (case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end='Y')
--AND (case when v1.FCancellation=1 then 'Y' else '' end IS NULL OR case when v1.FCancellation=1 then 'Y' else '' end ='')
--AND (ISNULL(v1.FBillNo,'') LIKE '%A11%'
--)  AND (v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007100))
--AND u1.FDate>=DateAdd(M,-3,getDate())
--AND u1.FDate<=getDate()

--BEGIN
--所有订单
--SET NOCOUNT ON
--DECLARE @FFetchDate str
--@FFetchDate='2011-01-10'
--select t2.FName,count(t1.FBillNo)
--from SEOrder t1
--LEFT JOIN t_Department t2 on t1.FDeptID=t2.FItemID
--RIGHT JOIN(
--Select distinct v1.FBillNo
--from SEOrder v1 
--INNER JOIN SEOrderEntry u1 ON  v1.FInterID = u1.FInterID AND u1.FInterID <>0
-- where 1=1
----AND (case when u1.FMRPClosed=1 then 'Y' else '' end IS NULL OR case when u1.FMRPClosed=1 then 'Y' else '' end='')
--AND (case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end='Y')
--AND (case when v1.FCancellation=1 then 'Y' else '' end IS NULL OR case when v1.FCancellation=1 then 'Y' else '' end ='')
--AND (v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007100))
--AND u1.FDate>=DateAdd(M,-3,getDate())
--AND u1.FDate<=getDate()) t3 ON t3.FBillNo=t1.FBillNo
--GROUP BY t2.FName

--订单超期天数

CREATE TABLE #temp_SEOrder_Comfirm(FDeptName nvarchar(255),FOrderBillNo nvarchar(255),FOrderBillInterID int,FFetchDate datetime)
CREATE TABLE #temp_Ontime_to_Delivery(FDeptName nvarchar(255),FOrderBillNo nvarchar(255),FDelaytime int)
 
INSERT INTO #temp_SEOrder_Comfirm
select t2.FName,t1.FBillNo,t1.FInterID,t3.FDate
from SEOrder t1
LEFT JOIN t_Department t2 on t1.FDeptID=t2.FItemID
INNER JOIN SEOrderEntry t3 ON  t1.FInterID = t3.FInterID AND t3.FInterID <>0
RIGHT JOIN(
Select distinct v1.FBillNo
from SEOrder v1 
INNER JOIN SEOrderEntry u1 ON  v1.FInterID = u1.FInterID AND u1.FInterID <>0
 where 1=1
AND u1.FMRPClosed=1
--AND (case when u1.FMRPClosed=1 then 'Y' else '' end IS NULL OR case when u1.FMRPClosed=1 then 'Y' else '' end='')
AND (case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end='Y')
AND (case when v1.FCancellation=1 then 'Y' else '' end IS NULL OR case when v1.FCancellation=1 then 'Y' else '' end ='')
AND (v1.FChangeMark=0 AND ( Isnull(v1.FClassTypeID,0)<>1007100))
AND u1.FDate>=DateAdd(M,-3,getDate())
AND u1.FDate<=getDate()) t4 ON t4.FBillNo=t1.FBillNo

--INSERT INTO #temp_Ontime_to_Delivery
--select t1.FDeptName,t2.FBillNo,DATEDIFF(day,t1.FFetchDate,t3.FCheckDate) AS FOverLoad
--from #temp_SEOrder_Comfirm t1
--LEFT JOIN ICStockBillEntry t2 ON t1.FOrderBillNo=t2.FOrderBillNo
--LEFT JOIN ICStockBill t3 ON t2.FInterID=t3.FInterID
--where t3.FTranType=21 And t3.FCheckerID>0 

--select distinct * from #temp_Ontime_to_Delivery

select t1.*,t3.FCheckDate,t2.FOrderBillNo,t2.FOrderEntryID,t2.FOrderInterID,DATEDIFF(day,t1.FFetchDate,t3.FCheckDate) AS FOverLoad
from #temp_SEOrder_Comfirm t1
LEFT JOIN ICStockBillEntry t2 ON t1.FOrderBillNo=t2.FOrderBillNo
LEFT JOIN ICStockBill t3 ON t2.FInterID=t3.FInterID
where t3.FTranType=21 And t3.FCheckerID>0 
order by t2.FOrderBillNo


DROP TABLE #temp_SEOrder_Comfirm
DROP TABLE #temp_Ontime_to_Delivery



--Select top 100000 v1.FBillNo,v1.FCheckDate,u1.FOrderBillNo,u1.FOrderInterID
--From ICStockBill v1 inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
--Where v1.FTranType=21 And v1.FCheckerID>0 
--
--select * from t_tabledescription where fdescription like '%出入%'
----210008 210009
--select * from t_fielddescription where ftableid=210009
--
--select top 100 * from SEOrderEntry
--
