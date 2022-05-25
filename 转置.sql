IF OBJECT_ID('tempdb.dbo.##temp1','U') IS NOT NULL DROP TABLE dbo.##temp1;

DECLARE @modelsUnpivot AS NVARCHAR(MAX),   
    @modelsPivot as  NVARCHAR(MAX),
    @sql_sum NVARCHAR(MAX),
    @sql NVARCHAR(MAX)

SET @sql_sum=(select ',SUM('+quotename(name)+') AS '''+substring(name,2,len(name)-1)+'''' 
        from syscolumns where id=object_id('actual_data') AND PATINDEX('%[0-9]%', name)>0 for xml path(''))

SET @sql='SELECT fModelName'+@sql_sum+' into ##temp1 FROM actual_data GROUP BY fModelName'

SELECT @sql
EXEC (@sql)

select @modelsUnpivot = stuff((select ','+quotename(substring(C.name,2,len(C.name)-1))
         from sys.columns as C
         where C.object_id = object_id('actual_data') and
               PATINDEX('%[0-9]%', C.name)>0
         for xml path('')), 1, 1, '')
SELECT @modelsUnpivot

select @modelsPivot = STUFF((SELECT  ',' 
                      + quotename(fModelName)
                    from ##temp1 t
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

SELECT @modelsPivot
set @sql 
  = 'select name, '+@modelsPivot+'
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
drop table ##temp1

