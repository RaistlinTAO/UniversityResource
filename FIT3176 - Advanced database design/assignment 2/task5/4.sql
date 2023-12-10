SELECT id "LAPTOPNO",  
XMLQuery('for$a in /techsum
return $a/ModelNumber/text()'
PASSING laptop_doc
RETURNING CONTENT).getStringVal() "Model Number",
XMLQuery('for$a in /techsum
return $a/Hardware/Batteries/BatteryType/text()'
PASSING laptop_doc
RETURNING CONTENT).getStringVal() "Battery Type",
XMLQuery('for$a in /techsum
return $a/Hardware/Batteries/BatteryTech/text()'
PASSING laptop_doc
RETURNING CONTENT).getStringVal() "Battery Tech"
FROM laptop
WHERE NOT(XMLQuery('for$a in /techsum
return $a/Hardware/Batteries/BatteryType/text()'
PASSING laptop_doc
RETURNING CONTENT).getStringVal() = 'Lithium'
AND 
XMLQuery('for$a in /techsum
return $a/Hardware/Batteries/BatteryTech/text()'
PASSING laptop_doc
RETURNING CONTENT).getStringVal() = 'ion');
