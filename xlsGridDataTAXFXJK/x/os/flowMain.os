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

}