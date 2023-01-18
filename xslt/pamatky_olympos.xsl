<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://www.loc.gov/MARC21/slim"
                exclude-result-prefixes="#all"
>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:param name="provider_uri" required="true" />

    <xsl:template name="metadataOnly">
            <xsl:if test="some $subfield in /m:record/m:datafield[@tag='X02' or @tag='X00' or @tag='X03']/m:subfield satisfies $subfield/text()">
                <dcvalue element="metadataOnly">false</dcvalue>
            </xsl:if>
    </xsl:template>

    <xsl:template match="m:datafield[@tag='TYP']/m:subfield[@code='a']">
            <dcvalue element="type"><xsl:value-of select="text()"/></dcvalue>
    </xsl:template>
    <xsl:template match="m:leader[matches(text(), '^.......a.*')]">
            <dcvalue element="type"><xsl:value-of select="'subordinate record'"/></dcvalue>
    </xsl:template>

    <xsl:template match="m:datafield[@tag='NAM']/m:subfield[@code='a']">
            <dcvalue element="subject"><xsl:value-of select="text()"/></dcvalue>
    </xsl:template>

    <!-- TODO -->
    <xsl:template match="m:datafield[@tag='LOK']/m:subfield[@code='a']">
    </xsl:template>

    <!-- TODO -->
    <xsl:template match="m:datafield[@tag='INS']/m:subfield[@code='a']">
    </xsl:template>

    <!-- TODO -->
    <xsl:template match="m:datafield[@tag='BIB']/m:subfield[@code='a']">
    </xsl:template>


    <xsl:template match="m:controlfield[@tag='001']">
            <dcvalue element="identifier"><xsl:value-of select="concat('olympos_cz:', text())"/></dcvalue>
            <dcvalue element="landingPage"><xsl:value-of select="concat( if (contains($provider_uri,  'pamatky'))
                                                                         then 'http://pamatky.olympos.cz/l.dll?cll~P='
                                                                         else 'http://dramata.olympos.cz/l.dll?cll~P=',
                                                                         text())"/></dcvalue>
            <dcvalue element="rights">
                    <xsl:text>autorská práva www.olympos.cz</xsl:text>
                    <!--
                    <xsl:text>Classical Tradition in Czech Culture is protected by author's law and is
                            available for private use only. Any further publications, reprints or distribution of any material
                            published on Classical Tradition and Czech Culture without
                            previous writtern agreement, including copying of there materials or their
                            parts on other web pages or keepeing in other databaseesis forbidden.
                            When quoting, it is necessary to note:
                            Classical Tradition and Czech Culture (www.olympos.cz), date of quotation.</xsl:text>
-->
            </dcvalue>
    </xsl:template>



    <!--
         pamatky.olympos:
datafield[@tag="X02"]/subfield[@code="a"]* ... list odkazu na soubory
<subfield code="a">fasáda (a)#Q:\PAMATKY\PAMATKY\NAWEB\FOTODOKU\0671.JPG</subfield>

v nasledujicim zkracuju zapis misto datafield[@tag="XXX"]/subfield[@code="a"] pisu jen XXX
*znaci repeatable
&patrne no repeat nutno overit

TYP & patrne type
NAM * Namet
LOK & Lokace
INS & Inspirace výt. (?)
BIB & == A patrne jen odkaz na kompletni biblio
700 * ... autor(i)
 @ind2="1" ?
  /a ... personal name
   /b ... vypada jako prijmeni + roky
    /4 ... ?relationship? (https://www.loc.gov/marc/bibliographic/bd700.html) vidim 340 a 070
    610 * ... atributy/keywords
    330 & ... komentar / anotace
    305 & ... bibliografie
    300 & ... poznamka/popis
    210 & ... vydano
     /d ... rok
      /e ... misto
       /c ... objednatel ... prijmeni, jmeno (roky)
       200 * nazev
        /a ... hlavni?
         /d ... preklad?
         101 ... vypada jako jazyk hlavniho nazvu?
         100 ... vypada jako datum cehosi - 20050509d1911 u u0czey0103 ba; 20060102d1912 u u0czey0103 ba - to za tim d v prvni casti se vyskytuje v 210; datovani? ta prvni cast by mohlo bejt datum vzniku
         005 ... vypada jako datum posledni zmeny (sedi na header datestamp)
         001 ... je id (header identifier); ~z jednoho potreba vyextrahovat landing page~ funguje cely id za (http://pamatky.olympos.cz/l.dll?cll~P=)

         ignore
         910 ... empty
         801 ... ? serie info
_________________
Vyse je mapping z vystupu "oai_dc", coz se ukazalo jako unimarc; nasleduje premapovani na marc21
_________________
X02
TYP
NAM
LOK
INS
BIB
700 -> 100 ind1=1, ind2=#
 /a vse v jednom
 /4 edt (ze by 340 bylo edt, co je edt; 070 ze by aut)
610 -> 653 (ale cast predmetove analyzy muze byt i v 0xx, ale nevypada to)
330 -> 520 ind1=2 (3xx - 5xx blok poznamek)
305 -> 500
300 -> 500 (tim padem je 500 repeatable tag)
210 -> 260
200 -> 245
101 -> ? (zakodovano v 008?)
100 -> ? (zakodovano v 008?)
001
005
         -->


</xsl:stylesheet>
