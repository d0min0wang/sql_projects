SELECT OBJECT_NAME(ind.OBJECT_ID) AS TableName, 
ind.name AS IndexName, indexstats.index_type_desc AS IndexType, 
indexstats.avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats 
INNER JOIN sys.indexes ind  
ON ind.object_id = indexstats.object_id 
AND ind.index_id = indexstats.index_id 
WHERE indexstats.avg_fragmentation_in_percent > 10 
ORDER BY indexstats.avg_fragmentation_in_percent DESC

select is_read_committed_snapshot_on from sys.databases where name='AIS20140921170539';

use master;
alter database AIS20201019094713 set read_committed_snapshot on;

select name,user_access,user_access_desc,
	snapshot_isolation_state,snapshot_isolation_state_desc,
	is_read_committed_snapshot_on
from sys.databases

sp_configure 'show advanced options', 1; GO  RECONFIGURE WITH OVERRIDE; GO  sp_configure 'max degree of parallelism', 1; GO  RECONFIGURE WITH OVERRIDE; GO

use master  
declare @dbname as sysname declare @sql varchar(max)  
 --@dbname='test'  为K/3Cloud对应的数据库名 
 set @dbname='AIS20140921170539'      
 set @sql=''  
    select @sql=@sql+' kill '+cast(spid as varchar)+';' from master..sysprocesses where dbid=db_id(@dbname);  
set @sql=@sql+'alter database '+@dbname+' set read_committed_snapshot on ' ;   
exec(@sql); 

select * from t_userprofile where fuserid =(select fuserid from t_user where fname='苏娇芳');

 