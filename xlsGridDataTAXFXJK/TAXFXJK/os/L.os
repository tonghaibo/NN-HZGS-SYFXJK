function TAXFXJK_L(){	var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
	var pub = new JavaPackage ( "com.xlsgrid.net.pub" );
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
		// 处理重定向的问题
		var url = request.getRequestURL().toString();
    		var b = url.indexOf(":");
    		var protocol = url.substring(0,b);
    		var sServerName = request.getHeader("X-FORWARDED-HOST");
    		if(pubpack.EAFunc.isEmptyStr(sServerName))
      			sServerName = request.getHeader("HOST");
      		var loc = url.indexOf("/L.sp");

    		if(protocol == "http" && sServerName =="139.196.39.78" && loc >=0) {
    		
    			response.sendRedirect("https://sch.xmidware.com/chis"+url.substring(loc)+"?"+pubpack.EAFunc.GetRequestQueryString(request) );
    		
    		}
    			
		//run customer os function with no login system
		try {
			var osp = pubpack.EAFunc.NVL( request.getParameter("osp"),"") ; //sytid 
			if (osp != "") {
				//return osp;
				var sytid = osp.split("_")[0];
				var mwid = osp.split("_")[1];
				var func = osp.split("_")[2];
				if (mwid == "publicos" || mwid == "appWebService") {
					var os = new pubpack.EAScript(null);
					var scriptArgs = new Array();
					scriptArgs[0] = request;
					var retos = os.CallClassFunc(sytid+"_"+mwid,func,scriptArgs);
					return retos.castToString();
				}
				else{
					
					var os = new pubpack.EAScript(null);
					os.DefineScopeVar("request", request);
					var retos = os.CallClassFunc(sytid+"_"+mwid,func,null);
					return retos.castToString();
				}
			}
			var osprcall = pubpack.EAFunc.NVL( request.getParameter("osprcall"),"") ; //sytid 
			if(osprcall=="rcall"){
				var sytid= pubpack.EAFunc.NVL( request.getParameter("sytid"),"") ; //sytid 
				var mwid= pubpack.EAFunc.NVL( request.getParameter("mwid"),"") ; //mwid
				var func= pubpack.EAFunc.NVL( request.getParameter("func"),"") ; //func
				
				var os = new pubpack.EAScript(null);
				os.DefineScopeVar("request", request);
				var retos = os.CallClassFunc(sytid+"_"+mwid,func,null);
				return retos.castToString();
			}
			
			
		}
		catch(e) {
			return e.toString();
		}
		
		
		var db = null;
		var msg= "";
		var layoutid = pubpack.EAFunc.NVL( request.getParameter("id"),"") ;
		var grdid = pubpack.EAFunc.NVL( request.getParameter("grdid"),"") ;// L.sp?grdid=PP&guid=f13131 类似show.sp?grdid=PP   
		

		var objid= pubpack.EAFunc.NVL( request.getParameter("objid"),"") ;
		var skin= pubpack.EAFunc.NVL( request.getParameter("skin"),"") ;
		var hashead = pubpack.EAFunc.NVL( request.getParameter("hashead"),"y") ;
		var lang = pubpack.EAFunc.NVL( request.getParameter("lang"),"GBK") ;//允许输入其他的字符集 如 UTF-8

		
		var deforg =  pubpack.EAFunc.NVL( request.getParameter("thisorgid"),webpack.EAWebDeforg.GetDeforg(request)) ;
		var browsetype = pubpack.EAFunc.getBroswerType( request );
		
		var sb=new langpack.StringBuffer();
		var grdid = pubpack.EAFunc.NVL( request.getParameter("grdid"),"") ;// L.sp?grdid=PP&guid=f13131 类似show.sp?grdid=PP   
	
		try {
			if(skin!="")request.getSession().setAttribute("USERSKIN",skin);//修改皮肤可以通过 L.sp?id=index&skin=blue  
			db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			
			if(grdid!=""){//这是一个中间件输出页面
				response.setContentType("text/html;charset="+lang);//response.setContentType("text/html; charset=GBK");
				
				var sytid = "";
				
				if(hashead=="y"){
					var logininfo = webpack.EASession.GetLoginInfo(request);//GetUserinfo、GetLoginInfo
					sytid = pubpack.EAFunc.NVL( request.getParameter("sytid"),"") ;// L.sp?grdid=PP&guid=f13131 类似show.sp?grdid=PP
					if (sytid == "" ) sytid=logininfo.getSytid();   

					getbasehtmlhead(sb,sytid,grdid,logininfo,lang);
					sb.append( "<body  topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0 onload=\"javascript:f_body_onload();\">");

				}

				var OSSYT1 = "x";
				var OSMWID1 = "showflg_mw";
				var OSFUNC1 = "GetBody";
				var eas = new pub.EAScript(null);                		 
				//参数找到后，就执行方法，上面所指的funname其实是文件名字，MyFun是文件的根节点，funName是方法名字
				try{
					eas.DefineScopeVar("db", db);
					eas.DefineScopeVar("request", request);
					eas.DefineScopeVar("sytid", sytid);

					var map = request.getParameterMap();
					var keys = map.keySet().iterator(); 
					while(	keys.hasNext() ){
						var _varNam = ""+keys.next();
          					var ss = map.get(_varNam);
          					eas.DefineScopeVar(_varNam, ss[0]);
					}
					var ret =  eas.CallClassFunc(""+OSSYT1 +"_"+OSMWID1+"",""+OSFUNC1+"",null).castToString();
					sb.append(ret);

				}catch(e){
					sb.append(""+OSSYT1 +"_"+OSMWID1+OSFUNC1+""+e.toString());
				}
				if(hashead=="y"){
					sb.append("</body></html>");
				}

			}
			else if(objid!="") {//这是一个组件的测试页面
			
				response.setContentType("text/html;charset="+lang );//response.setContentType("text/html; charset=GBK");
				if(hashead=="y"){
					var ds = db.QuerySQL("select * from LAYHDR where rownum=1" );
					gethtmlhead(db,ds,sb,lang);
					sb.append( "<body  topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0 onload=\"javascript:f_body_onload();>");


				}
				GetLayoutItem(db,request,sb,"[%IMAGE deforg='"+deforg+"' ctrltype='obj' ctrlid='"+objid+"' ]",0,0,0,"","",lang);
				if(hashead=="y"){
					sb.append("</body></html>");
				}
			}
			else {
			
				response.setContentType("text/html;charset="+lang);//response.setContentType("text/html; charset=GBK");
				// 布局的html
				if(hashead=="y"){
					
					GetLayoutHTML(db,request,sb,deforg,layoutid,1,"","",lang);
				}else {
				

					GetLayoutHTML(db,request,sb,deforg,layoutid,0,"","",lang);
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
	//p_layflg: 上级的layoutflg，需要一级一级往下延伸
	function GetLayoutHTML(db,request,sb,deforg,layoutid,ifneedhead,menuid,p_layflg,lang)
	{

				var ds = db.QuerySQL("select * from LAYHDR where deforg='"+deforg+"' and id='"+layoutid+"'" );
				if(ds.getRowCount()==0)
					throw new Exception( "该布局（"+deforg+"."+layoutid+"没有找到" );
				var colwidths = ds.getStringDef(0,"COLWIDTHS","" );
				var rowheights = ds.getStringDef(0,"ROWHEIGHTS" ,"");
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
				try{if(p_layflg!=""&& ds.get(0,"LAYFLG")=="") layflg  = p_layflg ; } catch(e ) {}// 如果上级的不为空取
				var fixflg = ifnull(ds.get(0,"FIXFLG"),"FIXWH");	//铺满模式
	
				var min_width= ifnull(ds.get(0,"min_width"),"0");  //最小宽度
				var padding_trbl = ifnull(ds.get(0,"margin_top"),"0%") +" "+ ifnull(ds.get(0,"margin_right"),"0%") +" "+ifnull(ds.get(0,"margin_bottom"),"0%")+" "+ifnull(ds.get(0,"margin_left"),"0%");//内边距
					
				var sxgguid = ds.get(0,"SXGGUID");
				
				var sxg = db.getBlob2String("select bdata from formblob where guid='"+sxgguid +"'","bdata");// for update

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
					
					gethtmlhead(db,ds,sb,lang);
					
					var bkcolor =ds.get(0,"BKCOLOR");
					var pagebkcolor = "bgcolor=\""+bkcolor+"\"";if(bkcolor =="")pagebkcolor ="";
					sb.append( "<body "+pagebkcolor+" topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0 onkeydown=\"keysubmit(event)\" onload=\"javascript:f_body_onload();\"");//onLoad=\"try{document.all('usrid').focus();}catch(e){} try{user_onload();}catch(e){}\"
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
				if(ds.get(0,"ONHTMLGUID")!="")sb.append( db.getBlob2String("select bdata from formblob where guid='"+ds.get(0,"ONHTMLGUID")+"'","bdata"));	
				if(onlayoutid!="") GetLayoutHTML(db,request,sb,deforg,onlayoutid,0,menulog,layflg,lang);
				var rows= sxgds.rows;
				var cols = sxgds.cols;
				var sSumHeight="";//sSumHeight=" height=\""+pageheightfix+"%\" ";				
				var sumwidth = 0;
				var sumheight = 0;
				var dflg = layflg;//DIV DIVFLW TABLE  DIVMOBILE
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
				//判断是否需要背景和前景
//				if(!(ds.get(0,"FKALIGN")=="" &&ds.get(0,"FKVALIGN")=="" &&ds.get(0,"FKWIDTH")=="" && ds.get(0,"FKHEIGHT")=="" && ds.get(0,"FKGRID")=="" && ds.get(0,"FKCOLOR")=="" && ds.get(0,"FKIMG")=="" )){
//					sb.append("<div id=\"TABLE_BK\"  style=\"background-color:"+ds.get(0,"BKCOLOR")+"; "+ ifnotnull(ds.get(0,"FKWIDTH")," width:"+ds.get(0,"FKWIDTH")+"; ")+ifnotnull(ds.get(0,"FKHEIGHT")," height:"+ds.get(0,"FKHEIGHT")+";")+"\">" );
//					sb.append("<div id=\"TABLE_"+layoutid+"_FK\" style=\""+ifnotnull(ds.get(0,"FKGRID"),"border:"+ds.get(0,"FKGRID")+";")+" "+ifnotnull(ds.get(0,"FKCOLOR"),"background-color:  "+ds.get(0,"FKCOLOR")+";")+" " + ifnotnull(ds.get(0,"FKIMG")," background-image: url('"+ds.get(0,"FKIMG")+"');")+"");
//					sb.append("padding:"+padding_trbl+";\">");
//					//sb.append("<table id=\"TABLE_BK\" border=0 cellspacing=0 cellpadding=0 width=100% height=100%><tr><td align=\""+ifnull(ds.get(0,"FKALIGN"),"CENTER")+"\" valign=\""+ifnull(ds.get(0,"FKVALIGN"),"MIDDLE")+"\">\n");
//					//sb.append("<table id=\"TABLE_"+layoutid+"_FK\" border=0 cellspacing=0 cellpadding=0 "+ifnotnull(ds.get(0,"FKWIDTH")," width="+ds.get(0,"FKWIDTH"))+" "+ifnotnull(ds.get(0,"FKHEIGHT")," height="+ds.get(0,"FKHEIGHT"))+"\"><tr><td align=\"LEFT\" align=\"TOP\" style=\""+ifnotnull(ds.get(0,"FKGRID"),"border: 1px solid "+ds.get(0,"FKGRID")+";")+" "+ifnotnull(ds.get(0,"FKCOLOR"),"background-color:  "+ds.get(0,"FKCOLOR")+";")+" " + ifnotnull(ds.get(0,"FKIMG")," background-image: url('"+ds.get(0,"FKIMG")+"')")+"\">\n");
//				}
				//2015 modify by scott 重新定义前景，并且支持居中对齐
				if(!(ds.get(0,"FKALIGN")=="" &&ds.get(0,"FKVALIGN")=="" &&ds.get(0,"FKWIDTH")=="" && ds.get(0,"FKHEIGHT")=="" && ds.get(0,"FKGRID")=="" && ds.get(0,"FKCOLOR")=="" && ds.get(0,"FKIMG")=="" )){
											sb.append("<div id=\"TABLE_"+layoutid+"_FK\" style=\""+ifnotnull(ds.get(0,"FKGRID"),"border:1px solid "+ds.get(0,"FKGRID")+";")+" "+ifnotnull(ds.get(0,"FKCOLOR"),"background-color:  "+ds.get(0,"FKCOLOR")+";")+" " + ifnotnull(ds.get(0,"FKIMG")," background-image: url('"+ds.get(0,"FKIMG")+"');")+"");
						if(ds.get(0,"FKWIDTH")!="")sb.append("width:"+ds.get(0,"FKWIDTH")+";");
						else if(fixflg=="FIXW"||fixflg=="FIXWH")sb.append("width:100%;");
						else if(fixflg=="DEF") sb.append("width:"+sumwidth+"px;");
						//else sb.append("width:"+ds.get(0,"FKWIDTH")+";");
						
						//if(fixflg=="FIXH"||fixflg=="FIXWH")sb.append("height:100%;");
						//if(ds.get(0,"FKHEIGHT")=="")sb.append("height:"+sumheight+"px;");//
						//else sb.append("height:"+ds.get(0,"FKHEIGHT")+";");//
						if(ds.get(0,"FKHEIGHT")!="")sb.append("height:"+ds.get(0,"FKHEIGHT")+";");
						
						if(ds.get(0,"FKALIGN")=="CENTER")sb.append("margin-left:auto;margin-right:auto;");
	
						sb.append("padding:"+padding_trbl+";\">");

				}
				
							
				// 水平
				var wflg = "1";//水平铺满 百分比还是pt =0 % else pt
				var aflg = "1";//垂直铺满 百分比还是pt =0 % else pt
				if(fixflg=="FIXW")wflg="0";
				if(fixflg=="FIXH")aflg="0";
				if(fixflg=="FIXWH"){ wflg="0";aflg="0"; }
				
				//sb.append("<!-- debug info:layoutid="+layoutid+" fixflg="+fixflg+",layflg="+layflg+",wflg="+wflg+",aflg ="+aflg +",dflg="+dflg+" -->\n");
				// 从sxg取出各个单元格数据
				if(dflg =="TABLE"){// 
					sb.append( "\n<table id=\"PAGE_MAIN_"+layoutid+"\" border=\"0\" width=\"100%\" height=100% id=\"TABLE_MAIN\" cellspacing=\""+CELLSPACE+"\" cellpadding=\""+CELLPADDING+"\" >\n");
				}
//				else if (dflg == "DIVMOBILE") {
//					var stylet="style=\"width:740px;margin-left:auto;margin-right:auto;\"";									 
//					sb.append( "\n<div id=\"PAGE_MAIN_"+layoutid+"\" "+stylet +"  >");
//				}
				else {
					//设置最小宽度
					var stylet="style=\"position:relative ;width:100%;margin:"+CELLSPACE+"px;height:100%;min-width:"+min_width+"px;_width:expression((document.documentElement.clientWidth||document.body.clientWidth)<"+min_width+"?"+min_width+":auto);\"";									 
					sb.append( "\n<div id=\"PAGE_MAIN_"+layoutid+"\" "+stylet +">");
					

				}
				

//				throw new Exception(dflg);
				if(dflg=="DIV") {//  DIV布局-铺满-用于网站
					
					f_getdivtree(db,request,sb,sxgds,dflg,aflg,wflg,sColW,sRowH,CELLPADDING ,0,0,rows-1,cols-1,0,layoutid,menuid,lang);	//递归，获取树形的DIV结构
				}
				else {	//TABLE or div flw

								
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
										
										if(attrid.substring(0,1)==" ") attrid=attrid.substring(1);
										oldidx=	str.indexOf("' ",idx+1)+2;
										if(oldidx-2<idx+2) oldidx= str.indexOf("' ",idx+2)+2;// 可能是 =' 移动互联网' 

										var attrval = str.substring(idx+2,oldidx-2);
										
										if(oldidx==1)
											attrval= str.substring(idx+2,str.length()-1);
										
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
										
										else if(attrid=="overflow-x"){
											overflow_x = attrval;
										}
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
									sStyle += "overflow-x:"+overflow_x+";"; //div溢出
								if(overflow_y!="")
									sStyle += "overflow-y:"+overflow_x+";"; 
								
														
								var sURLHTML= "";
								if(url!=""){
//									url=web.EASession.GetSysValue(url,request);//替换request 中[%id]
//									url=web.EASession.GetSysValue(url,web.EASession.GetLoginInfo(request));
									var sClick ="";
									if(url.indexOf("javascript:")!=-1 || url.indexOf("f_openLocalURL")!=-1){
								        	sClick=url;
								        }
								        else{
										if ( target == "" || target=="_self"  ) //||targetLayoutid.length()!=0
									        	sClick="javascript:window.location='"+url+"';";
									        else if ( target=="_blank" ) 
									        	sClick="javascript:openWindow('"+url+"');";
									        else if ( target!="_self" )
								        		sClick="javascript:frames['"+target+"'].location='"+url+"';";
								        } 
									sURLHTML=" onclick=\""+sClick+"\" onmouseover=\"this.style.cursor='hand';\""; 
								}
								sb.append( "<!-- 单元格 "+dflg+"-->\n");
								
								if(dflg =="TABLE"){
									
									sb.append("<td id=\"DIV_"+r+"_"+c+"\" "+sURLHTML+" width=\""+width+"\" height="+height+" align=\""+align+"\" valign=\""+valign+"\" style=\""+sStyle+"\"");
									if( rowspan>1)sb.append(" rowspan="+rowspan);
									if( colspan>1)sb.append(" colspan="+colspan);
									sb.append(">");
								}
								else if ( dflg == "DIVMOBILE" ) {
									if(width!=""&&width!="0")sStyle += "width:"+width+";"; 
									if(height!=""&&height!="0")sStyle += "height:"+height+";"; 
									
									// width=\""+width+"\" height="+height+" style=\""+sStyle+"\" 
									sb.append("\r\n<div id=\"DIV_"+r+"_"+c+"\" "+sURLHTML+"  style=\""+sStyle+"\" " );//padding:10px;  //width=\""+colw+"\" height="+rowh+" align=\"left\" valign=\"top\"						//if( rowspan>1)sb.append(" rowspan="+rowspan);
									sb.append(">");

								
								}
								else {
									if(width!=""&&width!="0")
									sStyle += "width:"+width+";"; 
									if(height!=""&&height!="0")
									sStyle += "height:"+height+";"; 
									
									sStyle +="float:left;";
									sb.append("\r\n<div id=\"DIV_"+r+"_"+c+"\" "+sURLHTML+"  width=\""+width+"\" height="+height+" style=\""+sStyle+"\" ");//padding:10px;  //width=\""+colw+"\" height="+rowh+" align=\"left\" valign=\"top\"						//if( rowspan>1)sb.append(" rowspan="+rowspan);
									sb.append(">");
								}
								str = sxgds.GetCellText(r,c);
								sb.append("\n<!-- layout item "+ r+"_"+c+"-->\n");
								
		
//								if(layoutid=="SJAPPBRDA")
//								throw new Exception("1111");
		              					GetLayoutItem(db,request,sb,str,r,c,rowh,menuid,layflg,lang);
			              				
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
					//sb.append("</div>");
					//sb.append("<div style=\"height:100%; overflow:hidden; display:inline-block; width:1px; overflow:hidden; margin-left:-1px; zoom:1; *display:inline; *margin-top:-1px; _margin-top:0; vertical-align:middle;\"></div>");
				}
				if(postlayoutid !="") GetLayoutHTML(db,request,sb,deforg,postlayoutid ,0,menulog,layflg,lang);
				if(ds.get(0,"POSTHTMLGUID")!="")sb.append( db.getBlob2String("select bdata from formblob where guid='"+ds.get(0,"POSTHTMLGUID")+"'","bdata"));	
				if(ifneedhead!=0)sb.append("</body></html>");
	
	}
	// 内部函数，得到公共的js变量
	function _gethtmljs(sb){
		sb.append("\nvar G_CLIENTPARAM = \"\"; if((''+window.location).indexOf(\"?\")>=0) G_CLIENTPARAM =\"&\"+(''+window.location).substring( (''+window.location).indexOf(\"?\")+1 );"); 
		sb.append("\nvar G_APP_USRID=\"\";var G_APP_USRNAM=\"\";var G_APP_USERPWD=\"\";var G_APP_USRIMG=\"\";var G_APP_USRGUID=\"\";var G_APP_USRORG=\"\";var G_APP_ACCID=\"\";var G_APP_ACCROOTSTR=\"\";"); 
		sb.append("\n try{G_APP_USRID=window.localStorage.getItem(\"XMIDWARE_APP_USRID\");G_APP_USRGUID=window.localStorage.getItem(\"XMIDWARE_APP_USRGUID\");
		G_APP_USRNAM=window.localStorage.getItem(\"XMIDWARE_APP_USRNAM\");
		try{G_APP_USRORG=window.localStorage.getItem(\"XMIDWARE_APP_USRORG\");}catch(e){G_APP_USRORG='';}
		
		G_APP_USERPWD=window.localStorage.getItem(\"XMIDWARE_APP_USERPWD\"); G_APP_USRIMG=window.localStorage.getItem(\"XMIDWARE_APP_USRIMG\");G_APP_ACCID=window.localStorage.getItem(\"XMIDWARE_APP_ACCID\");}catch(e){}"); 
		sb.append("if(G_APP_ACCID==null)G_APP_ACCID='';if(G_APP_USRID==null)G_APP_USRID='';if(G_APP_USRGUID==null)G_APP_USRGUID='';if(G_APP_USRNAM==null)G_APP_USRNAM='';if(G_APP_USERPWD==null)G_APP_USERPWD='';if(G_APP_USRIMG==null)G_APP_USRIMG='';if(G_APP_ACCID==null)G_APP_ACCID='';");
		sb.append("if(G_APP_ACCID!='')G_APP_ACCROOTSTR='ROOT_'+G_APP_ACCID+'/';");
		sb.append("\nvar G_WEBBASE=\"\";
		try{
			var loc_webes=window.localStorage.getItem(\"XMIDWARE_APP_WEBBASE\"); 
			if(loc_webes==null||loc_webes=='undefined')  G_WEBBASE=''; else G_WEBBASE=loc_webes;
		}catch(e){ G_WEBBASE=''; }
		if(G_WEBBASE=='')G_WEBBASE='"+pubpack.EAFunc.getAppAccRootUrl(request)+"';else G_WEBBASE=G_WEBBASE+G_APP_ACCROOTSTR;"); 
		
		sb.append("\nfunction GetLocationParam(param){// 得到window.location的某个参数
					var ss=(''+window.location).split('?');
					if(ss.length>1){
						var sss = ss[1].split('&');
						for(var i=0;i<sss.length;i++){
							var ssss = sss[i].split('=');
							if(ssss.length>1 && ssss[0]==param)return ssss[1];
						}
					}
					return '';
				}
			"); 
		sb.append("function replaceimgall(str){
			var curidx = -1;var count = 0 ;
			//替换规则<img 里src的图片
			curidx = str.indexOf(\"<img\",curidx+1);//第一个引号位置，“curidx+1”表示从该位置开始查找引号
			while(curidx >-1){
				var curidx2 = str.indexOf(\"src=\",curidx +1);
				var endidx = str.indexOf(\">\",curidx +1);
				if(curidx2>0&&endidx >0&&  endidx >curidx2 ){
					if(str.substring(curidx2+5,1)=='\"'||str.substring(curidx2+5,1)==\"'\"){ // src后面带引号
						str = str.substring(0,curidx2+6)+G_WEBBASE+str.substring(curidx2+6);
					} 
					else str = str.substring(0,curidx2+5)+G_WEBBASE+str.substring(curidx2+5);
				}
				curidx = str.indexOf(\"<img\",curidx+1);//第一个引号位置，“curidx+1”表示从该位置开始查找引号
				count ++; if ( count >1000) break;
			}
			return str;
		} " );
		sb.append("function replacehrefall(str,idflag){//idflag==id grd
			var sLoc = \"\"+window.location ;
			
			if(sLoc.indexOf(\"http\")>=0 ) return str;
			var curidx = -1;var count = 0 ;
			curidx = str.indexOf(\"L.sp\"+\"?\"+idflag+\"=\",curidx+1);
			var oldcuridx=-1;
			while(curidx >-1){
				// 如果L.sp前面有G_WEBBASE,说明这是一个在线系统，不要替代为
				var basecuridx = 	str.lastIndexOf(\"G_WEBBASE+\",curidx);
				if(basecuridx>0&&basecuridx>oldcuridx){
					
				}
				else {
					var loc1 = str.indexOf(\"&\",curidx +1);
					var loc2 = str.indexOf(\"'\",curidx +1);
					var loc3 = str.indexOf('\"',curidx +1);
					var loc = loc1;if(loc1<0)loc=loc2;if(loc<0)loc=loc3;
					if(loc1>0&&loc2>0&&loc>loc2) loc= loc2; 
					if(loc2>0&&loc3>0&&loc>loc3) loc= loc3;
					var newstr = str.substring(curidx,loc);
					var ss = newstr.split('?');
					if(ss.length>1){
						var sss = ss[1].split('=');
						if(sss.length>1){
							str = str.substring(0,curidx)+sss[1]+'.html?'+ss[1]+str.substring(loc);
	
						}
					}
				}
				oldcuridx = curidx;
				curidx = str.indexOf(\"L.sp\"+\"?\"+idflag+\"=\",curidx+1);//第一个引号位置，“curidx+1”表示从该位置开始查找引号
				count ++; if ( count >1000) break;
			}
			return str;
		} " );

//		sb.append("\n try{G_APP_USRID=window.localStorage.getItem(\"XMIDWARE_APP_USRID\");G_APP_USRGUID=window.localStorage.getItem(\"XMIDWARE_APP_USRGUID\");
//		G_APP_USRNAM=window.localStorage.getItem(\"XMIDWARE_APP_USRNAM\");
//		try{G_APP_USRORG=window.localStorage.getItem(\"XMIDWARE_APP_USRORG\");}catch(e){G_APP_USRORG='';}
//		G_APP_USERPWD=window.localStorage.getItem(\"XMIDWARE_APP_USERPWD\"); G_APP_USRIMG=window.localStorage.getItem(\"XMIDWARE_APP_USRIMG\");G_APP_ACCID=window.localStorage.getItem(\"XMIDWARE_APP_ACCID\");}catch(e){}"); 
//		sb.append("if(G_APP_ACCID==null)G_APP_ACCID='';if(G_APP_USRID==null)G_APP_USRID='';if(G_APP_USRGUID==null)G_APP_USRGUID='';if(G_APP_USRNAM==null)G_APP_USRNAM='';if(G_APP_USERPWD==null)G_APP_USERPWD='';if(G_APP_USRIMG==null)G_APP_USRIMG='';if(G_APP_ACCID==null)G_APP_ACCID='';");
		
	
	}
	// html head style public 
	function gethtmlhead(db,ds,sb,charset)
	{
		
		var compmode=ds.get(0,"COMPMODE");		
		if(compmode==1) {
			sb.append("<html xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>"+ds.get(0,"TITLE")+"</title><meta http-equiv=\"Content-Type\" content=\"text/html;\" charset=\""+charset+"\"/><script language=\"javascript\" src=\"xlsgrid/js/wnd.js\"></script><script language=\"javascript\" src=\"xlsgrid/images/flash/js/jquery-1.7.2.min.js\"></script>");
			sb.append("<link href=\"xlsgrid/images/flash/css/bootstrap.min.css\" rel=\"stylesheet\" type=\"text/css\" /><link href=\"xlsgrid/images/flash/css/jquery-ui-1.10.0.custom.css\" rel=\"stylesheet\" type=\"text/css\" />");//<LINK rel=stylesheet type=text/css HREF=\"xlsgrid/css/layout.css\">
		
		}
		else{
			var title = ds.get(0,"TITLE");
			if(title=="")title = ds.get(0,"NAME");
			sb.append("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html lang=\"zh-CN\"   xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>"+
			title+"</title><meta http-equiv=\"Content-Type\" content=\"text/html;\" charset=\""+charset+"\"/>"+
			"<script language=\"javascript\" src=\"xlsgrid/js/wnd.js\"></script>\n"+
			"<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/SkyRTC-client.js\"></script>\n"+
			"<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery-1.7.2.min.js\"></script>\n"+
			"<script type=\"text/javascript\" src=\"xlsgrid/js/highcharts.js\"></script>\n"+
			"<script language=\"javascript\" src=\"xlsgrid/js/exporting.js\"></script>\n"+
			"<link href=\"xlsgrid/images/flash/css/bootstrap.min.css\" rel=\"stylesheet\" type=\"text/css\" /><link href=\"xlsgrid/images/flash/css/jquery-ui-1.10.0.custom.css\" rel=\"stylesheet\" type=\"text/css\" />"+
			"<script type=\"text/javascript\" src=\"xlsgrid/js/highcharts-3d.js\"></script>\n");
		}
		var iconfont=ds.getStringDef(0,"ICONFONT","");
		if(iconfont!="")
			sb.append("<link rel=\"stylesheet\" href=\"xlsgrid/images/flash/iconfont/"+iconfont+"/iconfont.css\">");
		
		//sb.append("<meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0\" /> ");
		sb.append("<meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,minimum-scale=0.5,maximum-scale=3.0,user-scalable=no\">");
		sb.append("");
		if(ds.get(0,"PREHTML")!=""){
			sb.append( db.getBlob2String("select bdata from formblob where guid='"+ds.get(0,"PREHTML")+"'","bdata"));//ONHTMLGUID
		}
		sb.append("\n<script>\n");
		//var logininfo = webpack.EASession.GetUserinfo(request);
		//if (logininfo != null)  sb.append("var homeurl=\""+logininfo.getHomeURL()+"\";var mainurl=\""+logininfo.getMainurl()+"\"; \n");
		// 
		sb.append("
			var G_BROWSETYPE='';
			
			//********************************************
			//*****修改时间2017-04-25 优化标题加载速度慢问题
			//*******************************************
			var kdocTitle='';
			$(function(){
				kdocTitle = document.title;//标题 
				if(kdocTitle == null){ 
				    var t_titles = document.getElementByTagName('title') 
				    if(t_titles && t_titles.length >0) 
				    { 
				       kdocTitle = t_titles[0]; 
				    }else{ 
				       kdocTitle = ''; 
				    } 
				} 							
				try{parent.f_childwndready(kdocTitle );}catch(e){}
			})
			
			function f_body_onload(){
				// 判断浏览器版本
				var browser = {
					versions: function() {
						var u = navigator.userAgent, app = navigator.appVersion;
						return {//移动终端浏览器版本信息 
						trident: u.indexOf('Trident') > -1, //IE内核
						presto: u.indexOf('Presto') > -1, //opera内核
						webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
						gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, //火狐内核
						mobile: !!u.match(/AppleWebKit.*Mobile.*/) || !!u.match(/AppleWebKit/), //是否为移动终端
						ios: !!u.match(/\\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
						android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或者uc浏览器
						iPhone: u.indexOf('iPhone') > -1 || u.indexOf('Mac') > -1, //是否为iPhone或者QQHD浏览器
						iPad: u.indexOf('iPad') > -1, //是否iPad
						webApp: u.indexOf('Safari') == -1 //是否web应该程序，没有头部与底部
					};
				}(),
				language: (navigator.browserLanguage || navigator.language).toLowerCase()
				}
				 
				if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad) {
					G_BROWSETYPE='IOS';
				}
				else if (browser.versions.android) {
					G_BROWSETYPE='ANDROID';
				}
							
				
//				kdocTitle = document.title;//标题 
//				if(kdocTitle == null){ 
//				    var t_titles = document.getElementByTagName('title') 
//				    if(t_titles && t_titles.length >0) 
//				    { 
//				       kdocTitle = t_titles[0]; 
//				    }else{ 
//				       kdocTitle = ''; 
//				    } 
//				} 							
//				try{parent.f_childwndready(kdocTitle );}catch(e){}
				try{f_onload();}catch(e){} 
				try{
					document.addEventListener(\"deviceready\", onDeviceReady, false);
				}
				catch(e){
				}
				try{
					f_uploadapp();
				}
				catch(e){
				}

			}
			/*
			var pluginAlert = function(msg){
					
			    navigator.notification.alert(msg,  // message
			                                 alertDismissed,         // callback
			                                 '提示',            // title
			                                 'Done'                  // buttonName
			                                 );
			};
			*/	
			// 公共的设备ready调用函数
			function onDeviceReady() {
				try{ f_deviceready() ;}
				catch(e){
					document.addEventListener('backbutton', function (){
						try{parent.f_goback();}catch(ee){try{f_goback();}catch(eee){}}
						return 1;
					});
				}
				//更改提示框
				/*
				var pluginAlert = function(msg){
					
				    navigator.notification.alert(msg,  // message
				                                 alertDismissed,         // callback
				                                 '提示',            // title
				                                 'Done'                  // buttonName
				                                 );
				};
				window.alert = pluginAlert;	
				*/
//					console.log(navigator.notification);
//				    	window.alert = navigator.notification.alert;
//					window.confirm = navigator.notification.confirm;
//					window.prompt = navigator.notification.prompt;
			}
			
			var bAppendAudio = false
			function alertaudio(src)
			{
				if(bAppendAudio == false) {
					$(document.body).append(\"<audio id='myAlertAudio' src='\"+src+\"' hidden='true' />\");
					bAppendAudio = true;
				}
				document.all('myAlertAudio').src=src;	
				document.all('myAlertAudio').play();		
			}
			function closewindow(){
				window.close();
			}
		");

		
		sb.append("function keysubmit(evt){ \n");
		sb.append(" try {\n");
		sb.append("   if(evt.keyCode=='13'){ \n");
		sb.append("     if ( document.all('usrid').value =='' ) document.all('usrid').focus(); \n");
		sb.append("     else if ( document.all('userpwd').value =='' ) document.all('userpwd').focus(); \n");
		sb.append("     else {try{xmidware_login();}catch(e){f_login.submit();} }\n");
		sb.append("   }\n");
		sb.append(" }catch(e){}");
		sb.append("}");
		_gethtmljs(sb);
		
		sb.append("\n</script>"); 

		sb.append("<style type='text/css'>\n");
		
		
//		sb.append(".selectTdClass{background-color:#edf5fa!important}");
//		sb.append("table.noBorderTable td,table.noBorderTable th,");
//		sb.append("table.noBorderTable caption{border:1px dashed #ddd!important}table{margin-bottom:10px;border-collapse:collapse;display:table;width:100%!important}td,");
//		sb.append("th{word-wrap:break-word;word-break:break-all;padding:5px 10px;border:1px solid #DDD}caption{border:1px dashed #DDD;border-bottom:0;padding:3px;text-align:center}th{border-top:2px solid #BBB;background:#f7f7f7}.ue-table-interlace-color-single{background-color:#fcfcfc}.ue-table-interlace-color-double{background-color:#f7faff}td p{margin:0;padding:0}.res_iframe{display:block;width:100%;background-color:transparent;border:0}.vote_area{display:block;position:relative;margin:14px 0;white-space:normal!important}.vote_iframe{width:100%;height:100%;background-color:transparent;border:0}form{display:none!important}@media screen and (min-width:0\0) and (min-resolution:72dpi){.rich_media_content table{table-layout:fixed!important}.rich_media_content td,.rich_media_content th{width:auto!important}}.tc{text-align:center}.tl{text-align:left}.tr{text-align:right}.tips_global{color:#8c8c8c}.rich_split_tips{margin:20px 0;min-height:24px}.rich_media_tool_tips{margin-bottom:8px}.rich_media_tool{overflow:hidden;padding-top:15px;line-height:32px}.rich_media_tool .meta_primary{float:left;margin-right:10px}.rich_media_tool .meta_extra{float:right;margin-left:10px}.rich_media_tool .meta_praise{margin-right:0;margin-left:8px}.media_tool_meta i{vertical-align:0;position:relative;top:1px;margin-right:3px}.meta_praise{-webkit-tap-highlight-color:rgba(0,0,0,0);outline:0;min-width:3.5em}.meta_praise .praise_num{display:inline-block;vertical-align:top}.icon_praise_gray{background:transparent url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABoAAAA+CAYAAAA1dwvuAAAACXBIWXMAAA7EAAAOxAGVKw4bAAACd0lEQVRYhe2XMWhUMRjHfycdpDg4iJN26CQih4NUlFIc3iTasaAO+iZBnorIId2CDg6PLqWDXSy0p28TJ6ejILgoKiLFSeRcnASLnDf2HPKll8b3ah5NQPB+cHzJl0v+73J5Sf6NwWCAD6kqxoEV4BywCTwA2j59V9QlxrxUNJeBOSkfBtaAHvDcp/O+GkJHJd4H7kr5nm/nOkJHJH4FHkv5WAyhUxLfAgelvBlUKFXFBNCU6oYl+j6oEHohADwFtoDTUn8dTChVxX7gjlSfSJyS+CaYEDCPXs4d4IXkzDR+8BWqfI9SVUyil/ENST20ml8BF4Afu4z9HT3V80B/TAY9CxTABNAHxp1Oj4B1q34dWAamGa5Al0PALfSs3TS/aE1EcERWgQXgozPIN+Ai6O2ljFQVM8BLZJqN0KTEhgj9kvrViqf1wYz5BcoXQ38Pg9uckfiuSigU0xLXowmlqpgCjgNd4FM0IeCKxGcmEUtoRqLZScILpaqYA06iN9/tTTfGLzKvxLKdDCqUquIEcB59xK9GE2J4xLeBn3ZD1abaq/sQqSpmgWvo82rBbTdCPeAA4N69/noXS1XhphaBz27SPPVtapz/FXSBFsNDcgcN3wvkiBEjRoSndAtqLXXKvuvtYfMs+SP3T3tYm6ge1iaqh7UJ62HRTqNZko/mYV3CeVjA9rAuUTxsGd4edrcX1vWwddn2sHmWaA/bWuq4HnYLff3aC7U8bAiaMPyPJp3GhnxCUOlhQxPdwxrieViLbp4lUT2sIbqHNcTzsBYbeZZE9bCGeB7WIrqHNbTzLNnhYWMIlXpYI9Rz8gM8/GsFi3mW/Ace9jf8QZwIX5o4uQAAAABJRU5ErkJggg==) no-repeat 0 0;width:13px;height:13px;vertical-align:middle;display:inline-block;-webkit-background-size:100% auto;background-size:100% auto}.icon_praise_gray.praised{background-position:0 -18px}.praised .icon_praise_gray{background-position:0 -18px}.rich_tips{margin-top:25px;margin-bottom:0;min-height:24px;text-align:center}.rich_tips .tips{display:inline-block;vertical-align:middle}.rich_tips .tips,.rich_tips .rich_icon{vertical-align:middle}.rich_tips .rich_icon{margin-top:-3px 5px 0 0}.rich_tips.with_line{border-top:1px dotted #e1e1e1}.rich_tips.with_line .tips{position:relative;top:-12px;padding-left:16px;padding-right:16px;background-color:#f3f3f3}.rich_tips.with_line{line-height:16px}.rich_tips.with_line .tips{top:-11px;padding-left:.35em;padding-right:.35em}.title_tips .tips{color:#868686;font-size:16px}.loading_tips{margin:36px 0 20px}.title_bottom_tips{margin-top:-10px}.icon_arrow_gray{width:7px}.icon_loading_white{width:16px}.icon_loading_white.icon_before{margin-right:1em}.icon_loading_white.icon_after{margin-left:1em}.btn{display:block;padding-left:14px;padding-right:14px;font-size:18px;text-align:center;text-decoration:none;border-radius:5px;-moz-border-radius:5px;-webkit-border-radius:5px;box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;color:#fff;line-height:42px;-webkit-tap-highlight-color:rgba(255,255,255,0)}.btn.btn_inline{display:inline-block}.btn_primary{background-color:#04be02}.btn_primary:not(.btn_disabled):visited{color:#fff}.btn_primary:not(.btn_disabled):active{color:rgba(255,255,255,0.4);background-color:#//039702}.btn_disabled{color:rgba(255,255,255,0.6)}.wx_poptips{position:fixed;z-index:3;width:120px;min-height:120px;top:180px;left:50%;margin-left:-60px;background:rgba(40,40,40,0.5)!important;filter:progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr='#80282828',endcolorstr = '#80282828');text-align:center;border-radius:5px;-moz-border-radius:5px;-webkit-border-radius:5px;color:#fff}.wx_poptips .icon_toast{width:53px;margin:15px 0 0}.wx_poptips .toast_content{margin:0 0 15px}.discuss_container .rich_media_title{font-size:18px}.discuss_container .discuss_message{word-wrap:break-word;-webkit-hyphens:auto;-ms-hyphens:auto;hyphens:auto}.discuss_container.disabled .btn_discuss{color:#60f05f}.discuss_container.access .discuss_container_inner{padding:15px 15px 0}.discuss_container.editing .discuss_container_inner{padding-bottom:25px}.discuss_container.editing .frm_textarea_box_wrp{margin:0 -15px}.discuss_container.editing .frm_textarea{height:78px}.discuss_container.editing .frm_append.counter{display:block}.discuss_container.editing .discuss_btn_wrp{display:block}.discuss_container.editing .discuss_icon_tips{margin-top:0;margin-bottom:-14px}.discuss_container.editing .discuss_title_line{margin-bottom:-20px}.discuss_container.warning .counter{color:#e15f63}.frm_textarea{width:100%;background-color:transparent;border:0;display:block;font-size:14px;-webkit-box-sizing:border-box;box-sizing:border-box;height:37px;padding:10px 15px;resize:none;outline:0;-webkit-tap-highlight-color:rgba(0,0,0,0)}.frm_textarea_box_wrp{position:relative}.frm_textarea_box_wrp:before{content:\" \";position:absolute;left:0;top:0;width:100%;height:1px;border-top:1px solid #e7e6e4;-webkit-transform-origin:0 0;transform-origin:0 0;-webkit-transform:scaleY(0.5);transform:scaleY(0.5);top:-1px}.frm_textarea_box_wrp:after{content:\" \";position:absolute;left:0;top:0;width:100%;height:1px;border-top:1px solid #e7e6e4;-webkit-transform-origin:0 0;transform-origin:0 0;-webkit-transform:scaleY(0.5);transform:scaleY(0.5);top:auto;bottom:-2px}.frm_textarea_box{display:block;background-color:#fff}.frm_append.counter{display:none;position:absolute;right:8px;bottom:8px;color:#a3a3a3;font-weight:400;font-style:normal;font-size:12px}.frm_append .current_num.warn{color:#f43631}.discuss_btn_wrp{display:none;margin-top:20px;margin-bottom:20px;text-align:right}.btn_discuss{padding-left:1.5em;padding-right:1.5em}.discuss_list{margin-top:-5px;padding-bottom:20px;font-size:15px}.discuss_item{position:relative;padding-left:45px;margin-top:26px;*zoom:1}.discuss_item:after{content:\"\200B\";display:block;height:0;clear:both}.discuss_item .user_info{min-height:20px;overflow:hidden}.discuss_item .nickname{display:block;font-weight:400;font-style:normal;color:#727272;width:9em;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;word-wrap:normal}.discuss_item .avatar{position:absolute;top:0;left:0;top:3px;width:35px;height:35px;background-color:#ccc;vertical-align:top;margin-top:0;border-radius:2px;-moz-border-radius:2px;-webkit-border-radius:2px}.discuss_item .discuss_message{color:#3e3e3e;line-height:1.5}.discuss_item .discuss_extra_info{color:#8c8c8c;font-size:12px}.discuss_item .discuss_extra_info a{margin-left:.5em}.discuss_item .discuss_status{color:#ff7a21;white-space:nowrap}.discuss_item .discuss_status i{font-style:normal;margin-right:2px}.discuss_item .discuss_opr{float:right}.discuss_item .discuss_opr .meta_praise{display:inline-block;text-align:right;padding-top:5px;margin-top:-5px}.discuss_icon_tips{margin-bottom:20px}.discuss_icon_tips img{vertical-align:middle;margin-left:3px;margin-top:-4px}.discuss_icon_tips .icon_edit{width:12px}.discuss_icon_tips .icon_access{width:13px}.reply_result{position:relative;margin-top:.5em;padding-top:.5em;padding-left:.4em}.reply_result:before{content:\" \";position:absolute;left:0;top:0;width:100%;height:1px;border-top:1px solid #dadada;-webkit-transform-origin:0 0;transform-origin:0 0;-webkit-transform:scaleY(0.5);transform:scaleY(0.5)}.reply_result .nickname{position:relative;overflow:visible}.reply_result //.nickname:before{content:\" \";position:absolute;left:-0.4em;top:50%;margin-top:-7px;width:3px;height:14px;background-color:#02bb00}.rich_tips.discuss_title_line{margin-top:50px}.rich_media_extra{font-size:15px;position:relative}.rich_media_extra .extra_link{display:block}.rich_media_extra img{vertical-align:middle;margin-top:-3px}.rich_media_extra .appmsg_banner{width:100%}.rich_media_extra .ad_msg_mask{position:absolute;left:0;top:0;width:100%;height:100%;text-align:center;line-height:200px;background-color:#000;filter:alpha(opacity = 20);-moz-opacity:.2;-khtml-opacity:.2;opacity:.2}.mpda_bottom_container .rich_media_extra{padding-bottom:15px}.btn_default.btn_line,.btn_primary.btn_line{background-color:#fff;color:#04be02;border:1px solid #04be02;font-size:15px}.promotion_tag{position:absolute;display:block;height:23px;line-height:23px;width:85px;background:transparent url(/mmbizwap/zh_CN/htmledition/images/ad/promotion_tag_bg2318b8.png) no-repeat 0 0;-webkit-background-size:85px 23px;background-size:85px 23px;font-size:15px;font-style:normal;color:#eaeaea;padding-left:10px;left:0;bottom:10px}.top_banner{background-color:#fff}.top_banner .rich_media_extra{padding:15px 15px 20px 15px}.top_banner .rich_media_extra .extra_link{position:relative;padding-bottom:10px}.top_banner .rich_media_extra .extra_link:before{content:\" \";position:absolute;left:0;top:0;width:100%;height:1px;border-top:1px solid #d6d6d6;-webkit-transform-origin:0 0;transform-origin:0 0;-webkit-transform:scaleY(0.5);transform:scaleY(0.5);top:auto;bottom:-2px}.top_banner .rich_media_extra .extra_link:active,.top_banner .rich_media_extra .extra_link:focus{outline:0;border:0}.top_banner .rich_media_extra .appmsg_banner{width:100%;vertical-align:top;outline:0}.top_banner .rich_media_extra .appmsg_banner:active,.top_banner .rich_media_extra .appmsg_banner:focus{outline:0;border:0}.top_banner .rich_media_extra .promotion_tag{height:20px;line-height:20px;width:72px;background:transparent url(/mmbizwap/zh_CN/htmledition/images/ad/promotion_tag_bg_small2318b8.png) no-repeat 0 0;font-size:12px;-webkit-background-size:72px 20px;background-size:72px 20px}.top_banner .rich_media_extra .ad_msg_mask{position:absolute;left:0;top:0;width:100%;height:100%;text-align:center;line-height:200px;background-color:#000;filter:alpha(opacity = 20);-moz-opacity:.2;-khtml-opacity:.2;opacity:.2}.top_banner .rich_media_extra .ad_msg_mask img{position:absolute;width:16px;top:50%;margin-top:-8px;left:50%;margin-left:-8px}.wrp_preview_group{padding-top:100px}.preview_group{position:relative;min-height:83px;background-color:#fff;border:1px solid #e7e7eb;-webkit-text-size-adjust:none;text-size-adjust:none}.preview_group.fixed_pos{position:fixed;bottom:0;left:0;right:0}.preview_group .preview_group_inner{padding:14px}.preview_group .preview_group_inner .preview_group_info{padding-left:68px;color:#8d8d8d;font-size:14px}.preview_group .preview_group_inner .preview_group_info .preview_group_title{overflow:hidden;text-overflow:ellipsis;white-space:nowrap;word-wrap:normal;color:#000;font-weight:400;font-style:normal;padding-right:73px;max-width:142px;display:block}.preview_group .preview_group_inner .preview_group_info .preview_group_desc{padding-right:65px;display:inline-block;line-height:20px}.preview_group .preview_group_inner .preview_group_info .preview_group_avatar{position:absolute;width:55px;height:55px;left:13px;top:50%;margin-top:-27px;z-index:1}.preview_group .preview_group_inner .preview_group_info .preview_group_avatar.br_radius{border-radius:100%;-moz-border-radius:100%;-webkit-border-radius:100%}.preview_group .preview_group_inner .preview_group_opr{position:absolute;line-height:83px;top:0;right:13px}.preview_group .preview_group_inner .preview_group_opr .btn{padding:0;min-width:60px;min-height:30px;height:auto;line-height:30px;text-align:center}.preview_group.preview_card .card_inner .preview_card_avatar{position:absolute;width:57px;height:57px;left:13px;top:50%;margin-top:-28px}.preview_group.preview_card .card_inner .preview_group_info{padding-//left:70px}.preview_group.preview_card .card_inner .preview_group_info .preview_group_title2{width:100%;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;word-wrap:normal;padding-right:0;display:block}.preview_group.preview_card .card_inner .preview_group_info .preview_group_desc{padding-right:0}.preview_group.preview_card .card_inner .preview_group_info.append_btn .preview_group_desc,.preview_group.preview_card .card_inner .preview_group_info.append_btn .preview_group_title{padding-right:68px;width:auto}.preview_group.obvious_app{width:100%}.preview_group.obvious_app .preview_group_inner{padding:0}.preview_group.obvious_app .pic_app{width:58.3%;height:100%;display:inline-block;margin-right:2%;vertical-align:top}.preview_group.obvious_app .pic_app img{width:100%;vertical-align:top;margin-top:0}.preview_group.obvious_app .info_app{display:inline-block;width:38%;color:#8a8a8a;font-size:12px;box-sizing:border-box;-webkit-box-sizing:border-box;position:absolute;left:62%;top:0;height:100%}.preview_group.obvious_app .info_app .name_app{color:#000;font-size:16px;width:95%;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;word-wrap:normal;margin-top:4%}.preview_group.obvious_app .info_app .profile_app{line-height:12px}.preview_group.obvious_app .info_app .profile_app span{line-height:16px}.preview_group.obvious_app .info_app .profile_app em{font-size:9px;line-height:16px;margin:0 5px;font-weight:400;font-style:normal;color:#dfdfdf}.preview_group.obvious_app .info_app .dm_app{line-height:20px;vertical-align:middle;position:absolute;left:0;bottom:5%}.preview_group.obvious_app .info_app .dm_app p{line-height:12px}.preview_group.obvious_app .info_app .dm_app .ad_btn{display:block;color:#04be02;font-size:15px;padding-left:22px}.preview_group.obvious_app .info_app .dm_app .ad_btn.btn_download{background:transparent url(http://res.wx.qq.com/mmbizwap/zh_CN/htmledition/images/ad/icon58_download@3x.png) no-repeat 0 0;-webkit-background-size:19px 19px;background-size:19px 19px}.preview_group.obvious_app .info_app .dm_app .ad_btn.btn_install{background:transparent url(http://res.wx.qq.com/mmbizwap/zh_CN/htmledition/images/ad/icon58_install@3x.png) no-repeat 0 0;-webkit-background-size:19px 19px;background-size:19px 19px}.preview_group.obvious_app .info_app .dm_app .ad_btn.btn_installed{background:transparent url(http://res.wx.qq.com/mmbizwap/zh_CN/htmledition/images/ad/icon58_installed@3x.png) no-repeat 0 0;-webkit-background-size:19px 19px;background-size:19px 19px;color:#8a8a8a}.preview_group.obvious_app .info_app .dm_app .ad_btn.btn_open{background:transparent url(http://res.wx.qq.com/mmbizwap/zh_CN/htmledition/images/ad/icon58_open@3x.png) no-repeat 0 0;-webkit-background-size:19px 19px;background-size:19px 19px}.preview_group.obvious_app .info_app .dm_app .extra_info{font-size:9px}@media screen and (max-width:1023px){.qr_code_pc_outer{display:none!important}}@media screen and (min-width:1024px){.rich_media{width:740px;margin-left:auto;margin-right:auto}.rich_media_inner{padding:20px}.rich_media_meta{max-width:none}a.rich_media_meta_nickname{display:block!important}span.rich_media_meta_nickname{display:none!important}.rich_media_content{min-height:350px}.rich_media_title{padding-bottom:10px;margin-bottom:14px;border-bottom:1px solid #e7e7eb}body{background-color:#fff}.discuss_container.access{width:740px;margin-left:auto;margin-right:auto;background-color:#fff}.discuss_container.editing .frm_textarea_box{margin:0}.frm_textarea_box{position:relative}.frm_textarea_box:before{content:\" \";position:absolute;left:0;top:0;width:1px;height:100%;border-left:1px solid #e7e6e4;-webkit-transform-origin:0 0;transform-origin:0 0;-webkit-transform:scaleX(0.5);transform:scaleX(0.5)}.frm_textarea_box:after{content:\" \";position:absolute;left:0;top:0;width:1px;height:100%;border-left:1px solid #e7e6e4;-webkit-transform-origin:0 0;transform-origin:0 0;-webkit-transform:scaleX(0.5);transform:scaleX(0.5);left:auto;right:-2px}.rich_media_meta.nickname{max-width:none}.rich_tips.with_line .tips{background-color:#fff}}@media screen //and (min-width:1025px){.rich_media_inner{border:1px solid #d9dadc;border-top-width:0}body{background-color:#e7e8eb;font-family:\"Helvetica Neue\",Helvetica,\"Hiragino Sans GB\",\"Microsoft YaHei\",\"?￠èí??oú\",Arial,sans-serif}.rich_media{position:relative}.rich_media_inner{background-color:#fff;padding-bottom:100px}.rich_media_inner{position:relative}.qr_code_pc_outer{display:block!important;position:fixed;left:0;right:0;top:20px;color:#717375;text-align:center}.qr_code_pc_inner{position:relative;width:740px;margin-left:auto;margin-right:auto}.qr_code_pc{position:absolute;right:-145px;top:0;padding:16px;border:1px solid #d9dadc;background-color:#fff}.qr_code_pc p{font-size:14px;line-height:20px}.qr_code_pc_img{width:102px;height:102px}}");
		

		sb.append("A { TEXT-DECORATION: none}\n");
		sb.append("A:link { TEXT-DECORATION: none}\n");
		sb.append("A:visited { TEXT-DECORATION: none}\n");
		sb.append("A:hover { TEXT-DECORATION: none}\n");
		sb.append("TD {FONT-SIZE: 10.5pt;FONT-FAMILY: ;}\n");//background-size:100% 100%;
		//sb.append("html,body{ margin:0px; height:100%;} \n");
		sb.append("BODY {FONT-SIZE: 10.5pt;FONT-FAMILY: \"Microsoft YaHei\",\"微软雅黑\" !important;height:100%; text-align:center;");
		if(ds.get(0,"FKVALIGN")=="MIDDLE"||ds.get(0,"FKHEIGHT")=="100%"||ds.get(0,"BKIMGTYP")=="FULLSCREEN"){// 如果需要居中对齐，html和body的100高度都是不可缺的
			sb.append("height:100%;}\n");//
			sb.append("HTML {height:100%;}\n");
		}
		else sb.append("}\n");
		sb.append("</style>\n");
		sb.append("</head>");
		if(ds.get(0,"JSGUID")!="")
			sb.append( "<script src='EAFormBlob.sp?guid="+ds.get(0,"JSGUID")+"'></script>");
	
	}
	// 得到基本的html head,L.sp?grdid=xxx 使用到
	function getbasehtmlhead(sb,sytid,grdid,m_usrinfo,lang)
	{
		
		var m_mwXmlDB = new xmlpack.EAGRDXmlDB(sytid,grdid);
		var m_mwds = m_mwXmlDB.getGrdDS();
		var title = m_mwds.getStringAt(0,"NAME");
		sb.append("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html  xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>"+
			title+"</title><meta http-equiv=\"Content-Type\" content=\"text/html; charset="+lang+"\"/>"+//UTF-8
			//"<script language=\"javascript\" src=\"xlsgrid/js/_this.js\"></script>\n"+
			"<script language=\"javascript\" src=\"xlsgrid/js/x/_this.djs\"></script>\n"+
			//"<script type=\"text/javascript\" src=\"xlsgrid/js/"+sytid+"/"+grdid+".djs\"></script>\n"+ 不再使用 djs 直接放到html正文里面
			"<script language=\"javascript\" src=\"xlsgrid/js/wnd.js\"></script>\n"+
			"<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery-1.7.2.min.js\"></script>\n"+
			"<script type=\"text/javascript\" src=\"xlsgrid/js/highcharts.js\"></script>\n"+
			"<script language=\"javascript\" src=\"xlsgrid/js/exporting.js\"></script>\n"+
			"<script type=\"text/javascript\" src=\"xlsgrid/js/highcharts-3d.js\"></script>\n"+
			"<link href=\"xlsgrid/images/flash/css/bootstrap.min.css\" rel=\"stylesheet\" type=\"text/css\" /><link href=\"xlsgrid/images/flash/css/jquery-ui-1.10.0.custom.css\" rel=\"stylesheet\" type=\"text/css\" />");
		sb.append("<meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,minimum-scale=0.5,maximum-scale=3.0,user-scalable=yes\" /> ");
		sb.append("");
		sb.append("\n<script>\n");
		sb.append("function f_onload(){ \n");
		sb.append(" try { _thisOnpost_loaddata(0); } catch(e){}\n");
		sb.append("}\n</script>"); 
		/// JS 公共变量
		    sb.append("\n<script language='javascript'>");
		    //向后兼容
		    sb.append( "\nvar accid = '"+m_usrinfo.getAccid()+"';");
		    sb.append( "\nvar loginacc = '"+m_usrinfo.getAccid()+"';");
		    sb.append( "\nvar sytid = '"+m_usrinfo.getSytid().trim()+"';");
		    sb.append( "\nvar orgid = '"+m_usrinfo.getOrgid().trim()+"';");
		    sb.append( "\nvar usrid = '"+m_usrinfo.getUsrid().trim()+"';");
		    sb.append( "\nvar usrnam = '"+m_usrinfo.getUsrnam().trim()+"';");
		    sb.append( "\nvar logdat = '"+m_usrinfo.getLogdat().trim()+"';");
		    sb.append( "\nvar grdid = '"+grdid+"' ; ");
//		    sb.append( "\nvar grdtyp ='"+m_mwtyp+"';");
//		    sb.append( "\nvar homeurl = '"+homeUrl+"'"); 
	
		    sb.append( "\nvar locid='"+m_usrinfo.getLocid()+"'");
		    //以下是全程变量，可在脚本中直接使用。
		    sb.append( "\nvar G_DEPTID = '"+m_usrinfo.getDeptId()+"';");
		    sb.append( "\nvar G_DEPTNAM = '"+m_usrinfo.getDeptNam()+"';");
		    sb.append( "\nvar G_PRJID = '"+m_usrinfo.getPrjid()+"';");
		    sb.append( "\nvar G_NLS = '"+m_usrinfo.getNls()+"';");
		    sb.append( "\nvar G_USRLOC = '"+m_usrinfo.getOwnloc()+"';");
		    sb.append( "\nvar G_LOGINACC = loginacc;");
		    sb.append( "\nvar G_ACCID = accid;");
		    sb.append( "\nvar G_ACCNAM = '"+m_usrinfo.getAccnam()+"';");
		    sb.append( "\nvar G_SYTID = sytid;");
		    sb.append( "\nvar G_SYTNAM = '"+m_usrinfo.getSytnam()+"';");
		    sb.append( "\nvar G_ORGID = orgid;");
		    sb.append( "\nvar G_ORGNAM = '"+m_usrinfo.getOrgnam()+"';");
		    sb.append( "\nvar G_USRID = usrid;");
		    sb.append( "\nvar G_USRNAM = usrnam;");
		    sb.append( "\nvar G_LOGDAT = logdat;");
		    sb.append( "\nvar G_GRDID = grdid; ");
//		    sb.append( "\nvar G_GRDTYP =grdtyp;");
//		    sb.append( "\nvar G_HOMEURL = homeurl;"); 
		    sb.append( "\nvar G_LOCID = locid;"); 

		    var map = request.getParameterMap();
			var keys = map.keySet().iterator(); 
			while(	keys.hasNext() ){
				var _varNam = ""+keys.next();
	          		var ss = map.get(_varNam);
	          		sb.append( "\n var "+_varNam+ "=\"" +ss[0]+ "\"; " );

			}

		    _gethtmljs(sb);
		    sb.append("
			var G_BROWSETYPE='';
			
			//********************************************
			//*****修改时间2017-04-25 优化标题加载速度慢问题
			//*******************************************
			var kdocTitle='';
			$(function(){
				kdocTitle = document.title;//标题 
				if(kdocTitle == null){ 
				    var t_titles = document.getElementByTagName('title') 
				    if(t_titles && t_titles.length >0) 
				    { 
				       kdocTitle = t_titles[0]; 
				    }else{ 
				       kdocTitle = ''; 
				    } 
				} 							
				try{parent.f_childwndready(kdocTitle );}catch(e){}
			})
			
			function f_body_onload(){
				// 判断浏览器版本
				var browser = {
					versions: function() {
						var u = navigator.userAgent, app = navigator.appVersion;
						return {//移动终端浏览器版本信息 
						trident: u.indexOf('Trident') > -1, //IE内核
						presto: u.indexOf('Presto') > -1, //opera内核
						webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
						gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, //火狐内核
						mobile: !!u.match(/AppleWebKit.*Mobile.*/) || !!u.match(/AppleWebKit/), //是否为移动终端
						ios: !!u.match(/\\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
						android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或者uc浏览器
						iPhone: u.indexOf('iPhone') > -1 || u.indexOf('Mac') > -1, //是否为iPhone或者QQHD浏览器
						iPad: u.indexOf('iPad') > -1, //是否iPad
						webApp: u.indexOf('Safari') == -1 //是否web应该程序，没有头部与底部
					};
				}(),
				language: (navigator.browserLanguage || navigator.language).toLowerCase()
				}
				 
				if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad) {
					G_BROWSETYPE='IOS';
				}
				else if (browser.versions.android) {
					G_BROWSETYPE='ANDROID';
				}

//				var kdocTitle = document.title;//标题 
//				if(kdocTitle == null){ 
//				    var t_titles = document.getElementByTagName('title') 
//				    if(t_titles && t_titles.length >0) 
//				    { 
//				       kdocTitle = t_titles[0]; 
//				    }else{ 
//				       kdocTitle = ''; 
//				    } 
//				} 							
//				try{parent.f_childwndready(kdocTitle );}catch(e){}
				try{f_onload();}catch(e){}
				try{
					document.addEventListener(\"deviceready\", onDeviceReady, false);
				}
				catch(e){
				}
				try{
					f_uploadapp();
				}
				catch(e){
				}

			}
			
			
			// 公共的设备ready调用函数
			function onDeviceReady() {
				try{ f_deviceready() ;}
				catch(e){
					document.addEventListener('backbutton', function (){
						try{parent.f_goback();}catch(ee){try{f_goback();}catch(eee){}}
						return 1;
					});
				}

//					console.log(navigator.notification);
//				    	window.alert = navigator.notification.alert;
//					window.confirm = navigator.notification.confirm;
//					window.prompt = navigator.notification.prompt;
			}
			
			var bAppendAudio = false
			function alertaudio(src)
			{
				if(bAppendAudio == false) {
					$(document.body).append(\"<audio id='myAlertAudio' src='\"+src+\"' hidden='true' />\");
					bAppendAudio = true;
				}
				document.all('myAlertAudio').src=src;	
				document.all('myAlertAudio').play();		
			}
			function closewindow(){
				window.close();
			}

			
			
//			var pictureSource;  //设定图片来源  
//    			var destinationType; //选择返回数据的格式
//			document.addEventListener(\"deviceready\", onDeviceReady, false);
//			function onDeviceReady() {
//				pictureSource=navigator.camera.PictureSourceType;  
//        			destinationType=navigator.camera.DestinationType;  
//
//				console.log(navigator.notification);
//			    	window.alert = navigator.notification.alert;
//				window.confirm = navigator.notification.confirm;
//				window.prompt = navigator.notification.prompt;
//			}

		   ");

		   
		    sb.append("\n</script>");
		    
		    //done: 加载附加的js
		    //var extjs = m_mwds.getStringDef(0,EAMidWareUtil.GRD_EXTJS,"").split(",");
		    //for(var i=0;i<extjs.length;i++)
		    //{
		    // if (extjs[i].length()>0)
		    //    sb.append("\n<script language='javascript' src='"+extjs[i]+"' ></Script>");
		    //}		
		sb.append("<style type='text/css'>\n");
		sb.append("A { TEXT-DECORATION: none}\n");
		sb.append("A:link { TEXT-DECORATION: none}\n");
		sb.append("A:visited { TEXT-DECORATION: none}\n");
		sb.append("A:hover { TEXT-DECORATION: none}\n");
		sb.append("TD {FONT-SIZE: 10.5pt;FONT-FAMILY: \"Microsoft YaHei\",\"微软雅黑\" !important;}\n");//background-size:100% 100%;
		sb.append("BODY {FONT-SIZE: 10.5pt;FONT-FAMILY: \"Microsoft YaHei\",\"微软雅黑\" !important;height:100%; text-align:center;");
		sb.append("}\n");
		sb.append("</style>\n");
		sb.append("</head>");
//		if(ds.get(0,"JSGUID")!="")
//			sb.append( "<script src='EAFormBlob.sp?guid="+ds.get(0,"JSGUID")+"'></script>");
	
	}

	//递归，获取树形的DIV结构
	function f_getdivtree(db,request,sb,sxgds,dflg,aflg,wflg,sColW,sRowH,CELLPADDING,r1,c1,r2,c2,loopnum,layoutid,menuid,lang)
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
			f_getdivtree(db,request,sb,sxgds,dflg,aflg,wflg,sColW,sRowH,CELLPADDING,r1,c1,1*ss[0],1*ss[1],loopnum,layoutid,menuid,lang);
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
			f_getdivtree(db,request,sb,sxgds,dflg,aflg,wflg,sColW,sRowH,CELLPADDING,1*ss[2],1*ss[3],r2,c2,loopnum,layoutid,menuid,lang);
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

			var str = sxgds.GetCellText(r1,c1);
			GetLayoutItem(db,request,sb,str,r1,c1,0,menuid,"",lang);
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
	// layflg DIV.TABLE...
	function GetLayoutItem(db,request,sb,str,r,c,dHeight,menuid,layflg,lang)
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
		var overflow_x="";var overflow_y="";var fontcolor="";var fontsize="";var margin_t="";var margin_r="";var margin_l="";var margin_b="";var lodtyp="";

			while((idx=str.indexOf("='",idx+1))>0){
				var attrid = str.substring(oldidx,idx);
				if(attrid.substring(0,1)==" ")attrid=attrid.substring(1);
				oldidx=	str.indexOf("' ",idx+1)+2;
				if(oldidx-2<idx+2) oldidx=	str.indexOf("' ",idx+2)+2;

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
				else if(attrid=="fontsize")fontsize=attrval;if(fontsize=="")fontsize="3";
				else if(attrid=="lodtyp")lodtyp=attrval;
				else if(attrid=="overflow-x")overflow_x=attrval;	
				else if(attrid=="overflow-y")overflow_y=attrval;			
				
			}
		
		
		var marginpx = ifnull(margin_t,"0")+"px "+ifnull(margin_r,"0")+"px "+ifnull(margin_b,"0")+"px "+ifnull(margin_l,"0")+"px ";//外边距
	
		if(cellspace=="" ) cellspace="0";
		if(deforg!="" && ctrlid!="" ) {
			
			
			var sURLHTML=  "";
			if(url!=""){
//				url=pub.EAFunc.Replace(url,"#$amp;","&");
//				url=web.EASession.GetSysValue(url,request);//替换request 中[%id]
//				url=web.EASession.GetSysValue(url,web.EASession.GetLoginInfo(request));
				var sClick ="";
				if ( target == "" || target=="_self"  ) //||targetLayoutid.length()!=0
			          sClick="javascript:window.location='"+url+"';";
			        else if ( target=="_blank" ) 
			          sClick="javascript:openWindow('"+url+"');";
			        else if ( target!="_self" ) 
			          sClick="javascript:frames['"+target+"'].location='"+url+"';";
			          
				sURLHTML=" onclick=\""+sClick+"\" onmouseover=\"this.style.cursor='hand';\""; 
			}
			if(ctrlid=="IMAGE"){
				//[%IMAGE deforg='XLSGRID' ctrltype='obj' ctrlid='IMAGE' id='IMAGE-1' src='xlsgrid/images/flash/icon/icon_171.png' value='图片'  width='' height='' border='0' background='' ]
				if(src!=""){
					var imghtml = "<img src='"+src+"' style=\"width:"+width+";height:"+height+";\">";
					sb.append(imghtml);
				}
				//sb.append("<table  border=0 width=100% height=100% cellspacing=\""+cellspace+"\"  cellpadding=\"0\"  ><tr><td>"+imghtml+"</td></tr></table>" );
			}
			else if(ctrlid=="WP8ICON"){
				var imghtml = "<img src='"+src +"' style=\"width:"+width+";height:"+height+";min-width:60px;max-width:240px;min-height:60px;max-height:240px;\">";
				if ( src =="" ) imghtml = "&nbsp;";
			
				var sStyle="";
				if(margin_t!="")
					sStyle += "margin-top:"+margin_t+";";
				if(margin_r!="")
					sStyle += "margin-right:"+margin_r+";";
				if(margin_b!="")
					sStyle += "margin-bottom:"+margin_b+";";
				if(margin_l!="")
					sStyle += "margin-left:"+margin_l+";";

				sb.append("<table border=0 width=100% height=100% cellspacing=\""+cellspace+"\" style=\"background:"+bkcolor+";"+sStyle +"\" cellpadding=\"0\"  ><tr ><td>"+imghtml+"<br><font color="+ifnull(fontcolor,"#FFFFFF")+" size=\""+ifnull(fontsize,"3")+"\">"+val+"</font></td></tr></table>" );
	
			}
			else if(ctrlid=="ICONTEXT"){//图文混排
				var imghtml = "<img  src='"+src +"' border="+ifnull(border,"0")+" "+ifnotnull(width,"width="+width)+" "+ifnotnull(height,"height="+height)+" >";
				if(src!="" &&  src.substring(0,1)=="<")
					imghtml ="<font size=\""+fontsize*4+"\" color=\""+ifnull(fontcolor,"#FFFFFF")+"\">"+src+"</font>";
				else if(src.length()>=9 &&  src.substring(0,9)=="glyphicon"){
					imghtml = "<BR><font size=\""+fontsize*4+"\" color=\""+ifnull(fontcolor,"#FFFFFF")+"\"><span class=\""+src+"\"></span></font>";
				}

				
				if ( src =="" ) imghtml = "&nbsp;";
				
				var sStyle = "style=\"";
				
				if(background!="")
					sStyle += "background-image: url('"+background+"'); background-repeat: repeat-x;";
				if(margin_t!="")
					sStyle += "margin-top:"+margin_t+";";
				if(margin_r!="")
					sStyle += "margin-right:"+margin_r+";";
				if(margin_b!="")
					sStyle += "margin-bottom:"+margin_b+";";
				if(margin_l!="")
					sStyle += "margin-left:"+margin_l+";";
				sStyle += "\"";
				sb.append("<table border=0 width=100% height=100% cellspacing=\""+cellspace+"\"  cellpadding=\"0\"  ><tr ><td "+sStyle+" bgcolor=\""+bkcolor+"\" align="+ifnull(align,"center")+" valign="+ifnull(valign,"middle")+sURLHTML+">");
				sb.append("<div style=\"overflow:hidden; \"><div style=\"float:left;\" >"+imghtml+"<br></div><div style=\"float:left;width:48%;margin-top:15px;\"><font style=\"border-bottom:1px dashed #666666;\" size=\""+ifnull(fontsize,"2")+"\" color=\""+ifnull(fontcolor,"#FFFFFF")+"\" >"+val+"</font></br><font  size=\""+ifnull(fontsize,"3")+"\" color=\""+ifnull(fontcolor,"#FFFFFF")+"\" >"+text+"</font></div></td></tr></table>" );
	
			}
			
			else if(ctrlid=="TEXT"){		
				//[%IMAGE deforg='XLSGRID' ctrltype='obj' ctrlid='IMAGE' id='IMAGE-1' src='xlsgrid/images/flash/icon/icon_171.png' value='图片'  width='' height='' border='0' background='' ]
				sb.append("<table><tr><td><font>"+text+"</font></td></tr></table>" );
			}
			else if(ctrlid=="HTML"){
				//[%IMAGE deforg='XLSGRID' ctrltype='obj' ctrlid='IMAGE' id='IMAGE-1' src='xlsgrid/images/flash/icon/icon_171.png' value='图片'  width='' height='' border='0' background='' ]
				if(html!="" ){
					sb.append(db.getBlob2String("select bdata from formblob where guid='"+html+"'","bdata"));
					//sb.append("<table border=0 width=100% height=100% cellspacing=\"0\"  cellpadding=\"0\"><tr><td align=left valign=right >"+db.getBlob2String("select bdata from formblob where guid='"+html+"' ","bdata")+"</td></tr></table>" );//for update
				}
			}else if(ctrlid=="ITEM"){//商品展示
				//sb.append("<table width=100% height=120 cellpadding=0 cellspacing=0><tr><td style=\"background:url('"+src+"') no-repeat; background-size:cover; \"><table width=100% height=100% cellpadding=0 cellspacing=0><tr height=70%><td>&nbsp;</td><tr height=30%><td align=center style=\"background-color: rgba(66,66,66,0.5)\"  ><font color=#FFFFFF>"+val+"</font></td></table></td></tr></table>");
				var imghtml = "";//"<img   src='"+src+"' style=\"width:"+ifnull(width,"100%")+";height:"+ifnull(width,"auto")+";\">";
				var bkstyle = "background-image: url("+src+");";
				if(src!="" &&  src.substring(0,1)=="<") {
					imghtml ="<font size=\""+fontsize*4+"\" color=\""+ifnull(fontcolor,"#FFFFFF")+"\">"+src+"</font>";
					bkstyle  = "background-image: url(xlsgrid/images/flash/images/nvlimg120.png);";

				}
				else if(src.length()>=2 &&  src.substring(0,2)=="&#") {
					imghtml = "<span style=\"font-size:70px;\" class=\"iconfont\"><font size=\""+fontsize*5+"\" color=\""+ifnull(fontcolor,"#FFFFFF")+"\">"+src+"</font></span>";
					bkstyle  = "background-image: url(xlsgrid/images/flash/images/nvlimg120.png);";

				}
				else if(src.length()>=9 &&  src.substring(0,9)=="glyphicon"){
					imghtml = "<font size=\""+fontsize*4+"\" color=\""+ifnull(fontcolor,"#FFFFFF")+"\"><span class=\""+src+"\"></span></font>";
					bkstyle  = "background-image: url(xlsgrid/images/flash/images/nvlimg120.png);";

				}

				if ( imghtml =="" ) imghtml = "&nbsp;";

				//var divHeight="style=\"position:relative;display:block;";
				//divHeight +="\"";
//				sb.append("<table><tr ><td>");
//				sb.append("<div "+divHeight +" >"+imghtml+"<div style=\"position:absolute;bottom:0;left:0;color:#fff;-moz-opacity: 1; opacity: 1; filter: alpha(opacity=50);background: rgba(255, 255, 255, 0.5) !important; width:100%;height=20\" align=\"center\"><font style=\"position:relative; \" >"+val+"</font></div></div></td></tr></table>" );
//				sb.append("");
//				sb.append("<div "+divHeight +" ><table ><tr ><td align=center valign=middle>"+imghtml+"</td></tr></table><div style=\"position:absolute;bottom:0;left:0;color:#fff;-moz-opacity: 1; opacity: 1; filter: alpha(opacity=50);background: rgba(66, 66, 66, 0.5) !important; width:100%;\" align=\"center\"><font style=\"position:relative; \" size=\"3\" >"+val+"</font></div></div>" );

				//sb.append("");
				//sb.append("<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom>"+imghtml+"</td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\""+fontsize+"\" color=\""+ifnull(fontcolor,"#FFFFFF")+"\">"+val+"</font></td></tr></table>" );

		
	//sb.append("<div style=\"position:relative;width:100%;height:100%;align:center;\">"+imghtml+"<div style=\"position:absolute; top:100px; left:0px;height:30px; z-index:2;width:100%;background-color:#000;filter: alpha(opacity=50); opacity:0.5; \"><font size=\""+fontsize+"\" color=\""+ifnull(fontcolor,"#FFFFFF")+"\">"+val+"</font></div>");
	//sb.append("<table width=100% heigth=auto  cellspacing=\"0\" cellpadding=\"0\"><tr><td align=center valign=middle style=\"position:relative;width:100%;height:auto;align:center;\">"+imghtml+"<div style=\"position:absolute; margin-top: -30px;padding-top:3px;padding-bottom:3px; height:30px; z-index:2;width:100%;background-color:#000;filter: alpha(opacity=50); opacity:0.5; \"><font size=\""+fontsize+"\" color=\""+ifnull(fontcolor,"#FFFFFF")+"\">"+val+"</font></div></td></tr></table>");
//sb.append(imghtml+"<div style=\"position:absolute; margin-top: -30px;padding-top:3px;padding-bottom:3px; height:30px; z-index:2;width:100%;background-color:#000;filter: alpha(opacity=50); opacity:0.5;align:center; \"><font size=\""+fontsize+"\" color=\""+ifnull(fontcolor,"#FFFFFF")+"\">"+val+"</font></div>");
				sb.append("<table cellpadding=0 cellspacing=0 height=100% width=100% style=\"cursor:pointer;"+bkstyle+"background-repeat:no-repeat;background-position: center;\"><tr height=80%><td align=center valign=middle >"+imghtml +"</td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\""+fontsize+"\" color=\""+ifnull(fontcolor,"#FFFFFF")+"\">"+val+"</font></td></tr></table>" );




			}
			else {
				
				
				
				if(ctrltype=="pag"){
					GetLayoutHTML(db,request,sb,deforg,ctrlid,0,menuid,layflg,lang);
				}
				else {
					
				
					//sb.append("select * from layobj where deforg='"+deforg+"' and id='"+ctrlid+"'");
					var ds = db.QuerySQL("select * from layobj where deforg='"+deforg+"' and id='"+ctrlid+"'");
					//throw new Exception ( "select * from layobj where deforg='"+deforg+"' and id='"+ctrlid+"'");
					if(ds.getRowCount()>0){
						var htmlds = db.QuerySQL("select NAME,GUID,OSSYT,OSMWID,OSFUNC,CSSFILE,JSFILE from LHTML where id='"+ds.get(0,"WNDMOD")+"'");
						var CSSFILE="";
						var JSFILE="";
						var showflgid=ds.get(0,"WNDMOD");
						var lhtmlname=ds.get(0,"NAME");

						if(htmlds.getRowCount()>0){
							CSSFILE= htmlds.getStringAt(0,"CSSFILE");
							JSFILE= htmlds.getStringAt(0,"JSFILE");
						} 
						if(CSSFILE!="")
						sb.append("<link rel=\"stylesheet\" type=\"text/css\" href=\""+CSSFILE+"\">   \n");
						if(JSFILE!="")
						sb.append("<script type=\"text/javascript\" src=\""+JSFILE+"\"></script>\n");
						
						
						if(lodtyp=="2"||lodtyp=="3"){
							var url="";
							sb.append("<div id=\""+ctrlid+"_"+r+"_"+c+"\"><img src='xlsgrid/images/spinner.gif' style=\"margin-top:30px;\"></div>");
							
							
							url ="'+G_WEBBASE+'/rcall.jsp?deforg="+deforg+"&menuid="+menuid+"&crtlid="+ctrlid;
							sb.append("<script>function f_load_"+ctrlid+"_"+r+"_"+c+"() { 
								//导出html程序会把&CLIENTPARAM=[%CLIENTPARAM]替代为客户端参数
								$.get('"+url+"'+G_CLIENTPARAM+'&usrid='+G_APP_USRID+'&userpwd='+G_APP_USERPWD,function(data,status){
									// 替代所有的地址和路径
									data=replaceimgall(data);
									data=replacehrefall(data,'id');
									data=replacehrefall(data,'grdid');	
									document.getElementById(\""+ctrlid+"_"+r+"_"+c+"\").innerHTML=data;
									try{
										f_postload_"+showflgid+"('"+r+"','"+c+"');
									}catch(e){
										
									}
								}); 
							}</script>");
							if(lodtyp==2){
								sb.append("<script>setTimeout('f_load_"+ctrlid+"_"+r+"_"+c+"()',10);</script>");

							}
							if(lodtyp==3){
								
							}
							

							
						}
						else{
							var titlemode = ds.getStringAt(0,"TITLEMODE");
							var titlehtml = ds.getStringAt(0,"TITLEHTML");
							var str = GetBody(db,request,deforg,ds.get(0,"WNDMOD"),ds.get(0,"DSMOD"),ds.get(0,"WHEREBY"),ds.get(0,"SORTBY"),ds.get(0,"SQLTXT"),ds.get(0,"LAYCOL"),ds.get(0,"LAYROW"),ds.get(0,"PAGEROW"),ds.get(0,"OSMWID"),ds.get(0,"OSFUNC"),ds.get(0,"OSPARAM"),ds.get(0,"IFRAMEURL"),ds.get(0,"IFSCROLLBAR"),ds.get(0,"HTMLGUID"),ds.get(0,"MOREURL"),ds.get(0,"OPENLAYID"),ds.get(0,"ID"),menuid );
							// 2015增加一个自定义窗口风格的方法
							if(titlemode =="HTML"&&titlehtml!="") {
								var titlehtml = db.getBlob2String("select bdata from formblob where guid='"+titlehtml +"'","bdata");// for update
								titlehtml  = pub.EAFunc.Replace(titlehtml ,"[%BODY]",str );
								titlehtml  = pub.EAFunc.Replace(titlehtml ,"[%TITLE]",lhtmlname);

								sb.append(titlehtml );
							}
							else 
								sb.append(str);
							
						}
					}
					else {
						sb.append("data not found: deforg='"+deforg+"' and id='"+ctrlid+"'");
					}
				}
			}
			
		
		}
		
	}
	
	//重写调用组件方法
	function getcellitem(){
		//在某域名下使用Ajax向另一个域名下的页面请求数据，会遇到跨域问题。另一个域名必须在response中添加 Access-Control-Allow-Origin 的header，才能让前者成功拿到数据。
		response.setHeader("Access-Control-Allow-Origin","*");

		var deforg= pubpack.EAFunc.NVL( request.getParameter("deforg"),"") ;
		var ctrlid= pubpack.EAFunc.NVL( request.getParameter("crtlid"),"") ;
		var menuid= pubpack.EAFunc.NVL( request.getParameter("menuid"),"") ;
		var db = null;
		db = new pubpack.EADatabase();
		var ds = db.QuerySQL("select * from layobj where deforg='"+deforg+"' and id='"+crtlid+"'");
		if(ds.getRowCount()>0){
			return GetBody(db,request,deforg,ds.get(0,"WNDMOD"),ds.get(0,"DSMOD"),ds.get(0,"WHEREBY"),ds.get(0,"SORTBY"),ds.get(0,"SQLTXT"),ds.get(0,"LAYCOL"),ds.get(0,"LAYROW"),ds.get(0,"PAGEROW"),ds.get(0,"OSMWID"),ds.get(0,"OSFUNC"),ds.get(0,"OSPARAM"),ds.get(0,"IFRAMEURL"),ds.get(0,"IFSCROLLBAR"),ds.get(0,"HTMLGUID"),ds.get(0,"MOREURL"),ds.get(0,"OPENLAYID"),ds.get(0,"ID"),menuid );
		}			
	}

	//WNDMOD 窗口风格, DSMOD 数据来源 ,WHEREBY 条件, SORTBY 排序,SQLTXT  SQL语句, LAYCOL 分列数 ,LAYROW 分行数,PAGEROW 每页行记录数, OSMWID OS中间件, OSFUNC OS函数,OSPARAM OS函数的参数,IFRAMEURL IFRAME的URL,IFSCROLLBAR 是否显示滚动条,HTMLGUID HTML
	// ,MOREURL  更多按钮,OPENLAYID  点击列表打开的布局：
	function GetBody(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,PAGEROW ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID,CTRLID,menuid)
	{
		
		//在服务端OS中引用其他中间件的服务端脚本
		//说明：x_SQLINPUT是指x系统SQLINPUT中间件
	//	if(WNDMOD=="TITLELIST"){
			var ds = db.QuerySQL("select GUID,OSSYT,OSMWID,OSFUNC,CSSFILE,JSFILE from LHTML where id='"+WNDMOD+"'");
			
			if(ds.getRowCount()>0){
				var OSSYT1 = ds.getStringAt(0,"OSSYT");
				var OSMWID1 = ds.getStringAt(0,"OSMWID");
				var OSFUNC1 = ds.getStringAt(0,"OSFUNC");
				var GUID = ds.getStringAt(0,"GUID");
				var CSSFILE= ds.getStringAt(0,"CSSFILE");
				var JSFILE= ds.getStringAt(0,"JSFILE"); 
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
					eas.DefineScopeVar("menuid", menuid);
					eas.DefineScopeVar("CTRLID", CTRLID);
					
					
					var dsdtl = db.QuerySQL("select ID from LHTMLDTL where FORMGUID='"+GUID+"'");
					for(var i = 0;i<dsdtl.getRowCount();i++){
						var lhtid=dsdtl.getStringAt(i,"ID");
						var layvalue="";
						try{ layvalue=db.GetSQL("select b.val from LAYOBJ a,LAYOBJDTL b where a.guid=b.formguid and a.id='"+CTRLID+"' and b.id='"+lhtid+"'");}catch(e){}
						eas.DefineScopeVar(lhtid,layvalue);
					} 
					

					var ret =  eas.CallClassFunc(""+OSSYT1 +"_"+OSMWID1+"",""+OSFUNC1+"",null).castToString();
					return ret; 
				}catch(e){
					throw new Exception(""+OSSYT1 +"_"+OSMWID1+OSFUNC1+""+e.toString());
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
	// 检查是否存在 confirm
	function SaveASCheck()
	{
		var db = null;
		var guid = "0";
		try {
			db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			var sql ="select count(*) from  LAYHDR where id='"+id+"' and deforg='"+deforg+"'";
			var ds =db.QuerySQL(sql);
			return ds.getRowCount();


		}
		catch ( ee ) {
			
			throw new pubpack.EAException ( ee.toString() );
		}
		finally {
			if (db!=null) db.Close();
		}
		return guid ;
	}
	// 检查是否存在 confirm
	function SaveASDelete()
	{
		var db = null;
		var guid = "0";
		try {
			db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			var sql ="delete from  LAYHDR where id='"+id+"' and deforg='"+deforg+"'";
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