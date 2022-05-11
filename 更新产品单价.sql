select t1.FName,t1.FPrice,t2.FName,t2.F_115 from t_xxy_price t1
left join t_Item t2 on t1.FName=t2.FName
where t1.FName is not null and t2.FName is not null

Update t3 set t3.F_115=t1.FPrice
From t_xxy_price t1
left join t_ICItemCore t2 on t1.FName=t2.FName
left join t_ICItemCustom t3 on t2.FItemID=t3.FItemID

select FModel,FName,
F_111 AS 大S自动机,
F_112 AS 小S自动机,
F_113 AS 麻面炉,
F_114 AS 手工炉,
F_115 AS 剪尾单价,
F_116 AS 麻面自动机
from t_ICItem where F_114>0
--select * from t_ICItemCore t1 left join t_ICItemCustom t2 on t1.FItemID=t2.FItemID
--F_111 大S自动机
--F_112 小S自动机
--F_113 麻面炉
--F_114 手工炉
--F_115 剪尾单价
--F_116 麻面自动机

--delete from t_xxy_price where FName is null
drop table t_xxy_price

