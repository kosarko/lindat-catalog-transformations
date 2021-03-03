<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:param name="iso_xml_path" select="'../../'"/>

    <xsl:key name="iso-id-lookup" match="//language" use="id"/>
    <xsl:key name="iso-2b-lookup" match="//language" use="Part2B"/>
    <xsl:key name="iso-2t-lookup" match="//language" use="Part2T"/>
    <xsl:key name="iso-1-lookup" match="//language" use="Part1"/>

    <xsl:variable name="lang-top" select="document(concat($iso_xml_path, 'iso-639-3.xml'))/languages" as="document-node()"/>

    <!-- TODO 639-5 collective etc? -->
    <xsl:template match="languages">
        <xsl:param name="curr-id"/>
	<xsl:choose>
		<xsl:when test="key('iso-id-lookup', $curr-id)/Ref_Name">
			<xsl:value-of select="key('iso-id-lookup', $curr-id)/Ref_Name"/>
		</xsl:when>
		<xsl:when test="key('iso-2b-lookup', $curr-id)/Ref_Name">
			<xsl:value-of select="key('iso-2b-lookup', $curr-id)/Ref_Name"/>
		</xsl:when>
		<xsl:when test="key('iso-2t-lookup', $curr-id)/Ref_Name">
			<xsl:value-of select="key('iso-2t-lookup', $curr-id)/Ref_Name"/>
		</xsl:when>
		<xsl:when test="key('iso-1-lookup', $curr-id)/Ref_Name">
			<xsl:value-of select="key('iso-1-lookup', $curr-id)/Ref_Name"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:message>WARN: Failed to conver lang code '<xsl:value-of select="$curr-id"/>' in '<xsl:value-of select="$pid"/>'</xsl:message>
		</xsl:otherwise>
		<!--
		     TODO more complex logic?
		-->
	</xsl:choose>
    </xsl:template>
</xsl:stylesheet>
