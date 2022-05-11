SELECT * 
UPDATE t1
SET t1.F_138=t2.Ftel,t1.F_139=t2.Femail,t1.F_140=0,t1.F_141=0,t1.F_142=0,t1.F_145=1,t1.F_146=1,t1.F_147=1
FROM t_Organization t1
right JOIN  t_XYForImport2019 t2 ON t1.FItemID=t2.FItemID
WHERE t1.FItemID is not NULL

SELECT * INTO t_organization20200117 FROM t_Organization

SELECT t2.FName,t1.F_140,t1.F_141,t1.F_142,t1.F_145,t1.F_146,t1.F_147 
--自动发送位置1
UPDATE t1
SET t1.F_140=1,t1.F_141=1,t1.F_142=1,t1.F_145=1,t1.F_146=1,t1.F_147=1
FROM t_Organization t1 
LEFT JOIN t_Department t2 ON t1.Fdepartment=t2.FItemID
WHERE t2.FName like '%防尘帽%'