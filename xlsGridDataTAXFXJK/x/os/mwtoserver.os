function x_mwtoserver(){//ҳ��BODY������Ϻ��¼�
//sb������bodyԪ�ؼ�ǰ���head����
//bodysb������body��innerHTML
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
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var ds = new pubpack.EAXmlDS(xml);	// �ͻ��˿��Դ���һ��xml
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
	msg ="������"+cnt+"�ʼ�¼"+msg;
	return msg;
}


}