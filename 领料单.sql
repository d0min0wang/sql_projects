SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
Select top 1000000 u1.FDetailID as FListEntryID,v1.FVchInterID as FVchInterID,v1.FTranType as FTranType,v1.FInterID as FInterID,u1.FEntryID as FEntryID,v1.Fdate as Fdate,case  when v1.FCheckerID>0 then 'Y' when v1.FCheckerID<0 then 'Y' else '' end as FCheck,case when v1.FCancellation=1 then 'Y' else '' end as FCancellation,v1.FBillNo as FBillNo,u1.FQtyMust as FBaseQtyMust,case when (v1.FROB <> 1) then 'Y' else '' end as FRedFlag, 0 As FBOSCloseFlag from ICStockBill v1 INNER JOIN ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0 
 LEFT OUTER JOIN t_Department t4 ON     v1.FDeptID = t4.FItemID   AND t4.FItemID <>0 
 where 1=1 AND (     
ISNULL(t4.FName,'') = 'ÅäÁÏ°à'
)  AND (v1.FTranType=24 AND ((v1.FCheckerID>0)  AND (convert(datetime,convert(varchar(30),v1.FDate,120)) >='2011-07-25'  AND  convert(datetime,convert(varchar(30),v1.FDate,120)) < '2011-08-01') AND v1.FROB=1 AND  v1.FCancellation = 0))