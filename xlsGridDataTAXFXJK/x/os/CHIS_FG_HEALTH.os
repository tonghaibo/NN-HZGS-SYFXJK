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
	
	<!--这两个css 是必须的-->
    <link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/css/appframe-icons.css\" />
    <link href=\"xlsgrid/images/flash/css/appframe-cate.css\" rel=\"stylesheet\" type=\"text/css\" />
    <link href=\"xlsgrid/images/flash/css/appframe-ss.css\" rel=\"stylesheet\" type=\"text/css\" />
    <!--这三个js 是http下载的jquery211.min.js不能去掉-->
    <script type=\"text/javascript\" charset=\"utf-8\" src=\"xlsgrid/images/flash/js/fastclick.min.js\"></script>   
	<script src=\"xlsgrid/images/flash/js/angular.min.js\"></script>
	<script src=\"xlsgrid/images/flash/js/jquery211.min.js\"></script> 
	<!--这个appframework.ui.js必须放在前面-->
	<script type=\"text/javascript\" charset=\"utf-8\" src=\"xlsgrid/images/flash/js/appframework.ui.js\"></script>	
<!--公用js-->
<link type=\"text/css\" href=\"xlsgrid/images/flash/css/showflgapp_style.css\" rel=\"stylesheet\"/>
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/showflgapp_jquery1.7.1.min.js\"></script>
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery.event.drag-1.5.min.js\"></script>
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery.touchSlider.js\"></script>
<link type=\"text/css\" href=\"xlsgrid/images/flash/css/showflgapp_menu.css\" rel=\"stylesheet\" />

	
	<ul class=\"mainmenu\">
		<li align=\"left\"><a href=\"#\" onclick=\"openWindow('L.sp?id=MEDICATION');\" style=\"text-decoration:none;\"><em></em><p><span>用药(10)</span><i>把信赖交给我，把健康交给你</i></p><b></b></a></li>
		<li align=\"left\"><a href=\"#\" onclick=\"openWindow('L.sp?id=DIETCHIS');\" style=\"text-decoration:none;\"><em></em><p><span>饮食(9)</span><i>均衡饮食运动，健康常伴你左右</i></p><b></b></a></li>
		<li align=\"left\"><a href=\"#\" onclick=\"openWindow('L.sp?id=MOTIONCHIS');\" style=\"text-decoration:none;\"><em></em><p><span>运动(5)</span><i>源泉运动是健康的</i></p><b></b></a></li>
		<li align=\"left\"><a href=\"#\" onclick=\"openWindow('L.sp?id=MONITORCHIS');\" style=\"text-decoration:none;\"><em></em><p><span>监测(3)</span><i>您的健康卫士</i></p><b></b></a></li>
		<li align=\"left\"><a href=\"#\" onclick=\"openWindow('L.sp?id=MISSIONCHIS');\" style=\"text-decoration:none;\"><em></em><p><span>宣教(1)</span><i>预防保健生活化，享受健康一路发</i></p><b></b></a></li>
		<li align=\"left\"><a href=\"#\" onclick=\"openWindow('L.sp?id=RESERVATIONCHIS');\" style=\"text-decoration:none;\"><em></em><p><span>预约提醒(13)</span><i>预防保健生活化，享受健康一路发</i></p><b></b></a></li>
	</ul>	
	</p>
	";
	return html;
}

}