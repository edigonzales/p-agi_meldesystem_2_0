<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eCH-0132="http://www.ech.ch/xmlns/eCH-0132/3" xmlns:eCH-0129="http://www.ech.ch/xmlns/eCH-0129/6" version="3.0"> 
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/eCH-0132:delivery">
        <TRANSFER xmlns="http://www.interlis.ch/INTERLIS2.3">
        <HEADERSECTION SENDER="ch0132_to_xtf" VERSION="2.3">
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
        * policyholder kann es mehrere geben. Sie werden zusammengefügt.
        * Mappen des eventType-Integers, siehe Seite 19 der ech-0132-Norm.
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
            <Grundstuecksnummer xmlns="http://www.interlis.ch/INTERLIS2.3">
                <xsl:value-of select="number(tokenize(eCH-0132:buildingInformation/eCH-0132:realestate/eCH-0129:realestateIdentification/eCH-0129:number, '-')[last()])" />
            </Grundstuecksnummer>
        </SO_AGI_SGV_Meldungen_20221109.Meldungen.Meldung>



    </xsl:template>

</xsl:stylesheet>