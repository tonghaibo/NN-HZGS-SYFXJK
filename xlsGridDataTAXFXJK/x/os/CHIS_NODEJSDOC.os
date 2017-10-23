function x_CHIS_NODEJSDOC(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var ret = "";
//
function GetBody(){
var userName = pubpack.EAFunc.NVL( request.getParameter("USERID"),"");
var ro = pubpack.EAFunc.NVL( request.getParameter("ro"),"");
//图片地址
var html="
<!DOCTYPE HTML>
<html>
<head>
    <title>诊疗室</title>
    <meta charset=\"UTF-8\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    
<link rel=\"stylesheet\" type=\"text/css\" href=\"sytx/js/chis/wechart/css2/bootstrap.min.css\">    
    <link rel=\"stylesheet\" type=\"text/css\" href=\"sytx/js/chis/wechart/css2/style.css\">    
    <link rel=\"stylesheet\" type=\"text/css\" href=\"sytx/js/chis/wechart/css2/jquery.mobile.flatui.css\" />
	<style type=\"text/css\">
        #bottomNav {
            z-index:999;
            position:fixed;
            bottom:0;
            left:0;
            width:100%;
            _position:absolute;
            _top: expression_r(documentElement.scrollTop + documentElement.clientHeight-this.offsetHeight);
            overflow:visible;
        }
        #bottomNav input{
            width: 90%;
        }
    </style>
</head>
<body>
<div data-role=\"page\" id=\"mainpage\">
    <div class=\"header linear-g\">
        <a href=\"#panel-left\" data-iconpos=\"notext\" class=\"glyphicon glyphicon-th-large col-xs-2 text-right\"> </a>
        <a class=\"text-center col-xs-8\">诊疗室</a>
        <a href=\"#panel-right\" data-iconpos=\"notext\" class=\"glyphicon glyphicon-user col-xs-2 text-left\"> </a>
    </div>
    <div data-role=\"panel\" data-position=\"left\" data-display=\"push\" class=\"list-group shortcut_menu dn linear-g\" id=\"panel-left\">
        <ul class=\"mainmenu\">
            <li><a href=\"chart.html\" ><span>体征检测图</span></a></li>
            <li><a href=\"chartframe.html\" ><span>病程分析图</span></a></li>
            <li><a href=\"#\" ><span>基础信息</span></a></li>
            <li><a href=\"#\" ><span>既往病史</span></a></li>
            <li><a href=\"#\" ><span>门急诊及住院信息</span></a></li>
            <li><a href=\"#\" ><span>检查检验信息</span></a></li>
            <li><a href=\"#\" ><span>线上诊断</span></a></li>
            <li><a href=\"#\" ><span>穿戴设备</span></a></li>
            <li><a href=\"#\" onclick='init('029','fangkun','1')'><span>视频问诊</span></a></li>
        </ul>

    </div>
    <div data-role=\"panel\" data-position=\"right\" data-display=\"push\" class=\"user_box text-center dn linear-g\" id=\"panel-right\" style=\"border:1px solid #F2F2F2;background:#F2F2F2\" >
        <ul class=\"user_menu\"  >
            <li class=\"menu\" onclick=\"init('029','fangkun','2')\"><a><span class=\"glyphicon glyphicon-cog\"> </span> &nbsp;视频问诊</a></li>
        </ul>
        
        <!--
		<div id=\"videos1\" style=\"display:none;width:200px;height:200px;float:left;\">
			<video id=\"you1\" autoplay=\"autoplay\" style=\"top:200px;width:200px;height:200px\" controls></video>
		</div>
			
		
		<div id=\"videos1\" style=\"display:none;width:200px;height:200px;\">
			<video id=\"other1\" autoplay=\"autoplay\" style=\"top:400px;width:200px;height:200px\" controls></video>
		</div>
		
	-->	
		
		
		
		
		
		<div id=\"videos1\" style=\"display:none;width:100%;height:auto;float:left;\">
			<div><video id=\"you1\" autoplay=\"autoplay\" style=\"width:100%;height:auto;\" controls></video>
			<!--
				<div id=\"tstart-toolbar-bottom\">
					<div class=\"tstart-right\">
					<video id=\"other1\" autoplay=\"autoplay\" style=\"width:30%;height:auto;\" controls></video>
					</div>
				</div>
			-->
			</div>
			<p>&nbsp;</p>
			<video id=\"other1\" autoplay=\"autoplay\" style=\"width:100%;height:auto;\" controls></video>

		</div>

		
		
		
		
		
		
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
<script type=\"text/javascript\" src=\"sytx/js/chis/wechart/js2/jquery.min.js\"></script>
<script type=\"text/javascript\" src=\"sytx/js/chis/wechart/js2/jquery.mobile-1.4.0-rc.1.js\"></script>

