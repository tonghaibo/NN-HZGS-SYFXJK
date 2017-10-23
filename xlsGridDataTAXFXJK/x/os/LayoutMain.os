function x_LayoutMain(){var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );

var pubpack = new JavaPackage("com.xlsgrid.net.pub" );
var grdpack = new JavaPackage("com.xlsgrid.net.grd" );
//页面BODY处理完毕后事件
//sb里面是body元素及前面的head内容
//bodysb里面是body的innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("<script>");
	sb.append("function InitLayout() {");	
	var layoutid = pubpack.EAFunc.NVL( request.getParameter("layoutid"), "" );
	//if ( layoutid == "" )throw new Exception( "必须传入参数layoutid" );
	var orgid= pubpack.EAFunc.NVL( request.getParameter("myorgid"), "" );
	if ( orgid== "" )throw new Exception( "必须传入参数myorgid	" );	
	if (layoutid != "" ){
		var layout = new grdpack.EALayout(orgid,layoutid );
		sb.append( layout.GetInitGridJS() );
		try {sb.append( layout.GetInitPageJS() );}catch(e){}
		
	}
	sb.append("}");	
	
	sb.append("</script>");  
}

// 得到数据流的定义
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
					var layouttitle = "未命名";
					for ( var j=0;j<pageds.getRowCount();j++){
						if ( pageds.getStringAt(j,"ID")==layoutid ){
							layouttitle =pageds.getStringAt(j,"TITLE");
							if (layouttitle =="")
								layouttitle ="页面标题为空";
							break;
						}
					}
					ds.setValueAt(row,"NAME",layouttitle );
					ds.setValueAt(row,"STR","" );

					//ds.setValueAt(row,"NOTE","数据流"+filename);
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
									var sss = ss[n].split("～");
									
									var title = ss[n];
									if ( sss.length() > 1 ) {
										title = sss[1]; 
									}
									if ( title == "" )
										title="窗体标题为空";
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


// 得到数据流的定义
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
							ds.setValueAt(row,"NOTE","数据流"+filename);
							ds.setValueAt(row,"SYTID",selsytid );
							ds.setValueAt(row,"ACTION","修改布局" );
							ds.setValueAt(row,"ACTION1","删除布局" );
							
	
	
							
						}	
					}
				}
			}
		}
	}
        return ds.GetXml();
}

// 客户端param传入的参数可以直接使用
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
			  var fixheight =pageds.getStringAt(3,"NAME") ;// 新增高度
			  var align= pageds.getStringAt(4,"NAME") ;
			  var valign= pageds.getStringAt(5,"NAME") ;
			  var showheadimg= pageds.getStringAt(6,"NAME") ;
			  var showtoolbar= pageds.getStringAt(7,"NAME") ;
			  var bkcolor= pageds.getStringAt(8,"NAME") ;
			  var fixrowheight= pageds.getStringDef(9,"NAME","") ;//自适应行高？
			  var reloadtime= pageds.getStringDef(10,"NAME","") ;//定时刷新时间  (秒)	
			  var cellspace= pageds.getStringDef(11,"NAME","") ;//cellspace	
			  var cellpadding= pageds.getStringDef(12,"NAME","") ;//cellpadding
			  
			  var onhtmlid= pageds.getStringDef(13,"NAME","") ;//	
			  var posthtmlid= pageds.getStringDef(14,"NAME","") ;//

			  

	

			  
			  var ds =new pubpack.EAXmlDS();
			  try {
			  	ds.ReadFromFile(path);
			  }
			  catch (pubpack.EAException e) {//不存在，新增
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
			  		ds.setValueAt(i,"FIXROWHEIGHT",fixrowheight);//自适应行高？
			  		ds.setValueAt(i,"RELOADTIME",reloadtime);//定时刷新时间  (秒)	
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
		  		ds.setValueAt(row,"FIXROWHEIGHT",fixrowheight);//自适应行高？
		  		ds.setValueAt(row,"RELOADTIME",reloadtime);//定时刷新时间  (秒)
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
	return "已保存"+layoutid;
}

// 得到布局的主定义信息
function getLayoutIndex()
{
	var ret = " ";
	try {
		  
		  var path = pubpack.EAOption.dynaDataRoot+"org/" + thisorgid + "/layout/index.layout";
		  var ds =new pubpack.EAXmlDS();

		  try {
			  	ds.ReadFromFile(path);
		  }
		  catch (pubpack.EAException e) {//不存在，新增
		  	
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
				  var fixrowheight= ds.getStringDef(i,"FIXROWHEIGHT","") ;//自适应行高？
				  var reloadtime= ds.getStringDef(i,"RELOADTIME","") ;//定时刷新时间  (毫秒)
				  var cellspace= ds.getStringDef(i,"CELLSPACE","") ;//定时刷新时间  (毫秒)
				  var cellpadding= ds.getStringDef(i,"CELLPADDING","") ;//定时刷新时间  (毫秒)	
				  var onhtmlid= ds.getStringDef(i,"ONHTMLID","") ;//页面前HTML_ID
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