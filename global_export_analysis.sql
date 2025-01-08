USE global_exports;
with globalexportanalysis as(
SELECT 
  FT.`HSCode`,
 FT. `Commodity Code`,
 `dim-commodity`.`Commodity`,
  FT.`Supplier Code` ,
`dim-supplier`.`supplier Description`,
  FT.`Region Code` ,
  `dim-region`.`REGION DESCRIPTION`,
  FT.`Country Code`,
  `dim-country`.`COUNTRY DESCRIPTION`,
  FT.`Exported To Code`,
  `dim-exported to`.`EXPORTED TO DESCRIPTION`,
  FT.`Year`,
  FT.`Exported Month`,
  `dim-calendar`.`quarter`,
  `dim-calendar`.`Short month`,
  `dim-calendar`.`Year-Month`,
  `dim-calendar`.`Year-Quarter`,
  FT.`Export Mode`,
  `dim-transportation`.`Export mode description`,
  FT.`Material Type Code`,
  `dim-material type`.`Material Type`,
  FT.`Unit of Measure (UoM)`,
  FT.`From Currency`,
  FT.`To Currency`,
  `dim-exchange rate`.`Exchange Rate`,
 round(FT.`Price`,2) as Price,
  FT.`Quantity`,
  FT.`Freight Charges In %`,
  round(FT.`Price`,2)*(FT.`Quantity`) as `total sales`,
  ((FT.`Price`)*(FT.`Quantity`)*(FT.`Freight Charges In %`)/100) as `freight charges`,
  
  CASE
  WHEN  FT.`Quantity` BETWEEN 1 AND 25 THEN 0.005
  WHEN  FT.`Quantity` BETWEEN 26 AND 50 THEN 0.01
  WHEN  FT.`Quantity` BETWEEN 50 AND 100 THEN 0.015
 WHEN  FT.`Quantity` BETWEEN 101 AND 200 THEN 0.02
 WHEN  FT.`Quantity`> 200 THEN 0.025
 ELSE 0
 END AS `Duty Charges`,
 
-- round(FT.`Price`,2)*(FT.`Quantity`) - 
  
  CASE
  WHEN `dim-country`.`Country code` in ('NM','MA','nm') THEN 'EAST AFRICA'
  ELSE `dim-region`.`REGION description`
  END AS Region_new,
  
   CASE
  WHEN `dim-country`.`Country code` ='nm' THEN 'NAMIBIA'
  ELSE `dim-country`.`Country code`
  END AS Country_new,
  
  CASE
  WHEN `dim-material type`.`MATERIAL TYPE`='NA' THEN 'UNDER PROCESSING'
  ELSE `dim-material type`.`MATERIAL TYPE`
  END AS `Material Type New`
  
FROM `exp-fct-exports analysis (2)` AS FT

LEFT OUTER JOIN `dim-commodity` ON 
FT.`Commodity Code`= `dim-commodity`.`Commodity Code`

LEFT OUTER JOIN `dim-state` ON
FT.`State Code`=`dim-state`.`State Code`

LEFT OUTER JOIN `dim-supplier` ON
FT.`Supplier Code`=`dim-supplier`.`Supplier Code`

LEFT OUTER JOIN `dim-region` ON
FT.`Region Code`=`dim-region`.`Region Code`

LEFT OUTER JOIN `dim-country` ON
FT.`Country Code`=`dim-country`.`Country Code`

LEFT OUTER JOIN `dim-exported to` ON
FT.`Exported To Code`=`dim-exported to`.`Exported To Code`

LEFT OUTER JOIN `dim-calendar` ON
FT.`Exported Month`=`dim-calendar`.`Exported Month`

LEFT OUTER JOIN `dim-transportation` ON
FT.`Export Mode`=`dim-transportation`.`Export Mode`

LEFT OUTER JOIN `dim-material type` ON
FT.`Material Type Code`=`dim-material type`.`Material Code`

LEFT OUTER JOIN `dim-exchange rate` ON
FT.`From Currency`=`dim-exchange rate`.`From Currency`

where `dim-commodity`.`commodity` not in ('iron and steel','gold')
)
select distinct gea.*,
Round(gea.`total sales`+gea.`freight charges`+gea.`duty charges`,2) as `total cost to company`,
Round(gea.`total sales`-gea.`freight charges`-gea.`duty charges`,2) as `net sales`
from globalexportanalysis gea;



