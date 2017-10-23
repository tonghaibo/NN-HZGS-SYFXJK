function x_showflg_loginregister(){
//
// 
//
function loginregister()
{
	var html="<link rel=\"stylesheet\" href=\"xlsgrid/images/flash/css/reset.css\">
	          <link rel=\"stylesheet\" href=\"xlsgrid/images/flash/css/supersized.css\">
	          <link rel=\"stylesheet\" href=\"xlsgrid/images/flash/css/logstyle.css\">

	<div class=\"page-container\" id=\"container\" style=\"background-color:#EEEEEE;filter:alpha(opacity=80); -moz-opacity:0.8; opacity:0.8;width:600px;height:430px; border: 1px solid #EFEFEF;-moz-border-radius: 10px; -webkit-border-radius: 10px;   border-radius:10px; \">
            
                    <form action=\"L.sp?osp=YXIMAGES_loginregister_register\" method=\"post\" style=\"font-family: 黑体;\">
                    	<br/>
                    	<br/>
                    	<h1><font color=\"#333333\" style=\"font-family: 黑体;\">医生注册</font></h1>
                        <table>
                        	<tr><td align=right><font color=\"#333333\"  style=\"font-family: 黑体;\">手机号码：</font></td><td><input type=\"text\" id=\"userid\" name=\"userid\"  placeholder=\"请输入手机号码....\"></td></tr>

				<tr><td align=right><font color=\"#333333\" style=\"font-family: 黑体;\">设置密码：</font></td><td><input type=\"password\" id=\"password\" name=\"password\"   placeholder=\"请输入密码...\"></td></tr>
			
				<tr><td align=right><font color=\"#333333\" style=\"font-family: 黑体; PADDING-LEFT: 5px; \">确认密码：</font></td><td><input type=\"password\" id=\"repassword\" name=\"repassword\"   placeholder=\"请输入密码...\"></td></tr>
			</table>
						
                        <div><input type=\"checkbox\" id=\"ckbx\" name=\"ckbx\" checked=\"checked\"  style=\"width: 15px; height: 15px; margin-bottom: 8px;\">&nbsp&nbsp<font color=\"#333333\" style=\"font-family: 黑体;\">我已同意<a href=\"L.sp?id=servagr\">《51dupian.com用户服务协议医师版》</a></font></div>
						
			<input type=\"button\" onclick=\"savesubmit()\" style=\"cursor: pointer;width: 120px;height: 44px;margin-left:0px;background: #ef4300;-moz-border-radius: 6px;-webkit-border-radius: 6px;border-radius: 6px;border: 1px solid #ff730e;-moz-box-shadow:0 15px 30px 0 rgba(255,255,255,.25) inset,0 2px 7px 0 rgba(0,0,0,.2);-webkit-box-shadow:0 15px 30px 0 rgba(255,255,255,.25) inset,0 2px 7px 0 rgba(0,0,0,.2);box-shadow:0 15px 30px 0 rgba(255,255,255,.25) inset,0 2px 7px 0 rgba(0,0,0,.2);font-family: 'PT Sans', Helvetica, Arial, sans-serif;font-size: 14px;font-weight: 700;color: #fff;text-shadow: 0 1px 2px rgba(0,0,0,.1);-o-transition: all .2s;-moz-transition: all .2s;-webkit-transition: all .2s;-ms-transition: all .2s;\" value=\"提交\"></input>
                    </form>
        </div>";
        
        return html;
}

}