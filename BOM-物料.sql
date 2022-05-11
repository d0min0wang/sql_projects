

--select * from icbom where fbomnumber='BOM010128'
--select * from icbomchild where finterid=11267
--select fgrossweight,* from t_icitem where fitemid=13711
--select * from icclasstableinfo

update t1 set t1.fgrossweight=t2.FQty From t_icitem t1 inner join icbomchild t2 on t2.Fitemid=t1.fitemid