<?xml version="1.0" encoding="UTF-8"?> 

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- ILN 108 TH Bingen -->
 
  <xsl:template match="permanentLocationId"> <!-- ILN -->
    <permanentLocationId>
      <xsl:choose>
        <xsl:when test=".='DUMMY'">87764786-c5c8-47d0-a480-df506c751d76</xsl:when>
        <xsl:when test=".='AUFSATZ'">c5d96d68-ffc8-49a4-b43c-42d82f719ea9</xsl:when>

        <xsl:when test=".='LS'">c23399ef-6776-4442-a53a-dfca759c3b9f</xsl:when>

        <xsl:when test=".='ZBZEB'">802ea709-f017-49e7-9795-5fa0053668cb</xsl:when>
        <xsl:otherwise>413fe054-a4f3-423e-a62f-088eb111ea8d</xsl:otherwise> <!-- ZBMAG -->
      </xsl:choose>
    </permanentLocationId>
  </xsl:template>

  <!-- Map loan types -->
  <xsl:template match="permanentLoanTypeId"> <!-- ILN -->
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

</xsl:stylesheet>
