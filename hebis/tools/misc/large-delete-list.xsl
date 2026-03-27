<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

    <xsl:key name="hrids" match="hrid" use="substring(.,string-length(.)-1,2)"/>

    <xsl:variable name="x" select="('0','1','2','3','4','5','6','7','8','9')"/>
    <xsl:variable name="y" select="('0','1','2','3','4','5','6','7','8','9','X')"/>

    <xsl:template match="/root">
        <xsl:variable name="kontext" select="."/>
        <xsl:for-each select="$x">
            <xsl:variable name="xvar" select="."/>
            <xsl:for-each select="$y">
                <xsl:variable name="xyvar" select="concat($xvar,.)"/>
                <xsl:variable name="file" select="concat('out/d',$xvar,'/delete-',$xyvar,'.xml')"/>
                <xsl:message>Info: Writing to &apos;<xsl:value-of select="$file"/>&apos; (<xsl:value-of select="count($kontext/key('hrids',$xyvar))"/>)</xsl:message>
                <xsl:result-document href="{$file}">
                    <collection>
                        <xsl:for-each select="$kontext/key('hrids',$xyvar)">
                        <record>
                            <status>deleted</status>
                            <hrid>
                                <xsl:value-of select="."/>
                            </hrid>
                        </record>
                        </xsl:for-each>
                    </collection>
                </xsl:result-document>
             </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
