function x_LBak(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");

var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb");
var layoutpack = new JavaPackage ( "com.xlsgrid.net.layout");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd");

var langpack = new JavaPackage ( "java.lang");
//��Ϊ.sp����ʱ�����
//Ԥ���������request,response
function Response()
{
	var db = null;
	var msg= "";
	var layoutid = pubpack.EAFunc.NVL( request.getParameter("id"),"") ;
	var objid= pubpack.EAFunc.NVL( request.getParameter("objid"),"") ;
	var skin= pubpack.EAFunc.NVL( request.getParameter("skin"),"") ;


	
	var deforg =  pubpack.EAFunc.NVL( request.getParameter("thisorgid"),webpack.EAWebDeforg.GetDeforg(request)) ;
	var browsetype = pubpack.EAFunc.getBroswerType( request );
	response.setContentType("text/html;charset=UTF-8");//response.setContentType("text/html; charset=GBK");
	var sb=new langpack.StringBuffer();
	

	try {
		if(skin!="")request.getSession().setAttribute("USERSKIN",skin);//�޸�Ƥ������ͨ�� L.sp?id=index&skin=blue  
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		if(objid!="") {//����һ������Ĳ���ҳ��
		
			sb.append("<!Doctype HTML><html><head><title>TESTRUN</title><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0\" /><meta name=\"apple-mobile-web-app-capable\" content=\"yes\">    <meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\">    <meta name=\"format-detection\" content=\"telephone=no\"><script language=\"javascript\" src=\"xlsgrid/js/wnd.js\"></script><script language=\"javascript\" src=\"xlsgrid/images/flash/js/jquery-1.7.2.min.js\"></script>");//<LINK rel=stylesheet type=text/css HREF=\"xlsgrid/css/layout.css\">
			sb.append("<style type='text/css'>\n");
			sb.append("A { TEXT-DECORATION: none}\n");
			sb.append("A:link { TEXT-DECORATION: none}\n");
			sb.append("A:visited { TEXT-DECORATION: none}\n");
			sb.append("A:hover { TEXT-DECORATION: underline}\n");
			sb.append("TD {FONT-SIZE: 10.5pt;FONT-FAMILY: ΢���ź�;}\n");
			sb.append("BODY {FONT-SIZE: 10.5pt;FONT-FAMILY: ΢���ź�;height:100%;}\n");
			sb.append("HTML {height:100%;}\n");
			sb.append("</style>\n");
			sb.append("</head>\n");


			sb.append( "<body  topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0>");
			
			GetLayoutItem(db,request,sb,"[%IMAGE deforg='"+deforg+"' ctrltype='obj' ctrlid='"+objid+"' ]",0,0);
			sb.append("</body></html>");
		}
		else {
			// ���ֵ�html
			GetLayoutHTML(db,request,sb,deforg,layoutid,1);
		}
	}
	catch ( ee ) {
		db.Rollback();
		sb.append(ee.toString());
		//throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return sb.toString();
}
//�õ�ĳ�����ֵ�html
//ifneedhead=0 ֻ��ʾhtml����(<body>����)����ʾhtmlǰ׺
function GetLayoutHTML(db,request,sb,deforg,layoutid,ifneedhead)
{
			var ds = db.QuerySQL("select * from LAYHDR where deforg='"+deforg+"' and id='"+layoutid+"'" );
			var colwidths = ds.get(0,"COLWIDTHS" );
			var rowheights = ds.get(0,"ROWHEIGHTS" );
			var sColW = colwidths.split(",");
			var sRowH = rowheights .split(",");


			if(ds.getRowCount()==0 ) return "ʮ�ֱ�Ǹ����Ҫ�ҵ�ҳ�治���ڣ�"+deforg+"-"+layoutid+")";
			var sxgguid = ds.get(0,"SXGGUID");
	
			var sxg = db.getBlob2String("select bdata from formblob where guid='"+sxgguid +"' for update","bdata");
			
			var sxgds = new grdpack.EASXGParse();//deforg,id);f
			var rowheight = pubpack.EAFunc.getXmlAttribute(sxg,"rowheight");
			var colwidth = pubpack.EAFunc.getXmlAttribute(sxg,"colwidth");
			var combine = pubpack.EAFunc.getXmlAttribute(sxg,"combine");
			var cellvalue = pubpack.EAFunc.getXmlAttribute(sxg,"cellvalue" );

			sxgds.initRowCol(rowheight,colwidth);
			for ( var i=0;i<sxgds.rows;i++){
				for ( var c=0;c<sxgds.cols;c++){
					sxgds.SetCellHide(i,c,false);
					//sb.append("i="+i+",c="+c+",hide="+sxgds.GetCellHide(i,c) +"<br>");
				}
			}
			sxgds.initCellValue(cellvalue);
			sxgds.initCellCombine(combine);
			if(ifneedhead!=0){
				sb.append("<!Doctype HTML><html><head><title>"+ds.get(0,"TITLE")+"</title><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/><script language=\"javascript\" src=\"xlsgrid/js/wnd.js\"></script><script language=\"javascript\" src=\"xlsgrid/images/flash/js/jquery-1.7.2.min.js\"></script>");//<LINK rel=stylesheet type=text/css HREF=\"xlsgrid/css/layout.css\">
				sb.append("\n<script>\n");
				//var logininfo = webpack.EASession.GetUserinfo(request);
				//if (logininfo != null)  sb.append("var homeurl=\""+logininfo.getHomeURL()+"\";var mainurl=\""+logininfo.getMainurl()+"\"; \n");
				if( ds.get(0,"PREHTML")!="")sb.append(db.getBlob2String("select bdata from formblob where guid='"+ds.get(0,"PREHTML")+"' for update","bdata") );
					
				sb.append("function keysubmit(evt){ \n");
				sb.append(" try {\n");
				sb.append("   if(evt.keyCode=='13'){ \n");
				sb.append("     if ( document.all('userpwd').value =='' ) document.all('userpwd').focus(); \n");
				sb.append("     else f_login.submit(); \n");
				sb.append("   }\n");
				sb.append(" }catch(e){}");
				sb.append("}\n</script>"); 
				sb.append("<style type='text/css'>\n");
				sb.append("A { TEXT-DECORATION: none}\n");
				sb.append("A:link { TEXT-DECORATION: none}\n");
				sb.append("A:visited { TEXT-DECORATION: none}\n");
				sb.append("A:hover { TEXT-DECORATION: underline}\n");
				sb.append("TD {FONT-SIZE: 10.5pt;FONT-FAMILY: ΢���ź�;background-size:100% 100%;}\n");
				sb.append("BODY {FONT-SIZE: 10.5pt;FONT-FAMILY: ΢���ź�;height:100%;}\n");
				sb.append("HTML {height:100%;}\n");
				sb.append("</style>\n");
				sb.append("</head>");
				if(ds.get(0,"JSGUID")!="")
					sb.append( "<script src='EAFormBlob.sp?guid="+ds.get(0,"JSGUID")+"'></script>");
				var bkcolor =ds.get(0,"BKCOLOR");
				var pagebkcolor = "bgcolor=\""+bkcolor+"\"";if(bkcolor =="")pagebkcolor ="";
				sb.append( "<body "+pagebkcolor+" topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0 onkeydown=\"keysubmit(event)\" ");//onLoad=\"try{document.all('usrid').focus();}catch(e){} try{user_onload();}catch(e){}\"
				if(ds.get(0,"RELOADTIME")!="")sb.append( "try{setInterval('location.reload()',"+ds.get(0,"RELOADTIME")+"*1000);}catch(e){window.status='��ʱ���������';}");
				if(ds.get(0,"BKIMGTYP")=="FULLSCREEN")sb.append( " scroll=no  ");
				if((ds.get(0,"BKIMGTYP")=="DEFAULT"||ds.get(0,"BKIMGTYP")=="")&&ds.get(0,"BKIMG")!="" )sb.append( " background=\""+ds.get(0,"BKIMG")+"\" ");
				if(ds.get(0,"BKCOLOR")!="" )sb.append( " bgcolor=\""+ds.get(0,"BKCOLOR")+"\" ");
				sb.append(">\n");//body
				///sb.append("<div id=\"vertically_center\" style=\"display: inline;\">");
				if(ds.get(0,"BKIMGTYP")=="FULLSCREEN"&&ds.get(0,"BKIMG")!="" )
					sb.append("<div id=\"page_"+layoutid+"\" style=\"width:100%;height:100%;position:absolute;z-index:-1;top:0px;left:0px\" ><img src=\""+ds.get(0,"BKIMG")+"\"  width=\"100%\" height=\"100%\"></div> \n");
				// 
				

			}
			else {
				if(ds.get(0,"BKIMGTYP")=="FULLSCREEN"&&ds.get(0,"BKIMG")!="" ){
					//TD�����챳����䣬TD��������Ϊ position:relative;imgͼƬ����width:100%;height:100%;position:absolute;top:0;left:0;z-index:-1;
					sb.append("<img src='"+ds.get(0,"BKIMG")+"' style=\"width:100%;height:100%;position:absolute;top:0;left:0;z-index:-1;\"/> ");
				}
				//
			}
			//GUID "�ڲ�Ψһ���",ID "���",DEFORG "Ĭ����֯��",NAME "����",CLS "����",NOTE "����",TITLE "ҳ�����",FKWIDTH "ҳ����",FKHEIGHT "ҳ��߶�",BKCOLOR "������ɫ",
			//BKIMG "����ͼƬ",FKALIGN "ˮƽ����",FKVALIGN "��ֱ����",CELLSPACE "������϶",CELLPADDING "�����ڿ�϶",OBJPADDING "�б��ڿ�϶",RELOADTIME "��ʱˢ��ʱ��",
			//ONHTMLGUID "ҳ��ǰHTML",POSTHTMLGUID "ҳ���HTML",CRTDAT "��������",ZXGGUID "����ƽ���ZXG��GUID",SXGGUID "����ƽ���SXG��GUID",LOGOIMG "LOGOͼ���ַ",
			//LOGOIMGW "LOGOͼ���ַW",LOGOIMGH "LOGOͼ���ַH",FKCOLOR "ǰ��ɫ",BKIMGTYP "�������ģʽ",FKGRID "ǰ���߿���ɫ",FKIMG "ǰ�����ͼƬ"
			//if(ds.get(0,"BKIMGTYP")=="FULLSCREEN"&&ds.get(0,"BKIMG")!="" )
			//	sb.append("<div id=\"bkground\" style=\"width:100%;height:100%;position:absolute;z-index:-1;top:0px;left:0px\" ><img src=\""+ds.get(0,"BKIMG")+"\"  width=\"100%\" height=\"100%\"></div> \n");
			//<div id=\"page_"+layoutid+"\" style=\"display: inline;\">
			//sb.append("<table id=\"TABLE_"+layoutid+"_BK\"  style=\"height: 100%;width: 100%;display: inline;vertical-align:"+ifnull(ds.get(0,"FKVALIGN"),"MIDDLE")+";\"><tr><td align=\""+ifnull(ds.get(0,"FKALIGN"),"CENTER")+"\" valign=\""+ifnull(ds.get(0,"FKVALIGN"),"MIDDLE")+"\">");
			sb.append("<table id=\"TABLE_BK\" border=0 cellspacing=0 cellpadding=0 width=100% height=100%><tr><td align=\""+ifnull(ds.get(0,"FKALIGN"),"CENTER")+"\" valign=\""+ifnull(ds.get(0,"FKVALIGN"),"MIDDLE")+"\">\n");
			sb.append("<table id=\"TABLE_"+layoutid+"_FK\" border=0 cellspacing=0 cellpadding=0 "+ifnotnull(ds.get(0,"FKWIDTH")," width="+ds.get(0,"FKWIDTH"))+" "+ifnotnull(ds.get(0,"FKHEIGHT")," height="+ds.get(0,"FKHEIGHT"))+"><tr><td align=\"LEFT\" align=\"TOP\" style=\""+ifnotnull(ds.get(0,"FKGRID"),"border: 1px solid "+ds.get(0,"FKGRID")+";")+" "+ifnotnull(ds.get(0,"FKCOLOR"),"background-color:  "+ds.get(0,"FKCOLOR")+";")+" " + ifnotnull(ds.get(0,"FKIMG")," background-image: url('"+ds.get(0,"FKIMG")+"')")+"\">\n");
			
			// ��sxgȡ��������Ԫ������
			sb.append( "\n<table border=\"0\" width=\"100%\" height=100% id=\"TABLE_MAIN\" cellspacing=\"0\" cellpadding=\"0\" >");
			var rows= sxgds.rows;
			var cols = sxgds.cols;
			var sSumHeight="";//sSumHeight=" height=\""+pageheightfix+"%\" ";
			var sumwidth = 0;
			

			for(var c=0;c<cols;c++){
				try{sumwidth+=sxgds.GetCellColWidth(0,c);}catch(ee){}
			}
						
			for ( var r=0;r<rows;r++ ){
				var rh = 0;
				try{rh = sxgds.GetCellRowHeight(r,0);}catch(ee){}
				sb.append("<tr >");//not use height="+rh+"
				for ( var c=0;c<cols;c++){
					var colw = sxgds.GetCellColWidth(r,c);//*100/sumwidth
					var rowh = sxgds.GetCellRowHeight(r,c);
					if(c<sColW.length() && sColW[c]!="")colw = sColW[c];//ȡ�Զ����п�
					if(r<sRowH.length() && sRowH[r]!="")rowh = sRowH[r];//ȡ�Զ����п�

					var rowspan =sxgds.GetCellRowSpan(r,c)+1;  // �ϲ��ĸ���
					var colspan=sxgds.GetCellColSpan(r,c)+1;

					//�ж��Ƿ�hide,����ʱ����=1��˵���ڽ��������Ѿ����ϲ�
					if(sxgds.GetCellHide(r,c)==false){
						var nCombinerow=0;
						var nEndRow=r;

						sb.append("<td width=\""+colw+"\" height="+rowh+" align=\"left\" valign=\"top\" ");
						if( rowspan>1)sb.append(" rowspan="+rowspan);
						if( colspan>1)sb.append(" colspan="+colspan);
						sb.append(">");
						sb.append("\n<!-- layout item "+ r+"_"+c+"-->\n");
						
              					var  str = sxgds.GetCellText(r,c);

              					GetLayoutItem(db,request,sb,str,r,c);
	              				
	              				sb.append("\n<!-- end layout item "+ r+"_"+c+"-->\n");
	              				sb.append("</td>" );

	                    		}
	                    	}	
				sb.append("</tr>" );
			}
			sb.append( "</table>");	//</td></table>
			sb.append("</td></tr></table>\n");// FK TABLE
			sb.append("</td></tr></table>\n");// BK TABLE
//			sb.append("</div>\n");// 
//			sb.append("<div id=\"extra\" style=\"height: 100%;display: inline;vertical-align: middle;\"></div>");
			if(ifneedhead!=0)sb.append("</body></html>");

}
//����ĳ����Ԫ��������ַ�
function GetLayoutItem(db,request,sb,str,r,c)
{
	
	if ( str == "" ) {sb.append("&nbsp;");return ;}
	if(str.length()>=8)
		str = str.substring(8);//[%IMAGE 
	var idx = -1;
	var oldidx= 0;
	var layobjds = null;
	var deforg = "";
	var ctrlid = "";var ctrltype ="";
	var src = "";	var width = ""; var height = ""; var border = ""; var background="";var text = "";var color="";var html = "";var size="";var align="" ; var valign=""; var url=""; var target=""; var cellspace = "";var bkcolor="";var val="";
	while((idx=str.indexOf("='",idx+1))>0){
		var attrid = str.substring(oldidx,idx);
		if(attrid.substring(0,1)==" ")attrid=attrid.substring(1);
		oldidx=	str.indexOf("' ",idx+1)+2;
		var attrval= str.substring(idx+2,oldidx-2);
		if(oldidx==1)
			attrval= str.substring(idx+2,str.length-1);
		if(attrid=="ctrlid")ctrlid=attrval;
		else if(attrid=="ctrltype")ctrltype =attrval;//=pag,obj
		else if(attrid=="deforg")deforg =attrval;
		else if(attrid=="src")src =attrval;
		else if(attrid=="width")width =attrval;
		else if(attrid=="height")height=attrval;
		else if(attrid=="border")border =attrval;
		else if(attrid=="background")background=attrval;
		else if(attrid=="text")text=attrval;
		else if(attrid=="color")color=attrval;
		else if(attrid=="size")size=attrval;
		else if(attrid=="html")html=attrval;
		else if(attrid=="align")align=attrval;
		else if(attrid=="valign")valign=attrval;
		else if(attrid=="target")target=attrval;
		else if(attrid=="url")url=attrval;
		else if(attrid=="cellspace")cellspace=attrval;		
		else if(attrid=="bkcolor")bkcolor=attrval;	
		else if(attrid=="value")val=attrval;		
		
	}
	
	if(deforg!="" && ctrlid!="" ) {
		var sURLHTML=  "";
		if(url!=""){
			var sClick ="";
			if ( target == "" || target=="_self"  ) //||targetLayoutid.length()!=0
		          sClick="javascript:window.location='"+url+"';";
		        else if ( target=="_blank" ) 
		          sClick="javascript:window.open('"+url+"');";
		        else if ( target!="_self" ) 
		          sClick="javascript:frames['"+target+"'].location='"+url+"';";
			sURLHTML=" onclick=\""+sClick+"\" onmouseover=\"this.style.cursor='hand';\""; 
		}
		if(ctrlid=="IMAGE"){
			//[%IMAGE deforg='XLSGRID' ctrltype='obj' ctrlid='IMAGE' id='IMAGE-1' src='xlsgrid/images/flash/icon/icon_171.png' value='ͼƬ'  width='' height='' border='0' background='' ]
			var imghtml = "<img src='"+src +"' border="+ifnull(border,"0")+" "+ifnotnull(width,"width="+width)+" "+ifnotnull(height,"height="+height)+" >";
			if ( src =="" ) imghtml = "&nbsp;";
			var sStyle = "style=\"";
			if(background!="")
				sStyle += "background-image: url('"+background+"'); background-repeat: repeat-x;";
			sStyle += "\"";
			sb.append("<table border=0 width=100% height=100% cellspacing=\""+cellspace+"\"  cellpadding=\"0\"  ><tr><td "+sStyle +" bgcolor=\""+bkcolor+"\" align="+ifnull(align,"left")+" valign="+ifnull(valign,"top")+sURLHTML+">"+imghtml+"</td></tr></table>" );
		}
		else if(ctrlid=="WP8ICON"){
			var imghtml = "<img src='"+src +"' border="+ifnull(border,"0")+" "+ifnotnull(width,"width="+width)+" "+ifnotnull(height,"height="+height)+" >";
			if ( src =="" ) imghtml = "&nbsp;";
			var sStyle = "style=\"";
			if(background!="")
				sStyle += "background-image: url('"+background+"'); background-repeat: repeat-x;";
			sStyle += "\"";
			sb.append("<table border=0 width=100% height=100% cellspacing=\""+cellspace+"\"  cellpadding=\"0\"  ><tr ><td "+sStyle+" bgcolor=\""+bkcolor+"\" align="+ifnull(align,"center")+" valign="+ifnull(valign,"middle")+sURLHTML+">"+imghtml+"<br><font size=\""+ifnull(size,"2")+"\" color=\""+ifnull(color,"#FFFFFF")+"\" >"+val+"</font></td></tr></table>" );

		}
		else if(ctrlid=="ICONTEXT"){
			var imghtml = "<img src='"+src +"' border="+ifnull(border,"0")+" "+ifnotnull(width,"width="+width)+" "+ifnotnull(height,"height="+height)+" >";
			if ( src =="" ) imghtml = "&nbsp;";
			var sStyle = "style=\"";
			if(background!="")
				sStyle += "background-image: url('"+background+"'); background-repeat: repeat-x;";
			sStyle += "\"";
			sb.append("<table border=0 width=100% height=100% cellspacing=\""+cellspace+"\"  cellpadding=\"0\"  ><tr ><td "+sStyle+" bgcolor=\""+bkcolor+"\" align="+ifnull(align,"center")+" valign="+ifnull(valign,"middle")+sURLHTML+">"+imghtml+"<br><font size=\""+ifnull(size,"2")+"\" color=\""+ifnull(color,"#FFFFFF")+"\" >"+val+"</font></td></tr></table>" );

		}

		else if(ctrlid=="TEXT"){		
			//[%IMAGE deforg='XLSGRID' ctrltype='obj' ctrlid='IMAGE' id='IMAGE-1' src='xlsgrid/images/flash/icon/icon_171.png' value='ͼƬ'  width='' height='' border='0' background='' ]
			sb.append("<table border=0 width=100% height=100% cellspacing=\"0\"  cellpadding=\"0\"><tr><td align=left valign=right "+sURLHTML+"><font "+ifnotnull(size,"size="+size)+" "+ifnotnull(color,"color="+color)+">"+text+"</font></td></tr></table>" );
		}
		else if(ctrlid=="HTML"){
			//[%IMAGE deforg='XLSGRID' ctrltype='obj' ctrlid='IMAGE' id='IMAGE-1' src='xlsgrid/images/flash/icon/icon_171.png' value='ͼƬ'  width='' height='' border='0' background='' ]
			if(html!="" ){
				sb.append("<table border=0 width=100% height=100% cellspacing=\"0\"  cellpadding=\"0\"><tr><td align=left valign=right >"+db.getBlob2String("select bdata from formblob where guid='"+html+"' for update","bdata")+"</td></tr></table>" );
			}
		}
		else {
			if(ctrltype=="pag"){
				//sb.append("<div id=\"div_page"+ctrlid+"\" width=100% height=100%>\n");
				sb.append("<table border=0 cell width=100% height=100% cellspacing=\"0\"  cellpadding=\"0\"><tr><td align=left valign=top style=\"position:relative;\">");
				GetLayoutHTML(db,request,sb,deforg,ctrlid,0);
				sb.append("\n</td></tr></table>\n");

				//sb.append("\n</div>\n");
				
			}
			else {
				//sb.append("select * from layobj where deforg='"+deforg+"' and id='"+ctrlid+"'");
				var ds = db.QuerySQL("select * from layobj where deforg='"+deforg+"' and id='"+ctrlid+"'");
				if(ds.getRowCount()>0){
					
					if( ds.get(0,"PREHTML")!="")sb.append(db.getBlob2String("select bdata from formblob where guid='"+ds.get(0,"PREHTML")+"' for update","bdata") );
	
					//GUID "�ڲ�Ψһ���",ID "���",NAME "����",CLS "����",WNDMOD "���ڷ���Ѳ���",IFTITILE "�Ƿ���ʾ�����Ѳ���",TITLE "����",BKCOLOR "������ɫ",BKIMG "����ͼƬ",WNDOUT "��������",WNDIN "�����ڼ��",DSMOD "������Դ",SORTBY "����",WHEREBY "����",SQLTXT "SQL���",OSSYT "OSϵͳ",OSMWID "OS�м��",OSFUNC "OS����",OSPARAM "OS�����Ĳ���",SYTID "�������ϵͳ���",SHOMOD "��ʾ���",CRTDAT "��������",LAYCOL "������",LAYROW "������",IFPAGE "�Ƿ��ҳ",PAGEROW "ÿҳ�м�¼��",IFSCROLLBAR "�Ƿ���ʾ������",LOGOIMG "Ԥ��ͼƬ��·��",OBJBKCOLOR "�����ؼ��ı�����ɫ",OBJBKIMG "�����ؼ��ı���ͼƬ",NOTE "��ע",LOGOIMGW "Ԥ��ͼƬ�Ŀ��",LOGOIMGH "Ԥ��ͼƬ�ĸ߶�",DEFORG "Ĭ����֯��",TITLEICON "����ͼ��",TITLEHTML "�������ֱ����һ��HTML",TITLEFONTSIZE "���������С",WNDBORDER "���ڱ߿���ɫ",LISTIN "���֮��ļ��",TITLEFKCOLOR "����������ɫ",TITLBFKCOLOR "���ⱳ����ɫ",ONHTMLGUID "Ƕ��ǰ��HTML",POSTHTMLGUID "Ƕ�����HTML",BKBORDOR "�߿���ɫ"
					sb.append("<table id=\"TABLE_CELL"+r+"_"+c+"\" border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\""+ifnull(ds.get(0,"WNDOUT"),"0")+"\" cellpadding=\"0\" ><tr><td align=\"left\" valign=\"top\" style=\"");
					var styleHTML="";
					if(ds.get(0,"BKBORDOR")!="")sb.append("border: 1px solid "+ds.get(0,"BKBORDOR")+";");
					if(ds.get(0,"BKIMG")!=""){
						sb.append("background-image: url('"+ds.get(0,"BKIMG")+"'); background-repeat: repeat-x\"> \n");
						//sb.append("position:relative;\"> \n");
						//sb.append("<img src='"+ds.get(0,"BKIMG")+"' border=0 style=\"width:100%;height:100%;position:absolute;top:0;left:0;z-index:-1;\">");//
					}
					else sb.append("\"> \n");
					sb.append("<table border=\"0\"  width=\"100%\" height=\"100%\" cellspacing=\"0\"  cellpadding=\"0\">\n");
					
					// ��ʾ����
					if(ds.get(0,"TITLEMODE")!=""&& ds.get(0,"TITLEMODE")!="NVL"){//TITLEBKIMG
						if(ds.get(0,"TITLEMODE")=="STD"){
							var sUrl = "<a href=\""+ds.get(0,"TITLEURL")+"\" target=\""+ds.get(0,"TITLETARGET")+"\">";
							var sUrlEnd = "";
							if(ds.get(0,"TITLEURL")==""){sUrl ="";sUrlEnd ="";}
							sb.append("<tr><td align=\"left\" height=\""+ifnull(ds.get(0,"TITLEHEIGHT"),"30")+"\"  cellspacing=\"0\" cellpadding=\"0\" "+ifnotnull(ds.get(0,"TITLBFKCOLOR"),"bgcolor="+ds.get(0,"TITLBFKCOLOR"))+" style=\"position:relative;\"> ");//ifnotnull(ds.get(0,"BKBORDOR"),"border-bottom: 1px solid "+ds.get(0,"BKBORDOR")+";")+
							if(ds.get(0,"TITLEBKIMG")!=""){
								//TD�����챳����䣬TD��������Ϊ position:relative;imgͼƬ����width:100%;height:100%;position:absolute;top:0;left:0;z-index:-1;
								sb.append("<img src='"+ds.get(0,"TITLEBKIMG")+"' border=0 style=\"width:100%;height:100%;position:absolute;top:0;left:0;z-index:-1;\">");//
							}
								//style="position:relative;"><img src='EAFormBlob.sp?guid=E58DCBED67194382BABBC13562E5FA24' style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:-1;"/> 

							sb.append("<table id=\"TABLE_TITLE_"+r+"_"+c+"\" border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"5\" cellpadding=\"0\" >
										<tr><td width=\""+ifnull(ds.get(0,"TITLEHEIGHT"),"30")+"\"> "+
										ifnotnull(ds.get(0,"TITLEICON")," <img border=0 src=\""+ds.get(0,"TITLEICON")+"\">" )
										+"</td><td align=\""+ifnull(ds.get(0,"TITLEALIGN"),"left")+"\" valign=\"middle\">&nbsp;<font size=\""+ifnull(ds.get(0,"TITLEFONTSIZE"),"2")+"\" color=\"#FFFFFF\">"+sUrl +ds.get(0,"TITLE")+sUrlEnd +"</font></td></tr>
									</table>
								</td></tr> \n" );
						}
						else if(ds.get(0,"TITLEMODE")=="HTML"){
							sb.append( db.getBlob2String("select bdata from formblob where guid='"+ds.get(0,"TITLEHTML")+"' for update","bdata") );
						}
					}
					sb.append("<tr><td align=\"left\" valign=\"top\" "+ifnotnull(ds.get(0,"OBJBKCOLOR"),"bgcolor=\""+ds.get(0,"OBJBKCOLOR")+"\"")+">
								<table id=\"TABLE_CELL_"+r+"_"+c+"_MAIN\" border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\""+ifnull(ds.get(0,"WNDIN"),"0")+"\" cellpadding=\"0\" >
									<tr><td align=left valign=top>"+
									GetBody(db,request,deforg,ds.get(0,"WNDMOD"),ds.get(0,"DSMOD"),ds.get(0,"WHEREBY"),ds.get(0,"SORTBY"),ds.get(0,"SQLTXT"),ds.get(0,"LAYCOL"),ds.get(0,"LAYROW"),ds.get(0,"PAGEROW"),ds.get(0,"OSMWID"),ds.get(0,"OSFUNC"),ds.get(0,"OSPARAM"),ds.get(0,"IFRAMEURL"),ds.get(0,"IFSCROLLBAR"),ds.get(0,"HTMLGUID"),ds.get(0,"MOREURL"),ds.get(0,"OPENLAYID") )
									+"</td></tr>
								</table>
							</td></tr>
						</table>
					</td></tr></table> ");
						
				
			//		sb.append("<table id=\"TABLE_CELL"+r+"_"+c+"_BK\" border=0 cellspacing="+ifnull(ds.get(0,"WNDOUT"),"0")+" width=100% height=100%><tr><td align=CENTER valign=MIDDLE style=\""+ifnotnull(ds.get(0,"OBJBKCOLOR"),"background-color:  "+ds.get(0,"OBJBKCOLOR")+";")+" " + ifnotnull(ds.get(0,"OBJBKCOLOR")," background-image: url('"+ds.get(0,"OBJBKCOLOR")+"')")+"\">\n");
			///		ifnotnull(ds.get(0,"BKBORDOR"),"border: 1px solid "+ds.get(0,"FKGRID")+";")+" "+
					//sb.append("<tr><td ifnull(ds.get(0,"FKVALIGN"),"MIDDLE")> " );WNDOUT 
						
					//sb.append("AAA</td></tr></table>\n");
				}
				else {
					sb.append("data not found: deforg='"+deforg+"' and id='"+ctrlid+"'");
				}
			}
		}
		
	
	}
	
}
//WNDMOD ���ڷ��, DSMOD ������Դ ,WHEREBY ����, SORTBY ����,SQLTXT  SQL���, LAYCOL ������ ,LAYROW ������,PAGEROW ÿҳ�м�¼��, OSMWID OS�м��, OSFUNC OS����,OSPARAM OS�����Ĳ���,IFRAMEURL IFRAME��URL,IFSCROLLBAR �Ƿ���ʾ������,HTMLGUID HTML
// ,MOREURL  ���ఴť,OPENLAYID  ����б�򿪵Ĳ��֣�
function GetBody(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,PAGEROW ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	//�ڷ����OS�����������м���ķ���˽ű�
	//˵����x_SQLINPUT��ָxϵͳSQLINPUT�м��
	if(WNDMOD=="TBODY"){
		var ds = db.QuerySQL("select OSSYT,OSMWID,OSFUNC from LHTML where id='"+WNDMOD+"'");
		if(ds.getRowCount()>0){
			var OSSYT = ds.getStringAt(0,"OSSYT");
			var OSMWID = ds.getStringAt(0,"OSMWID");
			var OSFUNC = ds.getStringAt(0,"OSFUNC");
			var eas = new pub.EAScript(null);                		 
			//�����ҵ��󣬾�ִ�з�����������ָ��funname��ʵ���ļ����֣�MyFun���ļ��ĸ��ڵ㣬funName�Ƿ�������
			try{
				eas.DefineScopeVar("db", db);
				eas.DefineScopeVar("request", request);
				eas.DefineScopeVar("deforg", deforg);
				eas.DefineScopeVar("WNDMOD", WNDMOD);
				eas.DefineScopeVar("DSMOD", DSMOD);
				eas.DefineScopeVar("WHEREBY", WHEREBY);
				eas.DefineScopeVar("SORTBY", SORTBY);
				eas.DefineScopeVar("SQLTXT", SQLTXT );
				eas.DefineScopeVar("LAYCOL", LAYCOL );
				eas.DefineScopeVar("LAYROW", LAYROW);
				eas.DefineScopeVar("PAGEROW", PAGEROW );
				eas.DefineScopeVar("OSMWID", OSMWID);
				eas.DefineScopeVar("OSFUNC", OSFUNC);
				eas.DefineScopeVar("OSPARAM", OSPARAM);
				eas.DefineScopeVar("IFRAMEURL", IFRAMEURL);
				eas.DefineScopeVar("IFSCROLLBAR", IFSCROLLBAR);
				eas.DefineScopeVar("HTMLGUID", HTMLGUID);
				eas.DefineScopeVar("MOREURL", MOREURL);
				eas.DefineScopeVar("OPENLAYID", OPENLAYID);
				var ret =  eas.CallClassFunc(""+OSSYT +"_"+OSMWID+"",""+OSFUNC+"",null).castToString();
				return ret;
			}catch(e){
				throw new Exception(e);
			}
		}else{
			return "";
		}
	}
	
	var parent = new x_LHTML();
	return parent.GetBody(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,PAGEROW ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
}


// if val1==val2 then var3 else val4
function ifcase(val1,val2,val3,val4)
{	
	if(val1==val2)return val3;else return val4;
}
// if val1=="" then va2
function ifnull(val1,val2)
{	
	if(""+val1=="")return val2;else return val1;
}
// if val1=="" then va2 else return ""
function ifnotnull(val1,val2)
{	
	if(""+val1=="")return "";else return val2;
}

// �ͻ���param����Ĳ�������ֱ��ʹ��
function SaveAS()
{
	var db = null;
	var guid = "";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		guid = db.GetSQL("select sys_guid() guid from dual");
		var ds = db.QuerySQL("select COLUMN_NAME from user_tab_columns where table_name='LAYHDR'");
		var cols="";
		for ( var i=0;i<ds.getRowCount();i++){
			var colname= ds.getStringAt(i,"COLUMN_NAME");
			if(colname!="GUID"&& colname!="ID"){
				cols+=","+colname;	
			}
		}
		var sql ="insert into LAYHDR(guid,id"+cols+") select '"+guid+"','"+id+"'"+cols+" from layhdr where id='"+oldid+"' and deforg='"+deforg+"'";
		
		var retnum=db.ExcecutSQL(sql);
		
		db.Commit();	
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return guid ;
}

function GetColor()
{
	var ret = "";
	try {
		var txt =pubpack.EAFunc.readFile( pubpack.AppStartListener.approot + path + "/readme.txt" );
		var ss = txt.split("\r\n");
		for ( var i=0;i<ss.length();i++){
			var sss = ss[i].split(",");
			if(sss.length()>=2&& sss[0]==filename){
				ret = sss[1];break;
			}
		}
	}catch(e){
		ret=e.toString();
	}
	return ret;
}
}