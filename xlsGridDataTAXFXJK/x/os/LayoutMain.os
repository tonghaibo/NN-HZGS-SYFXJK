function x_LayoutMain(){var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );

var pubpack = new JavaPackage("com.xlsgrid.net.pub" );
var grdpack = new JavaPackage("com.xlsgrid.net.grd" );
//ҳ��BODY������Ϻ��¼�
//sb������bodyԪ�ؼ�ǰ���head����
//bodysb������body��innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("<script>");
	sb.append("function InitLayout() {");	
	var layoutid = pubpack.EAFunc.NVL( request.getParameter("layoutid"), "" );
	//if ( layoutid == "" )throw new Exception( "���봫�����layoutid" );
	var orgid= pubpack.EAFunc.NVL( request.getParameter("myorgid"), "" );
	if ( orgid== "" )throw new Exception( "���봫�����myorgid	" );	
	if (layoutid != "" ){
		var layout = new grdpack.EALayout(orgid,layoutid );
		sb.append( layout.GetInitGridJS() );
		try {sb.append( layout.GetInitPageJS() );}catch(e){}
		
	}
	sb.append("}");	
	
	sb.append("</script>");  
}

// �õ��������Ķ���
function GetLayout()
{
       var xml = "";

	var num = 0;
	var ds = new pubpack.EAXmlDS();
	var fileurl=pubpack.EAOption.dynaDataRoot + "org/" + thisorgid+"/layout";     
	var fileurl1=pubpack.EAOption.dynaDataRoot + "org/" + thisorgid+"/layout/index.layout";   
	var pagexml = pubpack.EAFunc.readFile(fileurl1);
        var pageds  = new pubpack.EAXmlDS(pagexml); 
	var folds = (new java.io.File(fileurl)).listFiles();
	if ( folds != null ) {
		folds=pub.EAFunc.sort(folds);
		var c = folds.length();
		for(var i=0;i<c;i++) {
			var f=folds[i];
			if(!f.isDirectory() ) {
				var filename = f.getName();
            			var index = filename.indexOf(".sxg");	
				if ( index >=0  ) {
					var row= ds.AddRow(ds.getRowCount()-1);
					num++;
					//ds.setValueAt(row,"SEQID",num);
					var layoutid = filename.substring(0,index);
					ds.setValueAt(row,"ID",layoutid );
					var layouttitle = "δ����";
					for ( var j=0;j<pageds.getRowCount();j++){
						if ( pageds.getStringAt(j,"ID")==layoutid ){
							layouttitle =pageds.getStringAt(j,"TITLE");
							if (layouttitle =="")
								layouttitle ="ҳ�����Ϊ��";
							break;
						}
					}
					ds.setValueAt(row,"NAME",layouttitle );
					ds.setValueAt(row,"STR","" );

					//ds.setValueAt(row,"NOTE","������"+filename);
					var fileurl2=pubpack.EAOption.dynaDataRoot + "org/" + thisorgid+"/layout/"+filename ;   
					var svgstr = pubpack.EAFunc.readFile(fileurl2);
					var index1= svgstr.indexOf("cellvalue=\"");
					if ( index1>0){
						var index2= svgstr.indexOf("\"",index1+"cellvalue=\"".length()+1);
						if ( index2>0 ) {
							var cellstr = svgstr.substring(index1+"cellvalue=\"".length(),index2 );
							var ss = cellstr.split("~n" );
							for ( var n = 0 ;n<ss.length() ;n++) {
								if ( ss[n].length() > 0 ) {
									row= ds.AddRow(ds.getRowCount()-1);
									num++;
									ds.setValueAt(row,"ID","" );
									var sss = ss[n].split("��");
									
									var title = ss[n];
									if ( sss.length() > 1 ) {
										title = sss[1]; 
									}
									if ( title == "" )
										title="�������Ϊ��";
									ds.setValueAt(row,"NAME",title );
									ds.setValueAt(row,"STR",ss[n]  );
								}
								
							}
						}
					}
				}	
			}
		}
	}

        return ds.GetXml();
}


