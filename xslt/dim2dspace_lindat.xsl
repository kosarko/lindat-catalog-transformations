<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
                exclude-result-prefixes="#all"
>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:template match="dim:field[@mdschema='dc' and @element='identifier' and @qualifier='uri']">
        <dcvalue element="identifier" qualifier="uri"><xsl:value-of select="."/></dcvalue>
        <dcvalue element="landingPage"><xsl:value-of select="."/></dcvalue>
       <dcvalue element="pid"><xsl:value-of select="."/></dcvalue>
        <!-- bit of a hack adding these here -->
        <xsl:apply-templates select="//dim:field[@mdschema!='dc']"/>
        <xsl:if test="not(//dim:field[@mdschema='dc' and @element='rights'])">
           <dcvalue element="rights"><xsl:value-of select="'Not specified'"/></dcvalue>
        </xsl:if>
    </xsl:template>

    <xsl:template match="dim:field[@mdschema='dc' and @element='date' and @qualifier='issued']" priority="100">
        <dcvalue element="date"><xsl:value-of select="."/></dcvalue>
    </xsl:template>

    <xsl:template match="dim:field[@mdschema='dc' and @element='date']">
    </xsl:template>

    <xsl:template match="dim:field[@mdschema='local' and @element='has' and @qualifier='files']">
        <dcvalue element="metadataOnly">
            <xsl:choose>
                <xsl:when test="text()='yes'">false</xsl:when>
                <xsl:otherwise>true</xsl:otherwise>
            </xsl:choose>
        </dcvalue>
    </xsl:template>

    <xsl:template match="dim:field[@mdschema='local' and @element='demo' and @qualifier='uri']">
        <dcvalue element="relation"><xsl:value-of select="."/></dcvalue>
    </xsl:template>

    <xsl:template match="dim:field[@mdschema='local' and @element='sponsor']">
        <dcvalue element="contributor" qualifier="funder"><xsl:value-of select="."/></dcvalue>
    </xsl:template>

    <xsl:template match="dim:field[@mdschema!='dc' and contains(lower-case(@qualifier), 'type')]">
        <dcvalue element="type"><xsl:value-of select="."/></dcvalue>
    </xsl:template>

</xsl:stylesheet>