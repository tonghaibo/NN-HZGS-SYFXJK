function x_L1(){	var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
	var baskpack = new JavaPackage ( "com.xlsgrid.net" );
	var webpack = new JavaPackage ( "com.xlsgrid.net.web");
	
	var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb");
	var layoutpack = new JavaPackage ( "com.xlsgrid.net.layout");
	var grdpack = new JavaPackage ( "com.xlsgrid.net.grd");
	
	var langpack = new JavaPackage ( "java.lang");
	//作为.sp服务时的入口
	//预定义变量：request,response
	function Response()
	{
		
		var db = null;
		var msg= "";
		var layoutid = pubpack.EAFunc.NVL( request.getParameter("id"),"") ;
		var objid= pubpack.EAFunc.NVL( request.getParameter("objid"),"") ;
		var skin= pubpack.EAFunc.NVL( request.getParameter("skin"),"") ;
		var hashead = pubpack.EAFunc.NVL( request.getParameter("hashead"),"y") ;
	
	
		var deforg =  pubpack.EAFunc.NVL( request.getParameter("thisorgid"),webpack.EAWebDeforg.GetDeforg(request)) ;
		var browsetype = pubpack.EAFunc.getBroswerType( request );
		response.setContentType("text/html;charset=UTF-8");//response.setContentType("text/html; charset=GBK");
		var sb=new langpack.StringBuffer();
		
	
		try {
			if(skin!="")request.getSession().setAttribute("USERSKIN",skin);//修改皮肤可以通过 L.sp?id=index&skin=blue  
			db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			
			if(objid!="") {//这是一个组件的测试页面
				if(hashead=="y"){
					gethtmlhead(db,ds,sb);
					sb.append( "<body  topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0>");
				}
				GetLayoutItem(db,request,sb,"[%IMAGE deforg='"+deforg+"' ctrltype='obj' ctrlid='"+objid+"' ]",0,0,0,"");
				if(hashead=="y"){
					sb.append("</body></html>");
				}
			}
			else {
				
				// 布局的html
				if(hashead=="y"){
					GetLayoutHTML(db,request,sb,deforg,layoutid,1,"");
				}else {
					GetLayoutHTML(db,request,sb,deforg,layoutid,0,"");
				}
				
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
	//得到某个布局的html
	//ifneedhead=0 只显示html内容(<body>里面)不显示html前缀
	function GetLayoutHTML(db,request,sb,deforg,layoutid,ifneedhead,menuid)
	{
				
				var ds = db.QuerySQL("select * from LAYHDR where deforg='"+deforg+"' and id='"+layoutid+"'" );
				var colwidths = ds.get(0,"COLWIDTHS" );
				var rowheights = ds.get(0,"ROWHEIGHTS" );
				var sColW = colwidths.split(",");
				var sRowH = rowheights .split(",");
				var onlayoutid = ds.get(0,"ONLAYOUTID" );
				var postlayoutid = ds.get(0,"POSTLAYOUTID" );
				var menulog = ds.get(0,"MENULOG");
				var enmenulog = ds.get(0,"ENMENULOG");
				if(ds.getRowCount()==0 ) return "十分抱歉，你要找的页面不存在（"+deforg+"-"+layoutid+")";
				
				var CELLPADDING = 1*ifnull(ds.get(0,"CELLPADDING"),"0");	//单元格之间的间隙	
				var CELLSPACE = 1*ifnull(ds.get(0,"CELLSPACE"),"0");	//外延边距	
				var layflg = ifnull(ds.get(0,"LAYFLG"),"DIV");		//布局风格
				var fixflg = ifnull(ds.get(0,"FIXFLG"),"FIXWH");	//铺满模式
	
				var min_width= ifnull(ds.get(0,"min_width"),"0");  //最小宽度
				var padding_trbl = ifnull(ds.get(0,"margin_top"),"0%") +" "+ ifnull(ds.get(0,"margin_right"),"0%") +" "+ifnull(ds.get(0,"margin_bottom"),"0%")+" "+ifnull(ds.get(0,"margin_left"),"0%");//内边距
				
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
					if(ds.get(0,"RELOADTIME")!="")sb.append( "try{setInterval('location.reload()',"+ds.get(0,"RELOADTIME")+"*1000);}catch(e){window.status='定时任务定义错误';}");
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
//背景图片不兼容火狐等浏览器			//TD可拉伸背景填充，TD必须设置为 position:relative;img图片设置width:100%;height:100%;position:absolute;top:0;left:0;z-index:-1;
//已经被替代无需使用				sb.append("<img src='"+ds.get(0,"BKIMG")+"' style=\"width:100%;height:100%;position:absolute;top:0;left:0;z-index:-1;\"/> ");
//					}
					
				}
				
				if(onlayoutid!="") GetLayoutHTML(db,request,sb,deforg,onlayoutid,0,menulog);
				//判断是否需要背景和前景
				if(!(ds.get(0,"FKALIGN")=="" &&ds.get(0,"FKVALIGN")=="" &&ds.get(0,"FKWIDTH")=="" && ds.get(0,"FKHEIGHT")=="" && ds.get(0,"FKGRID")=="" && ds.get(0,"FKCOLOR")=="" && ds.get(0,"FKIMG")=="" )){
					sb.append("<div id=\"TABLE_BK\"  style=\"background-color:"+ds.get(0,"BKCOLOR")+"\">" );
	
					sb.append("<div id=\"TABLE_"+layoutid+"_FK\" style=\""+ifnotnull(ds.get(0,"FKGRID"),"border:"+ds.get(0,"FKGRID")+";")+" "+ifnotnull(ds.get(0,"FKCOLOR"),"background-color:  "+ds.get(0,"FKCOLOR")+";")+" " + ifnotnull(ds.get(0,"FKIMG")," background-image: url('"+ds.get(0,"FKIMG")+"')")+"");
					sb.append(ifnotnull(ds.get(0,"FKWIDTH")," width:"+ds.get(0,"FKWIDTH"))+" ; "+ifnotnull(ds.get(0,"FKHEIGHT")," height:"+ds.get(0,"FKHEIGHT"))+" padding:"+padding_trbl+";\">");
	
					//sb.append("<table id=\"TABLE_BK\" border=0 cellspacing=0 cellpadding=0 width=100% height=100%><tr><td align=\""+ifnull(ds.get(0,"FKALIGN"),"CENTER")+"\" valign=\""+ifnull(ds.get(0,"FKVALIGN"),"MIDDLE")+"\">\n");
					//sb.append("<table id=\"TABLE_"+layoutid+"_FK\" border=0 cellspacing=0 cellpadding=0 "+ifnotnull(ds.get(0,"FKWIDTH")," width="+ds.get(0,"FKWIDTH"))+" "+ifnotnull(ds.get(0,"FKHEIGHT")," height="+ds.get(0,"FKHEIGHT"))+"\"><tr><td align=\"LEFT\" align=\"TOP\" style=\""+ifnotnull(ds.get(0,"FKGRID"),"border: 1px solid "+ds.get(0,"FKGRID")+";")+" "+ifnotnull(ds.get(0,"FKCOLOR"),"background-color:  "+ds.get(0,"FKCOLOR")+";")+" " + ifnotnull(ds.get(0,"FKIMG")," background-image: url('"+ds.get(0,"FKIMG")+"')")+"\">\n");
				}
				
				// 水平
				var wflg = "1";//水平铺满 百分比还是pt =0 % else pt
				var aflg = "1";//垂直铺满 百分比还是pt =0 % else pt
				if(fixflg=="FIXW")wflg="0";
				if(fixflg=="FIXH")aflg="0";
				if(fixflg=="FIXWH"){ wflg="0";aflg="0"; }
				
				var dflg = layflg;//DIV DIVFLW TABLE
				sb.append("<!-- debug info:layoutid="+layoutid+" fixflg="+fixflg+",layflg="+layflg+",wflg="+wflg+",aflg ="+aflg +",dflg="+dflg+" -->\n");
				// 从sxg取出各个单元格数据
				if(dflg =="TABLE"){
					sb.append( "\n<table id=\"PAGE_MAIN_"+layoutid+"\" border=\"0\" width=\"100%\"  height=100% id=\"TABLE_MAIN\" cellspacing=\"0\" cellpadding=\"0\" >\n");
				}
				else {
					//设置最小宽度
					var stylet="style=\"position:relative ;width:100%;margin:"+CELLSPACE+"px;height:100%;min-width:"+min_width+"px;_width:expression((document.documentElement.clientWidth||document.body.clientWidth)<"+min_width+"?"+min_width+":auto);\"";									 
					sb.append( "\n<div id=\"PAGE_MAIN_"+layoutid+"\" "+stylet +">");
					

				}
				
				var rows= sxgds.rows;
				var cols = sxgds.cols;
				var sSumHeight="";//sSumHeight=" height=\""+pageheightfix+"%\" ";
				
				if(dflg=="DIV") {//  DIV布局-铺满-用于网站
					
					f_getdivtree(db,request,sb,sxgds,dflg,aflg,wflg,sColW,sRowH,CELLPADDING ,0,0,rows-1,cols-1,0,layoutid,menuid);	//递归，获取树形的DIV结构
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
		
							var rowspan =sxgds.GetCellRowSpan(r,c)+1;  // 合并的个数
							var colspan=sxgds.GetCellColSpan(r,c)+1;
							//判断是否hide,或临时变量=1，说明在解析过程已经被合并
							if(sxgds.GetCellHide(r,c)==false){
								var nCombinerow=0;
								var nEndRow=r;
								var top = 0;
								var left =0;
								for ( var rr=0;rr<r;rr++) top+=CELLPADDING +getrowh(sxgds,sRowH,r);
								for ( var cc=0;cc<c;cc++) left+=CELLPADDING +getcolw(sxgds,sColW,c);
								//float:left;
								//设置单元格对象属性
								
								var  str = sxgds.GetCellText(r,c);
//								if ( str == "" ) {sb.append("&nbsp;");return ;}
								if(str.length()>=8)
									str = str.substring(8);//[%IMAGE 
								var idx = -1;
								var oldidx= 0;
								var layobjds = null;
								var deforg = "";
								var ctrlid = "";var ctrltype ="";
								var src = "";	var width = ""; var height = ""; var border = ""; var background="";var text = "";var color="";var html = "";var size="";var align="" ; var valign=""; var url=""; var target=""; var cellspace = "";var bkcolor="";var val=""; 
								var overflow_x="";var overflow_y="";var fontcolor="";var fontsize="";var margin_t="";var margin_r="";var margin_l="";var margin_b="";
								if(str!=""){
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
										else if(attrid=="width")width =ifnull(attrval,"0");
										else if(attrid=="height")height=ifnull(attrval,"0");
										else if(attrid=="border")border =ifnull(attrval,"0");
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
										else if(attrid=="margin_t")margin_t=attrval;//外边距上
										else if(attrid=="margin_r")margin_r=attrval;//右
										else if(attrid=="margin_b")margin_b=attrval;//下
										else if(attrid=="margin_l")margin_l=attrval;//左
										else if(attrid=="fontcolor")fontcolor=attrval;
										else if(attrid=="fontsize")fontsize=attrval;
										
										else if(attrid=="overflow-x")overflow_x=attrval;	
										else if(attrid=="overflow-y")overflow_y=attrval;			
										
									}
								}
								var sStyle = "";
								if(background!="")
									sStyle += "background-image: url('"+background+"');";
								if(margin_t!="")
									sStyle += "padding-top:"+margin_t+";";//外边距
								if(margin_r!="")
									sStyle += "padding-right:"+margin_r+";";//外边距
								if(margin_b!="")
									sStyle += "padding-bottom:"+margin_b+";";//外边距
								if(margin_l!="")
									sStyle += "padding-left:"+margin_l+";"; //外边距
								if(cellspace!="")
									sStyle += "margin:"+cellspace+";"; //内边距
								if(border!="")
									sStyle += "border:"+border+";"; //边框
								if(bkcolor!="")
									sStyle += "background-color:"+bkcolor+";"; //背景颜色
									
								if(overflow_x!="")
									sStyle += "overflow_x:"+overflow_x+";"; //div溢出
								if(overflow_y!="")
									sStyle += "overflow_y:"+overflow_x+";"; 
															
								var sURLHTML= "";
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
								sb.append( "<!-- 单元格 "+dflg+"-->\n");
								if(dflg =="TABLE"){
									
									sb.append("<td "+sURLHTML+" width=\""+width+"\" height="+height+" align=\""+align+"\" valign=\""+valign+"\" style=\""+sStyle+"\"");
									if( rowspan>1)sb.append(" rowspan="+rowspan);
									if( colspan>1)sb.append(" colspan="+colspan);
									sb.append(">");
								}
								else {//position: absolute; top: "+NStr(top,sumheight ,aflg)+"; left: "+NStr(left,sumwidth,wflg)+";
									sb.append("\r\n<div id=\"DIV_"+r+"_"+c+"\" style=\"float:left;width:"+NStr(colw,sumwidth,wflg)+";height:"+NStr(rowh,sumheight ,aflg)+";margin:"+CELLPADDING +"px;\"   ");//padding:10px;  //width=\""+colw+"\" height="+rowh+" align=\"left\" valign=\"top\"						//if( rowspan>1)sb.append(" rowspan="+rowspan);
									sb.append(">");
								}
								str = sxgds.GetCellText(r,c);
								sb.append("\n<!-- layout item "+ r+"_"+c+"-->\n");
								
		
								
		              					GetLayoutItem(db,request,sb,str,r,c,rowh,menuid);
			              				
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
				if(postlayoutid !="") GetLayoutHTML(db,request,sb,deforg,postlayoutid ,0,menulog);
				if(ifneedhead!=0)sb.append("</body></html>");
	
	}
	// html head style public 
	function gethtmlhead(db,ds,sb)
	{
		
		var compmode=ds.get(0,"COMPMODE");
		if(compmode==1)
			sb.append("<html  xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>"+ds.get(0,"TITLE")+"</title><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/><script language=\"javascript\" src=\"xlsgrid/js/wnd.js\"></script><script language=\"javascript\" src=\"xlsgrid/images/flash/js/jquery-1.7.2.min.js\"></script>");//<LINK rel=stylesheet type=text/css HREF=\"xlsgrid/css/layout.css\">
		else
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
		sb.append("TD {FONT-SIZE: 10.5pt;FONT-FAMILY: 微软雅黑;}\n");//background-size:100% 100%;
		
		sb.append("BODY {FONT-SIZE: 10.5pt;FONT-FAMILY: 微软雅黑;height:100%; text-align:center;");
		if(ds.get(0,"FKVALIGN")=="MIDDLE"){// 如果需要居中对齐，html和body的100高度都是不可缺的
			sb.append("height:100%;}\n");//
			sb.append("HTML {height:100%;}\n");
		}
		else sb.append("}\n");
		sb.append("</style>\n");
		sb.append("</head>");
		if(ds.get(0,"JSGUID")!="")
			sb.append( "<script src='EAFormBlob.sp?guid="+ds.get(0,"JSGUID")+"'></script>");
	
	}
	
	//递归，获取树形的DIV结构
	function f_getdivtree(db,request,sb,sxgds,dflg,aflg,wflg,sColW,sRowH,CELLPADDING,r1,c1,r2,c2,loopnum,layoutid,menuid)
	{
		
		if(loopnum>50) return ;
		if(r1==sxgds.rows||c1==sxgds.cols||r2==sxgds.rows||c2==sxgds.cols)return;
	
	
		loopnum=loopnum+1;
		//sb.append( "f_fgetdivtree"+ "("+r1+","+c1+")("+r2+","+c2+") <BR>");
		//1.得到（r1,c1）可能的切割线
		var ret = f_getsplit(sb,sxgds,r1,c1,r2,c2);
		//sb.append( "return "+ret+"<BR>" );
		var ss = ret.split(",");
		if(ret !=""&&ss.length()>=5){// 可以分割
			//sb.append( "<!-- 分割"+ret+" -->\n");
			var colw= 0;
			var rowh= 0;
			for(var c=c1;c<=1*ss[1];c++)
				colw+=getcolw(sxgds,sColW,c);
			for(var r=r1;r<=1*ss[0];r++)
				rowh+=getrowh(sxgds,sRowH,r);
			//sumwidth sumheight 要按本区域（而不是整个表格）来计算
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
			f_getdivtree(db,request,sb,sxgds,dflg,aflg,wflg,sColW,sRowH,CELLPADDING,r1,c1,1*ss[0],1*ss[1],loopnum,layoutid,menuid);
			sb.append( "</div>\n" );
			
			colw= 0;
			rowh= 0;
			for(var c=1*ss[3];c<=c2;c++)
				colw+=getcolw(sxgds,sColW,c);
			for(var r=1*ss[2];r<=r2;r++)
				rowh+=getrowh(sxgds,sRowH,r);
			sb.append("<!-- colw="+colw+",sumwidth="+sumwidth+" -->" );
			//设置外边距

			sb.append( "<div  id=\""+layoutid+"_"+ss[2]+"_"+ss[3]+"_"+r2+"_"+c2+"\" style=\"margin:0px;padding:0px;"+ss[4]+"width:"+NStr(colw,sumwidth,wflg)+";height:"+NStr(rowh,sumheight ,aflg)+";\">\n" );
			f_getdivtree(db,request,sb,sxgds,dflg,aflg,wflg,sColW,sRowH,CELLPADDING,1*ss[2],1*ss[3],r2,c2,loopnum,layoutid,menuid);
			sb.append( "</div>\n" );
		}
		else {//
			//var colw = getcellcolw(sxgds,sColW,r1,c1,0 ); 
			//var rowh = getcellrowh(sxgds,sRowH,r1,c1,0);
			//var top = 0;	var left =0;
			//for ( var rr=0;rr<r1;rr++) top+=getrowh(sxgds,sRowH,r1);
			//for ( var cc=0;cc<c1;cc++) left+=getcolw(sxgds,sColW,c1);
			// 本节点的内容
			//sb.append( "=============================内容"+r1+","+c1+"<BR>" );
			//sb.append("\r\n<div id=\"CELL_"+r1+"_"+c1+"\" style=\"float:left;width:"+NStr(colw,sumwidth,wflg)+";height:"+NStr(rowh,sumheight ,aflg)+";margin:"+CELLPADDING+"px;padding:0px;\" >");//padding:10px; //position: absolute; top: "+NStr(top,sumheight ,wflg)+"; left: "+NStr(left,sumwidth,wflg)+";
			sb.append("\n<!-- layout item "+ r1+"_"+c1+"-->\n");
			var  str = sxgds.GetCellText(r1,c1);
			GetLayoutItem(db,request,sb,str,r1,c1,0,menuid);
			sb.append("\n<!-- end layout item "+ r1+"_"+c1+"-->\n");
			//sb.append( "</div>\n" );
		
		}
		
	
		//else sb.append( "布局过于复杂，无法解释" );
	}
	
	//得到（r1,c1,r2,c2）可能的切割线
	//返回“”，表示不能再分割了
	function f_getsplit(sb,sxgds,r1,c1,r2,c2)
	{
		var colspan =sxgds.GetCellColSpan(r1,c1);  // 合并的个数
		var rowspan=sxgds.GetCellRowSpan(r1,c1);
	
		var comr2 = r1+rowspan;
		var comc2 = c1+colspan;
		//sb.append( "f_getsplit("+r1+","+c1+")("+r2+","+c2+") combine("+comr2+","+comc2 +")<BR>" );
		
		if(checkcolover(sxgds,r1,c1,r2,c2,comr2,comc2)==false&&comr2 !=r2){	//// 判断本行（含合并）到最右边为止，是否有超出的内容;作为水平割一刀
			sb.append("<!--水平割一刀"+ comr2+","+c2+","+(comr2+1)+","+c1+"-->\n" );
			return ""+ comr2+","+c2+","+(comr2+1)+","+c1+",float:none;";//水平 not neet float:left;
		}
		else if(checkrowover(sxgds,r1,c1,r2,c2,comr2,comc2)==false&&comc2 !=c2){//// 判断本列（含合并）到最下边为止，是否有超出的内容
			sb.append("<!--竖向割一刀"+ r2+","+comc2+","+r1+","+(comc2+1)+"-->\n" );
			return ""+ r2+","+comc2+","+r1+","+(comc2+1)+",float:left;";//竖向need float:left;
		}
		else if(_checkrowover(sxgds,r1,c1,r2,c2,comr2,comc2)==false&&comc2 !=c2){//// 逆向:判断本列（含合并）到最下边为止，是否有超出的内容
			sb.append("<!--逆向竖向割一刀"+r2+","+(c2-1)+","+r1+","+c2+"-->\n" );//<!--逆向竖向割一刀1,1,0,2-->
			return ""+ r2+","+(c2-1)+","+r1+","+c2+",float:left;";//竖向need float:left;
		}
		else if(_checkcolover(sxgds,r1,c1,r2,c2,comr2,comc2)==false&&comr2 !=r2){//// 逆向:判断本行（含合并）到最右边为止，是否有超出的内容;作为水平割一刀
			sb.append("<!--逆向水平割一刀"+(r2-1)+","+c2+","+r2+","+c1+"-->\n" );
			return ""+ (r2-1)+","+c2+","+r2+","+c1+",float:none;";//竖向no need float:left;
		}
	
		//sb.append("不割");
		return "";	
	}
	// 判断本行（含合并）到最右边为止，是否有超出的内容;作为水平割一刀
	// 如果有超出的内容，返回true 
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
	
	// 判断本列（含合并）到最下边为止，是否有超出的内容
	// 如果有超出的内容，返回true 
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
	// 逆向: 判断本列（含合并）到最下边为止，是否有被合并的内容
	// 如果有超出的内容，返回true 
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
	// 逆向: 水平一刀
	// 如果有超出的内容，返回true 
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
	
	//返回百分比还是px
	function NStr(num,sum,flg){
		if(flg=="0")return ""+(100*num/sum)+"%";
		else return ""+num+"px";
	}
	//处理某个单元格里面的字符
	function GetLayoutItem(db,request,sb,str,r,c,dHeight,menuid)
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
		var overflow_x="";var overflow_y="";var fontcolor="";var fontsize="";var margin_t="";var margin_r="";var margin_l="";var margin_b="";
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
			else if(attrid=="margin_t")margin_t=attrval;//外边距上
			else if(attrid=="margin_r")margin_r=attrval;//右
			else if(attrid=="margin_b")margin_b=attrval;//下
			else if(attrid=="margin_l")margin_l=attrval;//左
			else if(attrid=="fontcolor")fontcolor=attrval;
			else if(attrid=="fontsize")fontsize=attrval;
			
			else if(attrid=="overflow-x")overflow_x=attrval;	
			else if(attrid=="overflow-y")overflow_y=attrval;			
			
		}
		
		var marginpx = ifnull(margin_t,"0")+"px "+ifnull(margin_r,"0")+"px "+ifnull(margin_b,"0")+"px "+ifnull(margin_l,"0")+"px ";//外边距
	
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
				//[%IMAGE deforg='XLSGRID' ctrltype='obj' ctrlid='IMAGE' id='IMAGE-1' src='xlsgrid/images/flash/icon/icon_171.png' value='图片'  width='' height='' border='0' background='' ]
				if(src!=""){
					var imghtml = "<img src='"+src+"'>";
					sb.append(imghtml);
				}
				//sb.append("<table  border=0 width=100% height=100% cellspacing=\""+cellspace+"\"  cellpadding=\"0\"  ><tr><td>"+imghtml+"</td></tr></table>" );
			}
			else if(ctrlid=="WP8ICON"){
				var imghtml = "<img src='"+src +"'>";
				if ( src =="" ) imghtml = "&nbsp;";
				sb.append("<table border=0 width=100% height=100% cellspacing=\""+cellspace+"\"  cellpadding=\"0\"  ><tr ><td>"+imghtml+"<br><font>"+val+"</font></td></tr></table>" );
	
			}
			else if(ctrlid=="ICONTEXT"){//图文混排
				var imghtml = "<img src='"+src +"' border="+ifnull(border,"0")+" "+ifnotnull(width,"width="+width)+" "+ifnotnull(height,"height="+height)+" >";
				if ( src =="" ) imghtml = "&nbsp;";

				sb.append("<table><tr ><td>");
				sb.append("<div style=\"overflow:hidden; \"><div style=\"float:left;\" >"+imghtml+"<br></div><div style=\"float:left;width:48%;margin-top:15px;\"><font style=\"border-bottom:1px dashed #666666;\">"+val+"</font></br><font>"+text+"</font></div></td></tr></table>" );
	
			}
	
			else if(ctrlid=="TEXT"){		
				//[%IMAGE deforg='XLSGRID' ctrltype='obj' ctrlid='IMAGE' id='IMAGE-1' src='xlsgrid/images/flash/icon/icon_171.png' value='图片'  width='' height='' border='0' background='' ]
				sb.append("<table><tr><td><font>"+text+"</font></td></tr></table>" );
			}
			else if(ctrlid=="HTML"){
				//[%IMAGE deforg='XLSGRID' ctrltype='obj' ctrlid='IMAGE' id='IMAGE-1' src='xlsgrid/images/flash/icon/icon_171.png' value='图片'  width='' height='' border='0' background='' ]
				if(html!="" ){
					sb.append(db.getBlob2String("select bdata from formblob where guid='"+html+"'","bdata"));
					//sb.append("<table border=0 width=100% height=100% cellspacing=\"0\"  cellpadding=\"0\"><tr><td align=left valign=right >"+db.getBlob2String("select bdata from formblob where guid='"+html+"' for update","bdata")+"</td></tr></table>" );
				}
			}else if(ctrlid=="ITEM"){//商品展示
				var imghtml = "<img src='"+src +"'>";
				if ( src =="" ) imghtml = "&nbsp;";

				var divHeight="style=\"position:relative;display:block;";
				divHeight +="\"";
	
				sb.append("<table><tr ><td>");
				sb.append("<div "+divHeight +" >"+imghtml+"<div style=\"background:#000;position:absolute;bottom:0;left:0;color:#fff;-moz-opacity: 0.3; opacity: 0.3; filter: alpha(opacity=30);background: rgba(255, 255, 255, 0.3) !important; width:100%;\"><font style=\"position:relative; \">"+val+"</font></div></div></td></tr></table>" );
	
			}
	
			else {
				if(ctrltype=="pag"){
					GetLayoutHTML(db,request,sb,deforg,ctrlid,0,menuid);
				}
				else {
					//sb.append("select * from layobj where deforg='"+deforg+"' and id='"+ctrlid+"'");
					var ds = db.QuerySQL("select * from layobj where deforg='"+deforg+"' and id='"+ctrlid+"'");
					if(ds.getRowCount()>0){
						sb.append(GetBody(db,request,deforg,ds.get(0,"WNDMOD"),ds.get(0,"DSMOD"),ds.get(0,"WHEREBY"),ds.get(0,"SORTBY"),ds.get(0,"SQLTXT"),ds.get(0,"LAYCOL"),ds.get(0,"LAYROW"),ds.get(0,"PAGEROW"),ds.get(0,"OSMWID"),ds.get(0,"OSFUNC"),ds.get(0,"OSPARAM"),ds.get(0,"IFRAMEURL"),ds.get(0,"IFSCROLLBAR"),ds.get(0,"HTMLGUID"),ds.get(0,"MOREURL"),ds.get(0,"OPENLAYID"),ds.get(0,"ID"),menuid ));
					}
					else {
						sb.append("data not found: deforg='"+deforg+"' and id='"+ctrlid+"'");
					}
				}
			}
			
		
		}
		
	}
	//WNDMOD 窗口风格, DSMOD 数据来源 ,WHEREBY 条件, SORTBY 排序,SQLTXT  SQL语句, LAYCOL 分列数 ,LAYROW 分行数,PAGEROW 每页行记录数, OSMWID OS中间件, OSFUNC OS函数,OSPARAM OS函数的参数,IFRAMEURL IFRAME的URL,IFSCROLLBAR 是否显示滚动条,HTMLGUID HTML
	// ,MOREURL  更多按钮,OPENLAYID  点击列表打开的布局：
	function GetBody(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,PAGEROW ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID,CTRLID,menuid)
	{
		//在服务端OS中引用其他中间件的服务端脚本
		//说明：x_SQLINPUT是指x系统SQLINPUT中间件
	//	if(WNDMOD=="TITLELIST"){
			var ds = db.QuerySQL("select GUID,OSSYT,OSMWID,OSFUNC from LHTML where id='"+WNDMOD+"'");
			if(ds.getRowCount()>0){
				var OSSYT = ds.getStringAt(0,"OSSYT");
				var OSMWID = ds.getStringAt(0,"OSMWID");
				var OSFUNC = ds.getStringAt(0,"OSFUNC");
				var GUID = ds.getStringAt(0,"GUID");
				var eas = new pub.EAScript(null);                		 
				//参数找到后，就执行方法，上面所指的funname其实是文件名字，MyFun是文件的根节点，funName是方法名字
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
					eas.DefineScopeVar("MENUID", menuid);
					var dsdtl = db.QuerySQL("select ID from LHTMLDTL where FORMGUID='"+GUID+"'");
					for(var i = 0;i<dsdtl.getRowCount();i++){
						var lhtid=dsdtl.getStringAt(i,"ID");
						var layvalue="";
						try{ layvalue=db.GetSQL("select b.val from LAYOBJ a,LAYOBJDTL b where a.guid=b.formguid and a.id='"+CTRLID+"' and b.id='"+lhtid+"'");}catch(e){}
						eas.DefineScopeVar(lhtid,layvalue);
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
	
	// 客户端param传入的参数可以直接使用
	function SaveAS()
	{
		var db = null;
		var guid = "";
		try {
			db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
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
	//得到单元格的高度，（考虑到合并因素）
	function getcellcolw(sxgds,sColW,row,col,CELLPADDING )
	{
		if(sxgds.GetCellHide(row,col)==true)return 0;
		
		var colw = 1*getcolw(sxgds,sColW,col);
		//得到被合并单元格的宽度
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
		//得到被合并单元格的gao度
		var rowspan = sxgds.GetCellColSpan(row,col);
		var colspan = sxgds.GetCellRowSpan(row,col);
		for ( var j=0;j<colspan;j++ ) {
			rowh +=1*getrowh(sxgds,sRowH,row+j+1)+1*CELLPADDING ;
		}
		return rowh;
	}
	
	// 只取原始大小
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
			rowh = sRowH[r];//取自定义列宽
		return rowh;
	}



}