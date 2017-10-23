function x_CHIS_FG_KSDTL(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var ret = "";

function GetBody(){
//图片地址
var html="
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

<link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/css/appframe-ss.css\" />
	<div class=\"main_visual\" id=\"test\" >
		<div class=\"flicking_con\">
			<a href=\"#\">1</a>
			<a href=\"#\">2</a>
			<a href=\"#\">3</a>
			<a href=\"#\">4</a>
		</div>
		<div class=\"main_image\">
			<ul >
				<li><span ><img src=\"xlsgrid/images/flash/images/movpic_1.jpg\" style=\"width:100%;height:110px;\"></span></li>
				<li><span ><img src=\"xlsgrid/images/flash/images/movpic_2.jpg\" style=\"width:100%;height:110px;\"></span></li>
				<li><span ><img src=\"xlsgrid/images/flash/images/movpic_3.jpg\" style=\"width:100%;height:110px;\"></span></li>
				<li><span ><img src=\"xlsgrid/images/flash/images/movpic_4.jpg\" style=\"width:100%;height:110px;\"></span></li>
			</ul>
			<!--css中的图片这里拿出来方便下载-->
			<a href=\"javascript:;\" id=\"btn_prev\"  style=\"background: url(xlsgrid/images/flash/images/movpic_left.png) no-repeat left top;\"></a>
			<a href=\"javascript:;\" id=\"btn_next\" style=\"background: url(xlsgrid/images/flash/images/movpic_right.png) no-repeat right top;\"></a>
		</div>
	</div>
		
			
					
		<ul class=\"mainmenu\">
		
		<li align=\"left\"><a href=\"#\" onclick=\"window.location.href='L.sp?id=CHARTWE'\" style=\"text-decoration:none;\"><em></em><p><span>我要看病</span><i>预检人员协助您进行</i></p><b style=\"background: url(xlsgrid/images/flash/images/showflgapp_jt.png) no-repeat;background-size: 15px 19px;\"></b></a></li>
		
		
			<table border=\"0\" width=\"100%\"  height=100% cellspacing=\"0\" cellpadding=\"0\" ><td><tr>
			<table id=\"PAGE_MAIN_HAPP_Tool\" border=\"0\" width=\"100%\"  height=10% id=\"TABLE_MAIN\" cellspacing=\"7\" cellpadding=\"0\"  bgcolor=\"#EEEEEE\">";
			var sql="";
			var ds=null;
			var db=null;
			db = new pubpack.EADatabase();
			sql = "select * from YX_DOCDEPT";
			ds = db.QuerySQL(sql);
			for (var r=0;r<ds.getRowCount();r++) {
				html+="<tr>";
				html+="<td width=50%  onmouseover=this.style.cursor='hand'; width='0' height=0 align='' valign='' style='padding-top:0px;padding-bottom:0px;margin:0;border:1px  #FFFFFF solid;'>";
				html+="<a href='#' onclick=f_openLocalURL('L.sp?id=SJNK&dept="+ds.getStringAt(r,"id")+"');>";
				html+="<table border=0 width=100% height=100% cellspacing=0  cellpadding=0><tr>";
				html+="<td align=center bgcolor=#FFFFFF width=50 width=120><img src='EAFormBlob.sp?guid="+ds.getStringAt(r,"img")+"' width=50px height=50px ></td><td align=left valign=middle bgcolor=#FFFFFF>"+ds.getStringAt(r,"name")+"</td></tr></table>";
				html+="</a></td>";
				r++;
				if(r >= ds.getRowCount()) return;
				html+="<td width=50%  onmouseover=this.style.cursor='hand'; width='0' height=0 align='' valign='' style='padding-top:0px;padding-bottom:0px;margin:0;border:1px  #FFFFFF solid;'>";
				html+="<a href=# onclick=f_openLocalURL('L.sp?id=SJNK&dept="+ds.getStringAt(r,"id")+"');>";
				html+="<table border=0 width=100% height=100% cellspacing=0 cellpadding=0><tr>";
				html+="<td align=center bgcolor=#FFFFFF width=50 width=120><img src='EAFormBlob.sp?guid="+ds.getStringAt(r,"img")+"' width=50px height=50px ></td><td align=left valign=middle bgcolor=#FFFFFF>"+ds.getStringAt(r,"name")+"</td></tr></table>";
				html+="</a></td>";
				html+="</tr>";
			}
			
			html+="</table>
			</td></tr></table>
		
		
		<li align=\"left\"><a href=\"#all_panel3\"  target=\"_Blank\" style=\"text-decoration:none;\"><em></em><p><span>找医生</span><i>关键字、按科室查找专家</i></p><b style=\"background: url(xlsgrid/images/flash/images/showflgapp_jt.png) no-repeat;background-size: 15px 19px;\"></b></a></li>
		
		<div id=\"DIV_2_0\" style=\"margin:0;border:0;overflow-x:auto;\">
		<table width=\"100%\"><tbody><tr align=\"center\">";
		var sql="";
		var ds=null;
		var db=null;
		db = new pubpack.EADatabase();
		try{
			sql="select id, rownum,guid,name,jobtitle,img from yx_doc where img is not null and rownum<=15 and name<>'潘宇' and org='CHIS'";
			ds=db.QuerySQL(sql);
			if(ds.getRowCount()!=0){
				for (var r = 0;r < ds.getRowCount(); r++) {
					html += "<td><a href=\"#ABOUTDOCpanel\"  style=\"text-decoration:none;\" onclick=f_openLocalURL('L.sp?id=ABOUTDOC&uid="+ds.getStringAt(r,"id")+"');>";
					html += "<div><img src=\"EAFormBlob.sp?guid="+ds.getStringAt(r,"img")+"\" width=\"80px\" style=\"margin:15px;border-radius:50%;\"></div>";
					html += "<div>"+ds.getStringAt(r,"name")+"</div><div>"+ds.getStringAt(r,"jobtitle")+"</div></a></td>";
				}
			}
		} catch(e){}
		if(db!=null){db.Close();}
		
		html +="</tr></tbody></table>
			<!-- end layout item 2_0-->
			</div><!-- 单元格 DIVMOBILE-->
	
			<li align=\"left\"><a href=\"#\"  target=\"_Blank\" style=\"text-decoration:none;\" onclick=\"f_openLocalURL('L.sp?id=MAPFIND');\"><em></em><p><span>找医院</span><i>地图快速找到我们</i></p><b style=\"background: url(xlsgrid/images/flash/images/showflgapp_jt.png) no-repeat;background-size: 15px 19px;\"></b></a></li>
			<li align=\"left\"><a href=\"#\" onclick=\"openWindow('L.sp?id=MYROOM');\" style=\"text-decoration:none;\"><em></em><p><span >进入虚拟场景</span><i>就诊向导、医院场景</i></p><b style=\"background: url(xlsgrid/images/flash/images/showflgapp_jt.png) no-repeat;background-size: 15px 19px;\"></b></a></li>
			</ul>
			
			<div class=\"copyright\">Copyright ? 2004-2015 <a>硕格云开发</a> All rights reserved.</div><br><br>";
//html=getlayout(request,"CHIS_TEST01");
return html;
}

//获取图片参数
function genstr(str){

	var sql="";
	var ds="";
	var db=null;
	db = new pubpack.EADatabase();
	var layid="";
	try{
		sql="
			SELECT B.* FROM LAYOBJ A ,LAYOBJDTL B  
			WHERE A.GUID=B.FORMGUID 
			AND A.ID ='CHISMOVEPIC' AND A.CLS='CHIS'and B.id ='"+str+"'
		";
		ds=db.QuerySQL(sql);
		if(ds.getRowCount()==1){
			layid=ds.getStringAt(0,"VAL");
			return layid; 
		}
	}
	catch(e){ throw new Exception(e);}
	if(db!=null){db.Close();}
}

//各科医生
function genSJNK(){
var dep = pubpack.EAFunc.NVL( request.getParameter("dept"),"") ;

var html="

<link href=\"xlsgrid/images/flash/css/appframe-cate.css\" rel=\"stylesheet\" type=\"text/css\" />

<link href=\"xlsgrid/images/flash/css/sjnk_iscroll.css\" rel=\"stylesheet\" type=\"text/css\" />
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/iscroll.js\"></script>
<script type=\"text/javascript\">
var myScroll;
function loaded() {

	myScroll = new iScroll('wrapper', {
		snap: true,
		momentum: false,
		hScrollbar: false,
		onScrollEnd: function () {
			document.querySelector('#indicator > li.active').className = '';
			document.querySelector('#indicator > li:nth-child(' + (this.currPageX+1) + ')').className = 'active';
		}
	});
}

document.addEventListener('DOMContentLoaded', loaded, false);
</script>

</head>
<style type='text/css'>
hr
{
	display: block;
	-webkit-margin-before: 0.5em;
	-webkit-margin-after: 0.5em;
	-webkit-margin-start: auto;
	-webkit-margin-end: auto;
	border-style: inset;
	border-width: 1px;
}
</style>

<!--<script type=\"text/javascript\" src=\"sytx/js/chis/css/jquery.min.js\"></script>-->

<script type=\"text/javascript\">
$(document).ready(function(){
	playbox.init(\"playbox\");
	/*
	setTimeout(function() {
		// IE
		if(document.all) {
			document.getElementById(\"playbox\").click();
		}
		// 其它浏览器
		else {
			var e = document.createEvent(\"MouseEvents\");
			e.initEvent(\"click\", true, true);
			document.getElementById(\"playbox\").dispatchEvent(e);
		}
	}, 2000);
	*/
});

</script>";
//f_openLocalURL
//openWindow
var sql="";
var ds=null;
var db=null;
var dept = "";
db = new pubpack.EADatabase();
	try{dept = dep;}catch(e){dept = "";}
	if(dept == "") {
		sql="select a.id,a.name,b.name job,a.img,a.BEGOODATNAM,a.viscera,a.hospital from yx_doc a,yx_docjob b where a.jobtitle=b.id and a.org='CHIS' and iskf is null";
	} else {
		sql="select a.id,a.name,b.name job,a.img,a.BEGOODATNAM,a.viscera,a.hospital from yx_doc a,yx_docjob b where a.jobtitle=b.id and a.org='CHIS' and a.DEPARTMENT='"+dep+"' and iskf is null"; 
	}
	ds=db.QuerySQL(sql);
	html += "<img src=\"EAFormBlob.sp?guid=184E4ECA152C6272E050007F01007E91\" style=\"width:100%;height:100px;\"/>";
	if(ds.getRowCount()!=0){
		for (var r = 0;r < ds.getRowCount(); r++) {
			html += "<div bgcolor=#F8F8F8>";
			html +="<a  onclick=\"javascript:openWindow('L.sp?id=ABOUTDOC&uid="+ds.getStringAt(r,"id")+"')\">";
			
			html +="<table >";
			html +="<tr ><td rowspan=\"4\" ><img src=\"EAFormBlob.sp?guid="+ds.getStringAt(r,"img")+"\" style=\"margin:15px;border-radius:50%;width:60px;height:60px;\"></td><td align=\"left\"><font color=#3F3F3F>姓名：</font><font size=\"2\" color=#B2B2B2>"+ds.getStringAt(r,"name")+"</font></td></tr>";
			html +="<tr><td align=\"left\" > <font size=\"2\" color=\"#3F3F3F\">职称：</font><font  color=\"#B2B2B2\">"+ds.getStringAt(r,"job")+"</font></td></tr>";
			html +="<tr><td align=\"left\"> <font size=\"2\" color=\"#3F3F3F\">擅长领域：</font><font  color=\"#B2B2B2\">"+ds.getStringAt(r,"viscera")+"</font></td></tr>";
			html +="<tr><td align=\"left\"> <font size=\"2\" color=\"#3F3F3F\">擅长病种：</font><font  color=\"#B2B2B2\">"+ds.getStringAt(r,"BEGOODATNAM")+"</font></td></tr>";
			html +="</table>";
			html +="</a>";
			html += "</div><hr>";
		}
	}

if(db!=null){db.Close();}

html += "<style type=\"text/css\">
.top_bar{position:fixed;z-index:900;bottom:-1px;left:0;right:0;}
.top_menu{
	border-top:1px solid #b3b3b3;width:100%;height:40px;margin:0;padding:0;
	
	background:rgba(255, 255, 255, 0.7);
	background:-webkit-gradient(linear, 0 0, 0 100%, from(#e7e4e7), to(#b9b9b9));
	background:-o-gradient(linear, 0 0, 0 100%, from(#e7e4e7), to(#b9b9b9));
	background:gradient(linear, 0 0, 0 100%, from(#e7e4e7), to(#b9b9b9));
}
.top_bar .top_menu>li{
	position:relative;text-align:center;display:inline-block;width:25%;float:left;
	
	background:-webkit-gradient(linear, 0 0, 0 100%, from(rgba(0, 0, 0, 0.1)), color-stop(50%, rgba(0, 0, 0, 0.2)), to(rgba(0, 0, 0, 0.2))), -webkit-gradient(linear, 0 0, 0 100%, from(rgba(255, 255, 255, 0.1)), color-stop(50%, rgba(255, 255, 255, 0.3)), to(rgba(255, 255, 255, 0.1)));
	background:-o-gradient(linear, 0 0, 0 100%, from(rgba(0, 0, 0, 0.1)), color-stop(50%, rgba(0, 0, 0, 0.2)), to(rgba(0, 0, 0, 0.2))), -o-gradient(linear, 0 0, 0 100%, from(rgba(255, 255, 255, 0.1)), color-stop(50%, rgba(255, 255, 255, 0.3)), to(rgba(255, 255, 255, 0.1)));
	background:gradient(linear, 0 0, 0 100%, from(rgba(0, 0, 0, 0.1)), color-stop(50%, rgba(0, 0, 0, 0.2)), to(rgba(0, 0, 0, 0.2))), gradient(linear, 0 0, 0 100%, from(rgba(255, 255, 255, 0.1)), color-stop(50%, rgba(255, 255, 255, 0.3)), to(rgba(255, 255, 255, 0.1)));
}
.top_bar .top_menu li a label{padding:3px 0 0 3px;font-size:12px;overflow:hidden;}
.top_menu>li:first-child{background:none;}
.top_bar .top_menu>li>a{height:40px;line-height:40px;display:block;text-align:center;color:#4f4d4f;text-shadow:0 1px rgba(255, 255, 255, 0.3);text-decoration:none;border-top:1px solid #f9f9f9;}
.top_bar .top_menu>li>a p{overflow:hidden;margin:0 0 0 0;font-size:12px;display:block!important;line-height:18px;text-align:center;}
.top_bar .top_menu>li>a img{padding:0;height:20px;width:20px;color:#fff;line-height:40px;vertical-align:middle;}
.top_bar .top_menu>li>a:hover,.top_bar .top_menu>li>a:active{background-color:#CCCCCC;}
</style>

";
return html;
}

//医生微站
function genABOUTDOC(){
var uid = pubpack.EAFunc.NVL( request.getParameter("uid"),"") ;
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var usr=web.EASession.GetLoginInfo(request);
var orgid=usr.getOrgid();
var uuid = uid;

var html="


<link rel=\"shortcut icon\" href=\"http://img.guahao.cn/favicon.ico\">  
<link href=\"xlsgrid/images/flash/css/appframe-cate.css\" rel=\"stylesheet\" type=\"text/css\" />
<link href=\"xlsgrid/images/flash/css/sjnk_iscroll.css\" rel=\"stylesheet\" type=\"text/css\" />

<link href=\"xlsgrid/images/flash/css/sjnk_iscroll.css\" rel=\"stylesheet\" type=\"text/css\" />

<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/iscroll.js\"></script>

<script type=\"text/javascript\">
var myScroll;
function loaded() {

	myScroll = new iScroll('wrapper', {
		snap: true,
		momentum: false,
		hScrollbar: false,
		onScrollEnd: function () {
			document.querySelector('#indicator > li.active').className = '';
			document.querySelector('#indicator > li:nth-child(' + (this.currPageX+1) + ')').className = 'active';
		}
	});

}

document.addEventListener('DOMContentLoaded', loaded, false);
</script>

<script type=\"text/javascript\">

var playbox = (function(){
	//author:eric_wu
	var _playbox = function(){
		var that = this;
		that.box = null;
		that.player = null;
		that.src = null;
		that.on = false;
		//
		that.autoPlayFix = {
			on: true,
			//evtName: (\"ontouchstart\" in window)?\"touchend\":\"click\"
			evtName: (\"ontouchstart\" in window)?\"touchstart\":\"mouseover\"
			
		}

	}
	_playbox.prototype = {
		init: function(box_ele){
			this.box = \"string\" === typeof(box_ele)?document.getElementById(box_ele):box_ele;
			this.player = this.box.querySelectorAll(\"audio\")[0];
			this.src = this.player.src;
			this.init = function(){return this;}
			this.autoPlayEvt(true);
			return this;
		},
		play: function(){
			if(this.autoPlayFix.on){
				this.autoPlayFix.on = false;
				this.autoPlayEvt(false);
			}
			this.on = !this.on;
			if(true == this.on){
				this.player.src = this.src;
				this.player.play();
			}else{
				this.player.pause();
				this.player.src = null;
			}
			if(\"function\" == typeof(this.play_fn)){
				this.play_fn.call(this);
			}
		},
		handleEvent: function(evt){
			this.play();
		},
		autoPlayEvt: function(important){
			if(important || this.autoPlayFix.on){
				document.body.addEventListener(this.autoPlayFix.evtName, this, false);
			}else{
				document.body.removeEventListener(this.autoPlayFix.evtName, this, false);
			}
		}
	}
	//
	return new _playbox();
})();

playbox.play_fn = function(){
	this.box.className = this.on?\"btn_music on\":\"btn_music\";
}
function inroom(str) {
}
</script>";

var sql="";
var ds=null;
var db=null;
db = new pubpack.EADatabase();
try{
	//这里组织先写成：YXIMAGES因为默认的是XLSGRID
	sql="select c.guid,a.name,d.name job,a.img,a.BEGOODAT,a.hospital,a.VISCERA,a.EQUTYPE,a.note from yx_doc a,usr c,yx_docjob d where c.id='"+uid+"'  and a.id=c.id and a.jobtitle=d.id and c.org='CHIS'";
	
	ds=db.QuerySQL(sql);
	if(ds.getRowCount()>0){
			html += "<div style=\"margin-left:12px; margin-top:5px; width:97%\">";
			html += "<img src=\"EAFormBlob.sp?guid="+ds.getStringAt(0,"img")+"\"  style=\"border-radius:50%; float:left; height:90px; margin-right:20px;\">";
			html += "<div style=\"height:50%; text-align:left;\">
					<p style=\"padding:5px\"><font  color=#3F3F3F>姓名：</font><font  color=#B2B2B2>"+ds.getStringAt(0,"name")+"</font></p>
					<p style=\"padding:5px\"><font  color=\"#3F3F3F\">职称：</font><font  color=\"#B2B2B2\">"+ds.getStringAt(0,"job")+"</font></p>
					<p style=\"padding:5px\"><font  color=\"#3F3F3F\">特长：</font><font  color=\"#B2B2B2\">"+ds.getStringAt(0,"VISCERA")+"</font></p>					
				</div>";
			html += "<div style=\"text-align:left; width:100%; margin-right:12px;\">
					<p style=\"padding:3px\"><font  color=\"#444444\">医生介绍：</font></p>
					<div style=\"width:100%;\"><p><font color=\"#B2B2B2\">　　"+ds.getStringAt(0,"note")+"</font></p></div>
				</div>";
			html += "</div>";
			
			html+="<div><ul class=\"mainmenu\">
				
					<li align=\"left\"><button id=\"intoROOM\" type=\"button\" class=\"btn btn-primary btn-lg btn-block\" onclick=\"inroom('"+ds.getStringAt(0,"guid")+"')\">进入诊室</button></li>
				
			</ul>
			</div>";						
						
			
	}
	
} catch(e){}
if(db!=null){db.Close();}
	
return html;
}

//获取布局的html
function getlayout(request,layoutid){
	var db = null;
	var msg= "";
	var objid= pubpack.EAFunc.NVL( request.getParameter("objid"),"") ;
	var skin= pubpack.EAFunc.NVL( request.getParameter("skin"),"") ;
	var hashead = pubpack.EAFunc.NVL( request.getParameter("hashead"),"y") ;
	var deforg =  pubpack.EAFunc.NVL( request.getParameter("thisorgid"),webpack.EAWebDeforg.GetDeforg(request)) ;
	var browsetype = pubpack.EAFunc.getBroswerType( request );
	var sb=new langpack.StringBuffer();
	try{	
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var parent = new x_L();
		parent.GetLayoutHTML(db,request,sb,deforg,layoutid,0,"","");
	}
		catch ( ee ) {
			db.Rollback();
			sb.append("");
						
			//throw new pubpack.EAException ( ee.toString() );
		}
		finally {
			if (db!=null) db.Close();
		}

	return sb.toString();
}
//医生首页
function genDOCMENU1(){
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var usr=web.EASession.GetLoginInfo(request);
var orgid=usr.getOrgid();
var accid=usr.getAccid();
var userid =usr.getUsrid();
var html="

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


<link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/css/appframe-ss.css\" />
	<div class=\"main_visual\" id=\"test\" style=\"margin-left:0;margin-right:0\">
		<div class=\"flicking_con\">
			<a href=\"#\">1</a>
			<a href=\"#\">2</a>
			<a href=\"#\">3</a>
			<a href=\"#\">4</a>
		</div>
		<div class=\"main_image\">
			<ul >
				<li><span ><img src=\"xlsgrid/images/flash/images/movpic_1.jpg\" style=\"width:100%;height:110px;\"></span></li>
				<li><span ><img src=\"xlsgrid/images/flash/images/movpic_2.jpg\" style=\"width:100%;height:110px;\"></span></li>
				<li><span ><img src=\"xlsgrid/images/flash/images/movpic_3.jpg\" style=\"width:100%;height:110px;\"></span></li>
				<li><span ><img src=\"xlsgrid/images/flash/images/movpic_4.jpg\" style=\"width:100%;height:110px;\"></span></li>
			</ul>
			<!--css中的图片这里拿出来方便下载-->
			<a href=\"javascript:;\" id=\"btn_prev\"  style=\"background: url(xlsgrid/images/flash/images/movpic_left.png) no-repeat left top;\"></a>
			<a href=\"javascript:;\" id=\"btn_next\" style=\"background: url(xlsgrid/images/flash/images/movpic_right.png) no-repeat right top;\"></a>
		</div>
	</div>

		<ul class=\"mainmenu\">
		<!--这里不用传用户编号因为聊天组件可以获取全局登录用户信息-->
		<li align=\"left\"><a href=\"#\" onclick=\"javascript:if(G_BROWSETYPE=='IOS')window.open('L.sp?id=CHARTWE&userid="+userid+"');else f_openLocalURL('L.sp?id=CHARTWE&userid="+userid+"');\" style=\"text-decoration:none;\"><em></em><p><span >进入诊室</span><i>进入诊室</i></p><b style=\"background: url(xlsgrid/images/flash/images/showflgapp_jt.png) no-repeat;background-size: 15px 19px;\"></b></a></li>
		<li align=\"left\"><a href=\"#\" onclick=\"f_openLocalURL('L.sp?id=CHIS_PRELIST');\" style=\"text-decoration:none;\"><em></em><p><span>历史记录查询</span><i>查询历史就诊记录</i></p><b style=\"background: url(xlsgrid/images/flash/images/showflgapp_jt.png) no-repeat;background-size: 15px 19px;\"></b></a></li>
        	<li align=\"left\"><a href=\"#\" onclick=\"f_openLocalURL('L.sp?id=CHIS_PRELIST');\" style=\"text-decoration:none;\"><em></em><p><span>预约记录查询</span><i>查询历史就诊记录</i></p><b style=\"background: url(xlsgrid/images/flash/images/showflgapp_jt.png) no-repeat;background-size: 15px 19px;\"></b></a></li>
		</ul>

";
return html;
}


//我要咨询（在线不出诊的医生）
function genzxList(){
var html="";	
var sql="";
var ds=null;
var db=null;
db = new pubpack.EADatabase();

//
try{
	//这里组织先写成：YXIMAGES因为默认的是XLSGRID
	sql="select c.id,c.guid,a.name,d.name job,a.img,a.BEGOODAT,a.hospital,a.VISCERA,a.EQUTYPE,a.note from yx_doc a,usr c,yx_docjob d where a.id=c.id and a.jobtitle=d.id(+) and c.org='CHIS'
	 and  c.id not in (
		select crtusr
		  from yx_monthwork
		 where org = 'CHIS'
		   and ((to_date(dat || ' ' || substr(morning, 7, 99), 'yyyy-mm-dd hh24:mi') >=
		       to_date(to_char(sysdate, 'yyyy-mm-dd hh24:mi'), 'yyyy-mm-dd hh24:mi') and
		       to_date(dat || ' ' || substr(morning, 0, 5), 'yyyy-mm-dd hh24:mi') <=
		       to_date(to_char(sysdate, 'yyyy-mm-dd hh24:mi'), 'yyyy-mm-dd hh24:mi')) or
		       (to_date(dat || ' ' || substr(afternoon, 7, 99),
		                 'yyyy-mm-dd hh24:mi') >=
		       to_date(to_char(sysdate, 'yyyy-mm-dd hh24:mi'), 'yyyy-mm-dd hh24:mi') and
		       to_date(dat || ' ' || substr(afternoon, 0, 5),
		                 'yyyy-mm-dd hh24:mi') <=
		       to_date(to_char(sysdate, 'yyyy-mm-dd hh24:mi'), 'yyyy-mm-dd hh24:mi')))
		   and (usernum <> 0 or usernumaf <> 0)
		   and ((morning <> '-' and morning is not null) or
		       (afternoon <> '-' and afternoon is not null)) 
	) and c.isol='1' AND a.iskf<>'1'
	";

	ds=db.QuerySQL(sql);
	
	if(ds.getRowCount()>0){
		for(var i=0;i<ds.getRowCount();i++){
			html += "<a href=\"javascript:openWindow('L.sp?id=CHIS_ZX&ZXUSERID="+ds.getStringAt(i,"guid")+"&flg=zx&zxdoc=')\">";
			html += "<div style=\"margin-left:12px; margin-top:5px; width:100%\">";
			html += "<img src=\"EAFormBlob.sp?guid="+ds.getStringAt(i,"img")+"\"  style=\"border-radius:50%; float:left; height:90px; margin-right:20px;\">";
			html += "<div style=\"height:100px; text-align:left;\">
					<p style=\"padding:5px;margin:5px;\"><font  color=#3F3F3F>姓名：</font><font  color=#B2B2B2>"+ds.getStringAt(i,"name")+"</font></p>
					<p style=\"padding:5px;margin:5px;\"><font  color=\"#3F3F3F\">职称：</font><font  color=\"#B2B2B2\">"+ds.getStringAt(i,"job")+"</font></p>
					<p style=\"padding:5px;margin:5px;\"><font  color=\"#3F3F3F\">特长：</font><font  color=\"#B2B2B2\">"+ds.getStringAt(i,"VISCERA")+"</font></p>				
				</div>";
				html +="<hr/>";
			html += "</div></a>";
		}	
	}
	
} catch(e){}
if(db!=null){db.Close();}
	
return html;
}

//
// 
//
function getAllDoc()
{
	var sql="";
	var ds=null;
	var db=null;
	var html = "";
	db = new pubpack.EADatabase();
	
	sql="select rownum,a.id,a.name,b.name job,a.img,a.BEGOODATNAM,a.viscera,a.hospital from yx_doc a,yx_docjob b where a.jobtitle=b.id and a.org='CHIS' and iskf is null and rownum<=3";
	ds=db.QuerySQL(sql);
	
	if(ds.getRowCount()!=0){
		html += "<div style=\"float:left;\"></div><p style=\"float:right;\" onclick=\"javascript:openWindow('L.sp?id=SJNK')\">更多>></div>";
		for (var r = 0;r < ds.getRowCount(); r++) {
			html += "<div style=\"clear:both; bgcolor:#F8F8F8\">";
			html +="<a  onclick=\"javascript:window.open('L.sp?id=ABOUTDOC&uid="+ds.getStringAt(r,"id")+"')\">";
			html +="<table >";
			html +="<tr ><td rowspan=\"4\" ><img src=\"EAFormBlob.sp?guid="+ds.getStringAt(r,"img")+"\" style=\"margin:15px;border-radius:50%;width:60px;height:60px;\"></td><td align=\"left\"><font color=#3F3F3F>姓名：</font><font size=\"2\" color=#B2B2B2>"+ds.getStringAt(r,"name")+"</font></td></tr>";
			html +="<tr><td align=\"left\" > <font size=\"2\" color=\"#3F3F3F\">职称：</font><font  color=\"#B2B2B2\">"+ds.getStringAt(r,"job")+"</font></td></tr>";
			html +="<tr><td align=\"left\"> <font size=\"2\" color=\"#3F3F3F\">擅长领域：</font><font  color=\"#B2B2B2\">"+ds.getStringAt(r,"viscera")+"</font></td></tr>";
			html +="<tr><td align=\"left\"> <font size=\"2\" color=\"#3F3F3F\">擅长病种：</font><font  color=\"#B2B2B2\">"+ds.getStringAt(r,"BEGOODATNAM")+"</font></td></tr>";
			html +="</table>";
			html +="</a>";
			html += "</div><hr>";
		}
	}
	
	if(db!=null){db.Close();}
	
	return html;
}

}