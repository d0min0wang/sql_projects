select * from APP_SAP_IMMS 

update t1 set t1.IM_DESCRIPTION=t2.IM_DESCRIPTION
from  APP_SAP_IMMS t1
left join APP_PED_IMMS t2 on t1.PED_SEQ=t2.PED_SEQ and t1.IM_NAME=t2.IM_NAME
where t1.PED_SEQ=11 and t2.IM_NAME='·ÏÆ·ÂÊ 0.6%'

select * from APP_PED_IMMS where PED_SEQ=11