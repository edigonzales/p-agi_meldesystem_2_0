<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:myns="ch.so.agi" xmlns:eCH-0132="http://www.ech.ch/xmlns/eCH-0132/3" xmlns:eCH-0129="http://www.ech.ch/xmlns/eCH-0129/6"  exclude-result-prefixes="myns eCH-0132 eCH-0129" version="3.0"> 
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:key name="myns:lookup-eventType" match="myns:data" use="@key" />

    <xsl:variable name="myns:eventType-lookup">
        <myns:data key="3" value="Neubau" />
        <myns:data key="4" value="Anbau" />
        <myns:data key="5" value="Umbau" />
        <myns:data key="6" value="Teilabbruch" />
        <myns:data key="16" value="Trennung" />
        <myns:data key="17" value="Vereinigung" />
        <myns:data key="18" value="Entlassung" />
        <myns:data key="19" value="Loeschung.Abbruch" />
        <myns:data key="20" value="Loeschung.Vereinigung" />
        <myns:data key="21" value="Loeschung.Schaden" />
        <myns:data key="26" value="Neuaufnahme" />
    </xsl:variable>



    <xsl:template match="/eCH-0132:delivery">
        <TRANSFER xmlns="http://www.interlis.ch/INTERLIS2.3">
        <HEADERSECTION SENDER="eCH0132_to_xtf" VERSION="2.3">
            <MODELS>
            <MODEL NAME="SO_AGI_SGV_Meldungen_20221109" VERSION="2022-11-09" URI="https://agi.so.ch"/>
            </MODELS>
        </HEADERSECTION>

        <!-- TODO 
        * Lage: Beispiel fehlt
        * NBIdent: falsch im XML (metaDataName anstatt identDN) 
        * Versicherungsbeginn: falsch im XML (metaDataName) oder fehlt gänzlich. Sollte mandatory sein.
        -->

        <!-- Bemerkungen
        * Pro Meldung (z.B. newInsuranceValue) sind mehrere "buidlingInformationType" möglich. Dort sind dann wieder mehrere Grundstücke möglich. 
          Wie mache ich das grundsätzlich und wie mit XSLT? (-> TID? position()?)
          - pro building und pro Grundstück ein INTERLIS-Objekt?
          - jedoch werden immer alle Eingänge (buildingEntranceInformation) allen INTERLIS-Objekte zugewiesen
          -> Ich nehme nur jeweils das erste Element? Nachfragen bei SGV.
        * policyholder kann es mehrere geben. Sie werden zusammengefügt.
        * Mappen des eventType-Integers, siehe Seite 19 der ech-0132-Norm.

        * Gemeinde wird nicht geliefert. Dünkt mich. Wir könntes sie mit einem Update updaten (nache dem Import oder beim Transfer in Pub)
        -->

        <DATASECTION>
            <SO_AGI_SGV_Meldungen_20221109.Meldungen BID="SO_AGI_SGV_Meldungen_20221109.Meldungen">

                <xsl:message>Hallo Delivery</xsl:message>

                <!--Eventuell OR, falls alle ähnlich/gleich sind.-->
                <xsl:apply-templates select="eCH-0132:newInsuranceValue" /> 



            </SO_AGI_SGV_Meldungen_20221109.Meldungen>

        </DATASECTION>
        </TRANSFER>
    </xsl:template>

    <xsl:template match="eCH-0132:newInsuranceValue">
        <xsl:message>Hallo newInsuranceValue</xsl:message>

        <SO_AGI_SGV_Meldungen_20221109.Meldungen.Meldung xmlns="http://www.interlis.ch/INTERLIS2.3" TID="1">
            <xsl:if test="eCH-0132:buildingInformation[1]/eCH-0132:building[1]/eCH-0129:coordinates">
                <Lage xmlns="http://www.interlis.ch/INTERLIS2.3">
                    <COORD xmlns="http://www.interlis.ch/INTERLIS2.3">
                        <C1 xmlns="http://www.interlis.ch/INTERLIS2.3">
                            <xsl:value-of select="eCH-0132:buildingInformation[1]/eCH-0132:building[1]/eCH-0129:coordinates/eCH-0129:east" />
                        </C1>
                        <C2 xmlns="http://www.interlis.ch/INTERLIS2.3">
                            <xsl:value-of select="eCH-0132:buildingInformation[1]/eCH-0132:building[1]/eCH-0129:coordinates/eCH-0129:north" />                        
                        </C2>
                    </COORD>
                </Lage>
            </xsl:if>

            <Grundstuecksnummer xmlns="http://www.interlis.ch/INTERLIS2.3">
                <xsl:value-of select="number(tokenize(eCH-0132:buildingInformation[1]/eCH-0132:realestate[1]/eCH-0129:realestateIdentification/eCH-0129:number, '-')[last()])" />
            </Grundstuecksnummer>

            <EGRID xmlns="http://www.interlis.ch/INTERLIS2.3">
                <xsl:value-of select="eCH-0132:buildingInformation[1]/eCH-0132:realestate[1]/eCH-0129:realestateIdentification/eCH-0129:EGRID" />
            </EGRID>

            <NBIdent xmlns="http://www.interlis.ch/INTERLIS2.3">
                <xsl:value-of select="eCH-0132:buildingInformation[1]/eCH-0132:realestate[1]/eCH-0129:namedMetaData/eCH-0129:metaDataName[text() = 'NBIdent']/following-sibling::eCH-0129:metaDataValue" />
            </NBIdent>

            <Datum_Meldung xmlns="http://www.interlis.ch/INTERLIS2.3">
                <xsl:value-of select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
            </Datum_Meldung>

            <Meldegrund xmlns="http://www.interlis.ch/INTERLIS2.3">
                <xsl:value-of select="key('myns:lookup-eventType', eCH-0132:event, $myns:eventType-lookup)/@value"/>
            </Meldegrund>

            <Baujahr xmlns="http://www.interlis.ch/INTERLIS2.3">
                <xsl:value-of select="eCH-0132:buildingInformation[1]/eCH-0132:building[1]/eCH-0129:dateOfConstruction/eCH-0129:year" />
            </Baujahr>


<!-- TODO mapping-->


            <Gebaeudebezeichnung xmlns="http://www.interlis.ch/INTERLIS2.3">
                <xsl:value-of select="eCH-0132:buildingInformation[1]/eCH-0132:building[1]/eCH-0129:buildingCategory" />
            </Gebaeudebezeichnung>


        </SO_AGI_SGV_Meldungen_20221109.Meldungen.Meldung>







    </xsl:template>

</xsl:stylesheet>