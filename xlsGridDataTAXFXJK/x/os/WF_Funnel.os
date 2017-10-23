function x_WF_Funnel(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var dbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
// 客户端param传入的参数可以直接使用
//wfsytid ,wfgrdid, thisaccid,dat1,dat2
function querydtl()
{
	var db = null;
	var msg= "RUN OK";
	var xml = "";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		//var usrinfo = webpack.GetLogin
		var grdxml = new dbpack.EAGRDXmlDB(wfsytid ,wfgrdid);
		var tablename=grdxml.getGrdDS().getStringDef(0,"BILHDRTABLE","BILHDR");
		var collist = grdxml.getGrdDS().getStringDef(0,"COLLIST","");
		if(collist == "" ) collist = "a.BILID 编号,a.DAT 日期,to_char(a.CRTDAT,'YYYY-MM-DD HH24:MI:SS') 创建时间";
          	//String mysql = "select a.stat,count(*) cnt from "+tablename+" a where a.acc='"+thisaccid+"' ";
          	//mysql+=" group by a.stat ";

          	//EAXmlDS ds=db.QuerySQL(mysql);
		var sql = "select a.guid 内部编码,"+collist +",c.name 创建人姓名,a.stat 状态码,b.name 状态 from "+tablename+" a, sysprocess b,usr c where b.sytid='"+wfsytid +"' and b.grdid='"+wfgrdid+"' and a.stat=b.id "+
			" and a.org=c.org and a.crtusr=c.id "+
			" and to_char(a.crtdat,'YYYY-MM-DD')>='"+dat1+"' and  to_char(a.crtdat,'YYYY-MM-DD')<='"+dat2+"' "+
			" order by a.stat desc,a.crtdat desc ";
		var statds = db.QuerySQL(sql);
		return statds.GetXml();
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}
}