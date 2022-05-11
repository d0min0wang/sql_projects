SELECT top 1000 * FROM t_DF20ProductInfoLogger ORDER BY fTimestamp


;WITH CTE_Row
AS
(
    select *,ROW_NUMBER() over (order by fid) xid FROM t_DF20ProductInfoLogger
)
SELECT 
    CONVERT(VARCHAR(10),t1.fTimestamp,120) AS FDate,
    t1.fTimestamp,
    t3.fItemName,
    t1.fWeight,
    t1.fOvenMaterialTemperature,
    t1.fOvenMoldTemperature_1,
    t1.fOvenMoldTemperature_2,
    (t2.fWeight-t1.fWeight),
    t3.fDiePerBoard,
    (t2.fWeight-t1.fWeight)*1000/t3.fDiePerBoard,
    t1.fWeight,t2.fWeight 
FROM CTE_Row t1 INNER JOIN CTE_Row t2 ON t1.xid=t2.xid+1
LEFT JOIN t_DiePerBoard t3 ON t1.fProductID=t3.fItemID



WHERE (t2.fWeight-t1.fWeight)<-0.1