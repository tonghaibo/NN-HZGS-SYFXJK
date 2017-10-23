function TAXFXJK_JXSFCSWHB(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");

function del()
{
	try {
		var sql = "delete from TAX_JIAXSFCSB where jiaxsfcsuuid='"+guid+"'";
		var ret = pubpack.EADbTool.ExcecutSQL(sql);
		return ret;
	}
	catch(e) {
		return e.toString();
	}
}
}