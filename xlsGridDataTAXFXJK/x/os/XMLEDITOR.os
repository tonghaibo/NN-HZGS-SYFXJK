function x_XMLEDITOR(){var pub= new JavaPackage("com.xlsgrid.net.pub");
var pubpack= new JavaPackage("com.xlsgrid.net.pub");
var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var basePath = pub.EAOption.dynaDataRoot;

function reloadSysDefine()
{
  return xmldb.EAXmlDB.initXmlDBs();
}

  function  XmlToStd(xml)
  {
      xml = pub.EAFunc.Replace(xml, "&"+"quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"amp;quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"apos;", "'"  );
    return xml;
  }
  
  function StdToXml(xml)
  {
    xml = pub.EAFunc.Replace(xml,"&","&"+"amp;");
    return xml;
  }

function loadXML2DS()
{
  var path = basePath + xmlfile;
  var xml=pub.EAFunc.readFile(path);
  var s1="<"+rowsetid+">";
  var s2="</"+rowsetid+">";
  var r1="<"+rowid+">";
  var r2="</"+rowid+">";
  var r3="<"+rowid+" ";
  xml = pub.EAFunc.Replace(xml,s1,"<ROWSET>");
  xml = pub.EAFunc.Replace(xml,s2,"</ROWSET>");
  xml = pub.EAFunc.Replace(xml,r1,"<ROW>");
  xml = pub.EAFunc.Replace(xml,r2,"</ROW>");
  xml = pub.EAFunc.Replace(xml,r3,"<ROW ");
  
  var ds = new pub.EAXmlDS(xml);
  //如果因意外而出现“_”列，删除之。
  var r=ds.getColumnLoc("_");
  ds.removeColumn(r);
  r=ds.getColumnLoc("num");
  ds.removeColumn(r);
  return ds;
}

function saveDStoFile(ds)
{
  var s1="<"+rowsetid+">";
  var s2="</"+rowsetid+">";
  var r1="<"+rowid+">";
  var r2="</"+rowid+">";
  var r3="<"+rowid+" ";
  setGUID(ds);
  var xml = ds.GetXml();
  //xml = pub.EAFunc.regexReplace(xml,">",">\r");
  xml = pub.EAFunc.Replace(xml,"<ROWSET>",s1);
  xml = pub.EAFunc.Replace(xml,"</ROWSET>",s2);
  xml = pub.EAFunc.Replace(xml,"<ROW>",r1);
  xml = pub.EAFunc.Replace(xml,"</ROW>",r2);
  xml = pub.EAFunc.Replace(xml,"<ROW ",r3);
  xml = pub.EAFunc.regexReplace(xml,"<"+rowid+" .*","<"+rowid+">");
  //xml = pub.EAFunc.regexReplace(xml,"\r</","</");
  var path = basePath + xmlfile;
  //throw new Exception(xml);
  pub.EAFunc.WriteToFile(path,xml);
}

function setGUID(ds)
{
  var len = ds.getRowCount()-1;
//if(col>=0)
  var loc=ds.getColumnLoc("GUID");
  for(var j=len;j>=0;j--)
  {
    var guid = ds.getStringAt(j,loc);
    if(guid.length()<10) //不是有效的GUID,则赋新值
    {
      guid = pub.EAFunc.generateGuid(pub.EAFunc.GUID_JAVA,"");
      guid = pub.EAFunc.Replace(guid,"-","");
      ds.setValueAt(j,0,guid);
    }
  }
}

function addGUID()
{
  var ds=loadXML2DS();
  //var ds = new pub.EAXmlDS(xml);
  var loc=ds.getColumnLoc("GUID");
  if(loc<0)
  {
    ds.addColumn(-1,"GUID");
    setGUID(ds);
    saveDStoFile(ds);    
  }
  return ds;
}

function LoadFile()
{
  var ds;
  try
  {
     ds=addGUID();//loadXML2DS();
  }
  catch(e)
  {
    return "-";
  }
  //在第一行插入字段别名
  var sql = "select note from V_SYSXMLDB where id='"+flag+"'";
  ds.AddRow(-1);
  try
  {
    var str = pub.EADbTool.GetSQL(sql);
    var fields = pub.EAFunc.SplitString(str,",");
    var l = fields.length();
    for(var i=0;i<l;i++) 
      ds.setValueAt(0,i,""+fields[i]);
  }
  catch(e)
  {
    var c = ds.getColumnCount();
    for(var i=0;i<c;i++) 
      ds.setValueAt(0,i,ds.getColumnName(i));
  }
  //return ds.GetXml();
  //处理过滤条件,删除不符合条件的记录,设置数据行的可见标记
  var filters=pub.EAFunc.SplitString(filter,";");
  var l = filters.length();
  //添加状态列
  ds.addColumn(-1,"_");
  
  //仅处理 "filed1=val1;field2=val2" 类型的数据过滤,关系为"or"
  for(var i=0;i<l;i++)
  {
    var vals = pub.EAFunc.SplitString(filters[i],"=");
    if(vals.length()==2)
    {
      var len = ds.getRowCount()-1;
      var col = ds.getColumnLoc(vals[0]);
      if(col>=0)
        for(var j=len;j>=1;j--)
        {
          if(ds.getStringAt(j,col)!=vals[1])
            //ds.setValueAt(j,0,"1");
          //else
            ds.DeleteRow(j);
            //ds.setValueAt(j,0,"0");
        }
    }
  }
  
  return ds.GetXml();
}

function SaveToFile()
{
  xml = pub.EAFunc.regexReplace(xml,"<ROW .*","<ROW>");
  //xml = XmlToStd(xml);
  xml = StdToXml(xml);
  var ds = new pub.EAXmlDS(xml);
  if(fullrewrite==1)
  {
  var len = ds.getRowCount()-1;
  for(var j=len;j>=0;j--)
  {
    var state = ds.getStringAt(j,0);
    if(state=="-1")
      ds.DeleteRow(j);
  }  
  var r=ds.getColumnLoc("_");
  ds.removeColumn(r);
  //throw new pub.EAException(ds.getXml() );
  saveDStoFile(ds);
  return "保存成功!";    
  }
  //return xml;
  //删除标记为"已删除"的记录
  var file_ds;
  try
  {
  file_ds=loadXML2DS();
  }catch(e)
  {
    file_ds=new pub.EAXmlDS();
  }
  //var file_ds = new pub.EAXmlDS(xml);
  //var r=file_ds.getColumnLoc("_");
  //file_ds.removeColumn(r);
  //saveDStoFile(file_ds);
  var loc0=file_ds.getColumnLoc("GUID");
  var loc1=ds.getColumnLoc("GUID");
  var len = ds.getRowCount()-1;
  for(var j=len;j>=0;j--)
  {
    var state = ds.getStringAt(j,0);
    var guid=ds.getStringAt(j,loc1);
    var r = file_ds.Find(guid,loc0);
    if(state=="-1")
    {
      if(r>=0)
        onDelete(file_ds,r,guid);
    }
    else if(state=="9")
    {
      if(r<0)
        onInsert(ds,j,file_ds);
      else throw  new Exception("记录GUID标志错误:"+loc0+","+guid);
    }
    else if(state=="8")
    {
      //throw new Exception(""+r+","+xml);
      if(r>=0)
        onUpdate(ds,j,file_ds,r,guid);
    }
      
  }
  saveDStoFile(file_ds);
  return "保存成功!";
}
//var onDelete=Delete;
//var onInsert=Insert;
//var onUpdate=Update;
function onDelete(destds,destrow,guid)
{
  destds.DeleteRow(destrow);
}

function onInsert(srcds,srcrow,destds)
{
  destds.copyOneRow(srcds,srcrow);
  var r=destds.getColumnLoc("_");
  destds.removeColumn(r);
}

function onUpdate(srcds,srcrow,destds,destrow,guid)
{
  var cols = srcds.getColumnCount();
  for(var i=1;i<cols;i++) //跳过状态列0
    destds.setValueAt(destrow,srcds.getColumnName(i),srcds.getStringAt(srcrow,i));
}

function addBottomHtml(mwobj,request,sb,usrinfo)
{
  var script = request.getParameter("script");
  //2012年修改，默认取一个js运行脚本
  if(pub.EAFunc.isEmptyStr(script))
  {
  	// xmlfile=xmldb/orgdb/orgdb.xml 取出orgdb.xml并加入到js列表
  	var xmlfile =pubpack.EAFunc.NVL( request.getParameter("xmlfile"),"");
	if (xmlfile !="" ) {
		var flg = "";
		var ss = pubpack.EAFunc.SplitString(xmlfile,"/");
		script = "xlsgrid/js/"+ss[ss.length()-1]+".js";
	}
  }
  if(!pub.EAFunc.isEmptyStr(script))
	  sb.append("<SCRIPT language=jscript src='"+script+"'></SCRIPT>");  
}

function urlencode()
{
  return java.net.URLEncoder.encode(str,"GBK");
}

}