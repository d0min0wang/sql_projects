select 
	t2.FName as 收样公司,
--	t3.FName as 客户所属行业,
--	t2.F_118 as 方普行业结构,
--	t2.F_112 as 配套产品,
	t1.FText3 as 样品名称, 
	t1.Ftext1 as 样品料号,
--	t1.FDecimal2 as 剪尾前单重, 
--	t1.FDecimal3 as 剪尾后单重,
--	t1.Fdate3 as 样品完成日期,
--	t1.Fdate5 as 寄样日期,
	t1.FDate as 填写日期,
--	t1.FDecimal4 as 寄样数量,
	t4.FName as 寄样人,
	t5.FName as 负责部门
--	t1.FReqNote as 其他要求
from CRM_samplereq t1 
left join t_organization t2 ON t1.FCustomerID=t2.FItemID
left join t_Emp t4 on t1.FReqestID=t4.FItemID
left join t_Department t5 on t2.FDepartment=t5.Fitemid


Select u1.FItemID,v1.FSupplyID,sum(CASE WHEN u1.FAuxQty>0 THEN u1.FAuxQty END) 
From ICStockBill v1 inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID
Where v1.FTranType=2 And v1.FCheckerID>0 
and
Group by v1.FSupplyID,u1.FItemID'