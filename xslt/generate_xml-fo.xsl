<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:tss="http://www.thirdstreetsoftware.com/SenteXML-1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/XSL/Format" version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    
    <!-- this stylesheet generates XML FO which can then be used to create PDFs using an ANT build file -->
    
    <!-- provides a variety of date functions, citation styles etc. -->
<!--    <xsl:include href="/BachUni/programming/XML/Functions/BachFunctions%20v3.xsl"/>-->
    
    <xsl:template name="t_generate-fo-file">
        <xsl:param name="p_references"/>
        <xsl:param name="p_file-name"/>
        <xsl:result-document href="../_output/xslfo/{$p_file-name}.fo">
            <fo:root>
                <fo:layout-master-set>
                    <fo:simple-page-master master-name="A4" page-height="297mm" page-width="210mm">
                        <fo:region-body/>
                    </fo:simple-page-master>
                </fo:layout-master-set>
                <!-- generate bookmarks pointing to the first page of an issue -->
                <!-- oxygen doesn't validate with a fo:bookmarktree. this is a known bug -->
                <!-- Apple's preview seems not to recognise these bookmarks -->
                <fo:bookmark-tree>
                    <xsl:apply-templates select="$p_references/descendant-or-self::tei:biblStruct" mode="m_bookmark"/>
                </fo:bookmark-tree>
                <!-- add the actual pages -->
                <xsl:apply-templates select="$p_references/descendant-or-self::tei:biblStruct" mode="m_page-sequence"/>
            </fo:root>
        </xsl:result-document>
    </xsl:template>
    <!-- generate bookmarks -->
    <xsl:template name="t_generate-bookmarks" match="tei:biblStruct" mode="m_bookmark">
        <xsl:param name="p_input" select="."/>
        <!-- $p_destination must similar to $p_id in t_generate page-->
       <!-- <xsl:param name="p_destination" select="concat('i',$p_input//tss:characteristic[@name='volume'],'-1')"/>-->
        <xsl:param name="p_destination" select="concat('i_',$p_input/tei:monogr/tei:biblScope[@unit='issue']/@from,'-p_1')"/>
        <xsl:param name="p_title">
            <!-- title -->
            <xsl:value-of select="tei:monogr/tei:title[@level='j'][@xml:lang='ar-Latn-x-ijmes'][1]"/>
            <!-- issue -->
            <xsl:text> #</xsl:text>
            <xsl:value-of select="tei:monogr/tei:biblScope[@unit='issue']/@from"/>
            <!-- date -->
            <xsl:text>, </xsl:text>
            <xsl:value-of select="format-date(tei:monogr/tei:imprint/tei:date[1]/@when,'[D1] [MNn] [Y0001]')"/>
        </xsl:param>
        <fo:bookmark starting-state="show">
            <xsl:attribute name="internal-destination" select="$p_destination"/>
            <fo:bookmark-title>
                <xsl:value-of select="$p_title"/>
            </fo:bookmark-title>
        </fo:bookmark>
    </xsl:template>
    <!-- generate page sequence -->
    <xsl:template name="t_generate-page-sequence" match="tei:biblStruct" mode="m_page-sequence">
        <fo:page-sequence master-reference="A4">
            <fo:flow flow-name="xsl-region-body">
                <!-- here, every image should be added -->
                <!-- each <tei:surface> should generate a new page -->
                <xsl:apply-templates select="ancestor::tei:TEI/tei:facsimile/tei:surface" mode="m_pages"/>
                
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>
    <!-- generate individual pages -->
    <xsl:template name="t_generate-page" match="tss:attachmentReference" mode="m_pages">
        <xsl:param name="p_page-number" select="count(preceding-sibling::tss:attachmentReference)+1"/>
        <xsl:param name="p_issue-number" select="ancestor::tss:reference//tss:characteristic[@name='volume']"/>
        <xsl:param name="p_image-url" select="tss:URL"/>
        <fo:block>
            <xsl:attribute name="id" select="concat('i_',$p_issue-number,'-p_',$p_page-number)"/>
            <fo:external-graphic height="297mm" width="210mm" content-width="scale-to-fit" content-height="scale-to-fit" scaling="uniform">
                <xsl:attribute name="src">
                    <xsl:value-of select="$p_image-url"/>
                </xsl:attribute>
            </fo:external-graphic>
        </fo:block>
    </xsl:template>
    
    <xsl:template match="tei:surface" mode="m_pages">
        <xsl:call-template name="t_generate-page">
            <xsl:with-param name="p_page-number" select="count(preceding-sibling::tei:surface)+1"/>
            <xsl:with-param name="p_issue-number" select=" ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:biblScope[@unit='issue']/@from"/>
            <xsl:with-param name="p_image-url" select="tei:graphic[ starts-with(@url,'../')][1]/@url"/>
        </xsl:call-template>
    </xsl:template>
    
</xsl:stylesheet>