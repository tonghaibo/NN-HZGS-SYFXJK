function x_appWebService(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//查询用户关注号清单
function loadCareApp(request)
{
	var usrid = pub.EAFunc.NVL(request.getParameter("usrid"),"");
	var orgid = pub.EAFunc.NVL(request.getParameter("orgid"),"");

	var sql = "select a.org,a.appid,a.appname,a.appicon,a.appurl,b.loginuserid usrid,b.loginpasswd userpwd 
		from app_acount a,app_careacount b,usr c 
		where a.guid=b.appguid and b.usrguid=c.guid and a.org=b.org 
		  and c.id='"+usrid+"' and a.org='"+orgid+"'";
		 
	var ds = pub.EADbTool.QuerySQL(sql);
	return ds.GetXml();
	
}


//查询关注号列表
function loadAppAcount(request)
{
	var orgid = request.getParameter("orgid");
	var sql = "select a.org,a.appid,a.appname,a.appicon,a.appurl,'' usrid,'' userpwd 
		from app_acount a
		where a.org='"+orgid+"'";
		 
	var ds = pub.EADbTool.QuerySQL(sql);
	return ds.GetXml();
}

//添加到关注
function addAppCareAcount(request)
{
	var orgid = request.getParameter("orgid");
	var usrid = request.getParameter("usrid");
	var loginuserid = request.getParameter("loginuserid");
	var loginpwd = request.getParameter("loginpwd");
	var appid = request.getParameter("appid");
	
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "select guid from usr where org='"+orgid+"' and id='"+usrid+"'";
		var usrguid = db.GetSQL(sql);
		sql = "select guid from app_acount where org='"+orgid+"' and appid='"+appid+"'";
		var appguid = db.GetSQL(sql);
		
		sql = "insert into app_careacount(org,usrguid,appguid,caretime,carestat,loginuserid,loginpasswd)
			values('%s','%s','%s',sysdate,'1','%s','%s')".format([orgid,usrguid,appguid,loginuserid,loginpwd]);
		db.ExcecutSQL(sql);
		
		return "ok";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}


}