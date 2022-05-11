--> liangCK小梁 于2008-11-01
--> 生成测试数据: #T
IF OBJECT_ID('tempdb.dbo.#T') IS NOT NULL DROP TABLE #T
CREATE TABLE #T (仓库名称 VARCHAR(9),商品编码 VARCHAR(10),商品名称 VARCHAR(20),库存 INT)
INSERT INTO #T
SELECT '上海仓库1','07-c01-000','NOKIA诺基亚2600C',122 UNION ALL
SELECT '上海仓库1','07-c01-098','SonyEricsson索爱W380',244 UNION ALL
SELECT '广州仓库1','07-c01-098','SonyEricsson索爱W380',355 UNION ALL
SELECT '成都仓库1','07-c01-026','Nokia诺基亚N72',58 UNION ALL
SELECT '广州仓库1','07-c01-026','Nokia诺基亚N72',62 UNION ALL
SELECT '成都仓库1','07-c01-098','SonyEricsson索爱W380',88 UNION ALL
SELECT '成都仓库1','07-c01-000','NOKIA诺基亚2600C',30

--SQL查询如下:

SELECT 仓库名称,商品编码,商品名称,库存
FROM
(
   SELECT 仓库名称,商品编码,商品名称,库存,s1=0,s2=商品编码
   FROM #T
   UNION ALL
   SELECT '总库存:','','',SUM(库存),s1=1,s2=商品编码
   FROM #T
   GROUP BY 商品编码
) AS T
ORDER BY s2,s1
