SELECT * FROM sys.tables WHERE is_tracked_by_cdc = 1

if exists(select 1 from sys.databases where name='peiliao' and is_cdc_enabled=0)
begin
    exec sys.sp_cdc_enable_db
end

exec sys.sp_cdc_disable_db

SELECT * FROM sys.filegroups WHERE database_id = DB_ID('AIS20140921170539'); --cdc

SELECT name, physical_name FROM sys.master_files WHERE database_id = DB_ID('AIS20140921170539');

SELECT name, physical_name FROM sys.master_files WHERE database_id = DB_ID('AIS20150402160359');
ALTER DATABASE AIS20150402160359 ADD FILEGROUP CDC;

ALTER DATABASE AIS20150402160359
ADD FILE
(
NAME= 'SCM102SP2_CDC',
FILENAME = 'D:\DATABASES\AIS20150402160359_cdc.ldf'
)
TO FILEGROUP CDC;

select is_cdc_enabled from sys.databases where name='AIS20150402160359';

alter table actual_data add  constraint pk_actual_data primary key(ID)

select * from t_itemclass

SELECT * FROM sys.tables WHERE is_tracked_by_cdc = 1 ORDER BY name


--表开CDC
DECLARE @TablaName NVARCHAR(100)

SET @TablaName='ICMO'

IF EXISTS(SELECT 1 FROM sys.tables WHERE name=@TablaName AND is_tracked_by_cdc = 0)
BEGIN
    EXEC sys.sp_cdc_enable_table
        @source_schema = 'dbo', -- source_schema
        @source_name = @TablaName, -- table_name
        @capture_instance = N'dbo_ICMO', -- capture_instance
        @supports_net_changes = 1, -- supports_net_changes
        @role_name = NULL, -- role_name
        @index_name = NULL, -- index_name
        @captured_column_list = NULL, -- captured_column_list
        @filegroup_name = 'CDC' -- filegroup_name
END


EXECUTE sys.sp_cdc_disable_table   
    @source_schema = N'dbo',   
    @source_name = N'ICMO',  
    @capture_instance = N'dbo_ICMO'

select * FROM cdc.dbo_actual_data_CT
SELECT * FROM actual_data WHERE fendtime>='2024-04-14' order by fendtime DESC


--查询表是否有主键
SELECT TABLE_NAME,COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE   
WHERE TABLE_NAME='actual_data' 

SELECT * FROM actual_data ORDER by fStartTime DESC

SELECT * FROM ICMO WHERE FInterID=267398

UPDATE ICMO SET FQty=800 WHERE FInterID=267398

SELECT COUNT(*) FROM icmo cdc.dbo_icmo_ct WHERE finterid=267293

DBCC SQLPERF(LOGSPACE)  
GO  
SELECT name,recovery_model_desc,log_reuse_wait,log_reuse_wait_desc  
FROM sys.databases  
GO 

--显示原有配置：
 
EXEC sp_cdc_help_jobs
GO
 
--更改数据保留时间为分钟
 
EXECUTE sys.sp_cdc_change_job
    @job_type = N'cleanup',
    @retention=2880
GO
 
--停用作业
 
EXEC sys.sp_cdc_stop_job N'cleanup'
GO
 
--启用作业
 
EXEC sys.sp_cdc_start_job N'cleanup'
GO
 
--再次查看
EXEC sp_cdc_help_jobs
GO
 
--停用作业
 
EXEC sys.sp_cdc_stop_job N'cleanup'
 
GO
 
--启用作业
 
EXEC sys.sp_cdc_start_job N'cleanup'
 
GO
 
EXEC sys.sp_cdc_drop_job@job_type = N'cleanup' -- nvarchar(20)
 
GO
 
--查看作业
 
EXEC sys.sp_cdc_help_jobs
 
GO

--exec sys.sp_MScdc_capture_job;

