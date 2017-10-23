function x_showflg_Exchange(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
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
	var TITLE="";
	//var userid = pubpack.EAFunc.NVL( request.getParameter("USERID"),"");
	var ro  = pubpack.EAFunc.NVL( request.getParameter("ro"),"");
//<!--//xmidware下的目录格式如下：xlsgrid/images/flash/js/jquery-1.7.2.min.js"-->    
//XMIDWARE_APP_USRGUID
	var TITLE = pubpack.EAFunc.NVL( request.getParameter("TITLE"),"");

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
<!DOCTYPE HTML>
<html>
<head>
    <title>"+TITLE+"</title>
    <meta charset=\"UTF-8\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">    
   <link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/css/bootstrap.min.css\"> 
    <link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/css/style.css\">    
    <link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/css/jquery.mobile.flatui.css\" />
	<style type=\"text/css\">
        #bottomNav {
            z-index:999;
            position:fixed;
            background: -webkit-linear-gradient(top, #fdfdfd, #CDCDCD);

            margin-top: -50px; 
    	    height: 50px;
            bottom:0;
            left:0;
            width:100%;
         
            overflow:visible;
        }
        #bottomNav input{
            width: 90%;
        }
        #tstart-toolbar-bottom
         {
             position: fixed;/*固定*/
             bottom: 0;/*在最下*/
             color: #3E3E3E;
             left: 0;
             text-align: left;
             width: 100%;
             z-index: 500;
             _position:absolute; /* for IE6 */
             _top: expression(documentElement.scrollTop + documentElement.clientHeight-this.offsetHeight); /* for IE6 */
             overflow:visible;
         }
         #tstart-toolbar-bottom .tstart-left
         {
             float: left;/*在左*/             
             width: 300px;
             margin: 5px 5px 5px 5px;
             padding: 5px;
             border: 1px solid silver;
             background-color:white;
             /*椭圆与阴影*/
             box-shadow: 0px 0px 5px #000;
             -moz-box-shadow: 0px 0px 5px #000;
             -webkit-box-shadow: 0px 0px 5px #000;
         }
         #tstart-toolbar-bottom .tstart-right
         {
             float: right; /*在右*/
             width: 300px;
             margin: 5px 5px 5px 5px;
             padding: 5px;
             border: 1px solid silver;
             background-color:white;
             
             box-shadow: 0px 0px 5px #000;
             -moz-box-shadow: 0px 0px 5px #000;
             -webkit-box-shadow: 0px 0px 5px #000;
         }
 
 
 
 
 
 
 
 #popup{
  position: absolute;display:none; z-index:999999; background-color:#FFF; left: 601px; top: 217px; height: 150px; width: 217px;line-height:94px;text-align:center;
  border: 1px solid #03F;
}
#embedding{
  position: absolute; background-color: #36F; top: 94px;height:56px; width:217px;line-height:56px;text-align:center;
}
</style>
    
    
    
    

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


</head>
<body style=\"text-align:left;scrollbar:no;\">
<!-- 这-->
<div data-role=\"page\" id=\"mainpage\">
    <div class=\"header linear-g\">
 
        <a class=\"text-center col-xs-8\">诊疗室</a>
    </div>
   
  
    <div data-role=\"content\" class=\"container\" role=\"main\">
        <ul class=\"content-reply-box mg10\" id=\"list\">
        </ul>
    </div>
    <div id=\"bottomNav\">
        <input type=\"text\" style=\"float: left\" id=\"text\"/>
        <a style=\"cursor:pointer;float: right;width: 8%;margin-right: 3px;border: 1px solid #000000; text-align: center\" id=\"send\">回复</a>
    </div>
</div>



