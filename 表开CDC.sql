SELECT * FROM sys.tables WHERE is_tracked_by_cdc = 1

if exists(select 1 from sys.databases where name='peiliao' and is_cdc_enabled=0)
begin
    exec sys.sp_cdc_enable_db
end

select is_cdc_enabled from sys.databases where name='peiliao';

alter table actual_data add  constraint pk_actual_data primary key(ID)

select * from t_itemclass

SELECT * FROM sys.tables WHERE is_tracked_by_cdc = 1 ORDER BY name

--表开CDC
DECLARE @TablaName NVARCHAR(100)

SET @TablaName='t_itemclass'

IF EXISTS(SELECT 1 FROM sys.tables WHERE name=@TablaName AND is_tracked_by_cdc = 0)
BEGIN
    EXEC sys.sp_cdc_enable_table
        @source_schema = 'dbo', -- source_schema
        @source_name = @TablaName, -- table_name
        @capture_instance = NULL, -- capture_instance
        @supports_net_changes = 1, -- supports_net_changes
        @role_name = NULL, -- role_name
        @index_name = NULL, -- index_name
        @captured_column_list = NULL, -- captured_column_list
        @filegroup_name = 'CDC' -- filegroup_name
END

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