function x_CHIS_FG_HEALTH(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var ret = "";
var pub = new JavaPackage ( "com.xlsgrid.net.pub" );
var EAScript= new JavaPackage ( "com.xlsgrid.net.pub.EAScript");
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb");
var layoutpack = new JavaPackage ( "com.xlsgrid.net.layout");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd");	
var langpack = new JavaPackage ( "java.lang"); 
//
function GetBody(){

	var html="
	
	<!--������css �Ǳ����-->
    <link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/css/appframe-icons.css\" />
    <link href=\"xlsgrid/images/flash/css/appframe-cate.css\" rel=\"stylesheet\" type=\"text/css\" />
    <link href=\"xlsgrid/images/flash/css/appframe-ss.css\" rel=\"stylesheet\" type=\"text/css\" />
    <!--������js ��http���ص�jquery211.min.js����ȥ��-->
    <script type=\"text/javascript\" charset=\"utf-8\" src=\"xlsgrid/images/flash/js/fastclick.min.js\"></script>   
	<script src=\"xlsgrid/images/flash/js/angular.min.js\"></script>
	<script src=\"xlsgrid/images/flash/js/jquery211.min.js\"></script> 
	<!--���appframework.ui.js�������ǰ��-->
	<script type=\"text/javascript\" charset=\"utf-8\" src=\"xlsgrid/images/flash/js/appframework.ui.js\"></script>	
<!--����js-->
<link type=\"text/css\" href=\"xlsgrid/images/flash/css/showflgapp_style.css\" rel=\"stylesheet\"/>
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/showflgapp_jquery1.7.1.min.js\"></script>
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery.event.drag-1.5.min.js\"></script>
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery.touchSlider.js\"></script>
<link type=\"text/css\" href=\"xlsgrid/images/flash/css/showflgapp_menu.css\" rel=\"stylesheet\" />

	
	<ul class=\"mainmenu\">
		<li align=\"left\"><a href=\"#\" onclick=\"openWindow('L.sp?id=MEDICATION');\" style=\"text-decoration:none;\"><em></em><p><span>��ҩ(10)</span><i>�����������ң��ѽ���������</i></p><b></b></a></li>
		<li align=\"left\"><a href=\"#\" onclick=\"openWindow('L.sp?id=DIETCHIS');\" style=\"text-decoration:none;\"><em></em><p><span>��ʳ(9)</span><i>������ʳ�˶�����������������</i></p><b></b></a></li>
		<li align=\"left\"><a href=\"#\" onclick=\"openWindow('L.sp?id=MOTIONCHIS');\" style=\"text-decoration:none;\"><em></em><p><span>�˶�(5)</span><i>ԴȪ�˶��ǽ�����</i></p><b></b></a></li>
		<li align=\"left\"><a href=\"#\" onclick=\"openWindow('L.sp?id=MONITORCHIS');\" style=\"text-decoration:none;\"><em></em><p><span>���(3)</span><i>���Ľ�����ʿ</i></p><b></b></a></li>
		<li align=\"left\"><a href=\"#\" onclick=\"openWindow('L.sp?id=MISSIONCHIS');\" style=\"text-decoration:none;\"><em></em><p><span>����(1)</span><i>Ԥ��������������ܽ���һ·��</i></p><b></b></a></li>
		<li align=\"left\"><a href=\"#\" onclick=\"openWindow('L.sp?id=RESERVATIONCHIS');\" style=\"text-decoration:none;\"><em></em><p><span>ԤԼ����(13)</span><i>Ԥ��������������ܽ���һ·��</i></p><b></b></a></li>
	</ul>	
	</p>
	";
	return html;
}

}