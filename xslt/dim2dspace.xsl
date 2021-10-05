<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


    <xsl:param name="static_provider_name" static="yes"/>
    <xsl:param name="record_identifier"/>

    <!-- import may be overridden -->
    <xsl:import href="dim2dspace_main.xsl"/>

    <!-- overrides -->
    <!-- per provider includes if any -->
    <xsl:include href="dim2dspace_lindat.xsl"
                 use-when="$static_provider_name='LINDAT/CLARIAH-CZ repository' and doc-available('dim2dspace_lindat.xsl')"/>

</xsl:stylesheet>
