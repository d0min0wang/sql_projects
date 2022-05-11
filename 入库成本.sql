SET NOCOUNT ON
DECLARE @FMonth int
DECLARE @FIndex int
DECLARE @Sql nvarchar(1000)

CREATE TABLE #cost_In(FItemID int,
	FQty1 decimal(18,4),FQtyLow1 decimal(18,4),FChukuChengBen1 decimal(18,4),FHuliaoChengben1 decimal(18,4),FAmount1 decimal(18,4),
	FQty2 decimal(18,4),FQtyLow2 decimal(18,4),FChukuChengBen2 decimal(18,4),FHuliaoChengben2 decimal(18,4),FAmount2 decimal(18,4),
	FQty3 decimal(18,4),FQtyLow3 decimal(18,4),FChukuChengBen3 decimal(18,4),FHuliaoChengben3 decimal(18,4),FAmount3 decimal(18,4),
	FQty4 decimal(18,4),FQtyLow4 decimal(18,4),FChukuChengBen4 decimal(18,4),FHuliaoChengben4 decimal(18,4),FAmount4 decimal(18,4),
	FQty5 decimal(18,4),FQtyLow5 decimal(18,4),FChukuChengBen5 decimal(18,4),FHuliaoChengben5 decimal(18,4),FAmount5 decimal(18,4),
	FQty6 decimal(18,4),FQtyLow6 decimal(18,4),FChukuChengBen6 decimal(18,4),FHuliaoChengben6 decimal(18,4),FAmount6 decimal(18,4),
	FQty7 decimal(18,4),FQtyLow7 decimal(18,4),FChukuChengBen7 decimal(18,4),FHuliaoChengben7 decimal(18,4),FAmount7 decimal(18,4),
	FQty8 decimal(18,4),FQtyLow8 decimal(18,4),FChukuChengBen8 decimal(18,4),FHuliaoChengben8 decimal(18,4),FAmount8 decimal(18,4),
	FQty9 decimal(18,4),FQtyLow9 decimal(18,4),FChukuChengBen9 decimal(18,4),FHuliaoChengben9 decimal(18,4),FAmount9 decimal(18,4),
	FQty10 decimal(18,4),FQtyLow10 decimal(18,4),FChukuChengBen10 decimal(18,4),FHuliaoChengben10 decimal(18,4),FAmount10 decimal(18,4),
	FQty11 decimal(18,4),FQtyLow11 decimal(18,4),FChukuChengBen11 decimal(18,4),FHuliaoChengben11 decimal(18,4),FAmount11 decimal(18,4),
	FQty12 decimal(18,4),FQtyLow12 decimal(18,4),FChukuChengBen12 decimal(18,4),FHuliaoChengben12 decimal(18,4),FAmount12 decimal(18,4))

CREATE TABLE #cost_In_Sec(FItemID int,
	FQty1 decimal(18,4),FQtyLow1 decimal(18,4),FChukuChengBen1 decimal(18,4),FHuliaoChengben1 decimal(18,4),FAmount1 decimal(18,4),
	FQty2 decimal(18,4),FQtyLow2 decimal(18,4),FChukuChengBen2 decimal(18,4),FHuliaoChengben2 decimal(18,4),FAmount2 decimal(18,4),
	FQty3 decimal(18,4),FQtyLow3 decimal(18,4),FChukuChengBen3 decimal(18,4),FHuliaoChengben3 decimal(18,4),FAmount3 decimal(18,4),
	FQty4 decimal(18,4),FQtyLow4 decimal(18,4),FChukuChengBen4 decimal(18,4),FHuliaoChengben4 decimal(18,4),FAmount4 decimal(18,4),
	FQty5 decimal(18,4),FQtyLow5 decimal(18,4),FChukuChengBen5 decimal(18,4),FHuliaoChengben5 decimal(18,4),FAmount5 decimal(18,4),
	FQty6 decimal(18,4),FQtyLow6 decimal(18,4),FChukuChengBen6 decimal(18,4),FHuliaoChengben6 decimal(18,4),FAmount6 decimal(18,4),
	FQty7 decimal(18,4),FQtyLow7 decimal(18,4),FChukuChengBen7 decimal(18,4),FHuliaoChengben7 decimal(18,4),FAmount7 decimal(18,4),
	FQty8 decimal(18,4),FQtyLow8 decimal(18,4),FChukuChengBen8 decimal(18,4),FHuliaoChengben8 decimal(18,4),FAmount8 decimal(18,4),
	FQty9 decimal(18,4),FQtyLow9 decimal(18,4),FChukuChengBen9 decimal(18,4),FHuliaoChengben9 decimal(18,4),FAmount9 decimal(18,4),
	FQty10 decimal(18,4),FQtyLow10 decimal(18,4),FChukuChengBen10 decimal(18,4),FHuliaoChengben10 decimal(18,4),FAmount10 decimal(18,4),
	FQty11 decimal(18,4),FQtyLow11 decimal(18,4),FChukuChengBen11 decimal(18,4),FHuliaoChengben11 decimal(18,4),FAmount11 decimal(18,4),
	FQty12 decimal(18,4),FQtyLow12 decimal(18,4),FChukuChengBen12 decimal(18,4),FHuliaoChengben12 decimal(18,4),FAmount12 decimal(18,4))


--逐月查询明细数据
SET @FIndex=1
While(@FIndex<=@FMonth)
BEGIN
	SET @Sql='Insert Into #cost_In(FItemID,FQty'+CAST(@FIndex as varchar(2))+',FQtylOW'+CAST(@FIndex as varchar(2))+')' +
	' Select u1.FItemID,sum(CASE WHEN u1.FAuxQty>0 THEN u1.FAuxQty END),sum(CASE WHEN u1.FAuxQty<0 THEN u1.FAuxQty END) From ICStockBill v1 inner join ICStockBillEntry u1 on u1.FInterID=v1.FInterID' +
	' Where v1.FTranType=2 And v1.FCheckerID>0 And Year(v1.FDate)=' + CAST(@FYear as varchar(4)) + ' And Month(v1.FDate)=' + CAST(@FIndex as varchar(2)) +
	' Group by u1.FItemID'
	Execute(@Sql)
	SET @FIndex=@FIndex+1
END

--SELECT * FROM #LjyA

Insert Into #ljy(FItemID,FQty1,FQtyLow1,FQty2,FQtyLow2,FQty3,FQtyLow3,
	FQty4,FQtyLow4,FQty5,FQtyLow5,FQty6,FQtyLow6,
	FQty7,FQtyLow7,FQty8,FQtyLow8,FQty9,FQtyLow9,
	FQty10,FQtyLow10,FQty11,FQtyLow11,FQty12,FQtyLow12)
Select FItemID,sum(FQty1),sum(FQtyLow1),sum(FQty2),sum(FQtyLow2),sum(FQty3),sum(FQtyLow3),
sum(FQty4),sum(FQtyLow4),sum(FQty5),sum(FQtyLow5),sum(FQty6),sum(FQtyLow6),sum(FQty7),sum(FQtyLow7),
sum(FQty8),sum(FQtyLow8),sum(FQty9),sum(FQtyLow9),sum(FQty10),sum(FQtyLow10),sum(FQty11),sum(FQtyLow11),
sum(FQty12),sum(FQtyLow12) From #ljyA Group by FItemID Order by FItemID


select FItemID from ICStockBill t1
inner join ICStockBillEntry t2 ON t1.FInterID=t2.FInterID
where FTranType=2