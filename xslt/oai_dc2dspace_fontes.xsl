<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                exclude-result-prefixes="#all"
>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:template match="dc:source">
        <xsl:if test="./text()">
                <dcvalue element="source"><xsl:value-of select="."/></dcvalue>
                <dcvalue element="landingPage"><xsl:value-of select="."/></dcvalue>
                <dcvalue element="pid"><xsl:value-of select="concat($provider_name, ':', $record_identifier)"/></dcvalue>
                <!-- Scanned editions with a full-text search are published in the Fontes section. -->
                <dcvalue element="metadataOnly">false</dcvalue>
                <dcvalue element="rights">unknown</dcvalue>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
