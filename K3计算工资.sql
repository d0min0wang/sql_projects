select t2.FName,t3.FName,t4.FName,* from t_ICItem t1
left join t_Item t2 on t1.FParentID=t2.FItemID
left join t_Item t3 on t2.FParentID=t3.FItemID
left join t_Item t4 on t3.FParentID=t4.FItemID
left join chengxinggongzi t5 on t1.FModel=t5.FProName
where t4.FName='��Ʒ' and t5.FTeamID='�Զ���S��'

sp_help jianweigongzi
select * from t_ICItemCore t1
left join t_ICItemCustom t2 on t1.FItemID=t2.FItemID
left join t_Item t3 on t1.FParentID=t3.FItemID
left join t_Item t4 on t3.FParentID=t4.FItemID
left join t_Item t5 on t4.FParentID=t5.FItemID
left join chengxinggongzi t6 on t1.FModel=t6.FProName
where t5.FName='��Ʒ' and t6.FTeamID='��β'


select * from t_ICItemCore t1
left join t_ICItemCustom t2 on t1.FItemID=t2.FItemID
left join t_Item t3 on t1.FParentID=t3.FItemID
left join t_Item t4 on t3.FParentID=t4.FItemID
left join t_Item t5 on t4.FParentID=t5.FItemID
left join jianweigongzi t6 on t1.FModel=t6.FProName
where t5.FName='��Ʒ' and t6.FPrice>=0


update t2 set t2.F_115=t6.Fprice
from t_ICItemCore t1
left join t_ICItemCustom t2 on t1.FItemID=t2.FItemID
left join t_Item t3 on t1.FParentID=t3.FItemID
left join t_Item t4 on t3.FParentID=t4.FItemID
left join t_Item t5 on t4.FParentID=t5.FItemID
left join jianweigongzi t6 on t1.FModel=t6.FProName
where t5.FName='��Ʒ' and t6.FPrice>=0

 SELECT  ROUND(1.56191919191,3)

update t_ICItem set F_113= 111.111111111111 where fname like '%ZN75T1.5%'
update t_ICItem set F_113= 370.37037037037 where fname like '%RG040003515%'
update t_ICItem set F_113= 1444.44444444444 where fname like '%RG040002715%'
update t_ICItem set F_113= 1100 where fname like '%YH115165T1.0%'
update t_ICItem set F_113= 1166.66666666667 where fname like '%RG040003270%'
update t_ICItem set F_113= 55.5555555555556 where fname like '%RGSK-210P%'
update t_ICItem set F_113= 411.764705882353 where fname like '%RG040002957%'
update t_ICItem set F_113= 1166.66666666667 where fname like '%RG040003262%'
update t_ICItem set F_113= 411.764705882353 where fname like '%RG040003369%'
update t_ICItem set F_113= 153.80221035748 where fname like '%ECT47-60(1.5)%'



--select * from t_ICItem where fname like '%SKT9.0%'
--select * from t_ICItem where fname like '%ST��37.5-370%'
--select * from t_ICItem where fname like '%ST��24.5-155%'
--select * from t_Item where fname like '%ST��24-130%'




where F_111>0
--F_111 �Զ���S��
--F_112 СS�Զ���
--F_113 ����¯
--F_114 �ֹ�¯
--F_115 ��β

drop table jianweigongzi where FTeamID='�Զ���S��'