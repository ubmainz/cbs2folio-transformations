<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
  <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>
     
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="record">
    <xsl:variable name="currentrecord" select="."/>
    <record>
      <xsl:copy-of select="original"/>
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
      <instance>
        <source>K10plus</source>
        <xsl:copy-of select="$currentrecord/instance/*[not(self::source or self::administrativeNotes)]"/>
        <!-- RVK/DDC -->
        <classifications>
          <arr>
            <xsl:variable name="rvk" as="xs:string *">
              <xsl:for-each select="$currentrecord/original/(datafield[@tag='045R']/subfield[@code='8']|datafield[@tag='045R']/subfield[@code='a'])">
                <xsl:sequence select="normalize-space(substring-before(concat(.,':'),':'))"/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:for-each select="distinct-values($rvk)">
              <xsl:sort/>
              <i>
                <classificationNumber><xsl:value-of select="."/></classificationNumber>
                <classificationTypeId>RVK</classificationTypeId>
              </i>
            </xsl:for-each>
            <xsl:variable name="ddc" as="xs:string *">
              <xsl:for-each select="$currentrecord/original/(datafield[@tag='045F']/subfield[@code='a'][.!='B']|datafield[@tag='045H']/subfield[@code='a'][.!='B'])">
                <xsl:sequence select="normalize-space(translate(.,'/',''))"/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:for-each select="distinct-values($ddc)">
              <xsl:sort/>
              <i>
                <classificationNumber><xsl:value-of select="."/></classificationNumber>
                <classificationTypeId>DDC</classificationTypeId>
              </i>
            </xsl:for-each>
          </arr>
        </classifications>
        <administrativeNotes>
          <arr>
            <xsl:copy-of select="$currentrecord/instance/administrativeNotes/arr/*"/>
            <i><xsl:value-of select="concat('K10Plus-Datensatz PPN: ',$currentrecord/original/datafield[@tag='003@']/subfield[@code='0'],' - nur Instanz')"/></i>
          </arr>
        </administrativeNotes>
      </instance>
      <xsl:copy-of select="instanceRelations"/>
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
