function TAXFXJK_ORGUSER(){var pub= new JavaPackage("com.xlsgrid.net.pub");
var pubpack= new JavaPackage("com.xlsgrid.net.pub");
var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var utilpack = new JavaPackage ( "java.util");
var basePath = pubpack.EAOption.dynaDataRoot;

  function  XmlToStd(xml)
  {
      xml = pub.EAFunc.Replace(xml, "&"+"quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"amp;quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"apos;", "'"  );
    return xml;
  }
//��ѯĳ��org�µĽڵ�
//������� thisorgid�� thisid
function GetOrgList()
{
        var xml = "";
        var sytds = null;
        var sql = "select a.id, name from loc a where org ='"+thisorgid+"' ";
        if ( thisid == "" ) sql += " and refid is null ";
        else if ( thisid=="all" ) sql += " and 1<0 ";//���ֲ���

        else sql += " and refid='"+thisid+"'";
	
        sql+=" order by a.id ";
	
        try {	
	        sytds=pubpack.EADbTool.QuerySQL(sql);
	}catch ( e ){
		
		pubpack.EADbTool.ExcecutSQL("alter table loc add refid varchar2(20) ");
	        sytds=pubpack.EADbTool.QuerySQL(sql);

	}
        for( var i=0;i< sytds.getRowCount(); i ++ ) {
              
              var name = sytds.getStringAt(i,"NAME");
              xml+="<"+name +" imageid=\"0\" deptid=\""+sytds.getStringAt(i,"id")+"\" orgid=\""+thisorgid+"\" flag=\"dept\" >";      // sytflg˵���ýڵ���һ��ϵͳ
              
              xml+="</"+name +">";
        }  
        if ( thisid == "" ) { 
              xml+="<���ֲ��������û� imageid=\"0\" deptid=\"all\" orgid=\""+thisorgid+"\" flag=\"dept\" ></���ֲ��������û�>";      
              xml+="<������Ϣά�� imageid=\"1\"  orgid=\""+thisorgid+"\" flag=\"modifydept\" ></������Ϣά��>";      
	}
	
	if (sytds.getRowCount()==0){//˵��û�в����ˣ���Ҫ��ѯ
		
        	sql ="select id,name from usr where org='"+thisorgid+"' and useflg='1' ";
        	if  ( thisid=="all" ) sql += " ";//���ֲ���
        	else	sql += " and deptid='"+thisid+"' " ;
		
        	sytds=pubpack.EADbTool.QuerySQL(sql+" order by id " );
    	
		
		for( var i=0;i< sytds.getRowCount(); i ++ ) {
	              var id = sytds.getStringAt(i,"ID");

	              var name = sytds.getStringAt(i,"NAME");
	              xml+="<"+name+"("+id+")" +" imageid=\"1\" deptid=\""+thisid+"\" orgid=\""+thisorgid+"\" usrid=\""+id+"\" flag=\"usr\" >";      // sytflg˵���ýڵ���һ��ϵͳ
	              
	              xml+="</"+name+"("+id+")" +">";
	        }    
	        //if ( sytds.getRowCount() >0){
		        xml+="<�����û� imageid=\"1\" deptid=\""+thisid+"\" orgid=\""+thisorgid+"\" usrid=\"\" flag=\"usr\" >";      // sytflg˵���ýڵ���һ��ϵͳ
	                xml+="</�����û�>";
		//}
        
        } 
        return xml;
}
// �õ�ĳһ��������ͼ
function loadDataflwGraph()
{

  var path = pub.EAOption.dynaDataRoot+ pub.EAOption.get("xmldb.file.grddb")+"/syt" + selsytid + "/" + filename;
 
    return pub.EAFunc.readFile(path);
}

// �õ������б�
function GetItemList()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var ds = pubpack.EADbTool.QuerySQL("select a.PCH,b.id,b.name from fracas_pcitem a,v_fracas_item b where a.jc='"+jc+"' and a.xh='"+xh+"' and a.itmid=b.id and b.refid='"+itemclass+"' order by a.itmid ");

	
	if ( ds == null ) return "";
	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"ID");
		var name = ds.getStringAt(i,"NAME");
		var pch =ds.getStringAt(i,"PCH");
		xml+="<"+id + " name=\""+name+"\" itmid=\""+id+"\" pch =\""+pch +"\" xh=\""+xh +"\"  jc=\""+jc +"\" />";

	}
	return xml;
}

// �õ�ĳһ��������process
function loadWorkflw()
{
  var path = pub.EAOption.dynaDataRoot+ pub.EAOption.get("xmldb.file.grddb")+"/syt" + selsytid + "/" + mwid+"."+type;
  try
  {
    return pub.EAFunc.readFile(path);
  }
  catch(e)
  {
  	return "";
  }
}

