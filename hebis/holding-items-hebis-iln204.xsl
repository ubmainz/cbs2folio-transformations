<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl="http://exslt.org/common" version="1.0" exclude-result-prefixes="exsl">

  <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>
  <xsl:key name="original" match="original/item" use="@epn"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- ILN 204 UB Gießen: holding-items-hebis-iln204.xsl -->
  <!-- ================================================= -->

  <xsl:template match="permanentLocationId">
    <xsl:variable name="i" select="key('original', .)"/>
    <!-- 209A$f/209G$a ? -->
    <xsl:variable name="abt" select="$i/datafield[@tag = '209A']/subfield[@code = 'f']/text()"/>
    <xsl:variable name="signature" select="$i/datafield[@tag = '209A' and subfield[@code = 'x'] = '00']/subfield[@code = 'a']/text()"/>
    <xsl:variable name="signature-lowercase" select="
        translate($signature,
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'abcdefghijklmnopqrstuvwxyz')"/>

    <xsl:variable name="standort"
      select="$i/datafield[(@tag = '209G') and (subfield[@code = 'x'] = '01')]/subfield[@code = 'a']"/>
    <xsl:variable name="electronicholding"
      select="(substring($i/../datafield[@tag = '002@']/subfield[@code = '0'], 1, 1) = 'O') and not(substring($i/datafield[@tag = '208@']/subfield[@code = 'b'], 1, 1) = 'a')"/>

    <permanentLocationId>
      <xsl:variable name="ranges-list">
        <ranges>
          <department code="000">
            <!-- temporäre Erwerbungssignatur -->
            <prefix location="UB-FH">/</prefix>
            <prefix location="UB-FH (RVK Signaturen)">ILN204/CG/UB/Freihand1OG</prefix>
            <prefix location="UB-MAG-Phil1">064 2o</prefix>
            <range from="2o 1/1" to="2o 1/9" location="UB-MAG-KELLER"/>
            <range from="2o 2/1" to="2o 2/9" location="UB-MAG-KELLER"/>
            <range from="1600" to="1899" location="UB-SLS"/>
            <range from="1900" to="1990" location="UB-MAG-ALTBAU"/>
            <range from="a 1" to="a 48" location="UB-MAG-KELLER"/>
            <range from="a 49" to="a 56" location="UB-MAG-3"/>
            <range from="a 57" to="a 999999" location="UB-MAG-KELLER"/>
            <range from="1/1" to="1/9" location="UB-MAG-KELLER"/>
            <range from="2/1" to="2/9" location="UB-MAG-KELLER"/>
            <range from="20.000.00" to="24.999.99" location="UB-MAG-3"/>
            <range from="27.000.00" to="27.999.99" location="UB-FH-Mikroformen"/>
            <range from="2o 20.000.00" to="2o 24.999.99" location="UB-MAG-3"/>
            <range from="2o 4/1" to="2o 4/9" location="UB-MAG-KELLER"/>
            <range from="2o 40.000.00" to="2o 44.999.99" location="UB-MAG-ALTBAU"/>
            <range from="2o a 49" to="2o a 56" location="UB-MAG-3"/>
            <range from="2o b 49" to="2o b 73" location="UB-MAG-3"/>
            <range from="2o bt 1" to="2o bt 9" location="UB-MAG-3"/>
            <range from="2o erk 000001" to="2o erk 999999" location="UB-MAG-KELLER"/>
            <prefix location="UB-MAG-3">2o hass</prefix>
            <prefix location="UB-MAG-3">2o kt a</prefix>
            <prefix location="UB-Kartenraum">2o kt b</prefix>
            <prefix location="UB-MAG-3">2o kt-a</prefix>
            <prefix location="UB-Kartenraum">2o kt-b</prefix>
            <prefix location="UB-MAG-3">2o landesk</prefix>
            <range from="2o ma" to="2o mz" location="UB-MAG-3"/>
            <prefix location="UB-MAG-3">2o ss</prefix>
            <prefix location="UB-MAG-KELLER">2o ztg</prefix>
            <range from="2o zz 01" to="2o zz 48" location="UB-MAG-3"/>
            <range from="2o zz 49" to="2o zz 99" location="UB-MAG-3"/>
            <range from="3/1" to="3/9" location="UB-MAG-KELLER"/>
            <prefix location="UB-MAG-Phil1">350</prefix>
            <range from="4 b 49" to="4 b 73" location="UB-MAG-3"/>
            <prefix location="UB-MAG-3">4 ss</prefix>
            <range from="4/1" to="4/9" location="UB-MAG-KELLER"/>
            <range from="47.000.00" to="47.999.99" location="UB-FH-Mikroformen"/>
            <range from="4o 1/1" to="4o 1/9" location="UB-MAG-KELLER"/>
            <range from="4o 2/1" to="4o 2/9" location="UB-MAG-KELLER"/>
            <range from="4o 20.000.00" to="4o 24.999.99" location="UB-MAG-3"/>
            <range from="4o 3/1" to="4o 3/9" location="UB-MAG-KELLER"/>
            <range from="4o 4/1" to="4o 4/9" location="UB-MAG-KELLER"/>
            <range from="4o a 49" to="4o a 56" location="UB-MAG-3"/>
            <prefix location="UB-MAG-ALTBAU">4o azz</prefix>
            <range from="4o b 49" to="4o b 73" location="UB-MAG-3"/>
            <range from="4o bt 1/1" to="4o bt 9/9" location="UB-MAG-3"/>
            <range from="4o erk 000001" to="4o erk 999999" location="UB-MAG-KELLER"/>
            <prefix location="UB-MAG-3">4o hass</prefix>
            <prefix location="UB-MAG-3">4o kr</prefix>
            <prefix location="UB-MAG-3">4o kt a</prefix>
            <prefix location="UB-Kartenraum">4o kt b</prefix>
            <prefix location="UB-MAG-3">4o kt-a</prefix>
            <prefix location="UB-Kartenraum">4o kt-b</prefix>
            <prefix location="UB-MAG-3">4o landesk</prefix>
            <range from="4o ma" to="4o mz" location="UB-MAG-3"/>
            <prefix location="UB-MAG-3">4o nr</prefix>
            <prefix location="UB-MAG-3">4o pap</prefix>
            <prefix location="UB-MAG-3">4o ss</prefix>
            <prefix location="UB-MAG-KELLER">4o ztg</prefix>
            <range from="4o zz 01" to="4o zz 20" location="UB-MAG-3"/>
            <range from="4o zz 21" to="4o zz 48" location="UB-MAG-3"/>
            <range from="4o zz 49" to="4o zz 65" location="UB-MAG-ALTBAU"/>
            <range from="4o zz 66" to="4o zz 99" location="UB-MAG-3"/>
            <!--<range from="a 000001" to="a 000048" location="UB-MAG-KELLER"/>
        <range from="a 000049" to="a 000056" location="UB-MAG-3"/>
        <range from="a 000057" to="a 999999" location="UB-MAG-KELLER"/>-->
            <prefix location="UB-MAG-ALTBAU">abw</prefix>
            <prefix location="UB-MAG-ALTBAU">adk</prefix>
            <prefix location="UB-MAG-ALTBAU">ags</prefix>
            <prefix location="UB-MAG-ALTBAU">al</prefix>
            <prefix location="UB-MAG-3">an</prefix>
            <prefix location="UB-MAG-ALTBAU">ap</prefix>
            <prefix location="UB-MAG-ALTBAU">aro</prefix>
            <prefix location="UB-MAG-ALTBAU">azz</prefix>
            <range from="b 000001" to="b 000048" location="UB-MAG-KELLER"/>
            <range from="b 000049" to="b 000073" location="UB-MAG-3"/>
            <range from="b 000074" to="b 999999" location="UB-MAG-KELLER"/>
            <range from="bap 000001" to="bap 000010" location="UB-MAG-ALTBAU"/>
            <range from="bap 000013" to="bap 000026" location="UB-MAG-ALTBAU"/>
            <prefix location="ILN204/CD/UB/UBMag3">bap 27</prefix>
            <range from="bap 000028" to="bap 000099" location="UB-MAG-ALTBAU"/>
            <range from="bap auskunft" to="bap z" location="UB-MAG-ALTBAU"/>
            <prefix location="UB-MAG-KELLER">bel</prefix>
            <range from="bt 000001/1" to="bt 000009/9" location="UB-MAG-3"/>
            <range from="c 000001" to="c 999999" location="UB-MAG-KELLER"/>
            <range from="cd 000001" to="cd 999999" location="UB-MAG-3"/>
            <range from="d 000000" to="d 999999" location="UB-MAG-KELLER"/>
            <range from="da 000000" to="da 999999" location="UB-MAG-KELLER"/>
            <range from="e 000000" to="e 000009" location="UB-MAG-KELLER"/>
            <range from="e 000010" to="e 999999" location="UB-MAG-KELLER"/>
            <prefix location="UB-MAG-KELLER">erk</prefix>
            <range from="f 000001" to="f 999999" location="UB-MAG-KELLER"/>
            <prefix location="UB-MAG-3">fd</prefix>
            <prefix location="UB-FH (FH-Sig)">fh all</prefix>
            <prefix location="UB-FH-Mikroformen">fh arb</prefix>
            <prefix location="UB-MAG-3">fk</prefix>
            <prefix location="UB-FH-Mikroformen">fp</prefix>
            <range from="frsla /" to="frsla z" location="UB-MAG-KELLER"/>
            <range from="g 000001" to="g 999999" location="UB-MAG-KELLER"/>
            <prefix location="UB-MAG-3">gb</prefix>
            <prefix location="UB-MAG-KELLER">ges</prefix>
            <prefix location="UB-MAG-3">giso</prefix>
            <prefix location="UB-MAG-KELLER">gr 000002o 2/</prefix>
            <range from="gr 000002o 20.00" to="gr 000002o 49.99" location="UB-MAG-3"/>
            <range from="gr 000002o a 49/" to="gr 000002o a 56/" location="UB-MAG-3"/>
            <prefix location="UB-MAG-3">gr 000002o b</prefix>
            <prefix location="UB-MAG-3">gr 000002o hass</prefix>
            <prefix location="UB-MAG-3">gr 000002o kt</prefix>
            <prefix location="UB-MAG-3">gr 000002o ss</prefix>
            <prefix location="UB-MAG-KELLER">gr 000002o ztg</prefix>
            <range from="gr 000002o zz 01" to="gr 000002o zz 20" location="UB-MAG-3"/>
            <range from="gr 000002o zz 49" to="gr 000002o zz 99" location="UB-MAG-3"/>
            <range from="h 000001" to="h 999999" location="UB-MAG-KELLER"/>
            <prefix location="UB-MAG-3">hass</prefix>
            <prefix location="UB-SLS">hr</prefix>
            <range from="hs 000001" to="hs 009999" location="UB-SLS"/>
            <range from="i 000000" to="i 000009" location="UB-MAG-KELLER"/>
            <prefix location="UB-MAG-3">in</prefix>
            <range from="j 000000" to="j 999999" location="UB-MAG-KELLER"/>
            <range from="k 000001" to="k 999999" location="UB-MAG-KELLER"/>
            <prefix location="UB-MAG-3">kr</prefix>
            <prefix location="UB-MAG-3">kt-a</prefix>
            <prefix location="UB-Kartenraum">kt-b</prefix>
            <range from="l 000001" to="l 999999" location="UB-MAG-KELLER"/>
            <prefix location="UB-MAG-3">landesk</prefix>
            <prefix location="UB-MAG-KELLER">les</prefix>
            <range from="m" to="m 999999" location="UB-MAG-KELLER"/>
            <prefix location="UB-MAG-3">mag og</prefix>
            <range from="mag ug 000" to="mag ug 999" location="UB-MAG-KELLER"/>
            <prefix location="UB-MAG-KELLER">msla</prefix>
            <prefix location="UB-MAG-3">mus</prefix>
            <range from="n 000001" to="n 999999" location="UB-MAG-KELLER"/>
            <prefix location="UB-SLS">nachl</prefix>
            <prefix location="UB-MAG-ALTBAU">nl</prefix>
            <prefix location="UB-MAG-ALTBAU">no</prefix>
            <prefix location="UB-MAG-3">nr</prefix>
            <range from="o 000001" to="o 999999" location="UB-MAG-KELLER"/>
            <prefix location="UB-FH-OSR">osr</prefix>
            <prefix location="UB-MAG-3">ott</prefix>
            <range from="p 000001" to="p 999999" location="UB-MAG-KELLER"/>
            <prefix location="UB-MAG-3">pl</prefix>
            <prefix location="UB-MAG-3">progr</prefix>
            <prefix location="UB-MAG-KELLER">q</prefix>
            <range from="r 000000" to="r 999999" location="UB-MAG-KELLER"/>
            <prefix location="UB-SLS">rara</prefix>
            <range from="s 000001" to="s 999999" location="UB-MAG-KELLER"/>
            <prefix location="UB-MAG-3">sap</prefix>
            <prefix location="UB-MAG-3">sch</prefix>
            <prefix location="UB-MAG-3">ss</prefix>
            <range from="t 000001" to="t 999999" location="UB-MAG-KELLER"/>
            <prefix location="UB-SLS">thaer</prefix>
            <prefix location="UB-MAG-3">theo</prefix>
            <range from="u 000001" to="u 999999" location="UB-MAG-KELLER"/>
            <range from="v 000001" to="v 999999" location="UB-MAG-KELLER"/>
            <prefix location="UB-MAG-KELLER">vorl</prefix>
            <prefix location="UB-MAG-ALTBAU">vuf</prefix>
            <prefix location="UB-MAG-KELLER">vv</prefix>
            <prefix location="UB-MAG-KELLER">w</prefix>
            <range from="x 000000" to="x 999999" location="UB-MAG-KELLER"/>
            <range from="y 000001" to="y 999999" location="UB-MAG-KELLER"/>
            <range from="z 000001" to="z 999999" location="UB-MAG-KELLER"/>
            <prefix location="UB-MAG-3">z nr</prefix>
            <prefix location="UB-MAG-3">ztg</prefix>
            <range from="zz 000001" to="zz 000020" location="UB-MAG-3"/>
            <range from="zz 000021" to="zz 000030" location="UB-MAG-3"/>
            <range from="zz 000049" to="zz 000065" location="UB-MAG-ALTBAU"/>
            <range from="zz 000066" to="zz 000099" location="UB-MAG-3"/>
          </department>
          <department code="002">
            <!-- temporäre Erwerbungssignatur -->
            <prefix location="ZNL-FH">/</prefix>
            <prefix location="ZNL-FH">002 agr</prefix>
            <prefix location="ZNL-MAG">002 che fa 0.40</prefix>
            <range from="130 /" to="130 z" location="ZNL-FH"/>
            <prefix location="ZNL-MAG">140</prefix>
            <range from="49.000.00" to="49.999.99" location="ZNL-MAG"/>
            <range from="4o 20.000.00" to="4o 21.999.99" location="ZNL-FH"/>
            <range from="4o 22.000.00" to="4o 22.999.99" location="ZNL-FH"/>
            <range from="4o 49.000.00" to="4o 49.999.99" location="ZNL-MAG"/>
            <range from="4o zz 000001" to="4o zz 000020" location="ZNL-FH"/>
            <range from="4o zz 000049" to="4o zz 000099" location="ZNL-FH"/>
            <range from="4o zz 49" to="4o zz 65" location="ZNL-FH"/>
            <range from="bap 000011,1" to="bap 000012,9" location="ZNL-FH"/>
            <prefix location="ZNL-FH">in</prefix>
            <prefix location="ZNL-FH">ss</prefix>
            <range from="zeitschriftenraum" to="zeitschriftenraum b" location="ZNL-FH"/>
            <prefix location="ZNL-MAG">zeitschriftenraum chemie</prefix>
            <range from="zz 000001" to="zz 000020" location="ZNL-FH"/>
            <range from="zz 000049" to="zz 000099" location="ZNL-FH"/>
          </department>
          <department code="005">
            <!-- temporäre Erwerbungssignatur -->
            <prefix location="ZHB-FH">/</prefix>
            <range from="a" to="z" location="ZHB-FH"/>
            <range from="205 /" to="205 z" location="ZHB-MAG"/>
            <prefix location="ZHB-FH">wand</prefix>
          </department>
          <department code="009">
            <!-- temporäre Erwerbungssignatur -->
            <prefix location="ZP2-FH">/</prefix>
            <range from="aa" to="az" location="ZP2-FH"/>
            <prefix location="ZP2-FH">did mat</prefix>
            <range from="010" to="9" location="ZP2-FH"/>
            <prefix location="ZP2-FH">m</prefix>
            <prefix location="ZP2-FH">n</prefix>
            <prefix location="ZP2-FH">q</prefix>
            <prefix location="ZP2-FH">r</prefix>
            <prefix location="ZP2-FH">zeit</prefix>
          </department>
          <department code="010">
            <range from="/" to="z" location="ZRW-FH"/>
          </department>
          <department code="015">
            <range from="/" to="z" location="DezFB"/>
          </department>
          <department code="020">
            <range from="/" to="j" location="ZRW-FH"/>
            <prefix location="ZRW-FH">lbs</prefix>
            <range from="mag a" to="mag z" location="ZRW-FH"/>
            <range from="n" to="s 000009" location="ZRW-FH"/>
            <range from="x" to="z" location="ZRW-FH"/>
          </department>
          <department code="029">
            <range from="/" to="z" location="DezFB"/>
          </department>
          <department code="030">
            <prefix location="ZP2-FH">/</prefix>
            <prefix location="ZP2-FH">009</prefix>
            <prefix location="ZP2-FH">03.</prefix>
            <prefix location="ZP2-FH">030 diplom</prefix>
            <prefix location="ZP2-FH">030 kup</prefix>
            <prefix location="ZP2-FH">030 mag</prefix>
            <prefix location="ZP2-FH">030 mus</prefix>
            <prefix location="ZP2-FH">030 pol</prefix>
            <prefix location="ZP2-FH">030 soz</prefix>
          </department>
        </ranges>
      </xsl:variable>
      
      <xsl:variable name="location-prefix-match">
        <xsl:call-template name="get-location-by-prefix">
          <xsl:with-param name="signature-lowercase" select="$signature-lowercase"/>
          <xsl:with-param name="prefix-list"
            select="exsl:node-set($ranges-list)/ranges/department[@code = $abt]/prefix"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$location-prefix-match = ''">
          <xsl:call-template name="get-location-by-range">
            <xsl:with-param name="signature-lowercase" select="$signature-lowercase"/>
            <xsl:with-param name="range-list"
              select="exsl:node-set($ranges-list)/ranges/department[@code = $abt]/range"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$location-prefix-match"/>
        </xsl:otherwise>
      </xsl:choose>
    </permanentLocationId>
  </xsl:template>

  <xsl:template match="permanentLoanTypeId">
    <xsl:variable name="loantype"
      select="key('original', .)/datafield[@tag = '209A']/subfield[@code = 'd']"/>
    <permanentLoanTypeId>
      <xsl:choose>
        <xsl:when test=". = 'u'">0 u Ausleihbar</xsl:when>
        <xsl:when test=". = 'b'">1 b Kurzausleihe</xsl:when>
        <xsl:when test=". = 'c'">2 c Lehrbuchsammlungsausleihe</xsl:when>
        <xsl:when test=". = 's'">3 s Präsenzbestand</xsl:when>
        <xsl:when test=". = 'd'">4 d Passive Fernleihe</xsl:when>
        <xsl:when test=". = 'i'">5 i Nur für den Lesesaal</xsl:when>
        <xsl:when test=". = 'f'">6 f nur Kopie möglich</xsl:when>
        <!-- ILN 8: in LBS3 nicht genutzt -->
        <!-- Status 7 mit 237A/4801 Semesterausleihe erzeugen? = vertagt, da unklar, ob in Folio nutzbar und fuer CBS-Saetze nicht relevant -->
        <xsl:when test=". = 'e'">8 e Vermisst</xsl:when>
        <xsl:when test=". = 'a'">9 a Zur Erwerbung bestellt</xsl:when>
        <xsl:when test=". = 'g'">9 g Nicht ausleihbar</xsl:when>
        <xsl:when test=". = 'o'">9 o Ausleihstatus unbekannt</xsl:when>
        <xsl:when test=". = 'z'">9 z Verlust</xsl:when>
        <!-- <xsl:otherwise>0 u Ausleihbar</xsl:otherwise>  wg. Zs ohne $d? -->
        <xsl:otherwise>9 o Ausleihstatus unbekannt</xsl:otherwise>
        <!-- damit Sonderfaelle auffallen -->
      </xsl:choose>
    </permanentLoanTypeId>
  </xsl:template>

  <xsl:template match="discoverySuppress">
    <!-- uses 208@$b (und/oder Kat. 247E/XY ?) -->
    <discoverySuppress>
      <!-- MZ: <xsl:value-of select="(substring(., 1, 1) = 'g') or (substring(., 2, 1) = 'y') or (substring(., 2, 1) = 'z')"/> 
           DA: nicht anzeigen: Pos.2: f, p, y, z -->
      <xsl:value-of
        select="(substring(., 2, 1) = 'f') or (substring(., 2, 1) = 'p') or (substring(., 2, 1) = 'y') or (substring(., 2, 1) = 'z')"
      />
    </discoverySuppress>
  </xsl:template>

  <!-- Parsing call number for prefix - optional -->

  <xsl:template name="prefix">
    <!-- default, nutzt °,@  -->
    <xsl:param name="cn"/>
    <xsl:param name="cnprefixelement"/>
    <xsl:param name="cnelement"/>
    <xsl:variable name="cnprefix">
      <xsl:choose>
        <xsl:when test="contains($cn, '°')">
          <xsl:value-of select="concat(substring-before($cn, '°'), '°')"/>
        </xsl:when>
        <xsl:when test="contains($cn, '@')">
          <xsl:value-of select="substring-before($cn, '@')"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:message>Debug: <xsl:value-of select="$cnelement"/> Prefix "<xsl:value-of select="$cnprefix"
      />"</xsl:message>
    <xsl:if test="string-length($cnprefix) > 0">
      <xsl:element name="{$cnprefixelement}">
        <xsl:value-of select="normalize-space(translate($cnprefix, '@', ''))"/>
      </xsl:element>
    </xsl:if>
    <xsl:element name="{$cnelement}">
      <xsl:value-of select="normalize-space(translate(substring-after($cn, $cnprefix), '@', ''))"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="callNumber">
    <xsl:call-template name="prefix">
      <xsl:with-param name="cn" select="."/>
      <xsl:with-param name="cnprefixelement" select="'callNumberPrefix'"/>
      <xsl:with-param name="cnelement" select="'callNumber'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="itemLevelCallNumber">
    <xsl:call-template name="prefix">
      <xsl:with-param name="cn" select="."/>
      <xsl:with-param name="cnprefixelement" select="'itemLevelCallNumberPrefix'"/>
      <xsl:with-param name="cnelement" select="'itemLevelCallNumber'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="check-range">
    <!-- Checks if the string signature-short-lowercase is in the range defined
      by the strings range-start and range-end.
      
      The three strings are getting sorted by comparing char by char with a
      predefined sort key. If each char of signature-short-lowercase
      is between the corresponding char of range-start and range-end, the
      template returns 1, otherwise 0.
      
      Inspired by https://weinert-automation.de/pub/XSLT1.0RangeFilter.pdf        
    -->

    <xsl:param name="signature-short-lowercase"/>
    <xsl:param name="range-start"/>
    <xsl:param name="range-end"/>
    <xsl:param name="i" select="1"/>
    <xsl:param name="o" select="1"/>
    <xsl:variable name="sortChar">'0123456789aäbcdefghijklmnoöpqrsßtuüvwxyz/'</xsl:variable>
    <xsl:variable name="frmFrst">
      <xsl:value-of select="substring($range-start, $i, 1)"/>
    </xsl:variable>
    <xsl:variable name="befFrst">
      <xsl:value-of select="substring($range-end, $i, 1)"/>
    </xsl:variable>
    <xsl:variable name="frmCmp">
      <xsl:value-of select="
          string-length(
          substring-before($sortChar, $frmFrst))"/>
    </xsl:variable>
    <xsl:variable name="befTmp">
      <xsl:value-of select="
          string-length(
          substring-before($sortChar, $befFrst))"/>
    </xsl:variable>
    <xsl:variable name="befCmp">
      <xsl:choose>
        <xsl:when test="$befTmp = 0">99</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$befTmp"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="string-length($signature-short-lowercase) > 1">
      <xsl:choose>
        <xsl:when
          test="$i > string-length($signature-short-lowercase) and $o > string-length($signature-short-lowercase)">
          <xsl:value-of select="1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="idFrst">
            <xsl:value-of select="substring($signature-short-lowercase, $i, 1)"/>
          </xsl:variable>
          <xsl:variable name="idCmp">
            <xsl:value-of select="string-length(substring-before($sortChar, $idFrst))"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$idCmp >= $frmCmp and $befCmp >= $idCmp">
              <xsl:call-template name="check-range">
                <xsl:with-param name="signature-short-lowercase" select="$signature-short-lowercase"/>
                <xsl:with-param name="range-start" select="$range-start"/>
                <xsl:with-param name="range-end" select="$range-end"/>
                <xsl:with-param name="i" select="$i + 1"/>
                <xsl:with-param name="o" select="$o + 1"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="0"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="compare-tokens">
    <xsl:param name="signature-lowercase-trimmed"/>
    <xsl:param name="range-from"/>
    <xsl:param name="range-to"/>
    <xsl:param name="in-range"/>

    <xsl:variable name="delimiter" select="' '"/>

    <xsl:choose>
      <xsl:when test="contains($signature-lowercase-trimmed, $delimiter)">
        <xsl:call-template name="compare-tokens">
          <xsl:with-param name="signature-lowercase-trimmed">
            <xsl:value-of select="substring-after($signature-lowercase-trimmed, $delimiter)"/>
          </xsl:with-param>
          <xsl:with-param name="range-from">
            <xsl:value-of select="substring-after($range-from, $delimiter)"/>
          </xsl:with-param>
          <xsl:with-param name="range-to">
            <xsl:value-of select="substring-after($range-to, $delimiter)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="current-signature-token">
          <xsl:value-of select="$signature-lowercase-trimmed"/>
        </xsl:variable>
        <xsl:variable name="current-range-from-token">
          <xsl:value-of select="$range-from"/>
        </xsl:variable>
        <xsl:variable name="current-range-to-token">
          <xsl:value-of select="$range-to"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when
            test="$current-signature-token = $current-range-from-token and $current-signature-token = $current-range-to-token">
            <xsl:value-of select="1"/>
          </xsl:when>
          <xsl:when test="
              string(number($current-signature-token)) != 'NaN' and
              string(number($current-range-from-token)) != 'NaN' and
              string(number($current-range-to-token)) != 'NaN'">
            <!-- The current signature token and the comparison tokens, e.g. the from token and the to token
              can be converted to a number. Therefore a numeric comparison decides whether the signature
              token fits in the range. -->
            <xsl:choose>
              <xsl:when test="
                  number($current-range-from-token) &lt; number($current-signature-token) and
                  number($current-signature-token) &lt; number($current-range-to-token)">
                <xsl:value-of select="1"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="0"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="check-range">
              <xsl:with-param name="signature-short-lowercase" select="$current-signature-token"/>
              <xsl:with-param name="range-start" select="$range-from"/>
              <xsl:with-param name="range-end" select="$range-to"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="get-location-by-prefix">
    <xsl:param name="signature-lowercase"/>
    <xsl:param name="prefix-list"/>
    <xsl:if test="$prefix-list">
      <xsl:variable name="prefix-zeroless">
        <xsl:call-template name="remove-leading-zeros">
          <xsl:with-param name="range-string">
            <xsl:value-of select="$prefix-list[1]"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="starts-with($signature-lowercase, $prefix-zeroless)">
          <xsl:value-of select="$prefix-list/@location"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="get-location-by-prefix">
            <xsl:with-param name="signature-lowercase" select="$signature-lowercase"/>
            <xsl:with-param name="prefix-list" select="$prefix-list[position() != 1]"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="get-location-by-range">
    <xsl:param name="signature-lowercase"/>
    <xsl:param name="range-list"/>
    <xsl:param name="last-range"/>
    <xsl:param name="in-range"/>
    <xsl:param name="default-location" select="'Unbekannter Standort'"/>
    <xsl:choose>
      <xsl:when test="$in-range = 1">
        <xsl:value-of select="$last-range/@location"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$range-list">
            <xsl:call-template name="get-location-by-range">
              <xsl:with-param name="signature-lowercase" select="$signature-lowercase"/>
              <xsl:with-param name="last-range" select="$range-list[1]"/>
              <xsl:with-param name="range-list" select="$range-list[position() != 1]"/>
              <xsl:with-param name="in-range">
                <xsl:call-template name="compare-tokens">
                  <xsl:with-param name="signature-lowercase-trimmed">
                    <xsl:value-of
                      select="substring($signature-lowercase, 1, string-length($range-list[1]/@to))"
                    />
                  </xsl:with-param>
                  <xsl:with-param name="range-from">
                    <xsl:value-of select="$range-list[1]/@from"/>
                  </xsl:with-param>
                  <xsl:with-param name="range-to">
                    <xsl:value-of select="$range-list[1]/@to"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$default-location"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="remove-leading-zeros">
    <xsl:param name="range-string"/>
    <xsl:choose>
      <xsl:when test="
          string-length($range-string) >= 6 and
          not(contains(substring($range-string, 1, 6), ' '))">
        <xsl:choose>
          <xsl:when test="string(number(substring($range-string, 1, 6))) != 'NaN'">
            <xsl:value-of select="translate(substring($range-string, 1, 6), '0', '')"/>
            <xsl:value-of select="substring($range-string, 7)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring($range-string, 1, 1)"/>
            <xsl:call-template name="remove-leading-zeros">
              <xsl:with-param name="range-string" select="substring($range-string, 2)"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$range-string != ''">
          <xsl:value-of select="substring($range-string, 1, 1)"/>
          <xsl:call-template name="remove-leading-zeros">
            <xsl:with-param name="range-string" select="substring($range-string, 2)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
