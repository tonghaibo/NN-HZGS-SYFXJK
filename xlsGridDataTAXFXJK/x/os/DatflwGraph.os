function x_DatflwGraph(){var pub= new JavaPackage("com.xlsgrid.net.pub");
var pubpack= new JavaPackage("com.xlsgrid.net.pub");
var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var utilpack = new JavaPackage ( "java.util");
var basePath = pubpack.EAOption.dynaDataRoot;

//var flwLnkdbpath = pub.EAOption.getRealpath()+pub.EAOption.get("xmldb.file.flwLnkdb");
var basePath = pub.EAOption.dynaDataRoot;

  function  XmlToStd(xml)
  {
      xml = pub.EAFunc.Replace(xml, "&"+"quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"amp;quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"apos;", "'"  );
    return xml;
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
// �õ�ĳһ��������
function loadDataflw()
{

  var path = pub.EAOption.dynaDataRoot+ pub.EAOption.get("xmldb.file.flwLnkdb")+"/syt" + selsytid + "/" + datflwid+".xml";
 
  try
  {
    return pub.EAFunc.readFile(path);
  }
  catch(e)
  {
    var temp = pub.EAOption.dynaDataRoot + pub.EAOption.get("xmldb.file.flwLnkdb") + "/sytx/template.xml";
    return pub.EAFunc.readFile(temp );
  }
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
// ����Ŀǰû�����������ݵĶ�Ӧ��ϵ����ʱ��Datflwsrcȡ��
function GetFlwList()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var ds = xmldbpack.EAXmlDB.getFlwLnkDestDs(selsytid);

	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"LnkID");
		var name = ds.getStringAt(i,"DESC");

		xml+="<"+id + " name=\""+name+"\" id=\""+id+"\" sytflg=\""+selsytid+"\" />";

	}
	return xml;

}
// �õ������б�
function GetGrdList()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var ds = xmldbpack.EAGRDXmlDB.getSytWMList(selsytid,selgrdtyp);
	
	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"MWID");
		var name = ds.getStringAt(i,"NAME");

		xml+="<"+id + " name=\""+name+"\" id=\""+id+"\" selgrdtyp=\""+grdtyp+"\" sytflg=\""+selsytid+"\" />";

	}
	return xml;
}
// �õ������б�
function GetBillDSList()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var ds = xmldbpack.EAGRDXmlDB.getSytWMList(selsytid,"B");
	var ds1= new pubpack.EAXmlDS();

	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"MWID");
		var name = ds.getStringAt(i,"NAME");
		var newrow = ds1.AddRow(ds1.getRowCount()-1);
		ds1.setValueAt(newrow,"MWID" ,id );
		ds1.setValueAt(newrow,"NAME" ,name );
	}
	return ds1.GetXml();
	
}
// �õ���������Դ�б�
function GetDatflwsrc()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var ds = xmldbpack.EAXmlDB.getFlwLnkSrcDs(selsytid);
	var ds1= new pubpack.EAXmlDS();

	//Ϊ�˵õ�����
	var bilds = xmldbpack.EAGRDXmlDB.getSytWMList(selsytid,"B");
	var bilds1= new pubpack.EAXmlDS();
	for ( var i=0;i<bilds.getRowCount() ; i ++ ) {
		var id =bilds.getStringAt(i,"MWID");
		var name = bilds.getStringAt(i,"NAME");
		var newrow = bilds1.AddRow(bilds1.getRowCount()-1);
		bilds1.setValueAt(newrow,"MWID" ,id );
		bilds1.setValueAt(newrow,"NAME" ,name );
	}
	
	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"LnkID");
		var srcid = ds.getStringAt(i,"SRCCLS");
		var destid = "";
		var index = id .indexOf("2");
		if ( index > 0 ) 
			destid = id.substring(index +1);	// ����Ŀǰû�����������ݵĶ�Ӧ��ϵ����ʱ��LnkID�õ�destid
		var newrow = ds1.AddRow(ds1.getRowCount()-1);
		ds1.setValueAt(newrow,"ID" ,id );
		ds1.setValueAt(newrow,"SRCID" ,srcid );
		ds1.setValueAt(newrow,"DESTID" ,destid );
		var srcnam= "";
		var destnam= "";
		for ( var j=0;j<bilds1.getRowCount() ;j++ ) {
			if ( bilds1.getStringAt(j,"MWID") == srcid ) {
				srcnam= bilds1.getStringAt(j,"NAME"); 
				break;
			}
		}
		for ( var j=0;j<bilds1.getRowCount() ;j++ ) {
			if ( bilds1.getStringAt(j,"MWID") == destid ) {
				destnam= bilds1.getStringAt(j,"NAME"); 
				break;
			}
		}
		ds1.setValueAt(newrow,"SRCNAM" ,srcnam);
		ds1.setValueAt(newrow,"DESTNAM" ,destnam);
	}
	return ds1.GetXml();


}
// �õ�������Ŀ���б�
function GetDatflwdest()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var ds = xmldbpack.EAXmlDB.getFlwLnkDestDs(selsytid);
	return ds.GetXml();
	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"LnkID");
		var name = ds.getStringAt(i,"DESC");

		xml+="<"+id + " name=\""+name+"\" id=\""+id+"\" sytflg=\""+selsytid+"\" />";

	}
	return xml;

}
}