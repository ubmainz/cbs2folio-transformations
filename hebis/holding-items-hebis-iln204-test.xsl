<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl="http://exslt.org/common" version="1.0"
  exclude-result-prefixes="exsl">
  
  <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>
  <xsl:key name="original" match="original/item" use="@epn"/>

  <!-- copy template -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- ILN 204 UB Gießen: holding-items-hebis-iln204.xsl -->
  <!-- ================================================= -->

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
              <xsl:with-param name="range-end" select="$range-to"/>--> </xsl:call-template>
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

  <xsl:template match="test-signature">
    <permanentLocationId>
      
      <xsl:variable name="abt" select="substring(., 1, 3)"/>
    <xsl:variable name="signature" select="substring(., 5)"/>
    <xsl:variable name="signature-lowercase" select="
      translate($signature,
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
      'abcdefghijklmnopqrstuvwxyz')"/>

      <xsl:attribute name="source-signature">
        <xsl:value-of select="$signature"/>
      </xsl:attribute>
      
      <xsl:variable name="location-prefix-match">
      <xsl:call-template name="get-location-by-prefix">
        <xsl:with-param name="signature-lowercase" select="$signature-lowercase"/>
        <xsl:with-param name="prefix-list"
          select="document('lbs-ranges-iln204.xml')/ranges/department[@code = $abt]/prefix"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="$location-prefix-match = ''">
        <xsl:call-template name="get-location-by-range">
          <xsl:with-param name="signature-lowercase" select="$signature-lowercase"/>
          <xsl:with-param name="range-list"
            select="document('lbs-ranges-iln204.xml')/ranges/department[@code = $abt]/range"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$location-prefix-match"/>
      </xsl:otherwise>
    </xsl:choose>
    </permanentLocationId>    
  </xsl:template>
</xsl:stylesheet>
