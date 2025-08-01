<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
  <xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>
     
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="record">
    <!-- Ausfiltern des ganzen Datensatzes für Pakettitel TBD -->
    <xsl:if test="not(starts-with(datafield[@tag='208@']/subfield[@code='b'],'zez')) and
      not(starts-with(datafield[@tag='208@']/subfield[@code='b'],'l') and starts-with(datafield[@tag='002@']/subfield[@code='0'],'O') and starts-with(datafield[(@tag='209B') and (subfield[@code='x']='12')]/subfield[@code='a'],'pack'))">
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
              <matchesPattern>.*</matchesPattern> <!-- \D.* -->
            </retainOmittedRecord>
          </item>
          <holdingsRecord>
            <retainExistingValues>
              <forOmittedProperties>true</forOmittedProperties>
            </retainExistingValues>
            <retainOmittedRecord>
              <ifField>hrid</ifField>
              <matchesPattern>.*</matchesPattern> <!-- \D.* -->
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
        
        <xsl:choose> <!-- zez and 'pack' schon oben ausgefiltert -->
          <xsl:when test="starts-with(datafield[@tag='208@']/subfield[@code='b'],'z')"> <!-- ZDB-Fälle + elek. Einzelkäufe? -->
            <holdingsRecords>
              <arr>
                <!-- <xsl:apply-templates select="holding"/> -->
              </arr>
            </holdingsRecords>
          </xsl:when>
          <xsl:otherwise>
            <holdingsRecords>
              <arr>
                <!--  hrid raussuchen (206X$0) und epn 203@ in administrative notices eintragen -  sonst nichts -->
              </arr>
            </holdingsRecords>
          </xsl:otherwise>
      </xsl:choose>
     
      </record>
    </xsl:if>
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
              <matchesPattern>.*</matchesPattern> <!-- \D.* -->
            </blockDeletion>
          </item>
          <holdingsRecord>
            <blockDeletion>
              <ifField>hrid</ifField>
              <matchesPattern>.*</matchesPattern> <!-- \D.* -->
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

  <xsl:template name="lcode"><xsl:value-of select="@epn"/></xsl:template>
  <xsl:template name="selectioncode"><xsl:value-of select="datafield[@tag='208@']/subfield[@code='b']"/></xsl:template>

  <xsl:template match="permanentLocationId">
    <xsl:variable name="i" select="key('original',.)"/>
    <xsl:variable name="abt" select="$i/datafield[@tag='209A']/subfield[@code='f']"/>
    <xsl:variable name="standort" select="upper-case($i/datafield[(@tag='209G') and (subfield[@code='x']='01')]/subfield[@code='a'])"/> 
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
            <xsl:when test="contains($standort,'FERNLEIHE LESESAAL')">ZBFLLS</xsl:when>
            <xsl:when test="contains($standort,'FERNLEIHE')">ZBFL</xsl:when>
            <xsl:when test="contains($standort,'FREIHAND')">ZBFREI</xsl:when>
            <xsl:when test="contains($standort,'LESESAAL')">ZBLS</xsl:when>
            <xsl:when test="contains($standort,'LBS')">ZBLBS</xsl:when>
            <xsl:when test="contains($standort,'RARA')">ZBRARA</xsl:when>
            <xsl:otherwise>ZBMAG</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$abt='002'">
          <xsl:choose>
            <xsl:when test="$onorder">GFGZEB</xsl:when>
            <xsl:when test="contains($standort,upper-case('Erziehungswissenschaft'))">GFGPÄD</xsl:when>
            <xsl:when test="contains($standort,upper-case('Filmwissenschaft'))">GFGFILM</xsl:when>
            <xsl:when test="contains($standort,upper-case('Journalistik'))">GFGJOUR</xsl:when>
            <xsl:when test="contains($standort,upper-case('Politikwissenschaft'))">GFGPOL</xsl:when>
            <xsl:when test="contains($standort,upper-case('Psychologie'))">GFGPSYCH</xsl:when>
            <xsl:when test="contains($standort,upper-case('Publizistik'))">GFGPUB</xsl:when>
            <xsl:when test="contains($standort,upper-case('Soziologie'))">GFGSOZ</xsl:when>
            <xsl:otherwise>GFGPÄD</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$abt='003'">
          <xsl:choose>
            <xsl:when test="$onorder">ZBZEB</xsl:when>
            <xsl:otherwise>ZBLS</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$abt='004'">
          <xsl:choose>
            <xsl:when test="contains($standort,'NUMERUS')">PHNC</xsl:when>
            <xsl:otherwise>PHRVK</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$abt='005'">
          <xsl:choose>
            <xsl:when test="contains($standort,'LESESAAL')">UMLS</xsl:when>
            <xsl:when test="contains($standort,'LBS')">UMLBS</xsl:when>
            <xsl:otherwise>UMFH</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$abt='006'">
          <xsl:choose>
            <xsl:when test="contains($standort,'LEHRBUCH')">MINTLBS</xsl:when>
            <xsl:when test="contains($standort,'HANDAPPARAT')">MINTFAK</xsl:when>
            <xsl:otherwise>MINT</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$abt='009'">FBMPI</xsl:when>	
        <xsl:when test="$abt='016'">
          <xsl:choose>
            <xsl:when test="contains($standort,'MAGAZIN') or contains($standort,'Rara')">THRARA</xsl:when>
            <xsl:when test="contains($standort,'LEHRBUCH')">THLBS</xsl:when>
            <xsl:when test="contains($standort,'BÜRO') or contains($standort,'büro')">THFAK</xsl:when>
            <xsl:when test="contains($standort,'PSYCHOLOGIE')">THPSYCH</xsl:when>
            <xsl:otherwise>TH</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$abt='018'">
          <xsl:choose>
            <xsl:when test="contains($standort,'LEHRBUCH')">RWLBS</xsl:when>
            <xsl:when test="contains($standort,'MAGAZIN')">RWMAG</xsl:when>
            <xsl:otherwise>RW</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$abt='019'">
          <xsl:choose>
            <xsl:when test="$onorder">GHZEB</xsl:when>
            <xsl:when test="contains($standort,upper-case('Fernleihe Lesesaal'))">GHFLLS</xsl:when>
            <xsl:when test="contains($standort,upper-case('Fernleihe'))">GHFL</xsl:when>
            <xsl:when test="contains($standort,upper-case('Handapparat'))">GHFAK</xsl:when>
            <xsl:when test="contains($standort,upper-case('Lehrbuch'))">GHLBS</xsl:when>
            <xsl:when test="contains($standort,upper-case('Lesesaal'))">GHLS</xsl:when>
            <xsl:when test="contains($standort,upper-case('Magazin'))">GHMAG</xsl:when>
            <xsl:when test="($standort='CELA')
              or ($standort='CELTRA')
              or ($standort='SSC')">GHSEP</xsl:when>
            <xsl:otherwise>GHFREI</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$abt='020'">RWFAK</xsl:when>
        <xsl:when test="$abt='021'">ZBMAG</xsl:when>
        <xsl:when test="$abt='034'">FBGTEM</xsl:when>
        <xsl:when test="$abt='035'">UMRMED</xsl:when>
        <xsl:when test="$abt='043'">UMPSY</xsl:when>
        <xsl:when test="$abt='054'">UMZMK</xsl:when>
        <xsl:when test="$abt='058'">PHPHI</xsl:when>
        <xsl:when test="$abt='066'">
          <xsl:choose>
            <xsl:when test="contains($standort,'AMA')">RWAMA</xsl:when>
            <xsl:otherwise>RWETH</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$abt='069'">FBPSY</xsl:when>
        <xsl:when test="$abt='070'">PHGER</xsl:when>
        <xsl:when test="$abt='071'">PHAVL</xsl:when>
        <xsl:when test="$abt='072'">PHANG</xsl:when>
        <xsl:when test="$abt='073'">PHAVS</xsl:when>
        <xsl:when test="$abt='074'">PHROM</xsl:when>
        <xsl:when test="$abt='075'">PHSLAV</xsl:when>
        <xsl:when test="$abt='076'">PHPOL</xsl:when>
        <xsl:when test="$abt='077'">PHKLP</xsl:when>
        <xsl:when test="$abt='078'">PHKLA</xsl:when>
        <xsl:when test="$abt='079'">GFGKUN</xsl:when>
        <xsl:when test="$abt='080'">RWTURK</xsl:when>
        <xsl:when test="$abt='082'">FBÄGYPT</xsl:when>
        <xsl:when test="$abt='083'">PHKLW</xsl:when>
        <xsl:when test="$abt='085'">FBAVFGA</xsl:when>
        <xsl:when test="$abt='086'">PHALG</xsl:when>
        <xsl:when test="$abt='087'">PHBYZ</xsl:when>
        <xsl:when test="$abt='088'">PHMNG</xsl:when>
        <xsl:when test="$abt='090'">PHBUW</xsl:when>
        <xsl:when test="$abt='091'">
          <xsl:choose>
            <xsl:when test="contains($standort,upper-case('Separiert'))">PHMUWMAG</xsl:when>
            <xsl:otherwise>PHMUW</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$abt='092'">PHOEG</xsl:when>
        <xsl:when test="$abt='093'">
          <xsl:choose>
            <xsl:when test="$standort='MAG'">ZBMAG</xsl:when>
            <xsl:otherwise>ZBLS</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$abt='094'">FBIGL</xsl:when>
        <xsl:when test="$abt='110'">GFGGEO</xsl:when>
        <xsl:when test="$abt='111'">FBKUNST</xsl:when>
        <xsl:when test="$abt='112'">
          <xsl:choose>
            <xsl:when test="contains($standort,'FREIHAND')">PHHFMFREI</xsl:when>
            <xsl:otherwise>PHHFMMAG</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$abt='113'">GFGSPO</xsl:when>
        <xsl:when test="$abt='120'">PHTHW</xsl:when>
        <xsl:when test="$abt='124'">FBGESANG</xsl:when>
        <xsl:when test="$abt='125'">ZBMAG</xsl:when>
        <xsl:when test="$abt='126'">GFGUSA</xsl:when>
        <xsl:when test="$abt='127'">PHMAG</xsl:when>
        <xsl:otherwise>UNKNOWN</xsl:otherwise>
      </xsl:choose>
    </permanentLocationId>
  </xsl:template>

  <xsl:template match="holding">
    <i>
      <xsl:variable name="epn" select="datafield[@tag='203@']/subfield[@code='0']"/>
      <hrid>
        <xsl:value-of select="$epn"/>
      </hrid>
      <permanentLocationId>
        <xsl:call-template name="lcode"/>
      </permanentLocationId>
      <!-- There is no 109R in hebis, see $electronicholding -->
      <xsl:variable name="electronicholding" select="(substring(../datafield[@tag='002@']/subfield[@code='0'],1,1) = 'O') and not(substring(datafield[@tag='208@']/subfield[@code='b'],1,1) = 'a')"/>
      <callNumber>
        <xsl:if test="not($electronicholding) and (substring(datafield[@tag='208@']/subfield[@code='b'],1,1) != 'd')">
          <xsl:value-of select="datafield[(@tag='209A') and (subfield[@code='x']='00')]/subfield[@code='a']"/>
        </xsl:if>
      </callNumber>  
      <holdingsTypeId>
        <xsl:choose>
          <xsl:when test="substring(../datafield[@tag='002@']/subfield[@code='0'], 1, 1) = 'O'">electronic</xsl:when>
          <xsl:otherwise>physical</xsl:otherwise>
        </xsl:choose>
      </holdingsTypeId>
      <holdingsStatements>
        <xsl:if test="datafield[(@tag='209E')]/subfield[@code='a']">
          <arr>
            <xsl:for-each select="datafield[(@tag='209E') and (subfield[@code='x']='01' or subfield[@code='x']='02' or subfield[@code='x']='03')]/subfield[@code='a']">
              <i>
                <statement>
                  <xsl:if test="../subfield[@code='x']='03'">
                    <xsl:text>Angaben zur Vollständigkeit: </xsl:text>  
                  </xsl:if>
                  <xsl:value-of select="."/>
                </statement>
                <xsl:if test="(../subfield[@code='x']='02') and (../../datafield[@tag='209E']/subfield[@code='x']='04')">
                  <note>
                    <xsl:value-of select="../../datafield[(@tag='209E') and (subfield[@code='x']='04')]/subfield[@code='a']"/>
                  </note>
                </xsl:if>
              </i>
            </xsl:for-each>
            <xsl:if test="not (datafield[@tag='209E']/subfield[@code='x']='02') and (datafield[@tag='209E']/subfield[@code='x']='04')">
              <i>
                <note>
                  <xsl:value-of select="datafield[(@tag='209E') and (subfield[@code='x']='04')]/subfield[@code='a']"/>
                </note>
              </i>
            </xsl:if>
          </arr>
        </xsl:if>
      </holdingsStatements>
      
      <notes>
        <arr>
          <xsl:for-each select="datafield[@tag='220B' or @tag='220C' or @tag='220E' or @tag='237A']">
            <xsl:if test="./subfield[@code='a'] or ./subfield[@code='0']">
              <i>
                <note>
                  <xsl:value-of select="./subfield[@code='a'] | ./subfield[@code='0']"/>
                </note>
                <holdingsNoteTypeId>Note</holdingsNoteTypeId>
                <staffOnly>
                  <xsl:value-of select="./@tag!='237A'"/>
                </staffOnly>
              </i>
            </xsl:if>
          </xsl:for-each>
          <xsl:for-each select="datafield[(@tag='209G') and (subfield[@code='x']='01')]/subfield[@code='a']"> <!-- local adaptions -->
            <i>
              <note>
                <xsl:value-of select="."/>
              </note>
              <holdingsNoteTypeId>Standort (8201)</holdingsNoteTypeId>
              <staffOnly>false</staffOnly>
            </i>             
          </xsl:for-each>
          <xsl:if test="datafield[@tag='247D']">
            <i>
              <note>
                <xsl:value-of select="datafield[@tag='247D']/subfield[@code='a']"/>
              </note>
              <holdingsNoteTypeId>Text zur Ausleihbarkeit</holdingsNoteTypeId>
              <staffOnly>false</staffOnly>
            </i>
          </xsl:if>
          <xsl:if test="datafield[@tag='201B']">
            <i>
              <note>
                <xsl:value-of select="concat(translate(datafield[@tag='201B']/subfield[@code='0'], '-', '.'),' ', substring(datafield[@tag='201B']/subfield[@code='t'],1,5))"/>
              </note>
              <holdingsNoteTypeId>Letzte Änderung CBS</holdingsNoteTypeId>
              <staffOnly>true</staffOnly>
            </i>
          </xsl:if>
          <xsl:for-each select="datafield[@tag='209B' and not(subfield[@code='x']='01' or subfield[@code='x']='02')]">
            <i>
              <note>
                <xsl:value-of select="./subfield[@code='a']"/>
              </note>
              <holdingsNoteTypeId>Lokaler Schlüssel</holdingsNoteTypeId>
              <staffOnly>true</staffOnly>
            </i>
          </xsl:for-each>
          <!-- entfernt, weil über HDS2 angezeigt und sonst gedoppelt
          <xsl:for-each select="datafield[(@tag='244Z') and (subfield[@code='x']&gt;'79') and (subfield[@code='x']&lt;'99')]">
            <i>
              <note>
                <xsl:value-of select="./subfield[(@code='8')]"/>
                <xsl:if test="./subfield[@code='b']">
                  <xsl:text>. </xsl:text><xsl:value-of select="./subfield[@code='b']"/>
                </xsl:if>
              </note>
              <holdingsNoteTypeId>Provenance</holdingsNoteTypeId>
              <staffOnly>false</staffOnly>
            </i>
          </xsl:for-each>
          <xsl:for-each select="datafield[(@tag='244Z') and (subfield[@code='x']='99')]">
            <i>
              <note>
                <xsl:value-of select="./subfield[@code='a']"/>
                <xsl:if test="./subfield[@code='b']">
                  <xsl:text>. </xsl:text><xsl:value-of select="./subfield[@code='b']"/>
                </xsl:if>
              </note>
              <holdingsNoteTypeId>Provenance</holdingsNoteTypeId>
              <staffOnly>false</staffOnly>
            </i>
          </xsl:for-each>
          <xsl:for-each select="datafield[(@tag='220D')]">
            <i>
              <note>
                <xsl:value-of select="./subfield[@code='a']"/>
              </note>
              <holdingsNoteTypeId>Provenance</holdingsNoteTypeId>
              <staffOnly>false</staffOnly>
            </i>
          </xsl:for-each>
                    -->
          <xsl:for-each select="datafield[@tag='209S']/subfield[@code='S'] | datafield[@tag='204U']/subfield[@code='S'] | datafield[@tag='204P']/subfield[@code='S'] | datafield[@tag='204R']/subfield[@code='S'] ">
            <i>
              <note>
                <xsl:value-of select="."/>
              </note>
              <holdingsNoteTypeId>Lizenzindikator</holdingsNoteTypeId>
              <staffOnly>true</staffOnly>
            </i>
          </xsl:for-each>
          
          
          <xsl:if test="datafield[(@tag='209A') and (subfield[@code='x']='00') and subfield[@code='h']]">
            <i>
              <note>
                <xsl:value-of select="datafield[@tag='209A']/subfield[@code='h']"/>
              </note>
              <holdingsNoteTypeId><xsl:text>Signatur Ansetzungsform (7100)</xsl:text></holdingsNoteTypeId>
              <staffOnly>true</staffOnly>  
            </i>
          </xsl:if>
          <xsl:for-each select="datafield[(@tag='209A') and (subfield[@code='x']!='00')]/subfield[(@code='a') or (@code='h')]">
            <i>
              <note>
                <xsl:value-of select="."/>
              </note>
              <holdingsNoteTypeId>
                <xsl:variable name="codex" select="../subfield[@code='x']"/>
                <xsl:choose>
                  <xsl:when test="$codex='09'">
                    <xsl:text>Magazinsignatur (nur Monografien) (71</xsl:text><xsl:value-of select="$codex"/><xsl:text>)</xsl:text>
                  </xsl:when>
                  <xsl:when test="$codex='10'">
                    <xsl:text>Magazinsignatur (nur Zeitschriften) (71</xsl:text><xsl:value-of select="$codex"/><xsl:text>)</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>Weitere Signaturen (71</xsl:text><xsl:value-of select="$codex"/><xsl:text>)</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </holdingsNoteTypeId>
              <staffOnly>true</staffOnly>  
            </i>
          </xsl:for-each>
        </arr>
      </notes>
      <discoverySuppress>
        <xsl:choose>
          <xsl:when test="datafield[@tag='247E']/subfield[@code='a']"><xsl:text>true</xsl:text></xsl:when> <!-- selectionscode != true -->
          <xsl:otherwise><xsl:call-template name="selectioncode"/></xsl:otherwise>
        </xsl:choose>
      </discoverySuppress>   
      <sourceId>hebis</sourceId>
      <xsl:if test="not($electronicholding) and (datafield[(@tag='209G') and (subfield[@code='x']='00')]/subfield[@code='a'] or not(datafield[@tag='209A']/subfield[@code='i']))">
        <items>
          <arr>
            <xsl:for-each select="datafield[(@tag='209G') and (subfield[@code='x']='00')]/subfield[@code='a']">
              <!--   <xsl:message>Debug: <xsl:value-of select="."/></xsl:message> -->
              <xsl:variable name="copy">
                <xsl:choose>
                  <xsl:when test="contains(.,'(')">
                    <xsl:value-of select="translate(substring-before(substring-after(.,'('),')'),' .,','')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="position()"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <!--  <xsl:message>Debug: <xsl:value-of select="concat($epn,'-',$copy)"/></xsl:message> -->
              <xsl:apply-templates select="../.." mode="make-item">
                <xsl:with-param name="hhrid" select="concat($epn,'-',$copy)"/>
                <xsl:with-param name="bcode" select="substring-before(concat(.,' '),' ')"/>
                <xsl:with-param name="copy">
                  <xsl:if test="last()>1"><xsl:value-of select="$copy"/></xsl:if>
                </xsl:with-param>
              </xsl:apply-templates>
            </xsl:for-each>
            <xsl:if test="not(datafield[(@tag='209G') and (subfield[@code='x']='00')]/subfield[@code='a'])">
              <!--   <xsl:message>Debug: EPN <xsl:value-of select="$epn"/></xsl:message>  -->
              <xsl:apply-templates select="." mode="make-item">
                <xsl:with-param name="hhrid" select="concat($epn,'-1')"/>
              </xsl:apply-templates>
            </xsl:if>
          </arr>
        </items>
      </xsl:if>
      <electronicAccess>
        <arr>
          <xsl:for-each select="datafield[@tag='209S']">
            <i>
              <uri>
                <xsl:value-of select="./subfield[@code='u']"/>
              </uri>
            </i>
          </xsl:for-each>
          <xsl:for-each select="datafield[@tag='204P'] | datafield[@tag='204U'] | datafield[@tag='204R']">
            <i>
              <uri>
                <xsl:value-of select="./subfield[@code='0']"/>
              </uri>
            </i>
          </xsl:for-each>
        </arr>
      </electronicAccess>
      
    </i>
  </xsl:template>

  <xsl:template match="item" mode="make-item">
    <xsl:param name="hhrid"/>
    <xsl:param name="bcode"/>
    <xsl:param name="copy"/>
    <i>
      <hrid>
        <xsl:value-of select="$hhrid"/>
      </hrid>
      
      <!-- Hebis / K10plus -->  
      <materialTypeId>
        <xsl:variable name="type1" select="substring(../datafield[@tag='002@']/subfield[@code='0'], 1, 1)"/>
        <xsl:variable name="pd" select="../datafield[@tag='013H']/subfield[@code='0']"/>
        <xsl:choose>
          <xsl:when test="(($type1 = 'A') and ($pd = 'kart')) or ($type1 = 'K')">Karten</xsl:when> <!-- K10plus: pd kart type1 A / Hebis: type1 K -->
          <xsl:when test="(($type1 = 'A') and ($pd = 'muno')) or ($type1 = 'M')">Noten</xsl:when> <!-- K10plus: pd muno type1 A / Hebis: type1 M -->
          <xsl:when test="($type1 = 'A') or ($type1 = 'H') or ($type1 = 'I') or ($type1 = 'L') or (($type1 = 'B') and ($pd = 'bild'))">Druckschrift</xsl:when> <!-- K10plus: pd bild type1 B / Hebis: type1 I -->
          <xsl:when test="($type1 = 'G') or (($type1 = 'B') and ($pd = 'soto'))">Tonträger</xsl:when> <!-- K10pus: pd soto type1 B / Hebis: type1 G -->
          <xsl:when test="$type1 = 'B'">Audiovisuelles Material</xsl:when> <!-- K10plus: pd vide type1 B / Hebis: type1 B -->
          <xsl:when test="$type1 = 'C'">Blindenschriftträger</xsl:when>
          <xsl:when test="$type1 = 'E'">Mikroformen</xsl:when>
          <!-- <xsl:when test="$type1 = 'O'">E-Ressource</xsl:when> --> <!-- no items -->
          <xsl:when test="$type1 = 'S'">Computerlesbares Material</xsl:when>
          <xsl:when test="$type1 = 'V'">Objekt</xsl:when>
          <xsl:otherwise>Sonstiges</xsl:otherwise>
        </xsl:choose>
      </materialTypeId>
      
      <permanentLoanTypeId> <!-- TBD -->
        <xsl:choose>
          <xsl:when test="substring(datafield[@tag='208@']/subfield[@code='b'],1,1)='d'">dummy</xsl:when>
          <xsl:when test="(substring(../datafield[@tag='002@']/subfield[@code='0'],2,1)='o') and not(datafield[@tag='209A']/subfield[@code='d'])">aufsatz</xsl:when>
          <xsl:otherwise><xsl:value-of select="datafield[@tag='209A']/subfield[@code='d']"/></xsl:otherwise>
        </xsl:choose>
      
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
      <status>
        <name>
          <xsl:choose>
            <xsl:when test="(substring(datafield[@tag='208@']/subfield[@code='b'],1,1) = 'd') or 
              (substring(datafield[@tag='208@']/subfield[@code='b'],1,1) = 'p') or
              (substring(datafield[@tag='208@']/subfield[@code='b'],1,2) = 'gp')">Intellectual item</xsl:when>
            <xsl:when test="(substring(../datafield[@tag='002@']/subfield[@code='0'],2,1)='o') and not(datafield[@tag='209A']/subfield[@code='d'])">Unknown</xsl:when>
            <xsl:when test="datafield[@tag='209A']/subfield[@code='d']='a'">On order</xsl:when>
            <xsl:when test="datafield[@tag='209A']/subfield[@code='d']='e'">Long missing</xsl:when>
            <xsl:when test="datafield[@tag='209A']/subfield[@code='d']='z'">Withdrawn</xsl:when>
            <xsl:when test="datafield[@tag='209A']/subfield[@code='d']='g'">Restricted</xsl:when>
            <xsl:otherwise>Available</xsl:otherwise>
          </xsl:choose>
        </name>
      </status>
      <barcode>
        <xsl:value-of select="$bcode"/>
      </barcode>
      <copyNumber>
        <xsl:value-of select="$copy"/>
      </copyNumber>
      <yearCaption>
        <arr>
          <xsl:for-each select="datafield[@tag='209E' and (subfield[@code='x']='02')]/subfield[@code='a']"> <!-- Wiederholungen kommen jedoch nicht vor -->
            <i>
              <xsl:for-each select="../../datafield[@tag='209E' and (subfield[@code='x']='01')]/subfield[@code='a']"><xsl:value-of select="."/><xsl:text>: </xsl:text></xsl:for-each>
              <xsl:value-of select="."/>
            </i>
          </xsl:for-each>
        </arr>
      </yearCaption>
      
      <!-- no notes on item level 
        <notes>
          <arr>

          </arr>
        </notes>  -->
      
      <!-- No item for electronic access in hebis -->
      <accessionNumber>
        <xsl:for-each select="datafield[@tag='209C']">
          <xsl:value-of select="./subfield[@code='a']"/>
          <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
      </accessionNumber>
      <discoverySuppress>
        <xsl:choose>
          <xsl:when test="datafield[@tag='247E']/subfield[@code='a']"><xsl:text>true</xsl:text></xsl:when>
          <xsl:otherwise><xsl:call-template name="selectioncode"/></xsl:otherwise>
        </xsl:choose>
      </discoverySuppress>
      <statisticalCodeIds/>
    </i>
  </xsl:template>

 </xsl:stylesheet>
