function x_logout(){
var pub = new JavaPackage("com.xlsgrid.net.pub");
var servlet = new JavaPackage("com.xlsgrid.net.servlet");
var web = new JavaPackage("com.xlsgrid.net.web");
function Response(){
	//return "123";
	var orgid=pub.EAFunc.NVL(request.getParameter("orgid"),"");
	var usrid=pub.EAFunc.NVL(request.getParameter("usrid"),"");
	var pwd=pub.EAFunc.NVL(request.getParameter("userpwd"),"");
	var deforg=web.EAWebDeforg.GetDeforg(request);
	var usbkey_sernum=pub.EAFunc.NVL(request.getParameter("USBKEY_SERNUM"),"");
	var usbkey_keyval=pub.EAFunc.NVL(request.getParameter("USBKEY_KEYVAL"),"");
	var nls=pub.EAFunc.NVL(request.getParameter("nls"),"");
	var root = pub.EAFunc.getAppRootUrl(request);
	servlet.Login.savePassport(response,orgid, usrid, pwd,deforg,0,usbkey_sernum,usbkey_keyval,nls,root);
	var HttpSession = request.getSession();
	HttpSession.invalidate();
	var gotourl=pub.EAFunc.NVL(request.getParameter("gotourl"),"");
	var url = pub.EAFunc.getAppRootUrl(request);
	response.sendRedirect(url+gotourl);
}
}