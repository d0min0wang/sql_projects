USE [AIS20130811090352]
GO
/****** 对象:  Trigger [dbo].[icstockbill_fcostcenterid]    脚本日期: 10/16/2013 10:26:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[t_emp_update_emp_no]
ON [dbo].[t_Emp]
INSTEAD OF
UPDATE 
AS
begin
declare @fitemid int, @fempname nvarchar(200),@fempno nvarchar(200)

set @fempno='21001'

select @fitemid=FItemID,
	@fempname=(case when left(FName,1) like '%[ABCDEFGHIJKLMNOPQRSTUVWXYZ]%'
					then right(FName,len(FName)-1)
				else
					FName
				end)
from inserted

--EXEC  sp_addlinkedserver
--        @server='hrmdatabase',
--		@srvproduct='',
--		@provider='SQLOLEDB',
--		@datasrc='192.168.0.73'
--
--EXEC  sp_addlinkedsrvlogin 'hrmdatabase','false',NULL,'kingdee','kingdeetohrm'

update t_Emp set F_102=@fempno
--		(select STAFF_NO FROM hrmdatabase.fangpuhrm.dbo.perempms
--			WHERE STATUS='N' AND STAFF_NAME=@fempname)
where FItemID=@fitemid

--Exec sp_droplinkedsrvlogin hrmdatabase,Null
--Exec sp_dropserver hrmdatabase

end

--select * from t_Base_Emp
