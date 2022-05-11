DECLARE @sql NVARCHAR(2000)
DECLARE @machine NVARCHAR(10)

SET @machine='SF40'
--建报警表
SET @sql='CREATE TABLE t_'+@machine+'AlarmLogger'+
    '([fNumericID] [int] NULL,[fValue] [int] NULL,[fQuality] [int] NULL,[fTimestamp] [datetime] NULL,[fName] [nvarchar](255) NULL)' 
--Execute(@Sql)

--建工艺参数表
SET @sql='CREATE TABLE t_'+@machine+'ProcessParameters('+
    '	[fNumericID] [int] NULL,'+
    '	[fValue] [int] NULL,'+
    '	[fQuality] [int] NULL,'+
    '	[fTimestamp] [datetime] NULL,'+
    '	[fProductID] [bigint] NULL,'+
    '	[fStandardSingleWeight] [decimal](18, 3) NULL,'+
    '	[fProductLenth] [decimal](18, 3) NULL,'+
    '	[fMouldQuantity] [int] NULL,'+
    '	[fMouldOvenTemperature] [decimal](18, 3) NULL,'+
    '	[fMaterialOvenTemperature] [decimal](18, 3) NULL,'+
    '	[fMouldTemperature] [decimal](18, 3) NULL,'+
    '	[fMouldOvenTimer] [int] NULL,'+
    '	[fFirstMaterialOvenTimer] [int] NULL,'+
    '	[fSecondMaterialObenTimer] [int] NULL,'+
    '	[fFirstCoolingTimer] [int] NULL,'+
    '	[fSecondCoolingTimer] [int] NULL,'+
    '	[fCoolingTimerforOverHeat] [int] NULL,'+
    '	[fBrushOilTimer] [int] NULL,'+
    '	[fDippingCylinderDropTimer] [int] NULL,'+
    '	[fBrushFrequency] [int] NULL,'+
    '	[fSoakingDistance] [decimal](18, 3) NULL,'+
    '	[fDippingNumberOfStages] [int] NULL,'+
    '	[fDippingRate_1] [decimal](18, 3) NULL,'+
    '	[fDippingDistance_1] [decimal](18, 3) NULL,'+
    '	[fDippingRate_2] [decimal](18, 3) NULL,'+
    '	[fDippingDistance_2] [decimal](18, 3) NULL,'+
    '	[fDippingRate_3] [decimal](18, 3) NULL,'+
    '	[fDippingDistance_3] [decimal](18, 3) NULL,'+
    '	[fDippingRate_4] [decimal](18, 3) NULL,'+
    '	[fDeferDippingTimer] [int] NULL,'+
    '	[fFirstDippingTimer] [int] NULL,'+
    '	[fSecondDippingTimer] [int] NULL,'+
    '	[fAscentNumberOfStages] [int] NULL,'+
    '	[fAscentRate_1] [decimal](18, 3) NULL,'+
    '	[fAscentDistance_1] [decimal](18, 3) NULL,'+
    '	[fAscentRate_2] [decimal](18, 3) NULL,'+
    '	[fAscentDistance_2] [decimal](18, 3) NULL,'+
    '	[fAscentRate_3] [decimal](18, 3) NULL,'+
    '	[fAscentDistance_3] [decimal](18, 3) NULL,'+
    '	[fAscentRate_4] [decimal](18, 3) NULL,'+
    '	[fAscentDistance_4] [decimal](18, 3) NULL,'+
    '	[fStartFlipDistance] [decimal](18, 3) NULL,'+
    '	[fFlipRate] [decimal](18, 3) NULL,'+
    '	[fResidenceTimer] [int] NULL,'+
    '	[fFirstFlipAngle_M1] [decimal](18, 3) NULL,'+
    '	[fSecondFlipAngle_M1] [decimal](18, 3) NULL,'+
    '	[fSecondFlipDistance_M1] [decimal](18, 3) NULL,'+
    '	[fFirstFlipAngle_M2] [decimal](18, 3) NULL,'+
    '	[fSecondFlipAngle_M2] [decimal](18, 3) NULL,'+
    '	[fSecondFlipDistance_M2] [decimal](18, 3) NULL,'+
    '	[fDropNumberOfStages] [int] NULL,'+
    '	[fDropRate_1] [decimal](18, 3) NULL,'+
    '	[fDropDistance_1] [decimal](18, 3) NULL,'+
    '	[fDropRate_2] [decimal](18, 3) NULL,'+
    '	[fDropDistance_2] [decimal](18, 3) NULL,'+
    '	[fDropRate_3] [decimal](18, 3) NULL,'+
    '	[fDropDistance_3] [decimal](18, 3) NULL,'+
    '	[fDropRate_4] [decimal](18, 3) NULL,'+
    '	[fDropDistance_4] [decimal](18, 3) NULL,'+
    '	[fDemoldingFrequency] [int] NULL,'+
    '	[fDemoldingAscentPosition] [decimal](18, 3) NULL,'+
    '	[fDemoldingLoosePosition] [decimal](18, 3) NULL,'+
    '	[fDemoldingDropRate] [decimal](18, 3) NULL,'+
    '	[fDemouldingDistance] [decimal](18, 3) NULL,'+
    '	[fLiquidLevelDistance] [decimal](18, 3) NULL)'
--EXECUTE(@sql)

--建实时表
SET @sql='CREATE TABLE t_'+@machine+'RealTimeDataLogger('+
    '	[fNumericID] [int] NULL,'+
    '	[fPowerOnState] [int] NULL,'+
    '	[fQuality] [int] NULL,'+
    '	[fTimestamp] [datetime] NULL,'+
    '	[fFurnaceState] [int] NULL,'+
    '	[fLiterState] [int] NULL,'+
    '	[fDemouldingState] [int] NULL,'+
    '	[fAlarmState] [int] NULL,'+
    '	[fProductID] [bigint] NULL,'+
    '	[fICMONo] [bigint] NULL,'+
    '	[fStaffNo] [bigint] NULL,'+
    '	[fStandardOut] [int] NULL,'+
    '	[fActualOut] [decimal](18, 3) NULL,'+
    '	[fEfficiency] [decimal](18, 6) NULL)'
--EXECUTE(@sql)

SELECT @sql
