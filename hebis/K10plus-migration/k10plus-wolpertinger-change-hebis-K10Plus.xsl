<?xml version="1.0" encoding="UTF-8"?>
<!-- date of last edit: 2023-06-16 (YYYY-MM-DD) -->

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
            <xsl:copy-of select="$currentrecord/instance/*[not(self::hrid or self::source)]"></xsl:copy-of>
          </instance>
          <!-- instance relations? -->        
      </record>
    </xsl:for-each>
    
  </xsl:template>

  <xsl:template match="source">
    <source>K10plus</source>
  </xsl:template>
 
</xsl:stylesheet>
