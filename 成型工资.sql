--SELECT DISTINCT i.FName AS 员工名称,i.FBillNo AS 流转卡编号 ,i.FFlowCardNo AS 流转卡号,
--i.FName1 AS 产品名称,i.FName2 AS 工序,i.FAuxWhtfinish AS 实做重量 ,i.FAuxQtyfinish AS 实做数量,j.FPrice AS 单价,
--i.FAuxWhtfinish*j.FPrice AS 工资FROM Query i
--LEFT JOIN salary j ON i.FModel=j.FProName
--exec sp_configure 'show advanced options',1
--reconfigure
--exec sp_configure 'Ad Hoc Distributed Queries',1
--reconfigure

--Exec sp_droplinkedsrvlogin DBKingdee,Null
--Exec sp_dropserver DBKingdee
go
EXEC  sp_addlinkedserver
      @server ='DBKingdee',
      @srvproduct ='',
      @provider ='SQLOLEDB',
      @datasrc ='192.168.0.101'
EXEC sp_addlinkedsrvlogin
     'DBKingdee',
     'false',
     NULL,
     'user',
     'user001'
go
DROP TABLE QueryChengxing
go
select *   INTO QueryChengxing from
openquery(DBKingdee ,
'SELECT k.FName,j.FBillNo,i.FFlowCardNo,m.FModel,m.FName AS FName1,l.FName AS FName2,n.FName AS FName3,i.FAuxQtyfinish,
     i.FAuxQtyPass,i.FAuxWhtfinish,0.75 AS FUnitPrice,i.FAuxQtyPass*0.75 AS FAmount
FROM AIS20100618152307.dbo.SHProcRpt i
LEFT JOIN AIS20100618152307.dbo.SHProcRptMain j ON i.FInterID=j.FInterID
LEFT JOIN AIS20100618152307.dbo.t_Emp k ON i.FWorkerID=k.FItemID
LEFT JOIN AIS20100618152307.dbo.t_SubMessage l ON i.FOperID=l.FInterID
LEFT JOIN AIS20100618152307.dbo.t_ICItem m ON i.FItemID=m.FItemID
LEFT JOIN AIS20100618152307.dbo.t_SubMessage n ON i.FTeamID=n.FInterID
WHERE
l.FName=''成型''
AND
CONVERT(char(6),i.FEndWorkDate,112) =CONVERT(char(6),DATEADD(month,-1,getdate()),112)')

go
SELECT DISTINCT i.FName AS 员工名称 ,
     i .FBillNo AS 流转卡编号,
     i .FFlowCardNo AS 流转卡号,
     i .FName1 AS 产品名称,
     i .FName2 AS 工序,
     i .FName3 AS 班组,
     i .FAuxWhtfinish AS 实做重量,
     i .FAuxQtyfinish AS 实做数量,
     j .Fprice* 0.9 AS 单价,
     i .FAuxQtyfinish* j.Fprice *0.9 AS 工资
FROM QueryChengxing i
LEFT JOIN chengxing j ON i .FModel= j.FProName collate Chinese_PRC_CI_AS
and i. FName3=j .FTeamID collate Chinese_PRC_CI_AS
go
Exec sp_droplinkedsrvlogin DBKingdee,Null
Exec sp_dropserver DBKingdee


--select * from chengxing
--
--insert into chengxing values (3256,'麻面炉','ECT4.2-130(1.0)',3.18)
--insert into chengxing values (3257,'麻面炉','ECT4.2-130(1.0)',3.18)
--insert into chengxing values (3258,'麻面炉','RG040002011',416.67)
--insert into chengxing values (3259,'麻面炉','RG040002012',333.33)
--insert into chengxing values (3260,'麻面炉','STφ19-229(3.0)Q',72.22)
--insert into chengxing values (3261,'麻面炉','STφ23.8-313(3.0)',55.56)
--insert into chengxing values (3262,'麻面炉','STφ24.5-195(3.0)Q',48.61)
--insert into chengxing values (3263,'麻面炉','STφ24.5-270(3.0)Q',50.93)
--insert into chengxing values (3264,'麻面炉','STφ24.5-384(3.0)Q',60.19)
--insert into chengxing values (3265,'麻面炉','STφ31.5-700(3.0)Q',211.11)
--insert into chengxing values (3266,'麻面炉','STφ31.5-720B(2.5)',193.55)
--insert into chengxing values (3267,'麻面炉','STφ31-231(3.5)Q',67.42)
--insert into chengxing values (3268,'麻面炉','TUT5-2.6-83(1.1)',3.79)

