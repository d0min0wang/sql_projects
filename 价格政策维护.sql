select * from t_Emp
update t_Emp set FDepartmentID=38755
where FName='吴培祥'

select * from t_TableDescription where FDescription like '%物料%'



declare @decbits int

set @decbits=6

--select t2.FName,t3.FName,t1.FPrice,cast(round((t1.FPrice/1.16)*1.13,@decbits) as decimal(28, 10)), t1.* 
update t1 set t1.FPrice=cast(round((t1.FPrice/1.16)*1.13,@decbits) as decimal(28, 10))
 from ICPrcPlyEntry t1
left join t_Organization t2 on t1.FRelatedID=t2.FItemID
left join t_ICItem t3 on t1.FItemID=t3.FItemID
where t2.FName in (
'/上海源磊电子有限公司#',
'威海泓淋电子有限公司#(AC事业部)',
'威海市泓淋电力技术股份有限公司#(线缆事业部)',
'常州格力博有限公司',
'苏州益而益电线电缆有限公司#',
'杭州东赫电子有限公司#',
'江苏镇江东方电热科技股份有限公司#',
'无锡其诺电气有限公司#',
'杭州华虹电子科技设备有限公司#',
'贸联电子（常州）有限公司#',
'常州市美华电器有限公司#',
'乐清市宇凯线缆有限公司#',
'杭州达峰接插件有限公司#',
'扬州华声实业电子有限公司',
'江苏苏州根茂电子有限公司'
)



SELECT * INTO ICPrcPlyEntry20190510 FROM ICPrcPlyEntry


select * from t_ICItemCustom                                                                  

decimal(28, 10)

select t2.FName,t3.FName,t1.FPrice,cast(round(t1.FPrice,1) as decimal(28, 10)), t1.* 
--update t1 set t1.FPrice=cast(round(t1.FPrice,1) as decimal(28, 10))
 from ICPrcPlyEntry t1
left join t_Organization t2 on t1.FRelatedID=t2.FItemID
left join t_ICItem t3 on t1.FItemID=t3.FItemID
where t2.FName like '顺德区格兰仕电子元件有限公司'


--更新物料表
select t3.FFullNumber, t0.FTaxRate,t0.* 
--update t0 set t0.FTaxRate=16
from t_ICItemMaterial t0
left join t_ICItemCore t1 on t0.FItemID=t1.FItemID
left join t_Item t2 on t1.FParentID=t2.FItemID
left join t_Item t3 on t2.FParentID=t3.FItemID
left join t_Item t4 on t3.FParentID=t4.FItemID
where t3.FFullNumber in ('10','11','12','20','25','30','40','50','53','55','60','70','80','81','83','93','A','B')

select * from dbo.t_ICItemMaterial
select * from dbo.t_ICItemCore


SELECT * FROM t_Organization