function x_LHTMLFLOW(){var pub= new JavaPackage("com.xlsgrid.net.pub");
var pubpack= new JavaPackage("com.xlsgrid.net.pub");
var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var utilpack = new JavaPackage ( "java.util");
var basePath = pubpack.EAOption.dynaDataRoot;

var TABLETAG = "TABLE��";
var TABLEEDITTAG = "TABLE��ṹ�༭";
var VIEWTAG = "VIEW��ͼ";
var VIEWCODETAG = "VIEW����༭";

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
              if ( G_SYTID=="x" || (G_SYTID!="x" &&selsytid ==G_SYTID ) ){
              
	              xml+="<"+selsytid+" imageid=\"0\" sytflg=\""+selsytid+"\">";      // sytflg˵���ýڵ���һ��ϵͳ
	              //xml+="<����ͼ selgrdtyp=\"S\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
	              xml+="<�����м�� selgrdtyp=\"B\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
	              xml+="<�����м�� selgrdtyp=\"R\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
	              xml+="<��ѯ�м�� selgrdtyp=\"Q\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
	              xml+="<���м�� selgrdtyp=\"F\" imageid=\"0\" sytflg=\""+selsytid+"\"/>";
	              xml+="<�Զ����м�� selgrdtyp=\"M\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
	              xml+="<������ͼ selgrdtyp=\"D\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";
	              xml+="<��ϵͳ selgrdtyp=\"S\" imageid=\"0\"  sytflg=\""+selsytid+"\"/>";

		
	              xml+="</"+selsytid+">";
	       }
        }    
 //       xml+="</�м������>";
        return xml;
}


// �õ�ĳһ��������ͼ
function loadDataflwGraph()
{

	var path = pub.EAOption.dynaDataRoot+ pub.EAOption.get("xmldb.file.grddb")+"/syt" + selsytid + "/" + filename;
 	var str="";
 	try {
 		str = pub.EAFunc.readFile(path);
 	}
 	catch ( e ) {
		str= ""; 	
 	}
	return str;
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
		
		xml+="<"+id + " name=\""+name+"\" id=\""+id+"\"  selgrdtyp=\""+grdtyp+"\" sytflg=\""+selsytid+"\" />";

	}
	return xml;
}

// �õ��ж���ٿ�����ͼ
function GetDBFlowList()
{

        var sytds = xmldbpack.EASYTXmlDB.getSytDS();
	var ds = new pubpack.EAXmlDS();
	var num = 0;
	var imageid="2";

	var thissytid  =selsytid ;
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var fileurl=basePath + pub.EAOption.get("xmldb.file.grddb")+"/syt" + selsytid;     
	//throw new pubpack.EAException(fileurl);         
	var folds = (new java.io.File(fileurl)).listFiles();
	if ( folds != null ) {
		folds=pub.EAFunc.sort(folds);
		var c = folds.length();
		for(var i=0;i<c;i++) {
			var f=folds[i];
			if(!f.isDirectory() ) {
				var filename = f.getName();
            			var index = filename.indexOf(".dbflow");	//+sub
				if ( index >=0  ) {
					var row= ds.AddRow(ds.getRowCount()-1);
					num++;
					ds.setValueAt(row,"SEQID",num);
					ds.setValueAt(row,"FILENAME",filename);
					ds.setValueAt(row,"NOTE","ͼ"+filename);
					ds.setValueAt(row,"SYTID",selsytid );
				}	
			}
		}
	}
	if ( ds.getRowCount() > 0 ) {
		var ds0 = ds.sort( "FILENAME" );
		for( var i=0;i< ds0.getRowCount(); i ++ ) {
	              var id = ds0.getStringAt(i,"FILENAME");
	              var name = ds0.getStringAt(i,"NOTE");
	              
	              name = pubpack.EAFunc.Replace(name," ","");
	              xml+="<"+id +" imageid=\""+imageid+"\"  sytflg=\""+thissytid+"\" todo=\"adddbflow\">";      // sytflg˵���ýڵ���һ��ϵͳ
	              
	              xml+="</"+id +">";
	        }  
		
	}
	return xml;
}


