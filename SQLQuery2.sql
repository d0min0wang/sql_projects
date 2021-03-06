USE [AIS20090711180130]
GO
/****** Object:  StoredProcedure [dbo].[p_xy_SaleAnalyst]    Script Date: 12/31/2009 09:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--销售分析
ALTER PROCEDURE [dbo].[p_xy_SaleAnalyst]
AS
SET NOCOUNT ON 
IF EXISTS (SELECT name FROM sysobjects WHERE name = N't_xy_SaleAnalyst' AND type = 'U')
BEGIN
	TRUNCATE TABLE t_xy_SaleAnalyst
END

IF NOT EXISTS (SELECT name FROM sysobjects WHERE name = N't_xy_SaleAnalyst' AND type = 'U')
BEGIN
	Create Table t_xy_SaleAnalyst(FSupplyID int,FChanpinName nvarchar(200),FKehuNumber nvarchar(200),FKehuName nvarchar(200),FChengben decimal(18,4),FConsignPrice decimal(18,4),FConsignAmount decimal(18,4),
		FAuxQty decimal(18,4),FProfitRate decimal(18,4),FZuName nvarchar(200),F_110 nvarchar(200),F_111 nvarchar(200))
END

INSERT INTO t_xy_SaleAnalyst(FSupplyID,FChanpinName,FKehuNumber,FKehuName,FChengben,FConsignPrice,FConsignAmount,
		FAuxQty,FZuName,F_110,F_111)
SELECT v1.FSupplyID,v4.FShortNumber,v2.FNumber,v2.FName,u1.FAmount,u1.FConsignPrice,u1.FConsignAmount,
		u1.FAuxQty,v3.FName,v2.F_110,v2.F_111
--	,v5.FName AS FProdTrade,v4.FName AS FMidTrade,v3.FName AS FBigTrade 
FROM ICStockBill v1 
INNER JOIN ICStockBillEntry u1 ON u1.FInterID=v1.FInterID
LEFT JOIN t_Organization v2 ON v1.FSupplyID=v2.FItemID
LEFT JOIN t_Item v3 ON v2.Fdepartment=v3.FItemID
LEFT JOIN t_Item v4 ON u1.FItemID=v4.FItemID
--LEFT JOIN t_Item v3 ON v3.FItemID=v2.F_117
--LEFT JOIN t_Item v4 ON v4.FItemID=v3.FParentID
--LEFT JOIN t_Item v5 ON v5.FItemID=v4.FParentID
WHERE v1.FTranType=21 And v1.FDate BETWEEN '2009-01-01' AND '2009-12-31' 
--AND v3.FName='手把套事业部'
--Group by v1.FSupplyID,u1.FItemID

UPDATE t_xy_SaleAnalyst SET FProfitRate=(CASE WHEN ISNULL(FConsignAmount,0)<>0 THEN (FConsignAmount-FChengBen)/FConsignAmount ELSE 0 END)
SELECT * FROM t_xy_SaleAnalyst
--DROP TABLE t_xy_SaleAnalyst

--EXECUTE p_xy_SaleAnalyst