<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/chart.jquery.min.js\"></script>
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/chart.jquery.mobile-1.4.0-rc.1.js\"></script>
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/chart.main.js\"></script>
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/chart.peer.js\"></script>
<script type=\"text/javascript\">";
var sql="";
var ds=null;
var db=null;
db = new pubpack.EADatabase();
//sql="select a.guid,a.name,a.id,a.imgguid img from usr a where a.id='"+userid+"'";
//ds=db.QuerySQL(sql);
//if(ds.getRowCount()==0) throw new Exception ("改用户("+userid+"没有找到医生资料");

		
		html += "
		var rooms = GetLocationParam('ro');
		var socket = null;
		var currentUid = G_APP_USRGUID;
		var currentuser = null;
		$(document).ready(function() {

		
			// 如果存在usrid和userpwd用户，执行一次登陆
			var myusrid = GetLocationParam('usrid');
			var myuserpwd = GetLocationParam('userpwd');
			if(myusrid !=null&& myusrid !=''&&myuserpwd !=null&& myuserpwd !=''  ){
				$.get(\"rlogin.jsp?sytid=x&accid=0&usrid=\"+myusrid+\"&userpwd=\"+myuserpwd, function(result){	
	     	        		result = result.trim();
	        			if(result.indexOf('如有问题,请记录以上信息,联系开发商。')>0){
	        				var pos1 = result.indexOf('<pre>');
	        				var pos2 = result.indexOf('</pre>');
	        			}
	        			else if(result.substring(0,5)=='<?xml'){
	        				var pos1 = result.indexOf('<TOPIC>');
	        				var pos2 = result.indexOf('</TOPIC>');
	        			}
	        			else {	// 让login的返回信息，  成功标志~提示信息~用户编号~用户名称~用户GUID~用户IMGGUID~跳转的页面
	        				// 0~登录成功~xlsgrid~0~管理员~BE34D90B76D2450AA67B6B66D6953FF2~16BE57BE7AC806DEE050007F01005DFF~
	        				var ss = result.split('~');
	        				if(ss.length>6){
	        					if(ss[0]=='0') {
	        						try{
	        							window.localStorage.setItem('XMIDWARE_APP_USRID',myusrid);
									window.localStorage.setItem('XMIDWARE_APP_USERPWD',myuserpwd);
									window.localStorage.setItem('XMIDWARE_APP_USRNAM',ss[4]);
									window.localStorage.setItem('XMIDWARE_APP_USRGUID',ss[5]);
									window.localStorage.setItem('XMIDWARE_APP_USRIMG',ss[6]);
									G_APP_USRID = myusrid;
									G_APP_USERPWD = myuserpwd;
									G_APP_USRIMG = ss[6];
									G_APP_USRGUID = ss[5];
									G_APP_USRNAM = ss[4];
								}catch(e){}
	        													}
	        				}

	        			}
				});
			}
			
			if(typeof WebSocket === 'undefined') {
				alert(\"当前浏览器不支持websocket\");
				return;
			}
			
			

			socket = new WebSocket(\"ws://114.80.114.43:8000/\");

			socket.onopen = function(event) {
				if(rooms=='') {
					// 医生端，如果co是空值，那么创建一个room
					rooms = Math.round(Math.random()*1000000);
					socket.send(JSON.stringify({
						'EVENT': 'LOGIN',
						'GUID': currentUid,
						'NAME': '管理员',
						'ROOM': rooms,
						'ID'  : 'xlsgrid',
						'IMG' :'',
						'ACTION' : 'REQUEST',		// 
						'OTHGUID': '1'
					}));
					// 修改标题

					G_USRROL = '1';
				}
				else {//病人直接连接
					socket.send(JSON.stringify({
						'EVENT': 'LOGIN',
						'GUID': G_USRGUID,
						'NAME': G_USRNAM,
						'ROOM': rooms,
						'ID'  : G_USRID,
						'IMG' : G_USRIMG,
						'ACTION' : 'REQUEST'
					}));
					document.all('myroomname').innerHTML = '管理员聊天室';
				}
			};
			
			socket.onmessage = function(event) {
				var mData = JSON.parse(event.data);
				if(mData && mData.event) {
					switch(mData.event) {
						case 'LOGIN':
						var user = mData.user;
						
						if(user.GUID=='xlsgrd'){//排除本人
						}
						else {
							var room = user.ROOM;
							
							if(room == rooms){
								if( user.ACTION =='REQUEST'){
									if(2=='1'&& confirm('进入诊室,是否确认')==1 ){
										G_USRNAM1 = user.NAME;
										G_USRID1 = user.ID;
										G_USRIMG1 = user.IMG;
										G_USRGUID1 = user.GUID;
										// 发送确认消息告诉进入房间的人，你可以进来了，对方会获取医生的资料
										
										socket.send(JSON.stringify({
											'EVENT': 'LOGIN',
											'GUID': G_USRGUID,
											'NAME': G_USRNAM,
											'ROOM': rooms,
											'ID'  : G_USRID,
											'IMG' : G_USRIMG,
											'ACTION' : 'COMFIRM'

										}));
										appendMessage(G_USRNAM1+'进入"+TITLE+"',G_USRNAM1,G_USRIMG1,'left');
										document.all('myroomname').innerHTML = G_USRNAM+'"+TITLE+"-'+G_USRNAM1;
	
									}
								}
								else if( user.ACTION =='COMFIRM'){// 收到登陆的请求回复了，获取医生的资料

									if( user.ID!='xlsgrid') { 
										G_USRID1 = user.ID;
										G_USRNAM1 = user.NAME;
										G_USRIMG1 = user.IMG;
										G_USRGUID1 = user.GUID;
										document.all('myroomname').innerHTML = G_USRNAM1+'的"+TITLE+"-'+G_USRNAM;
									}
								}
								else if( user.ACTION =='CLOSE'){// 收到登陆的请求回复了，获取医生的资料

									appendMessage(G_USRNAM1+'离开"+TITLE+"',G_USRNAM1,G_USRIMG1,'left');

								}

							} else{
								return;
							}
							
						}
						break;
						case 'SPEAK':
						var content = mData.values;
						var newUser = mData.user;
						var uid = newUser.GUID;
						if(newUser.ROOM == rooms) {
							
							if(uid != G_USRGUID)appendMessage(content,G_USRNAM1,G_USRIMG1,'left');
						}
					
						break;
						
					}
				}
			};
			
		
		
	});
</script>
</body>
";
if(db!=null){db.Close();}
return html;

}

}