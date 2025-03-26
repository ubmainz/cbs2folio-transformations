<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="record">
    <xsl:variable name="currentrecord" select="."/>
    <xsl:variable name="hebppns" select="original/datafield[@tag='003H']/subfield[@code='0']|original/datafield[@tag='006H']/subfield[@code='0']"/>
    <xsl:for-each select="distinct-values($hebppns)">
      <record>
        <xsl:copy-of select="$currentrecord/processing"/>
          <instance>
            <hrid><xsl:value-of select="."/></hrid>
            <source>K10plus</source>
            <xsl:apply-templates select="$currentrecord/instance/*[not(self::hrid or self::source)]"/>
          </instance>
          <!-- instance relations? -->        
      </record>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="notes">
    <notes>
      <arr>
        <i>
          <note>Wolpertingerdatensatz aus K10plus-PPN <xsl:value-of select="../../original/datafield[@tag='003@']/subfield[@code='0']"/></note>
          <instanceNoteTypeId>Local notes</instanceNoteTypeId>
        </i>
        <xsl:apply-templates select="arr/*"/>
      </arr>
    </notes>
  </xsl:template>

</xsl:stylesheet>
