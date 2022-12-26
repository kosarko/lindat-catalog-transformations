<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:myfn="my:local:functions"
        exclude-result-prefixes="xs myfn"
        >
        <xsl:output method="xml" encoding="UTF-8" />

  <xsl:function name="myfn:genRange">
          <xsl:param name="lower"/>
          <xsl:param name="upper"/>
          <field name="date_itsim"><xsl:value-of select="$lower"/></field>
          <xsl:if test="$lower &lt; $upper">
                  <xsl:copy-of select="myfn:genRange($lower + 1, $upper)"/>
          </xsl:if>
  </xsl:function>

  <xsl:function name="myfn:aRange">
          <xsl:param name="lower"/>
          <xsl:param name="upper"/>
          <xsl:choose>
                  <xsl:when test="$lower &lt; $upper">
                          <xsl:copy-of select="myfn:genRange($lower, $upper)"/>
                  </xsl:when>
                  <xsl:otherwise>
                          <xsl:copy-of select="myfn:genRange($upper, $lower)"/>
                  </xsl:otherwise>
          </xsl:choose>
  </xsl:function>

  <xsl:function name="myfn:getYear">
          <xsl:param name="input"/>
                  <xsl:choose>
                          <xsl:when test="$input castable as xs:date">
                                  <xsl:value-of select="year-from-date(xs:date($input))"/>
                          </xsl:when>
                          <xsl:when test="$input castable as xs:gYear">
                                  <xsl:value-of select="year-from-date(xs:date(concat($input,'-01-01')))"/>
                          </xsl:when>
                          <xsl:when test="$input castable as xs:gYearMonth">
                                  <xsl:value-of select="year-from-date(xs:date(concat($input,'-01')))"/>
                          </xsl:when>
                          <xsl:when test="$input castable as xs:dateTime">
                                  <xsl:value-of select="year-from-dateTime(xs:dateTime($input))"/>
                          </xsl:when>
                          <xsl:otherwise>
                                  <xsl:message>ERROR: <xsl:value-of select="$record_identifier"/> Can't extract year from "<xsl:value-of select="$input"/>".</xsl:message>
                          </xsl:otherwise>
                  </xsl:choose>
  </xsl:function>

  <!--
  <xsl:template match="/dates">
        <range>
                <xsl:copy-of select="myfn:aRange(myfn:getYear(date[1]), myfn:getYear(date[2]))"/>
        </range>
  </xsl:template>
  -->
</xsl:stylesheet>



