function x_CARD_SMT(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var webget = new JavaPackage("com.xlsgrid.net.webget");
var httpcall = new webget.HttpCall();
var HtmlParser = new x_WG_HtmlParser();

var cvshome = pub.EAOption.dynaDataRoot;
var hostname = "http://www.smartpass.com.cn";


//下载
function downLoad()
{
	var db = null;
	var sql = "";
	var ret = "";
	var dat = "";
	var code = "GBK";
	var pageNo = 10;//每一页显示的记录数
	var pageCount = 0;//总的记录数
	var pageSize = 0;//总的页数【（总的记录数+每一页显示的记录数-1）/每一页显示的记录数】
	try {
		db = new pub.EADatabase();
		ret = httpcall.Post(hostname+"/cl_login.asp","btn1.x=44&btn1.y=6&mch_no="+userid+"&password="+passwd,code);
		ret = httpcall.Get(hostname+"/league/duizhang.asp",code);
		
		pageCount = 1.0*db.GetSQL("select to_date('"+enddat+"','yyyy-mm-dd')-to_date('"+startdat+"','yyyy-mm-dd')+1 from dual");
		pageSize = (pageCount+pageNo-1)/pageNo ; 
		
		for(var r = 1;r <= pageSize ;r ++)
		{
			ret = httpcall.Post(hostname+"/league/duizhang.asp","begin_date="+startdat+"&cmd=&end_date="+enddat+"&pg="+r+"&x=30&y=8",code);
			var nodelist = HtmlParser.parserHtml(ret,code);	
			return ret ;
			var tablist = HtmlParser.filterHtml(nodelist,"table");
			return tablist ;
			var ds = HtmlParser.parserTable(tablist,code,new Array("2"),"O");
		}  
		
		
	}
	catch ( e ) 
	{
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}
}