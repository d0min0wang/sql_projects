--create table [2009sort](月份 nvarchar(200),部门 nvarchar(200),大行业 nvarchar(200),购货单位 nvarchar(200),实发数量 decimal(18,4),销售金额 decimal(18,4))
insert into [dbo].[2009sort](月份,部门,大行业,购货单位,实发数量,销售金额)
select t1.月份 ,t1.部门 ,t2.F_110,t1.购货单位 ,t1.实发数量 ,t1.销售金额  
from [dbo].[2009data] t1 
left join [dbo].[t_Organization] t2 on t1.购货单位 =t2.FName 
--select * from [dbo].[2009sort]
--SELECT CASE WHEN (GROUPING(月份) = 1) THEN 'ALL' 
--            ELSE ISNULL(月份, 'UNKNOWN') 
--       END AS 月份, 
SELECT CASE WHEN (GROUPING(部门) = 1) THEN 'ALL' 
            ELSE ISNULL(部门, 'UNKNOWN') 
       END AS 部门, 
       CASE WHEN (GROUPING(大行业) = 1) THEN 'ALL' 
            ELSE ISNULL(大行业, 'UNKNOWN') 
       END AS 大行业, 
       --购货单位 AS 购货单位,
       SUM(实发数量) AS 实发数量,
       SUM(销售金额) AS 销售金额 
FROM [dbo].[2009sort]
GROUP BY 部门,大行业  WITH ROLLUP 
truncate table [dbo].[2009sort]
--drop table [dbo].[2009sort]