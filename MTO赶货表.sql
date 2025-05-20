Select
  convert(date,v1.Fdate,121) FDate
  ,o1.FName FClientName
  ,t11.FName FDepartment
  ,t17.FName FProductName
  ,sum(u1.Fauxqty) as FQty,avg(isnull(tt1.FOwnQty,0)) FInventoryQty,avg(isnull(tt2.FMakingQty,0)) FMaking,ISNULL(u1.FEntrySelfS0237,'') FFigureNum--图号
  ,max(u1.FNote) FNote
  --sum(u1.Fauxqty)
  ,isnull(max(o1.F_106),'') FPacking
from
  SEOutStock v1 
  INNER JOIN SEOutStockEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 
  LEFT OUTER JOIN t_Department t11 ON v1.FDeptID = t11.FItemID AND t11.FItemID <>0 
  left join t_Organization o1 on v1.FCustID=o1.FItemID
  INNER JOIN t_ICItem t17 ON u1.FItemID = t17.FItemID   AND t17.FItemID <>0 
  left join (
    --select FItemID,sum(FQty) FOwnQty from ICInventory where FStockID=14403 AND t2.FPlanMode<>14035 group by FItemID
    select t1.FItemID,sum(t1.FQty) FOwnQty 
    from ICInventory t1
    left joIN t_ICItemPlan t2 on t1.fitemid=t2.fitemid
    where t1.FStockID=14403 
    AND t2.FPlanMode<>14035 
    group by t1.FItemID
  ) tt1 on u1.FItemID=tt1.FItemID
  left join (
	select
		t1.FItemID			AS FItemID
		,sum(isnull(t2.FAuxQtyPass,0))AS FMakingQty
	from
		t_ICItem t1
		left join SHProcRpt		t2	on t1.FItemID=t2.FItemID
		left join SHProcRptMain	t3	on t2.FinterID=t3.FInterID
	where
		t2.FOperID >= 40026 
		and t3.FCheckStatus= 1059
	group by t1.FItemID,t1.fName
  ) tt2 on u1.FItemID=tt2.FItemID
  --left join(
  --select
  --  s2.FItemID,sum()
  --from
  --  SEOrder s1 inner join SEOrderEntry s2 on s1.FInterID=s2.FInterID
  --) tt1 
where
  v1.Fdate>=dateadd(day,-2,getdate()) and v1.Fdate<=dateadd(day,30,getdate())
  AND (v1.FTranType=83 AND v1.FStatus<3)
group by
  convert(date,v1.Fdate,121),o1.FName,t11.FName,t17.FName,ISNULL(u1.FEntrySelfS0237,'')

--MTO物料
Select
  convert(date,v1.Fdate,121) FDate
  ,o1.FName FClientName
  ,t11.FName FDepartment
  ,t17.FName FProductName
  ,sum(u1.Fauxqty) as FQty,avg(isnull(tt1.FOwnQty,0)) FInventoryQty,avg(isnull(tt2.FMakingQty,0)) FMaking,ISNULL(u1.FEntrySelfS0237,'') FFigureNum--图号
  ,max(u1.FNote) FNote
  --sum(u1.Fauxqty)
  ,isnull(max(o1.F_106),'') FPacking
from
  SEOutStock v1 
  INNER JOIN SEOutStockEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 
  LEFT OUTER JOIN t_Department t11 ON v1.FDeptID = t11.FItemID AND t11.FItemID <>0 
  left join t_Organization o1 on v1.FCustID=o1.FItemID
  INNER JOIN t_ICItem t17 ON u1.FItemID = t17.FItemID   AND t17.FItemID <>0 
  left joIN t_ICItemPlan t4 on u1.fitemid=t4.fitemid
	
  left join (
    --select FItemID,sum(FQty) FOwnQty from ICInventory where FStockID=14403 AND t2.FPlanMode<>14035 group by FItemID
    select t1.FItemID,left(t1.FMTONo,CHARINDEX('-',t1.FMTONo)-1) as FCust,sum(t1.FQty) AS FOwnQty from ICInventory t1
  left joIN t_ICItemPlan t2 on t1.fitemid=t2.fitemid
  where t2.FPlanMode=14035
  AND CHARINDEX('-',t1.FMTONo)>1
  and t1.FStockID=14403
  GROUP BY t1.FItemID,left(t1.FMTONo,CHARINDEX('-',t1.FMTONo)-1)
  ) tt1 on u1.FItemID=tt1.FItemID AND o1.FName=tt1.FCust
  left join (
	select
		t1.FItemID			AS FItemID
		,sum(isnull(t2.FAuxQtyPass,0))AS FMakingQty
	from
		t_ICItem t1
		left join SHProcRpt		t2	on t1.FItemID=t2.FItemID
		left join SHProcRptMain	t3	on t2.FinterID=t3.FInterID
    left joIN t_ICItemPlan t4 on t1.fitemid=t4.fitemid
	where
    t4.FPlanMode=14035
		and t2.FOperID >= 40026 
		and t3.FCheckStatus= 1059
	group by t1.FItemID,t1.fName
  ) tt2 on u1.FItemID=tt2.FItemID
  --left join(
  --select
  --  s2.FItemID,sum()
  --from
  --  SEOrder s1 inner join SEOrderEntry s2 on s1.FInterID=s2.FInterID
  --) tt1 
