SELECT 
	t1.FInterID,
	t1.FFlowCardNO,-- ��ת����,
	t3.FName,-- ����,
	t1.FTeamID, --
	t4.FName,-- ����,
	t1.FTeamTimeID,
	t8.FName,--���
	t6.FName,--�豸
	t5.FName,-- Ա����,
	t7.FModel,--��Ʒ
	t7.FHelpCode,--������
	t1.FStartWorkDate,--ʵ�ʿ�������
	t1.FAuxWhtSingle,--����
	t1.FAuxQtyPass,t1.FAuxWhtPass,
	t1.FAuxQtyFinish,t1.FAuxWhtFinish,
	t1.FAuxQtyForItem,t1.FAuxWhtForItem,
	t1.FAuxQtyScrap,t1.FAuxWhtScrap
FROM SHProcRpt t1
LEFT JOIN t_ICItem t2 ON t1.FItemID=t2.FItemID
LEFT JOIN t_SubMessage t3 ON t1.FOperID=t3.FInterID 
LEFT JOIN t_SubMessage t4 ON t1.FTeamID=t4.FInterID
LEFT JOIN t_Emp t5 ON t1.FWorkerID=t5.FItemID
LEFT JOIN vw_Device_Resource t6 ON t1.FDeviceID=t6.FID
LEFT JOIN t_ICItem t7 ON t1.FItemID=t7.FItemID
LEFT  JOIN v_ICSHOP_TeamTime t8 ON t1.FTeamTimeID=t8.FID
WHERE 
t3.FName='����'
and CONVERT(VARCHAR(10),t1.FStartWorkDate,120)='2011-12-17'
and t8.FName like '%��%'
and t4.FName like '%�Զ�%'

--����� 4
--��� 6
select t3.FName,t1.FStartWorkDate,t1.FTeamTimeID,t8.FName,t4.FName,t1.FDeviceID,t6.FName
--update t1 set t1.FDeviceID=1020
from SHProcRpt t1
LEFT JOIN t_SubMessage t3 ON t1.FOperID=t3.FInterID 
LEFT JOIN t_SubMessage t4 ON t1.FTeamID=t4.FInterID
LEFT JOIN vw_Device_Resource t6 ON t1.FDeviceID=t6.FID
LEFT  JOIN v_ICSHOP_TeamTime t8 ON t1.FTeamTimeID=t8.FID
WHERE 
t3.FName='����'
and t1.FFlowCardNO IN ('201112150011001','201112150011002',
	'201112150011003','201112150011004',
	'201112150011005','201112150011006')
--and CONVERT(VARCHAR(10),t1.FStartWorkDate,120)='2011-12-17'
--and t1.FTeamTimeID=2
--and t4.FName like '%�Զ�%'

select * from vw_Device_Resource
--D7 1069
--D5 1020