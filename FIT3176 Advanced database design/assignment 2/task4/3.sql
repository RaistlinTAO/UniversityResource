INSERT INTO laptop (LAPTOP_DOC)
VALUES(XMLType(
'<?xml version="1.0" encoding="utf-8"?>
<techsum loptopno="100">
    <BrandName>Google</BrandName>
    <ModelNumber>GA00122-US</ModelNumber>
    <ItemWeight Unit="Pounds">1.09</ItemWeight>
    <ProductDescription>Google Pixelbook</ProductDescription>
    <URL>https://goo.gl/CDfecY</URL>
    <Price Currency="AUD">1325.70</Price>
    <OperatingSystem>Chrome</OperatingSystem>
    <Hardware>
        <Screen Size="12.3">
            <MaxScreenResolution>2400 * 1600</MaxScreenResolution>
        </Screen>
        <Processor>3.3 GHz</Processor>
        <RAM Type="">8</RAM>
        <HardDrive Type="SSD">64</HardDrive>
        <WirelessType>
            <WirelessStandrad>802.11b</WirelessStandrad>
            <WirelessStandrad>802.11g</WirelessStandrad>
            <WirelessStandrad>802.11n</WirelessStandrad>
        </WirelessType>
        <USB30Ports>2</USB30Ports>
        <Batteries averageBatteryLife="0">
            <BatteryType>Lithium</BatteryType>
            <BatteryTech>ion</BatteryTech>
        </Batteries>
    </Hardware>
</techsum>').CreateSchemaBasedXML('laptop.xsd'));
INSERT INTO laptop (LAPTOP_DOC)
VALUES(XMLType(
'<?xml version="1.0" encoding="utf-8"?>
<techsum loptopno = "101">
    <BrandName>Asus</BrandName>
    <ModelNumber>C202SA-YS02</ModelNumber>
    <ItemWeight Unit="KG">0.99</ItemWeight>
    <ProductDescription>ASUS Chromebook C202SA-YS02 11.6" Ruggedized and Water Resistant Design with 180 Degree</ProductDescription>
    <URL>https://goo.gl/3WUfN9</URL>
    <Price Currency="USD">209.00</Price>
    <OperatingSystem>Chrome</OperatingSystem>
    <Hardware>
        <Screen Size="11.6">
            <MaxScreenResolution>1366 * 768</MaxScreenResolution>
        </Screen>
        <Processor>1.6 GHz Intel Celeron</Processor>
        <RAM Type="DDR3L">4</RAM>
        <HardDrive Type="emmc">16</HardDrive>
        <WirelessType>
            <WirelessStandrad>802.11ac</WirelessStandrad>
        </WirelessType>
        <USB30Ports>2</USB30Ports>
        <Batteries averageBatteryLife="10">
            <BatteryType>Lithium</BatteryType>
            <BatteryTech>Polymer</BatteryTech>
        </Batteries>
    </Hardware>
</techsum>').CreateSchemaBasedXML('laptop.xsd'));
INSERT INTO laptop (LAPTOP_DOC)
VALUES(XMLType(
'<?xml version="1.0" encoding="utf-8"?>
<techsum loptopno = "102">
    <BrandName>Apple</BrandName>
    <ModelNumber>MPTT2LL/A</ModelNumber>
    <ItemWeight Unit = "KG">2.90</ItemWeight>
    <ProductDescription>Apple 15" MacBook Pro(Newest Version)</ProductDescription>
    <URL>https://goo.gl/zXD6nr</URL>
    <Price Currency = "USD">2549.00</Price>
    <OperatingSystem>MacOS Sierra</OperatingSystem>
    <Hardware>
        <Screen Size = "15">
            <MaxScreenResolution>2880 * 1800</MaxScreenResolution>
        </Screen>
        <Processor>2.9 GHz Intel Core i7</Processor>
        <RAM Type = "DDR3 SDRAM">16</RAM>
        <HardDrive Type = "SSD">512</HardDrive>
        <WirelessType>
            <WirelessStandrad>802.11b</WirelessStandrad>
            <WirelessStandrad>802.11g</WirelessStandrad>
            <WirelessStandrad>802.11n</WirelessStandrad>
        </WirelessType>
        <USB30Ports>2</USB30Ports>
        <Batteries averageBatteryLife = "10">
            <BatteryType>Lithium</BatteryType>
            <BatteryTech>Metal</BatteryTech>
        </Batteries>
    </Hardware>
</techsum>').CreateSchemaBasedXML('laptop.xsd'));
INSERT INTO laptop (LAPTOP_DOC)
VALUES(XMLType(
'<?xml version="1.0" encoding="utf-8"?>
<techsum loptopno = "103">
    <BrandName>Microsoft</BrandName>
    <ModelNumber>D9P-00020</ModelNumber>
    <ItemWeight Unit = "KG">1.25</ItemWeight>
    <ProductDescription>Go beyond the traditional laptop with Surface Laptop. Backed by the best of Microsoft, including Windows and Office. Enjoy a natural typing experience enhanced by our Signature Alcantara fabric-covered keyboard. Thin, light, and powerful, it fits easily in your bag.</ProductDescription>
    <URL>https://goo.gl/zXD6nr</URL>
    <Price Currency = "AUD">1272.00</Price>
    <OperatingSystem>Windows 10 S</OperatingSystem>
    <Hardware>
        <Screen Size = "13.5">
            <MaxScreenResolution>2256 * 1504</MaxScreenResolution>
        </Screen>
        <Processor>i5-7200U</Processor>
        <RAM Type = "DDR3 SDRAM">4</RAM>
        <HardDrive Type = "SSD">256</HardDrive>
        <WirelessType>
            <WirelessStandrad>802.11ac</WirelessStandrad>
            <WirelessStandrad>802.11a</WirelessStandrad>
            <WirelessStandrad>802.11b</WirelessStandrad>
            <WirelessStandrad>802.11g</WirelessStandrad>
            <WirelessStandrad>802.11n</WirelessStandrad>
        </WirelessType>
        <USB30Ports>1</USB30Ports>
        <Batteries averageBatteryLife = "8.5">
            <BatteryType>Lithium</BatteryType>
            <BatteryTech>Metal</BatteryTech>
        </Batteries>
    </Hardware>
</techsum>').CreateSchemaBasedXML('laptop.xsd'));
INSERT INTO laptop (LAPTOP_DOC)
VALUES(XMLType(
'<?xml version="1.0" encoding="utf-8"?>
<techsum loptopno = "104">
    <BrandName>MSI</BrandName>
    <ModelNumber>4122904</ModelNumber>
    <ItemWeight Unit = "KG">1.90</ItemWeight>
    <ProductDescription>MSI GS73 Stealth 8RF-009AU 17.3" 120Hz Gaming Laptop</ProductDescription>
    <URL>https://goo.gl/zXD6nr</URL>
    <Price Currency = "AUD">3699.00</Price>
    <OperatingSystem>Windows 10 Home Ultra</OperatingSystem>
    <Hardware>
        <Screen Size = "17.3">
            <MaxScreenResolution>1920 * 1080</MaxScreenResolution>
        </Screen>
        <Processor> i7 Processor 8750H</Processor>
        <RAM Type = "DDR4">16</RAM>
        <HardDrive Type = "SSD">256</HardDrive>
        <WirelessType>
            <WirelessStandrad>802.11b</WirelessStandrad>
            <WirelessStandrad>802.11g</WirelessStandrad>
            <WirelessStandrad>802.11n</WirelessStandrad>
        </WirelessType>
        <USB30Ports>3</USB30Ports>
        <Batteries averageBatteryLife = "7.5">
            <BatteryType>Lithium</BatteryType>
            <BatteryTech>Metal</BatteryTech>
        </Batteries>
    </Hardware>
</techsum>').CreateSchemaBasedXML('laptop.xsd'));