<script type=\"text/javascript\" src=\"sytx/js/chis/wechart/js/peer.js\"></script>";
var sql="";
var ds=null;
var db=null;
db = new pubpack.EADatabase();
sql="select a.guid,a.name from usr a where a.id='"+userName+"'";
ds = db.QuerySQL(sql);
html+="<script type=\"text/javascript\">
		$(document).ready(function() {
			var rooms = '"+ro+"';
			var socket = null;
			var currentUid = '"+ds.getStringAt(0,"guid")+"';
			var user = null;
			var currentuser = null;
			
			if(typeof WebSocket === 'undefined') {
				alert(\"当前浏览器不支持websocket\");
				return;
			}
			
			function appendMessage(msg) {
				var d = new Date();
				var tim=d.getFullYear()+\"-\"+d.getMonth()+\"-\"+d.getDate()+\" \"+d.getHours()+\":\"+d.getMinutes()+\":\"+d.getSeconds();
				var str = \"\";
				str='<li class=\"even\">';
				str=str+'<a class=\"user\" href=\"#\"><img class=\"img-responsive avatar_\" src=\"images/doc.png\" alt=\"\"><span class=\"user-name\">"+ds.getStringAt(0,"name")+"</span></a>';
				str=str+'<div class=\"reply-content-box\" align=\"right\">';
				str=str+'<span class=\"reply-time\">'+tim+'</span>';
				str=str+'<div class=\"reply-content pr\">';
				str=str+'<span class=\"arrow\"></span>';
				str=str+msg;
				str=str+' </div>';
				str=str+'  </div>';
				str=str+'    </li>';
				document.getElementById(\"list\").innerHTML=document.getElementById(\"list\").innerHTML+str;
				document.getElementById(\"text\").value=\"\";
				window.scrollTo(0,9999);
			}
			function appendMessage1(msg,name) {
				var d = new Date();
				var tim=d.getFullYear()+\"-\"+d.getMonth()+\"-\"+d.getDate()+\" \"+d.getHours()+\":\"+d.getMinutes()+\":\"+d.getSeconds();
				var str = \"\";
				str='<li class=\"odd\">';
				str=str+'<a class=\"user\" href=\"#\"><img class=\"img-responsive avatar_\" src=\"images/doc.png\" alt=\"\"><span class=\"user-name\">'+name+'</span></a>';
				str=str+'<div class=\"reply-content-box\" align=\"right\">';
				str=str+'<span class=\"reply-time\">'+tim+'</span>';
				str=str+'<div class=\"reply-content pr\">';
				str=str+'<span class=\"arrow\"></span>';
				str=str+msg;
				str=str+' </div>';
				str=str+'  </div>';
				str=str+'    </li>';
				document.getElementById(\"list\").innerHTML=document.getElementById(\"list\").innerHTML+str;
				document.getElementById(\"text\").value=\"\";
				window.scrollTo(0,9999);
			}
			
			socket = new WebSocket(\"ws://114.80.114.43:8000/\");
			
			socket.onopen = function(event) {
				currentuser = {
					'EVENT': 'LOGIN',
					'GUID': currentUid,
					'NAME': '"+ds.getStringAt(0,"name")+"',
					'ROOM': rooms
				}
				socket.send(JSON.stringify({
					'EVENT': 'LOGIN',
					'GUID': currentUid,
					'NAME': '"+ds.getStringAt(0,"name")+"',
					'ROOM': rooms
				}));
			};
			
			socket.onmessage = function(event) {
				var mData = JSON.parse(event.data);
				if(mData && mData.event) {
					user = mData.user;
					switch(mData.event) {
						case 'LOGIN':
						var room = user.ROOM;
						if(room == rooms){
							alert(user.NAME+\"进入房间！\");
						} else{
							return;
						}
						break;
					
						case 'SPEAK':
						var content = mData.values;
						var newUser = mData.user;
						var uid = newUser.GUID;
						if(newUser.ROOM == rooms) {
							if(uid != currentUid) {
									appendMessage1(content,newUser.NAME);
								}
						}
						break;
					}
				}
			};
			
		function sendMsg(msg) {
			if(msg) {
				socket.send(JSON.stringify({
					'EVENT': 'SPEAK',
					'USER': currentuser,
					'VALUES':msg
				}));
			}
		};
		
		$(\"#send\").click(function(event) {
			var value = $.trim($(\"#text\").val());
			sendMsg(value);
			appendMessage(value);
		});
	});
</script>
 </body>";
if(db!=null){db.Close();}
return html;



}

}