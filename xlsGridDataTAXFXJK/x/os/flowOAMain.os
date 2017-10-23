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
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		
		//保存到数据库
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
  

  return "保存成功!";
}
 
function delBilDef()
{
  var path = basePath + pub.EAOption.get("xmldb.file.grddb")+"/syt" + sytid + "/" + xmlfile;
  var f = new java.io.File(path);
  var ok = f.delete();
  if(ok)
    return "删除成功！" ;
  else
    return "删除失败，可能文件正在使用。";
}


//================================================================// 
// 函数：GetSytList
// 说明：得到所有的系统名称
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：03/14/06 11:58:50
// 修改日志：
//================================================================// 
function GetSytList()
{
//"<?xml version = '1.0' encoding='GBK'?>";
//        xml+="<中间件对象>";
        var xml = "";
        var sytds = xmldbpack.EASYTXmlDB.getSytDS();
        for( var i=0;i< sytds.getRowCount(); i ++ ) {
              var selsytid = sytds.getStringAt(i,"ID");
              xml+="<"+selsytid+" imageid=\"0\" sytflg=\""+selsytid+"\">";      // sytflg说明该节点是一个系统
              //xml+="<流程图 selgrdtyp=\"S\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
              xml+="<单据中间件 selgrdtyp=\"B\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
              xml+="<报表中间件 selgrdtyp=\"R\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
              xml+="<查询中间件 selgrdtyp=\"Q\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
              xml+="<表单中间件 selgrdtyp=\"F\" imageid=\"0\" sytflg=\""+selsytid+"\"/>";
              xml+="<自定义中间件 selgrdtyp=\"M\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
	
              xml+="</"+selsytid+">";
        }    
 //       xml+="</中间件对象>";
        return xml;
}

// 得到某一个数据流图
function loadDataflwGraph()
{

  var path = pub.EAOption.dynaDataRoot+ pub.EAOption.get("xmldb.file.grddb")+"/syt" + selsytid + "/" + filename;
 
    return pub.EAFunc.readFile(path);
}

// 得到单据列表
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

// 得到某一个工作流process
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