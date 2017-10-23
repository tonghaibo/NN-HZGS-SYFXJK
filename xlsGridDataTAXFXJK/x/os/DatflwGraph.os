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
// 得到某一个数据流
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
// 由于目前没有数据流单据的对应关系，暂时从Datflwsrc取数
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
// 得到单据列表
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
// 得到单据列表
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
// 得到数据流来源列表
function GetDatflwsrc()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var ds = xmldbpack.EAXmlDB.getFlwLnkSrcDs(selsytid);
	var ds1= new pubpack.EAXmlDS();

	//为了得到名称
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
			destid = id.substring(index +1);	// 由于目前没有数据流单据的对应关系，暂时从LnkID得到destid
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
// 得到数据流目标列表
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