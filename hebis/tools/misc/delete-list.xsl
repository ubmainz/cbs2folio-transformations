<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

    <xsl:template match="/collection">
        <collection>
            <xsl:apply-templates/>
        </collection>
    </xsl:template>

    <xsl:template match="record[status='deleted']">
        <record>
            <delete>
                <hrid>
                    <xsl:value-of select="hrid"/>
                </hrid>
                <processing>
                    <item>
                        <blockDeletion>
                            <ifField>hrid</ifField>
                            <matchesPattern>it.*</matchesPattern>
                        </blockDeletion>
                    </item>
                    <holdingsRecord>
                        <blockDeletion>
                            <ifField>hrid</ifField>
                            <matchesPattern>ho.*</matchesPattern>
                        </blockDeletion>
                        <statisticalCoding>
                            <arr>
                                <i>
                                    <if>deleteSkipped</if>
                                    <becauseOf>ITEM_STATUS</becauseOf>
                                    <setCode>e7b3071c-8cc0-48cc-9cd0-dfc82c4e4602</setCode>
                                </i>
                                <i>
                                    <if>deleteSkipped</if>
                                    <becauseOf>HOLDINGS_RECORD_PATTERN_MATCH</becauseOf>
                                    <setCode>ac9bae48-d14c-4414-919a-292d539f9967</setCode>
                                </i>
                                <i>
                                    <if>deleteSkipped</if>
                                    <becauseOf>ITEM_PATTERN_MATCH</becauseOf>
                                    <setCode>970b8b4e-ee88-4037-b954-a10ee75340f0</setCode>
                                </i>
                            </arr>
                        </statisticalCoding>
                    </holdingsRecord>
                    <instance>
                        <statisticalCoding>
                            <arr>
                                <i>
                                    <if>deleteSkipped</if>
                                    <becauseOf>PO_LINE_REFERENCE</becauseOf>
                                    <setCode>dcf1220f-5524-4f1e-8e40-5da3366e8478</setCode>
                                </i>
                            </arr>
                        </statisticalCoding>
                    </instance>
                </processing>
            </delete>
        </record>
    </xsl:template>

</xsl:stylesheet>
