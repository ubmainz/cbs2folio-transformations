<?xml version="1.0" encoding="UTF-8"?> 

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- ILN 49 HS Mainz -->

  <!-- Map locations 
       For Mainz, the IDs are the location names in FOLIO, generated from 209A $f and other pica fields -->
  
  <xsl:template match="permanentLocationId|temporaryLocationId"> <!-- ILN -->
    <xsl:element name="{name()}">
      <xsl:choose>
        <xsl:when test=".='DUMMY'"></xsl:when>
        <xsl:when test=".='FBVW'"></xsl:when>
        <xsl:when test=".='GROSS'"></xsl:when>
        <xsl:when test=".='MAG'"></xsl:when>
        <xsl:when test=".='NZ'"></xsl:when>
        <xsl:when test=".='OGALLG'"></xsl:when>
        <xsl:when test=".='OGARCH'"></xsl:when>
        <xsl:when test=".='OGBAU'"></xsl:when>
        <xsl:when test=".='OGBWL'"></xsl:when>
        <xsl:when test=".='OGG'"></xsl:when>
        <xsl:when test=".='OGL'"></xsl:when>
        <xsl:when test=".='OGN'"></xsl:when>
        <xsl:when test=".='OGR'"></xsl:when>
        <xsl:when test=".='OGS'"></xsl:when>
        <xsl:when test=".='OGV'"></xsl:when>
        <xsl:when test=".='ONLINE'"></xsl:when>
        <xsl:when test=".='SEMAPP'"></xsl:when>
        <xsl:when test=".='THEKE'"></xsl:when>
        <xsl:when test=".='UGG'"></xsl:when>
        <xsl:when test=".='UGK'"></xsl:when>
        <xsl:when test=".='UGMED'"></xsl:when>
        <xsl:when test=".='UGV'"></xsl:when>
        <xsl:when test=".='UGZS'"></xsl:when>
        <xsl:when test=".='ZEB'"></xsl:when>
        <xsl:otherwise></xsl:otherwise> <!-- NZ -->
      </xsl:choose>
    </xsl:element>
  </xsl:template>



  <!-- Map loan types -->
  <xsl:template match="permanentLoanTypeId"> <!-- ILN TBD -->
    <permanentLoanTypeId>
      <xsl:choose>
        <xsl:when test=".='u ausleihbar (auch Fernleihe)'"><xsl:text>7a03b2e2-c995-47a4-83d0-04bbe1930af4</xsl:text></xsl:when> 
        <xsl:when test=".='b Kurzausleihe'"><xsl:text>df64c252-595d-463c-aad8-3bda0ba101aa</xsl:text></xsl:when>
        <xsl:when test=".='c Lehrbuchsammlung'"><xsl:text>d1ba00c9-3f08-4df9-9d70-c7e1ab3b1702</xsl:text></xsl:when>
        <xsl:when test=".='s Präsenzbestand Lesesaal'"><xsl:text>1cecc65a-a7c4-437a-bb04-6756c23b422e</xsl:text></xsl:when>
        <xsl:when test=".='d ausleihbar (keine Fernleihe)'"><xsl:text>31c550e8-86b7-4674-bab0-7011ba94148e</xsl:text></xsl:when>
        <xsl:when test=".='i nur für den Lesesaal'"><xsl:text>e04e82c1-1257-4046-bc5e-d742bbe061da</xsl:text></xsl:when>
        <xsl:when test=".='e vermisst'"><xsl:text>cbd4ec80-1622-420e-8b7c-644b04109367</xsl:text></xsl:when>
        <xsl:when test=".='a bestellt'"><xsl:text>8cef8fa7-0a78-4bdd-84d3-25ce207ef8c8</xsl:text></xsl:when>
        <xsl:when test=".='g nicht ausleihbar'"><xsl:text>20c359cb-b422-47cc-8c40-e8f6655f2b70</xsl:text></xsl:when>
        <xsl:when test=".='Test'"><xsl:text>3b23397c-93ec-40ad-bb8a-9113f9fe9de2</xsl:text></xsl:when>
        <xsl:when test=".='z Verlust'"><xsl:text>661ffe64-2e47-4203-845f-96d820aa48f2</xsl:text></xsl:when>
        <xsl:when test=".='1 Fernleihe - ausleihbar ohne Verl.'"><xsl:text>fb17e0b8-75cc-4ea2-a7ac-87bb53d146f9</xsl:text></xsl:when>
        <xsl:when test=".='2 Fernleihe - ausleihbar mit Verl.'"><xsl:text>370d3831-a948-4e46-9499-5ddea2f26150</xsl:text></xsl:when>
        <xsl:when test=".='3 Fernleihe - Kurzausleihe ohne Verl.'"><xsl:text>e6608ce5-4a46-4497-b15d-e28378a9b29c</xsl:text></xsl:when>
        <xsl:when test=".='dummy'"><xsl:text>80ff439c-3ccb-48df-9758-c11011cef6d0</xsl:text></xsl:when>
        <xsl:when test=".='unbekannt'"><xsl:text>39176004-0e64-4d06-b136-7140e7016298</xsl:text></xsl:when>        
        <xsl:otherwise>39176004-0e64-4d06-b136-7140e7016298</xsl:otherwise> <!-- unbekannt -->
      </xsl:choose>
    </permanentLoanTypeId>
  </xsl:template>

  <!-- Map identifier types -->
  <xsl:template match="identifierTypeId"> <!-- additional RLP -->
    <identifierTypeId>
      <xsl:choose>
        <xsl:when test=".='PPN-K10plus'"><xsl:text>98e4039e-adfe-405f-b763-c642765269df</xsl:text></xsl:when>
        <xsl:when test=".='PPN-Hebis'"><xsl:text>be3a2669-391d-4027-b023-1092a61ac631</xsl:text></xsl:when>
        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
      </xsl:choose>
    </identifierTypeId>
  </xsl:template>

  <!-- Map statistical code ids -->
  <xsl:template match="statisticalCodeIds"> <!-- ILN --> <!-- TBD: generate -->
    <statisticalCodeIds>
      <arr>
        <xsl:for-each select="arr/i">
          <i>
            <xsl:choose>
              <xsl:when test=".='LZA'">25c91085-8b64-47ea-9cb8-20dd539ac466</xsl:when>
              <xsl:when test=".='Dublettenbereinigung'">812aef7b-f026-449e-8976-31883ad95d1b</xsl:when>
              <xsl:when test=".='ZDB-Titel-mit-Mono-EPN'">73abd902-87c7-4bad-bdfe-25cbc06b6e63</xsl:when>
            </xsl:choose>
          </i>
        </xsl:for-each>
      </arr>
    </statisticalCodeIds>
  </xsl:template>

  <!-- Map holding note types -->
  <xsl:template match="holdingsNoteTypeId"> <!-- Level 2: FOLIO/hebis-wide -->
    <holdingsNoteTypeId>
      <xsl:choose>
        <xsl:when test=".='Abrufzeichen'"><xsl:text>6d3f575d-6727-42a4-ae58-56c00de2e1d4</xsl:text></xsl:when>        
        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
      </xsl:choose>
    </holdingsNoteTypeId>
  </xsl:template>

</xsl:stylesheet>
