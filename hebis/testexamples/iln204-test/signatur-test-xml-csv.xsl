<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">    
    <xsl:output method="text"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="test-signatures">
        <xsl:text>Signatur|Abt|PPN|Standort</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="permanentLocationId">
        <xsl:value-of select="@source-signature"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="@source-abt"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="@source-ppn"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
</xsl:stylesheet>