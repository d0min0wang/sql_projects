select t4.FName,t1.FModel,t1.FName,t1.F_113 from t_ICItem t1
left join t_Item t2 on t1.FParentID=t2.FItemID
left join t_Item t3 on t2.FParentID=t3.FItemID
left join t_Item t4 on t3.FParentID=t4.FItemID
where t4.FName='��Ʒ'


	case n.FName
		when '�Զ���S��' then m.F_111
		when 'СS�Զ���' then m.F_112
		when '����¯' then m.F_113
		when '�ֹ�¯' then m.F_114
		when '�����Զ���' then m.F_116
	end as FPrice,

select * from t_Item where FItemID=1243