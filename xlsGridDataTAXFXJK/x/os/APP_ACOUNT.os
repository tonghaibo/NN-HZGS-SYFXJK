function x_APP_ACOUNT(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function Response()
{
	//return "感谢关注"+appid;
	var sb = request.getRequestURL();
	return sb.toString();
	response.sendRedirect("L.sp?id=appCare");
}

// 添加关注号
// 调用端 Weixin.sp?osp=x.APP_ACOUNT.addAcount
function addAcount()
{
	try {
		var sqltxt = "insert into app_careacount(org,usrguid,appguid,loginuserid,loginpasswd) select 'XLSGRID' org,'"+usrguid
			+"' usrguid,guid appguid,'"+loginuserid+"' loginuserid,'"+loginpasswd+"' loginpasswd from app_acount where appid='"+appid+"'";
	
		pub.EADbTool.ExcecutSQL(sqltxt);
		
		//pub.EAFunc.Log(sqltxt);

		//response.sendRedirect("L.sp?id=appCare");
		
		//return "1";
	}
	catch (e) {
		return e.toString();
		//pub.EAFunc.Log(e.toString());
	}
}
}