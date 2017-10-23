function TAXFXJK_CR01(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var web = new JavaPackage ( "com.xlsgrid.net.web" );

//显示查询参数前预处理
//用于在查询或报表显示查询参数前的预处理。
//可以往sb（StringBuffer）中append HTML内容或额外附近脚本
//可以修改paramDs的内容，决定哪些参数可见或修改默认值
//  ID:编号;  NAME:标题; KEYVAL:关键字; SQLWHE:WHERE条件; DEFVAL:默认值
//  TIP:提示; EDTFLG:是否可修改;  VISFLG:是否可显示; KEYFLG:关键字段(没有作用)
//  DISPORD:参数显示次序号(修改无效); INPCTL:控件类型
function beforeShowParam(request,sb,paramDs,usrinfo)
//var request=javax.servlet.http.HttpServletRequest(); var sb = new java.lang.StringBuffer();var paramDs = new EAXmlDS();var usrinfo = new web.EAUserinfo();
{
	//throw new Exception(paramDs.GetXml());
	var usrinfo = web.EASession.GetLoginInfo(request);
	var usrorg = usrinfo.getusrOrg();
	var usrid = usrinfo.getUsrid();
//	var ds = pub.EADbTool.QuerySQL("select a.*,nvl(b.SCOPE,'NO') SCOPE from usr a,v_depts b where a.deptid=b.id and a.org=b.org and a.org='"+usrorg+"' and a.id='"+usrid+"'");
//	if (ds.getRowCount() > 0) {
//		var scope = ds.getStringAt(0,"SCOPE");
//		if (scope != "ALL") {
//			paramDs.setValueAt(8,11,"0");
//		}
//	}
}

//替换SQL参数
function replaceParam(mwobj,request,sql)
{
	var gds = request.getParameter("GDS");
	if (gds != "") {
		sql = pub.EAFunc.Replace(sql,"[%GDSSTR]","and nvl(a.gds,'') IN (select name from v_tax_gds where ID like '"+gds+"%')");
	}
	else {
		sql = pub.EAFunc.Replace(sql,"[%GDSSTR]","");
	}
	
	var usrinfo = web.EASession.GetLoginInfo(request);
	var usrorg = usrinfo.getusrOrg();
	var usrid = usrinfo.getUsrid();
	var swjg_dm = request.getParameter("SWJG_DM");
	if (swjg_dm == "1451100") {
		sql = pub.EAFunc.Replace(sql,"[%SWJGSTR]"," ");
	}
	else {
		sql = pub.EAFunc.Replace(sql,"[%SWJGSTR]"," and b.swjg_dm like '"+swjg_dm+"%'");
	}

	
	return sql;
}

}