----select * from t_tabledescription where Ftablename like '%Item%'
----
----select * from t_ICItem
----select * from ICBOM
----
----select * from t_fielddescription where fdescription like '%毛重%'
----
----select t2.FName,t2.FGrossWeight,t1.FQty
----from icbomchild t1 
----left join t_icitem t2 on t1.Fitemid=t2.fitemid
----where FGrossWeight>0
----
----select * from t_ICItem
--
--select t1.FBOMNumber as [BOM编号],
--	t2.FQty as [BOM单重],
--	t3.FName as [产品名称],
--	t3.FGrossWeight as [基础资料单重],
--	t2.FQty-t3.FGrossWeight as [差别]
--from ICBOM t1 
--left join ICBOMCHILD t2 ON t1.FInterID=t2.FInterID
--left join t_ICItem t3 ON  t1.FItemID=t3.FItemID
--where t2.FQty-t3.FGrossWeight<>0
--
--select * from ICBOM t1 left join ICBOMCHILD t2 ON t1.FInterID=t2.FInterID
--where t1.FStatus=1
--
--select t3.FGrossWeight,t2.FName,t1.FBOMNumber--,t4.FQty
--from ICBOM t1
--left join t_ICItemCore t2 on t1.FItemID=t2.FItemID
--left join t_ICItemDesign t3 on t1.FItemID=t3.FItemID
----left join ICBOMCHILD t4 ON t1.FInterID=t4.FInterID
--where t1.FStatus=1

select distinct t1.FInterID,t1.FItemID,t1.FBOMNumber,t2.FQty,t3.FGrossWeight,t4.FName,t7.FName
--update t3 set t3.FGrossWeight=t2.FQty
from ICBOM t1
left join ICBOMCHILD t2 ON t1.FInterID=t2.FInterID
left join t_ICItemDesign t3 on t1.FItemID=t3.FItemID
left join t_ICItemCore t4 on t1.FItemID=t4.FItemID
left join t_Item t5 on t4.FParentID=t5.FItemID
left join t_Item t6 on t5.FParentID=t6.FItemID
left join t_Item t7 on t6.FParentID=t7.FItemID
where t2.FQty>0 
--	and t2.FQty<>t3.FGrossWeight 
	and t1.FUseStatus=1072
	and t7.FName='产品'
--	and t7.FName='外来件加工配件'
	and t1.FInterID NOT IN (11935)
	and t4.FName like '%DLT250-18C/B02%'

select distinct t1.FInterID,t1.FItemID,t1.FBOMNumber,t2.FQty,t3.FGrossWeight,t4.FName,t7.FName
--update t3 set t3.FGrossWeight=t2.FQty
from ICBOM t1
left join ICBOMCHILD t2 ON t1.FInterID=t2.FInterID
left join t_ICItemDesign t3 on t1.FItemID=t3.FItemID
left join t_ICItemCore t4 on t1.FItemID=t4.FItemID
left join t_Item t5 on t4.FParentID=t5.FItemID
left join t_Item t6 on t5.FParentID=t6.FItemID
left join t_Item t7 on t6.FParentID=t7.FItemID
where t2.FQty>0 
	and t2.FQty<>t3.FGrossWeight 
	and t1.FUseStatus=1072
	and t7.FName='产品'
--	and t7.FName='外来件加工配件'
	and t1.FInterID NOT IN (11935)
order by t1.FInterID



update t_ICItemDesign set FGrossWeight=20.1 from t_ICItemDesign where FItemID=19510

select * from t_ICItemCore where fname like '%PAD%'
select * from t_item where fitemid=10995
--
--select * from t_Item where FName like '%外来%'
--
--select * from ICBOM


