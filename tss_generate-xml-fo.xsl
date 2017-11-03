<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:tss="http://www.thirdstreetsoftware.com/SenteXML-1.0"
    xmlns="http://www.w3.org/1999/XSL/Format"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    
    <!-- this stylesheet uses Sente XML intput and produces XML-FO for output of images attached to references as PDF -->
    
    <!-- provides a variety of date functions, citation styles etc. -->
    <xsl:include href="/BachUni/projekte/XML/Functions/BachFunctions v2b.xsl"/>
    
    <!-- collation parameter. decides whether pdfs are created for volumes, years of publication etc. Values: volume, year, issue  -->
    <xsl:param name="pgColl" select="'volume'"/>
    
    <xsl:template match="/">
            <xsl:apply-templates select=".//tss:references" mode="mPDF"/>
    </xsl:template>
    
    <xsl:template match="tss:references" mode="mPDF">
            <xsl:choose>
                <xsl:when test="$pgColl='year'">
                    <xsl:for-each-group select="./tss:reference" group-by=".//tss:date[@type='Publication']/@year">
                        <xsl:sort select="ancestor::tss:date[@type='Publication']/@month"/>
                        <xsl:sort select="ancestor::tss:date[@type='Publication']/@day"/>
                        <xsl:variable name="vRefs">
                            <xsl:copy-of select="current-group()"/>
                        </xsl:variable>
                        <xsl:variable name="vFileName" select="current-grouping-key()"/>
                        <xsl:call-template name="tResultFile">
                            <xsl:with-param name="pRefs" select="$vRefs"/>
                            <xsl:with-param name="pFileName" select="$vFileName"/>
                        </xsl:call-template>
                    </xsl:for-each-group>
                </xsl:when>
                <!-- Due to Sente's limited file naming capabilities, the "issue" field contains the "volume" information and vice vers -->
                <xsl:when test="$pgColl='volume'">
                    <xsl:for-each-group select="./tss:reference" group-by=".//tss:characteristic[@name='issue']">
                        <xsl:sort select="ancestor::tss:date[@type='Publication']/@year"/>
                        <xsl:sort select="ancestor::tss:date[@type='Publication']/@month"/>
                        <xsl:sort select="ancestor::tss:date[@type='Publication']/@day"/>
                        <xsl:variable name="vRefs">
                            <xsl:copy-of select="current-group()"/>
                        </xsl:variable>
                        <xsl:variable name="vFileName" select="concat('vol-',current-grouping-key())"/>
                        <xsl:call-template name="tResultFile">
                            <xsl:with-param name="pRefs" select="$vRefs"/>
                            <xsl:with-param name="pFileName" select="$vFileName"/>
                        </xsl:call-template>
                    </xsl:for-each-group>
                </xsl:when>
                <xsl:when test="$pgColl='issue'">
                    <xsl:for-each-group select="./tss:reference" group-by=".//tss:characteristic[@name='volume']">
                        <xsl:sort select="ancestor::tss:date[@type='Publication']/@year"/>
                        <xsl:sort select="ancestor::tss:date[@type='Publication']/@month"/>
                        <xsl:sort select="ancestor::tss:date[@type='Publication']/@day"/>
                        <xsl:variable name="vRefs">
                            <xsl:copy-of select="current-group()"/>
                        </xsl:variable>
                        <xsl:variable name="vFileName" select="concat('vol-',current-grouping-key())"/>
                        <xsl:call-template name="tResultFile">
                            <xsl:with-param name="pRefs" select="$vRefs"/>
                            <xsl:with-param name="pFileName" select="$vFileName"/>
                        </xsl:call-template>
                    </xsl:for-each-group>
                </xsl:when>
            </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tss:attachmentReference" mode="mPDF">
        <fo:block>
            <xsl:attribute name="id" select="concat('i',ancestor::tss:reference//tss:characteristic[@name='volume'],'-',position())"/>
            <fo:external-graphic height="297mm" width="210mm" content-width="scale-to-fit" content-height="scale-to-fit" scaling="uniform">
                <xsl:attribute name="src">
                    <xsl:value-of select="./tss:URL"/>
                </xsl:attribute>
            </fo:external-graphic>
        </fo:block>
    </xsl:template>
    
    <xsl:template name="tResultFile">
        <xsl:param name="pRefs"/>
        <xsl:param name="pFileName"/>
        <xsl:result-document href="FO {$pFileName}.xml">
            <fo:root>
                <fo:layout-master-set>
                    <fo:simple-page-master master-name="A4" page-height="297mm" page-width="210mm">
                        <fo:region-body />
                    </fo:simple-page-master>
                </fo:layout-master-set>
                <fo:bookmark-tree>
                    <xsl:for-each select="$pRefs/tss:reference">
                        <xsl:if test=".//tss:attachmentReference">
                            <fo:bookmark starting-state="show">
                                <xsl:attribute name="internal-destination" select="concat('i',.//tss:characteristic[@name='volume'],'-1')"/>
                                <fo:bookmark-title>
                                    <xsl:value-of select="concat(.//tss:characteristic[@name='volume'],', ',.//tss:date[@type='Publication']/@day,' ')"/>
                                    <xsl:call-template name="funcDateMonthName-Num">
                                        <xsl:with-param name="pMonth" select=".//tss:date[@type='Publication']/@month"/>
                                        <xsl:with-param name="pLang" select="'GEn'"/>
                                    </xsl:call-template>
                                    <xsl:value-of select="concat(' ',.//tss:date[@type='Publication']/@year)"/>
                                </fo:bookmark-title>
                            </fo:bookmark>
                        </xsl:if>
                    </xsl:for-each>
                </fo:bookmark-tree>
                
                <xsl:for-each select="$pRefs/tss:reference">
                    <xsl:if test=".//tss:attachmentReference">
                        <fo:page-sequence master-reference="A4">
                            <fo:flow flow-name="xsl-region-body">
                                <xsl:apply-templates select=".//tss:attachmentReference" mode="mPDF"/>
                            </fo:flow>
                        </fo:page-sequence>
                    </xsl:if>
                </xsl:for-each>
                
            </fo:root>
        </xsl:result-document>
        
    </xsl:template>
    
    
</xsl:stylesheet>