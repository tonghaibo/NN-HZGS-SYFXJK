function x_showflg_yxlogin(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var web = new JavaPackage ( "com.xlsgrid.net.web" );

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
	var titlename=pubpack.EAFunc.NVL( request.getParameter("TITLETYP"),"");
	var titlecolor="";
	if(titlename==""){
		 titlename="�߼�ר�� ����";
		  titlecolor="#1EBB91";
	}
	else{
		 titlename="�û�����";
		  titlecolor="red";
		  REGISTERPAGE="L.sp?id=loginRegHospital";
	}
//       <link rel=\"stylesheet\" href=\"xlsgrid/images/flash/css/reset.css\">
//	        <link rel=\"stylesheet\" href=\"xlsgrid/images/flash/css/supersized.css\">
//	        <link rel=\"stylesheet\" href=\"xlsgrid/images/flash/css/logstyle.css\">
	var html = "<!-- CSS -->
		 
	        <div class=\"page-container\" id=\"container\" style=\"background-color:#EEEEEE;filter:alpha(opacity=80); -moz-opacity:0.8; opacity:0.8;width:600px;height:400px; border: 1px solid #EFEFEF;-moz-border-radius: 10px; -webkit-border-radius: 10px;   border-radius:10px; \">
        ";
        var tdwidth=80;
        if(IFTEXTVISI=="false"){ textustnam=""; textpwdnam="";tdwidth=0;}
        
        if(TS_USERNAM!=null) usrplaceholder=TS_USERNAM;
        if(TS_PWD!=null) pwdplaceholder=TS_PWD;
//	<h1><img src=\""+TITLEIMG+"\"></h1>
        if(GOTOPAGE==null|| GOTOPAGE=="" || GOTOPAGE=="Login.sp"  ) {
        	html+="
	             <form style=\"width:600px;height:400px; \" id=\"f_login\"  action=\"Login.sp\" method=\"post\" target=\"_parent\" >
	            	
	               	<table style=\"width:100%;\">
		       <tr>
	               		<td width="+tdwidth+"></td>
	               		<td align=center style=\"padding-top: 47px; padding-bottom: 20px;\"><br><font color=\"#ccc\"><div style=\"position:relative;width:300px;\"><div style=\"float:left;width:20px;height:20px;background:"+titlecolor+";margin-top:5px;\"></div><div style=\"float:left; font-size:20px;color:#222;\">&nbsp;"+titlename+"</div></font></td>
	               	</tr>
		        <tr>
	               		<td align=right></td>
	               		<td><input type=\"text\" name=\"usrid\"  placeholder=\""+usrplaceholder+"\" style=\"font-family:΢���ź�;vertical-align:middle;color:#222;width:300px;height:44px;box-shadow:inset 2px 2px 5px #ececec;border:1px solid #aaa; border-radius:4px;padding:6px 4px; margin-bottom:10px; background:#fff;\"></p></td>
	               	</tr>
	               	
	                <tr>
	               		<td align=right><p><font color=\"#333333\">"+textpwdnam+"</font></td>
			 	<td><input type=\"password\" name=\"userpwd\"  placeholder=\""+pwdplaceholder+"\" style=\"font-family:΢���ź�;vertical-align:middle; color:#222; width:300px;height:44px;box-shadow:inset 2px 2px 5px #ececec;border:1px solid #aaa; border-radius:4px;padding:6px 4px; margin-bottom:10px; background:#fff;\"></p></td>

			</tr>
	               <tr>
	               		<td></td><td align=center> <button id=\"com_ok\" type=\"submit\" class=\"submit_button\" style=\"font-family:΢���ź�;vertical-align:middle;font-size:24px;letter-spacing:15px;width:300px;height:44px;background:#ef4300;border-radius:6px;border:1px solid #ff730e;box-shadow:inset 0px 15px 30px 0px rgba(255,255,255,0.25), 0px 2px 7px 0px rgba(0,0,0,0.2);color:#fff;text-shadow:0px 1px 2px rgba(0,0,0,0.1);\">&nbsp;��¼</button>";
		html+="</td></tr>";
	        
	        html +="<tr>
				<td></td>
				<td align=center ><br><font color=\"#3232cd\"><a onclick=\"javascript:window.location.href='"+REGISTERPAGE+"'\" style=\"cursor:pointer;\">ע���˺�</a> &nbsp;|&nbsp;<a onclick=\"javascript:alert('���������΢�Ź��ںš�ҽѧӰ��ר�Ҽ��š������Աȡ����ϵ��')\" style=\"cursor:pointer;\">��������?</font></a></td>
			</tr>";
	        
	        html+="</table></form> ";
	}
	else {	// �ű���½����ת
		html+="	<h1><img src=\""+TITLEIMG+"\"></h1>
	               <p><font color=\"#333333\">�û���</font> <input type=\"text\" name=\"usrid\" class=\"username\" placeholder=\"�����������û�����\" style=\"color:#222222;\"></p>
	               <p><font color=\"#333333\">���룺</font> <input type=\"password\" name=\"userpwd\" class=\"password\" placeholder=\"�����������û����룡\" style=\"color:#222222;\"></p>
	               <p>&nbsp;</p>
	                <button id=\"com_ok\" onclick=\"javascript:xmidware_login();\" type=\"submit\" class=\"submit_button\" style=\"font-family:΢���ź�;\">&nbsp;��¼</button>";
	        if(  REGISTERPAGE!="" )    
			html+="	<button type=\"button\" class=\"submit_button\" onclick=\"javascript:window.location.href='"+REGISTERPAGE+"'\" style=\"font-family:΢���ź�;\">ע��</button>";
	        html+="<div id='txt_log' style=\"margin:15px;align:left;\"></div>";

	}

	html+="
        </div>
        <!-- Javascript -->
        <script>
	        	function xmidware_login(){
	        		document.all('txt_log').innerHTML='<font color=#444444>��¼��...</font>';
	        		// ����Ҫ��xϵͳ����RLogin�м��
	        		<!--Login.sp?sytid=x&accid=0 -->
	     	        	$.get(\"rlogin.jsp?sytid=x&accid=0&usrid=\"+document.all('usrid').value+\"&userpwd=\"+document.all('userpwd').value, function(result){	
	     	        		result = result.trim();
	        			if(result.indexOf('��������,���¼������Ϣ,��ϵ�����̡�')>0){
	        				var pos1 = result.indexOf('<pre>');
	        				var pos2 = result.indexOf('</pre>');
						document.all('txt_log').innerHTML='<font color=#444444>'+result.substring(pos1+5,pos2)+'</font>';
	        			}
	        			else if(result.substring(0,5)=='<?xml'){
	        				var pos1 = result.indexOf('<TOPIC>');
	        				var pos2 = result.indexOf('</TOPIC>');
						document.all('txt_log').innerHTML='<font color=#444444>'+result.substring(pos1+7,pos2)+'</font>';

	        			}
	        			else {	// ��login�ķ�����Ϣ��  �ɹ���־~��ʾ��Ϣ~�û����~�û�����~�û�GUID~�û�IMGGUID~��ת��ҳ��
	        				// 0~��¼�ɹ�~xlsgrid~0~����Ա~BE34D90B76D2450AA67B6B66D6953FF2~16BE57BE7AC806DEE050007F01005DFF~
	        				var ss = result.split('~');
	        				if(ss.length>6){
	        					document.all('txt_log').innerHTML='<font color=#444444>'+ss[1] +'</font>';
	        					if(ss[6]!='')GOTOPAGE = ss[6];
	        					if(ss[0]=='0') {
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
	        				else if(ss.length>1)document.all('txt_log').innerHTML='<font color=#444444>'+ss[1] +'</font>';
	        				else document.all('txt_log').innerHTML='<font color=#444444>'+result +'</font>';

	        			}
				});
	        	}
	        	$(document).ready(function(){
			  	_resizeheight();
				if(G_APP_USRID!='') document.all('usrid').value =G_APP_USRID;
				var openmode = GetLocationParam('openmode');//openmode=autologin �Զ���½ 
				if(openmode == 'autologin'&&G_APP_USERPWD!=''){
					document.all('userpwd').value =G_APP_USERPWD;
					try{f_login.submit();}catch(e){ xmidware_login() ;}
				}
			});
			window.onresize=function()
			{
				_resizeheight();
			}
			function _resizeheight()
			{
				
				if($(window).width()<600){
					document.all('container').style.width = ''+$(window).width()*0.98+'px';
					document.all('usrid').style.width = ''+$(window).width()*0.5+'px';
					document.all('userpwd').style.width = ''+$(window).width()*0.5+'px';
				}
				else  {
					document.all('container').style.width = '600px';
					document.all('usrid').style.width = '300px';
					document.all('userpwd').style.width = '300px';
				}
				if($(window).width()<$(window).height())//����
					document.all('container').style.margin = ''+($(window).height() - 400)/30+'px auto 0 auto'
				else
					document.all('container').style.margin = ''+($(window).height() - 400)/3+'px auto 0 auto'
				
			}
			function openurl(name,url){
				document.all('mainframe').src=url;
			}
	</script>";
        return html;
}


}