EXEC sys.sp_cdc_change_job
  @job_type = 'capture'
  ,@maxtrans = 500      --每个扫描循环可以处理的最多事务数
  ,@maxscans = 10        --为了从日志中提取所有行而要执行的最大扫描循环次数
  ,@continuous = 1       --连续运行最多处理(max_trans * max_scans) 个事务
  ,@pollinginterval = 5


EXECUTE sys.sp_cdc_help_change_data_capture;

/*已启用CDC的表，在新增字段的时候，是不会自动添加到变更表（CT表）的。一般情况下，需要对表停止CDC再启用CDC。而这种操作会对导致CT表重建，也就丢失了以前的变更记录。

以下脚本会把所有CDC表新增的字段添加到相应的CT表中。如有2张表分别都添加了不同的3个字段，执行以下脚本后，2张CT表都新增了对应的字段！*/


SET NOCOUNT ON;
DECLARE @Tibble				NVARCHAR(30) = '$tmp$'; /*临时CT表*/
DECLARE @ObjectID			INT;
DECLARE @MaxColumnID		INT;
DECLARE @ErrorMessage		NVARCHAR(MAX);
DECLARE @SchemaName			NVARCHAR(128);
DECLARE @ObjectName			NVARCHAR(128);
DECLARE @CaptureInstance	NVARCHAR(128);
DECLARE @TmpCaptureInstance	NVARCHAR(128);
DECLARE @ColumnName			NVARCHAR(128);
DECLARE @ColumnID			INT;
DECLARE @ColumnDataType		NVARCHAR(128);
DECLARE @ColumnTypeName		NVARCHAR(128);
DECLARE @SQL				NVARCHAR(MAX);
DECLARE @ColumnOrdinal		INT;
DECLARE @IsComputed			BIT;
DECLARE @OriginalCDCObjectID INT;
DECLARE @NewCDCObjectID		INT;
 
