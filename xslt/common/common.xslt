<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template name="all_as_cdata">
	    <dcvalue element="original_metadata">
		    <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
		    <xsl:copy-of select="/"/>
		    <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
	    </dcvalue>
    </xsl:template>
</xsl:stylesheet>
