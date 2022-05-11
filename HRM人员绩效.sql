select  t2.STAFF_NAME,t3.DEPARTMENT_DESCRIPTION,t1.* from APP_SAP_IMMS t1
left join perempms t2 on t1.STAFF_NO=t2.STAFF_NO
left join PERDEPMS t3 on t2.DEPARTMENT=t3.DEPARTMENT
where t1.PED_SEQ>=18
and t3.DEPARTMENT_DESCRIPTION='生产部'
order by t2.STAFF_NAME,t1.PED_SEQ


--SELECT * FROM [dbo].[PERDEPMS]

select  t1.STAFF_NO,sum(t1.IM_PERCENTAGE) as sumerry from APP_SAP_IMMS t1
left join perempms t2 on t1.STAFF_NO=t2.STAFF_NO
left join PERDEPMS t3 on t2.DEPARTMENT=t3.DEPARTMENT
where t1.PED_SEQ=39
--and t3.DEPARTMENT_DESCRIPTION='生产部'
group by t1.STAFF_NO
order by sumerry