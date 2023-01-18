
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://www.loc.gov/MARC21/slim"
                exclude-result-prefixes="#all"
>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:param name="provider_uri" required="true" />


    <xsl:include href="common/common.xslt"/>

    <xsl:template match="text()"/>


    <xsl:template match="/m:record">
        <dublin_core schema="dc">
            <xsl:apply-templates/>
            <xsl:call-template name="title"/>
            <xsl:call-template name="metadataOnly"/>
            <xsl:call-template name="all_as_cdata"/>
        </dublin_core>
    </xsl:template>

    <!-- XXX ??? -->
    <!-- @ind1='1' -> `surname, name`; @ind1='0' -> `name surname`-->
    <!-- subfield[@code='4'] edt|aut  ??? -->
    <xsl:template match="m:datafield[@tag='100']/m:subfield[@code='a']">
            <dcvalue element="creator"><xsl:value-of select="text()"/></dcvalue>
    </xsl:template>

    <xsl:template match="m:datafield[@tag='653']/m:subfield[@code='a']">
            <dcvalue element="subject"><xsl:value-of select="text()"/></dcvalue>
    </xsl:template>

    <xsl:template match="m:datafield[@tag='520']/m:subfield[@code='a']">
            <dcvalue element="description"><xsl:value-of select="text()"/></dcvalue>
    </xsl:template>

    <xsl:template match="m:datafield[@tag='500']/m:subfield[@code='a']">
            <dcvalue element="description"><xsl:value-of select="text()"/></dcvalue>
    </xsl:template>

    <!-- 260...v samplu /c|e|b
      c...datum/rok vydani
      e...misto vyroby TODO
      b...jmeno nakladatele
    -->
    <xsl:template match="m:datafield[@tag='260']/m:subfield[@code='c']">
            <!-- XXX this is issued, but the downstream transformations don't care
            <dcvalue element="date" qualifier="issued"><xsl:value-of select="text()"/></dcvalue>
            -->
            <dcvalue element="date"><xsl:value-of select="text()"/></dcvalue>
    </xsl:template>
    <xsl:template match="m:datafield[@tag='260']/m:subfield[@code='b']">
            <dcvalue element="publisher"><xsl:value-of select="text()"/></dcvalue>
    </xsl:template>

    <xsl:template name="title">
            <xsl:choose>
                    <xsl:when test="m:datafield[@tag='NZV']/m:subfield[@code='t']/text()">
                        <dcvalue element="title"><xsl:value-of select="m:datafield[@tag='NZV']/m:subfield[@code='t']"/></dcvalue>
                    </xsl:when>
                    <xsl:when test="m:datafield[@tag='245']/m:subfield[@code='a']/text()">
                        <!-- @code='b' vypada jako anglickej preklad ale v sample je jen malo -->
                        <dcvalue element="title"><xsl:value-of select="m:datafield[@tag='245']/m:subfield[@code='a']"/></dcvalue>
                    </xsl:when>
            </xsl:choose>
    </xsl:template>
</xsl:stylesheet>