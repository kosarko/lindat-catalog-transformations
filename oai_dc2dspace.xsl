<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
                exclude-result-prefixes="#all"
>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:param name="provider_name"/>
    <xsl:param name="record_identifier"/>

    <xsl:template match="text()"/>

    <xsl:template match="/oai_dc:dc">
        <dublin_core schema="dc">
            <xsl:apply-templates select="dc:*"/>
        </dublin_core>
    </xsl:template>

    <xsl:template match="dc:*">
        <dcvalue>
            <xsl:attribute name="element">
                <xsl:value-of select="local-name()"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </dcvalue>
    </xsl:template>

</xsl:stylesheet>