//��Head�����ö���ű�
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
  var sql = "select ID,NAME from v_dblist";
  var ds;
  
  try{
    ds = pub.EADbTool.QuerySQL(sql);
  }catch(e){ ds = new pub.EAXmlDS();}
  //var ds= new pub.EAXmlDS();
  ds.AddNullRow(-1);
  ds.setValueAt(0,"id","");
  ds.setValueAt(0,"name","Ĭ������");
  var c=ds.getRowCount();
  sb.append("<script>\nvar treexml=\"<���ݿ�>");
  for(var i=0;i<c;i++)
  {
    var connid=ds.getStringAt(i,"id");
    sb.append("<");sb.append(ds.getStringAt(i,"name"));sb.append(" conn=\\\""+connid+"\\\" imageid=\\\"2\\\">");
//    sb.append("<"+TABLETAG +" conn=\\\""+connid+"\\\" imageid=\\\"1\\\"/>");
//    //sb.append("<"+TABLEEDITTAG +" conn=\\\""+connid+"\\\"/>");
//    sb.append("<"+VIEWTAG+" conn=\\\""+connid+"\\\"/>");
//    //sb.append("<"+VIEWCODETAG+" conn=\\\""+connid+"\\\"/>");
	 sb.append("<TABLE���  conn=\\\""+connid+"\\\" action=\\\"TABLE\\\" imageid=\\\"2\\\" />");
	 sb.append("<VIEW��ͼ  conn=\\\""+connid+"\\\" action=\\\"VIEW\\\" imageid=\\\"2\\\" />");

    sb.append("</");sb.append(ds.getStringAt(i,"name"));sb.append(">");
  }
  sb.append("</���ݿ�>\";\n");
  sb.append("\nvar G_DSID=\"\";");
  sb.append("\nvar G_DSNAME=\"Ĭ������\";");
  var sqlid=pub.EAFunc.DateToStr(new java.util.Date(),"MMddHHmmssSSS");
  sb.append("\nvar G_SQLID=\""+sqlid+"\";");

  // OS ����εõ���¼����Ϣ
  var usr=webpack.EASession.GetLoginInfo(request);

  var xmlfile=pubpack.EAFunc.NVL(request.getParameter("xmlfile"),"");
  var selsytid=pubpack.EAFunc.NVL(request.getParameter("selsytid"),usr.getSytid());
  sb.append("\nvar CURFILENAME =\""+xmlfile+"\";");
  sb.append("\nvar G_CURSYTID=\""+selsytid+"\";");
  sb.append("\nvar xmlfile=\""+xmlfile+"\";");
  sb.append("\nvar selsytid=\""+selsytid+"\";");


  
	
  sb.append("</script>");
}


