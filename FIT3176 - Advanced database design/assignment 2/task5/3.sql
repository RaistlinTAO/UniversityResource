SELECT id "Laptop Number",
       Extractvalue(laptop_doc, 'techsum/Hardware/RAM') "RAM",
       CONCAT( 
       CONCAT(
       SUBSTR( Extractvalue(laptop_doc, 'techsum/Hardware/Screen/MaxScreenResolution'), 1,4 ) ,
       ' ¡Á '),
       SUBSTR( Extractvalue(laptop_doc, 'techsum/Hardware/Screen/MaxScreenResolution'), 8 ))
       "Max Screen Resolution"
FROM   laptop
WHERE  SUBSTR( Extractvalue(laptop_doc, 'techsum/Hardware/Screen/MaxScreenResolution'), 1,4 ) >= 1920
       AND 
       SUBSTR( Extractvalue(laptop_doc, 'techsum/Hardware/Screen/MaxScreenResolution'), 8 ) >= 1080; 
