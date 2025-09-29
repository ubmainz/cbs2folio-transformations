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
    <xsl:variable name="hebppns" select="original/datafield[@tag='003H']/subfield[@code='0'],original/datafield[@tag='006H']/subfield[@code='0']"/>
    <!-- <xsl:variable name="hebppns-dist" select="$hebppns"/> --> <xsl:variable name="hebppns-dist" select="distinct-values($hebppns)"/>
    <xsl:for-each select="$hebppns-dist">
      <record>
        <xsl:copy-of select="$currentrecord/processing"/>
          <instance>
            <source>K10plus</source>
            <hrid><xsl:value-of select="concat('HEB',.)"/></hrid>
            <!-- <hrid><xsl:value-of select="."/></hrid> ohne HEB -->
            <xsl:apply-templates select="$currentrecord/instance/*[not(self::hrid or self::source or self::administrativeNotes)]"/>
            <administrativeNotes>
              <arr>
                <xsl:apply-templates select="$currentrecord/instance/administrativeNotes/arr/*"/>
                <i>
                  <xsl:text>Wolpertinger</xsl:text>
                  <xsl:if test="not(.=$currentrecord/original/datafield[@tag='003H']/subfield[@code='0'])"><xsl:value-of select="concat(' für Hebis-PPN: ',.)"/></xsl:if>
                </i>
              </arr>
            </administrativeNotes>
            <xsl:if test="$hebppns-dist[2]"> <!-- Hebis-Dubletten -->
                <xsl:if test="position()>1"> <!-- Verlierer-Datensatz - werden gelöscht -->
                  <statisticalCodeIds>
                    <arr>
                      <i>Dublettenbereinigung</i>
                    </arr>
                  </statisticalCodeIds>
                </xsl:if>
            </xsl:if>
          </instance>
          <!-- instance relations entfallen und kommen mit K10plus wieder -->
        <xsl:if test="position()=1"> <!-- Einzeldatensatz oder Gewinner -->
          <xsl:apply-templates select="$currentrecord/holdingsRecords"/>
        </xsl:if>        
      </record>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="holdingsRecords/arr/i[formerIds/arr/i[2]]/hrid">
    <hrid><xsl:value-of select="../formerIds/arr/i[2]"/></hrid>
  </xsl:template>
  
  <xsl:template match="items/arr/i[formerIds/arr/i[2]]/hrid">
    <hrid><xsl:value-of select="../formerIds/arr/i[2]"/></hrid>
  </xsl:template>

</xsl:stylesheet>