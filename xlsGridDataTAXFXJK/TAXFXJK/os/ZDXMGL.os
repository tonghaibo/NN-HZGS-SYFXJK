function TAXFXJK_ZDXMGL(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

//替换SQL参数
function replaceParam(mwobj,request,sql)
{
//	var isget = request.getParameter("ISGET");
//	if (isget == "0") {
//		sql = pub.EAFunc.Replace(sql,"[%ISGETSTR]"," and zbdwsbh=0");
//	}
//	else if (isget == "1") {
//		sql = pub.EAFunc.Replace(sql,"[%ISGETSTR]"," and zbdwsbh>0");
//	}
//	else {
//		sql = pub.EAFunc.Replace(sql,"[%ISGETSTR]","");
//	}
//	
//	return sql;
}


function setZDXMFlag()
{
	var db = null ;
	var sql = "";
	var ret = 0;

	try {		
		db = new pub.EADatabase();
		sql = "update TAX_ZDXM_FGWXM set zdbz='"+zdbz+"' where fgwxmuuid in ("+pub.EAFunc.SQLIN(guids)+")";
		ret = db.ExcecutSQL(sql);
		db.Commit();
		return "标注成功，记录数"+ret;
	}
	catch(e) {
		if(db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if(db != null) db.Close();
	}
}

}