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
    <xsl:variable name="abt" select="$i/datafield[@tag='209A']/subfield[@code='f']"/>
    <xsl:variable name="standort" select="$i/datafield[(@tag='209G') and (subfield[@code='x']='01')]/subfield[@code='a']"/> 
    <xsl:variable name="electronicholding" select="(substring($i/../datafield[@tag='002@']/subfield[@code='0'],1,1) = 'O') and not(substring($i/datafield[@tag='208@']/subfield[@code='b'],1,1) = 'a')"/>
    <xsl:variable name="onorder" select="substring($i/datafield[@tag='208@']/subfield[@code='b'],1,1) = 'a'"/>
    <permanentLocationId>
       <xsl:choose>
         <xsl:when test="$electronicholding">ONLINE</xsl:when>
         <xsl:when test="substring($i/datafield[@tag='208@']/subfield[@code='b'],1,1) = 'd'">DUMMY</xsl:when>
         <xsl:when test="(substring($i/../datafield[@tag='002@']/subfield[@code='0'],2,1) = 'o') and not($i/datafield[@tag='209A']/subfield[@code='d'])">AUFSATZ</xsl:when>
         <xsl:when test="$abt='000'">
           <xsl:choose>
             <xsl:when test="$onorder">ZBZEB</xsl:when>
             <xsl:when test="contains($standort,'Lesesaal')">LS</xsl:when>

             <xsl:otherwise>ZBMAG</xsl:otherwise>
           </xsl:choose>
         </xsl:when>

         <xsl:otherwise>UNKNOWN</xsl:otherwise>
       </xsl:choose>
      </permanentLocationId>
  </xsl:template>

  <xsl:template match="permanentLoanTypeId">
    <permanentLoanTypeId>
      <xsl:choose>
        <xsl:when test="(.='dummy') or (.='aufsatz')">dummy</xsl:when>
        <xsl:when test="(.='') or (.='u')">u ausleihbar (auch Fernleihe)</xsl:when>
        <xsl:when test=".='b'">b Kurzausleihe</xsl:when>
        <xsl:when test=".='c'">c Lehrbuchsammlung</xsl:when>
        <xsl:when test=".='s'">s Präsenzbestand Lesesaal</xsl:when>
        <xsl:when test=".='d'">d ausleihbar (keine Fernleihe)</xsl:when>
        <xsl:when test=".='i'">i nur für den Lesesaal</xsl:when>
        <xsl:when test=".='e'">e vermisst</xsl:when>
        <xsl:when test=".='g'">g nicht ausleihbar</xsl:when>
        <xsl:when test=".='a'">a bestellt</xsl:when>
        <xsl:when test=".='z'">z Verlust</xsl:when>
        <xsl:when test=".='1'">1 Fernleihe - ausleihbar ohne Verl.</xsl:when>
        <xsl:when test=".='2'">2 Fernleihe - ausleihbar mit Verl.</xsl:when>
        <xsl:when test=".='3'">3 Fernleihe - Kurzausleihe ohne Verl.</xsl:when>
        <xsl:otherwise>unbekannt</xsl:otherwise>
      </xsl:choose>
    </permanentLoanTypeId>
  </xsl:template>

  <xsl:template match="discoverySuppress"> <!-- add: substring(., 1, 4) = 'true') or -->
    <discoverySuppress>
      <xsl:value-of select="(substring(., 1, 4) = 'true') or (substring(., 1, 1) = 'g') or (substring(., 2, 1) = 'y') or (substring(., 2, 1) = 'z')"/>           
    </discoverySuppress>
  </xsl:template>

<!-- Parsing call number for prefix - optional -->

  <xsl:template match="callNumber">
    <xsl:variable name="i" select="key('original',../permanentLocationId)"/>
    <xsl:variable name="abt" select="$i/datafield[@tag='209A']/subfield[@code='f']"/>
    <xsl:variable name="standort" select="$i/datafield[(@tag='209G') and (subfield[@code='x']='01')]/subfield[@code='a']"/> 
    <xsl:choose>
      <xsl:when test="($abt='000' and (starts-with(., 'RARA ') and not(contains(.,'°')))) or
        ($abt='003') or ($abt='004')">
        <xsl:choose>
          <xsl:when test="contains(.,' ')">
            <callNumberPrefix>
              <xsl:value-of select="normalize-space(substring-before(.,' '))"/>
            </callNumberPrefix>
            <callNumber>
              <xsl:value-of select="normalize-space(substring-after(.,' '))"/>
            </callNumber>
          </xsl:when>
          <xsl:otherwise>
            <callNumberPrefix/>
            <callNumber>
              <xsl:value-of select="."/>
            </callNumber>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="cnprefix">
          <xsl:choose>
            <xsl:when test="contains(.,'°')">
              <xsl:value-of select="concat(substring-before(.,'°'),'°')"/>
            </xsl:when>
            <xsl:when test="contains(.,'@')">
              <xsl:value-of select="substring-before(.,'@')"/> 
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <callNumberPrefix>
          <xsl:value-of select="normalize-space(translate($cnprefix,'@',''))"/>
        </callNumberPrefix>
        <callNumber>
          <xsl:value-of select="normalize-space(translate(substring-after(.,$cnprefix),'@',''))"/>
        </callNumber>
      </xsl:otherwise>
    </xsl:choose>
   </xsl:template>

</xsl:stylesheet>
