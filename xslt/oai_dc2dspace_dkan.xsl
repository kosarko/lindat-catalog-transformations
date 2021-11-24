<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                exclude-result-prefixes="#all"
>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:template match="dc:identifier">
        <dcvalue element="identifier"><xsl:value-of select="."/></dcvalue>
        <xsl:if test="starts-with(text(), 'http')">
            <dcvalue element="landingPage"><xsl:value-of select="."/></dcvalue>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
