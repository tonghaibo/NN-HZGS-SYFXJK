function x_CHIS_MAINFRAM(){
var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var ret = "";
//
// 
//
function GetBody(){

var html="

<html>
<head>
    <title>����ҽԺ</title>
    <meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=0, minimal-ui\">
    <meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />
    <META HTTP-EQUIV=\"Pragma\" CONTENT=\"no-cache\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />
    <link rel=\"stylesheet\" type=\"text/css\" href=\"sytx/js/chis/css/icons.css\" />
    <link rel=\"stylesheet\" type=\"text/css\" href=\"sytx/js/chis/css/ss.css\" />
	<link href=\"sytx/js/chis/css/cate.css\" rel=\"stylesheet\" type=\"text/css\" />
     <script type=\"text/javascript\" charset=\"utf-8\" src=\"http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js\"></script>
	<script type=\"text/javascript\" charset=\"utf-8\" src=\"http://cdnjs.cloudflare.com/ajax/libs/fastclick/1.0.3/fastclick.min.js\"></script>   
	<script type=\"text/javascript\" charset=\"utf-8\" src=\"sytx/js/chis/js/appframework.ui.js\"></script>
	<style type=\"text/css\" >
	.copyright {
	padding: 8px;
	text-align: center;
	font-size: 14px;
	color:#B2B2B2;
	}
	</style>

<link type=\"text/css\" href=\"sytx/js/chis/css/style.css\" rel=\"stylesheet\"/>
<script type=\"text/javascript\" src=\"sytx/js/chis/js/jquery-1.7.1.min.js\"></script>
<script type=\"text/javascript\" src=\"sytx/js/chis/js/jquery.event.drag-1.5.min.js\"></script>
<script type=\"text/javascript\" src=\"sytx/js/chis/js/jquery.touchSlider.js\"></script>
<script type=\"text/javascript\">
$(document).ready(function(){

	$(\".main_visual\").hover(function(){
		$(\"#btn_prev,#btn_next\").fadeIn()
	},function(){
		$(\"#btn_prev,#btn_next\").fadeOut()
	});
	
	$dragBln = false;
	
	$(\".main_image\").touchSlider({
		flexible : true,
		speed : 200,
		btn_prev : $(\"#btn_prev\"),
		btn_next : $(\"#btn_next\"),
		paging : $(\".flicking_con a\"),
		counter : function (e){
			$(\".flicking_con a\").removeClass(\"on\").eq(e.current-1).addClass(\"on\");
		}
	});
	
	$(\".main_image\").bind(\"mousedown\", function() {
		$dragBln = false;
	});
	
	$(\".main_image\").bind(\"dragstart\", function() {
		$dragBln = true;
	});
	
	$(\".main_image a\").click(function(){
		if($dragBln) {
			return false;
		}
	});
	
	timer = setInterval(function(){
		$(\"#btn_next\").click();
	}, 5000);
	
	$(\".main_visual\").hover(function(){
		clearInterval(timer);
	},function(){
		timer = setInterval(function(){
			$(\"#btn_next\").click();
		},5000);
	});
	
	$(\".main_image\").bind(\"touchstart\",function(){
		clearInterval(timer);
	}).bind(\"touchend\", function(){
		timer = setInterval(function(){
			$(\"#btn_next\").click();
		}, 5000);
	});
	
});
</script>
<link type=\"text/css\" href=\"sytx/js/chis/css/menu.css\" rel=\"stylesheet\" />
<script type=text/javascript>
function clicul(id){
	var li=document.getElementById(id);
	if(li.style.display=='none' || li.style.display=='' ){
		li.style.display='block';
	}
	else{
	 	li.style.display='none';
	}

}

</script>

</head>
<body > 
    <div class=\"view\" id=\"mainview\">
        <header>
            <h1>����ҽԺ</h1>
        </header>

        <div class=\"pages\">
             <!--Initial List of items-->
            <div class=\"panel\" data-title=\"����ҽԺ\" id=\"list\" data-selected=\"true\" style=\"margin:0;padding:0;\">
			<div class=\"main_visual\" id=\"test\" style=\"margin-left:0;margin-right:0\">
					<div class=\"flicking_con\">
						<a href=\"#\">1</a>
						<a href=\"#\">2</a>
						<a href=\"#\">3</a>
						<a href=\"#\">4</a>
					</div>
					<div class=\"main_image\">
						<ul>
							<li><span ><img src=\"sytx/chisimg//3.jpg\" style=\"width:100%;\"></span></li>
							<li><span ><img src=\"sytx/chisimg/4.jpg\" style=\"width:100%;\"></span></li>
							<li><span ><img src=\"sytx/chisimg/1.jpg\" style=\"width:100%;\"></span></li>
							<li><span ><img src=\"sytx/chisimg/2.jpg\" style=\"width:100%;\"></span></li>
						</ul>
						<a href=\"javascript:;\" id=\"btn_prev\"></a>
						<a href=\"javascript:;\" id=\"btn_next\"></a>
					</div>
				</div>


				<ul class=\"mainmenu\">
				<li align=\"left\"><a href=\"#\" onclick=\"window.location.href='L.sp?id=MYROOM'\" style=\"text-decoration:none;\"><em></em><p><span >�������ⳡ��</span><i>�����򵼡�ҽԺ����</i></p><b></b></a></li>
				<li align=\"left\"><a href=\"#\" onclick=\"window.location.href='L.sp?id=CHARTWE'\" style=\"text-decoration:none;\"><em></em><p><span>Ԥ��</span><i>Ԥ����ԱЭ��������</i></p><b></b></a></li>
				
				<!--<li>-->
					<table border=\"0\" width=\"100%\"  height=100% cellspacing=\"0\" cellpadding=\"0\" >
					<table id=\"PAGE_MAIN_HAPP_Tool\" border=\"0\" width=\"100%\"  height=10% id=\"TABLE_MAIN\" cellspacing=\"7\" cellpadding=\"0\"  bgcolor=\"#EEEEEE\">
					<tr >
						<td width=50% onclick=\"javascript:window.location='L.sp?id=SJNK';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"\" valign=\"\" style=\"padding-top:0px;padding-bottom:0px;margin:0;border:1px  #FFFFFF solid;\">
							<table border=0 width=100% height=100% cellspacing=\"0\"  cellpadding=\"0\"  ><tr >
								<td align=\"center\" bgcolor=\"#FFFFFF\" width=50 width=\"120\"><img width=50px height=50px src=\"sytx/chisimg/icon1.png\"></td><td align=left valign=middle bgcolor=#FFFFFF>���ڿ�<br><font size=2 color=#666666>5λҽ������</font></td></tr></table>
						</td>
						<td  onclick=\"javascript:window.location='L.sp?id=SJNK';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"\" valign=\"\" style=\"padding-top:0px;padding-bottom:0px;margin:0;border:1px  #FFFFFF solid;\" >
							<table border=0 width=100% height=100% cellspacing=\"0\"  cellpadding=\"0\"  ><tr >
								<td align=\"center\" bgcolor=\"#FFFFFF\" width=50 width=\"159\"><img width=50px height=50px src=\"sytx/chisimg/icon2.png\"></td><td align=left valign=middle bgcolor=#FFFFFF>�����<br><font size=2 color=#666666>3λҽ������</font></td></tr></table>
						</td>
					</tr>
					<tr >
						<td width=50%  onclick=\"javascript:window.location='L.sp?id=SJNK';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"center\" valign=\"\" style=\"padding-top:0px;padding-bottom:0px;margin:0;border:1px  #FFFFFF solid;\">
							<table border=0 width=100% height=100% cellspacing=\"0\"  cellpadding=\"0\"  ><tr >
								<td align=\"center\" bgcolor=\"#FFFFFF\" width=50 width=\"120\"><img width=50px height=50px src=\"sytx/chisimg/icon3.png\"></td><td align=left valign=middle bgcolor=#FFFFFF>��Ⱦ��<br><font size=2 color=#666666>3λҽ������</font></td></tr></table>
						</td>
						<td  onclick=\"javascript:window.location='L.sp?id=SJNK';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"\" valign=\"\" style=\"padding-top:0px;padding-bottom:0px;margin:0;border:1px  #FFFFFF solid;\">
							<table border=0 width=100% height=100% cellspacing=\"0\"  cellpadding=\"0\"  ><tr >
								<td align=\"center\" bgcolor=\"#FFFFFF\" width=50 width=\"158\"><img width=50px height=50px src=\"sytx/chisimg/icon4.png\"></td><td align=left valign=middle bgcolor=#FFFFFF>�����ڿ�<br><font size=2 color=#666666>3λҽ������</font></td></tr></table>

						</td>
						
					</tr>
					<tr >
						<td width=50%  onclick=\"javascript:window.location='L.sp?id=SJNK';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"\" valign=\"\" style=\"padding-top:0px;padding-bottom:0px;margin:0;border:1px  #FFFFFF solid;\">
							<table border=0 width=100% height=100% cellspacing=\"0\"  cellpadding=\"0\"  ><tr >
								<td align=\"center\" bgcolor=\"#FFFFFF\" width=50 width=\"158\"><img width=50px height=50px src=\"sytx/chisimg/icon4.png\"></td><td align=left valign=middle bgcolor=#FFFFFF>�����ڿ�<br><font size=2 color=#666666>3λҽ������</font></td></tr></table>

						</td>
						<td  onclick=\"javascript:window.location='L.sp?id=SJNK';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"\" valign=\"\" style=\"padding-top:0px;padding-bottom:0px;margin:0;border:1px  #FFFFFF solid;\">
							<table border=0 width=100% height=100% cellspacing=\"0\"  cellpadding=\"0\"  ><tr >
								<td align=\"center\" bgcolor=\"#FFFFFF\" width=50 width=\"121\"><img width=50px height=50px src=\"sytx/chisimg/icon5.png\"></td><td align=left valign=middle bgcolor=#FFFFFF>�ǿ�<br><font size=2 color=#666666>3λҽ������</font></td></tr></table>
						</td>
					</tr>

					</table>
					</td></tr></table>
				<!--</li>-->
				
				<li align=\"left\"><a href=\"#onetoone\" target=\"_Blank\" style=\"text-decoration:none;\"><em></em><p><span>��ҽ��</span><i>�ؼ��֡������Ҳ���ר��</i></p><b></b></a></li>
				<div id=\"DIV_2_0\" style=\"margin:0;border:0;overflow-x:auto;\">
				<!-- layout item 2_0-->
				<table width=\"100%\"><tbody><tr align=\"center\"><td><a href=\"#\" onclick=\"javascript:window.location='L.sp?id=ABOUTDOC';\" style=\"text-decoration:none;\">
				<div><img src=\"sytx/chisimg/EAFormBlob.png\" width=\"80px\" style=\"margin:15px;border-radius:50%;\"></div>
				<div>������</div><div>����ҽʦ</div></a></td><td><a href=\"#\" onclick=\"javascript:window.location='L.sp?id=ABOUTDOC';\" style=\"text-decoration:none;\">
				<div><img src=\"sytx/chisimg/EAFormBlob(1).png\" width=\"80px\" style=\"margin:15px;border-radius:50%;\"></div>
				<div>��Ȫ</div><div>����ҽʦ</div></a></td><td><a href=\"#\" onclick=\"javascript:window.location='L.sp?id=ABOUTDOC';\" style=\"text-decoration:none;\">
				<div><img src=\"sytx/chisimg/EAFormBlob(2).png\" width=\"80px\" style=\"margin:15px;border-radius:50%;\"></div>
				<div>�º�</div><div>����ҽʦ</div></a></td><td><a href=\"#\" onclick=\"javascript:window.location='L.sp?id=ABOUTDOC';\" style=\"text-decoration:none;\">
				<div><img src=\"sytx/chisimg/EAFormBlob(3).png\" width=\"80px\" style=\"margin:15px;border-radius:50%;\"></div>
				<div>����</div><div>����ҽʦ</div></a></td><td><a href=\"#\" onclick=\"javascript:window.location='L.sp?id=ABOUTDOC';\" style=\"text-decoration:none;\">
				<div><img src=\"sytx/chisimg/EAFormBlob(4).png\" width=\"80px\" style=\"margin:15px;border-radius:50%;\"></div>
				<div>��Խ</div><div>����ҽʦ</div></a></td><td><a href=\"#\" onclick=\"javascript:window.location='L.sp?id=ABOUTDOC';\" style=\"text-decoration:none;\">
				<div><img src=\"sytx/chisimg/EAFormBlob(5).png\" width=\"80px\" style=\"margin:15px;border-radius:50%;\"></div>
				<div>Ǯ��</div><div>����ҽʦ</div></a></td><td><a onclick=\"javascript:window.location='L.sp?id=ABOUTDOC';\" style=\"text-decoration:none;\">
				<div><img src=\"sytx/chisimg/EAFormBlob(7).png\" width=\"80px\" style=\"margin:15px;border-radius:50%;\"></div>
				<div>Ҷ����</div><div>������</div></a></td><td><a onclick=\"javascript:window.location='L.sp?id=ABOUTDOC';\" style=\"text-decoration:none;\">
				<div><img src=\"sytx/chisimg/EAFormBlob(8).png\" width=\"80px\" style=\"margin:15px;border-radius:50%;\"></div>
				<div>��</div><div>������Ա</div></td><td><a href=\"#\" onclick=\"javascript:window.location='L.sp?id=ABOUTDOC';\" style=\"text-decoration:none;\">
				<div><img src=\"sytx/chisimg/EAFormBlob(9).png\" width=\"80px\" style=\"margin:15px;border-radius:50%;\"></div>
				<div>����a</div><div>��ʿ</div></a></td><td><a href=\"#\" onclick=\"javascript:window.location='L.sp?id=ABOUTDOC';\" style=\"text-decoration:none;\">
				<div><img src=\"sytx/chisimg/EAFormBlob(10).png\" width=\"80px\" style=\"margin:15px;border-radius:50%;\"></div><div>����b</div>
				<div>��ʿ</div></a></td></tr></tbody></table>
				<!-- end layout item 2_0-->
				</div><!-- ��Ԫ�� DIVMOBILE-->

				<li align=\"left\"><a href=\"\" onclick=\"javascript:window.location='L.sp?id=MAPFIND';\" target=\"_Blank\" style=\"text-decoration:none;\"><em></em><p><span>��ҽԺ</span><i>��ͼ�����ҵ�����</i></p><b></b></a></li>
				</ul>
			<div class=\"copyright\">Copyright ? 2004-2015 <a>˶���ƿ���</a> All rights reserved.</div><br><br>
            </div>
        <!--Detail View Pages for each list item-->

       

        <div class=\"panel\" data-title=\"�ҵ�\" id=\"szinfo\" data-footer=\"none\">
        	<ul class=\"mainmenu\" style=\"display:none;\"></ul>
		<table id=\"PAGE_MAIN_app\" border=\"0\" width=\"100%\"  height=100% id=\"TABLE_MAIN\" cellspacing=\"3\" cellpadding=\"0\" >
			<tr ><!-- ��Ԫ�� TABLE-->
			<td  onclick=\"javascript:window.location='L.sp?id=CHARTCHIS';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"CENTER\" valign=\"MIDDLE\" style=\"margin:0;border:0;background-color:#1859B7;\" colspan=2>
			<!-- layout item 0_0-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_146.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">�������ͼ</font></td></tr></table>
			<!-- end layout item 0_0-->
			</td><!-- ��Ԫ�� TABLE-->
			<td  onclick=\"javascript:window.location='L.sp?id=SVGCHIS';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"CENTER\" valign=\"MIDDLE\" style=\"margin:0;border:0;background-color:#04AEDA;\">
			<!-- layout item 0_2-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_120.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">���̷���ͼ</font></td></tr></table>
			<!-- end layout item 0_2-->
			</td></tr><tr ><!-- ��Ԫ�� TABLE-->
			<td  onclick=\"javascript:window.location='L.sp?id=ME_BASICCHIS';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"CENTER\" valign=\"MIDDLE\" style=\"margin:0;border:0;background-color:#00A9EC;\">
			<!-- layout item 1_0-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_119.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">������ʷ</font></td></tr></table>
			<!-- end layout item 1_0-->
			</td><!-- ��Ԫ�� TABLE-->
			<td  onclick=\"javascript:window.location='L.sp?id=ME_BASICCHIS';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"\" valign=\"\" style=\"margin:0;border:0;background-color:#E4696A;\">
			<!-- layout item 1_1-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_47.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">�ż��ＰסԺ��Ϣ</font></td></tr></table>
			<!-- end layout item 1_1-->
			</td><!-- ��Ԫ�� TABLE-->
			<td  onclick=\"javascript:window.location='L.sp?id=ME_BASICCHIS';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"\" valign=\"\" style=\"margin:0;border:0;background-color:#00A8EC;\">
			<!-- layout item 1_2-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_134.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">��������Ϣ</font></td></tr></table>
			<!-- end layout item 1_2-->
			</td></tr><tr ><!-- ��Ԫ�� TABLE-->
			<td  onclick=\"javascript:window.location='L.sp?id=ME_BASICCHIS';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"CENTER\" valign=\"MIDDLE\" style=\"margin:0;border:0;background-color:#36729E;\">
			<!-- layout item 2_0-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_111.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">�������</font></td></tr></table>
			<!-- end layout item 2_0-->
			</td><!-- ��Ԫ�� TABLE-->
			<td  onclick=\"javascript:window.location='L.sp?id=ME_BASICCHIS';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"CENTER\" valign=\"MIDDLE\" style=\"margin:0;border:0;background-color:#AA3F41;\">
			<!-- layout item 2_1-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_112.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">�����豸</font></td></tr></table>
			<!-- end layout item 2_1-->
			</td><!-- ��Ԫ�� TABLE-->
			<td  onclick=\"javascript:window.location='L.sp?id=ME_BASICCHIS';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"\" valign=\"\" style=\"margin:0;border:0;background-color:#04AEDA;\">
			<!-- layout item 2_2-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_136.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">��ͥ�Բ�����</font></td></tr></table>
			<!-- end layout item 2_2-->
			</td></tr><tr ><!-- ��Ԫ�� TABLE-->
			<td  onclick=\"javascript:window.location='L.sp?id=LOGINCHIS';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"CENTER\" valign=\"MIDDLE\" style=\"margin:0;border:0;background-color:#54C104;\">
			<!-- layout item 3_0-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_253.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">ע����Ϣ</font></td></tr></table>
			<!-- end layout item 3_0-->
			</td><!-- ��Ԫ�� TABLE-->
			<td  onclick=\"javascript:window.location='L.sp?id=LOGINCHIS';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"\" valign=\"\" style=\"margin:0;border:0;background-color:#009F3C;\">
			<!-- layout item 3_1-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_150.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">������Ϣ</font></td></tr></table>


			<!-- end layout item 3_1-->
			</td><!-- ��Ԫ�� TABLE-->
			<td  onclick=\"javascript:window.location='L.sp?id=BKLOGINCHIS';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"\" valign=\"\" style=\"margin:0;border:0;background-color:#009F3C;\">
			<!-- layout item 3_1-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_26.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">��¼ϵͳ</font></td></tr></table>


			<!-- end layout item 3_1-->
			</td><!-- ��Ԫ�� TABLE-->
			</tr></table>
		


        </div>
        <div class=\"panel\" data-title=\"��������\" id=\"item12\" data-footer=\"none\">
           <ul class=\"mainmenu\">
			<li align=\"left\"><a href=\"\" onclick=\"window.location.href='L.sp?id=MEDICATION'\" style=\"text-decoration:none;\"><em></em><p><span>��ҩ(10)</span><i>�����������ң��ѽ���������</i></p><b></b></a></li>
			<li align=\"left\"><a href=\"\" onclick=\"window.location.href='L.sp?id=DIETCHIS'\" style=\"text-decoration:none;\"><em></em><p><span>��ʳ(9)</span><i>������ʳ�˶�����������������</i></p><b></b></a></li>
			<li align=\"left\"><a href=\"\" onclick=\"window.location.href='L.sp?id=MOTIONCHIS'\" style=\"text-decoration:none;\"><em></em><p><span>�˶�(5)</span><i>ԴȪ�˶��ǽ�����</i></p><b></b></a></li>
			<li align=\"left\"><a href=\"\" onclick=\"window.location.href='L.sp?id=MONITORCHIS'\" style=\"text-decoration:none;\"><em></em><p><span>���(3)</span><i>���Ľ�����ʿ</i></p><b></b></a></li>
			<li align=\"left\"><a href=\"\" onclick=\"window.location.href='L.sp?id=MISSIONCHIS'\" style=\"text-decoration:none;\"><em></em><p><span>����(1)</span><i>Ԥ��������������ܽ���һ·��</i></p><b></b></a></li>
			<li align=\"left\"><a href=\"\" onclick=\"window.location.href='L.sp?id=RESERVATIONCHIS'\" style=\"text-decoration:none;\"><em></em><p><span>ԤԼ����(13)</span><i>Ԥ��������������ܽ���һ·��</i></p><b></b></a></li>
		</ul>	
		</p>
        </div>
		<div class=\"panel\" data-title=\"00\" id=\"item13\" data-footer=\"none\">
            <p>This is detail view for ��������</p>
        </div>
		<div class=\"panel\" data-title=\"��ͨ\" id=\"onetoone\" data-footer=\"none\" style=\"margin:0;padding:0;\">
         <ul class=\"uls\"  onclick=\"clicul('ul1');\" >
				<li class=\"lis\">
					<a href=\"#\" class=\"asa\">��Ѫ��<span class=\"spans\">495</span></a>
				</li>
			</ul>
			<ul class=\"uls\" id=\"ul1\" style=\"display:block;\">
				<li class=\"lis2\" id=\"\" >
					<a href=\"#\" class=\"asa2\" >01 ��ΰ<span class=\"spans2\">5</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">02 ��ҽ��<span class=\"spans2\">15</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">03 ������<span class=\"spans2\">9</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">04 ����<span class=\"spans2\">20</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">05 ��ͩ<span class=\"spans2\">15</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">06 ����<span class=\"spans2\">6</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">07 ���<span class=\"spans2\">1</span></a>
				</li>
			</ul>

			<ul class=\"uls\"  onclick=\"clicul('ul2');\">
				<li class=\"lis\">
					<a href=\"#\" class=\"asa\">���ڿ�<span class=\"spans\">130</span></a>
				</li>
			</ul>
			<ul class=\"uls\" id=\"ul2\" style=\"display:none;\">
			<li class=\"lis2\" id=\"\" >
					<a href=\"#\" class=\"asa2\" >01 ��ΰ<span class=\"spans2\">5</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">02 ��ҽ��<span class=\"spans2\">15</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">03 ������<span class=\"spans2\">9</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">04 ����<span class=\"spans2\">20</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">05 ��ͩ<span class=\"spans2\">15</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">06 ����<span class=\"spans2\">6</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">07 ���<span class=\"spans2\">1</span></a>
				</li>
			</ul>

			<ul class=\"uls\"  onclick=\"clicul('ul3');\">
				<li class=\"lis\">
					<a href=\"#\" class=\"asa\">�ǿ�<span class=\"spans\">205</span></a>
				</li>
			</ul>
			<ul class=\"uls\" id=\"ul3\" style=\"display:none;\">
			<li class=\"lis2\" id=\"\" >
					<a href=\"#\" class=\"asa2\" >01 ��ΰ<span class=\"spans2\">5</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">02 ��ҽ��<span class=\"spans2\">15</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">03 ������<span class=\"spans2\">9</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">04 ����<span class=\"spans2\">20</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">05 ��ͩ<span class=\"spans2\">15</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">06 ����<span class=\"spans2\">6</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">07 ���<span class=\"spans2\">1</span></a>
				</li>
			</ul>
			<ul class=\"uls\"  onclick=\"clicul('ul4');\">
				<li class=\"lis\">
					<a href=\"#\" class=\"asa\">�����<span class=\"spans\">35</span></a>
				</li>
			</ul>
			<ul class=\"uls\" id=\"ul4\" style=\"display:none;\">
			<li class=\"lis2\" id=\"\" >
					<a href=\"#\" class=\"asa2\" >01 ��ΰ<span class=\"spans2\">5</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">02 ��ҽ��<span class=\"spans2\">15</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">03 ������<span class=\"spans2\">9</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">04 ����<span class=\"spans2\">20</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">05 ��ͩ<span class=\"spans2\">15</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">06 ����<span class=\"spans2\">6</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">07 ���<span class=\"spans2\">1</span></a>
				</li>
			</ul>
        </div>
        </div>
         <!--Footer to add tabs if desired-->
        <footer>
            <a href=\"#list\" class=\"icon home\" id='tab1' data-transition=\"slide\">����ҽԺ</a>
            <a href=\"#item12\" class=\"icon heart\" id='tab2' data-transition=\"up-reveal\">��������</a>
	    <a href=\"#onetoone\" class=\"icon pencil\" id='tab3' data-transition=\"none\">��ͨ</a>
	    <a href=\"#szinfo\" class=\"icon user\" id='tab4' data-transition=\"none\">�ҵ�</a>
        </footer>
    </div>
</body>

</html>
";
return html;




}

}