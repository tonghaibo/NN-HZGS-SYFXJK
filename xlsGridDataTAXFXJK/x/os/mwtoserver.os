function x_mwtoserver(){//页面BODY处理完毕后事件
//sb里面是body元素及前面的head内容
//bodysb里面是body的innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
  bodysb.insert(0,"<form id=\"myfilef\"><input type=\"file\" id=\"myfile\" style=\"display:none\"></input></form>");
}

var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
function uploadsysurl()
{
	var db = null;
	var msg= "";
	var cnt = 0 ;
	var sql = "";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var ds = new pubpack.EAXmlDS(xml);	// 客户端可以传入一个xml
		for ( var row=0;row<ds.getRowCount();row ++ ) {
		
			sql = "insert into sysurl(org,name,note,url,icon,seqid,refid,id,layoutitem,supperid,target,icon2) "+
				"values('"+myorgid+"','"+ds.getStringAt(row,"name")+"','"+ds.getStringAt(row,"note")+"','" +
				ds.getStringAt(row,"url")+"','"+ds.getStringAt(row,"icon")+"','"+ds.getStringAt(row,"seqid")+"','"+ds.getStringAt(row,"refid")+"',"+
				"seq_sysurl.nextval,'"+ds.getStringAt(row,"layoutitem")+"','"+ds.getStringAt(row,"supperid")+"','"+ds.getStringAt(row,"target")+"','"+ds.getStringAt(row,"icon2")+"')";
			try{
				cnt +=db.ExcecutSQL(sql);
			}
			catch (  e){
				msg+=e.toString();
			
			}
		}
			
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	msg ="操作了"+cnt+"笔记录"+msg;
	return msg;
}


}