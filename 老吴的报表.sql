--create table [2009sort](�·� nvarchar(200),���� nvarchar(200),����ҵ nvarchar(200),������λ nvarchar(200),ʵ������ decimal(18,4),���۽�� decimal(18,4))
insert into [dbo].[2009sort](�·�,����,����ҵ,������λ,ʵ������,���۽��)
select t1.�·� ,t1.���� ,t2.F_110,t1.������λ ,t1.ʵ������ ,t1.���۽��  
from [dbo].[2009data] t1 
left join [dbo].[t_Organization] t2 on t1.������λ =t2.FName 
--select * from [dbo].[2009sort]
--SELECT CASE WHEN (GROUPING(�·�) = 1) THEN 'ALL' 
--            ELSE ISNULL(�·�, 'UNKNOWN') 
--       END AS �·�, 
SELECT CASE WHEN (GROUPING(����) = 1) THEN 'ALL' 
            ELSE ISNULL(����, 'UNKNOWN') 
       END AS ����, 
       CASE WHEN (GROUPING(����ҵ) = 1) THEN 'ALL' 
            ELSE ISNULL(����ҵ, 'UNKNOWN') 
       END AS ����ҵ, 
       --������λ AS ������λ,
       SUM(ʵ������) AS ʵ������,
       SUM(���۽��) AS ���۽�� 
FROM [dbo].[2009sort]
GROUP BY ����,����ҵ  WITH ROLLUP 
truncate table [dbo].[2009sort]
--drop table [dbo].[2009sort]