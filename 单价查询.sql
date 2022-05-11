select t4.FName,t1.FModel,t1.FName,t1.F_113 from t_ICItem t1
left join t_Item t2 on t1.FParentID=t2.FItemID
left join t_Item t3 on t2.FParentID=t3.FItemID
left join t_Item t4 on t3.FParentID=t4.FItemID
where t4.FName='产品'


	case n.FName
		when '自动大S机' then m.F_111
		when '小S自动机' then m.F_112
		when '麻面炉' then m.F_113
		when '手工炉' then m.F_114
		when '麻面自动机' then m.F_116
	end as FPrice,

select * from t_Item where FItemID=1243