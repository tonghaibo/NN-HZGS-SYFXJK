function x_FlowDesigner(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var utilpack = new JavaPackage ( "java.util");
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );

var basePath = pubpack.EAOption.dynaDataRoot;
//================================================================// 
// 函数：GetTableTree
// 说明：得到数据的TABLE和TREE的列表
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：12/11/05 14:48:21
// 修改日志：
//================================================================// 
function GetSVGList()
{
              var xml = "<?xml version = '1.0'?>";
//              xml += "<系统流程图>";
              var sID = selsytid;
              // 找出下级帐套所有的流程图
              var path = pubpack.EAOption.dynaDataRoot+"/xmldb/flowDb/syt"+sID;//pubpack.EAOption.dynaDataRoot + pubpack.EAOption.get("xmldb.file.flowdb") +"/syt"+sID;
              xml+=pubpack.EAFunc.readFile(path+"/index.xml");

              //path = basePath  + "xmldb/flowDb/syt"+sID;
              /**
              var file = new webpack.EAFileTree();
              try {
                    xml += file.GetXml(path,",grp,SVG,svg,",1);
              }
              catch ( pubpack.EAException e ) {
                  // 没有目录，不需要报错
                  //return e.toString();
              }*/
//              xml += "</系统流程图>";
              return xml;
}
//================================================================// 
// 函数：GetMDList
// 说明：得到中间件对象
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：03/11/06 21:26:17
// 修改日志：
//================================================================// 
function GetMDList()
{
              var xml = "<?xml version = '1.0'?>";
              var ds = xmldbpack.EAGRDXmlDB.getGrdIDDS(selsytid,grdtyp);//
              for ( var row=0;row<ds.getRowCount();row++){
                    xml+="<"+ds.getStringAt(row,"MWID")+" sytid=\""+selsytid+
                          "\" id=\""+ds.getStringAt(row,"MWID")+"\" NAME=\""+ds.getStringAt(row,"NAME") +"\" 类型=\""+ds.getStringAt(row,"MWTYP")+"\"/>";
              }                      
              return xml;
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
              xml+="</"+selsytid+">";
        }    
 //       xml+="</中间件对象>";
        return xml;
}

//================================================================// 
// 函数：GetFlwList
// 说明：得到数据流定义
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：03/11/06 21:26:08
// 修改日志：
//================================================================// 
function GetFlwList()
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var flwdbbase = pub.EAOption.dynaDataRoot + pub.EAOption.get("xmldb.file.flwLnkdb") + "/syt";
	var flwpath= pub.EAOption.get("xmldb.file.flwLnkdb");
	var sytid = selsytid;
	var xmlpath = flwpath + "/syt" + sytid + "/";
	var fs = (new iopack.File(flwdbbase+sytid)).listFiles();
	if(fs!=null) {
		utilpack.Arrays.sort(fs);
		for (var k = 0; k < fs.length ; k++){
			var filename = fs[k].getName();
			var len = filename.length();
			if(fs[k].isFile()&&filename.substring(len-4).equalsIgnoreCase(".xml"))
			{
				var flwname = filename;	// 文件名称
				xmlfile = xmlpath + flwname;//文件路径
				xml+="<"+flwname +" sytid=\""+selsytid+ "\" id=\""+flwname +"\" url=\""+xmlfile +"\"/>";
			}
		}
	}
              
        return xml;

}


//================================================================// 
// 函数：loadSVG
// 说明：载入一个svg图文件
// 参数：path路径
// 返回：
// 样例：
// 作者：
// 创建日期：03/11/06 17:08:33
// 修改日志：
//================================================================// 
function loadSVG()
{
      var basepath = pubpack.EAOption.dynaDataRoot+"/xmldb/flowDb/syt"+selsytid;//
      var str = pubpack.EAFunc.readFile(basepath +"/"+path);
      return str;

}
}