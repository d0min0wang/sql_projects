--select cast( floor(rand()*19) as int )+20
--Select CONVERT(varchar(100), GETDATE(), 23) +' 13:'+ convert(varchar(2),(cast( floor(rand()*19) as int )+20))+':00.000'


--insert into CHECKINOUT values(908,'2018-05-21 13:32:23.000','I',2,'101',NULL,0,'2141973150114',0)

--''+ CONVERT(varchar(100), GETDATE(), 23) + ' '+ 

--select * from CHECKINOUT where USERID=908 and year(checktime)='2018' and MONTH(CHECKTIME)='06'
 
--select * from CHECKINOUT where USERID=908 and CONVERT(varchar(7), CHECKTIME, 23)='2018-06'

--delete  from CHECKINOUT where CHECKTIME='2018-06-04 13:24:00.000'

declare @day int
declare @month varchar(2)
declare @date varchar(10)

set @month='06'
set @day=1

--while @day<=31
--begin
--	if exists(select 1 from CHECKINOUT where USERID=908 and datepart(year,checktime)='2018' and datepart(MONTH,CHECKTIME)=@month and datepart(DAY,CHECKTIME)=@day)
--	begin
--		select @date=(select distinct(CONVERT(varchar(10), CHECKTIME, 23)) from CHECKINOUT where USERID=908 and datepart(year,checktime)='2018' and datepart(MONTH,CHECKTIME)=@month and datepart(DAY,CHECKTIME)=@day)
--		select @date	
--	end
--	set @day=@day+1
--end
--Select convert(datetime,'2018-'+ @month +'-'+ cast(@day as varchar(2)) +' 12:'+ convert(varchar(2),(cast( floor(rand()*29) as int )))+':00.000')

while @day<=31
begin
	if exists(select 1 from CHECKINOUT where USERID=908 and datepart(year,checktime)='2018' and datepart(MONTH,CHECKTIME)=@month and datepart(DAY,CHECKTIME)=@day)
	begin
		--插入中午下班
		if not exists(select 1 from CHECKINOUT where USERID=908 and datepart(year,checktime)='2018' and datepart(MONTH,CHECKTIME)=@month and datepart(DAY,CHECKTIME)=@day and DATEPART(HOUR,CHECKTIME)='12')
		begin
			insert into CHECKINOUT values(908,convert(datetime,'2018-'+ @month +'-'+ cast(@day as varchar(2)) +' 12:'+ convert(varchar(2),(cast( floor(rand()*29) as int )))+':00.000'),'I',2,'102',NULL,0,'2141973150114',0)
		end
		--插入下午上班
		if not exists(select 1 from CHECKINOUT where USERID=908 and datepart(year,checktime)='2018' and datepart(MONTH,CHECKTIME)=@month and datepart(DAY,CHECKTIME)=@day and DATEPART(HOUR,CHECKTIME)='13')
		begin
			insert into CHECKINOUT values(908,convert(datetime,'2018-'+ @month +'-'+ cast(@day as varchar(2)) +' 13:'+ convert(varchar(2),(cast( floor(rand()*19) as int )+20))+':00.000'),'I',2,'102',NULL,0,'2141973150114',0)
		end
	end
	set @day=@day+1
end

--select * from CHECKINOUT where USERID=908 and datepart(year,checktime)='2018' and datepart(MONTH,CHECKTIME)='06' and datepart(DAY,CHECKTIME)='06' and DATEPART(HOUR,CHECKTIME)=17