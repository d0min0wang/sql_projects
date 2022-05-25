IF OBJECT_ID('tempdb.dbo.##temp1','U') IS NOT NULL DROP TABLE dbo.##temp1;
IF OBJECT_ID('tempdb.dbo.##temp2','U') IS NOT NULL DROP TABLE dbo.##temp2;
IF OBJECT_ID('tempdb.dbo.##temp3','U') IS NOT NULL DROP TABLE dbo.##temp3;
IF OBJECT_ID('tempdb.dbo.##temp4','U') IS NOT NULL DROP TABLE dbo.##temp4;

IF OBJECT_ID('superset_etl.dbo.t_FIN_Ingredient_Cost','U') IS NOT NULL DROP TABLE dbo.t_FIN_Ingredient_Cost;

DECLARE @sql_date NVARCHAR (1000),
	@modelsUnpivot AS NVARCHAR(MAX),   
    @modelsPivot As  NVARCHAR(MAX),
    @sql_sum NVARCHAR(MAX),
	@modelsCount AS NVARCHAR(MAX),
	@modelsUnoin AS NVARCHAR(MAX),
    @sql NVARCHAR(MAX)

SET @sql_sum=(select ',SUM('+quotename(name)+') AS '''+substring(name,2,len(name)-1)+'''' 
        from syscolumns where id=object_id('actual_data') AND PATINDEX('%[0-9]%', name)>0 for xml path(''))
				
SET @sql_date = CONVERT ( VARCHAR ( 7 ), DATEADD(month,-1, GETDATE()), 120 )

SET @sql='SELECT fModelName'+@sql_sum+' into ##temp1 FROM actual_data WHERE CONVERT ( VARCHAR ( 7 ), fDate, 120 ) = ''' + @sql_date + ''' GROUP BY fModelName'

--SELECT @sql
EXEC (@sql)

select @modelsUnpivot = stuff((select ','+quotename(substring(C.name,2,len(C.name)-1))
         from sys.columns as C
         where C.object_id = object_id('actual_data') and
               PATINDEX('%[0-9]%', C.name)>0
         for xml path('')), 1, 1, '')
--SELECT @modelsUnpivot

select @modelsPivot = STUFF((SELECT  ',' 
                      + quotename(fModelName)
                    from ##temp1 t
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')
--SELECT @modelsPivot

set @sql 
  = 'select name, '+@modelsPivot+' INTO ##temp2
      from
      (
        select fModelName, name, value
        from ##temp1
        unpivot
        (
          value for name in ('+@modelsUnpivot+')
        ) unpiv
      ) src
      pivot
      (
        sum(value)
        for fModelName in ('+@modelsPivot+')
      ) piv'

exec(@sql)

SET @sql = 'SELECT src.name, xy.FOutPrice,' + @modelsPivot + ' INTO ##temp3 FROM ##temp2 src LEFT JOIN t_xy_Raw_Material_Price xy ON src.name = REPLACE(xy.FName, ''-'', '''')'
EXEC( @sql )

SET @modelsCount = STUFF((SELECT  ',' 
                      + quotename(fModelName) + ',' + quotename(fModelName) + '*FOutPrice AS [' + fModelName + '_amount]'
                    from ##temp1 t
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')
--SELECT( @modelsCount )

SET @sql = 'SELECT name AS FName, FOutPrice,'+ @modelsCount + ' INTO ##temp4 FROM ##temp3'
EXEC( @sql )

SET @modelsUnoin = STUFF((SELECT  ',SUM(' 
                      + quotename(fModelName) + ') AS '+ quotename(fModelName) + ',SUM([' + fModelName + '_amount]) AS [' + fModelName + '_amount]'
                    from ##temp1 t
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')
--SELECT(@modelsUnoin)

SET @sql = 'SELECT * INTO t_FIN_Ingredient_Cost FROM ##temp4 UNION ' + 'SELECT ''合计'' AS FName, null AS FOutPrice,' + @modelsUnoin + 'FROM ##temp4'
EXEC(@sql)

drop table ##temp1,##temp2,##temp3,##temp4

select * from t_FIN_Ingredient_Cost
