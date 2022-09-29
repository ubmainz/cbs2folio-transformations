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

  <xsl:template name="check-range">
    <!-- See https://weinert-automation.de/pub/XSLT1.0RangeFilter.pdf -->
    <xsl:param name="signatur-short-lowercase"/>
    <xsl:param name="lbs-range-start"/>
    <xsl:param name="lbs-range-end"/>
    <xsl:param name="i" select="1"/>
    <xsl:param name="o" select="1"/>
    <xsl:variable name="sortChar">'0123456789aäbcdefghijklmnoöpqrsßtuüvwxyz'</xsl:variable>
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

    <xsl:if test="string-length($signatur-short-lowercase) > 1">
      <xsl:choose>
        <xsl:when
          test="$i > string-length($signatur-short-lowercase) and $o > string-length($signatur-short-lowercase)">
          <xsl:value-of select="1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="idFrst">
            <xsl:value-of select="substring($signatur-short-lowercase, $i, 1)"/>
          </xsl:variable>
          <xsl:variable name="idCmp">
            <xsl:value-of select="string-length(substring-before($sortChar, $idFrst))"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$idCmp >= $frmCmp and $befCmp >= $idCmp">
              <xsl:call-template name="check-range">
                <xsl:with-param name="signatur-short-lowercase" select="$signatur-short-lowercase"/>
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

  <xsl:template name="get-location-by-range">
    <xsl:param name="signatur-lowercase"/>
    <xsl:param name="range-list"/>
    <xsl:param name="last-range"/>
    <xsl:param name="in-range" select="0"/>
    <xsl:param name="default-location" select="'Unbekannter Standort'"/>
    <xsl:variable name="first-range" select="$range-list[1]"/>
    <xsl:choose>
      <xsl:when test="$in-range = 1">
        <xsl:value-of select="$last-range/@location"/>
      </xsl:when>
      <xsl:when test="$in-range = 0">
        <xsl:choose>
          <xsl:when test="$range-list">
            <xsl:call-template name="get-location-by-range">
              <xsl:with-param name="signatur-lowercase" select="$signatur-lowercase"/>
              <xsl:with-param name="last-range" select="$range-list[1]"/>
              <xsl:with-param name="range-list" select="$range-list[position() != 1]"/>
              <xsl:with-param name="in-range">
                <xsl:call-template name="check-range">
                  <xsl:with-param name="signatur-short-lowercase">
                    <!-- shorten signatur and add leading zeros -->
                    <xsl:call-template name="format-signatur">
                      <xsl:with-param name="signatur-short-lowercase">
                        <xsl:value-of
                          select="substring($signatur-lowercase, 1, string-length($first-range/@to))"
                        />
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:with-param>
                  <xsl:with-param name="lbs-range-start">
                    <xsl:call-template name="fill-range">
                      <xsl:with-param name="range-string" select="$first-range/@from"/>
                      <xsl:with-param name="range-length" select="string-length($first-range/@to)"/>
                    </xsl:call-template>
                  </xsl:with-param>
                  <xsl:with-param name="lbs-range-end">
                    <xsl:call-template name="fill-range">
                      <xsl:with-param name="range-string" select="$first-range/@to"/>
                      <xsl:with-param name="range-length" select="string-length($first-range/@from)"
                      />
                    </xsl:call-template>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$default-location"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
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

  <xsl:template name="format-signatur">
    <xsl:param name="signatur-short-lowercase"/>
    <xsl:variable name="delimiter" select="' '"/>
    <xsl:choose>
      <xsl:when test="$delimiter and contains($signatur-short-lowercase, $delimiter)">
        <xsl:call-template name="add-leading-zeros">
          <xsl:with-param name="signatur-token" select="$signatur-short-lowercase"/>
        </xsl:call-template>
        <xsl:text>-</xsl:text>
        <xsl:call-template name="format-signatur">
          <xsl:with-param name="signatur-short-lowercase"
            select="substring-after($signatur-short-lowercase, $delimiter)"/>
          <xsl:with-param name="delimiter" select="$delimiter"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="add-leading-zeros">
          <xsl:with-param name="signatur-token" select="$signatur-short-lowercase"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="add-leading-zeros">
    <xsl:param name="signatur-token"/>
    <xsl:choose>
      <xsl:when test="string(number($signatur-token)) = 'NaN'">
        <xsl:value-of select="$signatur-token"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="format-number($signatur-token, '#####0')"/>
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

  <xsl:template match="testsignatur">
    <xsl:variable name="signatur" select="."/>
    <xsl:variable name="abt" select="substring($signatur, 1, 3)"/>
    <xsl:variable name="signatur-lowercase" select="
        translate(
        substring($signatur, 5),
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'abcdefghijklmnopqrstuvwxyz')"/>
    <xsl:variable name="lookup-LBS-ranges" select="document('lbs-ranges-iln204.xml')"/>
    <permanentLocationId>
      <xsl:choose>
        <xsl:when test="$abt = '009'">ILN204/CG/ZP2/Freihand</xsl:when>
        <xsl:when test="$abt = '010'">ILN204/CG/ZRW/Freihand</xsl:when>
        <xsl:when test="$abt = '020'">ILN204/CG/ZRW/Freihand</xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="signatur-eingabe">
            <xsl:value-of select="$signatur"/>
          </xsl:attribute>
          <xsl:variable name="beginning-match">
            <xsl:for-each select="$lookup-LBS-ranges/lbs-ranges/department[@code = $abt]/beginning">
              <xsl:variable name="beginning-zeroless">
                <xsl:call-template name="remove-leading-zeros">
                  <xsl:with-param name="range-string">
                    <xsl:value-of select="./text()"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:variable>
              <xsl:if test="starts-with($signatur-lowercase, $beginning-zeroless)">
                <xsl:value-of select="./@location"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$beginning-match != ''">
              <xsl:value-of select="$beginning-match"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="get-location-by-range">
                <xsl:with-param name="signatur-lowercase" select="$signatur-lowercase"/>
                <xsl:with-param name="range-list"
                  select="$lookup-LBS-ranges/lbs-ranges/department[@code = $abt]/range"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </permanentLocationId>
  </xsl:template>
</xsl:stylesheet>
