--create table [2009sort](���� nvarchar(200),������λ nvarchar(200),�·� nvarchar(200),ʵ������ decimal(18,4),���۽�� decimal(18,4),����ҵ nvarchar(200),����ҵ nvarchar(200))
--insert into [dbo].[2009sort](�·�,����,������λ,ʵ������,���۽��,����ҵ,����ҵ)
--select t1.�·� ,t1.���� ,t1.������λ ,t1.ʵ������ ,t1.���۽�� ,t2.F_110 ,t2.F_111 
--from [dbo].[2009data] t1 
--left join [dbo].[t_Organization] t2 on t1.������λ =t2.FName 
--truncate table [dbo].[2008sort]

select * from [dbo].[2009sort]