//================================================================// 
// ������GetTableGroupTree
// ˵�����õ����ݵ�TABLE��TREE�ķ����б�
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�12/11/05 14:48:21
// �޸���־��
//================================================================// 
function GetTableGroupTree()
{
	var db = null;
	var msg= "";
	var xml="";
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "";
	        if( tagid==TABLETAG || tagid== TABLEEDITTAG ) 
	        {
	              var sql = "select id ,NVL( id,'����')||'��' name,'('||to_char(cnt)||')' note from ( "+
			"select substr(TABLE_NAME,0, instr(TABLE_NAME,'_')) id,count(*) cnt from user_tables group by substr(TABLE_NAME,0, instr(TABLE_NAME,'_')) "+
			") order by id";

	              var ds = db.QuerySQL(sql);  
	              var cnt = ds.getRowCount();
	              for( var i=0;i< cnt; i ++ ) {
	                    var sTableName = ds.getStringAt(i,"id");
	                    var sNote = ds.getStringAt(i,"note");
	                    var name = ds.getStringAt(i,"name");

	                    xml+="<"+name +" conn=\""+dsid+"\" imageid=\"2\" groupid=\""+sTableName +"\" action=\"TABLEGROUP\" name=\""+sNote+"\" />";//
	                    
	              }
	        }
	        else if ( tagid==VIEWTAG || tagid== VIEWCODETAG  ) {
	        	var sql = "select id ,NVL( id,'����')||'��' name,'('||to_char(cnt)||')' note from ( "+
			"select substr(VIEW_NAME,0, instr(VIEW_NAME,'_')) id,count(*) cnt from user_views group by substr(VIEW_NAME,0, instr(VIEW_NAME,'_')) "+
			") order by id";
	              var ds1 = db.QuerySQL(sql);        
	              var cnt = ds1.getRowCount();
	              for( var i=0;i< cnt; i ++ ) {
	                    var sTableName = ds1.getStringAt(i,"id");
	                    var name = ds1.getStringAt(i,"name");
	                    var sNote = ds1.getStringAt(i,"name");

	                    xml+="<"+name +" conn=\""+dsid+"\" imageid=\"2\" groupid=\""+sTableName +"\" action=\"VIEWGROUP\" name=\""+sNote+"\" />";// 
	                    
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
	return xml;
}

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
function GetTableTree()
{
	var db = null;
	var msg= "";
	var xml="";
	
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "";
	        if( tagid==TABLETAG || tagid== TABLEEDITTAG ) 
	        {
	              var sql = "select a.table_name,a.typ,decode( INSTR(b.COMMENTS,'~'),0,b.COMMENTS,substr(b.COMMENTS,1,INSTR(COMMENTS,'~')-1)) note,substr(b.COMMENTS,INSTR(COMMENTS,'~')+1,length(b.comments)) comments from "+
	                  "( select TABLE_NAME,'TABLE' TYP from user_tables ) "+
	                  "a,user_tab_comments b "+
	                  "where a.TABLE_NAME=b.table_name(+) and a.TABLE_NAME like '"+pretablname+"%' and a.TABLE_NAME not like 'EPC%' and a.TABLE_NAME not like 'ETL_TMP_%' "+
	                  " and a.TABLE_NAME not like 'SMP_%' and a.TABLE_NAME not like 'VDK_%' and a.TABLE_NAME not like 'VMQ_%'"+
	                  "order by a.TYP,a.TABLE_NAME  ";
	              var ds = db.QuerySQL(sql);  
	              var cnt = ds.getRowCount();
	              for( var i=0;i< cnt; i ++ ) {
	                    var sTableName = ds.getStringAt(i,"table_name");
	                    var sNote = ds.getStringAt(i,"note");
	                    var sComment = ds.getStringAt(i,"comments");
	                    if ( tagid==TABLETAG )
	                    	xml+="<"+sTableName +" conn=\""+dsid+"\" ID=\"+sTableName +\" name=\" "+sNote +"\" comment=\""+sComment +"\" action=\"ADDTABLE\" />";
	                    else 
	                    	xml+="<"+sTableName +" conn=\""+dsid+"\" ID=\"+sTableName +\" action=\"TABLEEDIT\" name=\" "+sNote +"\" comment=\""+sComment +"\" action=\"ADDTABLE\"/>";
	
	              }
	        }
	        else if ( tagid==VIEWTAG || tagid== VIEWCODETAG  ) {
	              sql = "select a.table_name,a.typ,decode( INSTR(b.COMMENTS,'~'),0,b.COMMENTS,substr(b.COMMENTS,1,INSTR(COMMENTS,'~')-1)) note,substr(b.COMMENTS,INSTR(COMMENTS,'~')+1,length(b.comments)) comments  from "+
	                  "( select VIEW_NAME TABLE_NAME,'VIEW' TYP from USER_VIEWS ) "+
	                  "a,user_tab_comments b "+
	                  "where a.TABLE_NAME=b.table_name(+) and a.TABLE_NAME like '"+pretablname+"%' "+
	                  "order by a.TYP,a.TABLE_NAME  ";
	              var ds1 = db.QuerySQL(sql);        
	              var cnt = ds1.getRowCount();
	              for( var i=0;i< cnt; i ++ ) {
	                    var sTableName = ds1.getStringAt(i,"table_name");
	                    var sNote = ds1.getStringAt(i,"note");
	                    var sComment = ds1.getStringAt(i,"comments");
	                    if ( tagid==VIEWTAG )
	                          xml+="<"+sTableName +" conn=\""+dsid+"\" ID=\""+sTableName +"\" name=\" "+sNote +"\" comment=\""+sComment +"\" action=\"ADDVIEW\"/>";
	                    else 
	                          xml += "<"+sTableName +" conn=\""+dsid+"\" ID=\""+sTableName +"\" action=\"VIEWCODE\" name=\""+sNote +"\" comment=\""+sComment +"\" action=\"ADDVIEW\"/>";
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
	return xml;
}
//�ж��м���Ƿ����
function queryMW()
{
	try {
	    var mwXmlDB = new xmldbpack.EAGRDXmlDB(sSytid,sGrdid);
	}
	catch ( e ) {
	    return "0";
	}
	return "1";
}
//�õ�ĳ���м������ϸ��Ϣ
//selsytid,selgrdid
function GetEAGRDXmlDB()
{
	var str = "";
	var grddb = new xmldb.EAGRDXmlDB(selsytid,selgrdid );
	var ds = grddb.getGrdPamDS();
	if ( ds.getRowCount()>0 ) {
		str+="<p align=left>�����������</p>";
		str+= DS2Table(ds, 700,"ID,NAME,INPCTL,NOTNULL,KEYVAL,EDTFLG,VISFLG,DISPORD","���,����,����,�ǿ�,�ؼ���,�ɱ༭,����ʾ,�����");
	}
	ds = grddb.getGrdShwDS();
	if ( ds.getRowCount()>0 ) {
		str+="<p align=left>�������Ϣ��</p>";
		str+= DS2Table(ds, 700,"ID,NROW,NCOL,NAME,DSKEY","��ʼλ��,��������,��������,����,������Դ");
	}
	ds = grddb.getGrdDSCDS();
	if ( ds.getRowCount()>0 ) {
		str+="<p align=left>������Դ��</p>";
			str+= DS2Table(ds, 700,"ID,NAME,DATDSC","���,����,SQL����");
	}
	ds = grddb.getGrdBtnDS();
	if ( ds.getRowCount()>0 ) {
		str+="<p align=left>����ť�Ͷ�����</p>";
		str+= DS2Table(ds, 700,"ID,NAME,ACTTYP,TIP","���,����,��������,��ʾ");
	}
	/*ds = grddb.getGrdCelDS();
	if ( ds.getRowCount()>0 ) {
		str+="<p align=left>����Ԫ�������</p>";
		str+= DS2Table(ds, 600,"ID,NAME","���,����");
	}
	ds = grddb.getGrdColDS();
	if ( ds.getRowCount()>0 ) {
		str+="<p align=left>����ϸ�������</p>";
		str+= DS2Table(ds, 600,"ID,NAME","���,����");
	}
	
	ds = grddb.getGrdFldHdrDs();
	if ( ds.getRowCount()>0 ) {
		str+="<p align=left>�����ݱ�ͷ��Ϣ���塿</p>";
		str+= DS2Table(ds, 600,"ID,NAME","���,����");
	}
	ds = grddb.getGrdFldDtlDs();
	if ( ds.getRowCount()>0 ) {
		str+="<p align=left>��������ϸ����Ϣ���塿</p>";
		str+= DS2Table(ds, 600,"ID,NAME","���,����");
	}
	*/
	return str;
	
}
//��һ��dsת��Ϊһ��html���
function DS2Table(ds, width,colidlist,colnamlist)
{
	var str = "";
	str+="<table border='1' cellpadding='5' cellspacing='0' width='"+width+"' style='border-collapse: collapse; ' bordercolorlight='#C0C0C0'>"+
		"<tr height='26' style='mso-height-source: userset; height: 19.5pt'>";
	var sColid = colidlist.split(",");
	var sColnam = colnamlist.split(",");
	for ( var c=0;c<ds.getColumnCount();c++ ) {
		var colid = ds.getColumnName(c);
		var colnam = colid;
		var bFinded = false;
		for ( var i=0;i<sColid.length();i++ ) {
			if( colid == sColid[i] ){
				bFinded  = true;
				colnam = sColnam[i];break;
			}
		}
		if ( colidlist=="" || bFinded  == true ) 
			str+="<td height='26'  class='style1' bgcolor='#EEEEEE' align=center>"+colnam+"</td>";
	}
	str+="</tr>";
	for ( var row=0;row<ds.getRowCount();row++ ){
		str+="<tr height='26' style='mso-height-source: userset; height: 19.5pt'>";
		for ( var c=0;c<ds.getColumnCount();c++ ){
			var bFinded = false;
			for ( var i=0;i<sColid.length();i++ ) {
				if( ds.getColumnName(c) == sColid[i] ){
					bFinded  = true;break;
				}
			}
			if ( colidlist=="" || bFinded  == true ) 
				str+="<td height='26' align=center >"+ds.getStringAt(row,c)+"</td>";
		}
		str+="</tr>";
	}
	str+="</table>";
	return str;
}

//�õ�ĳ���м���Ĵ�����Ϣ
//selsytid,selgrdid
function GetEAGRDJSOS()
{
	var str = "";
	var grddb = new xmldb.EAGRDXmlDB(selsytid,selgrdid );
	var js = grddb.getGrdJS();

	var os = grddb.getGrdOS();
	js = pubpack.EAFunc.Replace(js,"<","��");//
	js = pubpack.EAFunc.Replace(js,">","��");//
	os = pubpack.EAFunc.Replace(os,"<","��");
	os = pubpack.EAFunc.Replace(os,">","��");	
	str+="<p align=left>���ͻ��˴��롿</p><pre class=\"brush: cpp; auto-links: false; \">"+js+"</pre>";
	str+="<p align=left>������˴��롿</p><pre class=\"brush: cpp; auto-links: false; \">"+os+"</pre>";
	return str;
	
}
//XML�ĺ�������
function PostXML()
{
	xml = pubpack.EAFunc.Replace(xml,"<","��");
	xml = pubpack.EAFunc.Replace(xml,">","��");
	return xml;
}

//�õ�ĳ���м���Ļ�������
//selsytid,selgrdid
function GetGRDDefHTML()
{
	var str= "";
	try {
		var title = "�м��";
		if (seldoctyp == 1 ) title  = "ģ��";
		else if (seldoctyp == 3 ) title  = "ҵ��";
	
		var grddb = new xmldb.EAGRDXmlDB(selsytid,selgrdid );
		
		var ds = grddb.getGrdDS();
	//	str+= DS2Table(ds, 600,"","");
	
		str+="<p align=left>��"+title+"�������Զ��塿</p>";
		str+="<table border='1' width='100%' id='table1' bordercolorlight='#C0C0C0' style='border-collapse: collapse' cellspacing='0' cellpadding='8'>"+
			"<tr><td width='86' bgcolor='#FFFFEE'>"+title+"����ţ�</td><td width='81' bgcolor='#FFFFEE'>"+ds.getStringAt(0,"MWID")+"</td><td width='83' bgcolor='#FFFFEE'>"+title+"���ƣ�</td><td bgcolor='#FFFFEE'>"+ds.getStringAt(0,"NAME")+"</td><td width='65' bgcolor='#FFFFEE'>���ࣺ</td>	<td width='80' bgcolor='#FFFFEE'>"+ds.getStringAt(0,"CATTYP")+"</td></tr>"+
			"<tr><td width='86' height='74' bgcolor='#FFFFEE'>˵����</td><td colspan='5' height='74' bgcolor='#FFFFEE'>"+ds.getStringAt(0,"NOTE")+"</td></tr>"+
			"<tr><td width='86' bgcolor='#FFFFEE'>��ͷTABLE��</td><td width='81' bgcolor='#FFFFEE'>"+ds.getStringAt(0,"BILHDRTABLE")+"</td><td width='83' bgcolor='#FFFFEE'>��ϸTABLE��</td><td bgcolor='#FFFFEE'>"+ds.getStringAt(0,"BILDTLTABLE")+"</td><td width='65' bgcolor='#FFFFEE'>ģ���ļ���</td>	<td width='80' bgcolor='#FFFFEE'>"+ds.getStringAt(0,"FILE")+"</td></tr></table>";
	}
	catch(e) {
	
	}
		
	return str;
}


}