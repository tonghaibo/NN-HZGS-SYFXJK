function x_CHIS_NOJSSCO(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var ret = "";
//
function GetBody(){
var userName = pubpack.EAFunc.NVL( request.getParameter("USERID"),"");
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
        #tstart-toolbar-bottom
         {
             position: fixed;/*固定*/
             bottom: 0;/*在最下*/
             color: #3E3E3E;
             left: 0;
             text-align: left;
             width: 100%;
             z-index: 10000;
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
 
    </style>
</head>
<body>
<table border=0 width=100% height=100%><tr><td id='lefttd' width=100%>
<div data-role=\"page\" id=\"mainpage\" style=\"width:100%;\">
    <div class=\"header linear-g\">
        <a href=\"#panel-left\" data-iconpos=\"notext\" class=\"glyphicon glyphicon-th-large col-xs-2 text-right\"> </a>
        <a class=\"text-center col-xs-8\">"+TITLE+"</a>
      
        <a href=\"#\" onclick=\"javascript:f_switchvideo();\" data-iconpos=\"notext\" class=\"glyphicon glyphicon-facetime-video\"> </a>

    </div>

    <div data-role=\"panel\" data-position=\"left\" data-display=\"push\" class=\"list-group shortcut_menu dn linear-g\" id=\"panel-left\">
        <div class=\"header linear-g\">
       		<a class=\"text-center col-xs-8\">候诊病人</a>
    	</div>

        
        <a href=\"chart.html\" class=\"list-group-item\"><span class=\"glyphicon glyphicon-home\"> </span> &nbsp;病人1</a>
        <a href=\"#\" class=\"list-group-item\"><span class=\"glyphicon glyphicon-edit\"> </span> &nbsp;病人2</a>
        <a href=\"#\" class=\"list-group-item\"><span class=\"glyphicon glyphicon-list\"> </span> &nbsp;病人3</a>
        <a href=\"#\" class=\"list-group-item\"><span class=\"glyphicon glyphicon-list-alt\"> </span> &nbsp;病人4</a>
        <a href=\"#\" class=\"list-group-item\"><span class=\"glyphicon glyphicon-list-alt\"> </span> &nbsp;病人5</a>

    </div>
    
    <div data-role=\"panel\" data-position=\"right\" data-display=\"push\" class=\"user_box text-center dn linear-g\" id=\"panel-right\" style=\"border:1px solid #F2F2F2;background:#F2F2F2\" >
    	<ul class=\"user_menu\"  >
            <li class=\"left-menu\" \"><a><span class=\"glyphicon glyphicon-cog\"> </span> &nbsp;病人健康档案</a></li>
        </ul>
        <a href=\"chart.html\" class=\"list-group-item\"><span class=\"glyphicon glyphicon-home\"> </span> &nbsp;体征检测图</a>
        <a href=\"#\" class=\"list-group-item\"><span class=\"glyphicon glyphicon-edit\"> </span> &nbsp;病程分析图</a>
        <a href=\"#\" class=\"list-group-item\"><span class=\"glyphicon glyphicon-list\"> </span> &nbsp;基础信息</a>
        <a href=\"#\" class=\"list-group-item\"><span class=\"glyphicon glyphicon-list-alt\"> </span> &nbsp;既往病史</a>
        <a href=\"#\" class=\"list-group-item\"><span class=\"glyphicon glyphicon-list-alt\"> </span> &nbsp;门急诊及住院信息</a>
        <a href=\"#\" class=\"list-group-item\"><span class=\"glyphicon glyphicon-list-alt\"> </span> &nbsp;检查检验信息</a>
        <a href=\"#\" class=\"list-group-item\"><span class=\"glyphicon glyphicon-list-alt\"> </span> &nbsp;线上诊断</a>
        <a href=\"#\" class=\"list-group-item\"><span class=\"glyphicon glyphicon-list-alt\"> </span> &nbsp;穿戴设备</a>

    </div>
    <div data-role=\"content\" class=\"container\" role=\"main\">
        <ul class=\"content-reply-box mg10\" id=\"list\">
        </ul>
    </div>
    <div id=\"bottomNav\" style=\"height:40px;background: -webkit-linear-gradient(top, #fdfdfd, #CDCDCD);\">
    	<table width=100% height=100%  border=0  ><tr>
    	<td width=40><a href=\"#\" onclick=\"javascript:f_switchvideo();\" data-iconpos=\"notext\" class=\"glyphicon glyphicon-plus\"></a></td>
        <td ><input type=\"text\" style=\"width:100%;height:100%\" id=\"text\"/></td>
        <td width=60 onclick='send();' id=\"send\" style=\"cursor:hand;\"><a href='#' onclick='send();' >回复</a></td>
        </tr></table>	    	
    	
    </div>
</div>
</td>
<td width=0 id='righttd' >
	<ul class=\"user_menu\"  id=\"rightvidio\" style=\"display:none;\">
            <li class=\"menu\" onclick=\"init('fangkun','029','1')\"><a><span class=\"glyphicon glyphicon-cog\"> </span> &nbsp;点击打开视频问诊</a></li>
        </ul>
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

</td></tr></table>
<script>
	var vidiovisible = false;
	function f_switchvideo()
	{
		
		if(vidiovisible ==false ) { 
			
			document.all('righttd').width='50%';
			document.all('lefttd').width='50%';
			document.all('mainpage').style.width = '50%';
			document.all('mainpage').style.border = '1px solid #ccc';
			document.all('rightvidio').style.display = 'block';
			vidiovisible =true;
		}
		else {
			document.all('righttd').width='0%';
			document.all('lefttd').width='100%';
			document.all('mainpage').style.width = '100%';
			document.all('rightvidio').style.display = 'none';
			vidiovisible = false;
		}
	}
	function send(){
		
		var value = $.trim($(\"#text\").val());

		sendMsg(value);
		appendMessage(value);
	}
</script>
<script type=\"text/javascript\" src=\"sytx/js/chis/wechart/js2/jquery.min.js\"></script>
<script type=\"text/javascript\" src=\"sytx/js/chis/wechart/js2/jquery.mobile-1.4.0-rc.1.js\"></script>
<script type=\"text/javascript\" src=\"sytx/js/chis/wechart/js/main.js\"></script>
<script type=\"text/javascript\" src=\"sytx/js/chis/wechart/js/peer.js\"></script>
<script type=\"text/javascript\">";
var sql="";
var ds=null;
var db=null;
db = new pubpack.EADatabase();
sql="select a.guid,a.name,a.jobtitle,a.img,a.BEGOODAT,b.hosnam from yx_doc a,CHIS_HOS B where a.id='"+userName+"'";
ds=db.QuerySQL(sql);

		html += "$(document).ready(function() {
			var rooms = null;
			var socket = null;
			var currentUid = '"+ds.getStringAt(0,"guid")+"';
			var currentuser = null;
			
			if(typeof WebSocket === 'undefined') {
				alert(\"当前浏览器不支持websocket\");
				return;
			}
			
			function appendMessage(msg) {	// 我发出的
				var d = new Date();
				var tim=d.getFullYear()+\"-\"+d.getMonth()+\"-\"+d.getDate()+\" \"+d.getHours()+\":\"+d.getMinutes()+\":\"+d.getSeconds();
				var str = \"\";
				str='<li class=\"even\">';
				str=str+'<a class=\"user\" href=\"#\"><img class=\"img-responsive avatar_\" src=\"sytx/js/chis/wechart/images/avatar-2.png\" alt=\"\"><span class=\"user-name\">"+ds.getStringAt(0,"name")+"</span></a>';
				str=str+'<div class=\"reply-content-box\" align=\"left\" style=\"float:right;margin:2px;\">';
				str=str+'<span class=\"reply-time\">'+tim+'</span>';
				str=str+'<div class=\"reply-content pr\" >';
				str=str+'<span class=\"arrow\"></span>';
				str=str+msg;
				str=str+' </div>';
				str=str+'  </div>';
				str=str+'    </li>';
				document.getElementById(\"list\").innerHTML=document.getElementById(\"list\").innerHTML+str;
				document.getElementById(\"text\").value=\"\";
				window.scrollTo(0,9999);
			}
			function appendMessage1(msg,name) {// 对方过来的
				var d = new Date();
				var tim=d.getFullYear()+\"-\"+d.getMonth()+\"-\"+d.getDate()+\" \"+d.getHours()+\":\"+d.getMinutes()+\":\"+d.getSeconds();
				var str = \"\";
				str='<li class=\"odd\">';
				str=str+'<a class=\"user\" href=\"#\"><img class=\"img-responsive avatar_\" src=\"sytx/js/chis/wechart/images/avatar-1.png\" alt=\"\"><span class=\"user-name\">'+name+'</span></a>';
				str=str+'<div class=\"reply-content-box\" align=\"left\" style=\"float:left;margin:2px;\">';
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
				rooms = Math.round(Math.random()*1000000);
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
					'ROOM': rooms,
					'OTHGUID': '1'
				}));
			};
			
			socket.onmessage = function(event) {
				var mData = JSON.parse(event.data);
				if(mData && mData.event) {
					switch(mData.event) {
						case 'LOGIN':
						var user = mData.user;
						var room = user.ROOM;
						if(room == rooms){
							appendMessage1(user.NAME+\"进入诊室\"+room,\"系统提示\");
							
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
			if(value!=''){
				sendMsg(value);
				appendMessage(value);
			}
		});
		
	});
</script>
</body>
";
if(db!=null){db.Close();}
return html;
}
}