var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// �ͻ���param����Ĳ�������ֱ��ʹ��
function saveusr()
{
	var db = null;
	var msg= "";
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		
		try {
		  pub.EADbTool.ExcecutSQL("create view V_DESKTOP as select * from param where typ='DESKTOP'");
		}
		catch ( e ){}
		try {
		  pub.EADbTool.ExcecutSQL("create view V_ORGDEPT as select * from loc where useflg='1' and loctyp in ( '0','1','2')");
		}
		catch ( e ){}

		
		
		try {
		  pub.EADbTool.ExcecutSQL("create view V_USERPOST as select * from param where typ='USERPOST'");
		}
		catch ( e ){}
	
		var ds = new pubpack.EAXmlDS(xmlstr);	// �ͻ��˿��Դ���һ��xml
		
		if(ds.getRowCount()==1){
			var guid = ds.getStringAt(0,"GUID");
	
			if ( guid=="") {//����
				var sql ="";
				var collist1="";
				var collist2="";
				guid=db.GetSQL("select sys_guid() from dual" );
				for (var c=0;c<ds.getColumnCount();c++){
					if ( ds.getColumnName(c)!="GUID" ){
						if(c!=0) {collist1+=",";collist2+=",";}
						collist1+=ds.getColumnName(c);
						collist2+="'"+ds.getStringAt(0,c)+"'";
					}
					
				}
				sql= "insert into usr(guid,"+collist1+") values('"+guid+"',"+collist2+")";
				try{
					db.ExcecutSQL(sql);
				}
				catch ( e ){
					if ( 1*db.GetSQL("select count(*) from usr where org='"+ds.getStringAt(0,"ORG")+"' and id='"+ds.getStringAt(0,"ID")+"' " ) >= 1 ) {
						throw new pubpack.EAException ( "�ñ����ظ������������һ������" );					
					}
					
					try {
						db.ExcecutSQL("alter table usr add email varchar2(256)");					
						db.ExcecutSQL(sql);
					}catch ( e1 ){
						throw new pubpack.EAException ( "����ʧ��" +e.toString() );
					}

				}
				msg+=guid;
			
			}
			else{//����
				var sql ="";
				var collist1="";
				var collist2="";
				for (var c=0;c<ds.getColumnCount();c++){
					if ( ds.getColumnName(c)!="GUID" ){
						if(c!=0) {collist1+=",";collist2+=",";}
						collist1+=ds.getColumnName(c)+"='"+ds.getStringAt(0,c)+"'";
					}
					
				}
				sql= "update usr set "+collist1+" where guid='"+ds.getStringAt(0,"guid")+"'";
				try{
					db.ExcecutSQL(sql);
				}
				catch ( e ){
					throw new pubpack.EAException ( "����ʧ��" +e.toString() );
//					db.ExcecutSQL("alter table usr add email varchar2(256)");
//					db.ExcecutSQL(sql);

				}
//				throw new pubpack.EAException	("xhj\n"+ds.GetXml());
				msg+="����ɹ�";			
			}
			
			db.Commit();
		}
			
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
function saveusrrol()
{
	var db = null;
	var msg= "";
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var ds = new pubpack.EAXmlDS(xmlstr);	// �ͻ��˿��Դ���һ��xml
		db.ExcecutSQL("delete from usrrol where usr ='"+usrguid+"'");
		
		for ( var i=0;i<ds.getRowCount();i++){
			var guid = ds.getStringAt(i,"GUID");
			var checkid = ds.getStringAt(i,"CHECKID");
			if ( checkid=="1")
				db.ExcecutSQL("insert into usrrol(usr,rol,acc) values('"+usrguid+"','"+guid+"','"+thisaccid+"') ");
		}
		db.Commit();
		
		msg="�����ɹ�";	
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


function deleteusr()
{
	var db = null;
	var msg= "";
	
	try {
		db = new pubpack.EADatabase();	
		db.ExcecutSQL("delete from usrrol where usr ='"+usrguid+"'");
		db.ExcecutSQL("delete from usr where guid ='"+usrguid+"'");

		db.Commit();
		
		msg="�����ɹ�";	
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

//��Head�����ö���ű�
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("<link rel=\"stylesheet\" href=\"xlsgrid/zTree/css/zTreeStyle/zTreeStyle.css\" type=\"text/css\">\n"); 
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/zTree/js/jquery-1.4.4.min.js\"></script>\n"); 
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/zTree/js/jquery.ztree.core.js\"></script>\n"); 
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/js/json2.js\"></script>\n"); 

	sb.append("<table border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" height=\"100%\"><tr><td bgcolor=\"#EFEFEF\" align=center valign=middle>");
	sb.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" ><tr><td  style=\"border: 1px solid #EEEEEE\">	");
	sb.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" ><tr>");
	sb.append("<td width=25% height=100% style=\"border:solid 1px gray\" valign=top;>");
	
	sb.append("<div style=\"height:5%;\"><br>&nbsp;&nbsp;���ң�<input type='text' id='skey'>&nbsp;&nbsp;<button type='button' onclick='queryTree()'>����</button></div><hr>");
	
	sb.append("<div style=\"overflow-y:scroll;height:100%;\"><ul id=\"treeOrg\" class=\"ztree\"></ul></div></td>");
	sb.append("<td width=85% height=100% style=\"border:solid 1px gray\"  valign=top;><div style=\"overflow-y:scroll;height:100%;\">");

}

