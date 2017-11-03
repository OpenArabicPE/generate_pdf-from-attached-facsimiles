<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:tss="http://www.thirdstreetsoftware.com/SenteXML-1.0"
    xmlns="http://www.w3.org/1999/XSL/Format"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    
    <!-- this stylesheet uses Sente XML intput and produces XML-FO for output of images attached to references as PDF -->
    
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
                       <xsl:result-document href="FO {current-grouping-key()}.xml">
                           <fo:root>
                               <fo:layout-master-set>
                                   <fo:simple-page-master master-name="A4">
                                       <fo:region-body />
                                   </fo:simple-page-master>
                               </fo:layout-master-set>
                               <xsl:for-each select="$vRefs/tss:reference">
                                   <xsl:choose>
                                       <xsl:when test="$pgColl"></xsl:when>
                                   </xsl:choose>
                                   <xsl:apply-templates select=".//tss:attachmentReference" mode="mPDF"/>
                               </xsl:for-each>
                           </fo:root>
                       </xsl:result-document>
                    </xsl:for-each-group>
                </xsl:when>
                <xsl:when test="$pgColl='volume'">
                    <xsl:for-each-group select="./tss:reference" group-by=".//tss:characteristic[@name='issue']">
                        <xsl:sort select="ancestor::tss:date[@type='Publication']/@year"/>
                        <xsl:sort select="ancestor::tss:date[@type='Publication']/@month"/>
                        <xsl:sort select="ancestor::tss:date[@type='Publication']/@day"/>
                        <xsl:variable name="vRefs">
                            <xsl:copy-of select="current-group()"/>
                        </xsl:variable>
                        <xsl:result-document href="FO vol-{current-grouping-key()}.xml">
                            <fo:root>
                                <fo:layout-master-set>
                                    <fo:simple-page-master master-name="A4">
                                        <fo:region-body />
                                    </fo:simple-page-master>
                                </fo:layout-master-set>
                                <xsl:for-each select="$vRefs/tss:reference">
                                    <xsl:choose>
                                        <xsl:when test="$pgColl"></xsl:when>
                                    </xsl:choose>
                                    <xsl:apply-templates select=".//tss:attachmentReference" mode="mPDF"/>
                                </xsl:for-each>
                            </fo:root>
                        </xsl:result-document>
                    </xsl:for-each-group>
                </xsl:when>
            </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tss:attachmentReference" mode="mPDF">
        <fo:page-sequence master-reference="A4">
            <fo:flow flow-name="xsl-region-body">
                <fo:block>
                    <fo:external-graphic>
                    <xsl:attribute name="src">
                        <xsl:value-of select="./tss:URL"/>
                    </xsl:attribute>
                    </fo:external-graphic>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>
    
</xsl:stylesheet>