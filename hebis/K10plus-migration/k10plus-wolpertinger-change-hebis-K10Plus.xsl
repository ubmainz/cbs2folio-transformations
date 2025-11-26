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
    <xsl:variable name="hebppns-dist" select="distinct-values(original/datafield[@tag='006H']/subfield[@code='0'])"/> <!-- weitere Hebis-PPN -->
    <xsl:variable name="hebgewinner" select="original/datafield[@tag='003H']/subfield[@code='0'][1]"/>
    <xsl:if test="$hebgewinner">
      <record>
        <xsl:copy-of select="$currentrecord/processing"/>
        <instance>
          <source>K10plus</source>
          <hrid><xsl:value-of select="$hebgewinner"/></hrid>
          <xsl:apply-templates select="$currentrecord/instance/*[not(self::hrid or self::source or self::administrativeNotes)]"/>
          <administrativeNotes>
            <arr>
              <xsl:apply-templates select="$currentrecord/instance/administrativeNotes/arr/*"/>
              <i>
                <xsl:text>Wolpertinger</xsl:text>
              </i>
            </arr>
          </administrativeNotes>
        </instance>
        <!-- instance relations entfallen und kommen mit K10plus wieder -->
        <xsl:apply-templates select="$currentrecord/holdingsRecords"/> <!-- Gewinner: Holding und Items -->
      </record>
      <xsl:for-each select="$hebppns-dist"> <xsl:if test=".!=$hebgewinner"> <!-- Verlierer -->
        <record>
          <xsl:copy-of select="$currentrecord/processing"/>
            <instance>
              <source>K10plus</source>
              <hrid><xsl:value-of select="."/></hrid>
              <xsl:apply-templates select="$currentrecord/instance/*[not(self::hrid or self::source or self::administrativeNotes)]"/>
              <administrativeNotes>
                <arr>
                  <xsl:apply-templates select="$currentrecord/instance/administrativeNotes/arr/*"/>
                  <i>
                    <xsl:text>Wolpertinger für Hebis-PPN: </xsl:text><xsl:value-of select="."/>
                  </i>
                  <i>
                    <xsl:text>Verlierer wird gelöscht: keine Holdings oder Items</xsl:text>
                  </i>
                </arr>
              </administrativeNotes>
                <statisticalCodeIds>
                  <arr>
                    <i>Dublettenbereinigung</i>
                  </arr>
                </statisticalCodeIds>
            </instance>
            <!-- instance relations entfallen und kommen mit K10plus wieder -->
            <!-- Verlierer: keine Holdings -->
        </record> </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template match="holdingsRecords/arr/i[not(formerIds/arr/i[2])]/hrid">
    <hrid><xsl:value-of select="substring-after(.,'HEB')"/></hrid>
  </xsl:template>

  <xsl:template match="holdingsRecords/arr/i[formerIds/arr/i[2]]/hrid">
    <hrid><xsl:value-of select="substring-after(../formerIds/arr/i[2],'HEB')"/></hrid>
  </xsl:template>

  <xsl:template match="items/arr/i[not(formerIds/arr/i[2])]/hrid">
    <hrid><xsl:value-of select="substring-after(.,'HEB')"/></hrid>
  </xsl:template>

  <xsl:template match="items/arr/i[formerIds/arr/i[2]]/hrid">
    <hrid><xsl:value-of select="substring-after(../formerIds/arr/i[2],'HEB')"/></hrid>
  </xsl:template>

</xsl:stylesheet>