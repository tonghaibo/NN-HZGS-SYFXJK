function x_showflg_mw(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var pub = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" );
var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var langpack = new JavaPackage ( "java.lang" );
var servletpack = new JavaPackage ( "com.xlsgrid.net.servlet");
//================================================================// 
// ������GetBody
// ˵����ʵ������show.sp�Ĺ���
// ������MWID���м����ţ� VAL(�����б� guid=131241&bilid=12131&)
// ���أ�
// ������fGetBodygetColu
// ���ߣ�
// �������ڣ�01/28/15 17:58:16
// �޸���־��
//================================================================// 
var ones = "0";
function GetBody(){
	
//	throw new Exception("hello��kettle��"); 
	var db = null;
	try{
		db = new pubpack.EADatabase();
	
		var html = "";
		var sql = "";
		var m_usrinfo = webpack.EASession.GetLoginInfo(request);
		var processid =  pubpack.EAFunc.NVL(request.getParameter("processid"),"");
	
		var actionid =  pubpack.EAFunc.NVL(request.getParameter("actionid"),"");
	
		var workflowmwid =  pubpack.EAFunc.NVL(request.getParameter("workflowmwid"),"");// 
	
		var action = pubpack.EAFunc.NVL(request.getParameter("action"),"");
		var bLock = "0";
		if(action=="query")bLock = "1";
		else if(processid!="")bLock="1";
		
		var fixscreenwidth = pubpack.EAFunc.NVL(request.getParameter("fixscreenwidth"),"1");
	
		if(sytid == null || sytid=="" )sytid= m_usrinfo.getSytid();
		var m_accid = m_usrinfo.getAccid();
		var accdb = new xmlpack.EAACCXmlDB(m_accid);
		
		var m_mwXmlDB = new xmlpack.EAGRDXmlDB(sytid,grdid);
		
		var m_mwds = m_mwXmlDB.getGrdDS();
		
		var m_showds=m_mwXmlDB.getGrdShwDS(); //�ҵ�����Ͳ�ѯ�м䵥Ԫ��󶨵���Ϣ
		var m_paramds = m_mwXmlDB.getGrdPamDS();
		var m_dscds = m_mwXmlDB.getGrdDSCDS();
	
		var m_celds=m_mwXmlDB.getGrdCelDS(); //�ҵ���ͷ��Ԫ��󶨵���Ϣ
		var m_colds=m_mwXmlDB.getGrdColDS(); //�ҵ���ϸ��Ԫ��󶨵���Ϣ
		
		var m_grdnam=m_mwds.getStringDef(0,grdpack.EAMidWareUtil.GRD_NAME,"");
		var m_defdbname = m_mwds.getStringDef(0,"DBNAME",""); // Ĭ�ϵ����ݿ�
		var m_itemtablename = m_mwds.getStringDef(0,"ITEMTABLE","");
		var m_checktitle = m_mwds.getStringDef(0,grdpack.EAMidWareUtil.GRDCEL_CHECKTITLE,""); // 
		var m_closepages = "1".equals(m_mwds.getStringDef(0,"CLOSEPAGES","")); 
		//throw new Exception(grdpack.EAMidWareUtil.GRD_MWTYP);
		var m_mwtyp = m_mwds.getStringAt(0, grdpack.EAMidWareUtil.GRD_MWTYP);
		var m_mwbtnds = m_mwXmlDB.getGrdBtnDS();
	 
		var m_accnameCell="1-1";
		
		html=sytid +"-"+grdid+"-"+m_mwtyp;
		
		var sb = new StringBuffer();
		var jssb = new StringBuffer();
	
		sb.append("<script src=\"xlsgrid/js/xlscel.js\"></script><script src=\"xlsgrid/js/xlscol.js\"></script><script src=\"xlsgrid/js/x/showflg_mw.djs\"></script>");
		sb.append("<script>var homeurl=\""+m_usrinfo.getHomeURL()+"\";");
		sb.append("</script>");	
		sb.append("<link rel=\"stylesheet\" href=\"syt"+sytid+"/"+grdid+"/iconfont.css\">");	
	
	      
		var file = m_mwXmlDB.getBaseFileName();
		var html = pubpack.EAFunc.readFile(file+".htm");//��ȡ�м��Ŀ¼�µ�grdid.htm�ļ�
		// ȡ��html�������ʽ
		var p = html.indexOf("<style>");if ( p == -1 ) throw new pubpack.EAException( "���м����ҳ������û���ҵ���ǩ<style>");
		var p1 = html.indexOf("</style>");if ( p1 == -1 ) throw new pubpack.EAException( "���м����ҳ������û���ҵ���ǩ</style>");
		sb.append(html.substring(p,p1+8));
		
		var stru = pubpack.EAFunc.readFile(file+".str");
		var ds = new pubpack.EAXmlDS(stru);
		if (ds.getColumnCount()>0 && getDSColumnName(ds,0)=="num" ) // //ɾ���к��У��ӵڶ��п�ʼ������Ч����
	        		ds.removeColumn(0);
	      		var line = new StringBuffer();
		var g_guid="";	try{g_guid=guid;}catch(e){ }
		var g_bilid="";	try{g_bilid=bilid;}catch(e){ }
		var g_biltyp="";try{g_biltyp=biltyp;}catch(e){ }
		var hdrds  = new pubpack.EADS();
		var BILHDRTABLE = m_mwds.getValueDef(0,"BILHDRTABLE","BILHDR");
		var BILDTLTABLE = m_mwds.getValueDef(0,"BILDTLTABLE","BILDTL");
		jssb.append(" var BILHDRTABLE='"+BILHDRTABLE +"';var BILDTLTABLE ='"+BILDTLTABLE +"';");	
		if(m_mwtyp=="F") {
			//���м��f
			
			var sql = "select * from "+BILHDRTABLE +" where guid='"+g_guid+"'";
			hdrds = db.QuerySQL(sql);
	
		}
		else if (m_mwtyp=="B"){
			var sql = "";
			if(g_guid!="" )
				sql = "select * from BILHDR where  guid='"+g_guid+"'";
			else sql = "select * from BILHDR where bilid='"+g_bilid+"' and acc='"+m_accid+"' and biltyp='"+g_biltyp+"'";
			hdrds = db.QuerySQL(sql);
	
		}
	 	
	 	var mstat = "";
	 	var msubtyp = "";
	 	var g_idold = "";
	 	
	 	if(hdrds.getRowCount()>0){
	 		mstat = hdrds.getStringDef(0,"stat","");
	 		msubtyp = hdrds.getStringDef(0,"subtyp","");
	
	 		g_idold= hdrds.getStringDef(0,"bilid","");
	
		}
		sb.append("<script>var grdtyp=\""+m_mwtyp+"\";var bilid =\""+g_bilid+"\";var G_GUID =\""+g_guid +"\";var idold =\""+g_idold +"\";var stat =\""+mstat  +"\";var subtyp =\""+msubtyp +"\";
		function f_afteraction(actionid){	// �Ӵ���¼����������󷵻��޸�״̬
	              	var runurl = G_WEBBASE + 'EAWorkFlow1.sp?thissytid='+G_SYTID+'&thismwid='+G_GRDID+'&formguid='+G_GUID+'&actionid='+actionid;
	              	_this.OpenHttpRequest(runurl ,'GET');
			var runret=_this.SendHttpRequest();
			_this.CloseHttpRequest();
			if(runret!='') 
				alert('�����ɹ�'+runret);
			else alert('����ʧ��'+runret);
		} 
		</script>");
		
		var tooldiv ="";// ���ǹ�����
		var toolbut=""; //�������а�ť
		
		if(action!="query"&&m_mwtyp=="F"){
			if(g_guid!=""){
				toolbut="<a  onclick=\"f_save()\"><span style=\"padding: 6px 16px;background-color:#08A5EC;color: #fff;cursor:pointer;\">����</span></a>
				   	 <a onclick=\"f_delete();\"><span style=\"padding: 6px 16px;background-color:#FF0005;color: #fff;margin: 0 20px 0 5px;cursor:pointer;\">ɾ��</span></a>";
			}else{
				toolbut="<a onclick=\"f_save()\"><span style=\"padding: 6px 16px;background-color:#08A5EC;color: #fff;margin: 0 20px 0 5px;cursor:pointer;\">����</span></a>";
			}
			tooldiv ="<div style=\"position: fixed;top:0;left: 0;width: 100%;background-color: #E8EDED;z-index: 998;tab-size: 18;height: 36px;text-align: right;line-height: 36px;\">
				  "+toolbut+"	
				</div><div style=\"height:36px;\"></div>";
			
		}
		sb.append(tooldiv);
	 	var buttondiv = "";
	 	//����divռλ
	// 	buttondiv +="<div style=\"filter: alpha(opacity=45); opacity:0.45; height:40px;width:100%;left:0px;top:0px;background-color:#2c2c2c;\"></div>";
		//��Ӱ�ť�¼�
		buttondiv +="<div style=\"filter: alpha(opacity=45); opacity:0.45; height:40px;width:100%;position:fixed;left:0px;top:0px;background-color:#2c2c2c;\">";
	
	var buttonhtml2 = "";
	var buttonhtml  = "";
	//��ӹ�������ť

		if(workflowmwid !=null&&actionid!=null&&!pub.EAFunc.isEmptyStr(actionid)){// �򿪵���1��ִ�н��棬¼����������ȣ�2����ͨ�ı������
			buttondiv +="<a href=\"#\" onclick=\"javascript:parent.hideupload();\"><div   style=\"float:left;width:120px;height:100%;\"/><table height=100% border=0><tr><td valign=middle><font size=3 color=#FFFFFF>&nbsp;&nbsp;&nbsp;&nbsp;ȡ��&nbsp;&nbsp;&nbsp;&nbsp;</font></td></tr></table></div></a>";
	
			var wsActionds = xmlpack.EAXmlDB.getActionDs(sytid,workflowmwid );
			//throw new Exception(wsActionds.GetXml());
			if(wsActionds !=null){
		              	wsActionds = wsActionds .filterDS("ID",actionid);
		              	//throw new Exception("fdakf"+bLock+",action="+action+",processid="+processid+",mstat  ="+mstat  +",workflowmwid ="+workflowmwid +",sytid="+sytid+","+wsActionds .getRowCount()+",xml="+wsActionds .GetXml());
//				var xxxml = wsActionds.GetXml();
//				sb.append(xxxml);
				for(var i=0;i<wsActionds .getRowCount();i++){
			             
				
			            	var actionName = wsActionds .getStringAt(i,"NAME"); 
 
			            	var funcid = wsActionds .getStringAt(i,"id");// EAFunc.format("%s%s%s",m_mwid,processid,destid);
			            	var actmw  = wsActionds .getStringDef(i,"actmw","");
			            	var destid = wsActionds .getStringDef(i,"DESTID","");
			            	var srcid =wsActionds .getStringDef(i,"SRCID","");
			            	//buttonhtml2 +="<input type=\"button\" onclick=\"stm"+funcid +"();\" id=\""+funcid +"\" name = \"name"+funcid +"\" value =\""+actionName +"\"/>";
			            	buttonhtml2 +="<a href=\"#\" onclick=\"stm"+funcid +"();\"><div id=\""+funcid +"\" name = \"name"+funcid +"\" onmouseover=\"this.style.cursor='hand';\" value =\""+actionName +"\" style=\"float:right;height:100%;\"/><table  height=100% border=0><tr><td valign=middle><font size=3 color=#FFFFFF>&nbsp;&nbsp;&nbsp;&nbsp;"+actionName +"&nbsp;&nbsp;&nbsp;&nbsp;</font></td></tr></table></div></a>";
					//sb.append(wsActionds.GetXml());

					buttonhtml += "\r
			              		function stm"+funcid+"(){\r
			              			//��ִ�б���
			              			var retguid = f_save(false);
			              			if(retguid!=''){
				              			parent.f_afteraction("+funcid+");
				              			parent.hideupload();
			              			}
			              			//else alert('����ʧ��');

			              		\r}\r
			              	";

//			            sb.append("\n _this.AddToolbarButton('udf_stm"+funcid+"', '"+EAFunc.il8n("formgrid.submit")+"','"+name+"', '' , 0,1, 1, "+length+");");
//			            stmsb.append("function stm"+funcid+"(){\r" );
//			            
//			            //�ͻ��˽ű���֤���  2021.12.11 add by flm
//			            stmsb.append("if(typeof _thisValidateStm"+funcid+" !='undefined') {\rvar result=_thisValidateStm"+funcid+"();\r");
//			            stmsb.append("if(result!=\"\"){alert(result);return;}}");
//			            
//			            stmsb.append("if(!f_save(false)){}\r");
//			            stmsb.append("else{\r");
//			            stmsb.append("  window.returnValue=\"1\";\rwindow.close();");
//			            stmsb.append("}\r}");
				}
				
				
			}
		}else if(processid !=null&&!pub.EAFunc.isEmptyStr(processid)){	// �򿪵���ĳ�����Ĵ���������
			
			buttondiv +="<a href=\"#\" onclick=\"javascript:window.close();\"><div   style=\"float:left;width:120px;height:100%;\"/></div></a>"; //<table height=100% border=0><tr><td valign=middle><font size=3 color=#FFFFFF>&nbsp;&nbsp;&nbsp;&nbsp;�ر�&nbsp;&nbsp;&nbsp;&nbsp;</font></td></tr></table>
			
			var wsActionds = xmlpack.EAXmlDB.getActionDs(sytid,grdid); 
			if(wsActionds !=null){
		              	wsActionds = wsActionds .filterDS("SRCID",processid );//mstat

		              	for(var i=0;i<wsActionds.getRowCount();i++) {
		              		
		              		var funcid = wsActionds.getStringAt(i,"id");//�������
			              		var wsWhere = wsActionds .getStringDef(i,"WHERE","");
			              		if(wsWhere!=""){
							if( wsWhere.length()>0){
					              wsWhere= pub.EAFunc.XmlToStd(wsWhere);
					              wsWhere= pub.EAFunc.Replace(wsWhere, "''", "'");
					              wsWhere= pub.EAFunc.Replace(wsWhere, "<<", "<");
					              wsWhere= pub.EAFunc.Replace(wsWhere, ">>", ">");
							}
							var sql = "select count(*) from "+BILHDRTABLE+" where guid='"+g_guid+"' and stat=decode('"+processid +"','0','1','"+processid +"') " +wsWhere;
							var ret = "";
							try {
								ret = pub.EADbTool.GetSQL(sql);
							}
				                  catch (e)
				                  {
				                  // ȥ��and stat='"+processid+"' ��
					                  sql = "select count(*) from "+BILHDRTABLE+" where guid='"+g_guid+"'  " +wsWhere;
					                  ret = pub.EADbTool.GetSQL(sql);
				                  }
				                	if(ret=="0"){
				                	
				                	}else{
		              		var actionName = wsActionds.getStringAt(i,"name");//��������
		              		buttonhtml2 +="<a href=\"#\" onclick=\"f"+funcid +"();\"><div  id=\""+funcid +"\" name = \"name"+funcid +"\" value =\""+actionName +"\"  onmouseover=\"this.style.cursor='hand';\" style=\"float:right;height:100%;\"/><table height=100% border=0><tr><td valign=middle><font size=3 color=#FFFFFF>&nbsp;&nbsp;&nbsp;&nbsp;"+actionName +"&nbsp;&nbsp;&nbsp;&nbsp;</font></td></tr></table></div></a>";
		              		buttonhtml +=" function f"+funcid+"(){\r";
	            			var actmw = wsActionds.getStringDef(i,"actmw","");//������ص��м��
	            			var destid = wsActionds.getStringAt(i,"destid");//����Ŀ��״̬
	            			if(actmw.length() > 0 ) {
	            				//ȷ��ǰ��Ҫ�ȴ򿪴��ڽ��в���
	            				buttonhtml +="var ret = \"\";showupload('L.sp?grdid="+actmw+"&actionid="+funcid+"&workflowmwid="+grdid+"&srcformguid="+g_guid+"&guid="+g_guid+"&fixscreenwidth=1&usrid='+G_APP_USRID+'&userpwd='+G_APP_USERPWD);\r\n";
			            	}
			            	else {	// ֱ���޸�״̬
			            		buttonhtml +="f_afteraction("+funcid+" );";
			            	}
					buttonhtml +="}\r";	
		            	}
			              		}else{
			              			var actionName = wsActionds.getStringAt(i,"name");//��������
				              		buttonhtml2 +="<a href=\"#\" onclick=\"f"+funcid +"();\"><div  id=\""+funcid +"\" name = \"name"+funcid +"\" value =\""+actionName +"\"  onmouseover=\"this.style.cursor='hand';\" style=\"float:right;height:100%;\"/><table height=100% border=0><tr><td valign=middle><font size=3 color=#FFFFFF>&nbsp;&nbsp;&nbsp;&nbsp;"+actionName +"&nbsp;&nbsp;&nbsp;&nbsp;</font></td></tr></table></div></a>";
				              		buttonhtml +=" function f"+funcid+"(){\r";
			            			var actmw = wsActionds.getStringDef(i,"actmw","");//������ص��м��
			            			var destid = wsActionds.getStringAt(i,"destid");//����Ŀ��״̬
			            			if(actmw.length() > 0 ) {
			            				//ȷ��ǰ��Ҫ�ȴ򿪴��ڽ��в���
			            				buttonhtml +="var ret = \"\";showupload('L.sp?grdid="+actmw+"&actionid="+funcid+"&workflowmwid="+grdid+"&srcformguid="+g_guid+"&guid="+g_guid+"&fixscreenwidth=1&usrid='+G_APP_USRID+'&userpwd='+G_APP_USERPWD);\r\n";
					            	}
					            	else {	// ֱ���޸�״̬
					            		buttonhtml +="f_afteraction("+funcid+" );";
					            	}
							buttonhtml +="}\r";
			              		}
			              			
			            	}
				}
			}
 	
	
		
	for(var i=0;i<m_mwbtnds.getRowCount();i++){
		//����м���Զ��尴ť
		var cus_buttonid = m_mwbtnds.getStringAt(i,"ID");
		var cus_buttonname = m_mwbtnds.getStringAt(i,"NAME");
		//sb.append("<input type=\"button\" onclick=\""+cus_buttonid+"();\" id=\""+cus_buttonid+"\" name = \"name"+cus_buttonid+"\" value =\""+cus_buttonname+"\"/>");
		buttonhtml2 +="\r\n<a href=\"#\" onclick=\"try{"+cus_buttonid+"();}catch(e){}\"><div  id=\""+cus_buttonid+"\" name = \"name"+cus_buttonid+"\"  style=\"float:right;height:100%;\"><table  height=100% border=0><tr><td valign=middle ><font size=3 color=#FFFFFF>&nbsp;&nbsp;&nbsp;&nbsp;"+cus_buttonname+"&nbsp;&nbsp;&nbsp;&nbsp;</font></td></tr></table></div></a>\r\n";


	}

	if(!(buttonhtml ==""&&buttonhtml2 =="")){
		buttonhtml+="// ���ظ������� 
		function hideupload(){ 
			$('#show_upload_iframe').hide(); 
		} 
		// ������������ 
		function showupload(ajaxurl){ 
			window.scrollTo(0,0);
			
			var f=$('#show_upload_iframe'); 
			f.attr(\"src\",ajaxurl);
			f.attr(\"width\",$(window).width);
			f.attr(\"height\",$(window).height);

			f.attr(\"src\",ajaxurl);
			f.show();

		} 
		function iFrameHeight() {   
//			var ifm= document.getElementById(\"show_upload_iframe\");   
//			var f=$('#show_upload_iframe'); 
//			var subWeb = document.frames ? document.frames[\"show_upload_iframe\"].document : ifm.contentDocument;   
//			if(ifm != null && subWeb != null) {
//			   ifm.height = subWeb.body.scrollHeight;
//			   ifm.width = 800;
//			}   
			//f.show();
		}";
		sb.append(buttondiv +"<script language='javascript'>"+buttonhtml+"</script>"+buttonhtml2 +"</div>");
		sb.append("<div style=\"width:100%;height:50px;\"></div>");

	}
	//�������ĵ�������
	var htmlifram ="";
 	htmlifram +="
 		
 		<iframe frameborder=0 border=0 id=\"show_upload_iframe\"  frameborder=2   style=\"position: absolute;top:0px;left:0px; display:none;  background-color: white;z-index:99999; width:100%; height:100%;\" ></iframe>";

 	sb.append(htmlifram );
	//renderPDAPage_fillCell(ds,jssb);
	var startRow = 0; 
	var startCol = 0;  
	var resRow = 0;
	var resCol = 0;
	var endRow = 0;
	var endCol = 0;
	var haveDtl=true;
		var _dtlrng = "";
		try{_dtlrng=_dtlrng+m_mwds.getValueAt(0,grdpack.EAMidWareUtil.GRD_DTLRNG);}catch(e){}
	
	try{
		var dtlrng = _dtlrng.split(",");
		startRow = langpack.Integer.parseInt(dtlrng[0]);   
		startCol = langpack.Integer.parseInt(dtlrng[1]);   
		endRow  =langpack.Integer.parseInt(dtlrng[2]);
		endCol  =langpack.Integer.parseInt(dtlrng[3]);
	}catch(e){haveDtl=false;}
	
	//get col define
//	var cods = m_mwXmlDB.getGrdColDS();
//	var m_detailShowID = dsshow.getStringAt(idx, EAMidWareUtil.GRDSHW_ID).trim();
//	if(m_mwtyp=="F"){//���м��
		

		var dtlds = new pubpack.EADS();
		if(m_mwtyp=="F"){
			if (m_mwds.getStringDef(0,"BILDTLTABLE","").length() > 0 ) 
		      		dtlds=db.QuerySQL("select * from "+m_mwds.getValueDef(0,"BILDTLTABLE","")+" where formguid='"+g_guid+"'");
	      				
		}
		else if (m_mwtyp=="B"){
			if(g_guid!="" )dtlds=db.QuerySQL("select * from BILDTL where (acc,biltyp,bilid)=(select acc,biltyp,bilid from bilhdr where guid='"+g_guid+"')");
			else dtlds=db.QuerySQL("select * from BILDTL where bilid='"+g_bilid+"' and acc='"+m_accid+"' and biltyp='"+g_biltyp+"'");
		}
		else if (m_mwtyp=="R"||m_mwtyp=="Q"){
			var mysql = "";
			
		      	for (var i=0;i<m_showds.getRowCount();i++)
		      	{
		        	var dskey = m_showds.get(i,"DSKEY");
		        	var arrDs = dskey.split(",");
		        	var cellid = m_showds.getStringAt(i,"ID");
				var aCellid = m_showds.getStringAt(i,"ID").split(",");//sheet,row,col
					
		       		if (arrDs.length() == 1 && dskey.indexOf("DSC:") > -1 && dskey.indexOf(",")<0 )  //2010/6 ����DSC:MAIN,0,0
		        	{
		        		// ������������
		        		var dscid=arrDs[0].substring(4);	
		        		if(m_dscds!=null){
				      		var keyidx = m_dscds.getColumnLoc("ID");
				      		var validx = m_dscds.getColumnLoc("DATDSC");
				      		mysql = m_dscds.FindasHashMap(dscid,keyidx,validx);
				      		if(mysql==null || mysql=="" ) throw new Exception ( "����Դ"+dscid+"û�ж���SQL���");
				      		//�������Ϣ
//						var m_isCross = "1".equals(m_showds.getStringDef(i, "GRDSHW_ISCROSS", ""));
//						var m_showPages = "1".equals(m_showds.getStringDef(i,"PAGES",""));
//						var m_showPagesize = Integer.parseInt(m_showds.getStringDef(i,"PAGESIZE","-1"));
//						var m_initDynCtrl = "1".equals(m_showds.getStringDef(i,"DYNCTL",""));
//						var m_dbname = m_showds.getStringDef(i, EAMidWareUtil.GRDSHW_DBNAME, "");      
//						var m_isCrossIncludeHead = "1".equals(m_showds.getStringDef(i, "HROW", ""));
//						var m_detailDscID=arrDs[0].substring(4);
				      
				      		////���ű�һ����������Ļ���
						//var result = ""+ servletpack.RunScript.ExecMwOsEx(sytid,mwid,"replaceParam",new Object[]{this,request,mysql});
						//if(result!="" && result!="null") mysql= result;
						
						if(aCellid.length()>=3){
							startRow  = 1*aCellid[1];
							startCol  = 1*aCellid[2];
							endRow = startRow + 1*m_showds.getStringAt(i,"NROW")-1;
							endCol = startCol + 1*m_showds.getStringAt(i,"NCOL")-1;
							
							haveDtl = true;
						}
						mysql=webpack.EASession.GetSysValue(mysql,m_usrinfo);
						for ( var ii = 0 ; ii < m_paramds.getRowCount(); ii ++ ) { 
							var paramid = m_paramds.getStringAt(ii,"ID");
							var defval = m_paramds.getStringAt(ii,"DEFVAL");
						      	mysql  = pubpack.EAFunc.Replace(mysql,"[%"+paramid+"]",pubpack.EAFunc.NVL(request.getParameter(paramid),defval));
						}
						mysql=webpack.EASession.GetSysValue(mysql,request);//�滻request ��[%id]
						dtlds=db.QuerySQL(mysql);
						
					}
					
				}
				else if (arrDs.length()> 1 && dskey.indexOf("DSC:") > -1 && dskey.indexOf(",")>0 )  //
		        	{	// ����ĳ����ѯ����� DSC:MAIN,0,0
		        		var dscid=arrDs[0].substring(4);	
		        		if(m_dscds!=null){
				      		var keyidx = m_dscds.getColumnLoc("ID");
				      		var validx = m_dscds.getColumnLoc("DATDSC");
				      		mysql = m_dscds.FindasHashMap(dscid,keyidx,validx);
				      		if(mysql==null || mysql=="" ) throw new Exception ( "����Դ"+dscid+"û�ж���SQL���");
						mysql=webpack.EASession.GetSysValue(mysql,m_usrinfo);
						for ( var ii = 0 ; ii < m_paramds.getRowCount(); ii ++ ) { 
							var paramid = m_paramds.getStringAt(ii,"ID");
							var defval = m_paramds.getStringAt(ii,"DEFVAL");
						      	mysql  = pubpack.EAFunc.Replace(mysql,"[%"+paramid+"]",pubpack.EAFunc.NVL(request.getParameter(paramid),defval));
						}
						mysql=webpack.EASession.GetSysValue(mysql,request);//�滻request ��[%id]
						var dsds =db.QuerySQL(mysql);
						var val = "";
						try{
							val = dsds.getStringAt(1*arrDs[1],1*arrDs[2]);
						}
						catch(eeee){}
						var rr = 1*aCellid[1];var cc = 1*aCellid[2];
						var oldval = ds.getStringAt(rr,cc);
						var ss = oldval.split("`");oldval = val ;
							
						for( var nn=1;nn<ss.length();nn++) oldval+="`"+ss[nn];
							ds.setValueAt(rr,cc,oldval);


					}

		        	}
		        	else {
		        		// �����������[%itmid] [%SYS_USRNAM]
		        		if(aCellid.length()>=3){
		        			dskey  =webpack.EASession.GetSysValue(dskey ,m_usrinfo);
		        			for ( var ii = 0 ; ii < m_paramds.getRowCount(); ii ++ ) { 
							var paramid = m_paramds.getStringAt(ii,"ID");
							var defval = m_paramds.getStringAt(ii,"DEFVAL");
						      	dskey = pubpack.EAFunc.Replace(dskey ,"[%"+paramid+"]",pubpack.EAFunc.NVL(request.getParameter(paramid),defval));
						}
						dskey =webpack.EASession.GetSysValue(dskey ,request);//�滻request ��[%id]
		        			var rr = 1*aCellid[1];var cc = 1*aCellid[2]; 
						var oldval = ds.getStringAt(rr,cc);
						var ss = oldval.split("`");oldval = dskey ;
						
						for( var nn=1;nn<ss.length();nn++) oldval+="`"+ss[nn];
							ds.setValueAt(rr,cc,oldval);


					}
		        	}
		     	 }
			     
			
			
			
		}

		//������������������Ϣ�ű�
		resRow = endRow-startRow+1;
		resCol = endCol-startCol+1; 
		sb.append( "<script>\n  m_startrow = "+startRow + ";" ); 
		sb.append( "\n  m_startcol = "+startCol+ ";" ); 
		sb.append( "\n  m_endrow = "+(endRow+1)+ ";" );
		sb.append( "\n  m_orgEndRow = "+endRow+ ";");
		sb.append( "\n  m_endcol =  "+endCol+ ";" );//1 +  
		
		for ( var c=0;c<m_colds.getRowCount();c++){
		
			var ids = m_colds.getStringAt(c,"ID"); var idss = ids.split(",");
			sb.append("\n xlscol.add("+idss[0]+","+idss[1]+",'"+m_colds.getStringAt(c,"VALFLD")+"','"+m_colds.getStringAt(c,"LISTID")+"','"+m_colds.getStringAt(c,"FLD")+"','"+
				m_colds.getStringAt(c,"COLTYP")+"','"+m_colds.getStringDef(c,"NOTNULL","")+"','"+m_colds.getStringDef(c,"WHERE","")+"','"+m_colds.getStringDef(c,"ORDER","")+"');");
		}   	      
		sb.append("\n</script>");
		// ��Ԫ����ֵ��ʽ��
		// ��һ���֣���������
		//	ֵ,����,����,���,��ʽ,�߶�,XX,��ֵ��ʽ7
		// �ڶ����֣�ƥ����Ϣ
		//	�ؼ�����8,�󶨹ؼ���9,�����ֶα�ͷ����ϸ��ʶ10,�����11,�����ݿ�ȡ����ֵ12�������ݿ�ȡ������ʾֵ13,END��β��־
		//���ñ�ͷ��Ϣ
		
		for(var i=0;i<m_celds.getRowCount();i++){
			var t_cells=m_celds.getStringAt(i,grdpack.EAMidWareUtil.GRDSHW_ID).split(",");
			var VALFLD=m_celds.getStringAt(i,"VALFLD") ;//�ҵ������ֶ�
			var CTLTYP=m_celds.getStringAt(i,"CTLTYP") ;//�ҵ������ֶεĿؼ�����
			var LISTID=m_celds.getStringAt(i,"LISTID") ;//�ҵ������ֶεĿؼ��İ󶨹ؼ���
			var SHWVALFLD=m_celds.getStringDef(i,"FLD","") ;//��ʾֵ
						
			var t_row=t_cells[1];
			var t_col=t_cells[2];
			if(t_col!=-1){
				var btyp="hdr";//�����ֶα�ͷ����ϸ��ʶ	
				var cel=i;//m_colds���к�	
				
				if(CTLTYP=="") CTLTYP="text";
				
				//2015 6 modify by scott
				//if(t_col==43)return 26;
				var thiscolnam = getDSColumnName(ds,t_col);
				if(thiscolnam!=""){
					var oldval = ds.getStringAt(t_row,thiscolnam );
//					if(i==18){
//						throw new Exception( "SHWVALFLD="+SHWVALFLD);
//					
//					}
					if(oldval.trim()!="")
						ds.setValueAt(t_row,thiscolnam ,
						oldval+"`"+CTLTYP+"`"+LISTID+"`"+btyp+"`"+cel+"`"+hdrds.getStringDef(0,VALFLD,"")+"`"+hdrds.getStringDef(0,SHWVALFLD,"")+"`"+"END"
						);
				}
				
				
			}
			

		}
		//return m_celds.GetXml();
		var dtlrow1=startRow ;var dtlcol1=startCol ;var dtlrow2=endRow  ;var dtlcol2=endCol  ;
		var addcolhtml = "";
		if(dtlrow1!=0 && dtlrow2!=0 && dtlcol1!=0 && dtlcol2!=0 ){
			var startrow = 1*dtlrow1;
			//������ϸ��Ϣ
			
			if(dtlds.getRowCount()>0){
				for(var r=0;r<dtlds.getRowCount();r++){
					if(r+dtlrow1>=dtlrow2&&r<dtlds.getRowCount()-1){
						var newrow = ds.AddRow(dtlrow1+r);
						dtlrow2++;endRow  ++;
					}
					var thisguid = dtlds.getStringDef(r,"GUID","");// �Ѵ��ڵ���ϸ����Ҫ��һ���ط�����¼guid
					ds.setRowValue(dtlrow1+r,thisguid );
					if(m_mwtyp=="B" ||m_mwtyp=="F" ) {
						for(var i=0;i<m_colds.getRowCount();i++){
							var t_colls=m_colds.getStringAt(i,grdpack.EAMidWareUtil.GRDSHW_ID).split(",");
							var VALFLD=m_colds.getStringAt(i,"VALFLD") ;//�ҵ������ֶ�
							var COLTYP=m_colds.getStringAt(i,"COLTYP") ;//�ҵ������ֶεĿؼ�����
							var LISTID=m_colds.getStringAt(i,"LISTID") ;//�ҵ������ֶεĿؼ��İ󶨹ؼ���
							var SHWVALFLD=m_colds.getStringDef(i,"FLD","") ;//�ҵ������ֶ�
	
							var t_col=t_colls[1];
							addcolhtml += "_this.SetColName(0,"+t_col+",\""+VALFLD+"\");";
	
							var btyp="dtl";//�����ֶα�ͷ����ϸ��ʶ	
							var cel=i;//m_colds���к�
							if(COLTYP=="") COLTYP="text";
							var thiscolnam = getDSColumnName(ds,t_col);
							if(thiscolnam!=""){
								var oldval= ds.getStringAt(dtlrow1+r,thiscolnam );
								if(oldval.trim()!="")
									ds.setValueAt(dtlrow1+r,thiscolnam ,
										oldval+"`"+COLTYP+"`"+LISTID+"`"+btyp+"`"+cel+"`"+dtlds.getStringDef(r,VALFLD,"")+"`"+dtlds.getStringDef(r,SHWVALFLD,"")+"`"+"END"
									);
							}
						}
					}
					else if (m_mwtyp=="Q" ||m_mwtyp=="R" ) {
						
						for(var c=0;c<dtlds.getColumnCount();c++){
							var oldval = ds.getStringAt(dtlrow1+r,dtlcol1+c);
							var ss = oldval.split("`");oldval = dtlds.getStringAt(r,c);
							//throw new Exception(oldval);
							for( var nn=1;nn<ss.length();nn++) oldval+="`"+ss[nn];
							ds.setValueAt(dtlrow1+r,dtlcol1+c,oldval);//+"`````"+dtlds.getStringAt(r,c)+"``END"
							
						}
					}
				}
				startrow += dtlds.getRowCount();	// �����Ŀ��л���Ҫ��������Ϣ
			}
			
				
			for(var r=startrow;r<=1*dtlrow2;r++){
				for(var i=0;i<m_colds.getRowCount();i++){
					var t_colls=m_colds.getStringAt(i,grdpack.EAMidWareUtil.GRDSHW_ID).split(",");
					var VALFLD=m_colds.getStringAt(i,"VALFLD") ;//�ҵ������ֶ�
					var COLTYP=m_colds.getStringAt(i,"COLTYP") ;//�ҵ������ֶεĿؼ�����
					var LISTID=m_colds.getStringAt(i,"LISTID") ;//�ҵ������ֶεĿؼ��İ󶨹ؼ���
					var SHWVALFLD=m_colds.getStringDef(i,"VAL","") ;//�ҵ������ֶ�
					
					var t_col=t_colls[1];
					addcolhtml += "_this.SetColName(0,"+t_col+",\""+VALFLD+"\");";
					var btyp="dtl";//�����ֶα�ͷ����ϸ��ʶ	
					var cel=i;//m_colds���к�
					
					
					if(COLTYP=="") COLTYP="text";
					var thiscolnam = getDSColumnName(ds,t_col);
					if(thiscolnam!=""){//2015 6 modify by scott
						var oldval = ds.getStringAt(r,thiscolnam );
						if(oldval!="")
						ds.setValueAt(r,thiscolnam ,
							oldval+"`"+COLTYP+"`"+LISTID+"`"+btyp+"`"+cel+"`"+""+"`"+""+"`"+"END"
						);
						
					}	
				}
			}
			
			
		}
		sb.append("<script>var G_MAINCELLRANGROW1='"+dtlrow1+"';var G_MAINCELLRANGROW2='"+dtlrow2+"';var G_MAINCELLRANGCOL1='"+dtlcol1+"';var G_MAINCELLRANGCOL2='"+dtlcol2+"';"+addcolhtml +"</script>");
		var r=ds.getRowCount();
      		var c=ds.getColumnCount();
		
		//�ȳ�ʼ�����ݺ͸�ʽ(�����ʽ)
	      //��ʼ���п��,����ڵ�һ�� ```31`s1`18
	      var sumwidth = 0 ;
	      for( var n=0;n<ds.getColumnCount();n++)
	      {
	        var  ss= ds.getStringAt(0,n).split("`");
	        if ( ss.length()>=4) {
	        	if(ss[3]=="")ss[3]="0";//throw new Exception( "���б�����ʾ�������ϰ汾���м��XML�ļ�����Ѹ��м��"+grdid+"�����������һ��"+ds.getStringAt(0,n));
	        	sumwidth +=  langpack.Integer.parseInt(ss[3]);	
	          	ds.SetColumnExValue(n,ss[3]);  
	          
	        }
	      }
	      jssb.append("var G_ROW_COUNT="+ds.getRowCount()+";var G_COL_COUNT="+ds.getColumnCount()+";");
	      	var  cc = dtlds.getColumnCount();
		var uicols = c>cc?c:cc+(c-resCol);
		var col1 = 255;
		if(fixscreenwidth=="1")
			sb.append("<table id=\"table_main\" width=\"100%\"  border=0 cellpadding=0 cellspacing=0 style='border-collapse:collapse;' '>");//"+sumwidth +"
		else sb.append("<table id=\"table_main\" width=\""+sumwidth +"px\"  border=0 cellpadding=0 cellspacing=0 style='border-collapse:collapse;'>");//"+sumwidth +" width=\""+sumwidth +"px\" 

		for(var i=0;i<r;i++)
		{
			
			sb.append("\n<TR id=\"ROW_"+i+"\" ");
			var rowvalue = ds.getRowValue(i);
			if(rowvalue!="")sb.append(" ROWVALUE=\""+rowvalue+"\" " );
			if ( dtlds.bHaveRowURL==true ){
				var url = dtlds.getRowURL(i);
				if ( url.length() > 0 ) {
					sb.append(" onclick=\"javascript:window.location='"+ dtl.getRowURL(i)+"';\" onmouseover=\"this.style.cursor='hand';\" " );
				}
			}
			
			var closed=false;
				
			for(var j=0;j<c ;j++){
				
//				var hcol = (j <col1+resCol)?j:col1+resCol-1;//���ģ����ϸ��Ҫ��������չ�������һ����ϸ���Ķ��壻
//          			
//          			if(j==uicols-1)hcol=c-1; //���һ��
				
				var hcol= j;
				var info=ds.getStringAt(i,hcol);
				var items = info.split("`");
				
          			if(items.length()==1){//           				//sb.append("len="+items.length()+","+info);
//          				 continue;//���ϲ��ĵ�Ԫ�� info==""
          			}
          			else{
					var idx=0;
					// ֵ,����,����,���,��ʽ,�߶�,��Ԫ������ �磺������뵥``9``s4`24``100000021  ���е�Ԫ�����Ե�һλ=1��ʾ����
					 
					 
					var val = "";if(items.length()>0){ val=items[0];}
					var nrow= "";if(items.length()>1)nrow=items[1];
					var ncol= "";if(items.length()>2)ncol=items[2];
					var wid = ds.GetColumnExValue(j);// ����ڵ�һ�г�ʼ������
					if(ncol>1) {
						for( var cc = 1;cc<ncol;cc++) {
							var newcolwidth = ""+GetDSExValue(ds,j+cc);
							if(newcolwidth!=""&&wid !=""){
								wid=""+(langpack.Integer.parseInt(""+newcolwidth )+langpack.Integer.parseInt(""+wid));
							}
						}
					}
					
					var cls = "";if(items.length()>4)cls=items[4];//style
					var hgt = "";if(items.length()>5)hgt=items[5];// �߶�
					var cellattr = "";if(items.length()>7)cellattr=items[7];//��Ԫ������
					var bCellLock = "0"; //�Ƿ�����
					
					//throw new Exception("cellattr="+items[5]+",cellattr.substring(0,1)="+items[7]+",bLock="+bLock+",bCellLock="+bCellLock );
					if(cellattr!="")bCellLock = cellattr.substring(0,1);
					
					
					var typ = "";if(items.length()>8) typ=items[8];// 					
			          	if(!closed)
			          	{
				            	sb.append("height="+hgt+">");
				            	closed=true;
			          	}
			          				          	
			          	if(m_accnameCell==""+i+"_"+j){//��ʾ��ͷ
						if ( m_mwds.getStringDef(0,EAMidWareUtil.GRD_NOACCNAME,"0").equalsIgnoreCase("0")&& !pubpack.EAOption.get("SHOW_ACCNAM_ON_GRID").equalsIgnoreCase("n")) 
							val = accdb.getLngnam(); 
					}
					
					if(val.length()>0){
						
						var loc = hdrds.getColumnLoc(val);
						
						if(loc>=0)val = hdrds.getStringAt(0,loc);
						
					}
					
			          	if(cls.length()==0&& wid.length()==0){//2010 �����Ǻϲ�
			          	
			            		//sb.append(val);
			            		
			          	}
			          	else {
			  			sb.append( gettdinfo(i,j,nrow,ncol,cls,wid  ,typ) );//
					            	sb.append(">");
	//				            	if(hgt!=""&&val.length()== 0 && langpack.Integer.parseInt(hgt) > 5 ) // �߶����С��5����Ҫ�ѿ����Ϊ&nbsp; 
	//				              		val = "&nbsp;";
//					        }catch(e){
//			            			return hgt;
//			            		}
			            		var thiswidth  = "100%";
			            		if(fixscreenwidth=="0"){
			            			thiswidth  = wid+"px";//
			            			//try{thiswidth =""+ (1*wid-5);}catch(e){thiswidth =wid;}

						}
						var readonly = "0";
						if(bLock=="1") readonly = bLock;
						else if(bCellLock=="1")readonly =bCellLock;
						
			            		showContent(sb,cls,val,items,m_celds,m_colds,i,j,thiswidth,readonly,thiswidth,hgt,jssb);

			            		//showContent(sb,cls,val,items,m_celds,m_colds,i,j,wid);
			            		
		          		}
		          		
		          		 
	          			
		          	}	
	          		

        		}
        		
        		if(!closed)sb.append(">");
		
//        		sb.setLength(0);
        		sb.append("</TR>");
        		
      		}
		
	      //����׼����ϣ���os����һ���ӹ������ڴ��¼���Ϊ�µ�����ʱ��������
	    	//servletpack.RunScript.ExecMwOsEx(m_sytid,m_mwid,"filterBillDS",new Object[]{hdrds,dtlds,sb,request});
		

//	}
	sb.append("</table>");	
	// xlsgrid/js/"+sytid+"/"+grdid+".djs\"></script>\n"+ ����ʹ�� djs ֱ�ӷŵ�html��������
	sb.append("<script>");	

	// �Զ�����djs
	grdpack.EAMidWareBase.EnsureMwJsFile(sytid,grdid);
	sb.append( pubpack.EAFunc.readFile(pubpack.AppStartListener.approot+"xlsgrid/js/"+sytid+"/"+grdid+".djs") );
	sb.append( jssb.toString() );
	sb.append( "
	setTimeout('f_initgrid()',10);
	
		");
		
	sb.append("</script>");
	//��������
	sb.append("<div id='POPWIN' style='POSITION:fixed;display:none;border:1px ridge;width:380px;height:380px;top:0px;left:0px;z-index:900;overflow:auto;background-color:#ABABAB;'></div>");
	return sb.toString() ;
	}catch(e){
		db.Rollback();
		
		return ;
	}finally{
		if(db!=null){db.Close();}
	}
	
	
	return "error";
}
//�õ���Ԫ��ĸ߶�
function GetDSExValue(ds,c){
	try{
		return ds.GetColumnExValue(c);
	}
	catch(eee){
		return "";
	}
}

//���õ�Ԫ��ϲ����߶�
function gettdinfo(row,col,rows,cols,cls,wid,typ)
{
    var ret = "<TD id=CELL_0_"+row+"_"+col+" type='"+typ+"' class=";
    ret +=cls;
    if(rows.length()>0)
      ret += (" rowspan="+rows);
    if(cols.length()>0)
      ret += (" colspan="+cols);
    if(wid.length()>0)
      ret += (" width="+wid);
    //ret+=" onclick=\"try{f_cell_entry(0,"+row+","+col+");_thisOnMouseLClick(0,"+row+","+col+");}catch(e){}\"  ondbclick=\"try{_thisOnMouseDClick(0,r,c);}catch(e){}\"";
    ret += " onclick=\"CC(0,"+row+","+col+");\"  ondbclick=\"CDC(0,"+row+","+col+");\"";

    return ret;
}
// jssb �����еĽű�
function showContent(sb,cls,val,items,m_celds,m_colds,row,col,wid,readonly,w,h,jssb)
{
	try{
	if(val.toUpperCase().startsWith("$$"))
	{
 
		var names= new Array(); 
		names=val.substring(2).split(",");
		sb.append("<TABLE height=\"100%\" cellSpacing=\"0\" width=\"100%\" border=\"0\"><TBODY><TR>\n");
		sb.append("<TD style=\"BORDER-RIGHT: #3a77ba 1px solid; BORDER-TOP: #3a77ba 1px solid; BORDER-LEFT: #3a77ba ");
		sb.append("1px solid; BORDER-BOTTOM: #3a77ba 1px solid\" bgColor=\"#ffffff\" height=\"23\">\n");
		sb.append("<TABLE width=\"100%\" height=\"100%\"><TR><TD width=154>&nbsp;");
		sb.append("<IMG height=\"9\" src=\"xlsgrid/images/my/collapse.gif\" width=\"9\" border=\"0\">&nbsp;<span class=\""+cls+"\">");
	        if(names.length>1) sb.append(names[1]);
		else sb.append(names[0]);
	        sb.append("</span></TD><TD><IMG height=15 src=\"xlsgrid/images/my/barright.jpg\" width=22 ");
	        sb.append("align=right border=0></TD></TR></TABLE>");
		sb.append("</TD></TR>\n");
		sb.append("<TR><TD style=\"BORDER-RIGHT: #3a77ba 1px solid; BORDER-LEFT: #3a77ba 1px solid; BORDER-BOTTOM: #3a77ba 1px solid\"");
		sb.append("vAlign=\"top\" background=\"xlsgrid/images/my/greeting.jpg\" bgColor=\"#ffffff\"><FONT color=\"#014e82\">");
		sb.append("<iframe width=\"100%\" height=\"100%\" frameborder=\"0\" src=\"ShowXlsGrid.sp?grdid=");
		sb.append(names[0]);
		sb.append("&");
		sb.append(request.getQueryString());
		sb.append("\"></iframe>");
		sb.append("</TD></TR></TBODY></TABLE>");
		 
	}
	else{
		// ��Ԫ����ֵ��ʽ��
		// ��һ���֣���������
		//	ֵ,����,����,���,��ʽ,�߶�,XX,��ֵ��ʽ7
		// �ڶ����֣�ƥ����Ϣ
		//	�ؼ�����8,�󶨹ؼ���9,�����ֶα�ͷ����ϸ��ʶ10,�����11,�����ݿ�ȡ����ֵ12�������ݿ�ȡ������ʾֵ13,END��β��־14
		if(items.length()<8){
			
			//sb.append("("+row+","+col+")len="+items.length());//"��Ԫ���ֶβ���,һ�����ϵ��м������ȱ���ֶΣ������´�������Ը��м������һ�α���");
			return;
		}
		var kjtype="";//ȡ���ؼ�����
		var view="";//�󶨹ؼ���
		var btyp=""; //��������			
		var cellrow=""; 
		var newval = ""; 
		var newshowval = "";
		var valid = "CELLTEXT_0_"+row+"_"+col;
		var showvalid = "CELLSHOWTEXT_0_"+row+"_"+col;
		
		var valdisplaycss = "";
		var showvaldisplaycss = "display:none;";
		var id="";
		var name="";
		var sheet="";
		if(items.length()==8){// û�а��ֶ�
			//if(val!="")sb.append("<span style=\"padding-left:5px;padding-right:5px;\" id=\"CELLTEXT_0_"+row+"_"+col+"\" >"+val+"</span>");
			newval = val;
		}
		else if(items.length()==15){
			
			kjtype=items[8];//ȡ���ؼ�����
			view=items[9];//�󶨹ؼ���
			btyp=items[10]; //��������			
			cellrow=items[11]; 
			newval = items[12]; if(newval=="")newval= val;
			newshowval = items[13];
			if(btyp=="hdr"){
				id=m_celds.getStringDef(cellrow,"FLD","");//CELLID
				name=m_celds.getStringDef(cellrow,"VALFLD","");
				sheet=m_celds.getStringAt(cellrow,grdpack.EAMidWareUtil.GRDSHW_ID).split(",")[0];
				//sheet,row,col,name,namekey,key,coltyp,collen,where,sort
				//��ʾֵid, �ڲ�ֵ //name ��ʾֵ
				jssb.append( "\n xlscell.addnew( " + ""+sheet+","+  ""+row+","+""+col+","+"\"" + id+"\"," + "\"" + name+"\"," + 
				          "\"" + view+"\"," + "\"" + kjtype +"\"," + "\"\"," + "\"\"," + "\"\",\""+val+"\" );" );
				
			}
			else{
	 				//throw new Exception(grdpack.EAMidWareUtil.GRDSHW_ID);
	  				var ddd = m_colds.getStringDef(cellrow,"ID","");
	 				var cells=m_colds.getStringAt(cellrow,grdpack.EAMidWareUtil.GRDSHW_ID).split(",");
				 
				id="DTL_"+cells[0]+"_"+row+"_"+cells[1];
				name=m_colds.getStringAt(cellrow,"name");
				sheet=m_colds.getStringAt(cellrow,grdpack.EAMidWareUtil.GRDSHW_ID).split(",")[0];
			}

		}
			
		if(newshowval !=""){
			valdisplaycss = "display:none;";
			showvaldisplaycss = "";
		}
		if(sheet=="")sheet="0";
		var thiswidth = wid;
		if(val=="[%BOOLBOX]"){// ��
			//throw new Exception ( val);
			sb.append("<input type=checkbox id='"+valid+"' ctrltype=\"boolbox\" name='"+name+"' onchange=\"_thisOnCellModify("+sheet+","+row+","+col+",'',this.value)\"  value='"+newval+"' style=\"width:20px;height:20px;\">");
		}
		else if(val.length()>2&&val.substring(0,1)=="��"){//��ť
			sb.append("<table id='"+valid+"' width=100% height="+h+"  value=\""+val.substring(1,val.length()-1)+"\" ctrltype=\"button\"  onmouseover=\"this.style.cursor='pointer'\" onclick=\"try{_thisOnButtonCtrlClick('"+val.substring(1,val.length()-1)+"',"+sheet+","+row+","+col+");}catch(e){}\"><tr><td align=center valign=middle><font size=3>"+val.substring(1,val.length()-1)+"</font></td></tr></table>");


			//sb.append("<table width=100% height="+h+" border=0 id='"+valid+"' value=\""+val.substring(1,val.length()-1)+"\" ctrltype=\"button\"  onmouseover=\"this.style.cursor='pointer'\" onclick=\"try{_thisOnButtonCtrlClick('"+val.substring(1,val.length()-1)+"',"+sheet+","+row+","+col+");}catch(e){}\"><tr height="+h+"><td align=center valign=middle height=100% width=100%>"+val.substring(1,val.length()-1)+"</td></tr></table></a>");


			//sb.append("<a style=\"text-decoration: none;  border-radius: 4px;\" id='"+valid+"' value=\""+val.substring(1,val.length()-1)+"\" ctrltype=\"button\" onclick=\"try{_thisOnButtonCtrlClick('"+val.substring(1,val.length()-1)+"',"+sheet+","+row+","+col+");}catch(e){}\" ><table width=100% height=100% border=0><tr><td align=center valign=middle height=100% width=100%>"+val.substring(1,val.length()-1)+"</td></tr></table>");

			//sb.append("<input id='"+valid+"' type=\"button\" ctrltype=\"button\" value=\""+val.substring(1,val.length()-1)+"\" onclick=\"try{_thisOnButtonCtrlClick('"+val.substring(1,val.length()-1)+"',"+sheet+","+row+","+col+");}catch(e){}\" style=\"border: 0px solid #CDCDCD;width:"+thiswidth +";height:100%;\">");
		}
		else if(kjtype=="Button"){
			sb.append("<input id='"+valid+"' type=\"button\"  ctrltype=\"button\"  value=\""+name+"\" onclick=\"_thisOnButtonCtrlClick('"+valid+"',"+sheet+","+row+","+col+")\" />");
		}
		else if(val.length()>7&&val.substring(0,7)=="[%IMAGE"){// ͼƬ
			var str = val.substring(8,val.length()-1);
			sb.append("<img "+str+" id='"+valid+"'  ctrltype=\"image\"  onclick=\"_thisOnButtonCtrlClick('"+valid+"',"+sheet+","+row+","+col+")\" >");
		}
		else if(kjtype=="PasswordBox"&&readonly=="0"){ // ����
			sb.append("<input type=password id='"+valid+"' ctrltype=\"password\" name='"+name+"' onchange=\"_thisOnCellModify("+sheet+","+row+","+col+",'',this.value)\"  value='"+newval+"' style=\"font-size:9pt;border: 0px solid #0A246A;font-size:9pt;padding-left:5px; width:"+thiswidth +";height:100%;\">");
		}
		else if(kjtype=="SELECTBOX"){
			if(view!=""){
				var str= newval;
				if(newshowval!="")str=newshowval;//onblur=\"hidediv('"+valid+"')\"
				sb.append("<span style=\"padding-left:3px;padding-right:3px;\" id='"+valid+"'  innerval='"+newval+"' showval='"+newshowval+"' celllock='"+readonly+"' ctrltype=\"selectbox\" cellformat=\"\"  key=\""+view+"\"  where=\"\">"+str+"</span>
				<input ctrltype=\"selectbox\" type=text id='INPUT_"+valid+"'    name='"+name+"' value=\"\"  onkeyup=\"ddldiv('"+valid+"');\"  onkeydown=\"f_cell_keydown(event);arrowevent('"+valid+"');\"  onchange=\"f_scm("+sheet+","+row+","+col+",'',this.value,'"+view+"','');\"  style=\"display:none;border: 0px solid #0A246A; width:"+thiswidth+";height:100%;\"></input>
				<div id=\""+valid+"div_bkxl\" class=\"selectbox_wnd\" style=\"position: absolute; z-index: 9; border: 1px solid; display: none; width: 300px; overflow: hidden; cursor: pointer; background-color: white;\"></div>");

			}
			
		}
		else if(kjtype=="DATE"||val=="[%DATEBOX]"||kjtype=="DATE"){
			var str= newval;
			if(newshowval!="")str=newshowval;
			sb.append("\n<span style=\"padding-left:3px;padding-right:3px;\" id='"+valid+"' innerval='"+newval+"' showval='"+newshowval+"' celllock='"+readonly+"' ctrltype=\"date\" cellformat=\"\" >"+str+"</span>");
			sb.append("\n<input type=text readOnly='true'  id='INPUT_"+valid+"' name='"+name+"' value=\"\"  onkeydown=\"f_cell_keydown(event);\" onblur=\"f_cell_unentry(0,"+row+","+col+");\" onchange=\"try{_thisOnCellModify("+sheet+","+row+","+col+",'',this.value);}catch(eeee){}\"  style=\"display:none;border: 0px solid #0A246A; width:"+thiswidth+";height:100%;\">\n");
			

		}
		else if(kjtype=="RADIOBOX"){
			var str= newval;
			if(newshowval!="")str=newshowval;

			sb.append("\n<span style=\"display:none;padding-left:3px;padding-right:3px;\" id='"+valid+"' innerval='"+newval+"' showval='"+newshowval+"' celllock='"+readonly+"' ctrltype=\"text\" cellformat=\"\" style=\"display:none;\" >"+str+"</span>");
			
			var rediobox="";
			if(view!=""){
				var typds=db.QuerySQL("select * from "+view);
				for(var i=0;i<typds.getRowCount();i++){
					var id = typds.getStringAt(i,"id");
					var name = typds.getStringAt(i,"name");
					rediobox+="<input type='radio' name='"+valid+"_option' id='"+valid+"_option' value='"+id+"' onchange=\"try{_this.SetCellText("+sheet+","+row+","+col+",'"+id+"');_thisOnCellModify("+sheet+","+row+","+col+",'','"+id+"');}catch(eeee){}\" ";
					if(id==newval)
						rediobox+=" checked ";
					
					rediobox+="/>"+name+"</input>&nbsp;";
				}
			}
			sb.append(""+rediobox+"");
		}	
			
		else if(kjtype=="COMBOBOX"){
			var option="";
			if(view!=""){
				var typds=db.QuerySQL("select * from "+view);
				for(var i=0;i<typds.getRowCount();i++){
					var id = typds.getStringAt(i,"id");
					var name = typds.getStringAt(i,"name");
					if(id==newval)
						option+="<option selected value='"+id+"'>"+name+"</OPTION>";
					else
						option+="<option value='"+id+"'>"+name+"</OPTION>";

				}
			}
			sb.append("<div style=\"width:"+thiswidth +";border:0px solid #ccc; height:100%;background:#fffff; overflow:hidden;\">
			<select id='"+valid+"' name='"+name+"' ctrltype=\"combobox\" style=\"border-width:0px 0px 0px 0px; position:relative;width:"+thiswidth +";height:100%; "+valdisplaycss +"\" ");
			if(readonly=="1")
				sb.append(" disabled=\"disabled\" ");
			sb.append("> 
			<option value=''></option> "+option+"
			</select>
			</div>");
		}
		else if(kjtype=="MULTLINE"){

			var str= newval;
			if(newshowval!="")str=newshowval;
			//sb.append("<div style=\"width:100%;height:100%\" onclick=\"f_cell_entry(0,"+row+","+col+");\">");
			sb.append("\n<span style=\"padding-left:3px;padding-right:3px;\" id='"+valid+"' innerval='"+newval+"' showval='"+newshowval+"' celllock='"+readonly+"' ctrltype=\"MULTLINE\" cellformat=\"\"  >"+str+"</span>");
			sb.append("\n<textarea rows=\"2\" type=text id='INPUT_"+valid+"' name='"+name+"' value=\"\"  onkeydown=\"f_cell_keydown(event);\" onblur=\"f_cell_unentry(0,"+row+","+col+");\" onchange=\"try{_thisOnCellModify("+sheet+","+row+","+col+",'',this.value);}catch(eeee){}\"  style=\"margin:0px;display:none;border: 0px solid #0A246A; width:"+thiswidth+";height:100%;\"></textarea>\n");
			//sb.append("</div>");	

		}

		else if ( kjtype=="" && newval=="" && readonly=="1" ){ }// �յ����� sb.append("<img src='xlsgrid/images/flash/images/nvlimg.jpg' width=1 height=1>");
		else if(readonly!="1"){
			var str= newval;
			if(newshowval!="")str=newshowval;
			//sb.append("<div style=\"width:100%;height:100%\" onclick=\"f_cell_entry(0,"+row+","+col+");\">");
			sb.append("\n<span style=\"padding-left:3px;padding-right:3px;\" id='"+valid+"' innerval='"+newval+"' showval='"+newshowval+"' celllock='"+readonly+"' ctrltype=\"text\" cellformat=\"\"  >"+str+"</span>");
			sb.append("\n<input type=text id='INPUT_"+valid+"' name='"+name+"' value=\"\"  onkeydown=\"f_cell_keydown(event);\" onblur=\"f_cell_unentry(0,"+row+","+col+");\" onchange=\"try{_thisOnCellModify("+sheet+","+row+","+col+",'',this.value);}catch(eeee){}\"  style=\"margin:0px;display:none;border: 0px solid #0A246A; width:"+thiswidth+";height:100%;\">\n");
			//sb.append("</div>");	

		}
		else sb.append(newval);// ����ǲ������޸ģ�������ʲô���ͷ���ʲô

//		else if(kjtype=="text"&&readonly=="0"){
//			sb.append("<span style=\"padding-left:5px;padding-right:5px;display:none;\" id='"+valid+"'>"+newval+"</span>");
//			sb.append("<span style=\"padding-left:5px;padding-right:5px;display:none;\" id='"+showvalid+"'>"+newshowval+"</span>");
//			sb.append("<input type=text id='INPUT_"+valid+"' name='"+name+"'  onchange=\"_thisOnCellModify("+sheet+","+row+","+col+",'',this.value);\"  value='"+newval+" "+newshowval+"' style=\"font-size:9pt;border: 0px solid #0A246A;padding-left:5px; width:"+thiswidth +";height:100%;\">");
//			//sb.append("<input type=text id='"+showvalid+"' name='"+name+"' onchange=\"_thisOnCellModify("+sheet+","+row+","+col+",'',this.value);\"  value=\""+newshowval+"\" style=\"font-size:9pt;border: 0px solid #0A246A;font-size:9pt;padding-left:5px; width:"+thiswidth +";height:100%;"+showvaldisplaycss +"\">");
//
//		}	
//		else if(readonly=="0"){
//			sb.append("<span style=\"padding-left:5px;padding-right:5px;display:none;\" id='"+valid+"'>"+newval+"</span>");
//			sb.append("<span style=\"padding-left:5px;padding-right:5px;display:none;\" id='"+showvalid+"'>"+newshowval+"</span>");
//			sb.append("<input type=text id='INPUT_"+valid+"' name='"+name+"'  onchange=\"_thisOnCellModify("+sheet+","+row+","+col+",'',this.value);\"  value='"+newval+" "+newshowval+"' style=\"font-size:9pt;border: 0px solid #0A246A;font-size:9pt;padding-left:5px; width:"+thiswidth +";height:100%;\">");
//			//sb.append("<input type=text id='"+showvalid+"' name='"+name+"' onchange=\"_thisOnCellModify("+sheet+","+row+","+col+",'',this.value);\"  value=\""+newshowval+"\" style=\"font-size:9pt;border: 0px solid #0A246A;font-size:9pt;padding-left:5px; width:"+thiswidth +";height:100%;"+showvaldisplaycss +"\">");
//
//
//		}
//		else {
//			sb.append("<span style=\"padding-left:5px;padding-right:5px;"+valdisplaycss +"\" id='"+valid+"'>"+newval+"</span>");
//			sb.append("<span style=\"padding-left:5px;padding-right:5px;"+showvaldisplaycss +"\" id='"+showvalid+"'>"+newshowval+"</span>");
//
//		}
		

		

	}
	}catch(e){
		throw new Exception("showContent:error"+e.toString());
	}
	sb.append("</TD>");    
}
//�õ����������� SQL���
function getMainSQL(sytid,mwid,m_usrinfo,dsshow,m_dscds,request){
	var sql = "";
      for (var i=0;i<dsshow.getRowCount();i++)
      {
        var dskey = dsshow.get(i,"DSKEY");
        var arrDs = dskey.split(",");
        if (arrDs.length == 1 && dskey.indexOf("DSC:") > -1 && dskey.indexOf(",")<0 )  //2010/6 ����DSC:MAIN,0,0
        {
        	var dscid=arrDs[0].substring(4); 
        	if(m_dscds!=null){
		      var keyidx = m_dscds.getColumnLoc("GRDDS_ID");
		      var validx = m_dscds.getColumnLoc("DATDSC");
		      sql = m_dscds.FindasHashMap(dscid,keyidx,validx);
		      if(sql==null || sql=="" ) throw new Exception ( "����Դ"+dscid+"û�ж���SQL���");
		      //m_curdsid = dscid;
			//�������Ϣ
			var m_isCross = "1".equals(dsshow.getStringDef(i, "GRDSHW_ISCROSS", ""));
			var m_showPages = "1".equals(dsshow.getStringDef(i,"PAGES",""));
			var m_showPagesize = Integer.parseInt(dsshow.getStringDef(i,"PAGESIZE","-1"));
			var m_initDynCtrl = "1".equals(dsshow.getStringDef(i,"DYNCTL",""));
			var m_dbname = dsshow.getStringDef(i, EAMidWareUtil.GRDSHW_DBNAME, "");      
			var m_isCrossIncludeHead = "1".equals(dsshow.getStringDef(i, "HROW", ""));
			var m_detailDscID=arrDs[0].substring(4);
		      
		      //sql = ExpandEmbedSql(sql,1);//չ��SQL��ֱ��Ƕ����������������Դ,�磺select * from ([@310.Detail])
			////���ű�һ����������Ļ���
			//var result = ""+ servletpack.RunScript.ExecMwOsEx(sytid,mwid,"replaceParam",new Object[]{this,request,sql});
			//if(result!="" && result!="null") sql= result;
//			sql = webpack.EASession.GetSysValue(sql,m_usrinfo);
//		    
//			for ( var i = 0 ; i < m_paramds.getRowCount(); i ++ ) {    
//		      	sql = EAFunc.Replace(ret,"[%"+(i+1)+"]",m_paramds.getStringAt(i,"VALUE") );
//			}
//			for ( int i = 0 ; i < m_paramds.getRowCount(); i ++ ) {    
//				sql = pubpack.EAFunc.Replace(ret,"[%"+m_paramds.getStringAt(i,"ID")+"]",m_paramds.getStringAt(i,"VALUE") );
//			}
//			ret = pubpack.EAFunc.Replace(ret,"[]","");
		    //EALog.debug(" [  replaceParam  ��ɲ��������滻�Ĳ�ѯ����Դsql��"+ret+" ] ");    
		}
          
          break;
        }
      }
      return sql;
}
function getDSColumnName(ds,idx)
{
	try {
		return ds.getColumnName(idx);
	}catch(e){
		
	}
	return "";
}
//selectbox �ķ����
function getSelect() {
	var db = new pubpack.EADatabase();
	var ds = null;
	var html ="";
	var sql1 = "select * from ( select * from (
		select name , id ,seqid from "+tables+" where to_char(seqid) = '"+value+"' or name like '%"+value+"%' or UPPER(id) like UPPER('%"+value+"%') or UPPER(note) like UPPER('"+value+"%') 
		)where rownum<=30 ) order by seqid";

	var sql0 = "select * from (
		select name , id from "+tables+" where name like '%"+value+"%' or UPPER(id) like UPPER('%"+value+"%') or UPPER(note) like UPPER('"+value+"%')
		)where rownum<=30 order by id";
	var sql = "select * from (
		select name , id from "+tables+" where name like '%"+value+"%' or UPPER(id) like UPPER('%"+value+"%')
		)where rownum<=30 order by id";
	
	try {
		try{
			ds = db.QuerySQL(sql1);
			

		}
		catch(e) {
			try{
				ds = db.QuerySQL(sql0);
			}
			catch(e){
				ds = db.QuerySQL(sql);
	
			}
		}
	
		if(ds.getRowCount() == 0){
			 html += "<p>δ��������<font style='font-weight:bold'> "+value+" </font>��ص���Ϣ��</p>";		 
			 return html;
		}			
		if(ds.getRowCount()>0){ 
			html +="<ul id='booksearch_list' style=\"float:left;margin:0px;padding:0px;height:100%;width:100%;\">";
			for(var i=0;i<ds.getRowCount();i++){
				var name=ds.getValueAt(i,"name");
				var id=ds.getValueAt(i,"id");
				var seqid = ds.getValueDef(i,"seqid","");
				if(seqid!="")name = "("+seqid+")"+name;
				html+="<li style=\"align:left;width:100%\" id='"+valid+"li2_"+i+"' onmousemove=this.style.backgroundColor='#D7D7D7' onmouseout=this.style.backgroundColor='#FFFFFF' idval='"+id+"' onclick='G_CLOSECLICKEVENT = true;setBSName("+i+",\""+id+"\",\""+valid+"\")'>"+name;
				html+="</li>";
			}
			html +="</ul>";
		}
		
		return html;
	}catch(e){
		return ;
	}finally{
		if(db!=null){db.Close();}
	}
}

//��ȡ�ؼ��ֵ���ʾֵ
function genSelectBox()
{
	var db=null;
	var sql="";
	var ret="";
	var ds = null;
	var spec ="";
	
	var id= pubpack.EAFunc.NVL( request.getParameter("id"),"") ;
	var key= pubpack.EAFunc.NVL( request.getParameter("key"),"") ;

	
	try{
		db = new pubpack.EADatabase();
		sql="SELECT id||'~'||name spec FROM "+key+" WHERE ID ='"+id+"'";
		var sql0="SELECT id||'~'||name spec FROM "+key+" WHERE SEQID ='"+id+"'";
		try{ ds=db.QuerySQL(sql0); }
		catch(ee){

			ds=db.QuerySQL(sql);
		}
		if(ds.getRowCount()>="1"){
			spec =ds.getStringAt(0,"spec");
			return spec ;	
		}		
					
	} catch(e){
		db.Rollback();
		return e.toString();
		throw new Exception(e.toString());
	} finally {
		if(db!=null) db.Close();
	}


}

}