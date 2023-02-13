/*   Oracle 12c  */
CREATE TABLE laptop (
  id NUMBER GENERATED ALWAYS as IDENTITY(START with 100 INCREMENT by 1) PRIMARY KEY,
  laptop_doc XMLType)
  XMLTYPE COLUMN laptop_doc
    ELEMENT
    "laptop.xsd#techsum";