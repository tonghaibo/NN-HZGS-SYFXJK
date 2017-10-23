function TAXFXJK_ELeALL(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//Ìæ»»SQL²ÎÊý
function replaceParam(mwobj,request,sql)
{
	var hy = pub.EAFunc.NVL(request.getParameter("TYPCLSID"),"");
	var gds = pub.EAFunc.NVL(request.getParameter("GDS"),"");
	if (hy != "") {
		sql = pub.EAFunc.Replace(sql,"[%TYPCLSID]","and b.typclsid like '"+hy+"%'");
	}
	if (gds != "") {
		sql = pub.EAFunc.Replace(sql,"[%GDS]","and a.gds in (select name from v_tax_gds where id='"+gds+"')");
	}
	return sql;
}

}