use AIS20130104112823
select FName,right(FName,len(FName)-1),
 * from t_Organization where FItemID in (892)--FName like '*%'

select  FName,* from t_Organization where FName like '&%'
--ɾ�����*��
update t_Organization set FName=right(FName,len(FName)-1) where FName like '@%'--FItemID in (892) 

select FName,* from t_Organization where FName like '%&'
--ɾ���ұ�#��
update t_Organization set FName=left(FName,len(FName)-1) where FName like '%&'--FItemID in (19033) 

select FName,* from t_Organization where FItemID in (19033) 
