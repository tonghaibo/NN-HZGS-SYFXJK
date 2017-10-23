function x_showflg_vidcomict(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
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
	
	var unam="";
	var uimg="";
	var uguid="";

	var hernam="";
	var herimg="";
	var herguid="";
	herguid= pubpack.EAFunc.NVL( request.getParameter("herguid"),"");
	


	
	
	var scrollseq=0;  
	var BASEurl="https://sch.xmidware.com/chis/ROOT_CHIS/";
	
	var baseguid="";
	var sql="";
	var ds=null;
	var db=null;
	try{
		db = new pubpack.EADatabase();
		sql="select guid from hin_his a where a.formguid='"+userid+"'";
		ds=db.QuerySQL(sql);
		if(ds.getRowCount()!=0)
		{
			baseguid=ds.getStringAt(0,"guid");
		} 
//		sql="select * from usr where guid='"+uguid+"'";
//		
//		ds=db.QuerySQL(sql);
//		if(ds.getRowCount()!=0){
//			unam=ds.getStringAt(0,"name");
//			uimg=ds.getStringAt(0,"IMGGUID");
//			uguid=ds.getStringAt(0,"guid");
//		}
		sql="select * from usr where  guid='"+herguid+"'";
	      
		ds=db.QuerySQL(sql);
		
		
		//throw new Exception(sql);	
		if(ds.getRowCount()!=0){
			hernam=ds.getStringAt(0,"name");
			herimg=ds.getStringAt(0,"IMGGUID");
			herguid=ds.getStringAt(0,"guid");
			
	
		}
		
	}catch(e){throw new Exception(e);}
	finally{
		if(db!=null){
			db.Close();
		}
	}
	
	

//<!--//xmidware下的目录格式如下：xlsgrid/images/flash/js/jquery-1.7.2.min.js"-->    
//图片地址
var html="
	<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/chart.jquery.min.js\"></script>
	<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/chart.jquery.mobile-1.4.0-rc.1.js\"></script>
	<script type=\"text/javascript\" src='cordova.js'></script>
	<script type=\"text/javascript\" src='xlsgrid/images/flash/js/socket.io.js'></script>	

	<script>
	</script>
	<link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/css/style.css\">    
    	<link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/css/jquery.mobile.flatui.css\" />
    	<link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/css/bootstrap.min.css\">
    	
	<div id=\"loadingDiv\" style=\"position:fixed;display:none;z-index:2000;top:0px;left:0px;width:100%;height:100%;background-color:#FFFFFF\">
	<div id='noWait' height=20% style=\"filter: alpha(opacity=45); opacity:0.45; height:40px;width:100%;position:fixed;left:0px;top:0px;background-color:#2c2c2c; display\">
		<div style=\"position:fixed;top:10px;color:#ffffff;\"><a style=\"margin-left:10px;color: #ffffff;\" onclick=\"gendown()\"> 返回</a></div>
	</div>
	
	
	<iframe id=\"loadingafram\" src=\"\" width=100% height=100% frameborder=0></iframe>
	</div>
	<!----- 图片等资源的预览 ----->
	<div id=\"div_img_popup\" onclick=\"document.all('div_img_popup').style.display='none';document.all('div_img_show').style.display='none';\"  style=\"z-index:9997;position:fixed; background:rgba(0,0,0,0.6); bottom:0; top:0;left:0;right:0; display:none;\"></div>
	<div id=\"div_img_show\" onclick=\"document.all('div_img_popup').style.display='none';document.all('div_img_show').style.display='none';\" style=\"z-index:9998;position:absolute; top:0px; left:0%; width:100%; height:100%;margin-left:0px; margin-top:0px; display:none;\">
		<img class=\"big\" id=\"pupupimg\" src=\"\" style=\"z-index:9999;display:;width:; height:;top:;left:;\"/>
	</div>
	
	<table width=100% height=100% border=0>
	<tr>
	<td width=50% id=\"leftuptd\">
	<div class=\"linear-g\" style=\"height:50px; \"><table width=100% height=100% border=0> 
	<td width=20%  id='back' align=center valign=middle onclick=\" exitRoom();try{parent.f_goback();}catch(e){if(confirm('是否退出聊天界面')==1) window.close(); } \" style=\"cursor:pointer;\">
		<font color=#663300 ><span class=\"glyphicon glyphicon-chevron-left\" style=\"font-size: 15px\">退出聊天室</span></font> </td>
	</td>
	       <td align=center valign=middle id=\"myroomname\" >正在与"+hernam+"聊天</td>
	      
	</tr>
	</table></div>


<div data-role=\"page\" id=\"mainpage\" style=\"height:100%;position:relative;overflow-y: hidden;overflow-x: ;\" >
    <div data-role=\"panel\" data-position=\"left\" data-display=\"push\" class=\"list-group shortcut_menu dn linear-g\" id=\"panel-left\"  >
         <div class=\"header linear-g\">
       		<a class=\"text-center col-xs-8\">本次会诊预约的患者</a>
    </div>
</div>
    
    <div data-role=\"panel\" data-position=\"right\" data-display=\"push\" class=\"user_box text-center dn linear-g\" id=\"panel-right\" style=\"border:1px solid #F2F2F2;background:#F2F2F2\" >
    </div>
    <div id=\"mainzone\" data-role=\"content\" class=\"container\" role=\"main\" style=\"float:left;width:100%;padding-right: 0px;padding-left: 0px;margin-top:0px;margin-bottom: 70px;\" onclick=\"f_hideaddwnd();\">
    	<table border=0  cellspacing=0 cellpadding=0 style=\"width: inherit;\"><tr>
    	<td id='lefttd' width=100% height=20>
    	<table width=100% height=100%>
    		<tr>
    			<td valign=top>
    			<div id='leftdiv' style=\"float:left;width:100%;overflow:auto;padding-right:10px;padding-left:10px;\"> 
		        	<ul class=\"content-reply-box mg10\" id=\"list\">
		        	</ul>
		        </div>	
    			</td>
    		</tr>
    	</table>
    	
        </td>
	</tr>
	</table>
    </div>
<div id=\"bottomNav\" style=\"height:50px; display:block;border-top:#DFDFDF solid 1px;\">
		<table width=100% border=0 height=100%>
		<tr><td align=center valign=middle height=50>
			<table width=100% height=100%  border=0  ><tr>
			<td width=50 align=\"center\" atyle=\"cursor:point;margin-left:0\" onclick=\"javascript:f_showaddwnd();\"><font size=4><li class=\"glyphicon glyphicon-plus\"></li></font></td>
			<td ><input type=\"text\" style=\"padding-left:10px;width:100%;height:38px;border: 1px solid #dedede;-moz-border-radius: 5px;-webkit-border-radius: 5px;border-radius:5px;\" id=\"text\"/></td>
			<td width=80 id=\"send\"  style=\"cursor:pointer;\" align=center onClick=\"senMs();\"><font size=4>回复</font></td>
			</tr> 
				
			</table>	
		</td></tr>
		<tr><td>
			<table id='addwnd' width=100% height=100% style=\"border-top:1px solid #CDCDCD;display:none;\">
			<tr>
				<td width=20% align=center valign=middle><button type=\"button\" class=\"btn \" style=\"width:100%;height:60px;font-size: 12px\" onclick=\"capture(100,1,0,1920,1080,'P');\">
				  <p><font color=#003333><span class=\"glyphicon glyphicon-camera\" style=\"font-size: 24px\"></span></font></p>拍照
				</button></td>
				<td width=20% align=center valign=middle><button type=\"button\" class=\"btn \" style=\"width:100%;height:60px;font-size: 12px\" onclick=\"capture(100,1,0,-1,-1,'P');\">
				  <p><font color=#663300><span class=\"glyphicon glyphicon-film\" style=\"font-size: 24px\"></span></font></p>高清拍照
				</button></td>
				<td width=20% align=center valign=middle><button type=\"button\" class=\"btn \" style=\"width:100%;height:60px;font-size: 12px\" onclick=\"captureAudio();\">
				  <p><font color=#444477><span class=\"glyphicon glyphicon-volume-up\" style=\"font-size: 24px\"></span></font></p>录语音
				</button></td>
				<td width=20% align=center valign=middle><button type=\"button\" class=\"btn \" style=\"width:100%;height:60px;font-size: 12px\" onclick=\"capture(100,0,0,-1,-1,'')\">
				  <p><font color=#629924><span class=\"glyphicon glyphicon-picture\" style=\"font-size: 24px\"></span></font></p>相册库
				</button></td>
				<td width=20% align=center valign=middle><button type=\"button\" class=\"btn \" style=\"width:100%;height:60px;font-size: 12px\" onclick=\"capture(100,0,1,-1,-1,'P');\">
				  <p><font color=#884400><span class=\"glyphicon glyphicon-eye-open\" style=\"font-size: 24px\"></span></font></p>拍视频
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
  
  
</td> 
	</tr></table>
		<script>
			var myimage = document.getElementById('pupupimg');
			if (myimage.addEventListener) {   
				// IE9, Chrome, Safari, Opera   
				myimage.addEventListener('mousewheel', MouseWheelHandler, false);   
				// Firefox   
				myimage.addEventListener('DOMMouseScroll', MouseWheelHandler, false);   
			} else myimage.attachEvent('onmousewheel', MouseWheelHandler);
			
			function MouseWheelHandler(e) {   
				// cross-browser wheel delta   
				var e = window.event || e; // old IE support   
				var delta = Math.max(-1, Math.min(1, (e.wheelDelta || -e.detail)));
			  
				return false;   
			}
			

var scrollseq=0;  


function appendMessage(msg,usrnam,usrimg,leftorright) {	// 我发出的
				scrollseq  ++;
				var rightorleft = 'right'; 
				if (leftorright=='right') rightorleft = 'left';
				var d = new Date();
				var tim=d.getFullYear()+\"-\"+d.getMonth()+\"-\"+d.getDate()+\" \"+d.getHours()+\":\"+d.getMinutes()+\":\"+d.getSeconds();
				var str = \"\";
				var bkcolor=\"\";
				var arrawcolor = \"\";
				if(leftorright=='right'){
					bkcolor='#FFE4C7';
					arrawcolor='border-color: transparent transparent transparent #FFE4C7;';
					str='<table border=0 id=\"msg-'+scrollseq  +'\" width=100%><tr><td valign=top>';
					str=str+'<div class=\"reply-content-box\" align=lef style=\"float:'+leftorright+';margin:2px;\">';
					str=str+'<span class=\"reply-time\">'+tim+'</span>';
					str=str+'<div   style=\"background-color:'+bkcolor+';padding: .8em;border-radius: 5px;position:relative;\" >';
					str=str+'<span class=\"arrow\" style=\"'+arrawcolor+'z-index:1;position: absolute;top: 8px;right: -12px;border-style: dashed dashed dashed solid;border-width: 6px;\">';
					str=str+'</span><font size=\"4\">';
					str=str+msg;
					str=str+'</font></div>';
					str=str+'  </div>';
					str=str+'</td><td width=60 valign=top align=center>';
					str=str+'<a class=user href=>';
					str=str+'<img class=img-responsive avatar_ src="+BASEurl+"EAFormBlob.sp?guid='+usrimg+' width=50 height=50></a>';
					
					str=str+'<span class=\"user-name\" style=\"width:60px;\">'+usrnam+'</span>';
					str=str+'</a>';
					str=str+'</td>';
				}
				else {
					bkcolor='#BCE1FB';
					arrawcolor='border-color: transparent #BCE1FB transparent transparent;';
					str='<table border=0 id=\"msg-'+scrollseq  +'\" width=100%><tr><td valign=top width=60 align=center>';
					
					str=str+'<a class=user href=>';
					str=str+'<img class=img-responsive avatar_ src="+BASEurl+"EAFormBlob.sp?guid='+usrimg+' width=50 height=50 >';
					str=str+'<span class=user-name style=\"width:60px;\">'+usrnam+'</span>';
					str=str+'</a>';
					str=str+'</td><td  valign=top >';
					str=str+'<div class=\"reply-content-box\" align=lef style=\"float:'+leftorright+';margin:2px;\">';
					str=str+'<span class=\"reply-time\">'+tim+'</span>';
					str=str+'<div   style=\"background-color:'+bkcolor+';padding: .8em;border-radius: 5px;position:relative;\" >';
					//str=str+'<span class=\"arrow\" style=\"z-index:1;position: absolute;top: 8px;left: -12px;border-style: dashed solid dashed dashed;border-width: 6px;\">
					str=str+'</span><font size=\"4\">';
					str=str+msg;
					str=str+' </font></div>';
					str=str+'  </div>';
					str=str+\"</td>\";				
				}
				str=str+'</tr></table>';
				document.getElementById(\"list\").innerHTML=document.getElementById(\"list\").innerHTML+str;
				$('#leftdiv').scrollTop(9999999);
			}
		
		//开始连接
		var iosocket = io.connect('https://sch.xmidware.com:9001');
		//alert(G_APP_USRGUID)
		//G_APP_USRNAM,
		//G_APP_USRIMG
			
			
			
			
		iosocket.emit('login', G_APP_USRGUID);
		appendMessage('您已经进入聊天室',G_APP_USRNAM,G_APP_USRIMG,'right');
		function senMs(){
			var value  =document.getElementById(\"text\").value;
			if(value!='') {	
				var usr = {
                			name:G_APP_USRNAM,
                			img:G_APP_USRIMG,
                			val:value  
                		};
                		
				iosocket.emit('sendMessage',usr,G_APP_USRGUID,{type: 'speak'});
				//appendMessage(value,'"+unam+"','"+uimg+"','right');
			}
			document.getElementById(\"text\").value=\"\";
		}
		 document.onkeydown=function(event) { 
			
			 if(event.keyCode==13) { 
			 	senMs();
			 }
		 }
		 
		//G_APP_USRNAM,
		//G_APP_USRIMG
		  iosocket.on('messageReceived', function(name,str,message){
			 	switch (message.type){
		 		    case 'speak':
		                	if(str == G_APP_USRGUID) {
		                		appendMessage(name.val,name.name,name.img,'right');
		                	}
		                	
		                	
		                	else {
		                		appendMessage(name.val,name.name,name.img,'left');
		                	}

		                	break;
				}
		});
		 
		
		</script>
	</body>";

return html;

}



}