where
  v1.Fdate>=dateadd(day,-2,getdate()) and v1.Fdate<=dateadd(day,30,getdate())
  AND (v1.FTranType=83 AND v1.FStatus<3)
  AND t4.FPlanMode=14035
group by
  convert(date,v1.Fdate,121),o1.FName,t11.FName,t17.FName,ISNULL(u1.FEntrySelfS0237,'')






  select t1.FItemID,'',sum(t1.FQty) FOwnQty 
  from ICInventory t1
  left joIN t_ICItemPlan t2 on t1.fitemid=t2.fitemid
  where t1.FStockID=14403 
  AND t2.FPlanMode<>14035 
  group by t1.FItemID
UNION ALL
  select t1.FItemID,left(t1.FMTONo,CHARINDEX('-',t1.FMTONo)-1) as FCust,sum(t1.FQty) AS FQty from ICInventory t1
  left joIN t_ICItemPlan t2 on t1.fitemid=t2.fitemid
  where t2.FPlanMode=14035
  AND CHARINDEX('-',t1.FMTONo)>1
  and t1.FStockID=14403
  GROUP BY t1.FItemID,left(t1.FMTONo,CHARINDEX('-',t1.FMTONo)-1)


--========================================
--新MTO计算模式
--========================================
Select
  convert(date,v1.Fdate,121) FDate
  ,o1.FName FClientName
  ,t11.FName FDepartment
  ,t17.FName FProductName
  ,sum(u1.Fauxqty) as FQty,avg(isnull(tt1.FOwnQty,0)) FInventoryQty,avg(isnull(tt2.FMakingQty,0)) FMaking,ISNULL(u1.FEntrySelfS0237,'') FFigureNum--图号
  ,max(u1.FNote) FNote
  --sum(u1.Fauxqty)
  ,isnull(max(o1.F_106),'') FPacking
from
  SEOutStock v1 
  INNER JOIN SEOutStockEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 
  LEFT OUTER JOIN t_Department t11 ON v1.FDeptID = t11.FItemID AND t11.FItemID <>0 
  left join t_Organization o1 on v1.FCustID=o1.FItemID
  INNER JOIN t_ICItem t17 ON u1.FItemID = t17.FItemID   AND t17.FItemID <>0 
  left join (
    --select FItemID,sum(FQty) FOwnQty from ICInventory where FStockID=14403 AND t2.FPlanMode<>14035 group by FItemID
    select t1.FItemID,sum(t1.FQty) FOwnQty 
    from ICInventory t1
    --left joIN t_ICItemPlan t2 on t1.fitemid=t2.fitemid
    where t1.FStockID=14403 
    --AND t2.FPlanMode<>14035 
    AND CHARINDEX('-',t1.FMTONo)<1
    group by t1.FItemID
  ) tt1 on u1.FItemID=tt1.FItemID
  left join (
	select
		t1.FItemID			AS FItemID
		,sum(isnull(t2.FAuxQtyPass,0))AS FMakingQty
	from
		t_ICItem t1
		left join SHProcRpt		t2	on t1.FItemID=t2.FItemID
		left join SHProcRptMain	t3	on t2.FinterID=t3.FInterID
	where
		t2.FOperID >= 40026 
		and t3.FCheckStatus= 1059
        AND CHARINDEX('-',t3.FMTONo)<1
	group by t1.FItemID,t1.fName
  ) tt2 on u1.FItemID=tt2.FItemID
  --left join(
  --select
  --  s2.FItemID,sum()
  --from
  --  SEOrder s1 inner join SEOrderEntry s2 on s1.FInterID=s2.FInterID
  --) tt1 
where
  v1.Fdate>=dateadd(day,-2,getdate()) and v1.Fdate<=dateadd(day,30,getdate())
  AND (v1.FTranType=83 AND v1.FStatus<3)
  AND CHARINDEX('-',u1.FMTONo)<1
group by
  convert(date,v1.Fdate,121),o1.FName,t11.FName,t17.FName,ISNULL(u1.FEntrySelfS0237,'')



