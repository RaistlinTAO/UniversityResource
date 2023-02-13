BEGIN DBMS_XMLSCHEMA.registerSchema(
SCHEMAURL=>'laptop.xsd',
SCHEMADOC=>'<?xml version="1.0" encoding="utf-8"?>
<!-- Use UTF-8 for potential non-English characters -->
<xs:schema
    xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <!--Root-->
    <xs:element name="techsum">
        <xs:complexType>
            <xs:sequence>
                <xs:element name="BrandName" type="xs:string" />
                <xs:element name="ModelNumber" type="xs:string"/>
                <!--The Weight Unit in this case can be set as "KG", "Pound"-->
                <xs:element name="ItemWeight">
                    <xs:complexType>
                        <xs:simpleContent>
                            <!--The Weight is decimal-->
                            <xs:extension base="xs:decimal">
                                <xs:attribute name="Unit" type="xs:string"/>
                            </xs:extension>
                        </xs:simpleContent>
                    </xs:complexType>
                </xs:element>
                <!--ProductDescription can also set as token for trim -->
                <xs:element name="ProductDescription" type="xs:string"/>
                <xs:element name="URL" type="xs:string"/>
                <xs:element name="Price">
                    <xs:complexType>
                        <xs:simpleContent>
                            <xs:extension base="xs:decimal">
                                <!--Currency attribute: declare currency type like USD or AUD -->
                                <xs:attribute type="xs:string" name="Currency"/>
                            </xs:extension>
                        </xs:simpleContent>
                    </xs:complexType>
                </xs:element>
                <xs:element name="OperatingSystem" type="xs:string"/>
                <xs:element name="Hardware">
                    <xs:complexType>
                        <xs:sequence>
                            <xs:element name="Screen">
                                <xs:complexType>
                                    <xs:sequence>
                                        <!--MaxScreenResolution: Can replaced with Height and Width -->
                                        <xs:element name="MaxScreenResolution" type="xs:string"/>
                                    </xs:sequence>
                                    <!--Size attribute: screen size in inch -->
                                    <xs:attribute name="Size" type="xs:decimal"/>
                                </xs:complexType>
                            </xs:element>
                            <!--Processor: Can devide into speed and model -->
                            <xs:element name="Processor" type="xs:string"/>
                            <xs:element name="RAM">
                                <xs:complexType>
                                    <xs:simpleContent>
                                        <!--RAM Size: unsignedByte for 0-255 based on the current hardware -->
                                        <xs:extension base="xs:unsignedByte">
                                            <!--RAM Type: Something like DDR3, DDR4 or DDR3L -->
                                            <xs:attribute name="Type" type="xs:string"/>
                                        </xs:extension>
                                    </xs:simpleContent>
                                </xs:complexType>
                            </xs:element>
                            <xs:element name="HardDrive">
                                <xs:complexType>
                                    <xs:simpleContent>
                                        <!--HardDrive Size: unsignedShort for hdd size (GB) -->
                                        <xs:extension base="xs:unsignedShort">
                                            <xs:attribute name="Type" type="xs:string"/>
                                        </xs:extension>
                                    </xs:simpleContent>
                                </xs:complexType>
                            </xs:element>
                            <xs:element name="WirelessType">
                                <xs:complexType>
                                    <xs:sequence minOccurs="1" maxOccurs="unbounded">
                                        <xs:element name="WirelessStandrad" type="xs:string"/>
                                    </xs:sequence>
                                </xs:complexType>
                            </xs:element>
                            <!--USB30Ports: unsignedByte for number of USB3.0 ports -->
                            <xs:element name="USB30Ports" type="xs:unsignedByte"/>
                            <xs:element name="Batteries">
                                <xs:complexType>
                                    <xs:sequence>
                                        <xs:element name="BatteryType" type="xs:string"/>
                                        <xs:element name="BatteryTech" type="xs:string"/>
                                    </xs:sequence>
                                    <!--averageBatteryLife: Hours -->
                                    <xs:attribute name="averageBatteryLife" type="xs:decimal"/>
                                </xs:complexType>
                            </xs:element>
                        </xs:sequence>
                    </xs:complexType>
                </xs:element>
            </xs:sequence>
            <!--loptopno attribute: Loptop No which is required -->
            <xs:attribute name="loptopno" type="xs:unsignedInt" use="required"/>
        </xs:complexType>
    </xs:element>
</xs:schema>',
LOCAL=>TRUE, GENTYPES=>FALSE, GENTABLES=>FALSE, FORCE => FALSE, options => DBMS_XMLSCHEMA.REGISTER_BINARYXML);
END;