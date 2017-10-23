function TAXMON_B02(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//Ìæ»»SQL²ÎÊý
function replaceParam(mwobj,request,sql)
{
	var taxman = pub.EAFunc.NVL(request.getParameter("TAXMAN"),"");
	//throw new Exception(hy);
	if (taxman != "") {
		taxman = " and tousr in ("+pub.EAFunc.SQLIN(taxman)+")";
	}
	sql = pub.EAFunc.Replace(sql,"[%TAXMAN]",taxman);
	
	return sql;
	
}


}