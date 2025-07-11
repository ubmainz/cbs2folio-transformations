<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>
     
  <xsl:template match="collection">
    <collection>
      <xsl:apply-templates select="record"/>
    </collection>
  </xsl:template>
  
  <xsl:template match="record[not(delete)]">
    <record>
      <processing> <!-- preserves holdings data -->
        <item>
          <retainExistingValues>
            <forOmittedProperties>true</forOmittedProperties>
            <forTheseProperties>
              <arr>
                <i>materialTypeId</i>
              </arr>
            </forTheseProperties>
          </retainExistingValues>
          <status>
            <policy>retain</policy>
          </status>
          <retainOmittedRecord>
            <ifField>hrid</ifField>
            <matchesPattern>.*</matchesPattern>
          </retainOmittedRecord>
        </item>
        <holdingsRecord>
          <retainExistingValues>
            <forOmittedProperties>true</forOmittedProperties>
          </retainExistingValues>
          <retainOmittedRecord>
            <ifField>hrid</ifField>
            <matchesPattern>.*</matchesPattern>
          </retainOmittedRecord>
        </holdingsRecord>
        <instance>
          <retainExistingValues>
            <forOmittedProperties>true</forOmittedProperties>
          </retainExistingValues>
        </instance>
      </processing>
      <xsl:for-each select="*[not(self::processing)]">  <!-- removes any 'processing' element from pica2instance-new.xsl! -->
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </record>
  </xsl:template>

  <xsl:template match="record[delete]">
    <record>
      <delete>
        <xsl:for-each select="delete/*[not(self::processing)]">  <!-- removes any 'processing' element from pica2instance-new.xsl! -->
          <xsl:copy-of select="."/>
        </xsl:for-each>
        <processing> <!-- preserves holdings data -->
          <item>
            <blockDeletion>
              <ifField>hrid</ifField>
              <matchesPattern>.*</matchesPattern>
            </blockDeletion>
          </item>
          <holdingsRecord>
            <blockDeletion>
              <ifField>hrid</ifField>
              <matchesPattern>.*</matchesPattern>
            </blockDeletion>
            <statisticalCoding>
              <arr>
                <i>
                  <if>deleteSkipped</if>
                  <becauseOf>ITEM_STATUS</becauseOf>
                  <setCode>ITEM_STATUS</setCode>
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
                  <setCode>PO_LINE_REFERENCE</setCode>
                </i>
                <i>
                  <if>deleteSkipped</if>
                  <becauseOf>HOLDINGS_RECORD_PATTERN_MATCH</becauseOf>
                  <setCode>HOLDINGS_RECORD_PATTERN_MATCH</setCode>
                </i> 
                <i>
                  <if>deleteSkipped</if>
                  <becauseOf>ITEM_PATTERN_MATCH</becauseOf>
                  <setCode>ITEM_PATTERN_MATCH</setCode>
                </i> 
              </arr>
            </statisticalCoding>
          </instance>
        </processing>
      </delete>
    </record>
  </xsl:template>
 
 </xsl:stylesheet>