//��Ӷ���html
//afterBodyHtml�¼��󴥷����ѹ�ʱ��������afterBodyHtml�¼����д���
function addBottomHtml(mwobj,request,sb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("</div></td></tr></table>");	
	sb.append("</td></tr></table></td></tr></table>");

}


//��֯���ڵ�����
function getOrgTreeJson()
{
	//var json = "[{ id:\"999999\", pId:0,name:\"��֯�ܹ�\",open:true, iconOpen:\"xlsgrid/zTree/css/zTreeStyle/img/diy/1_open.png\", iconClose:\"xlsgrid/zTree/css/zTreeStyle/img/diy/1_close.png\" }";
	var json = "[";
	var db = null;
	try {
		db = new pub.EADatabase();
		//var sql = "select * from org where 1=1";
		//var sql = "select id,name,refid from loc where id='14511000000'";
		var sql = "select * from v_swjg where id='"+thisdeptid+"' or sjid='"+thisdeptid+"' order by id";
		var ds = db.QuerySQL(sql);
		json += "{ id:\"14511\",pId:\"99999\",open:false,name:\"���ݹ�˰��֯��Ա\",orgid:\"14511\",typ:\"ORG\",open:true, iconOpen:\"xlsgrid/zTree/css/zTreeStyle/img/diy/1_open.png\", iconClose:\"xlsgrid/zTree/css/zTreeStyle/img/diy/1_close.png\"}";
				
		for(var i=0;i<ds.getRowCount();i++) {
			var id = ds.getStringAt(i,"ID");
			var orgid = ds.getStringAt(i,"ID");
			var name = ds.getStringAt(i,"NAME");
			//var refid = ds.getStringAt(i,"REFID");
			var refid = ds.getStringAt(i,"SJID");
			if (refid == "") refid = "99999";
			var node = "{ id:\""+id+"\",pId:\"14511\",open:false,name:\""+name+"\",orgid:\""+thisorgid+"\",typ:\"ORG\"}";
//			if (json == "[") {
//				node = "{ id:\""+id+"\",pId:\""+refid+"\",open:false,name:\""+name+"\",orgid:\""+thisorgid+"\",typ:\"ORG\",open:true, iconOpen:\"xlsgrid/zTree/css/zTreeStyle/img/diy/1_open.png\", iconClose:\"xlsgrid/zTree/css/zTreeStyle/img/diy/1_close.png\"}";
//				json += node;
//			}
//			else {
				json += "," + node;			
//			}
			
  			json += getUserTreeJson(db,orgid,skey);
  		}
//  		json += getDeptTreeJson(db,thisorgid);
//  		json += getUserTreeJson(db,thisorgid);
  		json += "]";
	        return json;
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();	
	}       

}

//��ȡ����
function getDeptTreeJson(db,orgid)
{
	var json = "";
	//var sql = "select * from loc where org='"+orgid+"' and id!='14511000000' order by nvl(refid,'0'),id";
	var sql = "select * from v_swjg where sjid='"+orgid+"'";
	var ds = db.QuerySQL(sql);
	for(var i=0;i<ds.getRowCount();i++) {
		var id = ds.getStringAt(i,"ID");
		var name = ds.getStringAt(i,"NAME");
		//var refid = ds.getStringAt(i,"REFID");
		var refid = ds.getStringAt(i,"SJID");
		if (refid == "") refid = orgid;
		var node = "{ id:\""+id+"\",pId:\""+refid+"\",open:false,name:\""+name+"\",orgid:\""+orgid+"\",deptid:\""+id+"\",typ:\"DEPT\"}";
		if (json == "[") {
			json += node;
		}
		else {
			json += "," + node;			
		}
	}
        return json;
}

//��ȡ�û�
function getUserTreeJson(db,orgid,skey)
{
	var json = "";
	//var sql = "select * from usr where org='"+orgid+"' and useflg='1' order by id";
	var sql = "select * from usr where deptid='"+orgid+"' and useflg='1' ";
	if (skey != "") {
		sql += " and (id like '%"+skey+"%' or name like '%"+skey+"%')";
	}
	sql += " order by name,id";
	var ds = db.QuerySQL(sql);
	for(var i=0;i<ds.getRowCount();i++) {
		var id = ds.getStringAt(i,"ID");
		var name = ds.getStringAt(i,"NAME");
		var deptid = ds.getStringAt(i,"DEPTID");
		if (deptid == "") deptid = orgid;
		var node = "{ id:\""+id+"\",pId:\""+deptid+"\",open:false,name:\""+name+"("+id+")"+"\",orgid:\""+orgid+"\",deptid:\""+deptid+"\",typ:\"USR\"}";
		if (json == "[") {
			json += node;
		}
		else {
			json += "," + node;			
		}
	}
        return json;
}



}