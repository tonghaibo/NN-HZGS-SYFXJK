function x_flowOAMain(){var pub= new JavaPackage("com.xlsgrid.net.pub");
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

function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
  
  sb.append("<script>\n");
  var CURMWID =pubpack.EAFunc.NVL(request.getParameter("mwid"),"");
  var selsytid=pubpack.EAFunc.NVL(request.getParameter("selsytid"),"");
  sb.append("\nvar G_CURSYTID=\""+selsytid+"\";");
  sb.append("\nvar CURMWID =\""+CURMWID +"\";");
  sb.append("\nvar selsytid=\""+selsytid+"\";");
  sb.append("</script>");
}
  
function save()
{
  //xmlstr = pub.EAFunc.XmlToStd(xmlstr);
  xmlstr = XmlToStd(xmlstr);
  var path = basePath + pub.EAOption.get("xmldb.file.grddb")+"/syt" + selsytid + "/" + xmlfile;
  pub.EAFunc.WriteToFile(path,xmlstr);

	var db = null;
	var msg= "";
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		
		//���浽���ݿ�
		  if(typ=="process"){
		  	try {
			  db.ExcecutSQL("create table sysprocess ( guid char(32) default sys_guid() primary key,id varchar2(20),name varchar2(256),note varchar2(256),grdid varchar2(256) , sytid varchar2(20),subclass varchar2(20), nextname varchar2(20) )");
			}
			catch ( e ){}
			try {
			  db.ExcecutSQL("create view V_USRROL table sysprocess ( guid char(32) default sys_guid() primary key,id varchar2(20),name varchar2(256),note varchar2(256),grdid varchar2(256) , sytid varchar2(20) )");
			}
			catch ( e ){}
			try {
			  db.ExcecutSQL("create view  v_sytrol as select id,name ,syt thissytid from rol ");
			}
			catch ( e ){}
		
			try {
			  db.ExcecutSQL("alter table sysprocess add NEXTNAME varchar2(256),SUBCLASS varchar2(256)  ");
			}
			catch ( e ){}
			try {
			  db.ExcecutSQL("alter table sysprocess add TOROL varchar2(256)  ");
			}
			catch ( e ){}			
		
		  	try {
			  db.ExcecutSQL("delete from  sysprocess where grdid='"+thisgrdid+"' and sytid='"+selsytid+"'");
			}
			catch ( e ){}
			  var ds = new pub.EAXmlDS(xmlstr);
			  for ( var i=0;i<ds.getRowCount();i++){
			  	if (ds.getStringAt(i,"ID")!="") 
			  	db.ExcecutSQL("insert into sysprocess (id,name,note,grdid,sytid,nextname,subclass,TOROL ) values('"+ds.getStringAt(i,"ID")+"','"+ds.getStringAt(i,"NAME")+"','"+ds.getStringAt(i,"NOTE")+"','"+thisgrdid+"','"+selsytid+"','"+ds.getStringAt(i,"NEXTNAME")+"','"+ds.getStringAt(i,"SUBCLASS")+"','"+ds.getStringAt(i,"TOROL")+"')");
			  
			  }
		  }
		  if(typ=="action"){
		  	try {
			  db.ExcecutSQL("create table sysaction ( guid char(32) default sys_guid() primary key,grdid varchar2(256) , sytid varchar2(20) ,id varchar2(20),name varchar2(256),note varchar2(256),srcid varchar2(20),DESTID varchar2(20),WFWHERE varchar2(256),ACTMW varchar2(20),TRKTYP varchar2(20),TOROL varchar2(20),TOUSR varchar2(20),USECOLLIST varchar2(256),ISMESS varchar2(2) ,CHKNOTECOLUMN varchar2(100))");
			}
			catch ( e ){}
			try {
			  db.ExcecutSQL("delete from  sysaction where grdid='"+thisgrdid+"' and sytid='"+selsytid+"'");
			}
			catch ( e ){}
			  var ds = new pub.EAXmlDS(xmlstr);
			  for ( var i=0;i<ds.getRowCount();i++){
			  	if (ds.getStringAt(i,"ID")!="") 
			  	db.ExcecutSQL("insert into sysaction (id,name,note,grdid,sytid,SRCID,DESTID,WFWHERE,ACTMW,TRKTYP,TOROL,TOUSR,USECOLLIST ,ISMESS,CHKNOTECOLUMN) values('"+ds.getStringAt(i,"ID")+"','"+ds.getStringAt(i,"NAME")+"','"+ds.getStringAt(i,"NOTE")+"', "+
			  		"'"+thisgrdid+"','"+selsytid+"','"+ds.getStringAt(i,"SRCID")+"','"+ds.getStringAt(i,"DESTID")+"','"+ds.getStringAt(i,"WHERE")+"','"+ds.getStringAt(i,"ACTMW")+"','"+ds.getStringAt(i,"TRKTYP")+"',"+
				  	"'"+ds.getStringAt(i,"TOROL")+"','"+ds.getStringAt(i,"TOUSR")+"','"+ds.getStringAt(i,"USECOLLIST")+"','"+ds.getStringAt(i,"ISMESS")+"','"+ds.getStringDef(i,"CHKNOTECOLUMN","")+"')");
			  
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


  	  
  //if(typ=="action")
  //	  pub.EADbTool.ExcecutSQL("create table sysaction ( guid char(32) default sys_guid() primary key,id varchar2(20),name varchar2(256),note varchar2(256),grdid varchar2(256) , sytid varchar2(20) ");
  

  return "����ɹ�!";
}
 
function delBilDef()
{
  var path = basePath + pub.EAOption.get("xmldb.file.grddb")+"/syt" + sytid + "/" + xmlfile;
  var f = new java.io.File(path);
  var ok = f.delete();
  if(ok)
    return "ɾ���ɹ���" ;
  else
    return "ɾ��ʧ�ܣ������ļ�����ʹ�á�";
}


//================================================================// 
// ������GetSytList
// ˵�����õ����е�ϵͳ����
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�03/14/06 11:58:50
// �޸���־��
//================================================================// 
function GetSytList()
{
//"<?xml version = '1.0' encoding='GBK'?>";
//        xml+="<�м������>";
        var xml = "";
        var sytds = xmldbpack.EASYTXmlDB.getSytDS();
        for( var i=0;i< sytds.getRowCount(); i ++ ) {
              var selsytid = sytds.getStringAt(i,"ID");
              xml+="<"+selsytid+" imageid=\"0\" sytflg=\""+selsytid+"\">";      // sytflg˵���ýڵ���һ��ϵͳ
              //xml+="<����ͼ selgrdtyp=\"S\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
              xml+="<�����м�� selgrdtyp=\"B\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
              xml+="<�����м�� selgrdtyp=\"R\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
              xml+="<��ѯ�м�� selgrdtyp=\"Q\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
              xml+="<���м�� selgrdtyp=\"F\" imageid=\"0\" sytflg=\""+selsytid+"\"/>";
              xml+="<�Զ����м�� selgrdtyp=\"M\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
	
              xml+="</"+selsytid+">";
        }    
 //       xml+="</�м������>";
        return xml;
}

// �õ�ĳһ��������ͼ
function loadDataflwGraph()
{

  var path = pub.EAOption.dynaDataRoot+ pub.EAOption.get("xmldb.file.grddb")+"/syt" + selsytid + "/" + filename;
 
    return pub.EAFunc.readFile(path);
}

// �õ������б�
function GetGrdList()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var ds = xmldbpack.EAGRDXmlDB.getSytWMList(selsytid,selgrdtyp);
	if ( ds == null ) return "";
	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"MWID");
		var name = ds.getStringAt(i,"NAME");

		xml+="<"+id + " name=\""+name+"\" id=\""+id+"\" selgrdtyp=\""+grdtyp+"\" sytflg=\""+selsytid+"\" />";

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

}