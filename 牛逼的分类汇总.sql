--> liangCKС�� ��2008-11-01
--> ���ɲ�������: #T
IF OBJECT_ID('tempdb.dbo.#T') IS NOT NULL DROP TABLE #T
CREATE TABLE #T (�ֿ����� VARCHAR(9),��Ʒ���� VARCHAR(10),��Ʒ���� VARCHAR(20),��� INT)
INSERT INTO #T
SELECT '�Ϻ��ֿ�1','07-c01-000','NOKIAŵ����2600C',122 UNION ALL
SELECT '�Ϻ��ֿ�1','07-c01-098','SonyEricsson����W380',244 UNION ALL
SELECT '���ݲֿ�1','07-c01-098','SonyEricsson����W380',355 UNION ALL
SELECT '�ɶ��ֿ�1','07-c01-026','Nokiaŵ����N72',58 UNION ALL
SELECT '���ݲֿ�1','07-c01-026','Nokiaŵ����N72',62 UNION ALL
SELECT '�ɶ��ֿ�1','07-c01-098','SonyEricsson����W380',88 UNION ALL
SELECT '�ɶ��ֿ�1','07-c01-000','NOKIAŵ����2600C',30

--SQL��ѯ����:

SELECT �ֿ�����,��Ʒ����,��Ʒ����,���
FROM
(
   SELECT �ֿ�����,��Ʒ����,��Ʒ����,���,s1=0,s2=��Ʒ����
   FROM #T
   UNION ALL
   SELECT '�ܿ��:','','',SUM(���),s1=1,s2=��Ʒ����
   FROM #T
   GROUP BY ��Ʒ����
) AS T
ORDER BY s2,s1
