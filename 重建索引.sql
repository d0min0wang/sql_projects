SELECT OBJECT_NAME(dt.object_id)    as [TableName]   ,	--資料表名稱
       si.name                      as [IndexName]   ,	--索引名稱
       dt.avg_fragmentation_in_percent,					--邏輯片段的百分比 (索引中失序的頁面)。
       dt.avg_page_space_used_in_percent				
FROM
       (SELECT object_id                   ,
               index_id                    ,
               avg_fragmentation_in_percent,
               avg_page_space_used_in_percent
       FROM    sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'DETAILED')
       WHERE   index_id <> 0
       ) AS dt --does not return information about heaps
       INNER JOIN sys.indexes si
       ON     si.object_id = dt.object_id
          AND si.index_id  = dt.index_id
WHERE OBJECT_NAME(dt.object_id) LIKE '%_CT'


-- =============================================
-- Author:		Steven玄
-- ALTER date:  20210120
-- Description:	依照破碎程度分類重組或重建並產生修復執行字串   
-- =============================================
SELECT 'ALTER INDEX [' + ix.name + '] ON [' + s.name + '].[' + t.name + '] ' +
       CASE
              WHEN ps.avg_fragmentation_in_percent > 15			--破碎程度 判斷使用重組() 還是使用 重建()
              THEN 'REBUILD'									--重建
              ELSE 'REORGANIZE'									--重組
       END +
       CASE
              WHEN pc.partition_count > 1
              THEN ' PARTITION = ' + CAST(ps.partition_number AS nvarchar(MAX))
              ELSE ''
       END as [修復語法],
       avg_fragmentation_in_percent,
	   CASE
              WHEN ps.avg_fragmentation_in_percent > 15			--破碎程度 判斷使用重組() 還是使用 重建()
              THEN 'REBUILD'
              ELSE 'REORGANIZE'
       END as [判斷重組或重建]
FROM   sys.indexes AS ix
       INNER JOIN sys.tables t
       ON     t.object_id = ix.object_id
       INNER JOIN sys.schemas s
       ON     t.schema_id = s.schema_id
       INNER JOIN
              (SELECT object_id                   ,
                      index_id                    ,
                      avg_fragmentation_in_percent,
                      partition_number
              FROM    sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL)
              ) ps
       ON     t.object_id = ps.object_id
          AND ix.index_id = ps.index_id
       INNER JOIN
              (SELECT  object_id,
                       index_id ,
                       COUNT(DISTINCT partition_number) AS partition_count
              FROM     sys.partitions
              GROUP BY object_id,
                       index_id
              ) pc
       ON     t.object_id              = pc.object_id
          AND ix.index_id              = pc.index_id
WHERE  ps.avg_fragmentation_in_percent > 10						--需要進行重組或重建的破碎程度 條件
   AND ix.name IS NOT NULL


