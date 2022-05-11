USE master 
exec master..xp_cmdshell 'net use z: \\192.168.0.236\DBBackup backupuser~!@#$% /user:192.168.0.236\backupuser'
backup database AIS20100618152307 to disk='z:\DBBackup20120822.bak' --AIS20100618152307
exec master..xp_cmdshell 'net use z: /delete'

select * from ICMO
--´ò¿ªxp_cmdshell
sp_configure 'show advanced options', 1
go
reconfigure
go
sp_configure 'xp_cmdshell', 1
go
reconfigure
go
--¹Ø±Õxp_cmdshell
sp_configure 'xp_cmdshell', 0
go
reconfigure
go
sp_configure 'show advanced options', 0
go
reconfigure
go


USE master 
exec master..xp_cmdshell 'net use z: \\192.168.0.236\database backupuser~!@#$% /user:192.168.0.236\backupuser'
backup database AIS20131027183315 to disk='z:\AIS20131027183315.bak' --AIS20100618152307
exec master..xp_cmdshell 'net use z: /delete'
