
USE [master]
GO
ALTER DATABASE fangpuhrm SET RECOVERY SIMPLE WITH NO_WAIT
GO
ALTER DATABASE fangpuhrm SET RECOVERY SIMPLE --简单模式
GO
USE fangpuhrm
GO
DBCC SHRINKFILE (N'fangpuhrm_Log' , 11, TRUNCATEONLY)
GO
USE [master]
GO
ALTER DATABASE fangpuhrm SET RECOVERY FULL WITH NO_WAIT
GO
ALTER DATABASE fangpuhrm SET RECOVERY FULL --还原为完全模式
GO 