// �õ��������Ķ���
function GetLayoutItem()
{
       var xml = "";
        var sytds = xmldbpack.EAORGXmlDB.getOrgDs();
	var ds = new pubpack.EAXmlDS();
	var num = 0;
        for( var i=0;i< sytds.getRowCount(); i ++ ) {
		var selsytid = sytds.getStringAt(i,"ID");
		
		if ( thissytid == selsytid ) {
			var fileurl=pubpack.EAOption.dynaDataRoot + "org/" + selsytid+"/layout";     
			var folds = (new java.io.File(fileurl)).listFiles();
			if ( folds != null ) {
				folds=pub.EAFunc.sort(folds);
				var c = folds.length();
				for(var i=0;i<c;i++) {
					var f=folds[i];
					if(!f.isDirectory() ) {
						var filename = f.getName();
		            			var index = filename.indexOf(".sxg");	
						if ( index >=0  ) {
							var row= ds.AddRow(ds.getRowCount()-1);
							num++;
							ds.setValueAt(row,"SEQID",num);
							ds.setValueAt(row,"FILENAME",filename);
							ds.setValueAt(row,"NOTE","������"+filename);
							ds.setValueAt(row,"SYTID",selsytid );
							ds.setValueAt(row,"ACTION","�޸Ĳ���" );
							ds.setValueAt(row,"ACTION1","ɾ������" );
							
	
	
							
						}	
					}
				}
			}
		}
	}
        return ds.GetXml();
}

// �ͻ���param����Ĳ�������ֱ��ʹ��
function save()
{
	
	try {
		  xmlstr = XmlToStd(xmlstr);
		  var path = pubpack.EAOption.dynaDataRoot+"org/" + thisorgid + "/layout/" + layoutid+".sxg";
		  
		  pubpack.EAFunc.WriteToFile(path,xmlstr);	
		  
		  var path = pubpack.EAOption.dynaDataRoot+"org/" + thisorgid + "/layout/index.layout";
		  
		  var pageds= new pubpack.EAXmlDS( pageprop );
		  
		  if ( pageds.getRowCount() > 6 ) {
		  	  var title = pageds.getStringAt(0,"NAME") ;
		  	  var showflag =  pageds.getStringAt(1,"NAME") ;
			  var fixwidth =pageds.getStringAt(2,"NAME") ;
			  var fixheight =pageds.getStringAt(3,"NAME") ;// �����߶�
			  var align= pageds.getStringAt(4,"NAME") ;
			  var valign= pageds.getStringAt(5,"NAME") ;
			  var showheadimg= pageds.getStringAt(6,"NAME") ;
			  var showtoolbar= pageds.getStringAt(7,"NAME") ;
			  var bkcolor= pageds.getStringAt(8,"NAME") ;
			  var fixrowheight= pageds.getStringDef(9,"NAME","") ;//����Ӧ�иߣ�
			  var reloadtime= pageds.getStringDef(10,"NAME","") ;//��ʱˢ��ʱ��  (��)	
			  var cellspace= pageds.getStringDef(11,"NAME","") ;//cellspace	
			  var cellpadding= pageds.getStringDef(12,"NAME","") ;//cellpadding
			  
			  var onhtmlid= pageds.getStringDef(13,"NAME","") ;//	
			  var posthtmlid= pageds.getStringDef(14,"NAME","") ;//

			  

	

			  
			  var ds =new pubpack.EAXmlDS();
			  try {
			  	ds.ReadFromFile(path);
			  }
			  catch (pubpack.EAException e) {//�����ڣ�����
			  	if ( e.getCode() ==pubpack.EAException.errDataNotFount ){
				  	var row =ds.AddRow(-1);
				  	ds.setValueAt(row,"ID",layoutid);
				}
				else throw new Exception (e.toString());
			  }
			  var bExist =0 ;
			  for ( var i=0;i<ds.getRowCount();i++) {
			  	var id = ds.getStringAt(i,"ID");
			  	if ( id  == layoutid ){
			  		ds.setValueAt(i,"TITLE",title );
//			  		throw new Exception(title); 
			  		ds.setValueAt(i,"SHOWFLAG",showflag );
			  		ds.setValueAt(i,"WIDTHFIX",fixwidth );
			  		ds.setValueAt(i,"HEIGHTFIX",fixheight );
			  		ds.setValueAt(i,"ALIGN",align);
			  		ds.setValueAt(i,"VALIGN",valign);
			  		ds.setValueAt(i,"SHOWHEADIMG",showheadimg);
			  		ds.setValueAt(i,"SHOWTOOLBAR",showtoolbar);
			  		ds.setValueAt(i,"BKCOLOR",bkcolor);
			  		ds.setValueAt(i,"FIXROWHEIGHT",fixrowheight);//����Ӧ�иߣ�
			  		ds.setValueAt(i,"RELOADTIME",reloadtime);//��ʱˢ��ʱ��  (��)	
			  		ds.setValueAt(i,"CELLSPACE",cellspace);
			  		ds.setValueAt(i,"CELLPADDING",cellpadding);
			  		
			  		ds.setValueAt(i,"ONHTMLID",onhtmlid);
			  		ds.setValueAt(i,"POSTHTMLID",posthtmlid);

			  		



			  		bExist =1;
			  		break;
			  	}
			  
			  }
			  if(bExist ==0) {
			 	 var row =ds.AddRow(-1);
				  ds.setValueAt(row,"ID",layoutid);
				  ds.setValueAt(row,"TITLE",title );
		  		ds.setValueAt(row,"SHOWFLAG",showflag );
		  		ds.setValueAt(row,"WIDTHFIX",fixwidth );
		  		ds.setValueAt(row,"HEIGHTFIX",fixheight);

		  		ds.setValueAt(row,"ALIGN",align);
		  		ds.setValueAt(row,"VALIGN",valign);
		  		ds.setValueAt(row,"SHOWHEADIMG",showheadimg);
		  		ds.setValueAt(row,"SHOWTOOLBAR",showtoolbar);
		  		ds.setValueAt(row,"BKCOLOR",bkcolor);
		  		ds.setValueAt(row,"FIXROWHEIGHT",fixrowheight);//����Ӧ�иߣ�
		  		ds.setValueAt(row,"RELOADTIME",reloadtime);//��ʱˢ��ʱ��  (��)
				ds.setValueAt(row,"CELLSPACE",cellspace);
			  		ds.setValueAt(row,"CELLPADDING",cellpadding);
			  		
			  		ds.setValueAt(row,"ONHTMLID",onhtmlid);
			  		ds.setValueAt(row,"POSTHTMLID",posthtmlid);


			  }
			  	
			  pubpack.EAFunc.WriteToFile(path,ds.GetXml() );
			 
		  }
		  
	
	}
	catch ( ee ) {

		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		
	}
	return "�ѱ���"+layoutid;
}

