<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                exclude-result-prefixes="#all"
>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:template match="dc:source">
        <xsl:if test="./text()">
                <!-- TODO metadataOnly -->
                <dcvalue element="source"><xsl:value-of select="."/></dcvalue>
                <dcvalue element="landingPage"><xsl:value-of select="."/></dcvalue>
        </xsl:if>
    </xsl:template>

    <xsl:template match="dc:identifier">
        <xsl:if test="./text()">
                <dcvalue element="identifier"><xsl:value-of select="."/></dcvalue>
                <dcvalue element="pid"><xsl:value-of select="."/></dcvalue>
        </xsl:if>
    </xsl:template>

    <xsl:template match="dc:date">
            <dcvalue element="date"><xsl:value-of select="."/></dcvalue>
            <xsl:if test="generate-id() = generate-id(//dc:date[1])">
                    <dcvalue element="daterange"><xsl:value-of select="concat(., '@@', if (//dc:date[2]) then //dc:date[2] else .)"/></dcvalue>
            </xsl:if>
    </xsl:template>

</xsl:stylesheet>

