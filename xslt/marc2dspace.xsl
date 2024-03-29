<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


    <xsl:param name="static_provider_name" static="yes"/>
    <xsl:param name="record_identifier"/>

    <!-- import may be overridden -->
    <xsl:import href="marc2dspace_main.xsl"/>

    <!-- overrides -->
    <!-- per provider includes if any -->
    <xsl:include href="pamatky_olympos.xsl"
                 use-when="($static_provider_name='Pamatky' or $static_provider_name='Dramata') and doc-available('pamatky_olympos.xsl')"/>
    <xsl:include href="huav.xsl"
                 use-when="($static_provider_name='HUAV' or $static_provider_name='Bibliography of the History of the Czech Lands') and doc-available('huav.xsl')"/>

</xsl:stylesheet>
