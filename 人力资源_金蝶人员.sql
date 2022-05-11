USE [fangpuhrm]
GO
/****** 对象:  StoredProcedure [dbo].[EX_AUTO_FILL_KINGDEE_EMP]    脚本日期: 10/17/2013 17:10:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[EX_AUTO_FILL_KINGDEE_EMP]
AS

--EXEC  sp_addlinkedserver
--      @server='kingdeedatabase',
--		@srvproduct='',
--		@provider='SQLOLEDB',
--		@datasrc='192.168.0.101'
--EXEC  sp_addlinkedsrvlogin 'kingdeedatabase','false',NULL,'user','user001'

update t1 set t1.F_102=t2.STAFF_NO 
from kingdeedatabase.AIS20130811090352.dbo.t_Emp t1
left join fangpuhrm.dbo.perempms t2 on (case when left(t1.FName,1) like '%[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]%'
											then right(t1.FName,len(t1.FName)-1)
											else
												t1.FName
										end)=t2.STAFF_NAME
where t1.F_102 IS NULL and t2.STAFF_NO IS NOT NULL and t2.[STATUS]='N'


--Exec sp_droplinkedsrvlogin kingdeedatabase,Null
--Exec sp_dropserver kingdeedatabase

--EXECUTE EX_AUTO_FILL_KINGDEE_EMP