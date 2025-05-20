--原材料成本
SELECT * FROM t_xy_Raw_Material_Price
--出库成本
SELECT * FROM t_FIN_Ingredient_Cost
--运费成本
SELECT * FROM t_FIN_Shipping_Fee
--利息成本
SELECT * FROM t_FIN_Material_Inventory_Interest
--糊料成本
SELECT * FROM t_FIN_Paste_Unit_Price WHERE FDate='2024-09'


CREATE TABLE [dbo].[t_FIN_Raw_Material_Price](
	      [FNumber] [varchar](255) NULL,
	      [FName] [varchar](255) NULL,
	      [FBegQty] [decimal](38, 10) NULL,
	      [FInQty] [decimal](38, 10) NULL,
         [FOutQty] [decimal](38, 10) NULL,
         [FOutPrice] [decimal](38, 10) NULL,
         [FOutCost] [decimal](38, 10) NULL,
         [FEndQty] [decimal](38, 10) NULL,
         [FRemainPrice] [decimal](38, 10) NULL,
         [FRemainCost] [decimal](38, 10) NULL
      ) ON [PRIMARY]