function x_usrsession(){var web = new JavaPackage("com.xlsgrid.net.web");


//�����Servlet��Ӧ
//ֱ�ӿ���ʹ�� mwid.sp���ã���Action��ťҲ���Ե��ñ�����
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