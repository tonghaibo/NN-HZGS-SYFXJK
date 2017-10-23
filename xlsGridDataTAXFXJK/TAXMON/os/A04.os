function TAXMON_A04(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//Ìæ»»SQL²ÎÊý
function replaceParam(mwobj,request,sql)
{
	var hy = pub.EAFunc.NVL(request.getParameter("HY"),"");
	//throw new Exception(hy);
	if (hy != "") {
		hy = " and c.id in ("+pub.EAFunc.SQLIN(hy)+")";
	}
	sql = pub.EAFunc.Replace(sql,"[%HYCLS]",hy);
	
	return sql;
	
}

}