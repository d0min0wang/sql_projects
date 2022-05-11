select * from  CHECKINOUT t1
left join USERINFO t2 on t1.USERID =t2.USERID 
where t2.NAME  like '%王斌%'
and
t1.CHECKTIME >='2014-05-03'
select * from  USERINFO

select *  from CHECKINOUT where USERID=913 and year(CHECKTIME) ='2015' and month(CHECKTIME )='04' and day(CHECKTIME )='06'

insert into CHECKINOUT values(908,'2017-08-05 08:10:23.000','I',2,'101',NULL,0,'2141973150114',0)
insert into CHECKINOUT values(908,'2017-08-05 12:21:23.000','I',2,'101',NULL,0,'2141973150114',0)
insert into CHECKINOUT values(908,'2017-08-05 13:19:23.000','I',2,'101',NULL,0,'2141973150114',0)
insert into CHECKINOUT values(908,'2017-08-05 17:31:23.000','I',2,'101',NULL,0,'2141973150114',0)
insert into CHECKINOUT values(908,'2017-08-11 13:25:23.000','I',2,'101',NULL,0,'2141973150114',0)

select * from CHECKINOUT where CHECKTIME >='2014-06-17'


select * from ATTDETAIL where STAFF_NO ='10015' and dates='2015-01-23'

delete from ATTMASTER where STAFF_NO ='10015' and dates='2015-01-23' and [TIME]=173300 

update ATTDETAIL set IN_DATE_MID =NULL,IN_TIME_MID =000000,OUT_DATE =NULL,OUT_TIME =000000,TOTAL_WORK =034500
where STAFF_NO ='10015' and dates='2015-01-23'



declare @p1 int
set @p1=183968579
declare @p3 int
set @p3=1
declare @p4 int
set @p4=1
declare @p5 int
set @p5=0
exec sp_cursoropen @p1 output,N'SELECT A.STAFF_NO, A.DATES, A.STATUS_CODE, A.USED_TIME, A.FROM_TIME, B.STATUS_CODE, B.STATUS_DESCENG, B.STATUS_DESCCHN, B.ALLOW_ENTER, B.PLUS_MINUS, B.TIME_UNIT FROM fangpuhrm..ATTSTATUS A, fangpuhrm..ATTPOSTSETTINGS B WHERE A.STAFF_NO = @P1 AND (A.DATES >= @P2 AND A.DATES < DATEADD (day, 1, @P3))  AND B.STATUS_CODE = A.STATUS_CODE ORDER BY A.STAFF_NO  ASC, A.DATES  ASC, A.STATUS_CODE  ASC, A.FROM_TIME  ASC',@p3 output,@p4 output,@p5 output,N'@P1 char(10),@P2 datetime,@P3 datetime','10020     ','2016-11-30 00:00:00','2016-11-30 00:00:00'
select @p1, @p3, @p4, @p5

SELECT A.STAFF_NO, 
A.DATES, 
A.STATUS_CODE, 
A.USED_TIME, 
A.FROM_TIME, 
B.STATUS_CODE, 
B.STATUS_DESCENG, 
B.STATUS_DESCCHN, 
B.ALLOW_ENTER, 
B.PLUS_MINUS, 
B.TIME_UNIT 
FROM fangpuhrm..ATTSTATUS A, fangpuhrm..ATTPOSTSETTINGS B
where a.STAFF_NO='10020'
and year(a.DATES)='2016'
and month(a.DATES)='11'

