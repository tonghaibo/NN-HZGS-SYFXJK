function x_showflg_wechat(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var ret = "";
//
function GetBody(){
	// OS 中如何得到登录的信息
	var usr=web.EASession.GetLoginInfo(request);
	var orgid=usr.getOrgid();
	var accid=usr.getAccid();
	var userid =usr.getUsrid();
	
	if(SHOWVIDEO==null|| SHOWVIDEO=="") SHOWVIDEO= "1";
	if(RIGHTFRAMEURL==null|| RIGHTFRAMEURL=="") RIGHTFRAMEURL= "";
	if(WELCOMETEXT==null|| WELCOMETEXT=="") WELCOMETEXT= "";
	
	//咨询的参数
	var zxuserid = pubpack.EAFunc.NVL( request.getParameter("ZXUSERID"),"");
	var zxdoc  = pubpack.EAFunc.NVL( request.getParameter("zxdoc"),"");
	
	//会诊的参数
	var hosroom = pubpack.EAFunc.NVL( request.getParameter("room"),"");
	var hzuserid = pubpack.EAFunc.NVL( request.getParameter("HZUSERID"),"");
	var hzdoc  = pubpack.EAFunc.NVL( request.getParameter("hzdoc"),"");
	
	//预约本次会诊的病人参数
	var mora = pubpack.EAFunc.NVL( request.getParameter("mora"),"");
	var orderid = pubpack.EAFunc.NVL( request.getParameter("orderid"),"");
	
//<!--//xmidware下的目录格式如下：xlsgrid/images/flash/js/jquery-1.7.2.min.js"-->    
//XMIDWARE_APP_USRGUID
	var baseguid="";
	var sql="";
	var ds=null;
	var db=null;
	try{
		db = new pubpack.EADatabase();
		sql="select guid from hin_his a where a.formguid='"+XMIDWARE_APP_USRGUID+"'";
		ds=db.QuerySQL(sql);
		if(ds.getRowCount()!=0)
		{
			baseguid=ds.getStringAt(0,"guid");
		} 
	}catch(e){}
	finally{
		if(db!=null){
			db.Close();
		}
	}


//图片地址
var html="
	<script type=\"text/javascript\" charset=\"utf-8\" src=\"cordova.js\"></script>  
	<script type=\"text/javascript\" charset=\"utf-8\" src=\"cordova_plugins.js\"></script>  

	<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/chart.jquery.min.js\"></script>
	<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/chart.jquery.mobile-1.4.0-rc.1.js\"></script>
	<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/chart.main.js\"></script>
	<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/chart.peer.js\"></script>
	<script>
		var SHOWVIDEO='"+SHOWVIDEO+"';
		var RIGHTFRAMEURL='"+RIGHTFRAMEURL+"';
		var WELCOMETEXT='"+WELCOMETEXT+"';
		var TITLE='"+TITLE+"';
	</script>
	<link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/css/style.css\">    
    	<link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/css/jquery.mobile.flatui.css\" />
    	<link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/css/bootstrap.min.css\"> 
	<div id=\"loadingDiv\" style=\"position:fixed;display:none;z-index:2000;top:10px;left:0px;width:100%;height:100%;background-color:#FFFFFF\">
	<div height=20% style=\"filter: alpha(opacity=45); opacity:0.45; height:40px;width:100%;position:fixed;left:0px;top:0px;background-color:#2c2c2c;\">
		<div style=\"position:fixed;top:10px;\"><a style=\"margin-left:10px\" onclick=\"gendown()\"> 返回</a></div>
	</div>
	<iframe id=\"loadingafram\" src=\"\" width=100% height=80% frameborder=0></iframe>
	</div>
	<!----- 图片等资源的预览 ----->
	<div id=\"div_img_popup\" onclick=\"document.all('div_img_popup').style.display='none';document.all('div_img_show').style.display='none';\"  style=\"z-index:9997;position:fixed; background:rgba(0,0,0,0.6); bottom:0; top:0;left:0;right:0; display:none;\"></div>
	<div id=\"div_img_show\" onclick=\"document.all('div_img_popup').style.display='none';document.all('div_img_show').style.display='none';\" style=\"z-index:9998;position:absolute; top:0px; left:0%; width:100%; height:100%;margin-left:0px; margin-top:0px; display:none;\">
		<img class=\"big\" id=\"pupupimg\" src=\"\" style=\"z-index:9999;display:;width:; height:;top:0px;left:0px;\"/>
	</div>
	
	<div id=\"info\" style=\"display:none; position:relative; width:100%; height:100%; z-index:999999;\">
		<div style=\"position:absolute; top:0; left:0;\"><a href=\"#\">关闭</a></div>
	</div>
	
	<table width=100% height=100% border=0>
	<tr>
	<td width=50%>
	<div class=\"header linear-g\" style=\"height:50px; \"><table width=100% height=100% >";//	position:fixed;
		if (SHOWPATINFO == "2") {
			html +="<td width=10%  align=center valign=middle >
		        </td>";
	        } else {
	        	html +="<td width=10%  align=center valign=middle >
		        <a href=\"#panel-left\"  class=\"glyphicon glyphicon-th-large\"> </a></td>";
	        }
	        
	       html+=" 
	       
	       <td align=center valign=middle id=\"myroomname\" >正在连接....</td>
	      
		 <td width=10% onclick=\"javascript:init(G_APP_USRGUID,G_USRID1,1);f_switchvideo();f_showaddwnd();\" align=center valign=middle>
	        <font color=#663300><span class=\"glyphicon glyphicon-facetime-video\" style=\"font-size: 24px\"></span></font> </td>

	       	<td width=10% onclick=\"try{parent.f_goback();}catch(e){}\" align=center valign=middle>
	        <font color=#663300 ><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 24px\"></span></font> </td>
	       </tr></table>
	</div>";


    
  html+= "<div data-role=\"page\" id=\"mainpage\" style=\"height:100%;position:relative;\" >
    
    
    <div data-role=\"panel\" data-position=\"left\" data-display=\"push\" class=\"list-group shortcut_menu dn linear-g\" id=\"panel-left\"  >
         <div class=\"header linear-g\">
       		<a class=\"text-center col-xs-8\">本次会诊预约的患者</a>
    </div>";
    
    if(SHOWORDER == "1") {
    	var sql="";
	var ds=null;
	var db = new pubpack.EADatabase();
    	
    	sql = "select c.imgguid,c.name,c.guid,c.id,a.preno orderid
		  from chis_preno a, yx_monthwork b, usr c
		 where a.formguid = b.guid
		   and a.usrid = c.id
		   and a.org=b.org
		   and a.org=c.org
		   and b.crtusr='"+userid+"'
		   and a.flg = '"+mora+"'
		   and a.org='CHIS' 
		   and a.predat=to_char(sysdate,'yyyy-mm-dd')
		   and monstat='1'
		   and a.stat is null
		order by seqid";
    	
    	ds = db.QuerySQL(sql);
    	if(ds.getRowCount() > 0) {
    		html +="<div style='margin:5px auto;'><button type='button' class='btn btn-info' onclick='getOver();'>结束与此患者的会诊</button></div>";
    		
	    	for (var r=0;r<ds.getRowCount();r++) {
	    		var img = ds.getStringAt(r,"imgguid");
	    		var name = ds.getStringAt(r,"name");
	    		var oguid = ds.getStringAt(r,"guid");
	    		var oid = ds.getStringAt(r,"id");
	    		var orderid= ds.getStringAt(r,"orderid");
	    		html +="<a id='"+oguid+"' onclick=\"callNext('"+oguid+"','"+orderid+"');\" class=\"list-group-item\">
	    			<img src=\"EAFormBlob.sp?guid="+ds.getStringAt(r,"imgguid")+"\" style='width:40px;'/> <span>&nbsp;"+name+"</span></a> ";
	    	}
	    	
    	} else {
    		html +="<BR><BR>本次会诊无人预约";
    	}
    }
        
        
        
        
        
   html+=" </div>
    
    
    <div data-role=\"panel\" data-position=\"right\" data-display=\"push\" class=\"user_box text-center dn linear-g\" id=\"panel-right\" style=\"border:1px solid #F2F2F2;background:#F2F2F2\" >
    	

    </div>
   

    <div id=\"mainzone\" data-role=\"content\" class=\"container\" role=\"main\" style=\"float:left;width:100%;padding-right: 0px;padding-left: 0px;margin-top:5px;\" onclick=\"f_hideaddwnd();\">
    	<table border=0  cellspacing=0 cellpadding=0><tr>
    	<td id='lefttd' width=100% height=20>
    	<table width=100% height=100%>";
    	if(SHOWVIDEO=="1") {
    		html += "<tr height=100 id=\"videos1\" style=\"display:none\">
    			<td >
    					<video id=\"other1\" autoplay=\"autoplay\" style=\"width:50%;height:auto; float:left;\" controls></video>
					<video id=\"you1\"   autoplay=\"autoplay\" style=\"width:50%;height:auto;float:left;\" controls></video>
    			</td>
    		</tr>";
    	}
    		html += "<tr>
    			<td valign=top>
    			<div id='leftdiv' style=\"float:left;width:100%;height:20px;overflow:auto;padding-right:10px;padding-left:10px;\"> 
		        	<ul class=\"content-reply-box mg10\" id=\"list\">
		        	</ul>
		        </div>	
    			</td>
    		</tr>
    	</table>
    	
        </td>";
       
	
	
	html+="</tr>
	</table>
    </div>
       <div id=\"bottomNav\" style=\"height:50px; display:block;\">
		<table width=100% border=0 height=100%>
		<tr><td align=center valign=middle height=50>
			<table width=100% height=100%  border=0  ><tr>
			<td width=50 align=\"center\" atyle=\"cursor:point;margin-left:0\" onclick=\"javascript:f_showaddwnd();\"><font size=4><li class=\"glyphicon glyphicon-plus\"></li></font></td>
			<td ><input type=\"text\" style=\"padding-left:10px;width:100%;height:38px;border: 1px solid #dedede;-moz-border-radius: 5px;-webkit-border-radius: 5px;border-radius:5px;\" id=\"text\"/></td>
			<td width=80 id=\"send\" style=\"cursor:point;\" align=center><font size=4>回复</font></td>
			</tr> 
				
			</table>	
		</td></tr>
		<tr><td>
			<table id='addwnd' width=100% height=100% style=\"border-top:1px solid #CDCDCD;display:none;\">
			<tr>
				<td width=20% align=center valign=middle><button type=\"button\" class=\"btn \" style=\"width:100%;height:60px;font-size: 12px\" onclick=\"capture(50,1,0,1024,768);\">
				  <p><font color=#003333><span class=\"glyphicon glyphicon-camera\" style=\"font-size: 24px\"></span></font></p>拍照
				</button></td>
				<td width=20% align=center valign=middle><button type=\"button\" class=\"btn \" style=\"width:100%;height:60px;font-size: 12px\" onclick=\"capture(100,1,0,-1,-1);\">
				  <p><font color=#663300><span class=\"glyphicon glyphicon-film\" style=\"font-size: 24px\"></span></font></p>高清拍照
				</button></td>
				<td width=20% align=center valign=middle><button type=\"button\" class=\"btn \" style=\"width:100%;height:60px;font-size: 12px\" onclick=\"captureAudio();\">
				  <p><font color=#444477><span class=\"glyphicon glyphicon-volume-up\" style=\"font-size: 24px\"></span></font></p>录语音
				</button></td>
				
				<td width=20% align=center valign=middle><button type=\"button\" class=\"btn \" style=\"width:100%;height:60px;font-size: 12px\" onclick=\"capture(100,0,0,-1,-1)\">
				  <p><font color=#629924><span class=\"glyphicon glyphicon-picture\" style=\"font-size: 24px\"></span></font></p>相册库
				</button></td>
				<td width=20% align=center valign=middle><button type=\"button\" class=\"btn \" style=\"width:100%;height:60px;font-size: 12px\" onclick=\"capture(100,0,1,-1,-1);\">
				  <p><font color=#884400><span class=\"glyphicon glyphicon-eye-open\" style=\"font-size: 24px\"></span></font></p>选视频
				</button></td>
				
			</tr>
			
			</table>
		</td></tr><tr><td valign=top align=left>
			<div id='recordwnd' style='display:none;' align=center>
			<button id='luyin' class='btn btn-primary btn-lg' style='width:90%;height:50px;'><apan class='glyphicon glyphicon-volume-up'></span>按住录音</button> <div id='test' align=center>请点击开始录音</div>
			</div>
		</td></tr></table>
    </div>
  </div>
  </td> ";
	 if(RIGHTFRAMEURL!="") {
       		 html += "<td id='righttd' width=50% height=100% style=\"border:1px solid #ccc;\">";
		html+="<iframe src=\""+RIGHTFRAMEURL+"\" border=0 width=100% height=100% frameborder=0 id=\"RIGHTFRAMEBL\"></iframe>";

//			html+="<div id=\"show_vidio\" style=\"display:block; \">
//			
//				<div id=\"videos1\" style=\"width:100%;\" >
//				<video id=\"other1\" autoplay=\"autoplay\" style=\"width:100%;height:auto;z-index:10;\" controls></video>
//					</div>
//				
//				<video id=\"you1\" autoplay=\"autoplay\" style=\"width:100%;height:auto;\" controls></video>
//			</div> ";
		html+="</td>";	
	}



	html+="</tr></table></body>";

return html;

}


}