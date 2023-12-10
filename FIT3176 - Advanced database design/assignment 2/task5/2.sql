SELECT id, 
       xmldoc.productdescription£¬ concat(xmldoc.pricecurrency ,xmldoc.price), 
       xmldoc.weight 
FROM   laptop, 
       XMLTABLE('/techsum' passing laptop.laptop_doc COLUMNS productdescription VARCHAR2(50) path 'ProductDescription',
        pricecurrency VARCHAR2(3) path 'Price/@Currency',
        price VARCHAR2(8) path 'Price',
        weightunit VARCHAR2(7) path 'ItemWeight/@Unit',
        weight FLOAT(10) path 'ItemWeight' ) xmldoc
WHERE  ( 
              xmldoc.weight > 1 
       AND    xmldoc.weightunit = 'KG') 
OR     ( 
              xmldoc.weight > 2.2 
       AND    xmldoc.weightunit = 'Pounds');