function x_LSYSURLED(){var pubpack= new JavaPackage("com.xlsgrid.net.pub");
var pub = new JavaPackage("com.xlsgrid.net.pub");

var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var utilpack = new JavaPackage ( "java.util");
var basePath = pubpack.EAOption.dynaDataRoot;
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
  
  sb.append("<script>\n");
  var thisorgid=pubpack.EAFunc.NVL(request.getParameter("thisorgid"),webpack.EAWebDeforg.GetDeforg(request));
  sb.append("\nvar thisorgid=\""+thisorgid+"\";");
  sb.append("</script>");
  sb.append("<input type='file' id='imgfile' style='display:none' onchange='upload();'>\n");
  
}
  
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
  bodysb.insert(0,"<form id=\"myfilef\"><input type=\"file\" id=\"myfile\" style=\"display:none\"></input></form>");//
}  

// ����xlsGridData��web
// ���� deforg  sysurlid 
function copytoweb()
{
	var srcpath = basePath +"webresource/images/"+ deforg  + "/"+sysurlid+"/"; 
	var destpath = pubpack.EAOption.approot+"/images/"+ deforg  + "/"+sysurlid+"/";
	pubpack.EAFunc.copyDirectiory(srcpath,destpath,"","CVS",true );
	return "����ˣ��ļ��Ѵ�"+ srcpath +"ͬ����"+destpath ;
}

//��ʾ��ѯ����ǰԤ����
//�����ڲ�ѯ�򱨱���ʾ��ѯ����ǰ��Ԥ����
//������sb��StringBuffer����append HTML���ݻ���⸽���ű�
//�����޸�paramDs�����ݣ�������Щ�����ɼ����޸�Ĭ��ֵ
//  ID:���;  NAME:����; KEYVAL:�ؼ���; SQLWHE:WHERE����; DEFVAL:Ĭ��ֵ
//  TIP:��ʾ; EDTFLG:�Ƿ���޸�;  VISFLG:�Ƿ����ʾ; KEYFLG:�ؼ��ֶ�(û������)
//  DISPORD:������ʾ�����(�޸���Ч); INPCTL:�ؼ�����
function beforeShowParam(request,sb,paramDs,usrinfo)
//var request=javax.servlet.http.HttpServletRequest(); var sb = new java.lang.StringBuffer();var paramDs = new EAXmlDS();var usrinfo = new web.EAUserinfo();
{
	for (var r = 0; r < paramDs.getRowCount(); r ++) {
		if (paramDs.getStringAt(r,"ID") == "menu") {
			var showmenu = pubpack.EAFunc.NVL(request.getParameter("showmenu"),"");
			if (showmenu == "1") paramDs.setValueAt(r,"VISFLG","0");
		}
	}
}

// �ͻ���param����Ĳ�������ֱ��ʹ��
function save()
{
	var db = null;
	var sql= "";
	var msg= "";
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var ds = new pubpack.EAXmlDS(xmlstr);	// �ͻ��˿��Դ���һ��xml
		var EAfunc = new pubpack.EAFunc();
		
		for ( var row=0;row<ds.getRowCount();row ++ ) {
			var guid = ds.getStringAt(row,"GUID");
			var org = ds.getStringAt(row,"ORG");
			var refid = ds.getStringAt(row,"REFID");
			var id = ds.getStringAt(row,"ID");
			var name = ds.getStringAt(row,"NAME");
			var note = ds.getStringAt(row,"NOTE");
			var icon = ds.getStringAt(row,"ICON");
			var icon2 = ds.getStringAt(row,"ICON2");
			var seqid = ds.getStringAt(row,"SEQID");
			var htmlguid = ds.getStringAt(row,"HTMLGUID");
			var url = ds.getStringAt(row,"URL");
			var target = ds.getStringAt(row,"TARGET");
			var contextes= ds.getStringAt(row,"contextes");
			
			if (guid != ""){
				sql = "update lsysurl set refid='%s',name='%s',note='%s',icon='%s',icon2='%s',seqid='%s',htmlguid ='%s',url='%s',target='%s',contextes='%s' where guid='%s'"
					.format([refid,name,note,icon,icon2,seqid,htmlguid,url,target,contextes,guid]);
					
				db.ExcecutSQL(sql);
			} else {
				if (org != "" && refid != "" && id != "") {
					sql = "insert into lsysurl (guid,org,refid,id,name,note,icon,icon2,seqid,htmlguid,url,target) values (sys_guid(),'%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s')"
						.format([org,refid,id,name,note,icon,icon2,seqid,htmlguid,url,target,contextes]);
					db.ExcecutSQL(sql);
				}
			}
		}
		
		db.Commit();
		msg = "����ɹ�!";
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

// �ͻ���param����Ĳ�������ֱ��ʹ��
function delt()
{
	var db = null;
	var sql = "";
	var cnt = 0;
	var msg = "";
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var ds = new pubpack.EAXmlDS(xmlstr);	// �ͻ��˿��Դ���һ��xml
		
		for ( var row=0;row<ds.getRowCount();row ++ ) {
			var flg = ds.getStringAt(row,"FLG");
			var guid = ds.getStringAt(row,"GUID");
			
			if (flg == "1") {
				sql = "delete from lsysurl where guid='"+guid+"'";
				cnt += db.ExcecutSQL(sql);
			}
		}
		
		db.Commit();
		msg = "ɾ���ɹ�! �� "+cnt+" ��";
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