<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tss="http://www.thirdstreetsoftware.com/SenteXML-1.0" version="2.0"
    xmlns="http://www.thirdstreetsoftware.com/SenteXML-1.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    
    <xsl:include href="/BachUni/programming/XML/Functions/BachFunctions%20v3.xsl"/> 
    
    <!-- this stylesheet takes a SenteXML as input with JPGs attached to individual references and produces an additional URL to the PDF -->
    <!-- the stylesheet also adds Hijri dates, as it assumes that it will mostly deal with Arabic periodicals from the late 19th and early 20th centuries, which most likely had a Hijri publication date -->
    
    <xsl:variable name="vgUrlPdf" select="'file:///BachUni/projekte/XML/Sente2Pdf/pdfs/Servet'"/>
    
    <!-- identity transformation -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- add link to PDF -->
    <xsl:template match="tss:attachments">
        <xsl:copy>
            <xsl:element name="tss:attachmentReference">
                <xsl:element name="name">PDF</xsl:element>
                <xsl:element name="URL">
                    <xsl:variable name="vVolume"
                        select="concat('vol-',ancestor-or-self::tss:reference//tss:characteristic[@name='volume'])"/>
                    <xsl:variable name="vIssue"
                        select="concat('no-',ancestor-or-self::tss:reference//tss:characteristic[@name='issue'])"/>
                    <xsl:variable name="vUUID"
                        select="ancestor-or-self::tss:reference//tss:characteristic[@name='UUID']"/>
                    <xsl:value-of select="concat($vgUrlPdf,'-',$vVolume,'_',$vIssue,'_',$vUUID,'.pdf')"/>
                </xsl:element>
            </xsl:element>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!--
    <xsl:template match="tss:characteristics">
        <xsl:element name="tss:characteristics">
            <xsl:apply-templates/>
            <!-\-<xsl:if test="not(child::tss:characteristic[@name='Date Hijri'])">
                <xsl:variable name="vDateG">
                    <xsl:value-of select="concat(ancestor::tss:reference//tss:date[@type='Publication']/@year,'-',ancestor::tss:reference//tss:date[@type='Publication']/@month,'-',ancestor::tss:reference//tss:date[@type='Publication']/@day)"/>
                </xsl:variable>
                <xsl:variable name="vDateH">
                    <xsl:call-template name="funcDateG2H">
                        <xsl:with-param name="pDateG" select="$vDateG"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:element name="tss:characteristic">
                    <xsl:attribute name="name">Date Hijri</xsl:attribute>
                    <xsl:value-of select="format-number(number(tokenize($vDateH,'-')[3]),'0')"/>
                    <xsl:text> </xsl:text>
                    <xsl:call-template name="funcDateMonthName-Num">
                        <xsl:with-param name="pMonth" select="number(tokenize($vDateH,'-')[2])"/>
                        <xsl:with-param name="pLang" select="'hijmes'"/>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="number(tokenize($vDateH,'-')[1])"/>
                </xsl:element>
            </xsl:if>
-\->
        </xsl:element>
    </xsl:template>
    <xsl:template match="tss:attachmentReference">
        <xsl:if test="ends-with(./URL,'.pdf')">
            <xsl:copy-of select="."/>
        </xsl:if>
        <!-\- <xsl:copy-of select="."/> -\->
    </xsl:template>-->
    

</xsl:stylesheet>
