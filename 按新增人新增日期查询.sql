select * from t_TableDescription where FDescription like '%ŒÔ¡œ%'

select * from t_FieldDescription where FTableID=17

select * from ICPrcPlyEntry

select * from t_ICItem
select * from t_ICItemCustom


SELECT  t1.FItemID  
FROM t_Item t1  with(index (uk_Item2)) 
LEFT JOIN t_ICItem x2 ON t1.FItemID = x2.FItemID  
WHERE 
FItemClassID = 4 
AND 
F_102 Like '%∑∂∫ËŒƒ%'
--AND 
--year(F_105)='2015'
--and
--month(F_105)='03' 
AND 
t1.FDeleteD=0  
ORDER BY t1.FNumber