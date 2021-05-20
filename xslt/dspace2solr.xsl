<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="str"
>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:param name="provider_name"/>
    <xsl:param name="record_identifier"/>

    <xsl:variable name="pid" select="//dcvalue[@element='pid']"/>

    <xsl:include href="common/language_mapping.xslt"/>

    <xsl:template match="text()"/>

    <xsl:template match="/">
	    <add>
	    	<doc>
	   		<xsl:apply-templates select="//dcvalue[not(@qualifier)]"/>
	   		<xsl:apply-templates select="//dcvalue[@element='language'][@qualifier='iso']"/>
			<xsl:call-template name="id"/>
			<xsl:call-template name="displayName"/>
			<xsl:call-template name="rights"/>
			<xsl:call-template name="landingPage"/>
			<xsl:call-template name="oai_identifier"/>
			<xsl:call-template name="harvestedFrom"/>
			<xsl:call-template name="all_as_cdata"/>
		</doc>
	    </add>
    </xsl:template>

    <xsl:template match="dcvalue[@element='title']">
	<field name="title_tsim"><xsl:value-of select="."/></field>
    </xsl:template>

    <xsl:template match="dcvalue[@element='publisher']">
	<field name="publisher_tsim"><xsl:value-of select="."/></field>
	<field name="publisher_ssim"><xsl:value-of select="."/></field>
    </xsl:template>

    <xsl:template match="dcvalue[@element='creator']">
	<field name="creator_tsim"><xsl:value-of select="."/></field>
	<field name="creator_ssim"><xsl:value-of select="."/></field>
    </xsl:template>

    <xsl:template match="dcvalue[@element='contributor']">
	<field name="contributor_tsim"><xsl:value-of select="."/></field>
	<field name="contributor_ssim"><xsl:value-of select="."/></field>
    </xsl:template>

    <xsl:template match="dcvalue[@element='identifier']">
	<field name="identifier_ssim"><xsl:value-of select="."/></field>
    </xsl:template>

    <xsl:template match="dcvalue[@element='subject']">
	<field name="subject_ssim"><xsl:value-of select="."/></field>
    </xsl:template>

    <xsl:template match="dcvalue[@element='type']">
	<field name="type_ssim"><xsl:value-of select="."/></field>
    </xsl:template>

    <xsl:template match="dcvalue[@element='description']">
	    <!-- XXX apparently multivalued -->
	<field name="description_tsim"><xsl:value-of select="."/></field>
    </xsl:template>

    <xsl:template match="dcvalue[@element='language'][@qualifier='iso']">
	    <!-- XXX shouldn't need to tokenize -->
	    <!--<xsl:for-each select="str:tokenize(string(.), ',')">-->
	    <!----><xsl:for-each select="tokenize(string(.), ',')">
			<xsl:variable name="lang">
				<xsl:apply-templates select="$lang-top"><xsl:with-param name="curr-id" select="."/></xsl:apply-templates>
			</xsl:variable>
			<xsl:if test="$lang/language">
				<field name="language_iso_ssim"><xsl:value-of select="$lang/language/id"/></field>
				<field name="language_ssim"><xsl:value-of select="$lang/language/Ref_Name"/></field>
			</xsl:if>
	    </xsl:for-each>
    </xsl:template>

    <!-- don't know what to do with a language el; try treating it as iso code -->
    <xsl:template match="dcvalue[@element='language'][not(@qualifier)]">
	    <!-- XXX shouldn't need to tokenize -->
	    	<xsl:for-each select="tokenize(string(.), ',')">
			<xsl:variable name="lang">
				<xsl:apply-templates select="$lang-top"><xsl:with-param name="curr-id" select="."/></xsl:apply-templates>
			</xsl:variable>
			<xsl:if test="$lang/language/id">
				<field name="language_iso_ssim"><xsl:value-of select="$lang/language/id"/></field>
				<field name="language_ssim"><xsl:value-of select="$lang/language/Ref_Name"/></field>
			</xsl:if>
	    </xsl:for-each>
    </xsl:template>

    <xsl:template match="dcvalue[@element='format']">
	<field name="format"><xsl:value-of select="."/></field>
    </xsl:template>

    <!-- XXX string?? -->
    <xsl:template match="dcvalue[@element='coverage']">
	<field name="coverage_ssim"><xsl:value-of select="."/></field>
    </xsl:template>

    <xsl:template match="dcvalue[@element='relation']">
	<field name="relation_ssm"><xsl:value-of select="."/></field>
    </xsl:template>

    <xsl:template match="dcvalue[@element='source']">
	<field name="source_ssm"><xsl:value-of select="."/></field>
    </xsl:template>
    <!-- 
	 TODO maybe daterange? test with autodetect?
    <xsl:template match="dcvalue[@element='date']">
	<field name="date_dtsim"><xsl:value-of select="."/></field>
    </xsl:template>
    -->
    <xsl:template match="dcvalue[@element='date']">
	<field name="date_itsim"><xsl:value-of select="."/></field>
    </xsl:template>

    <xsl:template match="dcvalue[@element='metadataOnly']">
	    <field name="metadataOnly"><xsl:value-of select="."/></field>
    </xsl:template>

    <xsl:template name="id">
	<xsl:choose>
		<xsl:when test="//dcvalue[@element='pid']">
			<field name="id"><xsl:value-of select="//dcvalue[@element='pid']"/></field>
		</xsl:when>
		<xsl:when test="//dcvalue[@element='identifier' and starts-with(text(),'uuid')]">
			<field name="id"><xsl:value-of select="//dcvalue[@element='identifier' and starts-with(text(),'uuid')]"/></field>
		</xsl:when>
		<xsl:otherwise>
			<field name="id"><xsl:value-of select="//dcvalue[@element='identifier'][1]"/></field>
		</xsl:otherwise>
	</xsl:choose>
    </xsl:template>

    <xsl:template name="displayName">
	<xsl:choose>
		<xsl:when test="//dcvalue[@element='title']">
			<field name="displayName"><xsl:value-of select="//dcvalue[@element='title']"/></field>
		</xsl:when>
		<xsl:when test="//dcvalue[@element='description']">
			<field name="displayName"><xsl:value-of select="//dcvalue[@element='description']"/></field>
		</xsl:when>
	</xsl:choose>
    </xsl:template>

    <xsl:template name="all_as_cdata">
	    <field name="original_metadata_ss">
		    <xsl:value-of select="//dcvalue[@element='original_metadata']"/>
	    </field>
    </xsl:template>

    <xsl:template name="rights">
	    <!-- TODO limit the values to some manageable set -->
	    <xsl:for-each select="//dcvalue[@element='rights']">
		    <!-- XXX maybe should be text? not a string -->
		    <field name="rights"><xsl:value-of select="."/></field>
	    </xsl:for-each>
    </xsl:template>

    <xsl:template name="landingPage">
	    <!-- TODO probably more complex logic
		      not indexed it should be url
		 -->
	    <field name="landingPage"><xsl:value-of select="//dcvalue[@element='landingPage']"/></field>
    </xsl:template>
    <xsl:template name="harvestedFrom">
	    <field name="harvestedFrom"><xsl:value-of select="$provider_name"/></field>
    </xsl:template>
    <xsl:template name="oai_identifier">
	    <field name="oai_id"><xsl:value-of select="$record_identifier"/></field>
    </xsl:template>
</xsl:stylesheet>
