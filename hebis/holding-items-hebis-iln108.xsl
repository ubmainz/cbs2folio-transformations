<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>
  <xsl:key name="original" match="original/item" use="@epn"/>
     
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>  

  <!-- ILN 108 TH Bingen -->

  <xsl:template match="permanentLocationId">
    <xsl:variable name="i" select="key('original',.)"/>
    <xsl:variable name="signatur" select="$i/datafield[@tag='209A']/subfield[@code='a']"/>
    <xsl:variable name="electronicholding" select="(substring($i/../datafield[@tag='002@']/subfield[@code='0'],1,1) = 'O') and not(substring($i/datafield[@tag='208@']/subfield[@code='b'],1,1) = 'a')"/> 
    <!-- l nicht -->
    <permanentLocationId>
       <xsl:choose>
         <xsl:when test="$electronicholding">ONLINE</xsl:when>
         <xsl:when test="substring($i/datafield[@tag='208@']/subfield[@code='b'],1,1) = 'd'">DUMMY</xsl:when>
         <xsl:when test="starts-with($signatur,'Ab/')">ARCH</xsl:when>
         <xsl:when test="starts-with($signatur,'P/') or (substring($signatur,1,1)&lt;='9' and substring($signatur,1,1)&gt;='0') ">FREI</xsl:when> <!-- 0-9 P/ -->
         <xsl:when test="starts-with($signatur,'FB') or starts-with($signatur,'U/')">FB</xsl:when>
         <xsl:when test="starts-with($signatur,'K/') or starts-with($signatur,'KK/')">KP</xsl:when>
         <xsl:when test="starts-with($signatur,'Rara')">RARA</xsl:when>
         <xsl:when test="starts-with($signatur,'VW/')">VW</xsl:when>
         <xsl:otherwise>NZ</xsl:otherwise>
       </xsl:choose>
  </permanentLocationId>
  </xsl:template>

  <xsl:template match="permanentLoanTypeId">
    <permanentLoanTypeId>
      <xsl:choose>
        <xsl:when test="(.='dummy') or (.='aufsatz')">dummy</xsl:when>
        <xsl:when test="(.='') or (.='u')">u ausleihbar</xsl:when>
        <xsl:when test=".='s'">s Präsenzbestand</xsl:when>
        <xsl:when test=".='d'">d Zustimmung Wochenendausleihe</xsl:when>
        <xsl:when test=".='i'">i nur für den Lesesaal</xsl:when>
        <xsl:when test=".='e'">e vermisst</xsl:when>
        <xsl:when test=".='g'">g nicht ausleihbar</xsl:when>
        <xsl:when test=".='z'">z Verlust</xsl:when>
        <xsl:otherwise>unbekannt</xsl:otherwise>
      </xsl:choose>
    </permanentLoanTypeId>
  </xsl:template>

  <xsl:template match="discoverySuppress">
    <discoverySuppress>
      <xsl:value-of select="(substring(., 1, 4) = 'true') or (substring(., 1, 1) = 'g') or (substring(., 2, 1) = 'y') or (substring(., 2, 1) = 'z')"/>           
    </discoverySuppress>
  </xsl:template>

  <xsl:template match="i[holdingsNoteTypeId='Standort (8201)']"> <!-- 8201 will be displayed by default: add exceptions here -->
    <xsl:variable name="i" select="key('original',../../../permanentLocationId)"/>
    <xsl:variable name="signatur" select="$i/datafield[@tag='209A']/subfield[@code='a']"/>
    <xsl:if test="not(starts-with($signatur,'Ab/') or starts-with($signatur,'Rara'))">
      <i>
        <note>
          <xsl:value-of select="./note"/>
        </note>
        <xsl:copy-of select="*[name(.)!='note']"/>
      </i>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
