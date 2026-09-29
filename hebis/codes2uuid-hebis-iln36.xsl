<?xml version="1.0" encoding="UTF-8"?> 

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- ILN 36 LEIZA -->

  <!-- Map locations 
       For Mainz, the IDs are the location names in FOLIO, generated from 209A $f and other pica fields -->
  
  <xsl:template match="permanentLocationId|temporaryLocationId"> <!-- ILN 36 TBD -->
    <xsl:element name="{name()}">
      <xsl:choose>
        <xsl:when test=".='DUMMY'">de4046e6-d80a-474d-b81e-d5767f995dc6</xsl:when>

        <xsl:otherwise>91885c25-3b18-47d3-9cf6-5f6be2b396fb</xsl:otherwise> <!-- NZ -->
      </xsl:choose>
    </xsl:element>
  </xsl:template>



  <!-- Map loan types -->
  <xsl:template match="permanentLoanTypeId"> <!-- ILN TBD -->
    <permanentLoanTypeId>
       <xsl:choose>
       <xsl:when test=".='u ausleihbar (auch Fernleihe)'"><xsl:text>fdd9a986-ef76-4881-9858-ff24d9201da3</xsl:text></xsl:when> 
        <xsl:when test=".='b Kurzausleihe'"><xsl:text>478094a0-d87a-46bd-9951-c9cc8b64c453</xsl:text></xsl:when>
        <xsl:when test=".='c Lehrbuchsammlung'"><xsl:text>6ad0666d-f363-4446-b888-4689497779a6</xsl:text></xsl:when>
        <xsl:when test=".='s Präsenzbestand Lesesaal'"><xsl:text>1fa09d28-c954-4b32-a868-61490e5c7865</xsl:text></xsl:when>
        <xsl:when test=".='d ausleihbar (keine Fernleihe)'"><xsl:text>7221cc70-17be-47ae-af09-b542e5abdcad</xsl:text></xsl:when>
        <xsl:when test=".='i nur für den Lesesaal'"><xsl:text>4e2ea91f-5454-4bb8-92d7-3047fa748c03</xsl:text></xsl:when>
        <xsl:when test=".='e vermisst'"><xsl:text>771a4d7b-02f6-41ca-aa4a-13519c81fdd5</xsl:text></xsl:when>
        <xsl:when test=".='a bestellt'"><xsl:text>9d1acd95-39a3-48f2-9e45-a5c7b8fa7d0a</xsl:text></xsl:when>
        <xsl:when test=".='g nicht ausleihbar'"><xsl:text>e8ae51a4-5ec4-4c53-95ba-093e3d73d04f</xsl:text></xsl:when>
        <xsl:when test=".='z Verlust'"><xsl:text>eadbe1a0-b86f-4315-987b-7b707f976f40</xsl:text></xsl:when>
        <xsl:when test=".='dummy'"><xsl:text>02c0c444-96f7-4fbf-9488-5180ae7ad63f</xsl:text></xsl:when>
        <xsl:when test=".='unbekannt'"><xsl:text>3b16cade-fdeb-40d8-8f2b-e3495b6d321b</xsl:text></xsl:when>        
        <xsl:otherwise>3b16cade-fdeb-40d8-8f2b-e3495b6d321b</xsl:otherwise>
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
              <xsl:when test=".='Dublettenbereinigung'">812aef7b-f026-449e-8976-31883ad95d1b</xsl:when>
              <xsl:when test=".='ZDB-Titel-mit-Mono-EPN'">73abd902-87c7-4bad-bdfe-25cbc06b6e63</xsl:when>
              <xsl:when test=".='Ac'"><xsl:text>c85e824d-f439-47bf-a19c-720b6e1c7a30</xsl:text></xsl:when>
              <xsl:when test=".='Ad'"><xsl:text>0e1590f4-4daa-4e89-a6ba-a475e6039f38</xsl:text></xsl:when>
              <xsl:when test=".='Ab'"><xsl:text>7d4efe20-4197-408d-8242-764aa48e6907</xsl:text></xsl:when>
              <xsl:when test=".='AafF'"><xsl:text>9ff7fd00-347d-42e6-9b6b-3ef825085950</xsl:text></xsl:when>
              <xsl:when test=".='As'"><xsl:text>eb2eb4f5-d9b4-4dbf-8b20-22741037e495</xsl:text></xsl:when>
              <xsl:when test=".='Ob'"><xsl:text>a7632234-00b3-4ee2-a5dd-e719fdd76580</xsl:text></xsl:when>
              <xsl:when test=".='Oa'"><xsl:text>2ea6d8f4-099a-4e16-9878-a059282febd0</xsl:text></xsl:when>
              <xsl:when test=".='Os'"><xsl:text>a08156e5-7f00-4667-b3f9-60e06f179d7b</xsl:text></xsl:when>
              <xsl:when test=".='BafF'"><xsl:text>4c3b0a87-b445-4335-b7b9-fd406086102f</xsl:text></xsl:when>
              <xsl:when test=".='Bc'"><xsl:text>ec06720c-c3a7-484b-a2d5-777363cd39be</xsl:text></xsl:when>
              <xsl:when test=".='Bd'"><xsl:text>d6da08fd-e5f7-40f2-8d69-513ca494298c</xsl:text></xsl:when>
              <xsl:when test=".='Bs'"><xsl:text>4bc5c45b-52d2-415e-ae55-2c9b79560bdb</xsl:text></xsl:when>
              <xsl:when test=".='Bb'"><xsl:text>ed735e29-937a-4ca2-983e-8a5af1878945</xsl:text></xsl:when>
              <xsl:when test=".='C'"><xsl:text>95aa5c13-c9f2-4f35-b0e0-75abbf01ed66</xsl:text></xsl:when>
              <xsl:when test=".='EafF'"><xsl:text>1f724d22-5f79-4a95-a56f-c4016c80c02e</xsl:text></xsl:when>
              <xsl:when test=".='Ec'"><xsl:text>90f9ffe8-7af7-437c-aec3-d2549975ff3c</xsl:text></xsl:when>
              <xsl:when test=".='Ed'"><xsl:text>3697c409-7b3b-4be8-8fdf-ccac76f0b5b0</xsl:text></xsl:when>
              <xsl:when test=".='Es'"><xsl:text>a5d81b27-69d4-4128-a1a8-cce34d08b5e3</xsl:text></xsl:when>
              <xsl:when test=".='Eb'"><xsl:text>e4c221f3-cfa1-4de1-8ef0-a4a8a9d749bd</xsl:text></xsl:when>
              <xsl:when test=".='H'"><xsl:text>ba0bb45d-c8ff-4e51-b023-23adb982bb3b</xsl:text></xsl:when>
              <xsl:when test=".='SafF'"><xsl:text>6b6d9341-2bec-42fe-aab1-16cc7ac2fff0</xsl:text></xsl:when>
              <xsl:when test=".='Sc'"><xsl:text>b8363975-545f-4998-8c2e-90a805c1d84e</xsl:text></xsl:when>
              <xsl:when test=".='Sd'"><xsl:text>98564d81-a3a2-4d95-afdf-5a849be35068</xsl:text></xsl:when>
              <xsl:when test=".='Ss'"><xsl:text>f5c93073-298a-484c-bab8-8de1b0001355</xsl:text></xsl:when>
              <xsl:when test=".='Sb'"><xsl:text>c034e12e-993d-4da9-89d1-f057130d22a0</xsl:text></xsl:when>
              <xsl:when test=".='VZafF'"><xsl:text>f0ba98b5-6006-4b9b-bac1-b5e78d23b873</xsl:text></xsl:when>
              <xsl:when test=".='VZc'"><xsl:text>5c78d07c-47b6-4c1d-90e6-99fdcb0735c7</xsl:text></xsl:when>
              <xsl:when test=".='VZsbd'"><xsl:text>b67f1385-7790-4264-979c-64ad455b19bf</xsl:text></xsl:when>
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
        <xsl:when test=".='Produktsigel'"><xsl:text>bb307f6c-aae9-40f5-9a70-155064eee19d</xsl:text></xsl:when>
        <xsl:when test=".='Abrufzeichen'"><xsl:text>6d3f575d-6727-42a4-ae58-56c00de2e1d4</xsl:text></xsl:when>        
        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
      </xsl:choose>
    </holdingsNoteTypeId>
  </xsl:template>

</xsl:stylesheet>
