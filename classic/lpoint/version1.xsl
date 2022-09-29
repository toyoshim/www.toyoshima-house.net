<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">
<xsl:template match="/">

<xsl:for-each select="lpoint">
  <HTML>
	<xsl:for-each select="head">
	  <HEAD>
	  <TITLE>
		<xsl:value-of select="title"/>
	  </TITLE>
		<xsl:for-each select="screen">
		  <STYLE TYPE="text/css">
		    TABLE{
		      WIDTH:	<xsl:value-of select="@width"/>;
		      HEIGHT:	<xsl:value-of select="@height"/>;
		    }
		  </STYLE>
		</xsl:for-each>
	  </HEAD>
	</xsl:for-each>
	<xsl:for-each select="body">
	  <BODY>
		<xsl:for-each select="scene">
			[<xsl:value-of select="@name"/>]
		  <HR/>
			<xsl:for-each select="script">
			  <TABLE>
			  </TABLE>
				<xsl:for-each select="select">
					<xsl:for-each select="item">
					  &lt;A HREF="">
						<xsl:value-of/>
					  &lt;/A><BR/>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:for-each>
		  <HR/>
		</xsl:for-each>
	  </BODY>
	</xsl:for-each>
  </HTML>
</xsl:for-each>


</xsl:template>
</xsl:stylesheet>
