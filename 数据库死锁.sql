select *
  from master..SysProcesses
 where db_Name(dbID) = 'AIS20140921170539'
   and spId <> @@SpId
   and dbID <> 0
   and blocked >0;

   kill 295
   
EXEC sp_who_lock

--检测死锁
--如果发生死锁了，我们怎么去检测具体发生死锁的是哪条SQL语句或存储过程？
--这时我们可以使用以下存储过程来检测，就可以查出引起死锁的进程和SQL语句。SQL Server自带的系统存储过程sp_who和sp_lock也可以用来查找阻塞和死锁, 但没有这里介绍的方法好用。
use master
go
create procedure sp_who_lock
as
begin
declare @spid int,@bl int,
 @intTransactionCountOnEntry int,
  @intRowcount int,
  @intCountProperties int,
  @intCounter int
 create table #tmp_lock_who (
 id int identity(1,1),
 spid smallint,
 bl smallint)
 IF @@ERROR<>0 RETURN @@ERROR
 insert into #tmp_lock_who(spid,bl) select 0 ,blocked
 from (select * from sysprocesses where blocked>0 ) a 
 where not exists(select * from (select * from sysprocesses where blocked>0 ) b 
 where a.blocked=spid)
 union select spid,blocked from sysprocesses where blocked>0
 IF @@ERROR<>0 RETURN @@ERROR 
-- 找到临时表的记录数
 select @intCountProperties = Count(*),@intCounter = 1
 from #tmp_lock_who
 IF @@ERROR<>0 RETURN @@ERROR 
 if @intCountProperties=0
 select '现在没有阻塞和死锁信息' as message
-- 循环开始
while @intCounter <= @intCountProperties
begin
-- 取第一条记录
 select @spid = spid,@bl = bl
 from #tmp_lock_who where Id = @intCounter 
 begin
 if @spid =0 
   select '引起数据库死锁的是: '+ CAST(@bl AS VARCHAR(10)) + '进程号,其执行的SQL语法如下'
 else
   select '进程号SPID：'+ CAST(@spid AS VARCHAR(10))+ '被' + '进程号SPID：'+ CAST(@bl AS VARCHAR(10)) +'阻塞,其当前进程执行的SQL语法如下'
 DBCC INPUTBUFFER (@bl )
 end
-- 循环指针下移
 set @intCounter = @intCounter + 1
end
drop table #tmp_lock_who
return 0
end




--杀死锁和进程
--如何去手动的杀死进程和锁？最简单的办法，重新启动服务。但是这里要介绍一个存储过程，通过显式的调用，可以杀死进程和锁。
use master
go
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_killspid]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[p_killspid]
GO
create proc p_killspid
@dbname varchar(200) --要关闭进程的数据库名
as
 declare @sql nvarchar(500) 
 declare @spid nvarchar(20)
 declare #tb cursor for
  select spid=cast(spid as varchar(20)) from master..sysprocesses where dbid=db_id(@dbname)
 open #tb
 fetch next from #tb into @spid
 while @@fetch_status=0
 begin
  exec('kill '+@spid)
  fetch next from #tb into @spid
 end
 close #tb
 deallocate #tb
go
--用法 
exec p_killspid 'newdbpy'



--查看锁信息
--如何查看系统中所有锁的详细信息？在企业管理管理器中，我们可以看到一些进程和锁的信息，这里介绍另外一种方法。
--查看锁信息
create table #t(req_spid int,obj_name sysname)
declare @s nvarchar(4000)
 ,@rid int,@dbname sysname,@id int,@objname sysname
declare tb cursor for
 select distinct req_spid,dbname=db_name(rsc_dbid),rsc_objid
 from master..syslockinfo where rsc_type in(4,5)
open tb
fetch next from tb into @rid,@dbname,@id
while @@fetch_status=0
begin
 set @s='select @objname=name from ['+@dbname+']..sysobjects where id=@id'
 exec sp_executesql @s,N'@objname sysname out,@id int',@objname out,@id
 insert into #t values(@rid,@objname)
 fetch next from tb into @rid,@dbname,@id
end
close tb
deallocate tb
select 进程id=a.req_spid
 ,数据库=db_name(rsc_dbid)
 ,类型=case rsc_type when 1 then 'NULL 资源（未使用）'
  when 2 then '数据库'
  when 3 then '文件'
  when 4 then '索引'
  when 5 then '表'
  when 6 then '页'
  when 7 then '键'
  when 8 then '扩展盘区'
  when 9 then 'RID（行 ID)'
  when 10 then '应用程序'
 end
 ,对象id=rsc_objid
 ,对象名=b.obj_name
 ,rsc_indid
 from master..syslockinfo a left join #t b on a.req_spid=b.req_spid
go
drop table #t