/* 当前DB是否有CT表 */
IF EXISTS(SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID('cdc.change_tables'))
BEGIN
	/* 游标删除临时CT表，也许是上次执行留下的 */
	DECLARE TmpCDCObjects CURSOR LOCAL FAST_FORWARD FOR
	SELECT OBJECT_SCHEMA_NAME(source_object_id),OBJECT_NAME(source_object_id),capture_instance
	FROM cdc.change_tables
	WHERE capture_instance LIKE @Tibble + '%';
 
	OPEN TmpCDCObjects;
	FETCH NEXT FROM TmpCDCObjects INTO @SchemaName, @ObjectName, @CaptureInstance;
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		/* 删除临时CT表，即禁用 CDC capture instance */
		EXEC sys.sp_cdc_disable_table @source_schema = @SchemaName, @source_name = @ObjectName, @capture_instance = @CaptureInstance;
		FETCH NEXT FROM TmpCDCObjects INTO @SchemaName, @ObjectName, @CaptureInstance;
	END
	CLOSE TmpCDCObjects; 
	
	/* 如果一张表启用 CDC capture instance 超过1个，则中断操作！*/
	IF EXISTS(SELECT source_object_id, COUNT(*) FROM cdc.change_tables GROUP BY source_object_id HAVING COUNT(*) > 1)
	BEGIN
		DEALLOCATE TmpCDCObjects;
		SELECT @ErrorMessage = 'Unable to update CDC as there are objects with more than one capture instance in use. You must update CDC manually';
		THROW 50000, @ErrorMEssage, 1;
	END;
 
	/* Loop over all the CDC tables that do not have the latest columns */
	/* 遍历所有新字段cdc表做相关处理 */
	DECLARE CDCObjects CURSOR LOCAL FAST_FORWARD FOR
		SELECT ct.object_id,ct.source_object_id,MAX(cc.column_id) AS MaxCapturedColumnID
		FROM cdc.captured_columns AS cc INNER JOIN cdc.change_tables AS ct ON cc.object_id = ct.object_id
		GROUP BY ct.source_object_id,ct.object_id
		HAVING MAX(cc.column_id) < (SELECT MAX(column_id) FROM sys.columns AS c WHERE c.object_id = ct.source_object_id);
 
	OPEN CDCObjects;
	FETCH NEXT FROM CDCObjects INTO @OriginalCDCObjectID, @ObjectID, @MaxColumnID;
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SELECT
		@SchemaName = OBJECT_SCHEMA_NAME(@ObjectID)
		,@ObjectName = OBJECT_NAME(@ObjectID)
		,@CaptureInstance = (SELECT TOP 1 capture_instance FROM cdc.change_tables WHERE source_object_id = @ObjectID ORDER BY create_date);
		SELECT @TmpCaptureInstance = @Tibble + '_' + @CaptureInstance
 
		/* 新增临时 CDC capture instance , 使用一个临时名字*/
		EXEC sys.sp_cdc_enable_table @source_schema = @SchemaName, @source_name = @ObjectName, @capture_instance = @TmpCaptureInstance, @role_name = 'cdc_Admin';
 
		/* 新增字段到原 CT 表 */
		DECLARE cColumns CURSOR LOCAL FAST_FORWARD FOR
			WITH LastColumn AS (
				/* 获取所有CT表没有的最新字段 */
				SELECT ct.source_object_id,MAX(column_id) AS MaxColumnID
				FROM cdc.captured_columns AS cc INNER JOIN cdc.change_tables AS ct ON cc.object_id = ct.object_id
				WHERE cc.object_id = @OriginalCDCObjectID
				GROUP BY ct.source_object_id
			) SELECT c.name,c.column_id ,CASE
				WHEN t.name IN ('datetime2', 'varchar', 'char', 'binary', 'varbinary', 'float') THEN t.name + '(' + CASE WHEN c.max_length = -1 THEN 'MAX' ELSE CAST(c.max_length AS NVARCHAR(20)) END + ')'
				WHEN t.name IN ('nchar', 'nvarchar') THEN t.name + '(' + CASE WHEN c.max_length = -1 THEN 'MAX' ELSE CAST(c.max_length / 2 AS NVARCHAR(20)) END + ')'
				WHEN t.name IN ('decimal', 'numeric') THEN t.name+ '(' + CAST(c.precision AS NVARCHAR(20)) + ', ' + CAST(c.scale AS NVARCHAR(20)) + ')'
				ELSE t.name END AS DataType 
			,t.name AS TypeName,c.is_computed
			FROM sys.columns AS c 
			INNER JOIN LastColumn AS lc ON c.object_id = lc.source_object_id
			INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
			WHERE c.column_id > lc.MaxColumnID;
		
		OPEN cColumns;
		FETCH NEXT FROM cColumns INTO @ColumnName, @ColumnID, @ColumnDataType, @ColumnTypeName, @IsComputed;
 
		/* 查找字段最大序号 */
		SELECT @ColumnOrdinal = MAX(column_ordinal)
		FROM cdc.captured_columns
		WHERE [object_id] = @OriginalCDCObjectID;
 
		WHILE (@@FETCH_STATUS = 0)
		BEGIN;
			SELECT @ColumnOrdinal += 1; /* Increment the column ordinal */
			--SELECT @CaptureInstance, @ColumnName, @ColumnDataType, @ColumnOrdinal
			SELECT @SQL = 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(@OriginalCDCObjectID)) + '.' + QUOTENAME(OBJECT_NAME(@OriginalCDCObjectID)) + ' ADD [' + @ColumnName + '] ' + @ColumnDataType + ' NULL';
			PRINT @SQL;
			EXEC(@SQL);
			/* 更新字段信息到元数据表 cdc.captured_colums */
			INSERT INTO cdc.captured_columns([object_id], column_name, column_id, column_type, column_ordinal, is_computed)
			VALUES(@OriginalCDCObjectID, @ColumnName, @ColumnID, @ColumnTypeName, @ColumnOrdinal, @IsComputed);
			FETCH NEXT FROM cColumns INTO @ColumnName, @ColumnID, @ColumnDataType, @ColumnTypeName, @IsComputed
		END;
 
		/* 找到刚更新的对象ID */
		SELECT @NewCDCObjectID = [object_id]
		FROM cdc.change_tables
		WHERE source_object_id = @ObjectID AND object_id != @OriginalCDCObjectID
 
		/* batch insert proc */
		SELECT @SQL = STUFF(OBJECT_DEFINITION(OBJECT_ID('cdc.sp_batchinsert_' + CAST(@NewCDCObjectID AS NVARCHAR(20)))), 1, 6, 'alter');
		SELECT @SQL = REPLACE(@SQL, CAST(@NewCDCObjectID AS NVARCHAR(20)), CAST(@OriginalCDCObjectID AS NVARCHAR(20)));
		SELECT @SQL = REPLACE(@SQL, @TmpCaptureInstance, @CaptureInstance);
		EXEC(@SQL);
		/* insdel insert proc */
		SELECT @SQL = STUFF(OBJECT_DEFINITION(OBJECT_ID('cdc.sp_insdel_' + CAST(@NewCDCObjectID AS NVARCHAR(20)))), 1, 6, 'alter');
		SELECT @SQL = REPLACE(@SQL, CAST(@NewCDCObjectID AS NVARCHAR(20)), CAST(@OriginalCDCObjectID AS NVARCHAR(20)));
		SELECT @SQL = REPLACE(@SQL, @TmpCaptureInstance, @CaptureInstance);
		EXEC(@SQL);
		/* upd insert proc */
		SELECT @SQL = STUFF(OBJECT_DEFINITION(OBJECT_ID('cdc.sp_upd_' + CAST(@NewCDCObjectID AS NVARCHAR(20)))), 1, 6, 'alter');
		SELECT @SQL = REPLACE(@SQL, CAST(@NewCDCObjectID AS NVARCHAR(20)), CAST(@OriginalCDCObjectID AS NVARCHAR(20)));
		SELECT @SQL = REPLACE(@SQL, @TmpCaptureInstance, @CaptureInstance);
		EXEC(@SQL);
		/* 下一张表对象 */
		FETCH NEXT FROM CDCObjects INTO @OriginalCDCObjectID, @ObjectID, @MaxColumnID;
	END;
	CLOSE CDCObjects;
	DEALLOCATE CDCObjects;
 
	/* 删除临时CT表 */
	OPEN TmpCDCObjects;
	FETCH NEXT FROM TmpCDCObjects INTO @SchemaName, @ObjectName, @CaptureInstance;
	WHILE (@@FETCH_STATUS = 0)
	BEGIN;
		/* 移除 CDC capture instance */
		EXEC sys.sp_cdc_disable_table @source_schema = @SchemaName, @source_name = @ObjectName, @capture_instance = @TmpCaptureInstance;
		FETCH NEXT FROM TmpCDCObjects INTO @SchemaName, @ObjectName, @CaptureInstance;
	END;
	CLOSE TmpCDCObjects;
	DEALLOCATE TmpCDCObjects;
END;
SET NOCOUNT OFF;

SELECT blocking_session_id '阻塞进程的ID', wait_duration_ms '等待时间(毫秒)', session_id '(会话ID)' FROM sys.dm_os_waiting_tasks

select request_session_id spid,OBJECT_NAME(resource_associated_entity_id) tableName

from sys.dm_tran_locks where resource_type='OBJECT'


--查询当前活动的锁管理器资源的信息 

SELECT resource_type '资源类型',request_mode '请求模式',request_type '请求类型',request_status '请求状态',request_session_id '会话ID' FROM sys.dm_tran_locks

 

--查询数据库进程（where 筛选库）

select spId  from master..SysProcesses

where db_Name(dbID) = '312' and spId <> @@SpId and dbID <> 0

--查询死锁表

select request_session_id spid,OBJECT_NAME(resource_associated_entity_id) tableName

from sys.dm_tran_locks where resource_type='OBJECT'

 

--死锁相关信息查询

exec sp_who2 312

 

--查看此进程执行的SQL

dbcc inputbuffer(spid)

 

--查看隔离级别

DBCC USEROPTIONS

kill 312
