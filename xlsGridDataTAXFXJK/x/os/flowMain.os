function x_flowMain(){var pub= new JavaPackage("com.xlsgrid.net.pub");
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
  var xmlfile=pubpack.EAFunc.NVL(request.getParameter("xmlfile"),"");
  var selsytid=pubpack.EAFunc.NVL(request.getParameter("selsytid"),"");
  sb.append("\nvar CURFILENAME =\""+xmlfile+"\";");
  sb.append("\nvar G_CURSYTID=\""+selsytid+"\";");
  sb.append("\nvar xmlfile=\""+xmlfile+"\";");
  sb.append("\nvar selsytid=\""+selsytid+"\";");
  sb.append("</script>");
}
  
function save()
{
  //xmlstr = pub.EAFunc.XmlToStd(xmlstr);
  xmlstr = XmlToStd(xmlstr);
  var path = basePath + pub.EAOption.get("xmldb.file.grddb")+"/syt" + selsytid + "/" + xmlfile;
  pub.EAFunc.WriteToFile(path,xmlstr);

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

}