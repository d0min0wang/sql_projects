create table t_Emp(FInterID int,Fdept int,FName nvarchar(255))
create table t_SEOrder(FInterID int,FBillNo nvarchar(10),FEmp int,FItemID int,FPrice decimal(10,2),FAuxQty decimal(10,2),FAmount decimal(10,2))
create table t_Department(FInterID int,FName nvarchar(255))

insert into t_Emp values (10001,85,'janet')
insert into t_Emp values (10004,84,'creo')
insert into t_Emp values (10002,84,'bruce')
insert into t_Emp values (10003,86,'jacky')

insert into t_SEOrder values (1001,'CIN189001',10003,1001,10.5,10,105)
insert into t_SEOrder values (1002,'CIN189002',10001,1003,25,10,105)
insert into t_SEOrder values (1003,'CIN189003',10001,1002,21,10,105)
insert into t_SEOrder values (1004,'CIN189004',10004,1002,22,10,105)
insert into t_SEOrder values (1005,'CIN189005',10001,1001,99,10,105)
insert into t_SEOrder values (1006,'CIN189006',10002,1001,10,11,105)
insert into t_SEOrder values (1007,'CIN189007',10002,1003,5,10,105)
insert into t_SEOrder values (1004,'CIN189004',10005,1002,22,10,105)

insert into t_Department values (84,'销售一部')
insert into t_Department values (85,'销售二部')
insert into t_Department values (86,'销售三部')

select t3.FName AS 部门,
	t2.FName AS 员工,
	t1.FBillNo AS 单据编号,
	t1.FItemID AS 产品,
	t1.FPrice AS 产品单价,
	t1.FAuxQty AS 产品数量,
	t1.FAmount AS 销售金额 
from t_SEOrder t1
left join t_Emp t2 on t1.FEmp=t2.FInterID
left join t_Department t3 on t2.Fdept=t3.FInterID
where t2.FName IS NOT NULL

===============================================
select FDeptName,
	FEmpName,
	FBillNo,
	FItemID,
	FPrice,
	FAuxQty,
	FAmount
from
(select t3.FName AS FDeptName,
	t2.FName AS FEmpName,
	t1.FBillNo AS FBillNo,
	t1.FItemID AS FItemID,
	t1.FPrice AS FPrice,
	t1.FAuxQty AS FAuxQty,
	t1.FAmount AS FAmount,
	s0=0 
from t_SEOrder t1
left join t_Emp t2 on t1.FEmp=t2.FInterID
left join t_Department t3 on t2.Fdept=t3.FInterID
union all
select t3.FName,
	'',
	'',
	'',
	0,
	0,
	sum(t1.FAmount),
	s0=1 
from t_SEOrder t1
left join t_Emp t2 on t1.FEmp=t2.FInterID
left join t_Department t3 on t2.Fdept=t3.FInterID
group by t3.FName)tt1
order by FDeptName,s0


truncate table t_SEOrder