// �õ����ֵ���������Ϣ
function getLayoutIndex()
{
	var ret = " ";
	try {
		  
		  var path = pubpack.EAOption.dynaDataRoot+"org/" + thisorgid + "/layout/index.layout";
		  var ds =new pubpack.EAXmlDS();

		  try {
			  	ds.ReadFromFile(path);
		  }
		  catch (pubpack.EAException e) {//�����ڣ�����
		  	
		  	if ( e.getCode() ==pubpack.EAException.errDataNotFount ){
			  	return "";
			}
			else throw new Exception (e.toString());
		  }
		
		  for ( var i=0;i<ds.getRowCount();i++) {
			  var id = ds.getStringAt(i,"ID");
			  if ( id  == layoutid ){

			  	  var title = ds.getValueAt(i,"TITLE") ;

			  	  var showflag =  ds.getValueAt(i,"SHOWFLAG") ;
				  var fixwidth =ds.getValueAt(i,"WIDTHFIX") ;
				  var fixheight =ds.getStringDef(i,"HEIGHTFIX","") ;

				  var align= ds.getValueAt(i,"ALIGN") ;
				  var valign=ds.getValueAt(i,"VALIGN");
				  var showheadimg= ds.getValueAt(i,"SHOWHEADIMG");
				  var showtoolbar= ds.getValueAt(i,"SHOWTOOLBAR") ;
				  var bkcolor= ds.getStringDef(i,"BKCOLOR","") ;
				  var fixrowheight= ds.getStringDef(i,"FIXROWHEIGHT","") ;//����Ӧ�иߣ�
				  var reloadtime= ds.getStringDef(i,"RELOADTIME","") ;//��ʱˢ��ʱ��  (����)
				  var cellspace= ds.getStringDef(i,"CELLSPACE","") ;//��ʱˢ��ʱ��  (����)
				  var cellpadding= ds.getStringDef(i,"CELLPADDING","") ;//��ʱˢ��ʱ��  (����)	
				  var onhtmlid= ds.getStringDef(i,"ONHTMLID","") ;//ҳ��ǰHTML_ID
				  var posthtmlid= ds.getStringDef(i,"POSTHTMLID","") ;//			  
				  ret = title +"~"+showflag +"~"+fixwidth  +"~"+align+"~"+valign+"~"+showheadimg+"~"+showtoolbar+"~"+bkcolor+"~"+fixrowheight+"~"+reloadtime+"~"+cellspace+"~"+cellpadding+"~"+onhtmlid+"~"+posthtmlid+"~"+fixheight;
				  return ret;
			  }

		  }
		  
		    
	
	}
	catch ( ee ) {

		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		
	}

	return ret;
}


function  XmlToStd(xml)
{
      xml = pub.EAFunc.Replace(xml, "&"+"quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"amp;quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"apos;", "'"  );
    return xml;
}

}