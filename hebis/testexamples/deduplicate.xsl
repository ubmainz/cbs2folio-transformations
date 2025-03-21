<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>
    <xsl:key name="original" match="original/item" use="@epn"/>

    <xsl:template match="/">
        <collection>
            <xsl:for-each-group select="//record" group-by="hrid">
                <xsl:message><xsl:value-of select="current-grouping-key()"/> :  <xsl:value-of select="count(current-group())"/></xsl:message>
                <xsl:copy-of select="current-group()[1]"/>
            </xsl:for-each-group>
        </collection>
    </xsl:template>

</xsl:stylesheet>
