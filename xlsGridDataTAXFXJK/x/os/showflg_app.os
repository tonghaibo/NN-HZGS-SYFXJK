function x_showflg_app(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
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

/****
首页打开布局用f_openLocalURL(url)
子页面打开布局用openWindow(url)
****/
function GetBody(){

//组件里的参数直接使用
var menu5str=MENU5;
var menu4str=MENU4;
var menu2str=MENU2;
var menu3str=MENU3;
var menu1str=MENU1;
var htmltitle=HTMLTITLE;//网页标题
var title1=TITLE1;
var title2=TITLE2;
var title3=TITLE3;
var title4=TITLE4;
var title5=TITLE5;
var qty=DIVQTY;
var boomflg=BOOMFLG;

//var singnGuid=genFormguid();
var html="
<!--HTML5 doctype-->
<html>
<head>
    <title>"+htmltitle+"</title>
    <meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=0, minimal-ui\">
    <meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />
    <META HTTP-EQUIV=\"Pragma\" CONTENT=\"no-cache\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />
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
	<style type=\"text/css\" >
	.copyright {
	padding: 8px;
	text-align: center;
	font-size: 14px;
	color:#B2B2B2;
	}
	</style>
<script type=\"text/javascript\">
var curwinid=0;
var maxwinid=10;
function f_openWebURL(url){
	curwinid ++;
	if(curwinid>maxwinid)curwinid=1;
	$.get(url,function(data,status){				
	document.getElementById(\"DOCWIN\"+curwinid).innerHTML=data;
	});			
	document.all('a_gotoitem'+curwinid).click();
}
function f_openLocalURL(url) {
        curwinid ++;
        if (curwinid>maxwinid) curwinid=1;
        var data = \"<iframe src='\"+url+\"' width=100% height=100% frameborder=0 id='iframe_test'></iframe>\";
        document.getElementById(\"PANEL_WIN\"+curwinid).innerHTML=data;
        document.all('a_gotopanel'+curwinid).click();
}     

</script>	
<!--公用js-->

<link type=\"text/css\" href=\"xlsgrid/images/flash/css/showflgapp_style.css\" rel=\"stylesheet\"/>
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/showflgapp_jquery1.7.1.min.js\"></script>



<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery.event.drag-1.5.min.js\"></script>
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery.touchSlider.js\"></script>

<link type=\"text/css\" href=\"xlsgrid/images/flash/css/showflgapp_menu.css\" rel=\"stylesheet\" />
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

<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery-2.1.3.min.js\"></script>    
    	<script type=\"text/javascript\">
	function genup(url){
	$('#loadingDiv').css('display','block');  
	    $('#popup').slideDown();
            document.getElementById(\"loadingafram\").src=url; 
	}
	function gendown(){
	$('#loadingDiv').css('display','none'); 
	$('#popup').slideUp();
	}
</script>

<style type=\"text/css\" >
 #popup{
  position: absolute;display:none; z-index:999999; background-color:#FFF; left: 601px; top: 217px; height: 150px; width: 217px;line-height:94px;text-align:center;
  border: 1px solid #03F;
}
#embedding{
  position: absolute; background-color: #36F; top: 94px;height:56px; width:217px;line-height:56px;text-align:center;
}
</style>
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery-2.1.3.min.js\"></script>    
 
</head>
<body >
    <div class=\"view\" id=\"mainview\">
        <header>
            <h1>"+htmltitle+"</h1>
            ";
            if(SETINFO == "1") {
            	html += "<img src=xlsgrid/images/flash/appicon/icon_73.png  style=\"float:right;width:45px;margin-right:10px;\" onclick=\"genup('"+SETINFOURL+"')\"  / >";
            }
            html+="</header>

		<div id=\"loadingDiv\" style=\"position:fixed;display:none;z-index:2000;top:10px;left:0px;width:100%;height:100%;background-color:#FFFFFF\">
		<div height=20% style=\"filter: alpha(opacity=45); opacity:0.45; height:40px;width:100%;position:fixed;left:0px;top:0px;background-color:#2c2c2c;\">
		<div style=\"position:fixed;top:10px;\"><a style=\"margin-left:10px\" onclick=\"gendown()\">返回</a></div>
		</div>
		<iframe id=\"loadingafram\" src=\"\" width=100% height=100% frameborder=0></iframe>
		</div>
        <div class=\"pages\">
        	    ";	
        	    if(title1!="" && title1!=null){			
         	   	   html+="
         	           <!--第一个布局--------->
         	    	   <div class=\"panel\" data-title=\""+title1+"\" id=\"all_panel1\" data-footer=\"none\"  data-selected=\"true\" style=\"margin:0;padding:0;\">";	
         	    	   
		     	   if(menu1str!="" && menu1str!=null){
		     	   
		          	html+=getlayout(request,menu1str);   
		           }
		     	   html+="</div>";
		     }
        	    if(title2!="" && title2!=null){			
         	   	   html+="
         	           <!--第二个布局--------->
         	    	   <div class=\"panel\" data-title=\""+title2+"\" id=\"all_panel2\" data-footer=\"none\"   style=\"margin:0;padding:0;\">";		
		     	   if(menu2str!="" && menu2str!=null){   		
		          	html+=getlayout(request,menu2str);   
		           }
		     	   html+="</div>";
		     }
        	    if(title3!="" && title3!=null){			
         	   	   html+="
         	           <!--第三个布局--------->
         	    	   <div class=\"panel\" data-title=\""+title3+"\" id=\"all_panel3\" data-footer=\"none\"   style=\"margin:0;padding:0;\">";		
		     	   if(menu3str!="" && menu3str!=null){   		
		          	html+=getlayout(request,menu3str);   
		           }
		     	   html+="</div>";
		     }
		     
        	    if(title4!="" && title4!=null){			
         	   	  
         	   	   html+="
         	           <!--第四个布局--------->
         	    	   <div class=\"panel\" data-title=\""+title4+"\" id=\"all_panel4\" data-footer=\"none\"   style=\"margin:0;padding:0;\">";		
		     	   if(menu4str!="" && menu4str!=null){   		
		          	html+=getlayout(request,menu4str);   
		           }
		     	   html+="</div>";
		     }
		      if(title5!="" && title5!=null){			
         	   	  
         	   	   html+="
         	           <!--第五个布局--------->
         	    	   <div class=\"panel\" data-title=\""+title5+"\" id=\"all_panel5\" data-footer=\"none\"   style=\"margin:0;padding:0;\">";		
		     	   if(menu4str!="" && menu4str!=null){   		
		          	html+=getlayout(request,menu5str);   
		           }
		     	   html+="</div>";
		     }	
		          
		          html+="
		     		
		     <!--10个循环的div--------->
		     <div class=\"panel\" data-title=\"连接内部窗口不显示\" id=\"WININNER\" data-footer=\"none\">";
		          if(qty==0 || qty==null || qty==""){
		          	qty=10;
		          }
		          for(var i=1;i<=qty;i++){
		          	html+="<a href='#PANEL_WIN"+i+"' id='a_gotopanel"+i+"' style=\"display：none;\">直接跳转到win"+i+"</a><br>";
		          }
		          html+="<a href='#PANEL_WIN0' id='a_gotopanel0' style=\"display：none;\">直接跳转到临时页面</a><br>";

		     html+="</div>";     
		     
			   for(var i=0;i<=qty;i++){
			   	html+="
			          	<div class='panel' data-title='"+htmltitle+"' id='PANEL_WIN"+i+"' data-footer='none' style='padding:0;'>
				        <img src='xlsgrid/images/flash/images/loading.gif' style='max-width=:100%;height=:auto;margin-top:30px;' >
				        </div><br>
			        ";
		          }
		      html+="
		      </div><!--这个是pages 的结束-------------------------------------------------------------------------------->	         
		         ";
		            if( boomflg==null || boomflg==""){
		          	qty=0;
		          }
		         if(boomflg!=1){
			         
			         html+="
			         <!--Footer to add tabs if desired-->
			        <footer>
			            <!--五个div固定的菜单--------->
			            ";
			            if(title1!="" && title1!=null){
			            	html+="<a href=\"#all_panel1\" class=\"icon home\" id='tab1' data-transition=\"none\">"+title1+"</a>";	
			            }
			            if(title2!="" && title2!=null){
			            	html+="<a href=\"#all_panel2\" class=\"icon heart\" id='tab2' data-transition=\"up-reveal\">"+title2+"</a>";
				    }
				    if(title3!="" && title3!=null){
				    	html+="<a href=\"#all_panel3\" class=\"icon pencil\" id='tab3' data-transition=\"none\">"+title3+"</a>";
			            }
			            if(title4!="" && title4!=null){
			            	html+="<a href=\"#all_panel4\" class=\"icon user\" id='tab4' data-transition=\"none\">"+title4+"</a>";
				    }
			            if(title5!="" && title5!=null){
			            	html+="<a href=\"#all_panel5\" class=\"icon user\" id='tab5' data-transition=\"none\">"+title5+"</a>";
				    }
	
				    html+="
		
			        </footer>";
			}	
	html+="	        
    </div><!--这个是view 的结束------------------------------------------------------------------------------------->

</body>

</html>	
";
return html;

}


//获取每个布局的编号
function genSTR(str){

	var sql="";
	var ds="";
	var db=null;
	db = new pubpack.EADatabase();
	var layid="";
	try{
		sql="
			SELECT B.* FROM LAYOBJ A ,LAYOBJDTL B  
			WHERE A.GUID=B.FORMGUID 
			AND A.ID ='MAINAPPFRAM' AND A.CLS='CHIS'and B.id ='"+str+"'
		";
		ds=db.QuerySQL(sql);
		if(ds.getRowCount()==1){
			layid=ds.getStringAt(0,"VAL");
			return layid; 
		}
	}
	catch(e){return "";}
	if(db!=null){db.Close();}
}
//获取布局的html
function getlayout(request,layoutid){
	var db = null;
	var msg= "";
	var objid= pubpack.EAFunc.NVL( request.getParameter("objid"),"") ;
	var skin= pubpack.EAFunc.NVL( request.getParameter("skin"),"") ;
	var hashead = pubpack.EAFunc.NVL( request.getParameter("hashead"),"y") ;
	var lang = pubpack.EAFunc.NVL( request.getParameter("lang"),"y") ;
	var deforg =  pubpack.EAFunc.NVL( request.getParameter("thisorgid"),webpack.EAWebDeforg.GetDeforg(request)) ;
	var browsetype = pubpack.EAFunc.getBroswerType( request );
	var sb=new langpack.StringBuffer();
	try{	
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var parent = new x_L();
		parent.GetLayoutHTML(db,request,sb,deforg,layoutid,0,"","",lang);
	}
		catch ( ee ) {
			db.Rollback();
			sb.append("");
						
			throw new pubpack.EAException ( ee.toString() );
		}
		finally {
			if (db!=null) db.Close();
		}

	return sb.toString();
}

//
// 动态单个分组菜单
// DBNAME,SQL,TITLE,TITLEICON,MENUID,SUBTITLE,SHOWSUBMENU
// IFSHOWCOUNT
// IFSHOWHEADCOUNT
function GetAPPSubMenu()
{
	
	var db = null;
	var rethtml= "";
	if(SHOWSUBMENU==""||SHOWSUBMENU=="null"||SHOWSUBMENU==null)SHOWSUBMENU = "0";
	if(IFSHOWCOUNT==""||IFSHOWCOUNT=="null"||IFSHOWCOUNT==null)IFSHOWCOUNT= "1";
	if(IFSHOWHEADCOUNT==""||IFSHOWHEADCOUNT=="null"||IFSHOWHEADCOUNT==null)IFSHOWHEADCOUNT= "1";
	



	rethtml+="<link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/css/appframe-icons.css\" />
    <link href=\"xlsgrid/images/flash/css/appframe-cate.css\" rel=\"stylesheet\" type=\"text/css\" />
    
    <link type=\"text/css\" href=\"xlsgrid/images/flash/css/showflgapp_menu.css\" rel=\"stylesheet\" />
	";

	try {
		if(DBNAME!="")
			db = new pubpack.EADatabase(DBNAME);	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		else db = new pubpack.EADatabase();
		// 处理SQL的替代
		var usrinfo  = web.EASession.GetLoginInfo(request);
		SQL=web.EASession.GetSysValue(SQL,request);//替换request 中[%id]
		SQL=web.EASession.GetSysValue(SQL,usrinfo);
		var ds = db.QuerySQL(SQL);//列名称需要有ICON，NAME，URL，CNT（记录数）等字段
		var subhtmlstr ="";
		var sumcount = 0 ;
		var oldgroupid = "NULL";
		var MENUID = "";
		var MENUSUBTITLE = "";
		var displayflag = "none";
		if(SHOWSUBMENU == "1" ) displayflag = "block";
		for ( var i=0;i<ds.getRowCount();i++ ) {
			var NAME = ds.getStringDef(i,"NAME","");
			var SUBNAME = ds.getStringDef(i,"SUBNAME","");
			var ICON = ds.getStringDef(i,"ICON","");
			var ICONCOLOR = ds.getStringDef(i,"ICONCOLOR","#666666");

			var URL = ds.getStringDef(i,"URL","");
			var CNT= 1*ds.getStringDef(i,"CNT","0");
			//MENUTITLE,MENUICON,MENUSUBTITLE 
			MENUID= ds.getStringDef(i,"MENUID","");
			var MENUTITLE= ds.getStringDef(i,"MENUTITLE","");
			var MENUICON= ds.getStringDef(i,"MENUICON","");
			
			MENUSUBTITLE = ds.getStringDef(i,"MENUSUBTITLE","");
			var strShowCount = "";
			if(IFSHOWCOUNT=="1")strShowCount +="<div class=\"spans3\">"+CNT+"</div>";
			if(oldgroupid !=MENUID){
				if(i!=0) {
					if(IFSHOWHEADCOUNT=="1")
					{
						rethtml+="<span class=\"spans2\" style=\"margin-top:10px;\">"+sumcount +"</span >";
						rethtml+="<i>"+MENUSUBTITLE+"："+sumcount+"</i>";
					}
					else   rethtml+="<i>"+MENUSUBTITLE+"</i>";

					 rethtml+="</p><b></b></a>
			         	 </li>
					</ul>
					<ul class=\"uls\" id=\"SUB_"+ds.getStringDef(i-1,"MENUID","")+"\" style=\"display:"+displayflag +";margin-left:15px;margin-right:15px;\" style=\"margin:6px;\">";
	
					rethtml+=subhtmlstr ;
					subhtmlstr = "";
					rethtml+="</ul>";
				}
				
				// 加上分页标签
				rethtml += "<ul class=\"mainmenu\" id=\"MENU"+MENUID+"\" onclick=\"clicul('SUB_"+MENUID+"');\" >
			         		<li  align=\"left\"><a href=\"#MYROOMpanel\"  style=\"text-decoration:none;\"><em></em><p><span >"+MENUTITLE+"</span>";
				sumcount = 0 ;
			}
			subhtmlstr += "<a href=\"#\" onclick=\""+URL+"\" class=\"asa2\" style=\"text-transform:none;text-decoration:none;\" style=\"margin:6px;\">
					<li class=\"lis2\" id=\"\" style=\"border:0px;margin-bottom:4px;\"> <table width=100% border=0><tr><td width=60 align=left valign=middle>";
			if(ICON.length()>9 && ICON.substring(0,9)=="glyphicon")
				subhtmlstr += "<font class=\""+ICON+"\" style=\"font-size: 30px;font-style: normal;\" color='"+ICONCOLOR +"'> </font>";
			else if(ICON!="")
				subhtmlstr += "<img src='"+ICON+"' width=60 height=60  border=0>";
			else 	subhtmlstr += "<font class=\"glyphicon glyphicon-list-alt\" style=\"font-size: 30px;font-style: normal;\" color='"+ICONCOLOR +"'></font>";
			subhtmlstr += "</td><td> ";
			subhtmlstr += "<font style=\"font-size: 16px;font-style: normal;color:#333333\">  "+NAME+"</font>"+strShowCount ;
			if(SUBNAME!="")
				subhtmlstr += "<BR><font style=\"font-size: 12px;font-style: normal;color:#555555\"> "+SUBNAME+"</font>";
			subhtmlstr += "</td></tr></table></li>
					</a>	";

			sumcount += CNT;
			oldgroupid  = MENUID;
		}
	
		if(rethtml!=""){
			if(IFSHOWHEADCOUNT=="1")
			{
				rethtml+="<span class=\"spans2\" style=\"margin-top:10px;\">"+sumcount +"</span>";
				rethtml+="<i>"+MENUSUBTITLE+"："+sumcount +"</i>";
			}
			else rethtml+="<i>"+MENUSUBTITLE+"</i>";
			
			   rethtml+="</p><b></b></a>
	         	  </li>
			</ul>
			<ul class=\"uls\" id=\"SUB_"+oldgroupid +"\" style=\"display:"+displayflag +";margin-left:15px;margin-right:15px;\" style=\"margin:6px;\">";
	
			rethtml+=subhtmlstr ;
			rethtml+="</ul>";
		}
			}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return rethtml;

}

//获取每个布局的编号
function genFormguid(){

	var sql="";
	var ds=null;
	var db=null;
	db = new pubpack.EADatabase();
	
	var usr=web.EASession.GetLoginInfo(request);
	var orgid=usr.getOrgid();
	var accid=usr.getAccid();
	var userid =usr.getUsrid();
	//return userid+"_"+orgid ;
	var layid="";
	try{
		sql="
			select guid from CHIS_PATINFO where formguid=(select guid from usr where id='"+userid+"')
		";
		ds=db.QuerySQL(sql);
		if(ds.getRowCount()==1){
			layid=ds.getStringAt(0,"guid");
			return layid; 
		}
	}
	catch(e){return "";}
	if(db!=null){db.Close();}
}



//
// 
//
function GetAPPFrameBody()
{	
	if(DIVQTY==0 || DIVQTY==null || DIVQTY=="")DIVQTY=10;
	if(BOTTOMMENUICON==null)BOTTOMMENUICON="";
	if(BOTTOMMENUNAME==null)BOTTOMMENUNAME="";
	if(BOTTOMMENUURL==null)BOTTOMMENUURL="";
	if(DIVBGCOLOR==0 || DIVBGCOLOR==null || DIVBGCOLOR=="") DIVBGCOLOR="#000";
	
	var aName = BOTTOMMENUNAME.split(",");
	
	var aLayout = BOTTOMMENUURL.split(",");
	
	var aIcon = BOTTOMMENUICON.split(",");

	var layout1 = "";var layout2 = "";var layout3 = "";var layout4 = "";var layout5 = "";var layout6 = "";var layout7 = "";var layout8 = "";var layout9 = "";var layout10 = "";var layout11 = "";

	
	if(aLayout.length()>0)layout1 =aLayout[0];
	if(aLayout.length()>1)layout2 =aLayout[1];
	if(aLayout.length()>2)layout3 =aLayout[2];
	if(aLayout.length()>3)layout4 =aLayout[3];
	if(aLayout.length()>4)layout5 =aLayout[4];
	if(aLayout.length()>5)layout6 =aLayout[5];
	if(aLayout.length()>6)layout7 =aLayout[6];
	if(aLayout.length()>7)layout8 =aLayout[7];
	if(aLayout.length()>8)layout9 =aLayout[8];
	if(aLayout.length()>9)layout10 =aLayout[9];
	if(aLayout.length()>10)layout11 =aLayout[10];

	var aDefIcon = "glyphicon glyphicon-home,glyphicon glyphicon-th-large,glyphicon glyphicon-picture,glyphicon glyphicon-user,glyphicon glyphicon-signal,glyphicon glyphicon-check,glyphicon glyphicon-inbox,glyphicon glyphicon-lock,glyphicon glyphicon-qrcode,glyphicon glyphicon-comment,glyphicon glyphicon-home,glyphicon glyphicon-th-large".split(",");
	var html="


  	<script type=\"text/javascript\" src='xlsgrid/images/flash/js/socket.io.js'></script>	
	<script type=\"text/javascript\">
	var curwinid=0;
	var maxwinid=10;
	var socket = null;
	var url = \"\";
	var isim = "+USRIM+";
	if(isim == '') isim = 2; 
	var DIVQTY="+DIVQTY+";
	if(isim === 1) {
		var iosocket = io.connect('http://db.xmidware.com:9001'),
		session, username, callingTo, duplicateMessages = [];
		iosocket.emit('login', G_APP_USRGUID);
	   	url =G_WEBBASE+\"rcall.jsp?sytid=CHIS&mwid=CHISOS&funcid=upStat&myusrguid=\"+G_APP_USRGUID+\"&flg=1&userpwd=\"+G_APP_USERPWD+\"&usrid=\"+G_APP_USRID+\"\";
		$.get(url,function(result) {
			var str = result
			str = str.replace(/\\n/g,'');
			console.log(\"在线\"+str);
		});
		
		 iosocket.on('messageReceived', function(name,str,message){
		 	switch (message.type){
		 		case 'loginout':
	 		  	url =G_WEBBASE+\"rcall.jsp?sytid=CHIS&mwid=CHISOS&funcid=upStat&myusrguid=\"+name+\"&flg=2&userpwd=\"+G_APP_USERPWD+\"&usrid=\"+G_APP_USRID+\"\";
				$.get(url,function(result) {
					var str = result
					str = str.replace(/\\n/g,'');
					console.log(\"离线\"+name);
				});
				break;
			}
		});

		var _t = 2;
		
		window.onbeforeunload = function(){  
			setTimeout(function(){_t = setTimeout(officeLine(), 0)}, 0);

			iosocket.emit('sendMessage', G_APP_USRGUID,G_APP_USRGUID, {type: 'loginout'});
		}  
		function officeLine(){
			clearTimeout(_t);
			console.log(_t);
		}
		
		function xiaochu() {
			document.getElementById('bell').innerHTML=''
		}
	}
	
	function f_openLocalURL(url) {
		try{parent.alertaudio('');}catch(e){}
		var oldwinid = curwinid ;
	        curwinid ++;
	        if (curwinid>maxwinid) curwinid=1;
	        //document.all('a_gotopanelLOAD').click(); 
		if(oldwinid !=-1){// 首页打开，不需要
	        	document.getElementById(\"PANEL_WIN\"+curwinid).setAttribute('returntitle',document.all('CURTITLE').innerHTML);
	        	document.getElementById(\"PANEL_WIN\"+curwinid).setAttribute('returnseq',oldwinid);
	        	document.all('CURTITLEBACK').innerHTML=\"<li class='glyphicon glyphicon-chevron-left'></li>&nbsp; \"+document.all('CURTITLE').innerHTML;
	        }
	        
	        // 假设标题是序号  
	        document.all('CURTITLE').innerHTML = '';
	        document.getElementById(\"PANEL_WIN\"+curwinid).setAttribute('titlename','');
	        
	        for ( var i=0;i<DIVQTY;i++)
		         document.getElementById('PANEL_WIN'+i).style.display='none';
	        document.getElementById(\"PANEL_WINLOADING\").style.display='';
		bWatingOpen  = true;
		
	        var data = \"<iframe id='frame_win\"+curwinid+\"'src='\"+url+\"' width=100% height=100% frameborder=0></iframe>\";
	        document.getElementById(\"PANEL_WIN\"+curwinid).innerHTML=data;
	        
	        setTimeout('_settimeout()',1000);
	         
	         

//		document.all('a_gotopanel'+curwinid).click(); 

//	        bWatingOpen  = true;
//	        setTimeout('_settimeout()',500);//如果0.5分钟没有被子窗口触发
	}
	var bWatingOpen = false;
	function _settimeout()
	{
		console.log('timeout call ,'+bWatingOpen );
		if(bWatingOpen) {
			document.getElementById(\"PANEL_WINLOADING\").style.display='none';
		        document.getElementById('PANEL_WIN'+curwinid).style.display='';
		}
		bWatingOpen  = false;
	}
	function showbottommenu()
	{
		try{document.all('bottommenu').style.display=''; }catch(e){alert(e);}
		_resize();
	}
	function hidebottommenu()
	{
		try{document.all('bottommenu').style.display='none'; }catch(e){}
		_resize();
	}
	function showtopmenu()
	{
		try{document.all('topmenu').style.display=''; }catch(e){alert(e);}
		_resize();
	}
	function hidetopmenu()
	{
		try{document.all('topmenu').style.display='none'; }catch(e){}
		_resize();
	}
	// 返回上个节点     
	function f_goback()
	{	
		try{parent.alertaudio('');}catch(e){}
		var oldtitle = document.all('CURTITLE').innerHTML;
		//if(oldtitle =='')return '';
		
		var retseq = document.getElementById(\"PANEL_WIN\"+curwinid).getAttribute('returnseq');
		//document.all('a_gotopanel'+retseq ).click();
		document.getElementById(\"PANEL_WINLOADING\").style.display='none';
		for ( var i=0;i<DIVQTY;i++)
	         	document.getElementById('PANEL_WIN'+i).style.display='none';
	         document.getElementById('PANEL_WIN'+retseq ).style.display='';

		var rettitle = document.getElementById(\"PANEL_WIN\"+retseq ).getAttribute('titlename');
		
		document.all('CURTITLE').innerHTML = rettitle ;
		var backhtml=  document.getElementById(\"PANEL_WIN\"+retseq ).getAttribute('returntitle');
		if(backhtml!=\"\")
			document.all('CURTITLEBACK').innerHTML=\"<li class='glyphicon glyphicon-chevron-left'></li>&nbsp; \" + backhtml;
		else document.all('CURTITLEBACK').innerHTML='';
		showbottommenu();
		showtopmenu();
		document.all('frame_win'+curwinid).src='';
		curwinid --;
		return oldtitle ;
	}
	var G_FIRSTTITLE = '';//首页的标题
	// 下级子窗口载入完毕后调用
	// title 页面的标题
	function f_childwndready(title)
	{
		console.log('ready call '+title +bWatingOpen);
		document.all('CURTITLE').innerHTML = title ;
		document.getElementById(\"PANEL_WIN\"+curwinid ).setAttribute('titlename',title );
		if(curwinid ==0 )G_FIRSTTITLE= title;
		if(bWatingOpen){
			document.getElementById(\"PANEL_WINLOADING\").style.display='none';

			for ( var i=0;i<DIVQTY;i++)
		         	document.getElementById('PANEL_WIN'+i).style.display='none';
		         document.getElementById('PANEL_WIN'+curwinid).style.display='';
		         //try{document.all('frame_win'+curwinid).focus(); } catch(e){alert(e);}
		}
		bWatingOpen  = false;

	}
	//打开底部菜单
	function f_click_bottom_menu(num)
	{
		var url = '';
		if(num==0)url=\""+layout1+"\";
		if(num==1)url=\""+layout2+"\";
		if(num==2)url=\""+layout3+"\";
		if(num==3)url=\""+layout4+"\";
		if(num==4)url=\""+layout5+"\";
		if(num==5)url=\""+layout6+"\";
		if(num==6)url=\""+layout7+"\";
		if(num==7)url=\""+layout8+"\";
		if(num==8)url=\""+layout9+"\";
		if(num==9)url=\""+layout10+"\";
		
		//底部菜单，需要清空所有的历史返回记录;

	        curwinid =1;
	        if(num==0)curwinid=0;
	        document.getElementById(\"PANEL_WIN\"+curwinid).setAttribute('returntitle','');
	        document.getElementById(\"PANEL_WIN\"+curwinid).setAttribute('returnseq','');
	        document.all('CURTITLEBACK').innerHTML=\"\";
	        // 假设标题是序号  
	        document.all('CURTITLE').innerHTML = '';
	        document.getElementById(\"PANEL_WIN\"+curwinid).setAttribute('titlename','');
		
		
	        if(num!=0){    
	        	bWatingOpen = true;
	        	for ( var i=0;i<DIVQTY;i++)
		        	document.getElementById('PANEL_WIN'+i).style.display='none';
	       		document.getElementById(\"PANEL_WINLOADING\").style.display='';
//	       		alert(url);
	        	var data = \"<iframe id='frame_win\"+num+\"' src='\"+url+\"' width=100% height=100% frameborder=0></iframe>\";
	        	document.getElementById(\"PANEL_WIN\"+curwinid).innerHTML=data;
	        	//try{document.all('frame_win'+curwinid).focus(); } catch(e){alert(e);}

	        	setTimeout('_settimeout()',1000);
	        }
	        else {
	        	bWatingOpen= true;
	        	f_childwndready(G_FIRSTTITLE);
			
	        }
	        

//	        document.all('a_gotopanel'+curwinid).click();
	}
	
//	function f_deviceready() {
//		console.log(navigator.notification);
//	    	window.alert = navigator.notification.alert;
//		window.confirm = navigator.notification.confirm;
//		window.prompt = navigator.notification.prompt;
//	function f_onload() {
//
//		document.addEventListener('backbutton', function (){
//			
//			if(f_goback()==''){
//				if(confirm('是否要退出系统？')==1)
//					window.close();
//			}
//			return 1;
//		}
//		
//		, false); // 返回键 			
//
//
//	}
	// 固定中间区域的高度
	window.onresize=function()
	{
		 _resize();
	}
	function _resize(){
		var topbottomheight = 101;
		if(document.all('topmenu').style.display=='none') {
			document.all('mainzone').style.top = '0px';
			
			topbottomheight  = topbottomheight -50;
		}
		else {
			document.all('mainzone').style.top = '50px';

		}
		if(document.all('bottommenu').style.display=='none') topbottomheight  = topbottomheight -50;

		var hh = $(window).height()-topbottomheight ;

		document.all('mainzone').style.height = hh+'px';


//		document.all('PANEL_WINLOADING').style.height = hh+'px';
//		for ( var i=0;i<=DIVQTY;i++ ) 
//			document.all('PANEL_WIN'+i).style.height = (hh)+'px';
	}
	function f_onload()
	{
		_resize();
		curwinid  = -1;
		f_openLocalURL('"+DefLayoutURL+"');

	}
	</script>	

	</head>
	<body> 
	<div id=\"topmenu\" style=\"position: fixed;top:0px;left:0px;width:100%;height:50px;background-color:"+DIVBGCOLOR+";filter: alpha(opacity=50); opacity:0.8; \">
	    		<table width=100% height=100% border=0>
	    		<tr><td width=30% align=center valign=middle><a href='#' onclick='javascript:f_goback();' ><font color=#FFFFFF size=3><div id=\"CURTITLEBACK\"></DIV></font></a></td>
	    		<td align=center valign=middle><font color=#FFFFFF size=4><div id=\"CURTITLE\">"+HTMLTITLE+"</div></font></td>
	    		<td width=15% align=center valign=middle><font color=#FFFFFF size=4><div id=\"RIGHTBUTTON\"></div></font></td> ";
	if(RIGHTTOPIMG!=null&& RIGHTTOPIMG!="") 
		html+="<td width=15% align=center valign=middle onclick=\"f_openLocalURL('"+RIGHTTOPURL+"');\" onmouseover=\"this.style.cursor='pointer'\"><font color=#FFFFFF size=4><li id='bell' onclick=\"xiaochu();\" class='"+RIGHTTOPIMG+"'></li></font></td>";
	else 	html+="<td width=15% align=center valign=middle \">&nbsp;</td>";

	html+="</tr></table></div>";	
 	html+="<div id=\"mainzone\" style=\"position: absolute;top:50px;left:0px;width:100%;height:100%;\">
 		<div  data-title='"+HTMLTITLE+"' id='PANEL_WINLOADING' data-footer='none' style='width:100%;height:100%;padding:0;display:;' returntitle=\"\" returnseq=\"\" titlename=\"\"  >
		          	<br><br><br><img src='xlsgrid/images/flash/images/loading.gif' style='max-width=:100%;height=:auto;margin-top:30px;' ><br><P align=center> 载入中，请稍候...</p>
			        </div>
		        	";
	
	   for(var i=0;i<=DIVQTY;i++){
		html+="
	          	<div  data-title='"+HTMLTITLE+"' id='PANEL_WIN"+i+"' data-footer='none' style='width:100%;height:100%;padding:0;display:none;' returntitle=\"\" returnseq=\"\" titlename=\"\"  >
		        <img src='xlsgrid/images/flash/images/loading.gif' style='max-width=:100%;height=:auto;margin-top:30px;' >
		        </div>
	        ";

          }
	html+="</div>";
	
	       	
	if(aName [0]!=""){
	     	html+="
	     	<div id=\"bottommenu\"  style=\"display: ;position: fixed;bottom:0; z-index: 180;height: 51px;width:100%;background: #0066a0;border-top: 1px solid #0066a0;_top:expression(eval(document.documentElement.scrollTop+document.documentElement.clientHeight-this.offsetHeight-(parseInt(this.currentStyle.marginTop, 10)||0)-(parseInt(this.currentStyle.marginBottom, 10)||0)));\" >
	     	<table  border=0 width=100%><tr>";
		for ( var i=0;i<aName.length();i++){
			if(i>11)break;
			var sWidth=100/aName.length();
			var icon = aDefIcon[i];
			if(aIcon.length()>i&&aIcon[i]!="")icon = aIcon[i];
			if(aName [i]!="")
		       		html+="<td id='tdbottom"+i+"' onclick=\"f_bottommenu("+i+");\" width=\""+sWidth+"%\" style=\"cursor: pointer;\"><table width=100% height=100% border=0><tr><td align=center valign=middle> <font color='#FFF' ><li class=\""+icon +"\" style=\"font-size:20px;\"></li></font></td></tr><tr><td align=center valign=middle><font color=#FFF style=\"font-size:14px;\">"+aName [i]+"</font></td></tr></table></td>";	
		}
		html+="</tr></table>
		</div>
		<script> 
		function f_bottommenu(num){
			for ( var i=0;i<"+aName.length()+";i++){
				if(i!=num) document.all('tdbottom'+i).style.background='#0066a0';
				else document.all('tdbottom'+i).style.background='#0088d1';
				
			}
			f_click_bottom_menu(num);
		}
		</script>
		";
	}

	return html;
	

}
// 老的APP布局，屏幕切换的时候可以滑动，但是不兼容很多浏览器，在手机上有卡顿
function GetAPPFrameBodySlide()
{	
	if(DIVQTY==0 || DIVQTY==null || DIVQTY=="")DIVQTY=10;
	if(BOTTOMMENUICON==null)BOTTOMMENUICON="";
	if(BOTTOMMENUNAME==null)BOTTOMMENUNAME="";
	if(BOTTOMMENUURL==null)BOTTOMMENUURL="";
	
	var aName = BOTTOMMENUNAME.split(",");
	
	var aLayout = BOTTOMMENUURL.split(",");
	
	var aIcon = BOTTOMMENUICON.split(",");

	var layout1 = "";var layout2 = "";var layout3 = "";var layout4 = "";var layout5 = "";var layout6 = "";
	
	if(aLayout.length()>0)layout1 =aLayout[0];
	if(aLayout.length()>1)layout2 =aLayout[1];
	if(aLayout.length()>2)layout3 =aLayout[2];
	if(aLayout.length()>3)layout4 =aLayout[3];
	if(aLayout.length()>4)layout5 =aLayout[4];
	if(aLayout.length()>5)layout6 =aLayout[5];

	var aDefIcon = "glyphicon glyphicon-home,glyphicon glyphicon-th-large,glyphicon glyphicon-picture,glyphicon glyphicon-user,glyphicon glyphicon-signal,glyphicon glyphicon-check".split(",");
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
	
	<script type=\"text/javascript\">
	var curwinid=0;
	var maxwinid=10;
	var socket = null;
	var url = \"\";
	var isim = "+USRIM+";
	if(isim == '') isim = 2; 
	
	if(isim === 1) {
		socket = new WebSocket(\"ws://114.80.114.43:8000/\");
		socket.onopen = function(event) {
			socket.send(JSON.stringify({
				'EVENT': 'INWEB',
				'NAME': G_APP_USRNAM,
				'ID'  : G_APP_USRGUID,
				'NUM' : 8
			}));
			
			url =G_WEBBASE+ \"CHIS.CHISOS.upStat.osp?usrid=\"+G_APP_USRGUID+\"&org=CHIS&flg=1\";
			$.get(url,function(result) {
				console.log(\"在线\"+result);
			});
		};
		
		socket.onmessage = function(event) {
			var mData = JSON.parse(event.data);
			if(mData && mData.event) {
				switch(mData.event) {
					case 'LOGOUT':
					url = G_WEBBASE+ \"CHIS.CHISOS.upStat.osp?usrid=\"+mData.uid+\"&org=CHIS&flg=2\";
					$.get(url,function(result) {
						console.log(\"断线\"+mData.uid);
					});
					break;
					
					case 'ZAIXIAN':
					if(mData.uid == G_APP_USRGUID) {
						console.log(mData.zxid+\"向我咨询\");
					}
					break;
					
					case 'SPEAK':
					var content = mData.values;
					var newUser = mData.user;
					var uid = newUser.OGUID;
					if(newUser.ACTION == 'ZX') {
						if(uid == G_APP_USRGUID) {
							document.getElementById('bell').innerHTML='你有新消息';
						}
					}
					break;
					
					case 'CALL':
					if(mData.oid== G_APP_USRGUID) {
						alert('请进入'+mData.NAME+'诊室就诊');
						var url = 'L.sp?id=CHARTWE&rom='+mData.ROOM+'&USERID='+mData.oid+'&docguid='+mData.uid;
						openWindow(url);
					}
					break;
					
					case 'ROOMOVER':
					if(mData.uid == G_APP_USRGUID) {
						var url = 'L.sp?id=CHIS_APPFRAMN';
						parent.location.href=url;
					}
					break;
				}
			}
		};
		
		var _t = 2;
		
		window.onbeforeunload = function(){  
			setTimeout(function(){_t = setTimeout(officeLine(), 0)}, 0);
			socket.send(JSON.stringify({
				'EVENT': 'LOGOUT',
				'NAME': G_APP_USRNAM,
				'ID'  : G_APP_USRGUID
			}));
			url =G_WEBBASE+ \"CHIS.CHISOS.upStat.osp?usrid=\"+mData.uid+\"&org=CHIS&flg=2\";
			$.get(url,function(result) {
				console.log(\"断线\"+mData.uid);
			});    
		}  
		function officeLine(){
			clearTimeout(_t);
			alert(_t);
			socket.send(JSON.stringify({
				'EVENT': 'INWEB',
				'NAME': G_APP_USRNAM,
				'ID'  : G_APP_USRGUID,
				'NUM': _t
			}));
		}
	}
	
	function f_openLocalURL(url) {
		var oldwinid = curwinid ;
	        curwinid ++;
	        if (curwinid>maxwinid) curwinid=1;
	        //document.all('a_gotopanelLOAD').click(); 

	        document.getElementById(\"PANEL_WIN\"+curwinid).setAttribute('returntitle',document.all('CURTITLE').innerHTML);
	        document.getElementById(\"PANEL_WIN\"+curwinid).setAttribute('returnseq',oldwinid);
	        document.all('CURTITLEBACK').innerHTML=\"<li class='glyphicon glyphicon-chevron-left'></li>&nbsp; \"+document.all('CURTITLE').innerHTML;
	        // 假设标题是序号  
	        document.all('CURTITLE').innerHTML = '';
	        document.getElementById(\"PANEL_WIN\"+curwinid).setAttribute('titlename','');
	            
	         var data = \"<iframe src='\"+url+\"' width=100% height=100% frameborder=0></iframe>\";
	        document.getElementById(\"PANEL_WIN\"+curwinid).innerHTML=data;
	        
	        bWatingOpen  = true;
	        setTimeout('_settimeout()',500);//如果0.5分钟没有被子窗口触发
	}
	var bWatingOpen = false;
	function _settimeout()
	{
		if(bWatingOpen) 
			document.all('a_gotopanel'+curwinid).click(); 
		bWatingOpen  = false;
	}
	function showbottommenu()
	{
		try{document.all('bottommenu').style.display=''; }catch(e){alert(e);}
	}
	function hidebottommenu()
	{
		try{document.all('bottommenu').style.display='none'; }catch(e){}
	}
	function showtopmenu()
	{
		try{document.all('topmenu').style.display=''; }catch(e){alert(e);}
	}
	function hidetopmenu()
	{
		try{document.all('topmenu').style.display='none'; }catch(e){}
	}
	// 返回上个节点     
	function f_goback()
	{
		var retseq = document.getElementById(\"PANEL_WIN\"+curwinid).getAttribute('returnseq');
		document.all('a_gotopanel'+retseq ).click();
		var rettitle = document.getElementById(\"PANEL_WIN\"+retseq ).getAttribute('titlename');
		document.all('CURTITLE').innerHTML = rettitle ;
		var backhtml=  document.getElementById(\"PANEL_WIN\"+retseq ).getAttribute('returntitle');
		if(backhtml!=\"\")
			document.all('CURTITLEBACK').innerHTML=\"<li class='glyphicon glyphicon-chevron-left'></li>&nbsp; \" + backhtml;
		else document.all('CURTITLEBACK').innerHTML='';
		showbottommenu();
		showtopmenu();
		curwinid --;
	}
	var G_FIRSTTITLE = '';//首页的标题
	// 下级子窗口载入完毕后调用
	// title 页面的标题
	function f_childwndready(title)
	{
		document.all('CURTITLE').innerHTML = title ;
		document.getElementById(\"PANEL_WIN\"+curwinid ).setAttribute('titlename',title );
		if(curwinid ==0 )G_FIRSTTITLE= title;
		if(bWatingOpen)document.all('a_gotopanel'+curwinid).click(); 
		bWatingOpen  = false;

	}
	//打开底部菜单
	function f_click_bottom_menu(num)
	{
		var url = '';
		if(num==0)url=\""+layout1+"\";
		if(num==1)url=\""+layout2+"\";
		if(num==2)url=\""+layout3+"\";
		if(num==3)url=\""+layout4+"\";
		if(num==4)url=\""+layout5+"\";
		if(num==5)url=\""+layout6+"\";
		//底部菜单，需要清空所有的历史返回记录;
	        curwinid =1;
	        if(num==0)curwinid=0;
	        document.getElementById(\"PANEL_WIN\"+curwinid).setAttribute('returntitle','');
	        document.getElementById(\"PANEL_WIN\"+curwinid).setAttribute('returnseq','');
	        document.all('CURTITLEBACK').innerHTML=\"\";
	        // 假设标题是序号  
	        document.all('CURTITLE').innerHTML = '';
	        document.getElementById(\"PANEL_WIN\"+curwinid).setAttribute('titlename','');
	        if(num!=0){    
	        	var data = \"<iframe src='\"+url+\"' width=100% height=100% frameborder=0></iframe>\";
	        	document.getElementById(\"PANEL_WIN\"+curwinid).innerHTML=data;
	        }
	        else {
	        	f_childwndready(G_FIRSTTITLE);
			
	        }
	        document.all('a_gotopanel'+curwinid).click();
	}
	
	
	</script>	
	<!--公用js-->
	
	<link type=\"text/css\" href=\"xlsgrid/images/flash/css/showflgapp_style.css\" rel=\"stylesheet\"/>
	<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/showflgapp_jquery1.7.1.min.js\"></script>

	
	<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery.event.drag-1.5.min.js\"></script>
	<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery.touchSlider.js\"></script>
	
	<link type=\"text/css\" href=\"xlsgrid/images/flash/css/showflgapp_menu.css\" rel=\"stylesheet\" />
	<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery-2.1.3.min.js\"></script>   

	</head>
	<body> 
	    <div id=\"CELL_0_0_0\" style=\"display:none;\">隐藏</div>
	    <div class=\"view\" id=\"mainview\">
	    	<div id=\"topmenu\" style=\"top:0px;left:0px;width:100%;height:50px;background-color:#000;filter: alpha(opacity=50); opacity:0.5; \">
	    		<table width=100% height=100% border=0>
	    		<tr><td width=30% align=center valign=middle><a href='#' onclick='javascript:f_goback();' ><font color=#FFFFFF size=3><div id=\"CURTITLEBACK\"></DIV></font></a></td>
	    		<td align=center valign=middle><font color=#FFFFFF size=4><div id=\"CURTITLE\">"+HTMLTITLE+"</div></font></td>
	    		<td width=15% align=center valign=middle><font color=#FFFFFF size=4><div id=\"RIGHTBUTTON\"></div></font></td> ";
	if(RIGHTTOPIMG!=null&& RIGHTTOPIMG!="") 
		html+="<td width=15% align=center valign=middle onclick=\"f_openLocalURL('"+RIGHTTOPURL+"');\" onmouseover=\"this.style.cursor='pointer'\"><font color=#FFFFFF size=4><li id='bell' class='"+RIGHTTOPIMG+"'></li></font></td>";
	else 	html+="<td width=15% align=center valign=middle \">&nbsp;</td>";

	html+="</tr></table>
		</div>
		 <div class=\"pages\">
		";
	html+="<div class=\"panel\" data-title=\""+HTMLTITLE+"\" id='PANEL_WIN0' data-footer=\"none\"  data-selected=\"true\" style=\"margin:0;padding:0;\" returntitle=\"\" returnseq=\"\" titlename=\""+HTMLTITLE+"\">
         	    	    <iframe src='"+DefLayoutURL+"' width=100% height=100% frameborder=0></iframe>
				</div><br>";	
         	    	   	          
        html+="
	     		
	     <!--10个循环的div--------->
	     <div class=\"panel\" data-title=\"连接内部窗口不显示\" id=\"WININNER\" data-footer=\"none\">";
	          
	          for(var i=0;i<=DIVQTY;i++){
	          	html+="<a href='#PANEL_WIN"+i+"' id='a_gotopanel"+i+"' style=\"display：none;\">直接跳转到win"+i+"</a><br>";
	          }
//	          html+="<a href='#PANEL_WINLOAD' id='a_gotopanelLOAD' style=\"display：none;\">直接跳转到LOADING</a><br>";

	     html+="</div>";     
		   for(var i=0;i<=DIVQTY;i++){
		   	html+="
		          	<div class='panel' data-title='"+HTMLTITLE+"' id='PANEL_WIN"+i+"' data-footer='none' style='padding:0;' returntitle=\"\" returnseq=\"\" titlename=\"\" >
			        <img src='xlsgrid/images/flash/images/loading.gif' style='max-width=:100%;height=:auto;margin-top:30px;' >
			        </div><br>
		        ";
	          }
//	          html+="
//		          	<div class='panel' data-title='Loading' id='PANEL_WINLOAD' data-footer='none' style='padding:0;' returntitle=\"\" returnseq=\"\" titlename=\"\" >
//			        <img src='xlsgrid/images/flash/images/loading.gif' style='max-width=:100%;height=:auto;margin-top:30px;' >
//			        </div><br>
//		        ";

	      html+="
	      </div> ";
//	if(aName [0]!=""){
//	     	html+="<footer id=\"bottommenu\" style=\"diaplay:block;\">";
//		for ( var i=0;i<aName.length();i++){
//			if(i>5)break;
//			var icon = aDefIcon[i];
//			if(aIcon.length()>i&&aIcon[i]!="")icon = aIcon[i];
//			if(aName [i]!="")
//		       		html+="<a href=\"#\" class=\""+icon +"\" id='tab"+i+"' data-transition=\"none\" onclick=\"f_click_bottom_menu("+i+");\" style=\"font-size:20px;\"><P style=\"font-size:14px;\">"+aName [i]+"</p></a>";	
//		}
//		html+="</footer>";
//	}
	
	if(aName [0]!=""){
	     	html+="<table border=0 width=100% height=100% id=\"bottommenu\" style=\"display: ;z-index: 180;height: 49px;background: #0066a0;border-top: 1px solid #0066a0;\"><tr>";
		for ( var i=0;i<aName.length();i++){
			if(i>5)break;
			var sWidth=100/aName.length();
			var icon = aDefIcon[i];
			if(aIcon.length()>i&&aIcon[i]!="")icon = aIcon[i];
			if(aName [i]!="")
		       		html+="<td id='tdbottom"+i+"' onclick=\"f_bottommenu("+i+");\" width=\""+sWidth+"%\" style=\"cursor: pointer;\"><table width=100% height=100% border=0><tr><td align=center valign=middle> <font color='#FFF' ><li class=\""+icon +"\" style=\"font-size:20px;\"></li></font></td></tr><tr><td align=center valign=middle><font color=#FFF style=\"font-size:14px;\">"+aName [i]+"</font></td></tr></table></td>";	
		}
		html+="</tr></table><script> 
		function f_bottommenu(num){
			for ( var i=0;i<"+aName.length()+";i++){
				if(i!=num) document.all('tdbottom'+i).style.background='#0066a0';
				else document.all('tdbottom'+i).style.background='#0088d1';
				
			}
			f_click_bottom_menu(num);
		}
		</script>
		";
	}
	
	html+="</div>";
	return html;
	

}

//
// 
//
function GetAPPSubLayout()
{
	var rethtml= "
	    <link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/css/appframe-icons.css\" />
	    <link href=\"xlsgrid/images/flash/css/appframe-cate.css\" rel=\"stylesheet\" type=\"text/css\" />
	   
	    <link type=\"text/css\" href=\"xlsgrid/images/flash/css/showflgapp_menu.css\" rel=\"stylesheet\" />
	    <ul class=\"mainmenu\" id=\"MENU"+LAYOUTID+"\" onclick=\"clicul('SUBLAYOUT_"+LAYOUTID+"');\" >
        <li  align=\"left\"><a style=\"text-decoration:none;\"><em></em><p><b style=\"background: url(xlsgrid/images/flash/images/showflgapp_jt.png) no-repeat;background-size: 15px 19px;\"></b><span >"+TITLE+"</span>
        <span class=\"spans2\" style=\"margin-top:10px;\"></span>
	<i>"+SUBTITLE+"</i></li></ul>
	    ";                                                 
	rethtml += "<div id=\"SUBLAYOUT_"+LAYOUTID+"\" style=\"display:block;margin-left:15px;margin-right:15px;\" style=\"margin:6px;\">";
	rethtml+=getlayout(request,LAYOUTID) ;
	rethtml+="</div>";
//	rethtml += "<script type=text/javascript>
//			function clicul_"+LAYOUTID+"(id){
//				var li=document.getElementById(id);
//				if(li.style.display=='none' || li.style.display=='' ){
//					li.style.display='block';
//				}
//				else{
//				 	li.style.display='none';
//				}
//			
//			}
//			</script>";
	return rethtml;
}
//得到布局html
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
		parent.GetLayoutHTML(db,request,sb,deforg,layoutid,0,"","","");
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


}