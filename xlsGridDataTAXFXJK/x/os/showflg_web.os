function x_showflg_web(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var web = new JavaPackage ( "com.xlsgrid.net.web" );
//
// ����۵��Ķ�ҳǩWEBҳ�沼��
//
function WebFrame()
{

	//var doc_id = pubpack.EAFunc.NVL(request.getParameter("doc_id"),"");
	var db = null;
	var ret = "";
	try {
		// OS ����εõ���¼����Ϣ
		var usr=web.EASession.GetLoginInfo(request);
		
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		// ����
		if(titleheight==null||titleheight=="")titleheight="60";
		if(pagebarheight==null||pagebarheight=="")pagebarheight="30";
		//pagebarheight = "0";
		
		if(titile==null||titile=="")titile=usr.getSytnam();
		if(titlefontcolor==null||titlefontcolor=="")titlefontcolor="#111";
		if(titlefontsize==null||titlefontsize=="")titlefontsize="30px";
		if(subtitlefontcolor==null||subtitlefontcolor=="")subtitlefontcolor="#333";
		if(subtitlefontsize==null||subtitlefontsize=="")subtitlefontsize="12px";
		
		if(leftmenuwidth==null||leftmenuwidth=="")leftmenuwidth="220";
		if(leftmenubkcolor==null||leftmenubkcolor=="")leftmenubkcolor="#3992d0";
		if(leftmenuselcolor==null||leftmenuselcolor=="")leftmenuselcolor="#317eb4";
		if(leftmenufontcolor==null||leftmenufontcolor=="")leftmenufontcolor="#FFFFFF";
		
		if ( subsytid.length() > 0 ) subsytid = "-"+subsytid+"-";
		
		
		ret+="<script>// ����ȫ��
				window.onresize=function(event){
					_resizeheight();
				}
				window.onload=function()
				{
					_resizeheight();
				}
				function _resizeheight()
				{
					//alert ( $(window).height()-"+titleheight+" );
					document.all('lefttd').height=$(window).height()-"+titleheight+";
					
					document.all('righttd').width=''+$(window).width()-"+leftmenuwidth+"+'px';
					document.all('righttd1').width=''+$(window).width()-"+leftmenuwidth+"+'px';

					document.all('mainframe').height=$(window).height()-"+titleheight+"-"+pagebarheight+"-21;
				}
				function openurl(name,url){
					document.all('mainframe').src=url;
				}
			</script>
			<table width=100% height=100% cellspacing=0 cellpadding=0 border=0 style=\"width:100%;height:100%;\">
			<tr><td height=\""+titleheight+"px\" colspan=2>
			     <div style=\"background: url("+titlebkimgsrc+") repeat-x;width:100%;height:"+titleheight+"px;align:left:valign:middle;\">
			
				<div style=\"align:left:valign:middle;float:left;\">
					<img style=\"margin: 5px 50px; 0 50px;\" src=\""+titleimgsrc+"\">
					<span style=\"font-family: ΢���ź�;font-size:"+titlefontsize+";position: relative; font-weight: bold; top:5px; color:"+titlefontcolor+"\">"+titile+"</span>		
				</div>
	            		<div style=\"float:right;align:right;valign:middle;margin: 15px 10px 0 0;\">
					<div style=\"color:"+titlefontcolor+";font-size:"+subtitlefontsize+";\">��ӭ�㣬&nbsp;"+usr.getUsrnam()+"</div>
					<div style=\"color:"+titlefontcolor+";font-size:"+subtitlefontsize+";\">"+usr.getOrgnam()+"&nbsp;"+pubpack.EAFunc.NVL(usr.getDeptNam(),"")+"</div>
					<div style=\"color:"+titlefontcolor+";font-size:"+subtitlefontsize+";\">��½���ڣ�"+usr.getLogdat()+"</div>
				</div>
		             </div>
		     	</td></tr>
		     	<tr><td id=\"lefttd\" valign=top align=left width=\""+leftmenuwidth+"px\" height=\"100%\" rowspan=\"2\" style=\"border-right: 1px solid #b8b8b8;\">
		     		<!--�˵���-->				
					<div class=\"sidebar\" align=\"left\" style=\"width:220px;\"> 					
						<!--�û���Ϣ��-->
						
						<div style=\" background-color:#3992d0; height: 60px;border-top: 1px solid #3992d0;border-bottom: 1px solid #317eb4;\">
							<img style=\"float: left;margin: 4px 10px 0 8px;\" src=\"EAFormBlob.sp?guid=13E27FE3240AF2A5E050007F01002FDB\" width=\"51\" height=\"51\" alt=\"\">
							<p style=\"float:left;width: 125px;margin-top: 10px;\">
								<span style=\"color: #666;\"><strong><font color=#CDCDCD>��ã�"+usr.getUsrnam()+"</font></strong></span><br>
								<span><a href=\"../xlsgrid/jsp/pages/chgpassnew.jsp?flag=USR&grdid=PASSWD\" target=_blank ><font color=#FCFCFC>�޸�����</font></a>&nbsp;<a class=\"login-out\" href=\"../index.jsp\" target=\"_top\"><font color=#FCFCFC>ע��</font></a></span>
							</p>
						</div>
						
						<!--��Ҷ��-->
						<!--
						<div style=\"background-image:url(EAFormBlob.sp?guid=142ADF46208E3FB8E050007F01001824)\">
							<table border=0 width=200 cellpadding=0 cellspace=0>
							<tr>
							<td width=50%><a href=\"#\" onclick=\"openurl('','ROOT_XLSGRID/EntryCloud.jsp?menu=MENU&usrid=xlsgrid&userpwd=0');\"><img border=0 src='EAFormBlob.sp?guid=142A3657422DCB07E050007F01007DE2' style=\"height:auto;\"></a>
							<a href=\"#\" onclick=\"openurl('','ROOT_XLSGRID/EntryCloud.jsp?menu=MENU&usrid=xlsgrid&userpwd=0');\"><img border=0 src='EAFormBlob.sp?guid=142A36574235CB07E050007F01007DE2' style=\"height:auto;position:absolute;left:55px;top:120px;\"></a>
							</td>
							<td width=50%><a href=\"#\" onclick=\"openurl('','ROOT_XLSGRID/EntryCloud.jsp?menu=MENU&usrid=xlsgrid&userpwd=0');\"><img border=0 src='EAFormBlob.sp?guid=142A3657422FCB07E050007F01007DE2' style=\"height:auto;\"></a></td>
							</tr>
							<tr>
							<td width=50%><a href=\"#\" onclick=\"openurl('','ROOT_XLSGRID/EntryCloud.jsp?menu=MENU&usrid=xlsgrid&userpwd=0');\"><img border=0 src='EAFormBlob.sp?guid=142A36574231CB07E050007F01007DE2' style=\"height:auto;\"></a></td>
							<td width=50%><a href=\"#\" onclick=\"openurl('','ROOT_XLSGRID/EntryCloud.jsp?menu=MENU&usrid=xlsgrid&userpwd=0');\"><img border=0 src='EAFormBlob.sp?guid=142A36574233CB07E050007F01007DE2' style=\"height:auto;\"></a></td>
							</tr>
							</table>
							
						</div> 		
						-->				
						";
		ret+=_GetLeftMenu(request,leftmenuwidth,leftmenubkcolor,leftmenuselcolor,leftmenufontcolor);
		ret+="	</td>
			<td id=\"righttd\" height=\""+pagebarheight+"px\" width=\"80%\" valign=\"top\" align=left style=\"border-bottom: 1px solid #b8b8b8;\">
				<!--��ҳ����-->
			
			</td><tr>
			<td id=\"righttd1\" valign=\"top\" align=left>
				<!--����������ʾ��-->
				<div id=\"div_div_mainframe\" style=\"margin-top:10px; margin-bottom:10px; margin-left:10px;margin-right:10px;\">

					<div id=\"div_mainframe\" style=\" box-shadow: 0 0 8px #666;\">
						
						<iframe height=100% width=100% id=\"mainframe\" src=\""+defaultpageurl+"\" frameborder=\"0\" name=\"main\"  border=\"0\">
							
						</iframe>
						
					</div>

				</div>
			</td>			
		     	</tr></table>
		     ";	
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return ret ;

}




//
// ��ߵĲ˵�
//
function GetLeftMenu()
{
	return  _GetLeftMenu(request,leftmenuwidth,leftmenubkcolor,leftmenuselcolor,leftmenufontcolor);

}
function _GetLeftMenu(request,leftmenuwidth,leftmenubkcolor,leftmenuselcolor,leftmenufontcolor)
{
		var ret = "";

		// OS ����εõ���¼����Ϣ
		var usr=web.EASession.GetLoginInfo(request);
		
		if(leftmenuwidth==null||leftmenuwidth=="")leftmenuwidth="220";
		if(leftmenubkcolor==null||leftmenubkcolor=="")leftmenubkcolor="#3992d0";
		if(leftmenuselcolor==null||leftmenuselcolor=="")leftmenuselcolor="#317eb4";
		if(leftmenufontcolor==null||leftmenufontcolor=="")leftmenufontcolor="#FFFFFF";
		
		if ( subsytid.length() > 0 ) subsytid = "-"+subsytid+"-";
		
		
		ret+="<!--�˵���-->				
			<div class=\"sidebar\" > 					
							
				<!--���˵�menu-wrap-->
				<div class=\"user\" > 
						<style type=\"text/css\">
						dl,dt,dd{display:block;margin:0;}
						a{text-decoration:none;}
						
						#bg{background-image:url(images/content/dotted.png);}
						.container2{width:100%;height:100%;margin:auto;}
						
						/*left*/
						.leftsidebar_box{width:"+leftmenuwidth+"px;height:auto !important;overflow:visible !important;position:fixed;height:100% !important;background-color:"+leftmenubkcolor+";}
						.leftsidebar_box dt{padding-left:10px;padding-right:10px;background-repeat:no-repeat;background-position:10px center;font-size:14px;font-color:#FFFFFF;position:relative;line-height:35px;cursor:pointer;}
						.leftsidebar_box dd{background-color:#317eb4;padding-left:40px;font-size:14px;font-color:#FFFFFF;height:30px;}
						.leftsidebar_box dd a{color:#f5f5f5;line-height:20px;font-size:14px;font-color:#FFFFFF;}
						//.leftsidebar_box dt img{position:absolute;right:10px;top:20px;}
						.leftsidebar_box dl dd:last-child{padding-bottom:10px;}
						</style>
						<div class=\"container2\">
					
						<div class=\"leftsidebar_box\">

			";
			
			
			// ��ȡ�����������Ӳ˵�
			var sytid = usr.getSytid();
			var ds = xmlpack.EAXmlDB.getSubSytDB(sytid);
//			throw new pubpack.EAException ( ds.GetXml());
			var num = 0;
			for( var i=0;i<ds.getRowCount();i++){
			
				
				var sytType = ds.getStringAt(i,"TYP");
		            	var order  = ds.getStringAt(i,"order");
		            	var sUrl = ds.getStringAt(i,"URL");
		            	var sIcon = ds.getStringAt(i,"ICON");
		            	if(sIcon == "" ) sIcon = "xlsgrid/images/flash/appicon/icon_123.png";
		            	var sGotoUrl = ds.getStringDef(i,"GOTO","");
		            	if (subsytid.length()>0 &&  subsytid.indexOf ( "-"+ ds.getStringAt(i,"SUBID")+"-") < 0 ){
		            		
		            	}
		            	else {
			            	num++;
			            	
			            	if( sUrl.startsWith("../") ) sUrl = sUrl.substring(3);
			            	if (order=="0" ) {
			            		if(num!=1)
			            			ret+="</dl>";
			            		//ret += "<dl ><dt onClick=\"changeImage()\" ><img border=0 src=\""+sIcon+"\" width=30 height=30 style=\"position:absolute;left:10px;top:10px;\"><font size=2 color="+leftmenufontcolor+" >"+ds.getStringAt(i,"NAME")+"</font><img src=\"xlsgrid/images/arrow_white_right.png\"></dt>";
			            		ret += "<dl ><dt onClick=\"changeImage()\" ><table width=100% height=\"10px\" ><tr><td width=30 align=center valign=middle><img border=0 src=\""+sIcon+"\" width=30 height=20 ></td><td align=left valign=middle>";
			            		if(sGotoUrl != "")
			            			ret += 	"<a href=\"#\" onclick=\"openurl('','"+sGotoUrl+"');\">";
						ret += "<font size=3 color="+leftmenufontcolor+" >"+ds.getStringAt(i,"NAME")+"</font>";
						if(sGotoUrl != "")
			            			ret += 	"</a>";
						ret += "</td><td align=right valign=middle><img src=\"xlsgrid/images/arrow_white_right.png\">&nbsp;&nbsp;</td></tr></table></dt>";
	
					}
					else if(order=="1"){
						ret += "<dd class=\"first_dd\"><a href=\"#\" onclick=\"openurl('','"+sUrl+"');\"><font size=2 color="+leftmenufontcolor+">"+ds.getStringAt(i,"NAME")+"</font></a></dd>";
					}
					else 
						ret += "<dd><a href=\"#\" onclick=\"openurl('','"+sUrl+"');\"><font size=2 color="+leftmenufontcolor+">"+ds.getStringAt(i,"NAME")+"</font></a></dd>";
				}
			}
			if(num!=0) ret+="</dl>";
			
			
			ret +="						
						</div>
					
					</div>
					
					<script type=\"text/javascript\" src=\"js/jquery.js\"></script>
					<script type=\"text/javascript\">
					$(\".leftsidebar_box dt\").css({\"background-color\":\""+leftmenuwidth+"\"});
					$(\".leftsidebar_box dt\").css({\"background-color\":\""+leftmenubkcolor+"\"})
	
					
					//$(\".leftsidebar_box dt img\").attr(\"src\",\"xlsgrid/images/arrow_white_right.png\");
					$(function(){
						$(\".leftsidebar_box dd\").hide();
						$(\".leftsidebar_box dt\").click(function(){
									$(\".leftsidebar_box dt\").css({\"background-color\":\""+leftmenubkcolor+"\"})
									$(this).css({\"background-color\": \""+leftmenuselcolor+"\"});
							$(this).parent().find('dd').removeClass(\"menu_chioce\");
							//$(\".leftsidebar_box dt img\").attr(\"src\",\"xlsgrid/images/arrow_white_right.png\");
							//$(this).parent().find('img').attr(\"src\",\"xlsgrid/images/arrow_white_down.png\");
							$(\".menu_chioce\").slideUp(); 
							$(this).parent().find('dd').slideToggle();
							$(this).parent().find('dd').addClass(\"menu_chioce\");
						});
					})
					</script>
				</div>
			</div>
					
			";		     
	return ret ;
}



//
// ��½ҳ��
// TITLEIMG: EAFormBlob.sp?guid=165708C479077819E050007F010064A3
// REGISTERPAGE xlsgrid/loginregister.jsp
// openmode=autologin �Զ���½ openmode=entrypassword ��Ҫ��������(Ĭ��)
function GetWebLogin()
{
	var textustnam="�û���";
	var textpwdnam="���룺";
	var usrplaceholder="�����������û�����";
	var pwdplaceholder="�����������û����룡";
        if(CALLJSFUNC==null||CALLJSFUNC==""||CALLJSFUNC=="null") CALLJSFUNC = "noexist";
        if(ROOTACC==null||ROOTACC==""||ROOTACC=="null") ROOTACC="";
        if(IFLOGINBARCODE==null||IFLOGINBARCODE==""||IFLOGINBARCODE=="null") IFLOGINBARCODE="";
	var divheight = "410";
	if(RELOGINLOCAL==null||RELOGINLOCAL==""||RELOGINLOCAL=="null") RELOGINLOCAL="";
	else divheight = "420";
		
	var html = "<!-- CSS -->
	        <link rel=\"stylesheet\" href=\"xlsgrid/images/flash/css/reset.css\">
	        <link rel=\"stylesheet\" href=\"xlsgrid/images/flash/css/supersized.css\">
	        <link rel=\"stylesheet\" href=\"xlsgrid/images/flash/css/logstyle.css\">
	        <div class=\"page-container\" id=\"container\" style=\"background-color:#EEEEEE;filter:alpha(opacity=90); -moz-opacity:0.9; opacity:0.9;width:600px;height:"+divheight+"px; border: 1px solid #EFEFEF;-moz-border-radius: 3px; -webkit-border-radius: 3px;   border-radius:3px; \">
        ";
        var tdwidth=80;
        if(IFTEXTVISI=="false"){ textustnam=""; textpwdnam="";tdwidth=40;}
        

        
        if(TS_USERNAM!="") usrplaceholder=TS_USERNAM;
        if(TS_PWD!="") pwdplaceholder=TS_PWD;
	
        if(GOTOPAGE==null|| GOTOPAGE=="" || GOTOPAGE=="Login.sp"  ) {
        	html+="
	             <form id=\"f_login\" action=\"Login.sp\" method=\"post\" style=\"width:100%;\"><H1><img src=\""+TITLEIMG+"\" id=\"titleimg\" tyle=\"width:;height:auto;\"></H1>
	               	<table width=100%> ";
//		if(IFLOGINBARCODE=="1"||IFLOGINBARCODE=="true") {
//			html+="<tr>
//	               		<td align=right width="+tdwidth+"><p><font color=\"#333333\">���룺</font></td>
//	               		<td><input type=\"text\" name=\"usrbarcode\" class=\"username\" placeholder=\"ͨ����¼�������ֱ�ӵ�¼��\" style=\"background-color:#FFFFFF;font-size:18px;color:#222222;padding-left:5px;margin:5px;height:30px;\"></p></td>
//	               	</tr>";
//	        }
	             
	        html+="
		        <tr>
	               		<td align=right width="+tdwidth+"><p><font color=\"#333333\">"+textustnam+"</font></td>
	               		<td>
	               		
	               		<input type=\"text\" name=\"usrid\" class=\"username\" placeholder=\""+usrplaceholder+"\" style=\"background-color:#FFFFFF;font-size:18px;color:#222222;padding-left:5px;margin:5px;height:30px;\"></p></td>
	               	</tr>
	               	
	                <tr>
	               		<td align=right><p><font color=\"#333333\">"+textpwdnam+"</font></td>
			 	<td><input type=\"password\" name=\"userpwd\" class=\"password\" placeholder=\""+pwdplaceholder+"\" style=\"background-color:#FFFFFF;padding-left:5px;color:#222222;height:30px;\"></p></td>

			</tr>
			<tr>
				<td></td>
				<td align=center onclick=\"javascript:alert('�����Աȡ����ϵ��')\"><br>&nbsp;<a><font color=\"#3232cd\">��������?</font></a></td>
			</tr>
	               <tr>
	               		<td></td><td align=center> <button id=\"com_ok\" type=\"submit\" class=\"submit_button\" style=\"font-family:΢���ź�;\">&nbsp;��¼</button>";
	        if(  REGISTERPAGE!="" &&REGISTERPAGE!=null)    
			html+="	<button type=\"button\" class=\"submit_button\" onclick=\"javascript:window.location.href='"+REGISTERPAGE+"'\" style=\"font-family:΢���ź�;\">ע��</button>";
	        html+="</td></tr>";
	        html+="</table></form> ";
	}
	else {	// �ű���½����ת
		html+="	<h1><img src=\""+TITLEIMG+"\" tyle=\"width:;height:auto;\" id=\"titleimg\" ></h1> ";
		if (IFLOGINBARCODE=="1"||IFLOGINBARCODE=="true") {
			html+="<div id=\"mode_code\" >
			       <p><font color=\"#333333\">���룺</font> <input type=\"text\" name=\"usrbarcode\" class=\"username\" placeholder=\"ɨ���������ֱ�ӵ�¼��\" style=\"background-color:#FFFFFF;color:#222222;padding-left:5px;height:30px;\"></p>
			       <br>
			       <p style=\"color:#333333;font-size:26px;\"><span class=\"glyphicon glyphicon-user\" onclick=\"javascript:document.all('mode_code').style.display='none';document.all('mode_user').style.display='';\"></span></p>
			       </div>
			       <div id=\"mode_user\" style=\"display:none; \" >
			       <p><font color=\"#333333\">�û���</font> <input type=\"text\" name=\"usrid\" class=\"username\" placeholder=\"�����������û�����\" style=\"background-color:#FFFFFF;padding-left:5px;color:#222222;height:30px;\"></p>
		               <p><font color=\"#333333\">���룺</font> <input type=\"password\" name=\"userpwd\" class=\"password\" placeholder=\"�����������û����룡\" style=\"background-color:#FFFFFF;padding-left:5px;color:#222222;height:30px;\"></p>
		               <br>
			       <p style=\"color:#333333;font-size:26px;\"><span class=\"glyphicon glyphicon-barcode\" onclick=\"javascript:document.all('mode_code').style.display='';document.all('mode_user').style.display='none';document.all('usrbarcode').focus();\"></span></p>
		               </div>";
	        } else {	         
		        html+="<p><font color=\"#333333\">�û���</font> <input type=\"text\" name=\"usrid\" class=\"username\" placeholder=\"�����������û�����\" style=\"background-color:#FFFFFF;padding-left:5px;color:#222222;height:30px;\"></p>
		               <p><font color=\"#333333\">���룺</font> <input type=\"password\" name=\"userpwd\" class=\"password\" placeholder=\"�����������û����룡\" style=\"background-color:#FFFFFF;padding-left:5px;color:#222222;height:30px;\"></p>";
	        }
	        html+="&nbsp;<button id=\"com_ok\" onclick=\"javascript:xmidware_login();\" type=\"submit\" class=\"submit_button\" style=\"font-family:΢���ź�;\">&nbsp;��¼</button>";
	        if (REGISTERPAGE!=""&&REGISTERPAGE!=null ) {
			html+="&nbsp;<button type=\"button\" class=\"submit_button\" onclick=\"javascript:window.location.href='"+REGISTERPAGE+"'\" style=\"font-family:΢���ź�;\">&nbsp;ע��</button>";
	        }
	        html+="<div id='txt_log' style=\"margin:15px;align:left;\"></div>";
	}

	html+="
        </div>
        <!-- Javascript -->
        <script>
        		var ROOTACC = '"+ROOTACC+"';
        		var MAINURL = '"+GOTOPAGE+"';
        		function xmidware_goto(){
        			var winlocation = ''+ window.location;
               			if (winlocation .indexOf('http') == 0) {	//����ģʽ
        				if (winlocation .indexOf('ROOT_') != -1) window.location = MAINURL;
        				else window.location = 'ROOT_'+ROOTACC+'/'+MAINURL;
        			} else {
        				if (MAINURL.indexOf('L.sp?') == 0) {
						var str = MAINURL.substring(MAINURL.indexOf('id=')+3);
						var end = str.indexOf('&');
						var _id = '';
						
						if (end == -1) _id = str;
						else _id = str.substring(0,end);
						
						MAINURL = MAINURL.replace('L.sp?',_id+'.html?');
					}
        				
        				window.location = MAINURL;
        			}
        		}
	        	function xmidware_login(){
	        		
	        		if( '"+CALLJSFUNC+"'!='noexist'){
	        			var retval = "+CALLJSFUNC+"();
	        			var ss = retval.split('~');// �ɹ���־~��ʾ��Ϣ~�û����~�û�����~�û�GUID~�û�IMGGUID
	        			if( ss.length()>=6&&ss[0]=='1' ) {
	        				try{
        						window.localStorage.setItem('XMIDWARE_APP_USRID',document.all('usrid').value);
							window.localStorage.setItem('XMIDWARE_APP_USERPWD',document.all('userpwd').value);
							window.localStorage.setItem('XMIDWARE_APP_USRNAM',ss[4]);

							window.localStorage.setItem('XMIDWARE_APP_USRGUID',ss[5]);
							window.localStorage.setItem('XMIDWARE_APP_USRIMG',ss[6]);
						}catch(e){}
        					window.location = \""+GOTOPAGE+"\";

	        			}
	        		}
	        		else {
		        		document.all('txt_log').innerHTML='<font color=#444444>��¼��...</font>';
		        		// ����Ҫ��xϵͳ����RLogin�м��
		        		<!--Login.sp?sytid=x&accid=0 -->
		        		
		        		var usrbarcode = '';try{usrbarcode=document.all('usrbarcode').value;document.all('usrbarcode').value='';}catch(e){}
		  			
//		     	        	$.get(\"rlogin.jsp?sytid=x&accid=0&usrid=\"+document.all('usrid').value+\"&userpwd=\"+document.all('userpwd').value+\"&usrbarcode=\"+usrbarcode, function(result){	
//		     	  		     	result = result.trim();
		     	  		$.ajax({
		     	  			url: ''+G_WEBBASE+'/rlogin.jsp?sytid=x&accid=0&usrid='+document.all('usrid').value+'&userpwd='+document.all('userpwd').value+'&usrbarcode='+usrbarcode,
						type: 'GET',
						dataType: 'text',
						timeout: 3000,
						error: function(XMLHttpRequest, textStatus, errorThrown) {
							document.all('txt_log').innerHTML='<br><font color=#FF0000>�����쳣��<a href=\"javascript:window.close();\">�˳�ϵͳ</a></font>';
						},
						success: function(result) {
			        			if(result.indexOf('��������,���¼������Ϣ,��ϵ�����̡�')>0){
			        				var pos1 = result.indexOf('<pre>');
			        				var pos2 = result.indexOf('</pre>');
								document.all('txt_log').innerHTML='<font color=#444444>'+result.substring(pos1+5,pos2)+'</font>';
			        			}
			        			else if(result.substring(0,5)=='~<?xml'){
			        				var pos1 = result.indexOf('<TOPIC>');
			        				var pos2 = result.indexOf('</TOPIC>');
								document.all('txt_log').innerHTML='<font color=#444444>'+result.substring(pos1+7,pos2)+'</font>';
			        			}
			        			else {	// ��login�ķ�����Ϣ��  �ɹ���־~��ʾ��Ϣ~�û����~�û�����~�û�GUID~�û�IMGGUID~��ת��ҳ��
			        				// 0~��¼�ɹ�~xlsgrid~0~����Ա~BE34D90B76D2450AA67B6B66D6953FF2~16BE57BE7AC806DEE050007F01005DFF~
			        				var ss = result.split('~');
			        				if(ss.length>6){
			        					//document.all('txt_log').innerHTML='<font color=#444444>'+ss[1] +'</font>';
			        					if(ss[6]!='')GOTOPAGE = ss[6];
			        					var retnum = -1;
			        					try{retnum=1*ss[0];}catch(e){}
			        					if(retnum==0) {
			        						var rootacc = '';
			        						
			        						try{
			        							window.localStorage.setItem('XMIDWARE_APP_USRID',ss[2]);
											window.localStorage.setItem('XMIDWARE_APP_USERPWD',ss[3]);
											window.localStorage.setItem('XMIDWARE_APP_USRNAM',ss[4]);
											
											window.localStorage.setItem('XMIDWARE_APP_USRGUID',ss[5]);
											window.localStorage.setItem('XMIDWARE_APP_USRIMG',ss[6]);
											window.localStorage.setItem('XMIDWARE_APP_USRORG',ss[7]);
											
											if ('"+ROOTACC+"' == '') {	// ���û��ǿ������ROOTACC����
												ROOTACC = ss[8].trim();
											}
											if (ss[9].trim() != '') {	// ����û����õ�¼��ҳMAINURL
												MAINURL = ss[9].trim();
											}
											
											// rootacc = ss[8];
										} catch(e) { }
										
										window.localStorage.setItem('XMIDWARE_APP_ACCID',ROOTACC);
										window.localStorage.setItem('XMIDWARE_APP_MAINURL',MAINURL);
										
										xmidware_goto();
									}
									var url = window.location;
			        				}
			        				else if(ss.length>1){
			        					document.all('txt_log').innerHTML='<font color=#444444>'+ss[1]+'</font>';
			        					try {
			        						if (usrbarcode != \"\") {
				        						document.all('mode_code').style.display='';
				        						document.all('mode_user').style.display='none';
				        						document.all('usrbarcode').focus();
			        						}
			        						alertaudio(\"EAFormBlob.sp?guid=1D04644E3B8454E6E050007F01005C82\");
			        					} catch (e) { }
			        				}
			        				else document.all('txt_log').innerHTML='<font color=#444444>'+result+'</font>';
			        			}
		        			}
					});
				}
	        	}
	        	$(document).ready(function(){
			  	
				if(G_APP_USRID!='') document.all('usrid').value =G_APP_USRID;
				var openmode = GetLocationParam('openmode');//openmode=autologin �Զ���½ 
				if(openmode == 'autologin'&&G_APP_USERPWD!=''){
					if('"+RELOGINLOCAL+"'=='1'){//�������Ϊ1����ôopenmode=autologin����Ҫȥ���������֤
						ROOTACC = G_APP_ACCID;
						MAINURL = window.localStorage.getItem('XMIDWARE_APP_MAINURL');
						
						xmidware_goto();
					}
					else{
						document.all('userpwd').value = G_APP_USERPWD;
						
						try{f_login.submit();}catch(e){ xmidware_login() ;}
					}
				}
				_resizeheight(); ";
				if(IFLOGINBARCODE=="1"||IFLOGINBARCODE=="true")
					html+=" document.all('usrbarcode').focus();";

			html+="
			});
			window.onresize=function()
			{
				_resizeheight();
			}
			function _resizeheight()
			{
				var imgwidth = document.all('titleimg').clientWidth;
				if(imgwidth == 0 ) imgwidth = '600';
				
				var imgw = document.all('titleimg').style.width;	
				

				if($(window).width()<600){
					document.all('container').style.width = ''+$(window).width()*0.9+'px';
					document.all('usrid').style.width = ''+$(window).width()*0.5+'px';
					

					document.all('userpwd').style.width = ''+$(window).width()*0.5+'px';
					
					document.all('titleimg').style.width=($(window).width()*0.9-3)+'px';
					try{document.all('usrbarcode').style.width = ''+$(window).width()*0.5+'px';}catch(e){}
//					if(imgwidth>$(window).width()*0.9){
//						document.all('titleimg').style.width=($(window).width()*0.9-1)+'px';
//					}

				}
				else  {
					document.all('container').style.width = '600px';
					document.all('usrid').style.width = '300px';
					try{document.all('usrbarcode').style.width = '300px';}catch(e){}
					document.all('userpwd').style.width = '300px';
				}
				//if($(window).width()<$(window).height())//����
				//	document.all('container').style.margin = ''+($(window).height() - 400)/30+'px auto 0 auto'
				//else
					document.all('container').style.margin = ''+($(window).height() - 400)/3+'px auto 0 auto'
				
			}
			function openurl(name,url){
				document.all('mainframe').src=url;
			}
			function keysubmit(evt){ 
			 try {
			   if(evt.keyCode=='13'){ 
			   	if(evt.srcElement.name=='usrbarcode'){try{xmidware_login();}catch(e){f_login.submit();}}
			     else if ( document.all('usrid').value =='' ) document.all('usrid').focus(); 
			     else if ( document.all('userpwd').value =='' ) document.all('userpwd').focus(); 
			     else {try{xmidware_login();}catch(e){f_login.submit();} }
			   }
			 }catch(e){}}
	</script>
	<script src=\"xlsgrid/images/flash/js/supersized.3.2.7.min.js\" ></script>
        <script>
        	jQuery(function($){
			$.supersized({
			
			        // ����
			        slide_interval     : 4000,    // ת��֮��ĳ���
			        transition         : 1,    // 0 - �ޣ�1 - ���뵭����2 - ��������3 - �������ң�4 - ���ף�5 - ��������6 - ��תľ���Ҽ���7 - ����תľ��
			        transition_speed   : 1000,    // ת���ٶ�
			        performance        : 1,    // 0 - ������1 - ����ٶ�/������2 - ���ŵ�ͼ�����������ŵ�ת���ٶ�//���������ڻ��/ IE�������������Webkit�ģ�
			
			        // ��С��λ��
			        min_width          : 0,    // ��С�����ȣ�������Ϊ��λ��
			        min_height         : 0,    // ��С����߶ȣ�������Ϊ��λ��
			        vertical_center    : 1,    // ��ֱ���б���
			        horizontal_center  : 1,    // ˮƽ���ĵı���
			        fit_always         : 0,    // ͼ������ᳬ��������Ŀ�Ȼ�߶ȣ����Է��ӡ��ߴ磩
			        fit_portrait       : 1,    // ����ͼ�񽫲�����������߶�
			        fit_landscape      : 0,    // ���۵�ͼ�񽫲�������ȵ������
			
			        // ���
			        slide_links        : 'blank',    // ���𻷽�Ϊÿ�Żõ�Ƭ��ѡ��ٵģ�'��'��'��'��'��'��
			        slides             : [    // �õ�ƬӰ��
			                                 {image : '"+BKIMG1+"'},
			                                 {image : '"+BKIMG2+"'},
			                                 {image : '"+BKIMG3+"'}
			                       ]
			
			});
		});
		
	</script>
        <script src=\"xlsgrid/images/flash/js/logscripts.js\" ></script>
        ";
        return html;
}

//����֯�����׵�¼
function GetWebMutiLogin()
{
	var html = "<!-- CSS -->
	        <link rel=\"stylesheet\" href=\"xlsgrid/images/flash/css/reset.css\">
	        <link rel=\"stylesheet\" href=\"xlsgrid/css/supersized1.css\">
	        <link rel=\"stylesheet\" href=\"xlsgrid/css/login.css\">
	        <style>
	        	* { margin:0; padding:0; }
	        	body { background:#ccc; height:100%; }
			img { border:none; }
	        </style>
	        <script src=\"xlsgrid/images/flash/js/jquery.cookie.js\" ></script>
	        <script>
	        	$(document).ready(function(){
	        	    //�ж�֮ǰ�Ƿ�������cookie������У������á���ס�ҡ�ѡ���  
			    if($.cookie('xmidware_login_usrid')!=undefined){  
			        $(\"#rememberMe\").attr(\"checked\", true);  
			    }else{  
			        $(\"#rememberMe\").attr(\"checked\", false);  
			    }  
			      
			    //��ȡcookie  
			    if($('#rememberMe:checked').length>0){  
			        $('#orgid').val($.cookie('xmidware_login_orgid')); 
			        $('#accid').val($.cookie('xmidware_login_accid'));
			        $('#usrid').val($.cookie('xmidware_login_usrid')); 
			        $('#userpwd').val($.cookie('xmidware_login_userpwd'));  
			    }  
			      
			    //��������ס�ҡ��¼�  
			    $(\"#rememberMe\").click(rememberMe); 	    
			    
	        	});
	        	function rememberMe(){ 
			        if($('#rememberMe:checked').length>0){//����cookie  
			            $.cookie('xmidware_login_orgid', $('#orgid').val());  
			            $.cookie('xmidware_login_accid', $('#accid').val());
			            $.cookie('xmidware_login_usrid', $('#usrid').val());
			            $.cookie('xmidware_login_userpwd', $('#userpwd').val());  
			        }else{//���cookie  
			            $.removeCookie('xmidware_login_orgid');  
			            $.removeCookie('xmidware_login_accid');
			            $.removeCookie('xmidware_login_usrid');
			            $.removeCookie('xmidware_login_userpwd');  
			        }  
			}
	        	function xmidware_login(){
			        var usrid = $('#usrid').val();
			        var password = $('#userpwd').val();
			        if(usrid == '') {
			            alert('�û�������Ϊ��!');
			            return false;
			        }
			        if(password == '') {
			            alert('���벻��Ϊ��!');
			            return false;
			        }
			        rememberMe();
			    	$('#login_form').submit();
			}
	        </script>
        ";
	var tdwidth = 80;
	
	html += "<div class=\"page-container\">
			<div class=\"main_box\">
				<div class=\"login_box\">
					<div class=\"login_logo\">
						<img src=\"org/GXSI/logo4.png\" >
					</div>
				
					<div class=\"login_form\">
						<form action=\"Login.sp\" id=\"login_form\" method=\"post\">
							<div class=\"form-group\">
								<label for=\"orgid\" class=\"t\">�顡֯��</label> 
								<select class=\"form-control x319 in\" id=\"orgid\" name=\"orgid\">
								  <option value='GXSI'>�����籣��</option>
								  <option value='2'>�����籣��</option>
								  <option value='3'>�����籣��</option>
								  <option value='4'>�����籣��</option>
								  <option value='5'>�����籣��</option>
								</select>
							</div>
							<div class=\"form-group\">
								<label for=\"accid\" class=\"t\">�ʡ��ף�</label> 
								<select class=\"form-control x319 in\" id=\"accid\" name=\"accid\">
								  <option value='GXSI'>��������</option>
								  <option value='2'>������������</option>
								  <option value='3'>���䴢������</option>
								  <option value='4'>������</option>
								  <option value='5'>����ҽ������</option>
								</select>

							</div>
							<div class=\"form-group\">
								<label for=\"usrid\" class=\"t\">�á�����</label> 
								<input id=\"usrid\" value=\"\" name=\"usrid\" type=\"text\" class=\"form-control x319 in\" 
								autocomplete=\"off\">
							</div>
							<div class=\"form-group\">
								<label for=\"userpwd\" class=\"t\">�ܡ��룺</label> 
								<input id=\"userpwd\" value=\"\" name=\"userpwd\" type=\"password\" 
								class=\"password form-control x319 in\">
							</div>
							<div class=\"form-group\">
								<label class=\"t\"></label>
								<label for=\"rememberMe\" class=\"m\">
								<input id=\"rememberMe\" type=\"checkbox\" value=\"true\">&nbsp;��ס��¼��Ϣ!</label>
							</div>
							<div class=\"form-group space\">
								<label class=\"t\"></label>������
								<button type=\"button\"  id=\"submit_btn\" onclick=\"javascript:xmidware_login();\"
								class=\"btn btn-primary\">&nbsp;��&nbsp;¼&nbsp </button>
								<input type=\"reset\" value=\"&nbsp;��&nbsp;��&nbsp;\" class=\"btn btn-default\">
							</div>
						</form>
					</div>
				</div>
				<!--div class='bottom'>Copyright &copy; 2014 - 2015 <a href='#'>ϵͳ��½</a></div-->
			</div>
		</div>";

	
        return html;
}


//����ͼƬ
function ScrollImage()
{
	//ͼƬ��ַ��������ֱ��ʹ��
	
	var pic1=PIC1;
	var pic2=PIC2;
	var pic3=PIC3;
	var pic4=PIC4;
	if(IMGHEIGHT==null||IMGHEIGHT==""||IMGHEIGHT=="null")IMGHEIGHT="150";
	var html="
	<link href=\"xlsgrid/images/flash/css/appframe-cate.css\" rel=\"stylesheet\" type=\"text/css\" />
	<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery.event.drag-1.5.min.js\"></script>
	<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery.touchSlider.js\"></script>
	<style type='text/css'>
	.main_visual{height:"+IMGHEIGHT+"px;border-top:1px solid #d7d7d7;overflow:hidden;position:relative;}
	.main_image{height:"+IMGHEIGHT+"px;overflow:hidden;position:relative;}
	.main_image ul{width:9999px;height:"+IMGHEIGHT+"px;overflow:hidden;position:absolute;top:0;left:0}
	.main_image li{float:left;width:100%;height:"+IMGHEIGHT+"px;}
	.main_image li span{display:block;width:100%;height:"+IMGHEIGHT+"px;}
	.main_image li a{display:block;width:100%;height:"+IMGHEIGHT+"px}
	.main_image li .img_1{background:url('') center top no-repeat}
	.main_image li .img_2{background:url('') center top no-repeat}
	.main_image li .img_3{background:url('') center top no-repeat}
	.main_image li .img_4{background:url('') center top no-repeat}
	.main_image li .img_5{background:url('') center top no-repeat}
	div.flicking_con{position:absolute;top:190px;left:50%;z-index:999;width:300px;height:21px;margin:0 0 0 -50px;}
	div.flicking_con a{float:left;width:21px;height:21px;margin:0;padding:0;background:url('../images/btn_main_img.png') 0 0 no-repeat;display:none;text-indent:-1000px}
	div.flicking_con a.on{background-position:0 -21px}
	#btn_prev,#btn_next{z-index:11111;position:absolute;display:block;width:73px!important;height:74px!important;top:50%;margin-top:-37px;display:none;}
	#btn_prev{background:url(../images/hover_left.png) no-repeat left top;left:100px;}
	#btn_next{background:url(../images/hover_right.png) no-repeat right top;right:100px;}
	</style>
		<div class=\"main_visual\" id=\"test\" style=\"margin-left:0;margin-right:0\">
			<div class=\"flicking_con\">
				<a href=\"#\">1</a>
				<a href=\"#\">2</a>
				<a href=\"#\">3</a>

			</div>
			<div class=\"main_image\">
				<ul >
					<li><span ><img  src=\""+pic1+"\" style=\"width:100%;height:100%;\"></span></li>
					<li><span ><img  src=\""+pic2+"\" style=\"width:100%;height:100%;\"></span></li>
					<li><span ><img  src=\""+pic3+"\" style=\"width:100%;height:100%;\"></span></li>

				</ul>
				<a href=\"javascript:;\" id=\"btn_prev\"></a>
				<a href=\"javascript:;\" id=\"btn_next\"></a>
			</div>
		</div>
	";
	return html;
}



}