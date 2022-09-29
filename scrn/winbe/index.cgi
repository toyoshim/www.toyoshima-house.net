#!/usr/bin/perl

print <<EOD;
Status: 200 が、がお
Content-Type: text/html; charset=Shift_JIS
X-どうよ？: poor-ed by Perl...弱っ

<html>
<head>
	<title>うぃんび～・激写！？</title>
	<style type="text/css">
<!--
#layer1 {
background-color: #ffffff;
color: #4444ff;
position:absolute;
top: 0;
left: 30px;
z-index: 0;
}
BODY {
background:url("http://www.snowhouse.org/Cg/Comp/harami.jpg") NO-REPEAT RIGHT FIXED
}
-->
	</style>
	<script language="JavaScript">
<!--
function repos() {
	Layer1.style.top = document.body.scrollTop + 0;
}
-->
	</script>
</head>
<body bgcolor="#ffffff" background="http://www.snowhouse.org/Cg/Comp/harami.jpg" onscroll="repos();">
<div id="Layer1">
&nbsp;<br>
私の恥ずかしいスクリーンショットを公開よ♪<br>
&nbsp;<br>
</div>
&nbsp;<br>
&nbsp;<br>
&nbsp;<br>
EOD
opendir DIR, "." or die "can not open directory";
print "<blockquote><table>\n";
@files = readdir DIR;
@files = sort @files;
foreach $file (@files) {
	next if (!("$file" =~ /jpg$/));
	@st = stat "$file";
	$size = $st[7];
	print "<tr><td><a href=\"$file\">$file</a></td><td align=\"right\">$size byte</td></tr>\n";
}
closedir DIR;
print <<EOD;
</table></blockquote>
</body>
</html>
EOD
