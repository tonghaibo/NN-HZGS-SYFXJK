function x_showflg_pag(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var pub = new JavaPackage ( "com.xlsgrid.net.pub" );
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var EAScript= new JavaPackage ( "com.xlsgrid.net.pub.EAScript");

var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb");
var layoutpack = new JavaPackage ( "com.xlsgrid.net.layout");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd");	
var langpack = new JavaPackage ( "java.lang");


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
			sb.append(ee.toString());
			//throw new pubpack.EAException ( ee.toString() );
		}
		finally {
			if (db!=null) db.Close();
		}

	return sb.toString();
}

//静态html文本
function html(){
	return  db.getBlob2String("select bdata from formblob where guid='"+HTMLGUID+"' ","bdata");
	if(sc==""){
		return "";
	}
}

//信息发布正文
function tbody(){
	var layhdrguid = request.getParameter( "layhdrguid" );
	if (TITLESIZE == "") TITLESIZE = 4;
	
	var sql = "select a.* from LSYSURL a,formblob b,formblob img where a.icon=img.guid(+) and a.htmlguid=b.guid(+) and a.guid='"+layhdrguid+"'";
	var ds = db.QuerySQL(sql);
	var title = "";
	var pendat = "";
	var penusr = "";
	var image = "";
	if (ds.getRowCount() > 0) {
		title = ds.getStringAt(0,"NAME");
		pendat = ds.getStringAt(0,"PENDAT");
		penusr = ds.getStringAt(0,"PENUSR");
		image = ds.getStringAt(0,"ICON");
	}
	var context = db.getBlob2String("select b.bdata from LSYSURL a,formblob b where a.htmlguid=b.guid and a.guid='"+layhdrguid+"'","bdata");
	
	if (title == "") title = "无标题";
	if (context == "") context = "<b>无内容<b>";
	
	var html = " <table width=100%>";
	//验证是否显示标题
	if (TITLEFLG != 1) {
		var msg = "";
		var ids = db.QuerySQL("select nvl(b.name,a.penusr) nam,nvl(a.pendat,a.crtdat) dat from LSYSURL a,usr b where a.org=b.org(+) and a.penusr=b.id(+) and a.guid='"+layhdrguid+"'");
			
		if (ids.getRowCount() > 0) {
			msg = ids.getStringAt(0,"NAM");
			if (msg != "") msg += "&emsp;";
			msg += ids.getStringAt(0,"DAT");
		}
		html += "<tr><td align=\"center\" height=\"60px\"><font size="+TITLESIZE+"><b>"+ title +"</b></font></td></tr>";
		html += "<tr><td align=\"center\" style=\"color: #AFAFAF;\">"+ msg +"</td></tr>";
		html += "<tr><td align=\"center\" ><hr style=\"width: 92%; border: 1px solid #EFEFEF;\"></td></tr>";
	}
	if (image != "") {
		html+= "<tr><td align=\"center\" ><table width=92% style=\"text-align: left;\" ><tr><td><img src=\""+ image +"\" style=\"float:right;margin:10px;\">"+ context +"</td></tr></table></td></tr>";
	} else {
		html+= "<tr><td align=\"center\" ><table width=92% style=\"text-align: left;\" ><tr><td>"+ context +"</td></tr></table></td></tr>";
	}
	html += "</table>";
	
	return  html;
}

//登录窗口
function login(){
var fguid = db.GetSQL("select sys_guid() from dual " );
	return "<form id=\"f_login"+fguid +"\" action=\""+IFRAMEURL+"\" method=\"post\">
		<table border=\"0\" width=\"100%\"  cellspacing=\"0\" cellpadding=\"0\" bgcolor=\"#FFFFFF\">
		    <tr height=\"50\"> <td align=\"right\" width=\"20%\" ></td><td  >请输入用户名密码：</td> <td width=\"20%\" >　</td>   </tr>
		    <tr height=\"30\"> <td align=\"right\" width=\"20%\" >&nbsp;</td>
		        <td >
		        <table border=\"0\" width=\"100%\" height=100% cellspacing=\"0\" cellpadding=\"0\"  >
				<tr>
					<td width=30 height=30 bgcolor=#00A8EC style=\"border: 1px solid #CCCCCC; padding-left: 0px; padding-right: 0px; padding-top: 0px; padding-bottom: 0px\">
					<img src='xlsgrid/images/flash/icon/icon_151.png' width=35  height=35></td>
					<td style=\"border-right:1px solid #CCCCCC; border-top:1px solid #CCCCCC; border-bottom:1px solid #CCCCCC; padding:0px; \" valign=middle><input type=\"text\" name=\"usrid\"  style=\"width:98%;height:25px;border: 0px ;font-size: 12pt \"></td>
				</tr>
			</table>
		        </td> <td width=\"20%\">　</td>
		    </tr>
		    <tr height=\"20\"> <td colspan=\"3\" >&nbsp;</td></tr>
		    <tr height=\"30\"> <td align=\"right\" width=\"20%\" >&nbsp;</td>
		        <td ><table border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\"  >
				<tr>
					<td width=30 height=30 bgcolor=#FFC500 style=\"border: 1px solid #CCCCCC; padding-left: 0px; padding-right: 0px; padding-top: 0px; padding-bottom: 0px\">
					<img src='xlsgrid/images/flash/icon/icon_162.png' width=35 height=35></td>
					<td style=\"border-right:1px solid #CCCCCC; border-top:1px solid #CCCCCC; border-bottom:1px solid #CCCCCC; padding:0px; \" valign=middle><input type=\"password\" name=\"userpwd\"  style=\"width:98%;height:25px;border: 0px ;font-size: 12pt \"></td>
				</tr>
			</table></td><td width=\"20%\" >　</td></tr>
		    <tr height=40 > <td align=\"center\" colspan=\"3\" ><p align=\"center\"><img src=\"EAImgBlob.sp?guid=2DBC1121895D4FD48D9584E47E4D11C7\" border=0 onclick=\"javascript: f_login"+fguid +".submit();\" onmouseover=\"this.style.cursor='hand';\"> </td> </tr>
		</table></form>";
//var html=
//	"<form id=\"f_login\" action=\""+IFRAMEURL+"\" method=\"post\">"+
//	"<table  width=\"320\"  cellspacing=\"0\" cellpadding=\"0\" border=\"0\">"+
//		"<tr height=\"16\">"+
//	    "<td colspan=\"3\"  align=\"left\"><font color=#999999>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font> </td> </tr>"+
//	"<tr height=\"40\">"+
//	    "<td colspan=\"3\"  align=\"left\"><font color=#999999 size=\"4px\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;请输入用户名密码</font> </td> </tr>"+
//	"<tr height=\"40\">"+
//	    "<td align=\"right\" width=\"100\" valign=\"top\"><img src=EAFormBlob.sp?guid=69A085C9273641A39FD790D0D47D5468></td>"+
//	    "<td  align=\"left\" valign=\"top\">"+
//	        "<input type=\"text\" name=\"usrid\"  style=\"width:200px;height:25px;border: 1px solid #C0C0C0;font-size: 12pt\" > </td>"+
//	    "<td width=\"50\">　</td> </tr>"+
//	"<tr height=\"40\">"+
//	    "<td align=\"right\" width=\"100\" valign=\"top\"><img src=EAFormBlob.sp?guid=84D43F2B042F456A94A84013D6622D52></td>"+
//	   " <td  align=\"left\" valign=\"top\">"+
//	        "<input type=\"password\" name=\"userpwd\" style=\"width:200px;height:25px;border: 1px solid #C0C0C0;font-size: 12pt\"> </td>"+
//	    "<td width=\"50\" >　</td> </tr> <tr>"+
//	    "<td align=\"right\" colspan=\"3\" height=\"40\">"+
//	        "<p align=\"center\"><img src=EAFormBlob.sp?guid=44000855226C4576924B2C0A6BEE3A63 border=0 onclick=\"javascript: f_login.submit();\" onmouseover=\"this.style.cursor='hand';\">"+
//	         "</td> </tr></table></form>";
	return html;

}

//上下滚动图片
function sxscrollimg(){
var onload="<script type=\"text/javascript\">window.onload=function(){$(\".imageBox img\").width($(\".imageRotation\").width());$(\".imageBox img\").height($(\".imageRotation\").height());}</script>";
		

	var html="<div class=\"imageRotation\" id=\"imageRotation\">"+
		    "<div class=\"imageBox\">";
	html=ond+html;    
	var xml=db.QuerySQL("select icon,icon2,url from LSYSURL where REFID='"+DSMOD+"'");
	var spn="";
	for(var i=0;i<xml.getRowCount();i++){
		html+= "<img src="+xml.getStringAt(i,"icon")+">";
		if(i==0)
			spn+="<span class=\"active\" rel=\""+(i+1)+"\"><img src=\"http://dev.sss-shanghai.org/aca/ROOT_HIS/"+xml.getStringAt(i,"icon")+"\"/></span>";
		else
			spn+="<span  rel=\""+(i+1)+"\"><img src=\"http://dev.sss-shanghai.org/aca/ROOT_HIS/"+xml.getStringAt(i,"icon")+"\"/></span>";
	}
	html+="</div>"+ "<div class=\"icoBox\">"+spn+ "</div>"+"</div>";
	
	var jvaspt="<script type=\"text/javascript\">"+
			"    $(document).ready(function() {"+
			"       $(\".imageRotation\").each(function(){"+
			"           var imageRotation = this, "+
			"                    imageBox = $(imageRotation).children(\".imageBox\")[0],  "+
			"                   icoBox = $(imageRotation).children(\".icoBox\")[0],  "+
			"                    icoArr = $(icoBox).children(), "+
			"                    imageWidth = $(imageBox).width(),  "+
			"                    imageNum = $(imageBox).children().size(),  "+
			"                    imageReelWidth = imageWidth*imageNum,  "+
			"                    activeID = parseInt($($(icoBox).children(\".active\")[0]).attr(\"rel\")), "+
			"                    nextID = 0, "+
			"                    setIntervalID,  "+
			"                    intervalTime = 4000,  "+
			"                    speed =500;  "+
			

			"            $(imageBox).css({'width' : imageReelWidth + \"px\"});"+
			
	
			"            var rotate=function(clickID){"+
			"                if(clickID){ nextID = clickID; }"+
			"                else{ nextID=activeID<=3 ? activeID+1 : 1; }"+
			
			"                $(icoArr[activeID-1]).removeClass(\"active\");"+
			"                $(icoArr[nextID-1]).addClass(\"active\");"+
			"                $(imageBox).animate({left:\"-\"+(nextID-1)*imageWidth+\"px\"} , speed);"+
			"                $(icoArr[nextID-1]).addClass(\"active\").css({'border':'3px solid #eee'});"+
			"                $(icoArr[activeID-1]).addClass(\"active\").css({'border':'0px solid #eee'});"+
			"                activeID = nextID;"+
			"            };"+
			"            setIntervalID=setInterval(rotate,intervalTime);"+
			
			"            $(imageBox).hover("+
			"                    function(){ clearInterval(setIntervalID); },"+
			"                    function(){ setIntervalID=setInterval(rotate,intervalTime); }"+
			"            );"+
			
			"            $(icoArr).click(function(){"+
			"                clearInterval(setIntervalID);"+
			"                var clickID = parseInt($(this).attr(\"rel\"));"+
			"                rotate(clickID);"+
			"                setIntervalID=setInterval(rotate,intervalTime);"+
			"            });"+
			 "       });"+
			"    });"+
			"</script>";
   return html+jvaspt;
}

