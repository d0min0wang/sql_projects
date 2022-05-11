select * from ATTMASTER where month(dates)='10'
select * from perempms

EXEC sp_configure 'show advanced options', 1

GO
EXEC sp_configure 'Ad Hoc Distributed Queries', 1

GO 
sp_configure 'Ole Automation Procedures', 1;

GO 

EXEC sp_droplogin 'kingdee'

EXEC sp_addlogin 'kingdee', 'kingdeetohrm', 'fangpuhrm'

use fangpuhrm 
go
EXEC sp_grantdbaccess
        'kingdee', 'kingdeetohrm'
grant select 
on perempms 
to kingdeetohrm 