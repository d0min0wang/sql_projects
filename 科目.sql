 USE [AIS20131027183315]
GO
/****** Object:  StoredProcedure [dbo].[p_xy_SaleByProd]    Script Date: 2014/7/4 16:52:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXECUTE p_xy_SaleByProd '部门','起始物料代码','截止物料代码','产业','大行业','中行业','区域','省份','客户级别','起始客户代码','截止客户代码','业务员','配套产品','助记码',2010,3
--EXECUTE [p_xy_kemu] 2014,1,2,'','06','07'
ALTER   PROCEDURE [dbo].[p_xy_kemu]
	@FYear int, --年
	@FStartPeriod int, --起始期间
	@FEndPeriod int, --截止期间
	@FExplanation nvarchar(50),
	@FStartDept nvarchar(5), --部门起始代码
	@FEndDept nvarchar(5) --部门截止代码
AS
SET NOCOUNT ON

 Select Fperiod,
	Fnumber,
	Fname,
	FExplanation,
	FAmountFor,
	FAMOUNTFORCREDIT,
	F1,
	F2,
	F3,
	FVoucherID,
	FEntryID,0 as FisAdjustVoucher into #temp_kemu 
From (select Tb_show.* ,F1,F2,F3 from (select 
								t_VoucherEntry.FVoucherID,
								t_VoucherEntry.FEntryID,
								T_voucher.Fperiod , 
								a.Fnumber , 
								a.Fname , 
								T_voucherentry.FExplanation , 
								T_voucherentry.Famount*T_voucherentry.Fdc FAMOUNTFOR, 
								T_voucherentry.Famount*(1-T_voucherentry.Fdc) FAMOUNTFORCREDIT,  
								t_voucherentry.Fdetailid  from (Select 
FBrNo,FvoucherID,FDate,FYear,FPeriod, 
FGroupID,FNumber,FReference,FExplanation,FAttachments, 
FEntryCount,FDebitTotal,FCreditTotal,FInternalInd,FChecked, 
FPosted,FPreparerID,FCheckerID,FPosterID,FCashierID, 
FHandler,FOwnerGroupID,FObjectName,FParameter,FSerialNum, 
FTranType,FTransDate,FFrameWorkID,FApproveID,FFootNote, 
UUID , FMODIFYTIME 
From t_Voucher 
Union All 
Select 
FBrNo,FvoucherID,FDate,FYear,FPeriod, 
FGroupID,FNumber,FReference,FExplanation,FAttachments, 
FEntryCount,FDebitTotal,FCreditTotal,FInternalInd,FChecked, 
FPosted,FPreparerID,FCheckerID,FPosterID,FCashierID, 
FHandler,FOwnerGroupID,FObjectName,FParameter,FSerialNum, 
FTranType,FTransDate,FFrameWorkID,FApproveID,FFootNote, 
UUID , FMODIFYTIME 
From t_VoucherAdjust)  t_voucher,t_VoucherEntry as t_VoucherEntry,t_Account a,t_vouchergroup  
where T_voucherentry.fdetailid<>0  
and t_voucher.fvoucherid=t_voucherentry.fvoucherid 
and t_voucherentry.faccountid=a.faccountid 
and t_vouchergroup.Fgroupid=T_voucher.Fgroupid  
And t_voucher.FYear=@FYear 
And t_voucher.FPeriod>=@FStartPeriod 
And t_voucher.FPeriod<=@FEndPeriod
and CASE WHEN @FExplanation=''  THEN t_voucher.FExplanation ELSE @FExplanation END =t_voucher.FExplanation
--and (a.Fnumber<='4105.04.04' OR a.Fnumber >= '6000.04.04')  
)  Tb_show  
Left outer join 
( SELECT FdetailID , b.fnumber+'-'+b.fname F1 
	from t_itemdetail a , t_item b 
	where a.F1 = b.fitemid ) F1 
	on F1.Fdetailid=Tb_show.fdetailid  
	Left outer join 
		( SELECT FdetailID , b.fnumber+'-'+b.fname F2 
			from t_itemdetail a , t_item b 
			where a.F2 = b.fitemid 
				and CAST(b.fnumber AS decimal(9,2)) >=CAST(@FStartDept AS decimal(9,2))
				and CAST(b.fnumber AS decimal(9,2)) <=CAST(@FEndDept AS decimal(9,2))
				) F2 
			on F2.Fdetailid=Tb_show.fdetailid  
			Left outer join 
				( SELECT FdetailID , b.fnumber+'-'+b.fname F3 
					from t_itemdetail a , t_item b 
					where a.F3 = b.fitemid ) F3 
					on F3.Fdetailid=Tb_show.fdetailid ) as t 

select Fperiod AS 会计期间,
	Fnumber AS 科目代码,
	Fname AS 科目名称,
	FExplanation AS 凭证摘要,
	FAmountFor AS 借方发生额,
	FAMOUNTFORCREDIT AS 贷方发生额,
	F2 AS 部门 
from #temp_kemu
--where F2

drop table #temp_kemu

--select CAST('5502.02.10' AS decimal(9,4))