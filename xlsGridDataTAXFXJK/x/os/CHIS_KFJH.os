function x_CHIS_KFJH(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var ret = "";
 //ҩƷ������ɲ�ѯ
function GetBody(){
	var css="";
	var html="";
	var script="";
	
html="	


<!DOCTYPE html>
<!--HTML5 doctype-->
<html>

<head>

    <title>�����ƻ�</title>
    <meta http-equiv=\"Content-type\"content=\"text/html; charset=utf-8\">
    <meta name=\"viewport\"content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=0, minimal-ui\">
    <meta name=\"apple-mobile-web-app-capable\"content=\"yes\"/>
    <META HTTP-EQUIV=\"Pragma\"CONTENT=\"no-cache\">
    <meta http-equiv=\"X-UA-Compatible\"content=\"IE=edge\"/>
   
</head>

<body>

    <div class=\"view\"id=\"mainview\">
        <header>
            <h1>�����ƻ�</h1>
        </header>

        <div class=\"pages\">
             <!--Initial List of items-->
            <div class=\"panel\"data-title=\"�����ƻ�\"id=\"list\"data-selected=\"true\">
				<br>
				<input type=\"text\"placeholder=\"Enter Todo\"id=\"todoVal\">
              <ul class=\"list\">
                <li><!--��ҩ-->
				<a href=\"#item1\">
					<div bgcolor=#F8F8F8>
						<table>
							<tr>
								<td rowspan=\"2\">
								<img src=EAFormBlob.sp?guid=1342444E02BD7F6EE050007F0100169D></td>
								<td align=left><font color=#3F3F3F><b>��ҩ</b></font></td>
							</tr>
							<tr>
								<td> <font color=#B2B2B2>�����������ң��ѽ���������</font></td>
							</tr>
						</table>
					</div>

				</a>
				</li>
                <li><!--��ʳ-->
				<a href=\"#item2\">
					<div bgcolor=#F8F8F8>
						<table>
							<tr>
								<td rowspan=\"2\">
								<img src=EAFormBlob.sp?guid=1342444E02BF7F6EE050007F0100169D></td>
								<td align=left><font color=#3F3F3F><b>��ʳ</b></font></td>
							</tr>
							<tr>
								<td> <font color=#B2B2B2>������ʳ�˶�����������������</font></td>
							</tr>
						</table>
					</div>
				</a>
				</li>
                <li><!--�˶�-->
				<a href=\"#item3\">
					<div bgcolor=#F8F8F8>
						<table>
							<tr>
								<td rowspan=\"2\">
								<img src=EAFormBlob.sp?guid=1342444E02C27F6EE050007F0100169D></td>
								<td align=left><font color=#3F3F3F><b>�˶�</b></font></td>
							</tr>
							<tr>
								<td> <font color=#B2B2B2>ԴȪ�˶��ǽ�����</font></td>
							</tr>
						</table>
					</div>
				</a>
				</li>
				<li><!--���-->
				<a href=\"#item4\">
					<div bgcolor=#F8F8F8>
						<table>
							<tr>
								<td rowspan=\"2\">
								<img src=EAFormBlob.sp?guid=1342444E02C57F6EE050007F0100169D></td>
								<td align=left><font color=#3F3F3F><b>���</b></font></td>
							</tr>
							<tr>
								<td> <font color=#B2B2B2>���Ľ�������</font></td>
							</tr>
						</table>
					</div>
				</a>
				</li>
				<li><!--����-->
				<a href=\"#item5\">
					<div bgcolor=#F8F8F8>
						<table>
							<tr>
								<td rowspan=\"2\">
								<img src=EAFormBlob.sp?guid=134256039D713773E050007F01001B47></td>
								<td align=left><font color=#3F3F3F><b>����</b></font></td>
							</tr>
							<tr>
								<td> <font color=#B2B2B2>Ԥ��������������ܽ���һ·��</font></td>
							</tr>
						</table>
					</div>
				</a>
				</li>
				<li><!--ԤԼ����-->
				<a href=\"#item6\">
					<div bgcolor=#F8F8F8>
						<table>
							<tr>
								<td rowspan=\"2\">
								<img src=EAFormBlob.sp?guid=1342444E02CD7F6EE050007F0100169D></td>
								<td align=left><font color=#3F3F3F><b>ԤԼ����</b></font></td>
							</tr>
							<tr>
								<td> <font color=#B2B2B2>Ԥ��������������ܽ���һ·��</font></td>
							</tr>
						</table>
					</div>
				</a>
				</li>
                <li align=left><a href=\"#item3\">Item 3</a></li>
                <li align=left><a href=\"#item4\">Item 4</a></li>
                <li align=left><a href=\"#item5\">Item 5</a></li>
                <li align=left><a href=\"#item6\">Item 6</a></li>
                <li align=left><a href=\"#item7\">Item 7</a></li>
                <li align=left><a href=\"#item8\">Item 8</a></li>
                <li align=left><a href=\"#item9\">Item 9</a></li>
                <li align=left><a href=\"#item10\">Item 10</a></li>
                <li align=left><a href=\"#item11\">Item 11</a></li>
                <li align=left><a href=\"#item12\">Item 12</a></li>
              </ul>
            </div>

        <!--Detail View Pages for each list item-->
        <div class=\"panel\"data-title=\"Item 1\"id=\"item1\"data-footer=\"none\">
            <p>This is detail view for Item 1</p>
        </div>

        <div class=\"panel\"data-title=\"Item 2\"id=\"item2\"data-footer=\"none\">
            <p>This is detail view for Item 2</p>
        </div>

        <div class=\"panel\"data-title=\"Item 3\"id=\"item3\"data-footer=\"none\">
            <p>This is detail view for Item 3</p>
        </div>

        <div class=\"panel\"data-title=\"Item 4\"id=\"item4\"data-footer=\"none\">
            <p>This is detail view for Item 4</p>
        </div>

        <div class=\"panel\"data-title=\"Item 5\"id=\"item5\"data-footer=\"none\">
            <p>This is detail view for Item 5</p>
        </div>

        <div class=\"panel\"data-title=\"Item 6\"id=\"item6\"data-footer=\"none\">
            <p>This is detail view for Item 6</p>
        </div>

        <div class=\"panel\"data-title=\"Item 7\"id=\"item7\"data-footer=\"none\">
            <p>This is detail view for Item 7</p>
        </div>

        <div class=\"panel\"data-title=\"Item 8\"id=\"item8\"data-footer=\"none\">
            <p>This is detail view for Item 8</p>
        </div>

        <div class=\"panel\"data-title=\"Item 9\"id=\"item9\"data-footer=\"none\">
            <p>This is detail view for Item 9</p>
        </div>

        <div class=\"panel\"data-title=\"Item 10\"id=\"item10\"data-footer=\"none\">
            <p>This is detail view for Item 10</p>
        </div>

        <div class=\"panel\"data-title=\"Item 11\"id=\"item11\"data-footer=\"none\">
            <p>This is detail view for Item 11</p>
        </div>

        <div class=\"panel\"data-title=\"Item 12\"id=\"item12\"data-footer=\"none\">
            <p>This is detail view for Item 12</p>
        </div>

        </div>

         <!--Footer to add tabs if desired-->
        <footer>
            <a href=\"#main\"class=\"icon home\"data-transition=\"slide\">����</a>
			<a href=\"#main\"class=\"icon settings\"data-transition=\"slide\">����</a>
            <a href=\"#foobar\"class=\"icon heart\"id='tab2' data-transition=\"up-reveal\">Foobar</a>
            <a href=\"#about\"class=\"icon html5\"id='tab3' data-transition=\"slide-left\">About</a>
            <a href=\"#test\"class=\"icon trash\"id='tab4' data-transition=\"none\">test</a>
			<a href=\"#test\"class=\"icon pencil\"id='tab4' data-transition=\"none\">��ѯ</a>	
			<a href=\"#test\"class=\"icon user\"id='tab4' data-transition=\"none\">�ҵ�</a>
        </footer>
    </div>


</body>

</html>







";
var script="<script>
function genpro(){}

";
return css+html+script;
}


}