//左右滚动图片右边带小视图
function lscrollimg(){
var html ="<style type=\"text/css\">
		/* Reset style */
		* { margin:0; padding:0; word-break:break-all; }
		body { background:#FFF; color:#333; font:12px/1.6em Helvetica, Arial, sans-serif; }
		h1, h2, h3, h4, h5, h6 { font-size:1em; }
		a { color:#039; text-decoration:none; }
		 a:hover { text-decoration:underline; }
		ul, li { list-style:none; }
		fieldset, img { border:none; }
		em, strong, cite, th { font-style:normal; font-weight:normal; }
		/* Focus_change style */
		
		 #focus_change_list li { float:left; }
		
		 #focus_change_btn ul { padding-left:5px; }
		 #focus_change_btn li { display:inline; float:left; margin:0 15px; padding-top:12px; }
		 #focus_change_btn li img {border:2px solid #888;}
		
		 #focus_change_btn .current img { border-color:#EEE; }
		</style>";
		
	if(LAYCOL =="")LAYCOL ="1";
	var sql = "select * from ( select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' and icon is not null "  ;
	if(WHEREBY!="" ) sql+= " AND " +WHEREBY;
	if(SORTBY!="" ) sql+= " "+SORTBY;
	else sql+= " order by crtdat desc ";
	if(LAYCOL !=""&& LAYROW!="" ) sql+=") where  rownum<"+LAYCOL+"*"+LAYROW;
	
	  
	var xml=db.QuerySQL(sql);
	var spn="";
	var cnt=xml.getRowCount();
	if(cnt>5) cnt=5;
	
		
	
	html += "<script type=\"text/javascript\">

		function $a(id) { return document.getElementById(id); }
		function moveElement(elementID,final_x,final_y,interval) {
	
		 if (!document.getElementById) return false;
		 if (!document.getElementById(elementID)) return false;
		 var elem = document.getElementById(elementID);
		 if (elem.movement) {
		 clearTimeout(elem.movement);
		 }
		 if (!elem.style.left) {
		 elem.style.left = \"0px\";
		 }
		 if (!elem.style.top) {
		 elem.style.top = \"0px\";
		 }
		 var xpos = parseInt(elem.style.left);
		 var ypos = parseInt(elem.style.top);
		 if (xpos == final_x && ypos == final_y) {
		 return true;
		 }
		 if (xpos < final_x) {
		 var dist = Math.ceil((final_x - xpos)/10);
		 xpos = xpos + dist;
		 }
		 if (xpos > final_x) {
		 var dist = Math.ceil((xpos - final_x)/10);
		 xpos = xpos - dist;
		 }
		 if (ypos < final_y) {
		 var dist = Math.ceil((final_y - ypos)/10);
		 ypos = ypos + dist;
		 }
		 if (ypos > final_y) {
		 var dist = Math.ceil((ypos - final_y)/10);
		 ypos = ypos - dist;
		 }
		 elem.style.left = xpos + \"px\";
		 elem.style.top = ypos + \"px\";
		 var repeat = \"moveElement('\"+elementID+\"',\"+final_x+\",\"+final_y+\",\"+interval+\")\";
		 elem.movement = setTimeout(repeat,interval);
		}
		function classNormal(){
		
		 var focusBtnList = $a('focus_change_btn').getElementsByTagName('li');
		 for(var i=0; i<focusBtnList.length; i++) {
		 focusBtnList[i].className='';
		 }
		}
		function focusChange() {

			var focusBtnList = $a('focus_change_btn').getElementsByTagName('li');
			
			var widthImg = document.body.scrollWidth * 0.8 * 0.57;
			if(!document.body.scrollWidth >= 960){
				 widthImg = 960 * 0.8 * 0.57;
			}
		 	focusBtnList[0].onmouseover = function() {
			moveElement('focus_change_list',-widthImg * 0,0,5);
			classNormal()
			focusBtnList[0].className='current'
			 
			}			 
			 focusBtnList[1].onmouseover = function() {
			 moveElement('focus_change_list',-widthImg ,0,5);
			 classNormal()
			 focusBtnList[1].className='current'
			 }
			 focusBtnList[2].onmouseover = function() {
			 moveElement('focus_change_list',-widthImg *2,0,5);
			 classNormal()
			 focusBtnList[2].className='current'
			 }
			 focusBtnList[3].onmouseover = function() {
			 moveElement('focus_change_list',-widthImg *3,0,5);
			 classNormal()
			 focusBtnList[3].className='current'
			 }
			 focusBtnList[4].onmouseover = function() {
			 moveElement('focus_change_list',-widthImg *4,0,5);
			 classNormal()
			 focusBtnList[4].className='current'
			 }
			}
		setInterval('autoFocusChange()', 4000);
		function autoFocusChange() {
			
			 var focusBtnList = $a('focus_change_btn').getElementsByTagName('li');
			 for(var i=0; i<focusBtnList.length; i++) {
				 if (focusBtnList[i].className == 'current') {
				 var currentNum = i;
				 }
			 }
				 var widthImg = document.body.scrollWidth * 0.8 * 0.57;
				if(!document.body.scrollWidth >= 960){
					widthImg = 960 * 0.8 * 0.57;
				}
			 if (currentNum==0 ){
			 moveElement('focus_change_list',-widthImg ,0,5);
			 classNormal()
			 focusBtnList[1].className='current'
			 }
			 if (currentNum==1 ){
			 moveElement('focus_change_list',-widthImg *2,0,5);
			 classNormal()
			 focusBtnList[2].className='current'
			 }
			 if (currentNum==2 ){
			 moveElement('focus_change_list',-widthImg *3,0,5);
			 classNormal()
			 focusBtnList[3].className='current'
			 } 
			 if (currentNum==3 ){
			 moveElement('focus_change_list',-widthImg *4,0,5);
			 classNormal()
			 focusBtnList[4].className='current'
			 }
			if (currentNum==4 ){
			 moveElement('focus_change_list',0,0,5);
			 classNormal()
			 focusBtnList[0].className='current'
			 }
		}
		

		window.onload=function(){
		  focusChange();
		   eve();
		}
		</script>";

	html += "<div id=\"focus_change\" style=\" position:relative; height:350px;width:100%; overflow:hidden;\">
		 <div id=\"focus_change_list\" style=\"top:0; left:0; position:absolute; height:350px;\">
		 <ul>";
		for(var i=0;i<cnt;i++){
		if(i==0)
			html += "<li class=\"current\"><a href='"+xml.getStringAt(i,"url")+"&layhdrguid="+xml.getStringAt(i,"GUID")+"' ><img src="+xml.getStringAt(i,"icon")+" id='imgpx0' style=\"height:350px;\"  alt=\"\" ></a>";
		else
			html += "<li><a href=\"#\"><a href='"+xml.getStringAt(i,"url")+"&layhdrguid="+xml.getStringAt(i,"GUID")+"' ><img src="+xml.getStringAt(i,"icon")+" id='imgpx"+i+"'  style=\" height:350px;\"  alt=\"\" ></a>";
		}
	html +=	 "</ul>
		 </div>
		 <div  style=\"position:absolute; width:65px; height:100%; top:0; right:0; background:#000; filter:alpha(opacity=50); -moz-opacity:0.5; opacity: 0.5; \"></div>
		 <div id=\"focus_change_btn\" style=\"position:absolute; width:60px; height:100%;  bottom:0; right:20px;_right:-11px;\">
		 <ul>";
		 for(var i=0;i<cnt;i++){
		 if(i==0)
			html += "<li class=\"current\"><a href='"+xml.getStringAt(i,"url")+"&layhdrguid="+xml.getStringAt(i,"GUID")+"' ><img src="+xml.getStringAt(i,"icon2")+" style=\"width:50px; height:50px;\"   alt=\"\" ></a>";
		 else
			html += "<li><a href=\"#\"><a href='"+xml.getStringAt(i,"url")+"&layhdrguid="+xml.getStringAt(i,"GUID")+"' ><img src="+xml.getStringAt(i,"icon2")+" style=\"width:50px; height:50px;\"   alt=\"\" ></a>";
		 }
	html +=	"</ul>
		 </div>
		 </div>";
		
	html += "<script type=\"text/javascript\">


		
		//窗口宽度大小改变
		function eve() {
			var widthImg = document.body.scrollWidth * 0.8 * 0.57;
			if(document.body.scrollWidth >= 960){
				document.getElementById(\"focus_change\").style.width=widthImg +\"px\";		
				document.getElementById('imgpx0').style.width=widthImg +\"px\";			
				document.getElementById('imgpx1').style.width=widthImg +\"px\";
				document.getElementById('imgpx2').style.width=widthImg +\"px\";
				document.getElementById('imgpx3').style.width=widthImg +\"px\";
				document.getElementById('imgpx4').style.width=widthImg +\"px\";

				document.getElementById(\"focus_change_list\").style.width=4000+\"px\" ;
			}else{
				widthImg = 960 * 0.8 * 0.57;
				
				
				document.getElementById(\"focus_change\").style.width=widthImg +\"px\";
				document.getElementById('imgpx0').style.width=widthImg +\"px\";
				document.getElementById('imgpx1').style.width=widthImg +\"px\";
				document.getElementById('imgpx2').style.width=widthImg +\"px\";
				document.getElementById('imgpx3').style.width=widthImg +\"px\";
				document.getElementById('imgpx4').style.width=widthImg +\"px\";
				document.getElementById(\"focus_change_list\").style.width=4000+\"px\" ;
			}
		}
		

		fEventListen(window, 'resize',eve);
		function fEventListen(b,c,d,a){
		a=!!a;if(b.addEventListener)
		{b.addEventListener(c,d,a);}
		else{
			if(b.attachEvent)
			{b.attachEvent(\"on\"+c,d);}}
		}</script>";
	return html;

}

//从上往下滚动文字
function texscoll(){
var html = "";
	var sql = "select * from ( select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' order by  seqid)"  ;
	var ds=db.QuerySQL(sql);
	//html +="<div id=\"colee_bottom\" style=\"overflow:hidden;height:200px;width:400px;\">";

	html +="<div id=\"colee_bottom\" style=\"overflow:hidden;height:100%;width:100%;\">";
	html += "<div id=\"colee_bottom1\">";
	
	for (var r = 0; (r < ds.getRowCount()&&r<LAYROW)||(LAYROW==""&&r < ds.getRowCount()); r ++) {
		var icon = ds.getStringAt(r,"icon");
		var name = ds.getStringAt(r,"name");
		var url = ds.getStringAt(r,"url");
		if (OPENLAYID != "") {
			url = "L.sp?id="+OPENLAYID+"&layhdrguid="+ds.getStringAt(r,"GUID");
		}
		if (url != "") {
			html += "<a target=\""+ds.getStringAt(r,"target")+"\" href=\""+url+"\">"+name+"</a><BR/>";
		} else {
			html += name;
		}
	}
	html += " <div id=\"colee_bottom2\"></div> ";
	html += "</div>";
	html += "<script>marqueeStart(2, \"up\");</script>";
	
	html += "<script>
			var speed=30
			var colee_bottom2=document.getElementById(\"colee_bottom2\");
			var colee_bottom1=document.getElementById(\"colee_bottom1\");
			var colee_bottom=document.getElementById(\"colee_bottom\");
//			colee_bottom2.innerHTML=colee_bottom1.innerHTML
			colee_bottom.scrollTop=colee_bottom.scrollHeight
			function Marquee2(){
			if(colee_bottom1.offsetTop-colee_bottom.scrollTop>=0)
			colee_bottom.scrollTop+=colee_bottom2.offsetHeight
			else{
			colee_bottom.scrollTop--
			}
			}
			var MyMar2=setInterval(Marquee2,speed)
			colee_bottom.onmouseover=function() {clearInterval(MyMar2)}
			colee_bottom.onmouseout=function() {MyMar2=setInterval(Marquee2,speed)}
		</script>";
	return html;


}

//微信微博
function weixinbo(){
	return  db.getBlob2String("select bdata from formblob where guid='"+HTMLGUID+"' for update","bdata");
}

//视频演示
function flashdemo(){
	
}

//系统默认工具栏
function toolbar(){

}

//登录信息和搜索
function loginsearch(){
}

//OS脚本
function mwos(){
	var eas = new pub.EAScript(null);
	eas.DefineScopeVar("request", request);
	eas.DefineScopeVar("deforg", deforg);
	eas.DefineScopeVar("OSPARAM", OSPARAM);
	return eas .CallClassFunc(OSMWID,OSFUNC,null).castToString();
}

//内部FRAME
function framelayout(){

	if(IFRAMEURL!=""){
		IFRAMEURL=pub.EAFunc.Replace(IFRAMEURL,"#$amp;","&");
				
		try{	
			IFRAMEURL=web.EASession.GetSysValue(IFRAMEURL,request);//替换request 中[%id]
		}
		catch(e){
			
		}
		
		
		var usrinfo = web.EASession.GetUserinfo(request);
		if(usrinfo!=null)
			IFRAMEURL=web.EASession.GetSysValue(IFRAMEURL,usrinfo);
		var r=0;
		
//		while((IFRAMEURL.indexOf("[%")>-1&&r<1000)){
//				var idx1 = IFRAMEURL.indexOf("[");
//				
//				var idx2 = IFRAMEURL.indexOf("]")+1;
//				if(idx1>0&&idx2>0){
//					var val=IFRAMEURL.substring(idx1,idx2);
//					
//					IFRAMEURL=pub.EAFunc.Replace(IFRAMEURL,val,"");
//				}
//				r++;
//		}
	}
	var html="<iframe id=\""+id+"\" src='"+IFRAMEURL+"' scrolling='auto' frameBorder=0 border='0' width='100%' height='100%' ></iframe>";
	return html;
}

//药物信息
function retrieve(){
	var html = menu();
	html += loadBody();
	return html;
}

//药品说明书
function drugs(){
	var sb=new langpack.StringBuffer();
	sb.append("<script src=\"http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js\"></script>");
	var blo = loaddiv(id);
	return blo;
}

function GetBody(){
var doc_id = pubpack.EAFunc.NVL(request.getParameter("doc_id"),"");
	var sb=new langpack.StringBuffer();
	var db = "";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			//根节点-中药-西药1
		var sql = "select note from CDMS_DRUNOTE WHERE DOC_ID IN(select DOC_ID from CDMS_DRUNOTEREF WHERE DOc_id ='"+doc_id+"')   ORDER BY seqid";
		var ds=db.QuerySQL(sql);
		sb.append("<div style=\"width:80%;margin-left:10%;\">");
		for(var i =0;i<ds.getRowCount();i++){
			//药品介绍等信息
			var sql = "select title from cdms_drunote d where d.note = '"+ds.getValueAt(i,"note")+"'";
			var dsa=db.QuerySQL(sql);
			if(i != 0){
				sb.append("<span>【"+dsa.getValueAt(0,"title")+"】</span>");
				var hql = "select bdata from formblob  b where b.guid  = '"+ds.getValueAt(i,"note")+"'";
				var blo = db.getBlob2String(hql,"bdata");
				sb.append("<div><font color='#666666'>"+blo +"</font></div>");
				sb.append("<hr  style=\"width:1000px;margin-right:20%\">");
			}else{
				var hql = "select bdata from formblob  b where b.guid  = '"+ds.getValueAt(i,"note")+"'";
				var blo = db.getBlob2String(hql,"bdata");
				sb.append("<div style=\"margin-left:40%;\"><font color='#CCCCCC'>"+blo +"</font></div>");

			}
			
			
			
		}
		
		sb.append("</div>");
//		sb.append("<div style=\"width:84.9%;height:500px;float:left;\">");
//		for(var i =0;i<ds.getRowCount();i++){
//			var sql = "select title from formblob  b,cdms_drunote d where b.guid =d.note and b.guid  = '"+ds.getValueAt(i,"note")+"'";
//			var hql = "select bdata from formblob  b where b.guid  = '"+ds.getValueAt(i,"note")+"'";
//			var blo = db.getBlob2String(hql,"bdata");
//			var dsa=db.QuerySQL(sql);
			
					
//			sb.append("<p><a name=\"#"+i+"\">【"+dsa.getValueAt(0,"title")+"】</a></p>");
//			var bda="select bdata from formblob where guid in(select pic_jpg from cdms_notepic where doc_id in (select doc_id from formblob  b,cdms_drunote d where b.guid =d.note and b.guid ='"+ds.getValueAt(i,"note")+"'))";
		
//			var jpgname = "select name from cdms_notepic where doc_id in (select doc_id from formblob  b,cdms_drunote d where b.guid =d.note and b.guid =  '"+ds.getValueAt(i,"note")+"')";
//			var dsn=db.QuerySQL(jpgname);
//			var img = db.getBlob2String(bda,"bdata");
//			var blobimg = "";
//			
//			for(var k=0;k<dsn.getRowCount();k++){
//				//可能有多张照片
//				//将blob中图片替换掉blob中引用
//				
//				blobimg = pubpack.EAFunc.ReplaceNoCase(blo,"<img src=‘"+dsn.getValueAt(k,"name")+"‘></img>",img);
//				
//			}
//			sb.append("<div>"+blo +"</div>");
//		}
	}catch ( ee ) {
		db.Rollback();
		//sb.append(ee.toString());
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!="") db.Close();
	}

	return sb;


}

//药物专论
function drugMonograp(){
var sb=new langpack.StringBuffer();
	sb.append("<div id=\"hidde\" style=\"margin-left:10%;\"></div>");
	sb.append("<div id=\"frist\" onclick=\"tree(0)\" style=\"margin-left:10%;width:100px;height:20px;\" ><font color=\"#FFFFFF\">药理分类</font></div>");
	sb.append("<div id=\"tree\" style=\"margin-left:10%;margin-right:10%;float:left;width:1000px;\"></div>");//显示菜单
	sb.append("<div id=\"dru\" style=\"margin-left:10%;float:left;\"></div>");//
	sb.append("<input type=\"hidden\" id=\"inp\"");//用来得到菜单
	
	
	sb.append("<script src=\"http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js\"></script>");
	sb.append("<script type=\"text/javascript\">
	function manu(id){
		$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_TreeNode.manu.osp?id='+id,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		document.getElementById(\"dru\").innerHTML=result;
		

		}
		});
	
	}
	function dru(id,page){
		//隐藏上级菜单
		document.getElementById(\"tree\").style.display =\"none\";
		document.getElementById(\"dru\").style.display =\"\";
		$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_TreeNode.dru.osp?id='+id+'&page'+page,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		document.getElementById(\"dru\").innerHTML=result;
		

		}
		});
	}
	function tree(id){

	if(document.getElementById(\"dru\").innerHTML != \"\"){
		document.getElementById(\"dru\").style.display =\"none\";//隐藏
		document.getElementById(\"dru\").innerHTML =\"\";//清空
	}
	document.getElementById(\"tree\").style.display =\"\";
	document.getElementById(\"frist\").style.display =\"none\";
	$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_TreeNode.node.osp?id='+id,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		document.getElementById(\"inp\").value+=result +\"<font color='#FFFFFF'>></font>\";
		document.getElementById(\"hidde\").innerHTML = document.getElementById(\"inp\").value;
	
		var spl = document.getElementById(\"inp\").value.split(\"<input type='hidden' value=\"+id+\" />\");
		
		document.getElementById(\"hidde\").innerHTML = spl[0]+\"<input type='hidden' value=\"+id+\" />\";

		document.getElementById(\"inp\").value = spl[0]+\"<input type='hidden' value=\"+id+\" />\";
	}
	});
	
	$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_TreeNode.treenode.osp?id='+id,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		document.getElementById(\"tree\").innerHTML =result;
		
		
	}
	});
	
	
	}
	//分页
	function page(id,pagesize,count){
		
		$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_TreeNode.page.osp?id='+id+'&pagesize='+pagesize+'&count='+count,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		document.getElementById(\"dru\").innerHTML=result;
		

		}
		});
	}
	</script>");
//	var sb=new langpack.StringBuffer();
//	sb.append("<input type=\"hidden\" id=\"va\" value=\"frist\"/> ");
//	//sb.append("<input type=\"text\" id=\"sp\" value=\"\"/> ");
//	sb.append("<input type=\"hidden\" id=\"val\" value=\"\"/> ");
//	sb.append("<div  id=\"tex\"  style=\"width:25%;border:1px solid #CCCCCC;\"></div>");
//	sb.append("<div  id=\"right\"  style=\"width:74.9%;border:1px solid #CCCCCC;float:right;\"></div>");
//
//	//<a onclick=\"onclic(1,1,0,'西药')\">西药</a>
//	sb.append("<div id=\"frist\" style=\"width:300px;border:1px solid #CCCCCC;\"><a  onclick=\"onclic(0,0,0,'药理分类')\">药理分类</a> </div>");
//	pha(0,sb,0);
//	
//	
//	//sb.append("<script type=\"text/javascript\">function onclic(id,refid,isl,valu){alert(valu);if(isl == 0){document.getElementById(\"tex\").innerHTML +=\" >><a onclick='onclic(\"+id+\",\"+refid+\",\"+isl+\",\"+"'"+valu+"'"+"\")'> \"+valu+\"</a>\"; var tid = document.getElementById(\"va\").value;document.getElementById(tid).style.display =\"none\";document.getElementById(\"va\").value=id;document.getElementById(id).style.display =\"\";}else{alert(\"最低层\");}}</script>");
//	
//	
//	sb.append("<script type=\"text/javascript\">
//	function onclic(id,refid,isl,valu){
//	//document.getElementById(\"sp\").value=document.getElementById(\"tex\").innerHTML+\"a\"+id;
//	
//	if(isl == 0){
//		
//		var tid = document.getElementById(\"va\").value;
//		document.getElementById(tid).style.display =\"none\";
//		document.getElementById(\"va\").value=id;document.getElementById(id).style.display =\"\";
//	}else{
//	//var tex = document.getElementById(\"tex\").innerHTML;
//	//window.location.href=\"http://dev.sss-shanghai.org/aca/x.L_TreeNode.html.osp?id=\"+id+\"&tex\"+tex;
//	$.ajax({
//	url: 'http://dev.sss-shanghai.org/aca/x.L_TreeNode.html.osp?id='+id,type: 'POST',error: function(){alert('Error loading PHP document');},
//	
//	success: function(result){document.getElementById(\"right\").innerHTML =result;}
//	
//	});
//	return ; 
//	}
//	var spl =document.getElementById(\"val\").value.split(\"<input type='hidden'value=\"+id +\"/>\");
//	document.getElementById(\"tex\").innerHTML=spl[0]+\"<input type='hidden'value=\"+id +\"/>\";
//	if(valu==0){
//		document.getElementById(\"val\").value=spl[0]+\"<input type='hidden'value=\"+id +\"/>\";
//
//	}else{
//		document.getElementById(\"val\").value=spl[0];
//		document.getElementById(\"tex\").innerHTML +=\" >><a onclick='onclic(\"+id+\",\"+refid+\",\"+isl+\",0)'> \"+valu+\"</a>\"+\"<input type='hidden'value=\"+id +\"/>\";
//		document.getElementById(\"val\").value +=\" >><a onclick='onclic(\"+id+\",\"+refid+\",\"+isl+\",0)'> \"+valu+\"</a>\"+\"<input type='hidden'value=\"+id +\"/>\";
//	} 
//	//document.getElementById(\"val\").value=spl[0];
//	}
//	function dis(id){document.getElementById(\"+id+\").display =\"\";}</script>");
//
	return sb;


}



function node(){
	var html ="";
	var db = "";
	if(id==0){
	html ="<a onclick=\"tree("+id+")\"><font color=\"#FFFFFF\">药理分类></font>"+"</a><input type='hidden' value=0 />";
	return html;
	}
		try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			//根节点-中药-西药1
		var sql = "select * from CDMS_PHA where id='"+id+"' ";
		var ds=db.QuerySQL(sql);
		
		html = "<a  onclick=\"tree("+id+")\"><font color=\"#FFFFFF\">"+ds.getValueAt(0,1)+"</font></a><input type='hidden' value="+ds.getValueAt(0,0)+"/>";
		
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "出现错误";
		}
		finally {
		
			if (db!="") db.Close();
		}
	return html;

	
	}

function treenode(){
	var html ="";
	var db = "";
		try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			//根节点-中药-西药1
		var sql = "select * from CDMS_PHA where REFID='"+id+"' ";
		var ds=db.QuerySQL(sql);
		
		if(ds.getRowCount() == 0){
		
			var sql = "select * from CDMS_DRUNAM where id in(select DISTINCT A.catalog_id from cdms_phatyp A,CDMS_DRUTONOTE B where A.CATALOG_ID=B.CATALOG_ID AND  phacatalog_id='"+id+"' )";
			var ds=db.QuerySQL(sql);
			
			for(var i =0;i<ds.getRowCount();i++){
				html += "<table style=\"width:100px;height:100px; float:left;margin:5px;background-color:#3399FF;\">";
				html += "<tr><td onclick=\"dru("+ds.getValueAt(i,0)+",1)\"><font  size=\"3\" color=\"#FFFFFF\" style=\"margin-top:20px;\">"+ds.getValueAt(i,4)+"</font>";
				html += "<td></tr></table>";
			}
			
			
			
			return html;
		}
		
		for(var i =0;i<ds.getRowCount();i++){
			html += "<table style=\"width:100px;height:100px; float:left;margin:5px; background-color:#3399FF;\">";
			html += "<tr><td onclick=\"tree("+ds.getValueAt(i,0)+")\"><font  size=\"3\" color=\"#FFFFFF\" style=\"margin-top:20px;\">"+ds.getValueAt(i,1)+"</font>";
			html += "</td></tr></table>";
			
		}
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			//throw new pubpack.EAException ( ee.toString() );
			return "出现错误";
		}
		finally {
		
			if (db!="") db.Close();
		}
	return html;


}

function dru(){
		var html ="";
		var db = "";
		
		try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			//根节点-中药-西药1
		var sql = "select * from CDMS_DRUNOTEREF where DOC_ID in(select doc_id from CDMS_DRUTONOTE where CATALOG_ID = '"+id+"') ";
		var ds=db.QuerySQL(sql);
	
		//判断是否进行分页
			if(ds.getRowCount() >15){
				
				var pagesize = 0;
				
				//总页数
				var count = ds.getRowCount() % 15==0?ds.getRowCount() / 15:(ds.getRowCount() / 15)+1;
				
				//最小数
				var pagemin = pagesize * 15;
				//最大数
				var pagemax = (pagesize+1) * 15;
				var sql = "select * from (select rownum as r,CDMS_DRUNOTEREF.* from CDMS_DRUNOTEREF  where DOC_ID in(select doc_id from CDMS_DRUTONOTE where CATALOG_ID = '"+id+"')and rownum<="+pagemax +") where r> "+pagemin;	
			
				var ds=db.QuerySQL(sql);
					for(var i =0;i<ds.getRowCount();i++){
					var drug_name = ds.getValueAt(i,"drug_name");
					var manufacturer = ds.getValueAt(i,"manufacturer");
					var collectdate = ds.getValueAt(i,"collectdate");
					var doseform = ds.getValueAt(i,"doseform");
					var strength1 = ds.getValueAt(i,"strength1");
					if(doseform == ""||doseform ==null)doseform = "&nbsp;&nbsp;&nbsp;";
					if(collectdate == ""||collectdate ==null)collectdate = "&nbsp;&nbsp;&nbsp;";
					if(drug_name == ""||drug_name ==null)drug_name = "&nbsp;&nbsp;&nbsp;";
					if(manufacturer == ""||manufacturer ==null)manufacturer = "&nbsp;&nbsp;&nbsp;";
					if(strength1 == ""||strength1 ==null)strength1= "&nbsp;&nbsp;&nbsp;";
					html += "<p><a  href=\"http://cdms.xmidware.com/aca//ROOT_CDMS/L.sp?id=InstructionBook&doc_id="+ds.getValueAt(i,"DOC_ID")+"  \" target='_blank'  ><font color:#3366FF>"+drug_name+"</font></a></p>";
					html += "<p><font color='#333333'>商品名称:</font>"+drug_name+"</p>";
					html += "<p><font color='#333333'>生产厂家：</font>"+manufacturer+"<font color='#333333'>收集日期:</font>"+collectdate +"<font color='#333333'>剂型:</font>"+doseform +"<font color='#333333'>规格</font>:"+strength1+"</p>";
					html += "<hr  size=1 style=\"COLOR: #ffd306;border-style:outset;width:1000px;margin-right:20%\">";
					}
					html +="</div>";
					html +="<div><span>总页数"+count+"当前页"+pagesize +"</span>";
					html += "<span><select onchange=\"page("+id+",this.value-1,"+count+")\">";
					for(var k = 1;k<=count;k++){
						if(k == pagesize*1+1){
							html += "<option selected='selected'>";
							html += k;
							html += "</option>";
						}else{
							html += "<option>";
							html += k;
							html += "</option>";
						}
		
					}
					html += "</select></span>";
					html += "<span  onclick=\"page("+id+",0,"+count+")\">首页</span>";
					if(pagesize ==0){//没有上一页
					html +="<span><a>上一页</a></span>";
					}
					var bpage = pagesize * 1 +1;
					html += "<span ><a onclick=\"page("+id+","+bpage +","+count+")\">下一页</a></span >";
					html += "<span ><a onclick=\"page("+id+","+count+","+count+")\">尾页</a></span >";
					html +="</div>";
					return html;
			}
			html +="<div width=\"1000px\">";
			for(var i =0;i<ds.getRowCount();i++){
			var drug_name = ds.getValueAt(i,"drug_name");
			var manufacturer = ds.getValueAt(i,"manufacturer");
			var collectdate = ds.getValueAt(i,"collectdate");
			var doseform = ds.getValueAt(i,"doseform");
			var strength1 = ds.getValueAt(i,"strength1");
			if(doseform == ""||doseform ==null)doseform = "&nbsp;&nbsp;&nbsp;";
			if(collectdate == ""||collectdate ==null)collectdate = "&nbsp;&nbsp;&nbsp;";
			if(drug_name == ""||drug_name ==null)drug_name = "&nbsp;&nbsp;&nbsp;";
			if(manufacturer == ""||manufacturer ==null)manufacturer = "&nbsp;&nbsp;&nbsp;";
			if(strength1 == ""||strength1 ==null)strength1= "&nbsp;&nbsp;&nbsp;";
			html += "<p><a  href=\"http:cdms.xmidware.com/aca//ROOT_CDMS/L.sp?id=InstructionBook&doc_id="+ds.getValueAt(i,"DOC_ID")+"  \" target='_blank'  ><font color:#3366FF>"+drug_name+"</font></a></p>";
			html += "<p><font color='#333333'>商品名称:</font>"+drug_name+"</p>";
			html += "<p><font color='#333333'>生产厂家：</font>"+manufacturer+"<font color='#333333'>收集日期:</font>"+collectdate +"<font color='#333333'>剂型:</font>"+doseform +"<font color='#333333'>规格</font>:"+strength1+"</p>";
			html += "<hr  size=1 style=\"COLOR: #ffd306;border-style:outset;width:1000px;margin-right:20%\">";
			}
			html +="</div>";

		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "出现错误";
		}
		finally {
		
			if (db!="") db.Close();
		}
	return html;

}

function menu(){
	var html ="<style type=\"text/css\">
		.nav_a { 
		color: #333333;
		cursor: pointer;
		float: left;
		font-size: 14px;
		height: 40px;
		line-height: 40px;
		padding: 0px 15px;
		position: relative;
		}
		
		.nav { 
		height: 40px;
		
		}
		.nav .on { 
		background-color: #FFFFFF;
		color: #000000;
		
		}
		#dr div:hover{
		
			background:#666666;
		
		}

		
		</style>

		<div style=\"padding-left:10%;background-color: #999999;overflow:hidden;\">
		
	        <div class=\"nav\" id=\"dr\" style=\"float:left;\">
		    <div class=\"nav_a on\"  id=\"ck1\" onclick=\"clickon('ck1','药品说明书','cka')\">药品说明书</div>
		    <div  class=\"nav_a\" id=\"ck2\" onclick=\"clickon('ck2','药物专论','ckb')\">药物专论</div>
		    <div  class=\"nav_a\" id=\"ck3\" onclick=\"clickon('ck3','药物相互作用','ckc')\">药物相互作用</div>
		    <div class=\"nav_a\" id=\"ck4\" onclick=\"clickon('ck4','配伍禁忌','ckd')\">配伍禁忌</div>
		</div>
		
			
		</div>
		
		<div style=\"padding-left:10%;overflow:hidden;\">
			<img src=\"EAFormBlob.sp?guid=E19A65A832BA47C7911045ED3DD5BC1F\"/>
			
			
			<form id=\"form\" name=\"form\" method=\"post\" action=\"\">

			<div id=\"uboxstyle\">
			
				<select name=\"language\" id=\"language\">
					<option value=\"\"  selected=\"selected\">厂家</option>
					<option value=\"简体中文\" >简体中文</option>
					<option value=\"日本語\" >日本語</option>
				</select>
			</div>
			
			
			
			</form>
			
			
			
			
			<input type=\"hidden\" value=\"药品说明书\" id=\"his\" />
			<div style=\"float:right;\">
			<input type=\"text\" style=\"height:24px;\" name=\"wd\"  id=\"kw1\" size=\"40\"  autocomplete=\"off\"/>
			<input type=\"button\" style=\"background:none; border:0px;  color:#FFFFFF; height:30px;width:70px;\" onclick=\"likedru()\"  value=\"搜 索\">
			<input type=\"hidden\" id=\"rdrug\" value=\"\" />
			<input type=\"hidden\" id=\"rdrugid\" value=\"\" />
			</div>
		</div>
		</div>
		";
		html +="<script type=\"text/javascript\">
		//分析药物相互作用
		function fenxi(id,name){
			var drug = document.getElementById(\"rdrug\");
			var drugspl = drug.value.split(\"rdrug\");
			for(var i= 0;i< drugspl.length;i++){
				if(name ==drugspl[i]){
					alert(\"不能添加重复药品\");
					return ;
				}
			}
			document.getElementById(\"rdrugid\").value += id +\"rdrug\";
			document.getElementById(\"rdrug\").value += name +\"rdrug\";
			document.getElementById(\"bot\").style.display =\"\";
			document.getElementById(\"bot\").innerHTML += name;
		}
		//分析按钮进行药品分析
		function analyse(){
			var drug = document.getElementById(\"rdrugid\").value;
			
			$.ajax({
			url: 'http://cdms.xmidware.com/aca/x.L_retrieve.anal.osp?likename='+drug,
			type: 'POST',
			error: function(){alert('Error loading PHP document');},
			success: function(result){
			document.getElementById(\"dru\").style.display =\"\";
			document.getElementById(\"dru\").innerHTML=result;
			}
			});
			
		}
		
		//模糊搜索
		function likedru(){
			var va = document.getElementById(\"his\").value;
		
			var likename = document.getElementById(\"kw1\").value;
			if(likename.length < 2){
				alert(\"请输入两个以上字符(包含2个)\");
				return ;
			}
			if(va == \"药品说明书\"){
			}else if(va == \"药物专论\"){
			
			}else if(va == \"药物相互作用\"){
				$.ajax({
				url: 'http://cdms.xmidware.com/aca/x.L_retrieve.like.osp?likename='+likename+'&ty'+va,
				type: 'POST',
				error: function(){alert('Error loading PHP document');},
				success: function(result){
				document.getElementById(\"dru\").style.display =\"\";
				document.getElementById(\"dru\").innerHTML=result;
				}
				});

			}else{
			}

			
		}
		
		function clickon(id,va,cid){
		document.getElementById(\"rdrug\").value =\"\";	
		document.getElementById(\"bot\").style.display =\"none\";
		document.getElementById(\"inp\").value =\"\";
		document.getElementById(\"dru\").innerHTML =\"\";
		document.getElementById(\"tree\").innerHTML =\"\";
		document.getElementById(\"bot\").innerHTML=\"<div style='width:70px; height:100%; float:right'><div style='background-color:#FFFFFF; float:right; margin:10px;' onclick='analyse()'>分析</div><div  style='background-color:#FFFFFF;float:right; margin:10px;' onclick='clearhtml()'>清空</div></div>\";
		if(va == \"药品说明书\"){
		document.getElementById(\"hidde\").style.display =\"\";
		document.getElementById(\"frist\").innerHTML =\"<div onclick='tree(0,0)' style='width:100px;height:20px;'><font>药理分类</font></div>\";
		if(document.getElementById(\"hidde\").innerHTML !=\"\"){
			document.getElementById(\"hidde\").innerHTML ='<a onclick=\"tree(0,0)\"><font>药理分类></font></a><input value=\"0\" type=\"hidden\">';
		}

		}else if(va == \"药物专论\"){
		document.getElementById(\"hidde\").style.display =\"\";
		document.getElementById(\"frist\").innerHTML =\"<div onclick='tree(0,1)' style='width:100px;height:20px;'><font>药理分类</font></div>\";
		if(document.getElementById(\"hidde\").innerHTML !=\"\"){
			document.getElementById(\"hidde\").innerHTML ='<a onclick=\"tree(0,1)\"><font>药理分类></font></a><input value=\"0\" type=\"hidden\">';
		}
		}else if(va == \"药物相互作用\"){
		
		document.getElementById(\"frist\").innerHTML =\"\";
		document.getElementById(\"hidde\").style.display =\"none\";

		}else{
		document.getElementById(\"frist\").innerHTML =\"\";
		document.getElementById(\"hidde\").style.display =\"none\";
		}
		
		document.getElementById(\"his\").value =va;
		var b = document.getElementById('dr').getElementsByTagName('div');
		
		for(var i = 0;i<b.length;i++){
			
			b[i].className=\"nav_a\";
		}
	
		document.getElementById(id).className=\"nav_a on\";
		}
		</script>";


		return html;
	
}

function loadBody(){
	var sb=new langpack.StringBuffer();

	sb.append("<div id=\"hidde\" style=\"\"></div>");
	sb.append("<div id=\"frist\" style=\"width:100px;height:20px;\" ><div onclick='tree(0,0)' ><font>药理分类</font></div></div>");
	sb.append("<div id=\"tree\" style=\"float:left;\"></div>");//显示菜单
	sb.append("<div id=\"dru\" style=\"float:left;\"></div>");//
	sb.append("<div id=\"bot\" style=\"float:left;display:none;background-color:#CCC;position:fixed;bottom:0;height:70px;_position:absolute;_margin-top:expression(this.style.pixelHeight+document.documentElement.scrollTop);\"><div style=\"width:70px; height:100%; float:right\"><div style=\"background-color:#FFFFFF; float:right; margin:10px;\" onclick=''analyse()'>分析</div><div  style=\"background-color:#FFFFFF;float:right; margin:10px;\" onclick=\"clearhtml()\">清空</div></div></div>");
	sb.append("<input type=\"hidden\" id=\"inp\"");//用来得到菜单
	sb.append("<script src=\"http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js\"></script>");
	sb.append("<script type=\"text/javascript\">

	
	function manu(id){
	$.ajax({
	url: 'http://cdms.xmidware.com/aca/x.L_retrieve.manu.osp?id='+id,
	type: 'POST',
	error: function(){alert('Error loading PHP document');},
	success: function(result){
	document.getElementById(\"dru\").innerHTML=result;
	}
	});
	
	}
	//清空html
	function clearhtml(){
		document.getElementById(\"bot\").innerHTML=\"<div style='width:70px; height:100%; float:right'><div style='background-color:#FFFFFF; float:right; margin:10px;' onclick='analyse()'>分析</div><div  style='background-color:#FFFFFF;float:right; margin:10px;' onclick='clearhtml()'>清空</div></div>\";
		document.getElementById(\"rdrug\").value =\"\";
	}
	
	//取同类药品
	function dru(id,page){
		//隐藏上级菜单
		document.getElementById(\"tree\").style.display =\"none\";
		document.getElementById(\"dru\").style.display =\"\";
		$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_retrieve.dru.osp?id='+id+'&page'+page,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		document.getElementById(\"dru\").innerHTML=result;
		

		}
		});
	}
	//直接显示药品
	function drugShow(id){
		$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_retrieve.drugShow.osp?id='+id,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		//默认有<div style=\"width:1000px;\"></div>相当于判空
		if(result.length >36){
			document.getElementById(\"dru\").innerHTML=result;
		}else{
			document.getElementById(\"dru\").innerHTML=\"没有找到这个药品的信息\";
		}
		}
		});
		document.getElementById(\"dru\").style.display =\"\";//显示

	}
	
	
	function tree(id,ty){
	
	if(document.getElementById(\"dru\").innerHTML != \"\"){
		document.getElementById(\"dru\").style.display =\"none\";//隐藏
		document.getElementById(\"dru\").innerHTML =\"\";//清空
	}
	document.getElementById(\"tree\").style.display =\"\";
	document.getElementById(\"frist\").style.display =\"none\";
	$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_retrieve.node.osp?id='+id+'&ty='+ty,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		
		document.getElementById(\"inp\").value+=result +\"<font>></font>\";
		document.getElementById(\"hidde\").innerHTML = document.getElementById(\"inp\").value;
	
		var spl = document.getElementById(\"inp\").value.split(\"<input type='hidden' value=\"+id+\" />\");
		
		document.getElementById(\"hidde\").innerHTML = spl[0]+\"<input type='hidden' value=\"+id+\" />\";

		document.getElementById(\"inp\").value = spl[0]+\"<input type='hidden' value=\"+id+\" />\";
	}
	});
	
	$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_retrieve.treenode.osp?id='+id+'&ty='+ty,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		
		document.getElementById(\"tree\").innerHTML =result;
		
		
	}
	});
	
	}
	
	//查看说明书
	function instructionBook(id){
		$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_retrieve.instructionBook.osp?doc_id='+id,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		document.getElementById(\"tree\").innerHTML =result;
		document.getElementById(\"tree\").style.display = \"\";
		document.getElementById(\"dru\").style.display = \"none\";
		
	}
	});
	
	}
	
	//分页
	function page(id,pagesize,count){
		
		$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_retrieve.page.osp?id='+id+'&pagesize='+pagesize+'&count='+count,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		document.getElementById(\"dru\").innerHTML=result;
		

		}
		});
	}
	</script>");
	return sb;


}


//分类
function node(){

	var html ="";
	var db = "";
	if(id==0){
	html ="<a onclick=\"tree("+id+","+ty+")\"><font >药理分类></font>"+"</a><input type='hidden' value=0 />";
	return html;
	}
		try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			//根节点-中药-西药1
		var sql = "select * from CDMS_PHA where id='"+id+"' ";
		var ds=db.QuerySQL(sql);
		
		html = "<a  onclick=\"tree("+id+","+ty+")\"><font >"+ds.getValueAt(0,1)+"</font></a><input type='hidden' value="+ds.getValueAt(0,0)+"/>";
		
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "出现错误";
		}
		finally {
		
			if (db!="") db.Close();
		}
	return html;

	
	}

function treenode(){
	var html ="";
	var db = "";
	
		try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			//根节点-中药-西药1
		var sql = "select * from CDMS_PHA where REFID='"+id+"' ";
		var ds=db.QuerySQL(sql);
		
		if(ds.getRowCount() == 0){
			var ty= pubpack.EAFunc.NVL(request.getParameter("ty"),"");
			var sql = "select * from CDMS_DRUNAM where id in(select DISTINCT A.catalog_id from cdms_phatyp A,CDMS_DRUTONOTE B where A.CATALOG_ID=B.CATALOG_ID AND  phacatalog_id='"+id+"' )";
			var ds=db.QuerySQL(sql);
			if(ty == 0){//药品说明书
				for(var i =0;i<ds.getRowCount();i++){
					html += "<table style=\"width:100px;height:100px; float:left;margin:5px;background-color:#3399FF;\">";
					html += "<tr><td onclick=\"dru("+ds.getValueAt(i,0)+",1)\"><font  size=\"3\" color=\"#FFFFFF\" style=\"margin-top:20px;\">"+ds.getValueAt(i,4)+"</font>";
					html += "<td></tr></table>";
				}
			}else if(ty ==1){//药物专论
				for(var i =0;i<ds.getRowCount();i++){
					html += "<table style=\"width:100px;height:100px; float:left;margin:5px;background-color:#3399FF;\">";
					html += "<tr><td onclick=\"drugShow("+ds.getValueAt(i,0)+",1)\"><font  size=\"3\" color=\"#FFFFFF\" style=\"margin-top:20px;\">"+ds.getValueAt(i,4)+"</font>";
					html += "<td></tr></table>";
				}
			}
			
			
			
			return html;
		}
		
		for(var i =0;i<ds.getRowCount();i++){
			html += "<table style=\"width:100px;height:100px; float:left;margin:5px; background-color:#3399FF;\">";
			html += "<tr><td onclick=\"tree("+ds.getValueAt(i,0)+","+ty+")\"><font  size=\"3\" color=\"#FFFFFF\" style=\"margin-top:20px;\">"+ds.getValueAt(i,1)+"</font>";
			html += "</td></tr></table>";
			
		}
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "出现错误";
		}
		finally {
		
			if (db!="") db.Close();
		}
	return html;


}

function dru(){
		var html ="";
		var db = "";
		
		try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			//根节点-中药-西药1
		var sql = "select * from CDMS_DRUNOTEREF where DOC_ID in(select doc_id from CDMS_DRUTONOTE where CATALOG_ID = '"+id+"') ";
		var ds=db.QuerySQL(sql);
	
		//判断是否进行分页
			if(ds.getRowCount() >15){
				
				var pagesize = 0;
				
				//总页数
				var count = ds.getRowCount() % 15==0?ds.getRowCount() / 15:(ds.getRowCount() / 15)+1;
				
				//最小数
				var pagemin = pagesize * 15;
				//最大数
				var pagemax = (pagesize+1) * 15;
				var sql = "select * from (select rownum as r,CDMS_DRUNOTEREF.* from CDMS_DRUNOTEREF  where DOC_ID in(select doc_id from CDMS_DRUTONOTE where CATALOG_ID = '"+id+"')and rownum<="+pagemax +") where r> "+pagemin;	
			
				var ds=db.QuerySQL(sql);
					for(var i =0;i<ds.getRowCount();i++){
					var drug_name = ds.getValueAt(i,"drug_name");
					var manufacturer = ds.getValueAt(i,"manufacturer");
					var collectdate = ds.getValueAt(i,"collectdate");
					var doseform = ds.getValueAt(i,"doseform");
					var strength1 = ds.getValueAt(i,"strength1");
					if(doseform == ""||doseform ==null)doseform = "&nbsp;&nbsp;&nbsp;";
					if(collectdate == ""||collectdate ==null)collectdate = "&nbsp;&nbsp;&nbsp;";
					if(drug_name == ""||drug_name ==null)drug_name = "&nbsp;&nbsp;&nbsp;";
					if(manufacturer == ""||manufacturer ==null)manufacturer = "&nbsp;&nbsp;&nbsp;";
					if(strength1 == ""||strength1 ==null)strength1= "&nbsp;&nbsp;&nbsp;";
					html += "<p><a  onclick=\"instructionBook("+ds.getValueAt(i,"DOC_ID")+")\" ><font color:#3366FF>"+drug_name+"</font></a></p>";
					html += "<p><font color='#333333'>商品名称:</font>"+drug_name+"</p>";
					html += "<p><font color='#333333'>生产厂家：</font>"+manufacturer+"<font color='#333333'>收集日期:</font>"+collectdate +"<font color='#333333'>剂型:</font>"+doseform +"<font color='#333333'>规格</font>:"+strength1+"</p>";
					html += "<hr  size=1 style=\"COLOR: #ffd306;border-style:outset;width:1000px;margin-right:20%\">";
					}
					html +="</div>";
					html +="<div><span>总页数"+count+"当前页"+pagesize +"</span>";
					html += "<span><select onchange=\"page("+id+",this.value-1,"+count+")\">";
					for(var k = 1;k<=count;k++){
						if(k == pagesize*1+1){
							html += "<option selected='selected'>";
							html += k;
							html += "</option>";
						}else{
							html += "<option>";
							html += k;
							html += "</option>";
						}
		
					}
					html += "</select></span>";
					html += "<span  onclick=\"page("+id+",0,"+count+")\">首页</span>";
					if(pagesize ==0){//没有上一页
					html +="<span><a>上一页</a></span>";
					}
					var bpage = pagesize * 1 +1;
					html += "<span ><a onclick=\"page("+id+","+bpage +","+count+")\">下一页</a></span >";
					html += "<span ><a onclick=\"page("+id+","+count+","+count+")\">尾页</a></span >";
					html +="</div>";
					return html;
			}
			html +="<div width=\"1000px\">";
			for(var i =0;i<ds.getRowCount();i++){
			var drug_name = ds.getValueAt(i,"drug_name");
			var manufacturer = ds.getValueAt(i,"manufacturer");
			var collectdate = ds.getValueAt(i,"collectdate");
			var doseform = ds.getValueAt(i,"doseform");
			var strength1 = ds.getValueAt(i,"strength1");
			if(doseform == ""||doseform ==null)doseform = "&nbsp;&nbsp;&nbsp;";
			if(collectdate == ""||collectdate ==null)collectdate = "&nbsp;&nbsp;&nbsp;";
			if(drug_name == ""||drug_name ==null)drug_name = "&nbsp;&nbsp;&nbsp;";
			if(manufacturer == ""||manufacturer ==null)manufacturer = "&nbsp;&nbsp;&nbsp;";
			if(strength1 == ""||strength1 ==null)strength1= "&nbsp;&nbsp;&nbsp;";
			html += "<p><a onclick=\"instructionBook("+ds.getValueAt(i,"DOC_ID")+")\"  ><font color:#3366FF>"+drug_name+"</font></a></p>";
			html += "<p><font color='#333333'>商品名称:</font>"+drug_name+"</p>";
			html += "<p><font color='#333333'>生产厂家：</font>"+manufacturer+"<font color='#333333'>收集日期:</font>"+collectdate +"<font color='#333333'>剂型:</font>"+doseform +"<font color='#333333'>规格</font>:"+strength1+"</p>";
			html += "<hr  size=1 style=\"COLOR: #ffd306;border-style:outset;width:1000px;margin-right:20%\">";
			}
			html +="</div>";

		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "出现错误";
		}
		finally {
		
			if (db!="") db.Close();
		}
	return html;

}

function page(){

		var db="";
		
		try{
		//总页数
		db = new pubpack.EADatabase();
		var pag = pagesize*1 +1;
		//最小数
		var pagemin = pagesize * 15;
		//最大数
		var pagemax = pag* 15;
		var sql = "select * from (select rownum as r,CDMS_DRUNOTEREF.* from CDMS_DRUNOTEREF  where DOC_ID in(select doc_id from CDMS_DRUTONOTE where CATALOG_ID = '"+id+"')and rownum<="+pagemax +") where r> "+pagemin;	
		var ds=db.QuerySQL(sql);
		html ="";
	


		for(var i =0;i<ds.getRowCount();i++){
			var drug_name = ds.getValueAt(i,"drug_name");
			var manufacturer = ds.getValueAt(i,"manufacturer");
			var collectdate = ds.getValueAt(i,"collectdate");
			var doseform = ds.getValueAt(i,"doseform");
			var strength1 = ds.getValueAt(i,"strength1");
			if(doseform == ""||doseform ==null)doseform = "&nbsp;&nbsp;&nbsp;";
			if(collectdate == ""||collectdate ==null)collectdate = "&nbsp;&nbsp;&nbsp;";
			if(drug_name == ""||drug_name ==null)drug_name = "&nbsp;&nbsp;&nbsp;";
			if(manufacturer == ""||manufacturer ==null)manufacturer = "&nbsp;&nbsp;&nbsp;";
			if(strength1 == ""||strength1 ==null)strength1= "&nbsp;&nbsp;&nbsp;";
			html += "<p><a  href=\"http://cdms.xmidware.com/aca//ROOT_CDMS/L.sp?id=InstructionBook&doc_id="+ds.getValueAt(i,"DOC_ID")+"  \" target='_blank'  ><font color:#3366FF>"+drug_name+"</font></a></p>";
			html += "<p><font color='#333333'>商品名称:</font>"+drug_name+"</p>";
			html += "<p><font color='#333333'>生产厂家：</font>"+manufacturer+"<font color='#333333'>收集日期:</font>"+collectdate +"<font color='#333333'>剂型:</font>"+doseform +"<font color='#333333'>规格</font>:"+strength1+"</p>";
			html += "<hr  size=1 style=\"COLOR: #ffd306;border-style:outset;width:1000px;margin-right:20%\">";
			}
			html +="</div>";
			html +="<div><span>总页数"+count+"当前页"+pagesize +"</span>";
			html += "<span><select onchange=\"page("+id+",this.value-1,"+count+")\">";
			for(var k = 1;k<=count;k++){
				if(k == pagesize*1+1){
					html += "<option selected='selected'>";
					html += k;
					html += "</option>";
				}else{
					html += "<option>";
					html += k;
					html += "</option>";
				}
	
			}
			html += "</select></span>";
			html += "<span  onclick=\"page("+id+",0,"+count+")\">首页</span>";
			var bpage = pagesize *1 +1;
			var tpage = pagesize *1 -1;
	
			if(pagesize ==0){
				html += "<span><a>上一页</a></span>";
			}else{
				html += "<span><a onclick=\"page("+id+","+tpage+","+count+")\">上一页</a></span>";
			}
			var coun = count * 1 -1;
			if(pagesize == coun){
				html += "<span><a>下一页</a></span>";
			}else{
				html += "<span><a onclick=\"page("+id+","+bpage+","+count+")\">下一页</a></span>";
			}
			
			html += "<span><a onclick=\"page("+id+","+coun+","+count+")\">尾页</a></span>";
			html +="</div>";
		
		
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "出现错误";
		}
		finally {
		
			if (db!="") db.Close();
		}
		return html;	

}

//药物专论显示
function drugShow(){
	var html ="";
	var db="";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
	
		var sql = "select * from CDMS_DRCONTENT  where CATALOG_ID ='"+id+"' ";
		var ds=db.QuerySQL(sql);
		html += "<div style=\"width:1000px;\">";
		for(var i=0;i<ds.getRowCount();i++){
			html += "<div>"+ds.getValueAt(i,"dr_title")+"</div>";
			var hql = "select bdata from formblob where guid ='"+ds.getValueAt(i,"dr_content")+"'";
			var blo = db.getBlob2String(hql,"bdata");
			html += "<div>"+blo+"</div>";
			html += "<hr  style=\"width:1000px;margin-right:20%\">";
			
		}
		html +="<div>";
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "出现错误";
		}
		finally {
		
			if (db!="") db.Close();
		}
	return html;


}

function htmls(){

	var html ="";
	var db = "";
		try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			//根节点-中药-西药1
		var sql = "select DISTINCT A.* from cdms_phatyp A,CDMS_DRUTONOTE B where A.CATALOG_ID=B.CATALOG_ID AND  phacatalog_id='"+id+"' ";
		var ds=db.QuerySQL(sql);
		for(var i =0;i<ds.getRowCount();i++){
			var hql = "select * from cdms_drunam where id ="+ds.getValueAt(i,1);
			var dsa =db.QuerySQL(hql);
			html += "<div>"+dsa.getValueAt(0,0)+""+dsa.getValueAt(0,4)+"</div>";
		}
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
		}
		finally {
			if (db!="") db.Close();
		}
	return html;
	
}

//模糊查询
function like(){
 	var html ="";
	var db="";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sp = likename.split(" ");
		var sql = "select * from CDMS_DRUNAM where 1=1 and name like ";
		var spli = "";
		for(var i =0;i<sp.length();i++){
			if(sp[i] != ""){
			sql += "'%"+sp[i]+"%' and name like";
			}
		}
		sql += " '%%'";
		var ds=db.QuerySQL(sql);
	
		html += "<div style=\"width:1000px;\">";
		if(ds.getRowCount() == 0){
			html += "<p>未检索到与 "+likename+" 相关的信息。</p><p>建议您：</p><p>1. 检查您输入的关键词有无错误；</p><p>2. 更换检索词后重新进行检索。</p> ";
		}
		for(var i=0;i<ds.getRowCount();i++){
			html += "<div style=\"width:200px;height:50px;float:left;\" onclick=\"fenxi("+ds.getValueAt(i,"id")+",'"+ds.getValueAt(i,"name")+"')\">"+ds.getValueAt(i,"name")+"</div>";	
		}
		html +="<div>";
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "出现错误";
		}
		finally {
		
			if (db!="") db.Close();
		}
	return html;

}

function instructionBook(){
	var doc_id = pubpack.EAFunc.NVL(request.getParameter("doc_id"),"");
	var sb=new langpack.StringBuffer();
	var db = "";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			//根节点-中药-西药1
		var sql = "select note from CDMS_DRUNOTE WHERE DOC_ID IN(select DOC_ID from CDMS_DRUNOTEREF WHERE DOc_id ='"+doc_id+"')   ORDER BY seqid";
		var ds=db.QuerySQL(sql);
		sb.append("<div >");
		for(var i =0;i<ds.getRowCount();i++){
			//药品介绍等信息
			var sql = "select title from cdms_drunote d where d.note = '"+ds.getValueAt(i,"note")+"'";
			var dsa=db.QuerySQL(sql);
			if(i != 0){
				sb.append("<span>【"+dsa.getValueAt(0,"title")+"】</span>");
				var hql = "select bdata from formblob  b where b.guid  = '"+ds.getValueAt(i,"note")+"'";
				var blo = db.getBlob2String(hql,"bdata");
				sb.append("<div><font color='#666666'>"+blo +"</font></div>");
				sb.append("<hr  style=\"width:1000px;margin-right:20%\">");
			}else{
				var hql = "select bdata from formblob  b where b.guid  = '"+ds.getValueAt(i,"note")+"'";
				var blo = db.getBlob2String(hql,"bdata");
				sb.append("<div style=\"margin-left:40%;\"><font color='#CCCCCC'>"+blo +"</font></div>");

			}

		}
		
		sb.append("</div>");
		
		}catch ( ee ) {
		db.Rollback();
		//sb.append(ee.toString());
		throw new pubpack.EAException ( ee.toString() );
		}
		finally {
			if (db!="") db.Close();
		}
	
		return sb;


}


function anal(){
	var drug = pubpack.EAFunc.NVL(request.getParameter("likename"),"");
	var sb=new langpack.StringBuffer();
	var db = "";
	try {
		db = new pubpack.EADatabase();
		var likename ="";
		var drugspl =drug.split("rdrug");
	
		for(var i=0;i<drugspl.length();i++){
			if(drugspl.length()-1 ==i){
				likename += "refids like '%"+drugspl[i]+"%'";
			}else{
				likename += "refids like '%"+drugspl[i]+"%' and ";
			}
		}
		db = new pubpack.EADatabase();
		var sql = "select content1 from CDMS_ERRORMSG WHERE 1=1 and ";
		sql += likename ;

		var ds = db.QuerySQL(sql);
		if(ds.getRowCount() > 0){
			sb.append(ds.getValueAt(0,"content1"));
		}else{
			sb.append("没有找到相关信息");
		}
		}catch ( ee ) {
		db.Rollback();
		//sb.append(ee.toString());
		throw new pubpack.EAException ( ee.toString() );
		}
		finally {
			if (db!="") db.Close();
		}
	
	return sb;
}

//
// 
//
function getlinkage(){

	var sql="";
	var html="";
	var divli="<div style=\"border:1px solid #CCCCCC;width:100%; height:100%;\"><ul  id=\"leftmenu0\">";
	var script="";
	try{
		var cdcnt = db.GetSQL("select CDMSSMCNT.Nextval CNT from dual");
		sql="select * from LSYSURL where REFID='"+DSMOD+"'";
		var ds=db.QuerySQL(sql);
		var onurl="";
		var onguid="";
		for(var i=0;i<ds.getRowCount();i++){
			
			var url=ds.getStringAt(i,"url")+"&layhdrguid="+ds.getStringAt(i,"guid");
			if(onurl=="") {onurl=url; onguid=ds.getStringAt(i,"guid");}
			divli+="<li style=\"cursor:pointer\"><a onclick=\"setTab"+cdcnt +"('"+url+"')\">"+ds.getStringAt(i,"name")+"</a></li><br />";
		}
		divli+="</ul></div>";
		script="<script>
				function setTab"+cdcnt+"(url)
				{ 
					var ul=url+\"&hashead=n\";
					$.ajax({
					url: ul,
					type: 'POST',
//					error: function(){alert('您的网速有问题,如若网络正常。请联系管理员!');},
					success: function(result){
						
						document.getElementById(\"contentinfo"+cdcnt +"\").innerHTML=result;
					}
					});
				}
				 window.onload=setTab"+cdcnt+"('"+onurl+"');
			</script>";
		var loyhtml="";
//		if(onurl!=""){
//			
//			var parent = new x_showflg_title();
//			var layoutid=onurl.split("&")[0].split("=")[1];
//			request.getSession().setAttribute("layhdrguid",onguid);
//			loyhtml=parent.getlayout(request,layoutid);
//		}
		html+="<div><table width=\"100%\" height=\"100%\">
				 	<tr valign=\"top\">
						<td width=\"25%\">"+divli+"</td>
						<td  width=\"70%\"><div style=\"border:1px solid #CCCCCC; width:100%; height:100%;\"><div style=\"width:100%; height:100%;\" id=\"contentinfo"+cdcnt +"\">"+loyhtml+"</div></div></td>
					<tr>
				 </table>
			 </div>";
	}catch ( ee ) {
	db.Rollback();
	//sb.append(ee.toString());
	throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!="") db.Close();
	}
	return html+script;

}


//
//
function btcontent()
{
	var db = null;
	var ds = null;
	var sql = "";
	var ret = "";
	var tablehtml = "";
	var toolhtml = 0;
	
	//取request教师编号
	var usrid = request.getParameter("IDS");

	///取session登录教师编号
	if (usrid == null || usrid == "") {
		var usrinfo = web.EASession.GetLoginInfo(request);
		usrid = usrinfo.getUsrid();
		
		if (usrid == "xlsgrid") {
			usrid = "040470";
		}
	}
   
	try{
		db = new pubpack.EADatabase();
		
		sql="select guid,url,icon2,decode(LEVEL,1,name,2,'　'||name,name) name,seqid,CONTEXTES,LEVEL from LSYSURL a where REFID='"+DSMOD+"' start with CONTEXTES is null connect by prior id=CONTEXTES order by id";
		var ds = db.QuerySQL(sql);

		var onurl = "";
		var onguid = "";
	
		for(var i = 0;i< ds.getRowCount();i++){
			var url = ds.getStringAt(i,"url")+"&layhdrguid="+ds.getStringAt(i,"guid");
			if(onurl == "") {
				onurl = url; 
				onguid = ds.getStringAt(i,"guid");
			}
			var lev= ds.getStringAt(i,"LEVEL");
			if (lev == 1) {
				tablehtml+="<p  style='color:#c0c0c0'><img src=\""+ds.getStringAt(i,"icon2")+"\" width=16 height=16/> &nbsp;"+ds.getStringAt(i,"name")+"</p>";
			}else {
				tablehtml+="<button class='button white' onclick='javascript:show_right("+i+");'>"+ds.getStringAt(i,"name")+"</button>";
			}
			toolhtml ++;
		}
	}catch(e) {
		db.Rollback();
		throw new pubpack.EAException ( e.toString() );
		
	}finally {
		if (db != "") db.Close();
	}

	ret = "<html>
		 <head>
			<meta http-equiv='Content-Type' content='text/html;charset=gb2312'>
			
			<script>
			onload = function() {
				show_right(3);
			}
			onresize = function() {
				iframeResize(this); 
			}
				// 切换页面的触发事件
				function show_right(num){
					if (num == 1) { //编辑
						var a = 'show.sp?grdid=APO_TEA_Edit';
						a += '&ID="+usrid+"';
						document.getElementById(\"_main\").src = a;
					}if (num == 3) { //工作量
						var a = 'show.sp?grdid=APO_TEA_Dou';						
						a += '&ID="+usrid +"';
						document.getElementById(\"_main\").src = a;
						
					}if (num == 4) {//教学工作
						var a = 'show.sp?grdid=APO_TEA_Dou2';						
						a += '&ID="+usrid +"';
						document.getElementById(\"_main\").src = a;
					}if (num == 5) {//学习经历
						var a = 'show.sp?grdid=APO_TEA_Dou1';					
						a += '&ID="+usrid +"';
						document.getElementById(\"_main\").src = a;
					}if (num == 6) {//工作经历
						var a = 'show.sp?grdid=APO_TEA_Dou5';		
						a += '&ID="+usrid +"';
						document.getElementById(\"_main\").src = a;
					}if (num == 7) {//发表论文
						var a = 'show.sp?grdid=APO_TEA_Dou3';						
						a += '&ID="+usrid +"';
						document.getElementById(\"_main\").src = a;
					}if (num == 8) {//教师获奖情况
						var a = 'show.sp?grdid=APO_TEA_Dou4';						
						a += '&ID="+usrid +"';
						document.getElementById(\"_main\").src = a;
					}if (num == 10) {//教师获奖信息上报
						var a = 'show.sp?grdid=APO_AwaRep';
						document.getElementById(\"_main\").src = a;
					}if (num == 11) {//教师教研项目上报
						var a = 'show.sp?grdid=APO_ResRep';
						document.getElementById(\"_main\").src = a;
					}if (num == 12) {//教师发表论文上报
						var a = 'show.sp?grdid=APO_TheRep';
						document.getElementById(\"_main\").src = a;
					}
				}

			    function iframeResize(iframe){
 					 try {
 					 
 					 
// 					alert(document.body.clientHeight+'~'+document.body.offsetHeight+'@'+document.body.scrollHeight+'#'+document.documentElement.clientHeight);
					 iframe.height = document.documentElement.clientHeight-75-(2*10);
					 alert(iframe.height);
 					 
//				             var idocumentElement = iframe.contentWindow.document.documentElement;
//				             //取得body的页面内容：alert(iframe.contentWindow.document.body.innerHTML);
//				             if (idocumentElement.scrollHeight > 560) {
//				                 iframe.height -= 5;
//				                 iframe.height = idocumentElement.scrollHeight;
//				             } else {
//				                 var topHeight=4+43+12; //标题栏高度+控制栏高度
//						 var winHeight= window.screenTop;    //55
//						 var avaHeight= document.body.offsetHeight;//window.screen.availHeight; // 浏览器总高度
//						  
//				                 iframe.height = avaHeight-(topHeight+winHeight);
//				                 alert(avaHeight);
//				             }
				         }
				         catch (e) {
				             window.status = 'Error: ' + e.number + '; ' + e.description;
				         }
				}

			</script>
			<style type='text/css'>
				 .button {
			    		margin: 0 2px;  
			   		cursor: pointer;  
			    		text-align: left;  
			    		text-decoration: none;
			    		padding: .10em 2em .50em; 
			    		width:140px;
			    		height:30px;
					background:url(EAFormBlob.sp?guid=68440FEC95C0400D93C0A07950791CAA);
					border:0px;
					font:'a7a7a7';
					font-size:13px;
				}
				.button:hover {
					background:url(EAFormBlob.sp?guid=B14A7629BD874B27AEFFE6B3E50923AC);
				}
//				body { 
//					overflow-y : auto; 
//				} 
			</style>
		 </head>
		
		<body bgcolor='#c0c0c0' height='100%' scrolling='auto'>
			<table width='100%' height='100%' style='background-color:#ffffff'>
			   <tr width='100%' height='100%'>
		              <td width='100' height='100%' align='center' valign='top' style='text-decoration:none;'>
			       "+tablehtml+"
		             </td>
			    <td style='border-left:1px solid #c0c0c0'>&nbsp;</td>
			    <td width='100%' height='100%'><iframe id='_main' onresize='javascript:iframeResize(this);' scrolling='auto' frameBorder=0 border='0' width='100%' height='100%' ></iframe></td>
		        </tr>
		    </table>
	       </body>
	</html>";
	
	return ret;
}
//
function cjmuen(){
	var sql="";
	var html="";
	if(onmouseovercolor==null)  onmouseovercolor="";
	if(onmouseoverground==null) onmouseoverground="";
	if(clickbackground==null) clickbackground="";
	if(clickcolor==null) clickcolor="";
//	var divli="<div style=\"border:0px solid #CCCCCC;width:100%; height:100%;background-color:#ffffff;\"><ul  id=\"leftmenu0\">";
	var script="";
	var cdcnt = db.GetSQL("select CDMSSMCNT.Nextval CNT from dual");
	if(SQLTXT=="")
//		sql="select guid,url,icon2,decode(LEVEL,1,name,2,'　'||name,name) name,seqid,CONTEXTES,target,id,LEVEL from LSYSURL a where REFID='"+DSMOD+"' start with CONTEXTES is null connect by prior id=CONTEXTES order by id";
		sql="select guid,url,icon2,decode(CONTEXTES,'',name,'　'||name) name,seqid,CONTEXTES,target,id from LSYSURL a where REFID='"+DSMOD+"'  order by id";
	else
		sql=SQLTXT;
	var ds=db.QuerySQL(sql);
	var onurl="";
	var onguid="";
	var st = new Array(); 
	var divli="<table width=100% style=\"\">";
	for(var i=0;i<ds.getRowCount();i++){
		var id=ds.getStringAt(i,"id");
		var url=ds.getStringAt(i,"url");
		url=pub.EAFunc.Replace(url,"#$amp;","&");
		var gusrinfo=web.EASession.GetUserinfo(request);
		if(gusrinfo!=null){
			url=web.EASession.GetSysValue(url,request);//替换request 中[%id]
			url=web.EASession.GetSysValue(url,web.EASession.GetUserinfo(request));
		}
		
		while((url.indexOf("[%")>-1&&i<1000)){
			var idx1 = url.indexOf("[");
			
			var idx2 = url.indexOf("]")+1;
			
			var val=url.substring(idx1,idx2);
			url=pub.EAFunc.Replace(url,val,"");
		}

	
		var target=ds.getStringAt(i,"target");
		if(onurl==""&&ds.getStringAt(i,"url")!="") {onurl=url; onguid=ds.getStringAt(i,"guid");}
		var lev= ds.getStringAt(i,"CONTEXTES");
		if (lev == 1) {
			divli+="<tr><td align='right' width=15% height=\"35px\"><img src=\""+ds.getStringAt(i,"icon2")+"\" ></td><td id=\"td"+id+"\" style=\"color:#999999;font-size:13px;\" align='left' width=75% > "+ds.getStringAt(i,"name")+"</td></tr>";
		}
		else {
			st.push(id);
			if(i==1){
				divli+="<tr><td align='right' width=15% height=\"30px\"></td><td id=\"td"+id+"\" style=\"cursor:pointer;background:"+clickbackground+"\" align='left' width=75% onMouseOut=\"setoutcolor"+cdcnt+"(this.id)\" onmouseover=\"setovercolor"+cdcnt+"(this.id)\" onclick=\"setTab"+cdcnt+"(this.id,'"+url+"','"+target+"')\" >"+ds.getStringAt(i,"name")+"</td></tr>";
			}
			else
				divli+="<tr><td align='right' width=15% height=\"30px\"></td><td id=\"td"+id+"\" style=\"cursor:pointer\" align='left' width=75% onMouseOut=\"setoutcolor"+cdcnt+"(this.id)\" onmouseover=\"setovercolor"+cdcnt+"(this.id)\" onclick=\"setTab"+cdcnt+"(this.id,'"+url+"','"+target+"')\" >"+ds.getStringAt(i,"name")+"</td></tr>";
		}
	}
	divli+="</table>";

	script="<script type=\"text/javascript\">
			function setTab"+cdcnt+"(id,url,target)
			{
				var str="+st+";
				for ( var i=0;i<str.length;i++){
					var rid=\"td\"+str[i];
					document.getElementById(rid).style.background='#ffffff';
					document.getElementById(rid).style.color='#000000';
				}
				document.getElementById(id).style.background='"+clickbackground+"';
				document.getElementById(id).style.color='"+clickcolor+"';
				if(target==\"_self\"){
					
				}
				else if (target==\"_blank\"){
				
				}
				else if (target==\"_parent\"){
					
				}
				else if (target!=\"\"){
					
					document.getElementById(target).src=url;
				}
				else 
					window.location = url;
			}
			function setovercolor"+cdcnt+"(id){
				document.getElementById(id).style.color='"+onmouseovercolor+"';
//					document.getElementById(id).style.background='"+onmouseoverground+"';
			}
			function setoutcolor"+cdcnt+"(id){
//					document.getElementById(id).style.background='#ffffff';
				document.getElementById(id).style.color='#000000';
			}
//				 window.onload=setTab"+cdcnt+"('"+onurl+"');
		</script>";
	var style="<style type='text/css'>


		</style>";
	var loyhtml="";
	html+="<div><table id=tbhower width=\"100%\" height=\"100%\">
			 	<tr valign=\"top\">
					<td>"+divli+"</td>
				<tr>
			 </table>
		 </div>";
	return style+script+html;
}

//
// leftwidth : default 25% 
// showsubmenumode 载入时是否展开子菜单	如果0默认全展开1仅展开第一个菜单 2 不展开菜单
function get_cjmenucontent(){

	var sql="";
	var html="";
	var script="";
	var tablehtml = "";
	var toolhtml = 0;
	if(leftwidth=="")leftwidth = "25%";
	if(titlefontsize=="")titlefontsize= "3";	
	if(showsubmenumode =="")showsubmenumode = "0";	

	var layhdrguid= pubpack.EAFunc.NVL( request.getParameter("layhdrguid"),"") ;
		var cdcnt = db.GetSQL("select CDMSSMCNT.Nextval CNT from dual");
	      	if(SQLTXT=="")
			sql="select guid,url,icon2,decode(CONTEXTES,'',name,'　'||name) name,seqid,CONTEXTES,target,id from LSYSURL a where REFID='"+DSMOD+"'  order by seqid,id";
		else
			sql=SQLTXT;var ds=db.QuerySQL(sql);
		var onurl="";
		var onguid="";
		tablehtml+="<table width=100%>";
		var menucnt = 0;
		for(var i=0;i<ds.getRowCount();i++){
				var url=ds.getStringAt(i,"url")+"&layhdrguid="+ds.getStringAt(i,"guid");
				var target=ds.getStringAt(i,"target");
				var thisid = ds.getStringAt(i,"id");
				var titleimg = "";
				var icon2 = ds.getStringAt(i,"icon2");
				if(icon2.length()>0&&icon2.substring(0,1)=="<")titleimg = icon2;
				else if(icon2.length()>=9&&icon2.substring(0,9)=="glyphicon")titleimg = "<span class='"+icon2+"'></span>";

				else if(icon2 !="") titleimg = "<img src=\""+icon2 +"\" >";
				
			        if(onurl=="") {
			        	if(layhdrguid!="")
			        		onurl="L.sp?id=contenttxt&layhdrguid="+layhdrguid; onguid=ds.getStringAt(i,"guid"); 
			        	if(layhdrguid==""&&ds.getStringAt(i,"url")!=""&&ds.getStringAt(i,"guid")!="")
			        		onurl=url;
			        }
				var lev= ds.getStringAt(i,"CONTEXTES");
				if (lev =="") {
					menucnt ++;
					if(titleimg == "")titleimg  = "<span class='glyphicon glyphicon-folder-open'></span>";
					if(ds.getStringAt(i,"url") == "") tablehtml+=" <tr><td height=30 id='"+thisid +"' onclick=\"javascript:f_showsub('"+thisid+"');\" width=100%  style=\"cursor:pointer;padding-left:20px;display:block;\" bgcolor='#EFEFEF'> <table width=100% height=100%><tr><td align='right' width='10px' height=\"30px\">"+titleimg+"</td><td style=\"color:#333333;font-size:13px;\" align='left' ><font size="+titlefontsize+">&nbsp;&nbsp;"+ds.getStringAt(i,"name")+"</font></td></tr></table></td></tr>";
					else tablehtml+=" <tr><td height=30 id='"+thisid +"' onclick=\"javascript:setTab"+cdcnt+"('"+url+"','"+target+"');f_showsub('"+thisid+"');\" width=100%  style=\"cursor:pointer;padding-left:20px;display:block;\" bgcolor='#EFEFEF'> <table width=100% height=100%><tr><td align='right' width='10px' height=\"30px\">"+titleimg+"</td><td style=\"color:#333333;font-size:13px;\" align='left' ><font size="+titlefontsize+">&nbsp;&nbsp;"+ds.getStringAt(i,"name")+"</font></td></tr></table></td></tr>";
				}
				else {
					var display = "block";
					if(showsubmenumode==1&&menucnt!=1)	display  = "none";
					else if(showsubmenumode==2) display  = "none";
					if(titleimg =="")titleimg  = "<span class='glyphicon glyphicon-list-alt'></span>";

					tablehtml+="<tr id='ref_"+lev +"' style=\"cursor:pointer;display:"+display +";\" onclick=\"setTab"+cdcnt+"('"+url+"','"+target+"')\" ><td height=30  style=\"padding-top:5px;padding-left:45px;\"  align='left' width=100%  >"+titleimg+" &nbsp;&nbsp;"+ds.getStringAt(i,"name")+"</td></tr>";
				}
				toolhtml ++;
		}
		tablehtml+="</table>";
//					window.location.href=url;
		script="<script type=\"text/javascript\">
				function setTab"+cdcnt+"(url,target)
				{
					if(target == '_blank') window.location  = url;
					else {
						var ul=url+\"&hashead=n\";
						$.ajax({
						url: ul,
						type: 'POST',
						error: function(){alert('您的网速有问题,如若网络正常。请联系管理员!');},
						success: function(result){
							document.getElementById(\"contentinfo"+cdcnt +"\").innerHTML=result;
							try { setTimeout(\"ref_load()\",10); } catch (e) { }
						}
						});
					}
				}
				function f_showsub(id)
				{
					var idlist = document.all('ref_'+id) ;
					if(idlist.length==0)return;
					var dis = 'none';
					
					try { //多个对象
						if(idlist[0].style.display=='none')dis ='block';
						for ( var i=0;i<idlist.length;i++){
							idlist[i].style.display = dis;
						}
					} catch (e) { //单个对象
						if(document.all('ref_'+id).style.display=='none')dis ='block';
						document.all('ref_'+id).style.display = dis;
					}
				}
				 window.onload=setTab"+cdcnt+"('"+onurl+"');
			</script>";
		script+="<style type='text/css'>
				.colsz{
			    		margin: 0 2px;  
			   		cursor: pointer;  
			    		text-align: left;  
			    		text-decoration: none;
			    		padding: .10em 2em .50em; 
			    		height:30px;
					background:url(EAFormBlob.sp?guid=68440FEC95C0400D93C0A07950791CAA);
					border:0px;
					font:'a7a7a7';
					font-size:13px;
				}

			</style>";
			
		var loyhtml="";

		html+="<table width=\"100%\" height=\"100%\" style='background-color:#ffffff'>
				 	<tr valign=\"top\">
						<td width=\""+leftwidth+"\"><div style=\"margin-top:5px;\">"+tablehtml+"</div></td>
						<td style='border-left:1px solid #c0c0c0;height:100px'></td>
						<td ><div style=\"border:0px solid #CCCCCC; width:100%; height:100%; text-align:center;\"><div style=\"width:100%; height:100%; margin:0 auto; \" id=\"contentinfo"+cdcnt +"\">"+loyhtml+"</div></div></td>
					<tr>
				 </table>
			 ";

	return script+html;

}

//
// 新搜索
//
function newsearch(){
	var searchval= pubpack.EAFunc.NVL( request.getParameter("searchval"),"") ;
	if(gridcolor=="") gridcolor="#ff0000";
	if(width=="") width="500"; else if(width.split("px").length()>1) width=width.split("px")[0];
	if(height=="") height="25"; else if(height.split("px").length()>1) height=height.split("px")[0]*1.0;
	var css="<style>
		</style>";
	var cdcnt = db.GetSQL("select CDMSSMCNT.Nextval CNT from dual");
	var html="<table border=\"0\" width=\""+width+"\" cellspacing=\"0\" cellpadding=\""+border+"\">
	<tr>
		<td  bgcolor=\""+gridcolor+"\">
			<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" bgcolor=\"#FFFFFF\" height=\"25\" style=\"border:"+border+" solid "+bordercolor+"\">
				<tr>
				<td><input  id=\"ipt"+cdcnt+"\" type=\"text\" value=\""+searchval+"\" name=\"T1\"  style=\"height:"+height+"px;width:100%; border: 1px solid #FFFFFF; padding-left: 4px; padding-right: 4px; padding-top: "+height/5+"px; padding-bottom: 1px; font-size:14pt; text-align:left;\" size=\"100%\"></td>
				<td rowspan=2 onclick=\"searchA"+cdcnt+"('ipt"+cdcnt+"')\" width=\"80\" style=\"CURSOR: pointer;\" bgcolor=\""+gridcolor+"\"><p align=\"center\"><font color=\"#FFFFFF\" size=\"1\" style=\"font-family:'微软雅黑'; font-size:12pt;\">搜 索</font></p></td>
				</tr>
				<tr><td></td><td><div id=\"div_search"+cdcnt+"\"  style=\"position: absolute;z-index:9;background-color:white;border:1px solid;display:none;\"></div></td></tr>
			</table>
		</td>
	</tr></table>";
	var script="<script>
		function searchA"+cdcnt+"(id){
			var value=document.getElementById(id).value;
			if(value!=null && value!=\"\"){
				var url='"+seaurl+"';
				url+='&searchval='+value;";
				if(action=="location"){
					script+="window.location.href=url;";
				}
				else{
					script+="window.open(url);";
				}
		script+="}
			else{
				alert('请输入内容！');
			}
		}";
	script+="</script>";
	return css+html+script;
}


function mwiframe(){
	var target= pubpack.EAFunc.NVL( request.getParameter("target"),"");
	if(target=="")target=deftarget;//deftarget定义初始化target路径
	var url="show.sp?grdid="+target;
//	return url;
	var html="<iframe id=mwid src='"+url+"' scrolling='auto' frameBorder=0 border='0' width='100%' height='100%' ></iframe>";
	return html;
}

function BIWAP1(){

	var BI_GUID=pubpack.EAFunc.NVL( request.getParameter("BIID"),"");
	
	var BI_TITID=pubpack.EAFunc.NVL( request.getParameter("BITITID"),"");
	var BI_TYP="2";
	var TB_IFHEAD="false";
	var TB_IFHEADBORDER="false";
	var TB_HEAD="";
	var TB_WIDTH="100%";
	var TB_HEIGHT="100%";
	var TB_ROLBGCOLOR="#d5d5d5";
	var TB_BORDERCOLOR="#cdcdcd";
	var LINE_HEIGHT="25px";
	var TB_TABLW="true";
	var TB_ENTBTYP="";
	var usr = web.EASession.GetLoginInfo(request);
	var sytid = usr.getSytid();
	var topic = pub.EAFunc.NVL(BI_TITID,"");
	var modguid = pub.EAFunc.NVL(BI_GUID,"");
	var html="<table width=\"100%\" height=\"100%\">";
	html+="<tr><td>"+bitypicon(db,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP)+"</td></tr>";
	html+="<tr><td valign=top>"+bityptable(db,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP)+"</td></tr>";
	html+="</table>";
	return html;
}
//
// 
//
function Biwap(){

	var usr = web.EASession.GetLoginInfo(request);
	var sytid = usr.getSytid();
	var topic = pub.EAFunc.NVL(BI_TITID,"");
	var modguid = pub.EAFunc.NVL(BI_GUID,"");
	if(BI_TYP==0){
		return bityptable(db,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP);
	}
	if(BI_TYP==1){
		return bitypicon(db,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP);
	}
	if(BI_TYP==2){
		var html="<table width=\""+TB_WIDTH+"\" height=\""+TB_HEIGHT+"\">";
		html+="<tr><td>"+bitypicon(db,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP)+"</td></tr>";
		html+="<tr><td valign=top>"+bityptable(db,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP)+"</td></tr>";
		html+="</table>";
		return html;
	}
}

//BI表格
function bityptable(db,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP){
	var sql="";
	sql=getbisql(db,request,sytid,topic,modguid,usr);

	var trbgcolor="#F9F9F9";
	var tdborder=0;
//	TB_ENTBTYP=true;
	var html="<table borderColor=\"\"  align=\"center\" width=\""+TB_WIDTH+"\" height=\""+TB_HEIGHT+"\" cellspcing=\"2\" cellpadding=\"2\" style=\"border-collapse:collapse;line-height:"+LINE_HEIGHT+"\" >";
	var ds=db.QuerySQL(sql);
	var style="";
	if(TB_IFHEADBORDER){
		style="style=\"border:solid "+TB_BORDERCOLOR+"; border-width:1px 1px 1px 1px;\"";
	}
	if(TB_IFHEAD){
		html+="<tr><td align=\"center\" "+style+" colspan=\""+ds.getColumnCount()+"\">"+TB_HEAD+"</td></tr>";
	}
	
	for(var r=0; r<ds.getRowCount(); r++){
		var colsum=0;
		if(r==0){
			html+="<tr style=\"height:30px\" bgcolor=\""+TB_ROLBGCOLOR+"\">";
			for(var c=0;c<ds.getColumnCount();c++){
				
				html+="<td background=xlsgrid/images/xlsgrid/tab.bg.off.grid.gif style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px 1px 1px 1px;\">"+ds.getColumnName(c)+"</td>";
				if(c==ds.getColumnCount()-1){
					html+="<td background=xlsgrid/images/xlsgrid/tab.bg.off.grid.gif style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px 1px 1px 1px;\">合计</td>";
				}
			}
			html+="</tr>";
		}
		if(TB_TABLW==true&&r%2==1) trbgcolor="#F9F9F9"; else trbgcolor="#FFFFFF";
		if(TB_ENTBTYP==true) tdborder=0;  else tdborder=1;
		html+="<tr bgcolor=\""+trbgcolor+"\">";
		for(var c=0;c<ds.getColumnCount();c++){
			
			if(c>0) colsum+=ds.getStringAt(r,c)*1;
			if(c==0&&ds.getColumnCount()>1)
				html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px "+tdborder+"px 1px 1px;\">"+ds.getStringAt(r,c)+"</td>";
			else
				html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px "+tdborder+"px 1px "+tdborder+"px;\">"+ds.getStringAt(r,c)+"</td>";
			if(c==ds.getColumnCount()-1){
					html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px 1px 1px "+tdborder+"px;\">"+colsum+"</td>";
			}
		}
		html+="</tr>";
		if(r==ds.getRowCount()-1){
			
			var rlsum=0;
			html+="<tr bgcolor=\""+trbgcolor+"\">";
			for(var c=0;c<ds.getColumnCount();c++){
				var rowsum=0;
				for(var rr=0;rr<ds.getRowCount();rr++){
					if(c>0) rowsum+=ds.getStringAt(rr,c)*1;
				}
				rlsum+=rowsum;
				if(c==0&&ds.getColumnCount()>1)
					html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px "+tdborder+"px 1px 1px;\">合计</td>";
				else
					html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px "+tdborder+"px 1px "+tdborder+"px;\">"+rowsum+"</td>";
				if(c==ds.getColumnCount()-1){
						html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px 1px 1px "+tdborder+"px;\">"+rlsum+"</td>";
				}
			}
			html+="</tr>";
		}

	}
	
	
	html+="</table>";

	return html;

}
//BI图形
function bitypicon(db,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP){
	var sql=getbisql(db,request,sytid,topic,modguid,usr);
	var optionstr = "";
	var optionds = db.QuerySQL("select * from V_CHARTTYPE");
	var cdcnt = db.GetSQL("select CDMSSMCNT.Nextval CNT from dual");
	for (var r = 0;r < optionds.getRowCount();r ++) {
		var id = optionds.getStringAt(r,"ID");
		var name = optionds.getStringAt(r,"NAME");
		var typ = optionds.getStringAt(r,"TYP");
		optionstr += "<option value='"+id+"-"+typ+"'>"+name+"</option>";
	}
	var html="<table border='0' cellspacing='0' cellpadding='0'  style='border: 1px solid "+TB_BORDERCOLOR+"'  width='98.5%' height='100%'>
								<tr><td height=30 align=center background=xlsgrid/images/xlsgrid/tab.bg.off.grid.gif>
								</td></tr>
								<tr><td height=50% valign=top>
									<div id='container"+cdcnt+"' style='margin:0px; '></div>
								</td></tr>
								</table>";
	var style="<style>
			.navPoint {
				COLOR: #225f98; CURSOR: hand; FONT-FAMILY: 'Webdings'; FONT-SIZE: 9pt
				}
		</style>";
	var script="<script>
   	 var options={
	        chart:{
	            backgroundColor: '#FFFFFF',
	            plotBackgroundColor: null,
		    plotBorderWidth: null,
		    plotShadow: false,
		    renderTo:'container"+cdcnt+"'  
	        },
	        exporting: {
	            buttons: {
	                contextButton: {
	                    menuItems: [
	                    	{
	                       	 	text: '柱状图',
	                        	onclick: function () {
	                            		f_chgchart('柱状图');
	                       		}
	                   	},
	                   	{
	                       	 	text: '折线图',
	                        	onclick: function () {
	                            		f_chgchart('折线图');
	                       		}
	                   	},
	                   	{
	                       	 	text: '区域图',
	                        	onclick: function () {
	                            		f_chgchart('区域图');
	                       		}
	                   	},
	                   	{
	                       	 	text: '曲线区域图',
	                        	onclick: function () {
	                            		f_chgchart('曲线区域图');
	                       		}
	                   	},
	                   	{
	                       	 	text: '3D柱状图',
	                        	onclick: function () {
	                            		f_chgchart('3D柱状图');
	                       		}
	                   	},
	                   	{
	                       	 	text: '3D饼图',
	                        	onclick: function () {
	                            		f_chgchart('3D饼图');
	                       		}
	                   	},
	                   	{
	                       	 	text: '混合图',
	                        	onclick: function () {
	                            		f_chgchart('混合图');
	                       		}
	                   	},
	                   	{
	                       	 	text: '柱形堆叠图',
	                        	onclick: function () {
	                            		f_chgchart('柱形堆叠图');
	                       		}
	                   	},
	                   	{
	                       	 	text: '漏斗图',
	                        	onclick: function () {
	                            		f_chgchart('漏斗图');
	                       		}
	                   	},
	                   	{
	                        	separator: true
	                    	}
	                   ]
	                   .concat(Highcharts.getOptions().exporting.buttons.contextButton.menuItems)
	                 }
	       	   }
	        },
	        title: {
	            text: '"+GetTopic(db,sytid,topic)+"'
	        },
	        plotOptions: {
	            column: {
	                depth: 25
	            }
	        },
	        xAxis: {
	            categories: "+getxAxis(db,sql,sytid,topic,0)+"
	        },
	        yAxis: {
	            allowDecimals: false,
	            title: {
	                text: 'z '
	            }
	        },
	        series: ["+getseries(db,sql,sytid,topic,0)+"]
	    };
    	$(document).ready(function(){
    		options.chart.type ='column';
		var chart = new Highcharts.Chart(options);
	});
</script>";
	script+="<script>
		function f_chgchart(val){
			if(val=='柱状图'){
				options.labels={};
				options.legend={};
				options.plotOptions={};
				options.chart.type ='column';
				 options.chart.options3d={
				                enabled: false,
				                alpha: 0,
				                beta: 0,
				                depth: 100
				            };
				options.series=["+getseries(db,sql,sytid,topic,0)+"];
				var chart = new Highcharts.Chart(options);
			}
			else if(val=='折线图'){	
				options.plotOptions={};
			 	options.chart.options3d={
				                enabled: false,
				                alpha: 0,
				                beta: 0,
				                depth: 100
				            };	
        			options.yAxis.plotLines=[{
			                value: 0,
			                width: 1,
			                color: '#808080'
			            }];
				options.chart.type ='line';
				options.legend ={
				            layout: 'vertical',
				            align: 'right',
				            verticalAlign: 'middle',
				            borderWidth: 0
				        };
				        options.series=["+getseries(db,sql,sytid,topic,0)+"];
				var chart = new Highcharts.Chart(options);
			}
			else if(val=='区域图'){
				options.labels={};
				options.legend={};
				options.plotOptions={};
				options.chart.type ='area';
				 options.chart.options3d={
				                enabled: false,
				                alpha: 0,
				                beta: 0,
				                depth: 100
				            };
				options.series=["+getseries(db,sql,sytid,topic,0)+"];
				var chart = new Highcharts.Chart(options);
			}
			else if(val=='曲线区域图'){
				options.labels={};
				options.legend={};
				options.plotOptions={};
				options.chart.type ='areaspline';
				 options.chart.options3d={
				                enabled: false,
				                alpha: 0,
				                beta: 0,
				                depth: 100
				            };
				options.series=["+getseries(db,sql,sytid,topic,0)+"];
				 var chart = new Highcharts.Chart(options);
			}
			else if(val=='3D柱状图'){
				options.labels={};
				options.legend={};
				options.plotOptions={};
				 options.chart.type='column';
				 options.chart.margin=75;
				 options.chart.options3d={
				                enabled: true,
				                alpha: 10,
				                beta: 25,
				                depth: 70
				            };
				 options.plotOptions.column={
				                depth: 25
				            };
				 options.series=["+getseries(db,sql,sytid,topic,0)+"];
				 var chart = new Highcharts.Chart(options);
			}
			else if(val=='3D饼图'){
				 options.chart.type='pie';
				 options.plotOptions={};
				 options.chart.options3d={
			                enabled: true,
			                alpha: 45,
			                beta: 0
			            };
			           options.series=[{
				            type: 'pie',
				            name: '合计',
				            data: "+getseriessum(db,sql,sytid,topic,0)+"
				   }];
				   
				   options.plotOptions={
				            pie: {
				                allowPointSelect: true,
				                cursor: 'pointer',
				                dataLabels: {
				                    enabled: true,
				                    color: '#cdcdcd',
				                    connectorColor: '#000000',
				                    format: '<b>{point.name}</b>: {point.percentage:.1f} %'
				                }
				            }
				        };
				 options.labels={};
			          var chart = new Highcharts.Chart(options);
			}
			else if(val=='混合图'){
				 options.chart.options3d={};
				 options.plotOptions={};
				 options.series=["+getserieshunhe(db,sql,sytid,topic,0)+"];
				 options.labels= {                                                         
			            items: [{                                                     
			                html: '合计',                          
			                style: {                                                  
			                    left: '150px',                                         
			                    top: '8px',                                           
			                    color: 'black'                                        
			                }                                                         
			            }]                                                            
			        };                                                          
				 var chart = new Highcharts.Chart(options);
			}
			else if(val=='柱形堆叠图'){
				
				options.labels={};
				options.legend={};
				options.chart.type ='column';
				 options.chart.options3d={
				                enabled: false,
				                alpha: 0,
				                beta: 0,
				                depth: 100
				            };
				options.plotOptions={
					            column: {
					                stacking: 'normal'
					            }
					        };
				options.series=["+getseries(db,sql,sytid,topic,0)+"];
				var chart = new Highcharts.Chart(options);
			}
			else if(val=='漏斗图'){
				options.labels={};
				options.legend={};
				options.plotOptions={
					            series: {
					                dataLabels: {
					                    enabled: true,
					                    format: '<b>{point.name}</b> ({point.y:,.0f})',
					                    color: 'black',
					                    softConnector: true
					                },
					                neckWidth: '30%',
					                neckHeight: '25%'
					            }
					        };
				options.chart.type ={
					            type: 'funnel',
					            marginRight: 100
					        };
				
				options.series=[{
						   name: '合计',
						   data: "+getseriessum(db,sql,sytid,topic,0)+"
						}];
				options.xAxis={};
				options.yAxis={};
				alert(options);
				var chart = new Highcharts.Chart(options);
			}

		}
	
	</script>";
	return style+script+html;
}
//获取BI sql
function getbisql(db,request,sytid,topic,modguid,usr){

	db = new pub.EADatabase();
	var tablename = db.GetSQL("select sourceds from dim_model where guid='"+modguid+"'");
	var isCross = isCrossReport(db,sytid,topic);
	var sql="";
	if (!isCross) {
		sql = "select "
			+ getVdimWithName(db,sytid,topic,modguid,tablename) + ","
			+ getTarget(db,sytid,topic,true,modguid,tablename)
			+ ",'双击钻取' 双击钻取"
			+ "\n  from "
			+ tablename
			+ "\n where "
			+ getSearchParam(db,sytid,topic,request)
			+ "\n group by "
			+ getVdim(db,sytid,topic)
			+ "\n order by "
			+ getVdimOrders(db,sytid,topic,modguid,tablename);
	} else {
		sql = "select "
			+ getVdimWithName(db,sytid,topic,modguid,tablename) + ","
			+ colDate2Char(db,sytid,topic,getTarget(db,sytid,topic,false,modguid,tablename))
			+ "\n  from "
			+ tablename
			+ "\n where "
			+ getSearchParam(db,sytid,topic,request);
		var r_HCols = getVdimName(db,sytid,topic,modguid,tablename);		//交叉行字段
		var r_VCols = getCrossCol(db,sytid,topic);	//交叉列字段
		var r_VCol = getCrossTarget(db,sytid,topic);	//交叉值字段
		var colsql = getColSQL(db,sytid,topic,r_VCols);	//交叉列字段SQL
		var orderby = getVdimOrders(db,sytid,topic,modguid,tablename);		//行排序字段
		sql = pub.EASqlFunc.GetSql2CrossTableSQL(db,sql,colsql,r_HCols,r_VCols,r_VCol,orderby);
	}
	var gusrinfo=web.EASession.GetUserinfo(request);
	if(gusrinfo!=null){
		sql=web.EASession.GetSysValue(sql,request);//替换request 中[%id]
		sql=web.EASession.GetSysValue(sql,web.EASession.GetUserinfo(request));
	}

	
	return sql;
}

//获取维度（带中文名）
function getVdimWithName(db,sytid,topic,modguid,tablename)
{
	var str = "";
	var sql = "select vdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	var vdim = db.GetSQL(sql);
	
	var arr = vdim.split(",");
	for (var i = 0;i < arr.length();i ++) {
		var colnam = GetColname(db,arr[i],modguid,tablename); //获取字段名称
		if (colnam == "") colnam = arr[i];
		if (str != "") str += ",";
		str += arr[i] +" as \""+ colnam +"\"";
	}
	return str;
}

//获取目标（带中文名）
function getTarget(db,sytid,topic,sumflg,modguid,tablename)
{
	var str = "";
	var sql = "select hdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	var hdim = db.GetSQL(sql);
	
	var arr = hdim.split(",");
	if (!sumflg) {
		for (var i = 0;i < arr.length();i ++) {
			if (str != "") str += ",";
			str += arr[i];
		}
	} else {
		for (var i = 0;i < arr.length();i ++) {
			var colnam = GetColname(db,arr[i],modguid,tablename); //获取字段名称
			if (colnam == "") colnam = arr[i];
			
			if (i == 0) {
				str = "sum("+ arr[i] +") as \""+ colnam +"\"";
			} else {
				str += ",sum("+ arr[i] +") as \""+ colnam +"\"";
			}
		}
	}
	return str;
}

//获取查询条件
function getSearchParam(db,sytid,topic,request)
{
	var where = "1=1";
	
	var sql = "select refmod,lvl,to_char(sysdate,'yyyy-mm-dd') dat from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	
	var ds = db.GetXMLSQL(sql);
	var refmod = ds.getStringAt(0,"REFMOD");
	var lvl = ds.getStringAt(0,"LVL");
	var sysdate = ds.getStringAt(0,"DAT");
	
	if (lvl != null && lvl != "") {
		where += "\n   and "+lvl;
	}
	
	sql = "select * from dim_dim where refmod='%s' order by seq".format([refmod]);

	var dimxmlds = db.GetXMLSQL(sql);
	
	for (var i = 0;i < dimxmlds.getRowCount();i ++) {
		var id = dimxmlds.getStringAt(i,"ID");
		var name = dimxmlds.getStringAt(i,"NAME");
		var datatyp = dimxmlds.getStringAt(i,"DATATYP");
		var control = dimxmlds.getStringAt(i,"CONTROL");
		var keyval = dimxmlds.getStringAt(i,"KEYVAL");
		var val = ""; 
		var dat1 = "";
		var dat2 = "";
		
		if (datatyp == "DATE") {
			dat1 = pub.EAFunc.NVL(request.getParameter("STA"+id),sysdate);
			dat2 = pub.EAFunc.NVL(request.getParameter("END"+id),sysdate);
			
			where += "\n   and " + id + ">=to_date(decode('"+dat1+"','','1900-01-01','"+dat1+"'),'yyyy-mm-dd')";
			where += "\n   and " + id + "<=to_date(decode('"+dat2+"','','2900-01-01','"+dat2+"'),'yyyy-mm-dd')";
		} else {
			if (val != "") {
				if (control != "" && keyval != "") {
					if (datatyp.indexOf("CHAR") >= 0) where += "\n   and "+ id +"='"+ val +"'";
					else where += "\n   and to_char("+ id +")='"+ val +"'";
				} else {
					if (datatyp.indexOf("CHAR") >= 0) where += "\n   and nvl("+ id +",' ') like '"+ val +"%'";
					else where += "\n   and nvl(to_char("+ id +"),' ') like '"+ val +"%'";
				}
			}
		}
	}

	return where;
}

//日期类型的转为字符型 select dat,itmid from aaa --> select to_char(dat,'yyyy-mm-dd') dat,itmid from aaa
function colDate2Char(db,sytid,topic,cols)
{
	var ret = "";
	var arrcols = cols.split(",");
	var incols = pub.EAFunc.SQLIN(cols);
	var sql = "select * from dim_dim where refmod=(select refmod from dim_topic where sytid='%s' and id='%s') and id in (%s)".format([sytid,topic,incols]);
	var ds = db.GetXMLSQL(sql);
	var colid = ds.getStringAt(0,"ID");
	var coltyp = ds.getStringAt(0,"DATATYP");
	
	for (var i = 0;i < arrcols.length();i ++) {
		if (ret != "") ret += ",";
		if (colid == arrcols[i] && coltyp == "DATE") ret += "to_char("+arrcols[i]+",'yyyy-mm-dd') "+arrcols[i];
		else ret += arrcols[i];
	}
	return ret;
}



//获取维度（中文名,用于交叉表行字段）
function getVdimName(db,sytid,topic,modguid,tablename)
{
	var str = "";
	var sql = "select vdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	var vdim = db.GetSQL(sql);
	
	var arr = vdim.split(",");
	for (var i = 0;i < arr.length();i ++) {
		var colnam = GetColname(db,arr[i],modguid,tablename); //获取字段名称
		if (colnam == "") colnam = arr[i];
		if (str != "") str += ",";
		str += colnam;
	}
	return str;
}


//取得交叉列字段
function getCrossCol(db,sytid,topic)
{
	var sql = "select b.id from dim_topic a,dim_dim b where a.refmod=b.refmod and a.id='%s' and a.sytid='%s' and a.hdim like '%'||b.id||'%'".format([topic,sytid]);
	return db.GetSQL(sql);
}

//交叉值字段
function getCrossTarget(db,sytid,topic)
{
	var sql = "select a.hdim,b.id from dim_topic a,dim_dim b where a.refmod=b.refmod and a.id='%s' and a.sytid='%s' and a.hdim like '%'||b.id||'%'".format([topic,sytid]);
	var ds = db.GetXMLSQL(sql);
	var hdim = ds.getStringAt(0,"HDIM");
	var vdim = ds.getStringAt(0,"ID");
	var arr = hdim.split(",");
	for (var i = 0;i < arr.length();i ++) {
		if (arr[i] != vdim) return arr[i];
	}
	return "";
}

//交叉列字段SQL
function getColSQL(db,sytid,topic,vcol)
{
	var sql = "select keyval,wher from dim_dim where refmod=(select refmod from dim_topic where sytid='%s' and id='%s') and id='%s'".format([sytid,topic,vcol]);
	var ds = db.GetXMLSQL(sql);
	var view_name = ds.getStringAt(0,"KEYVAL");
	var where = ds.getStringAt(0,"WHER");
	if (view_name == "") {
		return "";
	} else {
		if (where != "") where = " and " + where;
		sql = "select name from "+ view_name +" where 1>0 " + where;
		return sql;
	}
}
//排序依据（中文名）
function getVdimOrders(db,sytid,topic,modguid,tablename)
{
	var sql = "select orders,vdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	var ds = db.GetXMLSQL(sql);
	
	var str = ds.getStringAt(0,"ORDERS");
	var vdim = ds.getStringAt(0,"VDIM");
	
	if (str != null && str != "") return str;
	
	str = "";
	var arr = vdim.split(",");
	for (var i = 0;i < arr.length();i ++) {
		var colnam = GetColname(db,arr[i],modguid,tablename); //获取字段名称
		if (colnam == "") colnam = arr[i];
		if (str != "") str += ",";
		str += colnam;
	}
	return str;
}
//是否交叉
function isCrossReport(db,sytid,topic)
{
	var sql = "select a.hdim,b.id from dim_topic a,dim_dim b where a.refmod=b.refmod and a.sytid='%s' and a.id='%s' and a.hdim like '%'||b.id||'%'".format([sytid,topic]);
	var rowcnt = db.GetSQLRowCount(sql);
	if (rowcnt > 0) return true;
	return false;
}

//获取维度
function getVdim(db,sytid,topic)
{
	var sql = "select vdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	return db.GetSQL(sql);
}

//字段名称
function GetColname(db,colid,modguid,tablename)
{
	var ret = "";
	var ds = db.QuerySQL("select name from dim_dim where refmod='"+modguid+"' and upper(id)=upper('"+colid+"')"); //维度
	if ( ds.getRowCount() > 0 ) ret = ds.getStringAt(0,"NAME");
	else {
		ds = db.QuerySQL("select nvl(supername,'')||'Ｘ'||name name from dim_target where refmod='"+modguid+"' and upper(id)=upper('"+colid+"')"); //目标
		if ( ds.getRowCount() > 0 ) ret = ds.getStringAt(0,"NAME");
		else {
			ds = db.QuerySQL(" select comments name from user_col_comments where upper(table_name)=upper('"+tablename+"') and upper(column_name)=upper('"+colid+"')"); //系统
			if ( ds.getRowCount() > 0 ) ret = ds.getStringAt(0,"NAME");
		}
	}
	if ( ret == "" ) ret = colid;
	return ret;
}
//得到主题
function GetTopic(db,sytid,topicid)
{
	var ds = null;
	var curtopic = topicid;

	ds = db.QuerySQL("select name,longname,hdim,vdim,hdim||','||vdim hvdim,nvl(picnote,'MSColumn3D-1') picnote,vdimshowcol,piclocation,xchart from dim_topic where sytid='"+sytid+"' and id='"+topicid+"'");
	if ( ds.getRowCount() == 0 ) throw new Exception( "主题"+topicid+"没有找到" );
	
	var str =ds.getStringAt(0,"NAME");
	return str ;
}

//bchgxy	图型轴向 = 1 X和Y轴旋转
function getseries(db,sql,sytid,topic,bchgxy){

	var ds=null;
	ds = db.QuerySQL(sql);
	var statrow=0;
	var statcol=0;
	var torow=ds.getRowCount();
	var tocol=ds.getColumnCount();
	var title = GetTopic(db,sytid,topic);
	var str="";
	if (bchgxy == "0") {
		for ( var r=statrow;r<torow;r++ ) {
			str+="{name: '"+ds.getStringAt(r,ds.getColumnName(0))+"',data: [";
			for(var c=1;c<tocol;c++){
				if(c==tocol-1)
					str+=ds.getStringAt(r,ds.getColumnName(c));
				else
					str+=ds.getStringAt(r,ds.getColumnName(c))+",";
			}
			str+="]";
			if(r==torow-1) str+="}"; else str+="},";
			
		}
	} else {
		for ( var c=1;c<tocol;c++ ) {
			str+="{name: '"+ds.getStringAt(0,ds.getColumnName(c))+"',data: [";
			for(var r=1;r<torow;r++){
				if(c==torow-1)
					str+=ds.getStringAt(r,ds.getColumnName(c));
				else
					str+=ds.getStringAt(r,ds.getColumnName(c))+",";
			}
			str+="]";
			if(c==tocol-1) str+="}"; else str+="},";
		}
	}

	return str;
}

//bchgxy	图型轴向 = 1 X和Y轴旋转
function getxAxis(db,sql,sytid,topic,bchgxy){
	
	var ds=null;
	ds = db.QuerySQL(sql);
	var statrow=0;
	var statcol=0;
	var torow=ds.getRowCount();
	var tocol=ds.getColumnCount();
	var str="";
	if (bchgxy == "0") {
		str+="[";
		for ( var c=1;c<tocol;c++ ) {
			if(c==tocol-1)
				str+="'"+ds.getColumnName(c)+"'";
			else
				str+="'"+ds.getColumnName(c)+"',";
		}
		str+="]";
	} 
	else {
		str+="categories: [";
		for ( var r=0;r<torow;r++ ) {
			if(r==torow-1)
				str+="'"+ds.getStringAt(r,ds.getColumnName(0))+"'";
			else
				str+="'"+ds.getStringAt(r,ds.getColumnName(0))+"',";
		}
		str+="]";
	}
	
	return str;
}

//bchgxy图型轴向 = 1 X和Y轴旋转
function getseriessum(db,sql,sytid,topic,bchgxy){

	var ds=null;
	ds = db.QuerySQL(sql);
	var statrow=0;
	var statcol=0;
	var torow=ds.getRowCount();
	var tocol=ds.getColumnCount();
	var title = GetTopic(db,sytid,topic);
	var str="[";
	if (bchgxy == "0") {
		var sum=0;
		var colsum=0;
		for ( var r=0;r<torow;r++ ) {
			colsum=0;
			for ( var c=1;c<tocol;c++ ) {
				colsum+=ds.getStringAt(r,ds.getColumnName(c))*1.00;
			}
			sum+=colsum;
		}
		for ( var r=0;r<torow;r++ ) {
			colsum=0;
			for ( var c=1;c<tocol;c++ ) {
				colsum+=ds.getStringAt(r,ds.getColumnName(c))*1.00;
			}
//			throw new Exception(colsum+"--"+sum+"==="+colsum*100/sum.toFixed(2));
//			colsum=colsum/sum;
			if(r==torow-1)
				str+="['"+ds.getStringAt(r,ds.getColumnName(0))+"',"+colsum+"]";
			else
				str+="['"+ds.getStringAt(r,ds.getColumnName(0))+"',"+colsum+"],";
		}
	} 
	else {
		for ( var c=1;c<tocol;c++ ) {
			for ( var r=0;r<torow;r++ ) {
				colsum+=ds.getStringAt(r,ds.getColumnName(c))*1;
			}
			if(r==tocol-1)
				str+=" ['"+ds.getStringAt(0,ds.getColumnName(c))+"',"+ds.getStringAt(torow-1,ds.getColumnName(c))+"]";
			else
				str+=" ['"+ds.getStringAt(0,ds.getColumnName(c))+"',"+ds.getStringAt(torow-1,ds.getColumnName(c))+"],";
		}
	}
	str+="]";
	return str;
}

//bchgxy	图型轴向 = 1 X和Y轴旋转
function getserieshunhe(db,sql,sytid,topic,bchgxy){

	var ds=null;
	ds = db.QuerySQL(sql);
	var statrow=0;
	var statcol=0;
	var torow=ds.getRowCount();
	var tocol=ds.getColumnCount();
	var title = GetTopic(db,sytid,topic);
	var str="";
	if (bchgxy == "0") {
		for ( var r=statrow;r<torow;r++ ) {
			str+="{type:'column',name: '"+ds.getStringAt(r,ds.getColumnName(0))+"',data: [";
			for(var c=1;c<tocol;c++){
				if(c==tocol-1)
					str+=ds.getStringAt(r,ds.getColumnName(c));
				else
					str+=ds.getStringAt(r,ds.getColumnName(c))+",";
			}
			str+="]";
			if(r==torow-1) str+="}"; else str+="},";
			
		}
	} else {
		for ( var c=1;c<tocol;c++ ) {
			str+="{type:'column',name: '"+ds.getStringAt(0,ds.getColumnName(c))+"',data: [";
			for(var r=1;r<torow;r++){
				if(c==torow-1)
					str+=ds.getStringAt(r,ds.getColumnName(c));
				else
					str+=ds.getStringAt(r,ds.getColumnName(c))+",";
			}
			str+="]";
			if(c==tocol-1) str+="}"; else str+="},";
		}
	}
	str+=",{type: 'spline', name: '平均',data:"+getseriespingjun(db,sql,sytid,topic,bchgxy)+" },{type:'pie',name: '合计饼图',data:"+getseriessum(db,sql,sytid,topic,bchgxy)+",center: [150, 80],                                            
            size: 100,                                                    
            showInLegend: false,                                          
            dataLabels: {                                                 
                enabled: true,
                color: '#cdcdcd',
                connectorColor: '#000000',
                format: '<b>{point.name}</b>: {point.percentage:.1f} %'

            } }";
	return str;
}


//bchgxy图型轴向 = 1 X和Y轴旋转 去平均数
function getseriespingjun(db,sql,sytid,topic,bchgxy){

	var ds=null;
	ds = db.QuerySQL(sql);
	var statrow=0;
	var statcol=0;
	var torow=ds.getRowCount();
	var tocol=ds.getColumnCount();
	var title = GetTopic(db,sytid,topic);
	var str="[";
	if (bchgxy == "1") {
		var sum=0;
		var colsum=0;
		for ( var r=0;r<torow;r++ ) {
			colsum=0;
			for ( var c=1;c<tocol;c++ ) {
				colsum+=ds.getStringAt(r,ds.getColumnName(c))*1.00;
			}
			sum+=colsum;
		}
		for ( var r=0;r<torow;r++ ) {
			colsum=0;
			for ( var c=1;c<tocol;c++ ) {
				colsum+=ds.getStringAt(r,ds.getColumnName(c))*1.00;
			}
//			throw new Exception(colsum+"--"+sum+"==="+colsum*100/sum.toFixed(2));
//			colsum=colsum/sum;
			if(r==torow-1)
				str+=colsum;
			else
				str+=colsum+",";
		}
	} 
	else {
		var sum=0;
		var colsum=0;
		for ( var c=1;c<tocol;c++ ) {
			colsum=0;
			for ( var r=0;r<torow;r++ ) {
				colsum+=ds.getStringAt(r,ds.getColumnName(c))*1.00;
			}
			sum+=colsum;
		}
		for ( var c=1;c<tocol;c++ ) {
			colsum=0;
			for ( var r=0;r<torow;r++ ) {
				colsum+=ds.getStringAt(r,ds.getColumnName(c))*1.00;
			}
			var a=db.GetSQL("select round("+colsum+"/"+torow+",2) from dual");
//			throw new Exception("select round("+colsum/torow+",2) from dual");
			if(c==tocol-1)
				str+=a;
			else
				str+=a+",";
		}
	}
	str+="]";
	return str;
}

//
// 
//
function GetMap() {
	var html = "	<html>
		<head>
			<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />
			<meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no\" />
			<style type=\"text/css\">
				body, html{width: 100%;height: 100%; margin:0;}
				#l-map{height:800px;width:100%;}
			</style>
			<script type=\"text/javascript\" src=\"http://api.map.baidu.com/api?v=2.0&ak=bcqnSYjGSOPcmxcDpG8T9nMs\"></script>
			<title>MAP</title>
		</head>
		<body onload=\"load()\">
			<div id=\"l-map\" style=\"width:100%;height:100%;\"></div>
			
		</body>
		</html>
		<script type=\"text/javascript\">
			function load() {
				navigator.geolocation.getCurrentPosition(onSuccess, onError,{ maximumAge: 3000, timeout: 10000, enableHighAccuracy: true });
			}
			
			var onSuccess = function (position) {
				var lat = position.coords.latitude;
				var lng = position.coords.longitude;
			if(lat!=''&&lat!=null&&lng!=''&&lng!=null){
				var map = new BMap.Map('l-map');
				var gpsPoint=new BMap.Point(lng,lat);
				map.centerAndZoom(gpsPoint, 16);
				map.addControl(new BMap.NavigationControl());  //添加默认缩放平移控件 v2.0

				var marker1 = new BMap.Marker(gpsPoint);  // 创建标注	
				map.addOverlay(marker1);              // 将标注添加到地图中	
				
				map.setCenter(gpsPoint);
				var label = new BMap.Label('Localtion',{offset:new BMap.Size(20,-10)});
				map.addOverlay(label);//添加标签

				var local = new BMap.LocalSearch(map, {
					renderOptions:{map: map, autoViewport:true}
				});
				local.searchNearby('医院', gpsPoint);
			}
			};
			function onError(error) {  
				alert(JSON.stringify(error)); 
			} 
		</script>";
		
		return html;
}

function os()
{
	
	var eas = new pubpack.EAScript(null);
	eas.DefineScopeVar("request", request);
	eas.DefineScopeVar("deforg", deforg);
	eas.DefineScopeVar("OSPARAM", OSPARAM);

	return eas.CallClassFunc(OSMWID,OSFUNC,null).castToString();
}


//
// 
//
function GetMap()
{

}

}