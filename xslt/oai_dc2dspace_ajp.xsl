<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
                exclude-result-prefixes="#all"
>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:template match="dc:identifier[contains(text(), 'items')]">
        <dcvalue element="identifier"><xsl:value-of select="."/></dcvalue>
        <dcvalue element="landingPage"><xsl:value-of select="."/></dcvalue>
	<!-- bit of a hack adding these here -->
	<dcvalue element="pid"><xsl:value-of select="$record_identifier"/></dcvalue>
	<xsl:if test="not(//dc:rights)">
		<dcvalue element="rights"><xsl:value-of select="'Not specified'"/></dcvalue>
	</xsl:if>
    <xsl:if test="//dc:identifier[contains(text(), 'files')]">
	    <dcvalue element="metadataOnly">false</dcvalue>
    </xsl:if>
    </xsl:template>

    <xsl:template match="dc:identifier[contains(text(), 'files')]">
        <dcvalue element="identifier"><xsl:value-of select="."/></dcvalue>
    </xsl:template>

</xsl:stylesheet>
