<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>
  <xsl:key name="original" match="original/item" use="@epn"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- ILN 204 UB Gießen: holding-items-hebis-iln204.xsl -->
  <!-- ================================================= -->

  <xsl:variable name="lookup-LBS-ranges" select="document('lbs-ranges-iln204.xml')"/>

  <xsl:template name="get-location">
    <!-- See https://weinert-automation.de/pub/XSLT1.0RangeFilter.pdf -->
    <xsl:param name="signatur"/>
    <xsl:param name="lbs-range-start"/>
    <xsl:param name="lbs-range-end"/>
    <xsl:param name="i" select="1"/>
    <xsl:param name="o" select="1"/>
    <xsl:variable name="sortChar"
      >'0123456789AÄaäBbCcDdEeFfGgHhIiJjKkLlMmNnOÖoöPpQqRrSsßTtUÜuüVvWwXxYyZz'</xsl:variable>

    <xsl:variable name="frmFrst">
      <xsl:value-of select="substring($lbs-range-start, $i, 1)"/>
    </xsl:variable>
    <xsl:variable name="befFrst">
      <xsl:value-of select="substring($lbs-range-end, $i, 1)"/>
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

    <xsl:if test="string-length($signatur) > 1">
      <xsl:choose>
        <xsl:when test="$i > string-length($signatur) and $o > string-length($signatur)">
          <xsl:value-of select="1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="idFrst">
            <xsl:value-of select="substring($signatur, $i, 1)"/>
          </xsl:variable>
          <xsl:variable name="idCmp">
            <xsl:value-of select="string-length(substring-before($sortChar, $idFrst))"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$idCmp >= $frmCmp and $befCmp >= $idCmp">
              <xsl:call-template name="get-location">
                <xsl:with-param name="signatur" select="$signatur"/>
                <xsl:with-param name="lbs-range-start" select="$lbs-range-start"/>
                <xsl:with-param name="lbs-range-end" select="$lbs-range-end"/>
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

  <xsl:template name="fill-range">
    <xsl:param name="range-length"/>
    <xsl:param name="range-string"/>

    <xsl:choose>
      <xsl:when test="$range-length > string-length($range-string)">
        <xsl:call-template name="fill-range">
          <xsl:with-param name="range-length" select="$range-length"/>
          <xsl:with-param name="range-string" select="concat($range-string, '0')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$range-string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="testsignatur">
    <xsl:variable name="abt" select="'000'"/>
    <xsl:variable name="signatur" select="."/>
    <permanentLocationId>
      <xsl:attribute name="testsignatur">
        <xsl:value-of select="$signatur"/>
      </xsl:attribute>

      <xsl:for-each select="$lookup-LBS-ranges/lbs-ranges/*">
        <xsl:variable name="filled-lbs-range-start">
          <xsl:call-template name="fill-range">
            <xsl:with-param name="range-string" select="@from"/>
            <xsl:with-param name="range-length" select="string-length(@to)"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="filled-lbs-range-end">
          <xsl:call-template name="fill-range">
            <xsl:with-param name="range-string" select="@to"/>
            <xsl:with-param name="range-length" select="string-length(@from)"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="check-get-location">
          <xsl:call-template name="get-location">
            <xsl:with-param name="signatur">
              <xsl:value-of select="
                  translate(
                  substring($signatur, 1, string-length(@to)),
                  'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                  'abcdefghijklmnopqrstuvwxyz')"/>
            </xsl:with-param>
            <xsl:with-param name="lbs-range-start">
              <xsl:value-of select="$filled-lbs-range-start"/>
            </xsl:with-param>
            <xsl:with-param name="lbs-range-end">
              <xsl:value-of select="$filled-lbs-range-end"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$check-get-location = 1">
          <xsl:attribute name="standort-range">
            <xsl:value-of select="@location"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:for-each>


      <xsl:choose>
        <!-- Regeln für UB -->
        <xsl:when test="$abt = '000'">
          <xsl:choose>
            <!-- UB / Standort FH 1.Stock = Freihand1OG -->
            <!-- UB / Standort FH 2.Stock = Freihand2OG -->
            <!-- UB / Standort Magazin 3.Stock = UBMag3 -->
            <!-- UB / Standort Magazin Keller= UBMagKeller -->
            <!-- UB / Standort Magazin Altbau = UBMagAltbau-->
            <!-- UB / Standort Magazin Phil 1 Altbau = UBMagPhil1 -->
            <!-- UB / Standort SLS = UBSLS -->
            <xsl:when test="starts-with($signatur, '/')">ILN204/CG/UB/Freihand1OG</xsl:when>
            <!-- Temporäre Erwerbungssignatur - Standort so lassen?-->
            <xsl:when test="starts-with($signatur, '000 ')">ILN204/CG/UB/Freihand1OG</xsl:when>
            <!-- RVK-Signaturen -->
            <xsl:when test="starts-with($signatur, '064 ')">
              <xsl:choose>
                <xsl:when test="starts-with($signatur, '064 4o a')"
                  >ILN204/CG/UB/Freihand2OG</xsl:when>
                <!-- 064er bei FH Sla -->
                <xsl:when test="starts-with($signatur, '064 einzelsig')"
                  >ILN204/CG/UB/Freihand2OG</xsl:when>
                <!-- 064er bei FH OSTGe -->
                <xsl:otherwise>ILN204/CG/UB/UBMagPhil1</xsl:otherwise>
                <!-- Rest der 064er in Mag Phil1 -->
              </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with($signatur, '1/')">ILN204/CG/UB/UBMagKeller</xsl:when>
            <!-- KSTR Signaturen im Keller -->
            <xsl:when test="starts-with($signatur, '16')">ILN204/CG/UB/UBSLS</xsl:when>
            <!-- Alte Dissen mit EJ vorne im SLS -->
            <xsl:when test="starts-with($signatur, '17')">ILN204/CG/UB/UBSLS</xsl:when>
            <!-- Alte Dissen mit EJ vorne im SLS -->
            <xsl:when test="starts-with($signatur, '18')">ILN204/CG/UB/UBSLS</xsl:when>
            <!-- Alte Dissen mit EJ vorne im SLS -->
            <xsl:when test="starts-with($signatur, '19')">ILN204/CG/UB/UBMagAltbau</xsl:when>
            <!-- Dissen 1900-1990 im Altbau -->
            <xsl:when test="starts-with($signatur, '2/')">ILN204/CG/UB/UBMagKeller</xsl:when>
            <!-- KSTR Signaturen im Keller -->
            <xsl:when test="starts-with($signatur, '20.')">ILN204/CG/UB/UBMag3</xsl:when>
            <!-- 20er Signaturen im bis 24.999.99 in Mag3 -->
            <xsl:when test="starts-with($signatur, '21.')">ILN204/CG/UB/UBMag3</xsl:when>
            <!-- 20er Signaturen im bis 24.999.99 in Mag3 -->
            <xsl:when test="starts-with($signatur, '22.')">ILN204/CG/UB/UBMag3</xsl:when>
            <!-- 20er Signaturen im bis 24.999.99 in Mag3 -->
            <xsl:when test="starts-with($signatur, '23.')">ILN204/CG/UB/UBMag3</xsl:when>
            <!-- 20er Signaturen im bis 24.999.99 in Mag3 -->
            <xsl:when test="starts-with($signatur, '24.')">ILN204/CG/UB/UBMag3</xsl:when>
            <!-- 20er Signaturen im bis 24.999.99 in Mag3 -->
            <xsl:when test="starts-with($signatur, '27.')">ILN204/CG/UB/UBFreihand1OG</xsl:when>
            <!-- Arbeitsplatz Mikroformen -->
            <xsl:when test="starts-with($signatur, '2o 1/')">ILN204/CG/UB/UBMagKeller</xsl:when>
            <!-- Sind doch eigentlich auch KSTR -->
            <xsl:when test="starts-with($signatur, '2o 2/')">ILN204/CG/UB/UBMagKeller</xsl:when>
            <!-- Sind doch eigentlich auch KSTR -->
            <xsl:when test="starts-with($signatur, '2o 20.')">ILN204/CG/UB/UBMag3</xsl:when>
            <!-- 20er Signaturen im bis 24.999.99 in Mag3 -->
            <xsl:when test="starts-with($signatur, '2o 21.')">ILN204/CG/UB/UBMag3</xsl:when>
            <!-- 20er Signaturen im bis 24.999.99 in Mag3 -->
            <xsl:when test="starts-with($signatur, '2o 22.')">ILN204/CG/UB/UBMag3</xsl:when>
            <!-- 20er Signaturen im bis 24.999.99 in Mag3 -->
            <xsl:when test="starts-with($signatur, '2o 23.')">ILN204/CG/UB/UBMag3</xsl:when>
            <!-- 20er Signaturen im bis 24.999.99 in Mag3 -->
            <xsl:when test="starts-with($signatur, '2o 24.')">ILN204/CG/UB/UBMag3</xsl:when>
            <!-- 20er Signaturen im bis 24.999.99 in Mag3 -->

            <!-- Für später -->
            <xsl:when test="starts-with($signatur, 'FH ')">ILN204/CG/UB/Freihand2OG</xsl:when>
            <xsl:when test="starts-with($signatur, '4o ')">ILN204/CD/UB/UBMag</xsl:when>
            <xsl:when test="starts-with($signatur, 'ADk')">ILN204/CG/UB/Altbau</xsl:when>

            <!-- Sammler schiebt alles andere zum Standort Unbekannt -->
            <xsl:otherwise>ILN204/CG/UB/Unbekannt</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$abt = '002'">
          <xsl:choose>
            <xsl:when test="starts-with($signatur, '002')">ILN204/CG/ZNL/Freihand</xsl:when>
            <xsl:when test="starts-with($signatur, '140')">ILN204/CG/ZNL/Mag</xsl:when>
            <!-- TBD -->
            <xsl:otherwise>ILN204/CG/ZNL/Freihand</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$abt = '005'">
          <xsl:choose>
            <xsl:when test="starts-with($signatur, '005')">ILN204/CG/ZHB/Freihand</xsl:when>
            <xsl:when test="starts-with($signatur, '205')">ILN204/CG/ZHB/Mag</xsl:when>
            <!-- TBD -->
            <xsl:otherwise>ILN204/CG/ZHB/Freihand</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$abt = '009'">ILN204/CG/ZP2/Freihand</xsl:when>
        <xsl:when test="$abt = '010'">ILN204/CG/ZRW/Freihand</xsl:when>
        <xsl:when test="$abt = '020'">ILN204/CG/ZRW/Freihand</xsl:when>

        <xsl:otherwise>ILN204/CD/DezFB/Fachbibliotheken</xsl:otherwise>
        <!-- Dezentrale FB als Catchall???  -->
      </xsl:choose>
    </permanentLocationId>
  </xsl:template>

</xsl:stylesheet>
