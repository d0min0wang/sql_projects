select * from t_tabledescription where fdescription like '%��������%'

select * from t_WorkCenter

select t1.FInterID,t1.FItemID,t2.FOperID,t3.FName from t_Routing t1
left join t_RoutingOper t2 ON t1.FInterID=t2.FInterID
left join t_SubMessage t3 ON t2.FOperID=t3.FInterID
--t_Routing
--t_RoutingGroup
--t_RoutingOper
--t_WorkCenter

--��β 40027
SELECT CONVERT(varchar(10),i.FEndWorkDate,120),
ISNULL(i.FAuxQtyPass,0) as FQty,
ISNULL(i.FAuxWhtScrap,0)+ISNULL(i.FAuxWhtForItem,0) as FScrap
FROM SHProcRpt i 
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID
LEFT JOIN ICShop_FlowCard m ON i.FFlowCardInterID=m.FID
LEFT JOIN ICShop_FlowCardEntry n ON m.FID=n.FID
--LEFT JOIN t_Routing t1 ON i.FItemID=t1.FItemID
--left join t_RoutingOper t2 ON t1.FInterID=t2.FInterID
WHERE year(i.FEndWorkDate)='2011'
and month(i.FEndWorkDate)='03'
and day(i.FEndWorkDate)='21'
and l.FName='����'
--and t2.FOperID=40027
and n.FOperID=40027

select top 100 FInterID,FFlowCardInterID from SHProcRpt
select top 100 FID from ICShop_FlowCardEntry

SELECT top 100 i.FFlowCardNO AS ���β��ת����,
	i.FICMOBillNO AS �������񵥺�,
	j.FName AS ��Ʒ����,
	i.FOperID AS �����,
	l.FName AS ����
FROM ICShop_FlowCardEntry i
LEFT JOIN t_ICItem j ON i.FItemID=j.FItemID
LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID
where i.FOperID=40027

select * from t_tabledescription where fdescription like '%��ת��%'

select * from t_fielddescription where ftableid=1450015
