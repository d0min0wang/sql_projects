select t1.FName,t1.FPrice,t2.FName,t2.F_115 from t_xxy_price t1
left join t_Item t2 on t1.FName=t2.FName
where t1.FName is not null and t2.FName is not null

Update t3 set t3.F_115=t1.FPrice
From t_xxy_price t1
left join t_ICItemCore t2 on t1.FName=t2.FName
left join t_ICItemCustom t3 on t2.FItemID=t3.FItemID

select FModel,FName,
F_111 AS ��S�Զ���,
F_112 AS СS�Զ���,
F_113 AS ����¯,
F_114 AS �ֹ�¯,
F_115 AS ��β����,
F_116 AS �����Զ���
from t_ICItem where F_114>0
--select * from t_ICItemCore t1 left join t_ICItemCustom t2 on t1.FItemID=t2.FItemID
--F_111 ��S�Զ���
--F_112 СS�Զ���
--F_113 ����¯
--F_114 �ֹ�¯
--F_115 ��β����
--F_116 �����Զ���

--delete from t_xxy_price where FName is null
drop table t_xxy_price

