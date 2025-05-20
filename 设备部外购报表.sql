Select v1.FDate,
    v1.fbillno,
    t103.FName,
    t7.FName,
    t8.FName,
    t1.FName,
    t1.FModel,
    t2.FName,
    u1.FAuxQty,
    u1.FEntrySelfP0141,
    v1.FMultiCheckDate2,
    u1.FFetchTime,
    --u1.FSourceBillNo,
    CASE when t5.FAuxQty>=u1.FEntrySelfP0141 then '是' else '否' end ,
    t5.FauxQty,
    t6.FDate,
    IIF(DATEDIFF(day,u1.FFetchTime,t6.FDate)>=0,DATEDIFF(day,u1.FFetchTime,t6.FDate),NULL)
from POrequest v1 
INNER JOIN POrequestEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
LEFT join t_ICItem t1 ON u1.FItemID=t1.FItemID
LEFT join t_MeasureUnit t2 ON t1.FUnitGroupID=t2.FUnitGroupID
left join poorderentry t3 on u1.FInterID=t3.FSourceInterId and u1.FEntryID=t3.FSourceEntryID
left join POOrder t4 on t3.FInterID=t4.FInterID --and t4.FClassTypeID=
Left Join ICStockBillEntry t5 on t3.FInterID=t5.FOrderInterID and t3.FEntryID=t5.FOrderEntryID--t3.FInterID=t4.FInterID  
LEFT join ICStockBill t6 ON t5.FInterID=t6.FInterID
 LEFT OUTER JOIN t_Department t7 ON     v1.FDeptID = t7.FItemID   AND t7.FItemID <>0 
 LEFT OUTER JOIN t_Emp t8 ON     v1.FRequesterID = t8.FItemID   AND t8.FItemID <>0 
 LEFT OUTER JOIN t_Submessage t103 ON   v1.FBizType = t103.FInterID  AND t103.FInterID<>0 
 where t6.FTranType=1 
 AND
 v1.FInterID = 14926
 
 
  (     
v1.Fdate >=  '2025-03-01' 
  AND  
u1.Fauxqty  > 0.0000000000
  AND  
 NOT (t103.FName IS NULL OR t103.FName='')
  AND  
 NOT (t5.FName IS NULL OR t5.FName='')
  AND  
 NOT (t8.FName IS NULL OR t8.FName='')
  AND  
u1.FEntrySelfP0141  > 0.0000000000
)

SELECT * FROM t_TableDescription where FDescription LIKE '%入库%'



SELECT * FROM t_FieldDescription WHERE FTableID=210008 --ORDER BY FDescription
AND FDescription LIKE '%数量%'

SELECT * FROM PORequest where finterid=14926

SELECT POOrderEntry.FSourceInterID,* FROM POOrder WHERE FInterID = 16961 AND FEntryID = 1

SELECT POOrderEntry.FSourceInterID,*   FROM  POOrder  INNER JOIN POOrderEntry  ON POOrder.FInterID=POOrderEntry.FInterID
where POOrder.FBillNo='POORD015820'
 WHERE POOrder.FClassTypeID = 1007101 And POOrderEntry.FSourceInterID = 14926 AND POOrderEntry.FSourceEntryID IN ( 1 )  And POOrderEntry.FSourceTranType = -70) AND POOrder.FClassTypeID=1007101