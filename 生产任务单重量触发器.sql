USE [AIS20100618152307]
GO
/****** ����:  Trigger [dbo].[JR_AuxWht]    �ű�����: 08/13/2012 10:26:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


drop  Trigger JR_AuxWht On ICMO

For Update
as
declare @FInterID int,@FGrossWeight float

Select 
	@FInterID=FInterID 
From Inserted

select @FGrossWeight=FGrossWeight from t_icitem t1 ,Inserted t2 where t1.FitemID=t2.FitemID

update ICMO set
	FHeadSelfJ0174=isnull(@FGrossWeight,0)*isnull(FAuxQty,0) --�ƻ�������=����*�ƻ���������
WHERE  FinterID=@FInterID



--select top 100000 t2.FGrossWeight from ICMO t1
--left join t_ICItem t2 on t1.FItemID=t2.FItemID
--where fbillno='75945'
update t1 set 
	t1.FHeadSelfJ0174=isnull(t2.FGrossWeight,0)*isnull(t1.FAuxQty,0)
from ICMO t1
left join t_ICItem t2 on t1.FItemID=t2.FItemID
where t1.fbillno='75945'