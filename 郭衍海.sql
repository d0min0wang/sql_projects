DECLARE @StartPeriod char(10)
DECLARE @EndPeriod char(10)
SET @StartPeriod='2010-03-09' --统计的年月
SET @EndPeriod='2010-03-09' --统计的年月
	SELECT
		CASE WHEN GROUPING(FEmpName)=1 THEN 
			'员工合计' ELSE (FEmpName) END, 
		CASE WHEN GROUPING(FEmpName)=1 THEN ''
			WHEN GROUPING(FDate)=1 THEN 
				'日期合计' ELSE (FDate) END, 
		CASE WHEN GROUPING(FEmpName)=1 THEN ''
			WHEN GROUPING(FDate)=1 THEN ''
				WHEN GROUPING(FModelName)=1 THEN
					'产品合计' ELSE (FModelName) END, 
		COALESCE(SUM(FProdWht),0) FProdWht,
		COALESCE(AVG(FSingle),0) FSingle,
		COALESCE(SUM(FScrapforItem),0) FScrapforItem,
		COALESCE(SUM(FScrapforWork),0) FScrapforWork
	FROM(
		SELECT 
			FTeamTime=n.FClass,
			FDevice=o.FName,
			FEmpName=m.FName,
			FDate=CONVERT(char(10),i.FStartWorkDate,23),
			FModelName=k.FName,
			FProdWht=i.FAuxWhtPass,
			FSingle=i.FAuxWhtSingle,
			FScrapforItem=i.FAuxWhtForItem,
			FScrapforWork=i.FAuxWhtScrap
		FROM SHProcRpt i
		LEFT JOIN t_ICItem k ON i.FItemID=k.FItemID
		LEFT JOIN t_SubMessage l ON i.FOperID=l.FInterID 
		LEFT JOIN t_Emp m ON i.FWorkerID=m.FItemID
		LEFT JOIN t_ICTeamTimeEntry n ON i.FTeamTimeID=n.FEntryID 
		LEFT JOIN vw_Device_Resource o ON i.FDeviceID=o.FInterID 
		WHERE l.FName='成型'
			AND CONVERT(char(10),i.FStartWorkDate,23) BETWEEN @StartPeriod AND @EndPeriod
	)a
	GROUP BY FEmpName,FDate,FModelName 
	WITH ROLLUP
--ORDER BY FDate

--SELECT * FROM t_ICItem
--SELECT * FROM vw_Device_Device                                                                
 --1460072
 --select * from t_TableDescription where ftableid=1460072
--select * from t_tableDescription where fdescription like '%设备%'
--select * from vw_Device_Resource                                                                                                                                                                                                                                                                

--SELECT CONVERT(varchar(100), GETDATE(), 23)



