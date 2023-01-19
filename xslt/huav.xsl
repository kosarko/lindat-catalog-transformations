<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://www.loc.gov/MARC21/slim"
                exclude-result-prefixes="#all"
>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <!-- substring('oai:biblio.hiu.cas.cz:00000115-af2b-4851-9520-c6dd0b2227f2', 23) -> drops oai:biblio.hiu.cas.cz:) -->
    <xsl:variable name="id" select="substring($record_identifier, 23)"/>

    <xsl:template name="metadataOnly">
            <xsl:if test="some $subfield in /m:record/m:datafield[@tag='856']/m:subfield[@code='u'] satisfies $subfield/text()">
                <dcvalue element="metadataOnly">false</dcvalue>
            </xsl:if>
    </xsl:template>


    <xsl:template match="m:controlfield[@tag='001']">

            <dcvalue element="pid"><xsl:value-of select="concat('https://biblio.hiu.cas.cz/records/', $id)"/></dcvalue>
            <dcvalue element="landingPage"><xsl:value-of select="concat('https://biblio.hiu.cas.cz/records/', $id)"/></dcvalue>
            <dcvalue element="rights">unknown</dcvalue>
    </xsl:template>
</xsl:stylesheet>
