CREATE PROCEDURE dbo.PROC_DELTABLE 
AS 
DECLARE @TABLENAME AS NVARCHAR(128) 
DECLARE cur_del CURSOR FOR

--删除表名以KCPD结尾的所有表：’%KCPD’ 
select name from sysobjects where type='U' and name like '%bak'

OPEN cur_del 
FETCH NEXT FROM cur_del INTO @TABLENAME 
WHILE(@@FETCH_STATUS=0) 
BEGIN 
PRINT 'drop table '+@TABLENAME 
EXEC('drop table '+@TABLENAME) 
FETCH NEXT FROM cur_del INTO @TABLENAME 
END 
CLOSE cur_del 
DEALLOCATE cur_del 
GO

EXEC PROC_DELTABLE

--查询数据表大小
declare  @table_spaceused table
(name   nvarchar(100)
,rows   int
,reserved   nvarchar(100)
,data   nvarchar(100)
,index_size nvarchar(100)
,unused nvarchar(100)
)

insert into @table_spaceused
(name,rows,reserved,data,index_size,unused )
exec sp_MSforeachtable
@command1='exec sp_spaceused ''?'''

select * from @table_spaceused order by [rows] DESC

--清除报警表中不为1的数据/半年前的记录
DECLARE @TABLENAME AS NVARCHAR(128) 
DECLARE cur_del CURSOR FOR

--删除表名以KCPD结尾的所有表：’%K[dbo].[t_DE01AlarmLogger]’ 
--select count(*) from [dbo].[t_DY04AlarmLogger] where fvalue=0
--DELETE from [dbo].[t_DY04AlarmLogger] where fvalue=0

select name from sysobjects where type='U' and name like '%AlarmLogger'

OPEN cur_del 
FETCH NEXT FROM cur_del INTO @TABLENAME 
WHILE(@@FETCH_STATUS=0) 
BEGIN 
PRINT 'delete from '+@TABLENAME +' WHERE  year(fTimestamp)<DATEADD(MONTH, -6,getdate())'
EXEC('delete from '+@TABLENAME +' WHERE  year(fTimestamp)<DATEADD(MONTH, -6,getdate())') 
FETCH NEXT FROM cur_del INTO @TABLENAME 
END 
CLOSE cur_del 
DEALLOCATE cur_del 
GO

SELECT count(*) from t_DF01AlarmLogger WHERE  year(fTimestamp)<DATEADD(MONTH, -6,getdate())