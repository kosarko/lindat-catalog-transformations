<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:oai="http://www.openarchives.org/OAI/2.0/"
        version="2.0">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/oai:OAI-PMH//oai:record">
    <xsl:variable name="id" select="oai:header/oai:identifier"/>
    <xsl:variable name="xml-file" select="encode-for-uri(concat($id, '.xml'))"/>
    <xsl:variable name="txt-file" select="encode-for-uri(concat($id, '.txt'))"/>
    <xsl:result-document href="{$xml-file}" method="xml">
                 <xsl:copy-of select="oai:metadata/*"/>
    </xsl:result-document>
    <xsl:result-document href="{$txt-file}" method="text">
                 <xsl:value-of select="$id"/>
    </xsl:result-document>
  </xsl:template>
</xsl:stylesheet>
