--create table [2009sort](部门 nvarchar(200),购货单位 nvarchar(200),月份 nvarchar(200),实发数量 decimal(18,4),销售金额 decimal(18,4),大行业 nvarchar(200),中行业 nvarchar(200))
--insert into [dbo].[2009sort](月份,部门,购货单位,实发数量,销售金额,大行业,中行业)
--select t1.月份 ,t1.部门 ,t1.购货单位 ,t1.实发数量 ,t1.销售金额 ,t2.F_110 ,t2.F_111 
--from [dbo].[2009data] t1 
--left join [dbo].[t_Organization] t2 on t1.购货单位 =t2.FName 
--truncate table [dbo].[2008sort]

select * from [dbo].[2009sort]