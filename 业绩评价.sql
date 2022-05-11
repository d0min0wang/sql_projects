USE [fangpuhrm]
GO
/****** Object:  StoredProcedure [dbo].[EX_AUTO_FILL_SAP_TABLE]   Script Date: 2014/7/18 13:47:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[EX_AUTO_FILL_SAP_TABLE]
	@NewPeriod as float, --新评估周期
	@PastPeriod as float --旧评估周期
AS
SET NOCOUNT ON
--select * from APP_PED_IMMS where 
--PED_SEQ=4
--IM_NAME='销售额 735万'

--select t2.IM_SEQ,t1.* from APP_SAP_IMMS t1
--left join APP_PED_IMMS t2 on t1.PED_SEQ=t2.PED_SEQ and t1.IM_NAME=t2.IM_NAME
--where t2.PED_SEQ=5

--create table temp_bonos_table
--(PED_SEQ float,
--IM_SEQ int,
--new_IM_SEQ int,
--CT_SEQ int,
--IM_IS_BSC bit,
--IM_BSC_CT_SEQ int,
--IM_BSC_IM_SEQ int,
--STAFF_NO char(10),
--IM_NAME char(220),
--IM_DESCRIPTION char(2400),
--IM_ROLE char(30),
--IM_PERCENTAGE real)

--drop table temp_bonos_table

--select 
--*
--from temp_bonos_table t1 left join APP_PED_IMMS t2

--declare @NewPeriod float
--declare @PastPeriod float

--set @NewPeriod=11 --新周期代码
--set @PastPeriod=10   --旧周期代码

--删除新周期评估方面
delete from dbo.APP_SAP_IMMS where PED_SEQ=@NewPeriod
--删除新周期评估指标
delete from dbo.APP_SAP_CTMS where PED_SEQ=@NewPeriod


truncate table temp_bonos_table

INSERT INTO temp_bonos_table
select t1.PED_SEQ,
	t2.IM_SEQ,
	t1.IM_SEQ,
	t2.CT_SEQ,
	t1.IM_IS_BSC,
	t1.IM_BSC_CT_SEQ,
	t1.IM_BSC_IM_SEQ,
	t1.STAFF_NO,
	t2.IM_NAME,
	t2.IM_DESCRIPTION,
	t1.IM_ROLE,
	t1.IM_PERCENTAGE from APP_SAP_IMMS t1
left join APP_PED_IMMS t2 on t1.PED_SEQ=t2.PED_SEQ and t1.IM_NAME=t2.IM_NAME
where t2.PED_SEQ=@PastPeriod


---------复制指标------
--插入评估方面
INSERT INTO dbo.APP_SAP_CTMS (PED_SEQ, STAFF_NO, CT_SEQ, CT_PERCENTAGE) 
select @NewPeriod, 
	STAFF_NO,
	1,
	100
from dbo.APP_PED_EMPMS WHERE PED_SEQ=@NewPeriod
-- (11,'10004',1,100)

INSERT INTO dbo.APP_SAP_CTMS (PED_SEQ, STAFF_NO, CT_SEQ, CT_PERCENTAGE) 
select @NewPeriod, 
	STAFF_NO,
	2,
	0
from dbo.APP_PED_EMPMS WHERE PED_SEQ=@NewPeriod
--VALUES (11,'10004',2,0)

--插入评估指标
INSERT INTO dbo.APP_SAP_IMMS(PED_SEQ, 
	STAFF_NO, 
	CT_SEQ, 
	IM_SEQ, 
	IM_IS_BSC, 
	IM_BSC_CT_SEQ, 
	IM_BSC_IM_SEQ, 
	IM_NAME, 
	IM_DESCRIPTION, 
	IM_ROLE, 
	IM_PERCENTAGE, 
	IM_COMMENT, 
	IM_SCORES, 
	IM_REMARK, 
	IM_SUMUP, 
	IM_SUMUP_SCORES, 
	IM_IS_FIX)
 SELECT 
	@NewPeriod, 
	t1.STAFF_NO, 
	t1.CT_SEQ, 
	t1.new_IM_SEQ, 
	t1.IM_IS_BSC,--1 
	t1.IM_BSC_CT_SEQ, --1
	t1.IM_BSC_IM_SEQ, --1
	t2.IM_NAME, 
	t2.IM_DESCRIPTION, 
	t1.IM_ROLE, --1
	t1.IM_PERCENTAGE,--1 
	t2.IM_COMMENT, 
	0, 
	'', 
	'', 
	0, 
	0
FROM dbo.temp_bonos_table t1
left join dbo.APP_PED_IMMS t2
on t1.IM_SEQ=t2.IM_SEQ
WHERE t2.PED_SEQ=@NewPeriod 
AND t1.STAFF_NO IN (SELECT STAFF_NO FROM  dbo.APP_PED_EMPMS WHERE PED_SEQ=@NewPeriod)


--UPDATE A SET A.IM_COMMENT=B.IM_COMMENT 
--FROM APP_SAP_IMMS A,APP_PED_IMMS B 
--WHERE A.IM_NAME=B.IM_NAME
--AND A.IM_DESCRIPTION=B.IM_DESCRIPTION
--AND B.PED_SEQ='新建周期代码' AND A.PED_SEQ='新建周期代码'

--select t2.* from temp_bonos_table t1
--left join APP_PED_IMMS t2 on t1.IM_SEQ=t2.IM_SEQ
--where t2.PED_SEQ=5

--重复记录
--select * from temp_bonos_table a
--where (a.STAFF_NO,a.new_IM_SEQ) in  (select STAFF_NO,new_IM_SEQ from temp_bonos_table group by STAFF_NO,new_IM_SEQ  having count(*) > 1)

--SELECT * FROM  dbo.APP_SAP_IMMS WHERE PED_SEQ =11

--EXEC 
-- =============================================
-- EXECUTE EX_AUTO_FILL_SAP_TABLE 13,12
-- =============================================


