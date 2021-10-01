
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:omeka="http://omeka.org/schemas/omeka-xml/v5"
                exclude-result-prefixes="#all"
>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:param name="provider_name"/>
    <xsl:param name="record_identifier"/>

    <xsl:include href="common/common.xslt"/>

    <xsl:template match="text()"/>

    <xsl:variable name="lp_prefix" select="'https://archiv.janpatocka.cz/items/show/'"/>

    <xsl:template match="/omeka:item">
        <dublin_core schema="dc">
	            <dcvalue element="pid"><xsl:value-of select="$record_identifier"/></dcvalue>
                <dcvalue element="landingPage"><xsl:value-of select="concat($lp_prefix, @itemId)"/></dcvalue>
                <dcvalue element="type"><xsl:value-of select="omeka:itemType/omeka:name/text()"/></dcvalue>
                <dcvalue element="rights">open access</dcvalue>
                <dcvalue element="rights">Rights holder: Archiv Jana Patočky, z.s.</dcvalue>
                <xsl:apply-templates/>
                <xsl:call-template name="metadata_only"/>
                <xsl:call-template name="all_as_cdata"/>
        </dublin_core>

    </xsl:template>

    <xsl:template match="//omeka:elementSet[./omeka:name/text()='Dublin Core']//omeka:element">
            <xsl:variable name="el_name" select="lower-case(omeka:name/text())"/>
            <xsl:for-each select=".//omeka:text">
                <dcvalue>
                    <xsl:attribute name="element">
                            <xsl:value-of select="$el_name"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space(.)"/>
                </dcvalue>
            </xsl:for-each>
    </xsl:template>

    <!-- drop rights as we prefill those -->
    <xsl:template match="//omeka:elementSet[./omeka:name/text()='Dublin Core']//omeka:element[./omeka:name/text()='Rights']" priority="100"/>

    <xsl:template match="//omeka:element[./omeka:name/text()='Original Format']">
            <xsl:for-each select=".//omeka:text">
                <dcvalue element="format">
                    <xsl:value-of select="normalize-space(.)"/>
                </dcvalue>
            </xsl:for-each>
    </xsl:template>

    <xsl:template match="//omeka:tagContainer/omeka:tag/omeka:name">
                <dcvalue element="subject"><xsl:value-of select="normalize-space(.)"/></dcvalue>
    </xsl:template>

    <xsl:template name="metadata_only">
                <xsl:if test="/omeka:item/omeka:fileContainer/omeka:file or //omeka:tagContainer/omeka:tag/omeka:name[lower-case(normalize-space(text()))='fulltext']">
                    <dcvalue element="metadataOnly">false</dcvalue>
                </xsl:if>
    </xsl:template>

</xsl:stylesheet>
