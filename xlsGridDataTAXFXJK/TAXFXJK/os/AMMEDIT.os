function TAXFXJK_AMMEDIT(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");

function del()
{
	try {
		var sql = "delete from tax_cmpammno where guid='"+guid+"'";
		var ret = pubpack.EADbTool.ExcecutSQL(sql);
		return ret;
	}
	catch(e) {
		return e.toString();
	}
}
//添加权限函数
function qx(){

	return 1;
}
}