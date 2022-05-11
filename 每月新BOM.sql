select ICBOM.FBOMNumber,ICBOM.FEnterTime,t_ICItem.FNumber,t_ICItem.FModel,t_ICItem.FHelpCode
from ICBOM
left join t_ICItem on ICBOM.FItemID=t_ICItem.FItemID
 where ICBOM.FEnterTime>='2011-12-01'

select fcostacctid,* from t_icitem

select * from t_submessage where finterid=1183