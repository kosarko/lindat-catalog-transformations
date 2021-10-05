<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
                exclude-result-prefixes="#all"
>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:param name="provider_name"/>
    <xsl:param name="record_identifier"/>

    <xsl:include href="common/common.xslt"/>

    <xsl:template match="text()"/>

    <xsl:template match="/dim:dim">
        <dublin_core schema="dc">
            <xsl:apply-templates select="dim:field[@mdschema='dc']"/>
<!--            <xsl:call-template name="all_as_cdata"/>-->
        </dublin_core>
    </xsl:template>

    <xsl:template match="dim:field[@mdschema='dc']">
        <dcvalue>
            <xsl:copy-of select="@element"/>
            <!--
            currently using qualifiers only for lang.iso and dspace2solr even works without them
            <xsl:copy-of select="@qualifier"/>
            -->
            <xsl:value-of select="."/>
        </dcvalue>
    </xsl:template>

    <xsl:template match="dim:field[@mdschema='dc' and @element='contributor' and @qualifier='author']" priority="100">
        <dcvalue element="creator"><xsl:value-of select="."/></dcvalue>
    </xsl:template>
</xsl:stylesheet>
