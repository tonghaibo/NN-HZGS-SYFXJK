function x_FlowDesigner(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var utilpack = new JavaPackage ( "java.util");
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );

var basePath = pubpack.EAOption.dynaDataRoot;
//================================================================// 
// ������GetTableTree
// ˵�����õ����ݵ�TABLE��TREE���б�
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�12/11/05 14:48:21
// �޸���־��
//================================================================// 
function GetSVGList()
{
              var xml = "<?xml version = '1.0'?>";
//              xml += "<ϵͳ����ͼ>";
              var sID = selsytid;
              // �ҳ��¼��������е�����ͼ
              var path = pubpack.EAOption.dynaDataRoot+"/xmldb/flowDb/syt"+sID;//pubpack.EAOption.dynaDataRoot + pubpack.EAOption.get("xmldb.file.flowdb") +"/syt"+sID;
              xml+=pubpack.EAFunc.readFile(path+"/index.xml");

              //path = basePath  + "xmldb/flowDb/syt"+sID;
              /**
              var file = new webpack.EAFileTree();
              try {
                    xml += file.GetXml(path,",grp,SVG,svg,",1);
              }
              catch ( pubpack.EAException e ) {
                  // û��Ŀ¼������Ҫ����
                  //return e.toString();
              }*/
//              xml += "</ϵͳ����ͼ>";
              return xml;
}
//================================================================// 
// ������GetMDList
// ˵�����õ��м������
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�03/11/06 21:26:17
// �޸���־��
//================================================================// 
function GetMDList()
{
              var xml = "<?xml version = '1.0'?>";
              var ds = xmldbpack.EAGRDXmlDB.getGrdIDDS(selsytid,grdtyp);//
              for ( var row=0;row<ds.getRowCount();row++){
                    xml+="<"+ds.getStringAt(row,"MWID")+" sytid=\""+selsytid+
                          "\" id=\""+ds.getStringAt(row,"MWID")+"\" NAME=\""+ds.getStringAt(row,"NAME") +"\" ����=\""+ds.getStringAt(row,"MWTYP")+"\"/>";
              }                      
              return xml;
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
              xml+="</"+selsytid+">";
        }    
 //       xml+="</�м������>";
        return xml;
}

//================================================================// 
// ������GetFlwList
// ˵�����õ�����������
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�03/11/06 21:26:08
// �޸���־��
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
				var flwname = filename;	// �ļ�����
				xmlfile = xmlpath + flwname;//�ļ�·��
				xml+="<"+flwname +" sytid=\""+selsytid+ "\" id=\""+flwname +"\" url=\""+xmlfile +"\"/>";
			}
		}
	}
              
        return xml;

}


//================================================================// 
// ������loadSVG
// ˵��������һ��svgͼ�ļ�
// ������path·��
// ���أ�
// ������
// ���ߣ�
// �������ڣ�03/11/06 17:08:33
// �޸���־��
//================================================================// 
function loadSVG()
{
      var basepath = pubpack.EAOption.dynaDataRoot+"/xmldb/flowDb/syt"+selsytid;//
      var str = pubpack.EAFunc.readFile(basepath +"/"+path);
      return str;

}
}