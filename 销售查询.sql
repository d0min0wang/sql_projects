Select t1.FSupplyID,
	t3.FName AS "客户",
	t4.FName AS "部门",
	t5.FName AS "区域",
	t6.FName AS "业务员",
	t9.FName AS "行业", 
	t3.F_118 AS "行业结构",
	t8.FName AS "回款方式",	
	t1.FDate AS "交易日期", 
	t2.FConsignAmount
From ICStockBill t1 
inner join ICStockBillEntry t2 on t2.FInterID=t1.FInterID
left join t_Organization t3 on t1.FSupplyID=t3.FItemID 
left join t_Department t4 on t4.FItemID=t3.FDepartment 
left join t_SubMessage t5 on t5.FInterID=t3.FRegionID 
left join t_Emp t6 on t6.FItemID=t3.Femployee 
left join t_settle t8 on t8.FItemID=t3.FSetID
left join t_Item t9 on t3.F_117=t9.FItemID
Where t1.FTranType=21 And Year(t1.FDate)='2011'


--select * from t_Organization
--
--select * from t_Item order by fitemid
