function x_weixin_pubuser(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var weixin= new JavaPackage("com.xlsgrid.net.weixin");
function Getxeixinhttp()
{
	var httpcall = new webget.HttpCall();
	var ret = httpcall.Get(url,"UTF-8");	
	return ret;
}
function Postxeixinhttp()
{
	var urls=url+"?access_token="+token;
        var result =weixin.WeixinUtil.httpRequest(urls,"POST",jos);  
        return result;
}
function gettoken()
{
	var httpcall = new webget.HttpCall();
	var ret = httpcall.Get(url,"UTF-8");	
	return ret;
}

}