<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:edm="http://www.europeana.eu/schemas/edm/"
                xmlns:ore="http://www.openarchives.org/ore/terms/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                exclude-result-prefixes="rdf edm ore dc skos"
                >
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:param name="provider_name"/>
    <xsl:param name="record_identifier"/>

    <xsl:key name="about" match="//*[@rdf:about]" use="@rdf:about"/>

    <xsl:include href="common/common.xslt"/>

    <xsl:template match="text()"/>

    <xsl:template match="/rdf:RDF">
        <dublin_core schema="dc">
            <xsl:call-template name="rights_uri"/>
	    <xsl:apply-templates select="edm:ProvidedCHO"/>
	    <xsl:apply-templates select="//edm:dataProvider"/>
	    <xsl:apply-templates select="//edm:isShownAt"/>
	    <xsl:apply-templates select="//edm:isShownBy"/>
	    <xsl:call-template name="metadataOnly"/>
	    <xsl:call-template name="all_as_cdata"/>
        </dublin_core>
    </xsl:template>

    <xsl:template match="edm:type">
       <dcvalue element="type"><xsl:value-of select="."/></dcvalue>
    </xsl:template>

    <!-- FIXME both two char lang codes and three char lang codes are possible; our dspace handles only 3 char -->
    <xsl:template match="edm:ProvidedCHO/dc:language" priority="1">
        <xsl:if test="string-length(.) = 2">
            <xsl:message>WARN: Found 2 char lang code '<xsl:value-of select="."/>'</xsl:message>
        </xsl:if>
       <dcvalue element="language" qualifier="iso"><xsl:value-of select="."/></dcvalue>
    </xsl:template>

    <!-- XXX some values might not be literals but refs, using prefLabel if present
	 TODO use also the ref somehow, if http
    -->
    <xsl:template match="edm:ProvidedCHO/dc:*">
	    <xsl:variable name="value">
		    <xsl:choose>
			<xsl:when test="@rdf:resource">
				<xsl:choose>
					<xsl:when test="key('about', @rdf:resource)/skos:prefLabel">
						<xsl:value-of select="key('about', @rdf:resource)/skos:prefLabel"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:message>WARN: not a literal <xsl:value-of select="@rdf:resource"/> </xsl:message>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
            			<xsl:value-of select="."/>
			</xsl:otherwise>
		    </xsl:choose>
	    </xsl:variable>
        <dcvalue>
            <xsl:attribute name="element">
                <xsl:value-of select="local-name()"/>
            </xsl:attribute>
            <xsl:value-of select="$value"/>
        </dcvalue>
    </xsl:template>

    <!-- FIXME rdf:resource might not be an uri, it can be a local ref to cc:License -->
    <xsl:template name="rights_uri">
        <xsl:variable name="rights_uri">
            <xsl:choose>
                <xsl:when test="//edm:WebResource/edm:rights">
                    <xsl:if test="count(//edm:WebResource) &gt; 1">
                        <xsl:message>WARN: There are multiple WebResources, not sure if choosing the right
                        license</xsl:message>
                    </xsl:if>
                    <xsl:value-of select="//edm:WebResource[0]/edm:rights/@rdf:resource"/>
                </xsl:when>
                <xsl:when test="//ore:Aggregation/edm:rights">
                    <xsl:value-of select="//ore:Aggregation/edm:rights/@rdf:resource"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="string-length($rights_uri) &gt; 0">
            <dcvalue element="rights" qualifier="uri"><xsl:value-of select="$rights_uri"/></dcvalue>
        </xsl:if>
    </xsl:template>

    <!-- For convenience, not really in dspace -->
    <xsl:template match="edm:dataProvider">
	    <dcvalue element="dataProvider"><xsl:value-of select="."/></dcvalue>
    </xsl:template>
    <xsl:template match="edm:isShownAt">
	    <dcvalue element="landingPage"><xsl:value-of select="@rdf:resource"/></dcvalue>
    </xsl:template>
    <xsl:template match="edm:isShownBy">
	    <dcvalue element="isShownBy"><xsl:value-of select="@rdf:resource"/></dcvalue>
    </xsl:template>
    <xsl:template match="edm:ProvidedCHO">
	    <dcvalue element="pid"><xsl:value-of select="@rdf:about"/></dcvalue>
            <xsl:apply-templates select="dc:*"/>
	    <xsl:apply-templates select="edm:type"/>
    </xsl:template>

    <xsl:template name="metadataOnly">
	    <xsl:choose>
		    <xsl:when test="//edm:WebResource">
	    		<dcvalue element="metadataOnly">false</dcvalue>
                    </xsl:when>
		    <xsl:otherwise>
	    		<dcvalue element="metadataOnly">true</dcvalue>
		    </xsl:otherwise>
	    </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
