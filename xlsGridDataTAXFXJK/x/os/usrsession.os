function x_usrsession(){var web = new JavaPackage("com.xlsgrid.net.web");


//服务端Servlet响应
//直接可以使用 mwid.sp调用，在Action按钮也可以调用本函数
function Response()
{
	var usrinfo = web.EASession.GetUserinfo(request);
	//var usrid = usrinfo.getUsrid();
   	var accid = usrinfo.getAccid();
   	var orgid = usrinfo.getOrgid();
   	var sytid = usrinfo.getSytid(); 
   	var test =  usrinfo.getUsrid();

	return test;
}

}