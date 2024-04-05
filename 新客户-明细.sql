--新增客户新算法
declare @FYear AS NVARCHAR(4)
DECLARE @FLastYear as NVARCHAR(4)
DECLARE @FMonth AS int
SET @FYear='2023'
SET @FLastYear='2022'



--复购客户销售额
;WITH t AS
(SELECT
ROW_NUMBER() OVER(PARTITION BY FSupplyID ORDER bY fdate) rn,--自增长序号切分组排序了
FSupplyID,
fdate
FROM ICStockBill
where fsupplyid is not NULL and fsupplyid>0
group by FSupplyID,
fdate
),
t1
as
(
SELECT
a.FSupplyID,
a.fdate,
DATEDIFF(month,b.fdate,a.fdate) cn
FROM t a
LEFT JOIN t b on a.rn=b.rn+1 AND a.FSupplyID=b.FSupplyID
WHERE YEAR(a.fdate) in (@FLastYear,@FYear) --取当年和前一年交易的客户，因为前一年交易的客户在当年的交易额需要计算到当年
and DATEDIFF(month,b.fdate,a.fdate) >12 ----距离上次交易12个月以上的
)
SELECT * into #temp1 from  t1
select t5.FName,
    t6.fname,t4.FName,sum(t3.FConsignAmount) FROM #temp1 t1
LEFT JOIN ICStockBill t2 on t1.FSupplyID=t2.FSupplyID AND CAST(DATEDIFF(MONTH, t1.FDate, t2.FDate) AS INT)<=12 --计算交易日期在十二个月之内的
LEFT JOIN ICStockBillEntry t3 ON t2.FInterID=t3.FInterID 
left join t_Organization t4 on t1.FSupplyID=t4.FItemID
left join t_Department t5 on t4.FDepartment=t5.FItemID
LEFT JOIN t_Emp t6 ON t4.Femployee=t6.FItemID
WHERE YEAR(t2.FDate)=@FYear AND t2.FTranType=21 --去当年的交易数据
and t5.FName in ('通信事业部','新能源事业部','健康事业部')
GROUP BY t5.FName,t6.FName,t4.FName 
ORDER BY t5.FName,t6.FName 
drop table #temp1



--首次交易客户销售额
;WITH t AS
(SELECT
ROW_NUMBER() OVER(PARTITION BY FSupplyID ORDER bY fdate) rn,--自增长序号切分组排序了
FSupplyID,
fdate
FROM ICStockBill
where fsupplyid is not NULL and fsupplyid>0
group by FSupplyID,
fdate
)
select t5.FName,
    t6.fname,t4.FName,sum(t3.FConsignAmount) FROM t t1
LEFT JOIN ICStockBill t2 on t1.FSupplyID=t2.FSupplyID AND CAST(DATEDIFF(MONTH, t1.FDate, t2.FDate) AS INT)<12 --计算交易日期在十二个月之内的
LEFT JOIN ICStockBillEntry t3 ON t2.FInterID=t3.FInterID 
left join t_Organization t4 on t1.FSupplyID=t4.FItemID
left join t_Department t5 on t4.FDepartment=t5.FItemID
LEFT JOIN t_Emp t6 ON t4.Femployee=t6.FItemID
WHERE YEAR(t1.FDate) in (@FLastYear,@FYear) AND t1.rn=1 --取第一次交易在当年和前一年的客户，因为前一年的客户在当年发生的部分交易额要归入当年
and YEAR(t2.FDate)=@FYear AND t2.FTranType=21 --取当年的交易数据
--AND year(t4.f_123) in (@FLastYear,@FYear) --取新增日期在当年和前一年的客户
and t5.FName in ('通信事业部','新能源事业部','健康事业部')
GROUP BY t5.FName,t6.FName,t4.FName 
ORDER BY t5.FName ,t6.FName