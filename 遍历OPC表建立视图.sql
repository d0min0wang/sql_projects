DECLARE @machineType NVARCHAR(2)
DECLARE @machineName NVARCHAR(4)
DECLARE @machineTable NVARCHAR(50)
DECLARE @SQLStatement nvarchar(max)
DECLARE @machineNo INT
declare @machineNames table(idx int identity(1,1), machiname nvarchar(2))


SET @SQLStatement=''

insert into @machineNames (machiname)
    select 'DE' union
    select 'DF' union
    select 'DM' union
    select 'DY' union
    select 'SE' union
    select 'SF' union
    select 'SG' union
    select 'SM' union
    select 'SR' union
    select 'SY' 

declare @i int
declare @cnt int

select @i = min(idx) - 1, @cnt = max(idx) from @machineNames

while @i < @cnt
begin
    select @i = @i + 1
    set @machineType = (select machiname from @machineNames where idx = @i)
    SET @machineNo=1

    WHILE (@machineNo<=30)
    BEGIN
        SET @machineName=@machineType+ REPLICATE('0',2-len(CONVERT(NVARCHAR(2),@machineNo)))+CONVERT(NVARCHAR(2),@machineNo)
        SET @machineTable='t_'+@machineName+'ProcessParameters'
        --SELECT @machineTable
	    IF OBJECT_ID(@machineTable) IS NOT NULL
	    BEGIN
                SET @SQLStatement=@SQLStatement+'SELECT '''
	        + @machineName +''' AS fMachineName ' 
	        +',t1.[fTimestamp]'
	        +' ,t1.[fProductID]'
	        +' ,t1.[fStandardSingleWeight]'
	        +' ,t1.[fProductLenth]'
	        +' ,t1.[fMouldQuantity]'
	        +' ,t1.[fMouldOvenTemperature]'
	        +' ,t1.[fMaterialOvenTemperature]'
	        +' ,t1.[fMouldTemperature]'
	        +' ,t1.[fMouldOvenTimer]'
	        +' ,t1.[fFirstMaterialOvenTimer]'
	        +' ,t1.[fSecondMaterialObenTimer]'
	        +' ,t1.[fFirstCoolingTimer]'
	        +' ,t1.[fSecondCoolingTimer]'
	        +' ,t1.[fCoolingTimerforOverHeat]'
	        +' ,t1.[fBrushOilTimer]'
	        +' ,t1.[fDippingCylinderDropTimer]'
	        +' ,t1.[fBrushFrequency]'
	        +' ,t1.[fSoakingDistance]'
	        +' ,t1.[fDippingNumberOfStages]'
	        +' ,t1.[fDippingRate_1]'
	        +' ,t1.[fDippingDistance_1]'
	        +' ,t1.[fDippingRate_2]'
	        +' ,t1.[fDippingDistance_2]'
	        +' ,t1.[fDippingRate_3]'
	        +' ,t1.[fDippingDistance_3]'
	        +' ,t1.[fDippingRate_4]'
	        +' ,t1.[fDeferDippingTimer]'
	        +' ,t1.[fFirstDippingTimer]'
	        +' ,t1.[fSecondDippingTimer]'
	        +' ,t1.[fAscentNumberOfStages]'
	        +' ,t1.[fAscentRate_1]'
	        +' ,t1.[fAscentDistance_1]'
	        +' ,t1.[fAscentRate_2]'
	        +' ,t1.[fAscentDistance_2]'
	        +' ,t1.[fAscentRate_3]'
	        +' ,t1.[fAscentDistance_3]'
	        +' ,t1.[fAscentRate_4]'
	        +' ,t1.[fAscentDistance_4]'
	        +' ,t1.[fStartFlipDistance]'
	        +' ,t1.[fFlipRate]'
	        +' ,t1.[fResidenceTimer]'
	        +' ,t1.[fFirstFlipAngle_M1]'
	        +' ,t1.[fSecondFlipAngle_M1]'
	        +' ,t1.[fSecondFlipDistance_M1]'
	        +' ,t1.[fFirstFlipAngle_M2]'
	        +' ,t1.[fSecondFlipAngle_M2]'
	        +' ,t1.[fSecondFlipDistance_M2]'
	        +' ,t1.[fDropNumberOfStages]'
	        +' ,t1.[fDropRate_1]'
	        +' ,t1.[fDropDistance_1]'
	        +' ,t1.[fDropRate_2]'
	        +' ,t1.[fDropDistance_2]'
	        +' ,t1.[fDropRate_3]'
	        +' ,t1.[fDropDistance_3]'
	        +' ,t1.[fDropRate_4]'
	        +' ,t1.[fDropDistance_4]'
	        +' ,t1.[fDemoldingFrequency]'
	        +' ,t1.[fDemoldingAscentPosition]'
	        +' ,t1.[fDemoldingLoosePosition]'
	        +' ,t1.[fDemoldingDropRate]'
	        +' ,t1.[fDemouldingDistance]'
	        +' ,t1.[fLiquidLevelDistance]'
	        +' ,t2.fProductSpecifications'
	        +' ,t2.fProductMaterial'
            +' FROM '
	        +' [OPCDatabase].[dbo].[t_'+@machineName+'ProcessParameters] t1 '
	        +' LEFT JOIN [OPCDatabase].[dbo].[t_StandardProcessParameters] t2 ON t1.fProductID = t2.fProductID ' 
            +' UNION ALL '
        
        END
        set @machineNo=@machineNo+1
    
    END
    
END

SELECT @SQLStatement
