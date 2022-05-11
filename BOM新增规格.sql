--select * from t_tabledescription where fdescription like '%BOM%'
--select * from ICBomChild
--
--select * from t_fielddescription where ftableid=250000

SELECT DISTINCT t1.fbomnumber,t4.Fmodel,t4.FHelpcode --,t1.*
FROM IcBom t1 
INNER JOIN ICBomChild t2 ON t1.FInterID = t2.FInterID 
--INNER JOIN #IcBomGroup t3 ON t1.FParentID = t3.FinterID 
INNER JOIN t_IcItem t4 ON t1.FItemID = t4.FItemID 
--LEFT JOIN t_User t5 ON t1.FCheckerID = t5.FUserID 
--LEFT JOIN t_User t6 ON t1.FCheckID = t6.FUserID 

WHERE 1 = 1  --AND ((t1.FAudDate BETWEEN '2011-10-01' AND '2011-10-31') OR t1.FAudDate IS NULL) 
-- AND ((t1.FCheckDate BETWEEN '2011-10-01' AND '2011-10-31') OR t1.FCheckDate IS NULL) 
AND ((t1.FEnterTime BETWEEN '2011-10-01' AND '2011-10-31') OR t1.FEnterTime IS NULL) 