function TAXFXJK_FDCCSWHB(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");

function del()
{
	try {
		var sql = "delete from TAX_FDCKFQYMC_NSRSBH_DZB where fdcdzuuid='"+guid+"'";
		var ret = pubpack.EADbTool.ExcecutSQL(sql);
		return ret;
	}
	catch(e) {
		return e.toString();
	}
}
}