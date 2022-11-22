<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:oai="http://www.openarchives.org/OAI/2.0/"
        version="2.0">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/oai:OAI-PMH/oai:ListRecords/oai:record">
    <xsl:variable name="id" select="oai:header/oai:identifier"/>
    <xsl:variable name="filename" select="encode-for-uri(concat($id, '.xml'))"/>
    <xsl:result-document href="{$filename}" method="xml">
            <!--
                 <xsl:copy-of select="*[local-name()='metadata']/*"/>
-->
                <!-- maybe catch oai:record if we need the oai identifier -->
                 <xsl:copy-of select="oai:metadata/*"/>
    </xsl:result-document>
    <success>Created file: <xsl:value-of select="$filename"/></success>
  </xsl:template>
</xsl:stylesheet>
