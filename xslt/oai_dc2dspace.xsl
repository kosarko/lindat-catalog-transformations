<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
                exclude-result-prefixes="#all"
>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


    <xsl:param name="static_provider_name" static="yes"/>
    <xsl:param name="record_identifier"/>

    <!-- import may be overridden -->
    <xsl:import href="oai_dc2dspace_main.xsl"/>

    <!-- overrides -->
    <!-- per provider includes if any -->
    <xsl:include href="oai_dc2dspace_ajp.xsl" use-when="$static_provider_name='Patocka digital' and doc-available('oai_dc2dspace_ajp.xsl')"/>
    <xsl:include href="oai_dc2dspace_ffmu.xsl" use-when="($static_provider_name='Digitální knihovna Arne Nováka' or $static_provider_name='Projectiles' or $static_provider_name='Cinematic Brno') and doc-available('oai_dc2dspace_ffmu.xsl')"/>
    <xsl:include href="oai_dc2dspace_hyperfontes.xsl" use-when="$static_provider_name='HyperFontes' and doc-available('oai_dc2dspace_hyperfontes.xsl')"/>
    <xsl:include href="oai_dc2dspace_fontes.xsl" use-when="$static_provider_name='Fontes' and doc-available('oai_dc2dspace_fontes.xsl')"/>


</xsl:stylesheet>
