<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

  <xsl:variable name="version" select="'v4'"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="record[delete]"/> <!-- no delete -->
  
  <xsl:template match="record">
    <xsl:variable name="currentrecord" select="."/> <!-- 003H Primäre Hebis-PPN -->
    <xsl:variable name="hebppns-dist" select="distinct-values(original/datafield[@tag='006H']/subfield[@code='0'])"/> <!-- weitere Hebis-PPN -->
    <xsl:variable name="hebppn" select="(original/datafield[@tag='003H']/subfield[@code='0'])[1]"/>
    <xsl:variable name="hebgewinner" select="($hebppn,concat('KXP',$currentrecord/instance/hrid))[1]"/>
    <xsl:variable name="hebppns" select="if (index-of($hebppns-dist,$hebgewinner)) then remove($hebppns-dist,index-of($hebppns-dist,$hebgewinner)) else $hebppns-dist" />
    <record>
      <xsl:variable name="epns-ohne-hebis" select="distinct-values($currentrecord/holdingsRecords/arr/i[starts-with(formerIds/arr/i[2],'KXP')]/hrid)"/>
      <xsl:variable name="hebepns" select="distinct-values($currentrecord/holdingsRecords/arr/i/formerIds/arr/i[2])"/>
      <xsl:copy-of select="$currentrecord/processing"/>
       <instance>
        <hrid><xsl:value-of select="$hebgewinner"/></hrid>
        <xsl:apply-templates select="$currentrecord/instance/*[not(self::hrid or self::administrativeNotes)]"/>
        <administrativeNotes>
          <arr>
            <xsl:apply-templates select="$currentrecord/instance/administrativeNotes/arr/*"/>
            <i>
              <xsl:text>Wolpertinger </xsl:text><xsl:value-of select="$version"/>
              <xsl:if test="$hebppns">
                <xsl:text> - Dubletten-PPN (Hebis): </xsl:text><xsl:value-of select="$hebppns" separator=", "/>
              </xsl:if>
            </i>
            <xsl:if test="not(empty($epns-ohne-hebis))">
              <i>
                <xsl:text>Uffbasse! K10plus-EPNs ohne Hebis-EPN: KXP... </xsl:text><xsl:value-of select="$epns-ohne-hebis" separator=", "/>
              </i> 
            </xsl:if>
          </arr>
        </administrativeNotes>
      </instance>
      <!-- instance relations entfallen und kommen mit K10plus wieder -->
      <xsl:choose> <!-- Gewinner: Holding und Items -->
        <xsl:when test="empty($hebepns)">
          <xsl:apply-templates select="$currentrecord/holdingsRecords"/>
        </xsl:when>
        <xsl:otherwise>
          <holdingsRecords>
            <arr>
              <xsl:for-each select="$hebepns">
                <xsl:apply-templates select="($currentrecord/holdingsRecords/arr/i[formerIds/arr/i[2]=current()])[1]"/>
              </xsl:for-each>
            </arr>
          </holdingsRecords>
        </xsl:otherwise>
      </xsl:choose>
    </record>
    <xsl:for-each select="$hebppns"> <!-- Verlierer -->
      <record>
        <xsl:copy-of select="$currentrecord/processing"/>
          <instance>
            <hrid><xsl:value-of select="."/></hrid>
            <identifiers>
              <arr>
                <xsl:apply-templates select="$currentrecord/instance/identifiers/arr/i[not((identifierTypeId='PPN-K10plus') or (identifierTypeId='PPN-Hebis'))]"/>
              </arr>
            </identifiers>
            <xsl:apply-templates select="$currentrecord/instance/*[not(self::hrid or self::administrativeNotes or self::identifiers)]"/>
            <administrativeNotes>
              <arr>
                <xsl:apply-templates select="$currentrecord/instance/administrativeNotes/arr/*"/>
                <i>
                  <xsl:text>Wolpertinger </xsl:text><xsl:value-of select="$version"/><xsl:text> für Hebis-PPN: </xsl:text><xsl:value-of select="."/>
                </i>
                <i>
                  <xsl:text>Dublette - wird gelöscht: keine Bestände</xsl:text>
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
          <!-- Verlierer: keine Holdings, kein K10plus PPN -->
      </record>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="holdingsRecords/arr/i[not(formerIds/arr/i[2])]/hrid">
    <hrid><xsl:value-of select="if (starts-with(.,'HEB')) then substring-after(.,'HEB') else ."/></hrid>
  </xsl:template>

  <xsl:template match="holdingsRecords/arr/i[formerIds/arr/i[2]]/hrid">
    <hrid><xsl:value-of select="if (starts-with(../formerIds/arr/i[2],'HEB')) then substring-after(../formerIds/arr/i[2],'HEB') else ../formerIds/arr/i[2]"/></hrid>
  </xsl:template>

  <xsl:template match="items/arr/i[not(formerIds/arr/i[2])]/hrid">
    <hrid><xsl:value-of select="if (starts-with(.,'HEB')) then substring-after(.,'HEB') else ."/></hrid>
  </xsl:template>

  <xsl:template match="items/arr/i[formerIds/arr/i[2]]/hrid">
    <hrid><xsl:value-of select="if (starts-with(../formerIds/arr/i[2],'HEB')) then substring-after(../formerIds/arr/i[2],'HEB') else ../formerIds/arr/i[2]"/></hrid>
  </xsl:template>

</xsl:stylesheet>