Select
  convert(date,v1.Fdate,121) FDate
  ,o1.FName FClientName
  ,t11.FName FDepartment
  ,t17.FName FProductName
  ,sum(u1.Fauxqty) as FQty,avg(isnull(tt1.FOwnQty,0)) FInventoryQty,avg(isnull(tt2.FMakingQty,0)) FMaking,ISNULL(u1.FEntrySelfS0237,'') FFigureNum--图号
  ,max(u1.FNote) FNote
  --sum(u1.Fauxqty)
  ,isnull(max(o1.F_106),'') FPacking
from
  SEOutStock v1 
  INNER JOIN SEOutStockEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 
  LEFT OUTER JOIN t_Department t11 ON v1.FDeptID = t11.FItemID AND t11.FItemID <>0 
  left join t_Organization o1 on v1.FCustID=o1.FItemID
  INNER JOIN t_ICItem t17 ON u1.FItemID = t17.FItemID   AND t17.FItemID <>0 
  left joIN t_ICItemPlan t4 on u1.fitemid=t4.fitemid
	
  left join (
    --select FItemID,sum(FQty) FOwnQty from ICInventory where FStockID=14403 AND t2.FPlanMode<>14035 group by FItemID
    select t1.FItemID,left(t1.FMTONo,len(t1.FMTONo)-CHARINDEX('-',reverse(t1.FMTONo))) as FCust,sum(t1.FQty) AS FOwnQty from ICInventory t1
  left joIN t_ICItemPlan t2 on t1.fitemid=t2.fitemid
  where t2.FPlanMode=14035
  AND CHARINDEX('-',t1.FMTONo)>1
  and t1.FStockID in (14403,55582)
  GROUP BY t1.FItemID,left(t1.FMTONo,len(t1.FMTONo)-CHARINDEX('-',reverse(t1.FMTONo)))
  ) tt1 on u1.FItemID=tt1.FItemID AND o1.FName=tt1.FCust
  left join (
	select
		t1.FItemID			AS FItemID
		,sum(isnull(t2.FAuxQtyPass,0))AS FMakingQty
	from
		t_ICItem t1
		left join SHProcRpt		t2	on t1.FItemID=t2.FItemID
		left join SHProcRptMain	t3	on t2.FinterID=t3.FInterID
    left joIN t_ICItemPlan t4 on t1.fitemid=t4.fitemid
	where
    t4.FPlanMode=14035
    and CHARINDEX('-',t3.FMTONo)>1
		and t2.FOperID >= 40026 
		and t3.FCheckStatus= 1059
	group by t1.FItemID,t1.fName
  ) tt2 on u1.FItemID=tt2.FItemID
  --left join(
  --select
  --  s2.FItemID,sum()
  --from
  --  SEOrder s1 inner join SEOrderEntry s2 on s1.FInterID=s2.FInterID
  --) tt1 
where
  v1.Fdate>=dateadd(day,-2,getdate()) and v1.Fdate<=dateadd(day,30,getdate())
  AND (v1.FTranType=83 AND v1.FStatus<3)
  AND t4.FPlanMode=14035
  and CHARINDEX('-',u1.FMTONo)>1
  --AND o1.fname LIKE '%中航光电%'
group by
  convert(date,v1.Fdate,121),o1.FName,t11.FName,t17.FName,ISNULL(u1.FEntrySelfS0237,'')






select t3.fname,t1.FStockID,left(t1.FMTONo,len(t1.FMTONo)-CHARINDEX('-',reverse(t1.FMTONo))) as FCust,t1.FQty AS FOwnQty from ICInventory t1
  left joIN t_ICItemPlan t2 on t1.fitemid=t2.fitemid
  LEFT JOIN t_ICItem t3 ON t1.fitemid=t3.fitemid
  where t2.FPlanMode=14035
  AND CHARINDEX('-',t1.FMTONo)>1
  --and t1.FStockID=14403
  and left(t1.FMTONo,len(t1.FMTONo)-CHARINDEX('-',reverse(t1.FMTONo))) LIKE '%中航光电%'
  AND t3.Fname LIKE '%ECB107%'
  GROUP BY t3.fname,left(t1.FMTONo,len(t1.FMTONo)-CHARINDEX('-',reverse(t1.FMTONo))-1)


  select t3.fname,left(u1.FMTONo,CHARINDEX('-',u1.FMTONo)-1)
  from
  SEOutStock v1 
  INNER JOIN SEOutStockEntry u1 ON v1.FInterID = u1.FInterID AND u1.FInterID <>0 
  LEFT OUTER JOIN t_Department t11 ON v1.FDeptID = t11.FItemID AND t11.FItemID <>0 
  left join t_Organization o1 on v1.FCustID=o1.FItemID
  LEFT JOIN t_ICItem t3 ON u1.fitemid=t3.fitemid
  where CHARINDEX('-',u1.FMTONo)>1
  and left(u1.FMTONo,CHARINDEX('-',u1.FMTONo)-1) LIKE '%中航光电%'
  AND t3.Fname LIKE '%ECT7.3%'