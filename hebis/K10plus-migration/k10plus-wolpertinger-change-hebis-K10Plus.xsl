<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="record[delete]"/> <!-- no delete -->
  
  <xsl:template match="record">
    <xsl:variable name="currentrecord" select="."/> <!-- 003H Primäre Hebis-PPN -->
    <xsl:variable name="hebppns" select="original/datafield[@tag='003H']/subfield[@code='0']|original/datafield[@tag='006H']/subfield[@code='0']"/>
    <xsl:variable name="hebppns-dist" select="distinct-values($hebppns)"/>
    <xsl:for-each select="$hebppns-dist">
      <record>
        <xsl:copy-of select="$currentrecord/processing"/>
          <instance>
            <source>K10plus</source>
            <hrid><xsl:value-of select="."/></hrid>
            <xsl:choose>
              <xsl:when test=".=$currentrecord/original/datafield[@tag='003H']/subfield[@code='0']">
                <matchKey><xsl:value-of select="$currentrecord/original/datafield[@tag='003@']/subfield[@code='0']"/></matchKey>
              </xsl:when>
              <xsl:otherwise>
                <matchKey/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="$currentrecord/instance/*[not(self::hrid or self::source or self::administrativeNotes)]"/>
            <administrativeNotes>
              <arr>
                <xsl:apply-templates select="$currentrecord/instance/administrativeNotes/arr/*"/>
                <i><xsl:value-of select="concat('Wolpertingerdatensatz K10plus-PPN: ',$currentrecord/original/datafield[@tag='003@']/subfield[@code='0'],
                    ' hebis-PPN: ',.,' - Instanz aus K10plus')"/></i>
              </arr>
            </administrativeNotes>
            <xsl:if test="$hebppns-dist[2]">
              <statisticalCodeIds>
                <arr>
                    <i>Dublettenbereinigung</i>
                </arr>
              </statisticalCodeIds>
            </xsl:if>
          </instance>
          <!-- instance relations? -->
          <xsl:apply-templates select="$currentrecord/holdingsRecords"/>        
      </record>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
