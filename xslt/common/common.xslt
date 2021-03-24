<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template name="all_as_cdata">
	    <dcvalue element="original_metadata"><xsl:value-of select="serialize(/)"/></dcvalue>
    </xsl:template>
</xsl:stylesheet>
