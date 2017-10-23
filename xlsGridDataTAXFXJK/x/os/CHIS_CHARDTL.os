function x_CHIS_CHARDTL(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var ret = "";
 //药品配伍禁忌查询
function getShow(){
	var css="";
	var html="";
	var script="";
	
html="	
<!DOCTYPE HTML>

<html>
<head>
	<title>响应式测试2 - by smwell.com - haibao</title>
	<meta charset=\"GB2312\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0,minimum-scale=1,maximum-scale=1,user-scalable=yes\">
    <link href=\"http://libs.baidu.com/bootstrap/3.0.3/css/bootstrap.min.css\" rel=\"stylesheet\">
    <script src=\"http://libs.baidu.com/bootstrap/3.0.3/js/bootstrap.min.js\"></script>
    <link rel=\"stylesheet\" type=\"text/css\" href=\"sytx/css/style.css\">
    </head>
<body  style=\"width:100%\">
<div data-role=\"page\">
	<div class=\"header linear-g\">
        <a href=\"#panel-left\" data-iconpos=\"notext\" class=\"glyphicon glyphicon-th-large col-xs-2 text-right\"></a>
        <a class=\"text-center col-xs-8\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;smwell.com</a>
        <a href=\"#panel-right\" data-iconpos=\"notext\" class=\"glyphicon glyphicon-user col-xs-2 text-left\"></a>
    	</div>

    	 <div data-role=\"panel\" data-position=\"left\" data-display=\"push\" class=\"list-group shortcut_menu dn linear-g\" id=\"panel-left\">
    	 
        <a href=\"#\" class=\"list-group-item\"><span class=\"glyphicon glyphicon-home\"></span> &nbsp;菜单1</a>
        <a href=\"#\" class=\"list-group-item\"><span class=\"glyphicon glyphicon-edit\"></span> &nbsp;菜单2</a>
        <a href=\"#\" class=\"list-group-item\"><span class=\"glyphicon glyphicon-list\"></span> &nbsp;菜单3</a>
        <a href=\"#\" class=\"list-group-item\"><span class=\"glyphicon glyphicon-list-alt\"></span> &nbsp;菜单4</a>
    </div>
    
    <div data-role=\"panel\" data-position=\"right\" data-display=\"push\" class=\"user_box text-center dn linear-g\" id=\"panel-right\">
        <div class=\"u_info\">
            <img class=\"avatar\" src=\"images/avatar-2.png\" alt=\"头像\">
            <span class=\"username\">李医生</span>
        </div>
        <ul class=\"user_menu\">
          <li class=\"menu\"><a href=\"#\"><span class=\"glyphicon glyphicon-cog\"> </span> &nbsp;基本设置</a></li>
          <li class=\"menu\"><a href=\"#\"><span class=\"glyphicon glyphicon-lock\"> </span> &nbsp;修改密码</a></li>
          <li class=\"menu\"><a href=\"#\"><span class=\"glyphicon glyphicon-picture\"> </span> &nbsp;上传头像</a></li>
          <li class=\"menu\"><a href=\"#\"><span class=\"glyphicon glyphicon-off\"> </span> &nbsp;安全退出</a></li>
        </ul>
    </div>	
    	
    	
    	
    	
    	
    <div data-role=\"content\" class=\"container\" role=\"main\" id=\"mainchart\">
        <ul class=\"content-reply-box mg10\" id=\"mainul\">
            <li class=\"odd\">
                <a class=\"user\" href=\"#\"><img class=\"img-responsive avatar_\" src=\"EAFormBlob.sp?guid=10BF8EF172C7687DE050007F010044C3\" alt=\"\"><span class=\"user-name\">张先生</span></a>
                <div class=\"reply-content-box\">
                	<span class=\"reply-time\">2015-2-8 17:14:0</span>
                    <div class=\"reply-content pr\" align=\"left\">
                    	<span class=\"arrow\">&nbsp;</span>
                    	您好，我想预约复诊
                    </div>
                </div>
            </li>
            <li class=\"even\">
                <a class=\"user\" href=\"#\"><img class=\"img-responsive avatar_\" src=\"EAFormBlob.sp?guid=10BF8EF172C7687DE050007F010044C3\" alt=\"\"><span class=\"user-name\">李医生</span></a>
                <div class=\"reply-content-box\">
                	<span class=\"reply-time\">2015-2-8 17:14:10</span>
                    <div class=\"reply-content pr\" align=\"right\">
                    	<span class=\"arrow\">&nbsp;</span>
                    	几点？
                    </div>
                </div>
            </li>
        

             </ul>  		
	<br>
	<br>
        
        <ul class=\"operating row text-center linear-g\">
        	<li class=\"col-xs-4\"><a href=\"#\"><span class=\"glyphicon glyphicon-tags\"></span> &nbsp;标签</a></li>
        	<li class=\"col-xs-4\"><a href=\"#\"><span class=\"glyphicon glyphicon-comment\"></span> &nbsp;回复</a></li>
        	<li class=\"col-xs-4\"><a href=\"#\"><span class=\"glyphicon glyphicon-heart\"></span> &nbsp;喜欢</a></li>
        </ul>
        </div>
</body>
</html>
";
var script="<script>
function genpro(){
	var strtxt=document.getElementById('textstr').value;
	var d = new Date();
	var tim=d.getFullYear()+'-'+d.getMonth()+'-'+d.getDate()+' '+d.getHours()+':'+d.getMinutes()+':'+d.getSeconds();
	var str='<li class=\"even\">';
	str=str+'<a class=\"user\" href=\"#\"><img class=\"img-responsive avatar_\" src=\"EAFormBlob.sp?guid=10BF8EF172C7687DE050007F010044C3\" alt=\"\"><span class=\"user-name\">灞波儿奔</span></a>';
	str=str+'<div class=\"reply-content-box\" align=\"right\">';
	str=str+'<span class=\"reply-time\">'+tim+'</span>';
	str=str+'<div class=\"reply-content pr\">';
	str=str+'<span class=\"arrow\"></span>';
	str=str+strtxt;
	str=str+' </div>';
	str=str+'  </div>';
	str=str+'    </li>';
	document.getElementById(\'mainul\').innerHTML=document.getElementById(\'mainul\').innerHTML+str;
	document.getElementById('textstr').value='';
	window.scrollTo(0,9999);
}
var SubmitOrHidden = function(evt){   
	 evt = window.event || evt;    
	if(evt.keyCode==13){
	  	genpro(); 
	 }
}               
window.document.onkeydown=SubmitOrHidden;//当有键按下时执行函数
	$(function(){
//		/* 
//		** 不同页面切换转场效果
//		** $.mobile.changePage ('/test.html', 'slide/pop/fade/slideup/slidedown/flip/none', false, false);
//		*/
		$('.list-group-item,.menu a').click(function(){
			$.mobile.changePage($(this).attr('href'), {
				transition : 'flip', //转场效果
				reverse : true       //默认为false,设置为true时将导致一个反方向的转场
			});	
		});
	});
</script>
";
return css+html+script;
}
}