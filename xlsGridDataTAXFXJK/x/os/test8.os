function x_test8(){	var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
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
				gethtmlhead(db,ds,sb);
				sb.append( "<body  topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0>");
				
				GetLayoutItem(db,request,sb,"[%IMAGE deforg='"+deforg+"' ctrltype='obj' ctrlid='"+objid+"' ]",0,0,0);
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
				var CELLPADDING = 1*ifnull(ds.get(0,"CELLPADDING"),"0");	//��Ԫ��֮��ļ�϶	
				var CELLSPACE = 1*ifnull(ds.get(0,"CELLSPACE"),"0");	//���ӱ߾�	
				var layflg = ifnull(ds.get(0,"LAYFLG"),"DIV");		//���ַ��
				var fixflg = ifnull(ds.get(0,"FIXFLG"),"FIXWH");	//����ģʽ
				var margin_top = ifnull(ds.get(0,"margin_top"),"0");  //��߾���
				var margin_left = ifnull(ds.get(0,"margin_left"),"0");  //��߾���
				var margin_right = ifnull(ds.get(0,"margin_right"),"0");  //��߾���
				var margin_bottom = ifnull(ds.get(0,"margin_bottom"),"0");  //��߾���
				var min_width= ifnull(ds.get(0,"min_width"),"0");  //��С���

				
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
					gethtmlhead(db,ds,sb);
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
//					if(ds.get(0,"BKIMGTYP")=="FULLSCREEN"&&ds.get(0,"BKIMG")!="" ){
//����ͼƬ�����ݻ���������			//TD�����챳����䣬TD��������Ϊ position:relative;imgͼƬ����width:100%;height:100%;position:absolute;top:0;left:0;z-index:-1;
//�Ѿ����������ʹ��				sb.append("<img src='"+ds.get(0,"BKIMG")+"' style=\"width:100%;height:100%;position:absolute;top:0;left:0;z-index:-1;\"/> ");
//					}
					
				}
				//�ж��Ƿ���Ҫ������ǰ��
				if(!(ds.get(0,"FKALIGN")=="" &&ds.get(0,"FKVALIGN")=="" &&ds.get(0,"FKWIDTH")=="" && ds.get(0,"FKHEIGHT")=="" && ds.get(0,"FKGRID")=="" && ds.get(0,"FKCOLOR")=="" && ds.get(0,"FKIMG")=="" )){
					sb.append("<div id=\"TABLE_BK\" style=\"\">" );
	
					sb.append("<div id=\"TABLE_"+layoutid+"_FK\" style=\""+ifnotnull(ds.get(0,"FKGRID"),"border: 1px solid "+ds.get(0,"FKGRID")+";")+" "+ifnotnull(ds.get(0,"FKCOLOR"),"background-color:  "+ds.get(0,"FKCOLOR")+";")+" " + ifnotnull(ds.get(0,"FKIMG")," background-image: url('"+ds.get(0,"FKIMG")+"')")+"");
					sb.append(ifnotnull(ds.get(0,"FKWIDTH")," width:"+ds.get(0,"FKWIDTH"))+" ; "+ifnotnull(ds.get(0,"FKHEIGHT")," height:"+ds.get(0,"FKHEIGHT"))+";margin-left:"+margin_left+"%; margin-right:"+margin_right+"%; margin-bottom:"+margin_bottom+"%; margin-top:"+margin_top+"%;\">");
	
					//sb.append("<table id=\"TABLE_BK\" border=0 cellspacing=0 cellpadding=0 width=100% height=100%><tr><td align=\""+ifnull(ds.get(0,"FKALIGN"),"CENTER")+"\" valign=\""+ifnull(ds.get(0,"FKVALIGN"),"MIDDLE")+"\">\n");
					//sb.append("<table id=\"TABLE_"+layoutid+"_FK\" border=0 cellspacing=0 cellpadding=0 "+ifnotnull(ds.get(0,"FKWIDTH")," width="+ds.get(0,"FKWIDTH"))+" "+ifnotnull(ds.get(0,"FKHEIGHT")," height="+ds.get(0,"FKHEIGHT"))+"\"><tr><td align=\"LEFT\" align=\"TOP\" style=\""+ifnotnull(ds.get(0,"FKGRID"),"border: 1px solid "+ds.get(0,"FKGRID")+";")+" "+ifnotnull(ds.get(0,"FKCOLOR"),"background-color:  "+ds.get(0,"FKCOLOR")+";")+" " + ifnotnull(ds.get(0,"FKIMG")," background-image: url('"+ds.get(0,"FKIMG")+"')")+"\">\n");
				}
				// ˮƽ
				var wflg = "1";//ˮƽ���� �ٷֱȻ���pt =0 % else pt
				var aflg = "1";//��ֱ���� �ٷֱȻ���pt =0 % else pt
				if(fixflg=="FIXW"||fixflg=="FIXWH")wflg="0";
				if(fixflg=="FIXH"||fixflg=="FIXWH")aflg="0";
				
				var dflg = layflg;//DIV DIVFLW TABLE
				sb.append("<!-- debug info:layoutid="+layoutid+" fixflg="+fixflg+",layflg="+layflg+",wflg="+wflg+",aflg ="+aflg +",dflg="+dflg+" -->\n");
				// ��sxgȡ��������Ԫ������
				if(dflg =="TABLE"){
					sb.append( "\n<table id=\"PAGE_MAIN_"+layoutid+"\" border=\"0\" width=\"100%\"  height=100% id=\"TABLE_MAIN\" cellspacing=\"0\" cellpadding=\"0\" >\n");
				}
				else {
					//������С���
					var stylet="style=\"position:relative ;width:100%;margin:"+CELLSPACE+"px;height:100%;min-width:"+min_width+"px;_width:expression((document.documentElement.clientWidth||document.body.clientWidth)<"+min_width+"?"+min_width+":auto);\"";									 
					sb.append( "\n<div id=\"PAGE_MAIN_"+layoutid+"\" "+stylet +">");
					

				}
	
				var rows= sxgds.rows;
				var cols = sxgds.cols;
				var sSumHeight="";//sSumHeight=" height=\""+pageheightfix+"%\" ";
				
				if(dflg=="DIV") {//  DIV����-����-������վ
					
					f_getdivtree(db,request,sb,sxgds,dflg,aflg,wflg,sColW,sRowH,CELLPADDING ,0,0,rows-1,cols-1,0,layoutid);	//�ݹ飬��ȡ���ε�DIV�ṹ
				}
				else {	//TABLE or div flw
					var sumwidth = 0;
					var sumheight = 0;
					if(dflg=="DIVFLW"){
						for(var c=0;c<cols;c++){
							try{sumwidth+=1*getcolw(sxgds,sColW,c)+1*CELLPADDING ;}catch(ee){}
						}
						if(cols>0) sumwidth+=CELLPADDING ;
						for(var c=0;c<rows;c++){
							try{sumheight +=1*getrowh(sxgds,sRowH,c)+1*CELLPADDING ;}catch(ee){}
						}
						if(rows>0) sumheight +=CELLPADDING ;	
					}
					else{	
						for(var c=0;c<cols;c++){
							try{sumwidth+=1*getcolw(sxgds,sColW,c);}catch(ee){}
						}
						for(var c=0;c<rows;c++){
							try{sumheight +=1*getrowh(sxgds,sRowH,c);}catch(ee){}
						}
					}				
					for ( var r=0;r<rows;r++ ){
						var rh = 0;
						try{rh = sxgds.GetCellRowHeight(r,0);}catch(ee){}
						if(dflg =="TABLE") sb.append("<tr >");
						for ( var c=0;c<cols;c++){
							var colw = getcellcolw(sxgds,sColW,r,c,CELLPADDING ); 
							var rowh = getcellrowh(sxgds,sRowH,r,c,CELLPADDING );
		
							var rowspan =sxgds.GetCellRowSpan(r,c)+1;  // �ϲ��ĸ���
							var colspan=sxgds.GetCellColSpan(r,c)+1;
							//�ж��Ƿ�hide,����ʱ����=1��˵���ڽ��������Ѿ����ϲ�
							if(sxgds.GetCellHide(r,c)==false){
								var nCombinerow=0;
								var nEndRow=r;
								var top = 0;
								var left =0;
								for ( var rr=0;rr<r;rr++) top+=CELLPADDING +getrowh(sxgds,sRowH,r);
								for ( var cc=0;cc<c;cc++) left+=CELLPADDING +getcolw(sxgds,sColW,c);
								//float:left;
								if(dflg =="TABLE"){
									sb.append("<td width=\""+NStr(colw,sumwidth,wflg)+"\" height="+NStr(rowh,sumheight ,aflg)+" align=\"left\" valign=\"top\" ");
									if( rowspan>1)sb.append(" rowspan="+rowspan);
									if( colspan>1)sb.append(" colspan="+colspan);
									sb.append(">");
								}
								else {//position: absolute; top: "+NStr(top,sumheight ,aflg)+"; left: "+NStr(left,sumwidth,wflg)+";
									sb.append("\r\n<div id=\"DIV_"+r+"_"+c+"\" style=\"float:left;width:"+NStr(colw,sumwidth,wflg)+";height:"+NStr(rowh,sumheight ,aflg)+";margin:"+CELLPADDING +"px;\"   ");//padding:10px;  //width=\""+colw+"\" height="+rowh+" align=\"left\" valign=\"top\"						//if( rowspan>1)sb.append(" rowspan="+rowspan);
									sb.append(">");
								}
								
								sb.append("\n<!-- layout item "+ r+"_"+c+"-->\n");
								
		              					var  str = sxgds.GetCellText(r,c);
		

		              					GetLayoutItem(db,request,sb,str,r,c,rowh);
			              				
			              				sb.append("\n<!-- end layout item "+ r+"_"+c+"-->\n");
			              				if(dflg =="TABLE")sb.append("</td>" );
								else sb.append("</div>" );
			                    		}
			                    	}	
						if(dflg =="TABLE")sb.append("</tr>" );
					}
				}
				if(dflg =="TABLE")sb.append("</table>" );
				else sb.append( "</div>");	//</td></table>
				if(!(ds.get(0,"FKALIGN")=="" &&ds.get(0,"FKVALIGN")=="" &&ds.get(0,"FKWIDTH")=="" && ds.get(0,"FKHEIGHT")=="" && ds.get(0,"FKGRID")=="" && ds.get(0,"FKCOLOR")=="" && ds.get(0,"FKIMG")=="" )){
					//sb.append("</td></tr></table>\n");// FK TABLE
					//sb.append("</td></tr></table>\n");// BK TABLE
					sb.append("</div>");
					sb.append("</div>");
					//sb.append("<div style=\"height:100%; overflow:hidden; display:inline-block; width:1px; overflow:hidden; margin-left:-1px; zoom:1; *display:inline; *margin-top:-1px; _margin-top:0; vertical-align:middle;\"></div>");
				}
				if(ifneedhead!=0)sb.append("</body></html>");
	
	}
	// html head style public 
	function gethtmlhead(db,ds,sb)
	{
		sb.append("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html  xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>"+ds.get(0,"TITLE")+"</title><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/><script language=\"javascript\" src=\"xlsgrid/js/wnd.js\"></script><script language=\"javascript\" src=\"xlsgrid/images/flash/js/jquery-1.7.2.min.js\"></script>");//<LINK rel=stylesheet type=text/css HREF=\"xlsgrid/css/layout.css\">
		sb.append("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes\" /> ");
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
		sb.append("TD {FONT-SIZE: 10.5pt;FONT-FAMILY: ΢���ź�;}\n");//background-size:100% 100%;
		
		sb.append("BODY {FONT-SIZE: 10.5pt;FONT-FAMILY: ΢���ź�;height:100%; text-align:center;");
		if(ds.get(0,"FKVALIGN")=="MIDDLE"){// �����Ҫ���ж��룬html��body��100�߶ȶ��ǲ���ȱ��
			sb.append("height:100%;}\n");//
			sb.append("HTML {height:100%;}\n");
		}
		else sb.append("}\n");
		sb.append("</style>\n");
		sb.append("</head>");
		if(ds.get(0,"JSGUID")!="")
			sb.append( "<script src='EAFormBlob.sp?guid="+ds.get(0,"JSGUID")+"'></script>");
	
	}
	
	//�ݹ飬��ȡ���ε�DIV�ṹ
	function f_getdivtree(db,request,sb,sxgds,dflg,aflg,wflg,sColW,sRowH,CELLPADDING,r1,c1,r2,c2,loopnum,layoutid)
	{
		if(loopnum>50) return ;
		if(r1==sxgds.rows||c1==sxgds.cols||r2==sxgds.rows||c2==sxgds.cols)return;
	
	
		loopnum=loopnum+1;
		//sb.append( "f_fgetdivtree"+ "("+r1+","+c1+")("+r2+","+c2+") <BR>");
		//1.�õ���r1,c1�����ܵ��и���
		var ret = f_getsplit(sb,sxgds,r1,c1,r2,c2);
		//sb.append( "return "+ret+"<BR>" );
		var ss = ret.split(",");
		if(ret !=""&&ss.length()>=5){// ���Էָ�
			//sb.append( "<!-- �ָ�"+ret+" -->\n");
			var colw= 0;
			var rowh= 0;
			for(var c=c1;c<=1*ss[1];c++)
				colw+=getcolw(sxgds,sColW,c);
			for(var r=r1;r<=1*ss[0];r++)
				rowh+=getrowh(sxgds,sRowH,r);
			//sumwidth sumheight Ҫ�������򣨶������������������
			var sumwidth = 0;
			var sumheight = 0;
			for(var c=c1;c<=c2;c++){
				try{sumwidth+=1*getcolw(sxgds,sColW,c) ;}catch(ee){}
			}
			for(var c=r1;c<=r2;c++){
				try{sumheight +=1*getrowh(sxgds,sRowH,c);}catch(ee){}
			}
			sb.append("<!-- colw="+colw+",sumwidth="+sumwidth+" -->" );
	
			sb.append( "<div id=\""+layoutid+"_"+r1+"_"+c1+"_"+ss[0]+"_"+ss[1]+"\" style=\"margin:0px;padding:0px;"+ss[4]+"width:"+NStr(colw,sumwidth,wflg)+";height:"+NStr(rowh,sumheight ,aflg)+";\" >\n" );
			f_getdivtree(db,request,sb,sxgds,dflg,aflg,wflg,sColW,sRowH,CELLPADDING,r1,c1,1*ss[0],1*ss[1],loopnum,layoutid);
			sb.append( "</div>\n" );
			
			colw= 0;
			rowh= 0;
			for(var c=1*ss[3];c<=c2;c++)
				colw+=getcolw(sxgds,sColW,c);
			for(var r=1*ss[2];r<=r2;r++)
				rowh+=getrowh(sxgds,sRowH,r);
			sb.append("<!-- colw="+colw+",sumwidth="+sumwidth+" -->" );
	
			sb.append( "<div id=\""+layoutid+"_"+ss[2]+"_"+ss[3]+"_"+r2+"_"+c2+"\" style=\"margin:0px;padding:0px;"+ss[4]+"width:"+NStr(colw,sumwidth,wflg)+";height:"+NStr(rowh,sumheight ,aflg)+";\">\n" );
			f_getdivtree(db,request,sb,sxgds,dflg,aflg,wflg,sColW,sRowH,CELLPADDING,1*ss[2],1*ss[3],r2,c2,loopnum,layoutid);
			sb.append( "</div>\n" );
		}
		else {//
			//var colw = getcellcolw(sxgds,sColW,r1,c1,0 ); 
			//var rowh = getcellrowh(sxgds,sRowH,r1,c1,0);
			//var top = 0;	var left =0;
			//for ( var rr=0;rr<r1;rr++) top+=getrowh(sxgds,sRowH,r1);
			//for ( var cc=0;cc<c1;cc++) left+=getcolw(sxgds,sColW,c1);
			// ���ڵ������
			//sb.append( "=============================����"+r1+","+c1+"<BR>" );
			//sb.append("\r\n<div id=\"CELL_"+r1+"_"+c1+"\" style=\"float:left;width:"+NStr(colw,sumwidth,wflg)+";height:"+NStr(rowh,sumheight ,aflg)+";margin:"+CELLPADDING+"px;padding:0px;\" >");//padding:10px; //position: absolute; top: "+NStr(top,sumheight ,wflg)+"; left: "+NStr(left,sumwidth,wflg)+";
			sb.append("\n<!-- layout item "+ r1+"_"+c1+"-->\n");
			var  str = sxgds.GetCellText(r1,c1);
			GetLayoutItem(db,request,sb,str,r1,c1,0);
			sb.append("\n<!-- end layout item "+ r1+"_"+c1+"-->\n");
			//sb.append( "</div>\n" );
		
		}
		
	
		//else sb.append( "���ֹ��ڸ��ӣ��޷�����" );
	}
	
	//�õ���r1,c1,r2,c2�����ܵ��и���
	//���ء�������ʾ�����ٷָ���
	function f_getsplit(sb,sxgds,r1,c1,r2,c2)
	{
		var colspan =sxgds.GetCellColSpan(r1,c1);  // �ϲ��ĸ���
		var rowspan=sxgds.GetCellRowSpan(r1,c1);
	
		var comr2 = r1+rowspan;
		var comc2 = c1+colspan;
		//sb.append( "f_getsplit("+r1+","+c1+")("+r2+","+c2+") combine("+comr2+","+comc2 +")<BR>" );
		
		if(checkcolover(sxgds,r1,c1,r2,c2,comr2,comc2)==false&&comr2 !=r2){	//// �жϱ��У����ϲ��������ұ�Ϊֹ���Ƿ��г���������;��Ϊˮƽ��һ��
			sb.append("<!--ˮƽ��һ��"+ comr2+","+c2+","+(comr2+1)+","+c1+"-->\n" );
			return ""+ comr2+","+c2+","+(comr2+1)+","+c1+",float:none;";//ˮƽ not neet float:left;
		}
		else if(checkrowover(sxgds,r1,c1,r2,c2,comr2,comc2)==false&&comc2 !=c2){//// �жϱ��У����ϲ��������±�Ϊֹ���Ƿ��г���������
			sb.append("<!--�����һ��"+ r2+","+comc2+","+r1+","+(comc2+1)+"-->\n" );
			return ""+ r2+","+comc2+","+r1+","+(comc2+1)+",float:left;";//����need float:left;
		}
		else if(_checkrowover(sxgds,r1,c1,r2,c2,comr2,comc2)==false&&comc2 !=c2){//// ����:�жϱ��У����ϲ��������±�Ϊֹ���Ƿ��г���������
			sb.append("<!--���������һ��"+r2+","+(c2-1)+","+r1+","+c2+"-->\n" );//<!--���������һ��1,1,0,2-->
			return ""+ r2+","+(c2-1)+","+r1+","+c2+",float:left;";//����need float:left;
		}
		else if(_checkcolover(sxgds,r1,c1,r2,c2,comr2,comc2)==false&&comr2 !=r2){//// ����:�жϱ��У����ϲ��������ұ�Ϊֹ���Ƿ��г���������;��Ϊˮƽ��һ��
			sb.append("<!--����ˮƽ��һ��"+(r2-1)+","+c2+","+r2+","+c1+"-->\n" );
			return ""+ (r2-1)+","+c2+","+r2+","+c1+",float:none;";//����no need float:left;
		}
	
		//sb.append("����");
		return "";	
	}
	// �жϱ��У����ϲ��������ұ�Ϊֹ���Ƿ��г���������;��Ϊˮƽ��һ��
	// ����г��������ݣ�����true 
	function checkcolover(sxgds,r1,c1,r2,c2,comr2,comc2)
	{
		for (var r = r1;r<=comr2 ;r++){
			for (var c = c1;c<=c2; c++){
				if(!(r==r1 && c==c1)){
					//sb.append("cell"+r+","+c+"="+sxgds.GetCellHide(r,c));
					//if(sxgds.GetCellHide(r,c)!=false){//f_getsplit(0,1)(1,4) combine(0,1)1 "+sxgds.GetCellRowSpan(0,4)+"
						if((r+sxgds.GetCellRowSpan(r,c))>comr2){
							return true;
						}
					//}
				}
			}
		}
		return false;
	}
	
	// �жϱ��У����ϲ��������±�Ϊֹ���Ƿ��г���������
	// ����г��������ݣ�����true 
	function checkrowover(sxgds,r1,c1,r2,c2,comr2,comc2)
	{
		for (var r = r1;r<=r2;r++){
			for (var c = c1;c<=comc2; c++){
				if(!(r==r1 && c==c1)){
					//if(sxgds.GetCellHide(r,c)!=false){
						if(c+sxgds.GetCellColSpan(r,c)>comc2){
							return true;
						}
					//}
				}
			}
		}
		
		return false;
	}
	// ����: �жϱ��У����ϲ��������±�Ϊֹ���Ƿ��б��ϲ�������
	// ����г��������ݣ�����true 
	function _checkrowover(sxgds,r1,c1,r2,c2,comr2,comc2)
	{
		for (var r = r1;r<=r2;r++){
			for (var c = c1;c<c2; c++){
					//if(sxgds.GetCellHide(r,c)!=false){
						if(c+sxgds.GetCellColSpan(r,c)>=c2){
							return true;
						}
					//}
			}
		}
		
		return false;
	}
	// ����: ˮƽһ��
	// ����г��������ݣ�����true 
	function _checkcolover(sxgds,r1,c1,r2,c2,comr2,comc2)
	{
		for (var r = r1;r<r2;r++){
			for (var c = c1;c<=c2; c++){
					//if(sxgds.GetCellHide(r,c)!=false){
						if(r+sxgds.GetCellRowSpan(r,c)>=r2){
							return true;
						}
					//}
			}
		}
		
		return false;
	}
	
	//���ذٷֱȻ���px
	function NStr(num,sum,flg){
		if(flg=="0")return ""+(100*num/sum)+"%";
		else return ""+num+"px";
	}
	//����ĳ����Ԫ��������ַ�
	function GetLayoutItem(db,request,sb,str,r,c,dHeight)
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
		var overflow_x="";var overflow_y="";var fontcolor="";var fontsize="";
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
			else if(attrid=="cellspace")cellspace=ifnull(attrval,"0");		
			else if(attrid=="bkcolor")bkcolor=attrval;	
			else if(attrid=="value")val=attrval;
			
			else if(attrid=="fontcolor")fontcolor=attrval;
			else if(attrid=="fontsize")fontsize=attrval;
			
			else if(attrid=="overflow-x")overflow_x=attrval;	
			else if(attrid=="overflow-y")overflow_y=attrval;			
			
		}
		if(cellspace=="" ) cellspace="0";
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
				var imghtml = "<img src='"+src +"' style='border-color:#BBBBBB' border="+ifnull(border,"0")+" border="+ifnull(border,"0")+" "+ifnotnull(width,"width="+width)+" "+ifnotnull(height,"height="+height)+" >";
				if ( src =="" ) imghtml = "&nbsp;";
				var sStyle = "style=\"width:100%;height:100%;";
				if(background!="")
					sStyle += "background-image: url('"+background+"'); background-repeat: repeat-x;";
				sStyle += "\"";
				sb.append("<!-- "+cellspace+" -->" );
				sb.append("<div  "+sStyle +"  "+sURLHTML+"  bgcolor=\""+bkcolor+"\">"+imghtml+"</div>");
				//sb.append("<table  border=0 width=100% height=100% cellspacing=\""+cellspace+"\"  cellpadding=\"0\"  ><tr><td "+sStyle +" bgcolor=\""+bkcolor+"\" align="+ifnull(align,"left")+" valign="+ifnull(valign,"top")+sURLHTML+">"+imghtml+"</td></tr></table>" );
			}
			else if(ctrlid=="WP8ICON"){
				var imghtml = "<img src='"+src +"' border="+ifnull(border,"0")+" "+ifnotnull(width,"width="+width)+" "+ifnotnull(height,"height="+height)+" >";
				if ( src =="" ) imghtml = "&nbsp;";
				var sStyle = "style=\"";
				if(background!="")
					sStyle += "background-image: url('"+background+"'); background-repeat: repeat-x;";
				sStyle += "\"";
				sb.append("<table border=0 width=100% height=100% cellspacing=\""+cellspace+"\"  cellpadding=\"0\"  ><tr ><td "+sStyle+" bgcolor=\""+bkcolor+"\" align="+ifnull(align,"center")+" valign="+ifnull(valign,"middle")+sURLHTML+">"+imghtml+"<br><font size=\""+ifnull(fontsize,"2")+"\" color=\""+ifnull(fontcolor,"#FFFFFF")+"\" >"+val+"</font></td></tr></table>" );
	
			}
			else if(ctrlid=="ICONTEXT"){//ͼ�Ļ���
				var imghtml = "<img src='"+src +"' border="+ifnull(border,"0")+" "+ifnotnull(width,"width="+width)+" "+ifnotnull(height,"height="+height)+" >";
				if ( src =="" ) imghtml = "&nbsp;";
				var sStyle = "style=\"";
				
				if(background!="")
					sStyle += "background-image: url('"+background+"'); background-repeat: repeat-x;";
				sStyle += "\"";
				sb.append("<table border=0 width=100% height=100% cellspacing=\""+cellspace+"\"  cellpadding=\"0\"  ><tr ><td "+sStyle+" bgcolor=\""+bkcolor+"\" align="+ifnull(align,"center")+" valign="+ifnull(valign,"middle")+sURLHTML+">");
				sb.append("<div style=\"overflow:hidden; \"><div style=\"float:left;\" >"+imghtml+"<br></div><div style=\"height:0px;\"><font size=\""+ifnull(fontsize,"2")+"\" color=\""+ifnull(fontcolor,"#FFFFFF")+"\" >"+val+"</font></br><font  style=\" float:left\"  size=\""+ifnull(fontsize,"2")+"\" color=\""+ifnull(fontcolor,"#FFFFFF")+"\" >"+text+"</font></div></td></tr></table>" );
	
			}
	
			else if(ctrlid=="TEXT"){		
				//[%IMAGE deforg='XLSGRID' ctrltype='obj' ctrlid='IMAGE' id='IMAGE-1' src='xlsgrid/images/flash/icon/icon_171.png' value='ͼƬ'  width='' height='' border='0' background='' ]
				sb.append("<table border=0 width=100% height=100% cellspacing=\"0\"  cellpadding=\"0\"><tr><td align=left valign=right "+sURLHTML+"><font "+ifnotnull(fontsize,"size="+size)+" "+ifnotnull(color,"color="+fontcolor)+">"+text+"</font></td></tr></table>" );
			}
			else if(ctrlid=="HTML"){
				//[%IMAGE deforg='XLSGRID' ctrltype='obj' ctrlid='IMAGE' id='IMAGE-1' src='xlsgrid/images/flash/icon/icon_171.png' value='ͼƬ'  width='' height='' border='0' background='' ]
				if(html!="" ){
					var sStyle = "style=\"width:100%;height:100%;";
					if(background!="")
					sStyle += "background-image: url('"+background+"'); background-repeat: repeat-x;";
					sStyle += "\"";
					sb.append("<div "+sStyle +">"+db.getBlob2String("select bdata from formblob where guid='"+html+"'","bdata")+"</div>");
					//sb.append("<table border=0 width=100% height=100% cellspacing=\"0\"  cellpadding=\"0\"><tr><td "+sStyle+" align=left valign=right >"+db.getBlob2String("select bdata from formblob where guid='"+html+"' for update","bdata")+"</td></tr></table>" );
				}
			}else if(ctrlid=="ITEM"){//��Ʒչʾ
				var imghtml = "<img src='"+src +"' border="+ifnull(border,"0")+" "+ifnotnull(width,"width="+width)+" "+ifnotnull(height,"height="+height)+" >";
				if ( src =="" ) imghtml = "&nbsp;";
				var sStyle = "style=\"";
				if(background!="")
					sStyle += "background-image: url('"+background+"'); background-repeat: repeat-x;";
				sStyle += "\"";
				var divHeight="style=\"position:relative;display:block;";
				if(height!="")
					divHeight += "height:"+dHeight+"px;";
				divHeight +="\"";
	
				sb.append("<table border=0 width=100% height=100%  cellspacing=\""+cellspace+"\"  cellpadding=\"0\"  ><tr ><td "+sStyle+" bgcolor=\""+bkcolor+"\" align="+ifnull(align,"center")+" valign="+ifnull(valign,"middle")+sURLHTML+">");
				sb.append("<div "+divHeight +" >"+imghtml+"<div style=\"background:#000;position:absolute;bottom:0;left:0;color:#fff;-moz-opacity: 0.3; opacity: 0.3; filter: alpha(opacity=30);background: rgba(255, 255, 255, 0.3) !important; width:100%;\"><font size=\""+ifnull(fontsize,"2")+"\" color=\""+ifnull(fontcolor,"#FFFFFF")+"\"  style=\"position:relative; \">"+val+"</font></div></div></td></tr></table>" );
	
			}
	
			else {
				if(ctrltype=="pag"){
				var ds = db.QuerySQL("select * from LAYHDR where deforg='"+deforg+"' and id='"+ctrlid+"'" );
				//�б���ͼƬ
				if(ds.get(0,"BKIMGTYP")=="FULLSCREEN"&&ds.get(0,"BKIMG")!="" ){
					//����ȫ��������ı���ͼƬ
					var stylet = "style=\" background-image:url('"+ds.get(0,"BKIMG")+"');-moz-background-size: 100% 100%;-o-background-size: 100% 100%;-webkit-background-size: 100% 100%;background-size: 100% 100%;-moz-border-image: url(scale.jpg) 0;<!--[if lt IE 9]>background-image:none; filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+ds.get(0,"BKIMG")+"', sizingMethod='scale');<![endif]-->}\"";
					sb.append("<table border=0 width=100% height=100% cellspacing=\"0\"  cellpadding=\"0\"><tr><td align=left valign=top "+stylet+">");
				}else{
					//û�б���ͼ
					sb.append("<table border=0 width=100% height=100% cellspacing=\"0\"  cellpadding=\"0\"><tr><td align=left valign=top style=\"position:relative;\">");
				}

				
					//sb.append("<table border=0 width=100% height=100% cellspacing=\"0\"  cellpadding=\"0\"><tr><td align=left valign=top style=\"position:relative;\">");
					GetLayoutHTML(db,request,sb,deforg,ctrlid,0);
					//sb.append("</div>");
					sb.append("\n</td></tr></table>\n");
					
				}
				else {
					//sb.append("select * from layobj where deforg='"+deforg+"' and id='"+ctrlid+"'");
					var ds = db.QuerySQL("select * from layobj where deforg='"+deforg+"' and id='"+ctrlid+"'");
					if(ds.getRowCount()>0){
						
						if( ds.get(0,"PREHTML")!="")sb.append(db.getBlob2String("select bdata from formblob where guid='"+ds.get(0,"PREHTML")+"' for update","bdata") );
		
						//GUID "�ڲ�Ψһ���",ID "���",NAME "����",CLS "����",WNDMOD "���ڷ���Ѳ���",IFTITILE "�Ƿ���ʾ�����Ѳ���",TITLE "����",BKCOLOR "������ɫ",BKIMG "����ͼƬ",WNDOUT "��������",WNDIN "�����ڼ��",DSMOD "������Դ",SORTBY "����",WHEREBY "����",SQLTXT "SQL���",OSSYT "OSϵͳ",OSMWID "OS�м��",OSFUNC "OS����",OSPARAM "OS�����Ĳ���",SYTID "�������ϵͳ���",SHOMOD "��ʾ���",CRTDAT "��������",LAYCOL "������",LAYROW "������",IFPAGE "�Ƿ��ҳ",PAGEROW "ÿҳ�м�¼��",IFSCROLLBAR "�Ƿ���ʾ������",LOGOIMG "Ԥ��ͼƬ��·��",OBJBKCOLOR "�����ؼ��ı�����ɫ",OBJBKIMG "�����ؼ��ı���ͼƬ",NOTE "��ע",LOGOIMGW "Ԥ��ͼƬ�Ŀ��",LOGOIMGH "Ԥ��ͼƬ�ĸ߶�",DEFORG "Ĭ����֯��",TITLEICON "����ͼ��",TITLEHTML "�������ֱ����һ��HTML",TITLEFONTSIZE "���������С",WNDBORDER "���ڱ߿���ɫ",LISTIN "���֮��ļ��",TITLEFKCOLOR "����������ɫ",TITLBFKCOLOR "���ⱳ����ɫ",ONHTMLGUID "Ƕ��ǰ��HTML",POSTHTMLGUID "Ƕ�����HTML",BKBORDOR "�߿���ɫ"
						//sb.append("<table id=\"TABLE_CELL"+r+"_"+c+"\" border=\"0\" width=\"100%\" height=\"100%\"  ><tr><td align=\"left\" valign=\"top\" style=\"");
						
						sb.append("<div id=\"TABLE_CELL"+r+"_"+c+"\" align=\"left\" valign=\"top\"  cellspacing=\""+ifnull(ds.get(0,"WNDOUT"),"0")+"\" cellpadding=\"0\"  style=\"width:100%;height:100%;");
	
						var styleHTML="";
						
						sb.append("margin:"+ifnull(ds.get(0,"WNDOUT"),"0")+"px;");
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

						var overf="";
						var overf2="";
						if(overflow_x=="1"){ overf="<div style='width:"+ifnull(width,"500")+"px;height:"+ifnull(height,"300")+"px; overflow-x:auto;'>"; overf2="</div>";}
						if(overflow_y=="1"){ overf="<div style='width:"+ifnull(width,"500")+"px;height:"+ifnull(height,"300")+"px;overflow-y:auto;'>"; overf2="</div>";}
						if(overflow_y=="1"&&overflow_x=="1"){ overf="<div style='width:"+ifnull(width,"500")+"px;height:"+ifnull(height,"300")+"px;overflow:auto;'>"; overf2="</div>";}
						sb.append("<tr><td align=\"left\" valign=\"top\" "+ifnotnull(ds.get(0,"OBJBKCOLOR"),"bgcolor=\""+ds.get(0,"OBJBKCOLOR")+"\"")+">
									<table id=\"TABLE_CELL_"+r+"_"+c+"_MAIN\" border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\""+ifnull(ds.get(0,"WNDIN"),"0")+"\" cellpadding=\"0\" >
										<tr><td align=left valign=top>"+overf+
										GetBody(db,request,deforg,ds.get(0,"WNDMOD"),ds.get(0,"DSMOD"),ds.get(0,"WHEREBY"),ds.get(0,"SORTBY"),ds.get(0,"SQLTXT"),ds.get(0,"LAYCOL"),ds.get(0,"LAYROW"),ds.get(0,"PAGEROW"),ds.get(0,"OSMWID"),ds.get(0,"OSFUNC"),ds.get(0,"OSPARAM"),ds.get(0,"IFRAMEURL"),ds.get(0,"IFSCROLLBAR"),ds.get(0,"HTMLGUID"),ds.get(0,"MOREURL"),ds.get(0,"OPENLAYID") )
										+overf2+"</td></tr>
									</table>
								</td></tr>
							</table>
						</div> ");
							
					
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
	//	if(WNDMOD=="TITLELIST"){
			var ds = db.QuerySQL("select GUID,OSSYT,OSMWID,OSFUNC from LHTML where id='"+WNDMOD+"'");
			if(ds.getRowCount()>0){
				var OSSYT = ds.getStringAt(0,"OSSYT");
				var OSMWID = ds.getStringAt(0,"OSMWID");
				var OSFUNC = ds.getStringAt(0,"OSFUNC");
				var GUID = ds.getStringAt(0,"GUID");
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
					
					var dsdtl = db.QuerySQL("select ID from LHTMLDTL where FORMGUID='"+GUID+"'");
					
					for(var i = 0;i<dsdtl.getColumnCount();i++){
						eas.DefineScopeVar(dsdtl.getStringAt(i,"ID"),request.getParameter(dsdtl.getStringAt(i,"ID")));
					} 
					var ret =  eas.CallClassFunc(""+OSSYT +"_"+OSMWID+"",""+OSFUNC+"",null).castToString();
					return ret; 
				}catch(e){
					throw new Exception(""+OSSYT +"_"+OSMWID+OSFUNC+""+e.toString());
				}
			}else{
				return "";
			}
	//	}
		
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
	//�õ���Ԫ��ĸ߶ȣ������ǵ��ϲ����أ�
	function getcellcolw(sxgds,sColW,row,col,CELLPADDING )
	{
		if(sxgds.GetCellHide(row,col)==true)return 0;
		
		var colw = 1*getcolw(sxgds,sColW,col);
		//�õ����ϲ���Ԫ��Ŀ��
		var rowspan = sxgds.GetCellColSpan(row,col);
		var colspan = sxgds.GetCellRowSpan(row,col);
		for ( var j=0;j<rowspan;j++ ) {
			colw +=1*getcolw(sxgds,sColW,col+j+1)+1*CELLPADDING ;
		}
		return colw;
	}
	
	function getcellrowh(sxgds,sRowH,row,col,CELLPADDING )
	{
		if(sxgds.GetCellHide(row,col)==true)return 0;
		var rowh = 1*getrowh(sxgds,sRowH,row);
		//�õ����ϲ���Ԫ���gao��
		var rowspan = sxgds.GetCellColSpan(row,col);
		var colspan = sxgds.GetCellRowSpan(row,col);
		for ( var j=0;j<colspan;j++ ) {
			rowh +=1*getrowh(sxgds,sRowH,row+j+1)+1*CELLPADDING ;
		}
		return rowh;
	}
	
	// ֻȡԭʼ��С
	function getcolw(sxgds,sColW,c)
	{
		if(c>=sxgds.cols)return 0;
		var colw = sxgds.aColwidth[c];
		if(c<sColW.length() && sColW[c]!=""  && sColW[c].substring(sColW[c].length()-1) !="%" )
			colw = sColW[c];
		return colw;
	}
	function getrowh(sxgds,sRowH,r)
	{
		if(r>=sxgds.rows)return 0;
		var rowh = sxgds.aRowheight[r];
		if(r<sRowH.length() && sRowH[r]!="" && sRowH[r].substring(sRowH[r].length()-1) !="%")
			rowh = sRowH[r];//ȡ�Զ����п�
		return rowh;
	}

}