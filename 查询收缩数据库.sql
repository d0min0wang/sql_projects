DBCC SQLPERF(LOGSPACE)

select count(*) from icmo

SELECT name 
,size/128.0 as size_MB
,size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 AS AvailableSpaceInMB
,*
FROM sys.database_files;


USE [tempdb]
GO
DBCC FREESYSTEMCACHE ('ALL')
GO
DBCC SHRINKFILE(N'tempdev',2)
DBCC SHRINKFILE(N'templog',2)
DBCC SHRINKFILE(N'temp2',2)
DBCC SHRINKFILE(N'temp3',2)
DBCC SHRINKFILE(N'temp4',2)
DBCC SHRINKFILE(N'temp5',2)
DBCC SHRINKFILE(N'temp6',2)
DBCC SHRINKFILE(N'temp7',2)
DBCC SHRINKFILE(N'temp8',2)
GO

USE [TEMPDB]
GO
DBCC SHRINKFILE(N'tempdev.mdf',0,TRUNCATEONLY)
GO

ALTER DATABASE AIS20140921170539 SET RECOVERY SIMPLE;
GO

CHECKPOINT;
GO

DBCC SHRINKFILE ('SCM102SP2_log', 10);
GO

ALTER DATABASE AIS20140921170539 SET RECOVERY FULL;
GO

DBCC LOGINFO;


DBCC OPENTRAN

SELECT session_id, elapsed_time_seconds
FROM sys.dm_tran_active_snapshot_database_transactions

--查看tempdb记录的分配情况
use tempdb  
go  
SELECT top 10 t1.session_id,                                                      
t1.internal_objects_alloc_page_count,  t1.user_objects_alloc_page_count,  
t1.internal_objects_dealloc_page_count , t1.user_objects_dealloc_page_count,
t3.login_name,t3.status,t3.total_elapsed_time  
from sys.dm_db_session_space_usage  t1  
inner join sys.dm_exec_sessions as t3  
on t1.session_id = t3.session_id  
where (t1.internal_objects_alloc_page_count>0  
or t1.user_objects_alloc_page_count >0  
or t1.internal_objects_dealloc_page_count>0  
or t1.user_objects_dealloc_page_count>0)  
order by t1.internal_objects_alloc_page_count desc

--看这session_id的用处
select p.*,s.text  
from master.dbo.sysprocesses p  
cross apply sys.dm_exec_sql_text(p.sql_handle) s  
where spid = 79
