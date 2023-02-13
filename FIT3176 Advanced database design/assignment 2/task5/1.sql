SELECT id                                                  "Laptop Number",
       Extractvalue(laptop_doc, 'techsum/ModelNumber')     "Model Number",
       Extractvalue(laptop_doc, 'techsum/OperatingSystem') "Operating System",
       Extractvalue(laptop_doc, 'techsum/Hardware/Batteries/@averageBatteryLife'
       )
       "Average Battery Life"
FROM   laptop
WHERE  Extractvalue(laptop_doc, 'techsum/Hardware/Batteries/@averageBatteryLife'
       ) != 0; 