<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="2.0">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="//dublin_core">
    <xsl:variable name="id" select="dcvalue[@element='identifier']"/>
    <xsl:variable name="xml-file" select="encode-for-uri(concat($id, '.xml'))"/>
    <xsl:variable name="txt-file" select="encode-for-uri(concat($id, '.txt'))"/>
    <xsl:result-document href="{$xml-file}" method="xml">
                 <xsl:copy-of select="."/>
    </xsl:result-document>
    <xsl:result-document href="{$txt-file}" method="text">
                 <xsl:value-of select="$id"/>
    </xsl:result-document>
  </xsl:template>
</xsl:stylesheet>
