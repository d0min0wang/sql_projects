Select t1.FSupplyID,
	t3.FName AS "�ͻ�",
	t4.FName AS "����",
	t5.FName AS "����",
	t6.FName AS "ҵ��Ա",
	t9.FName AS "��ҵ", 
	t3.F_118 AS "��ҵ�ṹ",
	t8.FName AS "�ؿʽ",	
	t1.FDate AS "��������", 
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
