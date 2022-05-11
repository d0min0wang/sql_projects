USE [AIS20120806141655]
GO
/****** 对象:  Trigger [dbo].[icstockbill_ICMOInStock]    脚本日期: 08/13/2012 16:28:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[JR_icstockbillEntry_ICMOInStock]
ON [dbo].[ICStockBillEntry]
FOR insert
AS
declare @FAuxQty decimal(18,4),@FInterID int

select @FAuxQty=FAuxQty,@FInterID=FICMOInterID from Inserted
if @FInterID>0
begin
	update ICMO set FHeadSelfJ0179=isnull(FHeadSelfJ0179,0)+isnull(@FAuxQty,0)
	where FInterID=@FInterID
end
--select * from t_tabledescription where fdescription like '%任务单%'
--select * from t_fielddescription where ftableid=470000
--select * from icstockbill t1
--left join icstockbillentry t2 on t1.Finterid=t2.finterid
--where t1.fbillno='CIN414183'
