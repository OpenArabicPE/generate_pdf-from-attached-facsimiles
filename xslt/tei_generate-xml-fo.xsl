<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:tss="http://www.thirdstreetsoftware.com/SenteXML-1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/XSL/Format" version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

    <!-- this stylesheet uses TEI <bibl> and <biblStruct> nodes as input and produces XML-FO that can be used to create PDFs with an ANT build file -->
    
    <xsl:include href="generate_xml-fo.xsl"/>

    <xsl:template match="/">
        <xsl:apply-templates select="descendant::tei:sourceDesc/tei:biblStruct" mode="m_pdf"/>
    </xsl:template>
    <xsl:template match="tei:biblStruct" mode="m_pdf">
        <xsl:call-template name="t_generate-fo-file">
            <xsl:with-param name="p_references" select="."/>
            <xsl:with-param name="p_file-name" select="ancestor::tei:TEI/@xml:id"/>
        </xsl:call-template>
    </xsl:template>
    
</xsl:stylesheet>
