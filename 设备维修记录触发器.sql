use AIS20140731101633

select GETDATE()

select DATEDIFF ( MINUTE , GETDATE() , DATEADD(MINUTE,15,GetDate()) )*1.0/60


select * from t_tableDescription where FDescription like '%…Ë±∏Œ¨–ﬁ%'

select DATEDIFF ( MINUTE , FStopTime , FStartTime ),
DATEDIFF ( MINUTE ,  FFixStart,FFixStop),* from ICDeviceRepairRecord

update ICDeviceRepairRecord set FStopManHour = DATEDIFF ( MINUTE , FStopTime , FStartTime )

update ICDeviceRepairRecord set FFixTime  = DATEDIFF ( MINUTE ,  FFixStart,FFixStop)