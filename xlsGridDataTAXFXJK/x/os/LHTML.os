function x_LHTML(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");
var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb");
var layoutpack = new JavaPackage ( "com.xlsgrid.net.layout");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd");
var langpack = new JavaPackage ( "java.lang");
//WNDMOD �����ͣ�������չ�У�
//	_this.SetListValue(list1,"HTML","HTML");
//	_this.SetListValue(list1,"OS","OS�ű�");
//	_this.SetListValue(list1,"MW","�м������");	
//	_this.SetListValue(list1,"FRAME","�ڲ�FRAME");
//	_this.SetListValue(list1,"FRAMEGROUP","��ҳFRAME��");	
//	_this.SetListValue(list1,"SCROLLIMAGE","����ͼƬ");
//	_this.SetListValue(list1,"TOOLBAR","ϵͳĬ�Ϲ�����");		
//	_this.SetListValue(list1,"MENU","�˵���");	
//	_this.SetListValue(list1,"FLASH","��Ƶ��ʾ");	
//	_this.SetListValue(list1,"���","���(��׼)");
//	_this.SetListValue(list1,"�հױ��","�հױ��");
//
//WNDMOD ���ڷ��, DSMOD ������Դ ,WHEREBY ����, SORTBY ����,SQLTXT  SQL���, LAYCOL ������ ,LAYROW ������,MOREURL ÿҳ�м�¼��, OSMWID OS�м��, OSFUNC OS����,OSPARAM OS�����Ĳ���,IFRAMEURL IFRAME��URL,IFSCROLLBAR �Ƿ���ʾ������,HTMLGUID,MOREURL,OPENLAYID HTML
function GetBody(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{	
//	return WNDMOD;

	//HTML
	if(WNDMOD=="HTML") return _GetHTML(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	//�˵���
	if(WNDMOD=="MENU") return _GetOS1(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);

	//�����ҳ�˵�
	if(WNDMOD=="TOPMENU")  return _GetOS2(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);

	//΢��΢��
	if(WNDMOD=="WEIXINBO") return _GetOS3(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	//���ҹ���ͼƬ
	if(WNDMOD=="SCROLLIMG") return _GetOS3(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	
	//����
	if(WNDMOD=="LOGINSEARCH") return _GetOS1(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	//���¹���ͼƬ
	if(WNDMOD=="SX_SCROLLIMG") return _GetOS3(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	//������
	if(WNDMOD=="TITLELIST") return _GetTITLELIST(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	//��¼������
	if(WNDMOD=="LOGIN") return _GetOS4(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	//���б�����
	if(WNDMOD=="TOUBLELIST") return _GetOS1(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	//ͼ�ı�����
	if (WNDMOD=="IMGTITLELIST") return _GetOS1(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	if (WNDMOD=="TBODY") return _GetTBODY(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	//��������
	if (WNDMOD=="texscoll") return _GetOS1(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	
	//3A��¼
	if(WNDMOD=="LOGIN3A") return _GetOS5(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	
		//W8�����Ʒ��ʾ
	if(WNDMOD=="W8ITEM") return _GetOS3(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	
	//��ҳ�б�
	if (WNDMOD == "TITLEPAGE") return _GetOS1(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	//ͼ�ı����ʡ������
	if (WNDMOD == "IMGTEXT") return _GetOS1(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	//��������DIV
	if (WNDMOD == "SINGDIV") return _GetOS1(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	return "";
	


	
}
// HTML 
function _GetHTML(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	
	return  db.getBlob2String("select bdata from formblob where guid='"+HTMLGUID+"' for update","bdata");
}
function _GetTBODY(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	var html = "";
	
	var layhdrguid= request.getParameter( "layhdrguid" ) ;
	var sql = "select A.* from LSYSURL a,formblob b,formblob img where a.icon=img.guid(+) and a.htmlguid=b.guid and a.guid='"+layhdrguid+"'";
	var ds = db.QuerySQL(sql);
	var title = "";
	var crtdat = "";
	var image = "";
	if(ds.getRowCount()>0){
		title = ds.getStringAt(0,"NAME");
		crtdat = ds.getStringAt(0,"CRTDAT");
		image = ds.getStringAt(0,"ICON");
	}
	var context = db.getBlob2String("select b.bdata from LSYSURL a,formblob b where a.htmlguid=b.guid and a.guid='"+layhdrguid+"' for update","bdata");
	html = "  
		<table   >
		<tr><td><h1 style=\"   text-align: center; \">"+title +"</h1></td></tr>
		 <tr><td align=center >"+crtdat+"</td></tr>
		 <tr><td><hr style=\"border-bottom: 1px solid #DFDFDF; padding-left: 4px; padding-right: 4px; padding-top: 1px; padding-bottom: 1px\" size=\"0\"></td></tr>
		 ";
	if(image!=""){
		html +="<tr><td align=center ><img src=\""+image +"\" border=\"0\" /></td></tr>";
	}
	
	html+= "
		 <tr><td align=center ><table     width=90% style=\"text-align: left;\"  ><tr><td>"+context +" </td></tr></table></td></tr>
		</table>

		 ";
//	html = "<p align=\"center\"><b><font size=\"4\">����</font></b></p>
//		<hr style=\"border-bottom: 1px solid #DFDFDF; padding-left: 4px; padding-right: 4px; padding-top: 1px; padding-bottom: 1px\" size=\"0\">
//		<p></p>
//		<p><img src=\"\"></p>
//		<table border=\"0\" width=\"80%\" cellspacing=\"10\">
//		 <tr>
//		  <td>"+context +"</td>
//		 </tr>
//		</table>
//		<p></p>";
//	html = "  <h1 style=\" height: auto;  text-align: center;margin-top: 10px;\">"+title +"</h1>
//		<div id=\"fbdate\" style=\"text-align: center;\">2014</div>
//		<div id=\"wenzi\" style=\"width: 630px; text-align: justify;margin: 0 auto;line-height: 23px;;BSHARE_POP blkContainerSblkCon clearfix blkContainerSblkCon_14;\">
//		<div id=\"maincontent\"><div id=\"ivs_content\">"+context +"</div><br></div> ";
//	html = "<h1 style=\" text-align: center;margin-top: 10px;\">"+title +"</h1>";
	return  html;
}
function _GetTITLELIST(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	var html = "";
	if(LAYCOL =="")LAYCOL ="1";
	var sql = "select * from ( select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' "  ;
	if(WHEREBY!="" ) sql+= " AND " +WHEREBY;
	if(SORTBY!="" ) sql+= " "+SORTBY;
	else sql+= " order by crtdat desc ";
	if(LAYCOL !=""&& LAYROW!="" ) sql+=") where  rownum<"+LAYCOL+"*"+LAYROW;
	
	// "+WHEREBY +" "+SORTBY;
	var ds=db.QuerySQL(sql);
//	for(var i=0;i<ds.getRowCount();i++){
//		html+=  "<li style=\"color:#999999\"><a href='"+ds.get(i,"URL")+"' target='"+ds.get(i,"URL")+"'>"+ds.getStringAt(i,"name")+"</a></li>";
//	}

	html +="<table>";
		
	for(var i=0;i<ds.getRowCount();i++){

		html +="<tr>";
		
		html +="<td width=\"30\">";
		html +="<img src=\""+ds.getStringAt(i,"icon2")+"\" width=20 height=20/>";
		html +="</td>";
		
		html +="<td style=\"border-bottom: 1px dotted #C0C0C0; line-height:200% \">";
		var url =ds.get(i,"URL") ;
		if(OPENLAYID!=""){
			url = "L.sp?id="+OPENLAYID+"&layhdrguid="+ds.getStringAt(i,"GUID");
			html +="<a href='"+url+"' >"+ds.getStringAt(i,"name")+"</a>";
			
		}
		else if(url !="")
			html +="<a href='"+url+"' target='"+ds.get(i,"TARGET")+"'>"+ds.getStringAt(i,"name")+"</a>";
		else html +=ds.getStringAt(i,"name");

		html +="</td>";
		html +="</tr>";

	} 
			
		
		html +="</table>";
	return html;
}
//xs
function _GetOS1(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	var parent = new x_LHTML1();
	return parent.GetBody(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
}
//xd
function _GetOS2(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	var parent = new x_LHTML2();
	return "";
//	return parent.GetBody(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
}
//xl
function _GetOS3(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	var parent = new x_LHTML3();
	return parent.GetBody(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
}
//LI
function _GetOS4(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	var parent = new x_LHTML4();
	return parent.GetBody(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
}
function _GetOS5(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	var parent = new x_LHTML5();
	return parent.GetBody(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
}
function _GetIF(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	var html="";
       if(DSMOD=="����" || DSMOD=="������Ϣ" || DSMOD=="��������"){
	html="<div style=\"border:1px #999999 solid; width:100%; height:100%\">"+
                 "<table width=100% border=\"0\">"+
                 "<tr>"+
                 "<td><h3 style=\"color:#FF0000\">&nbsp;&nbsp;&nbsp;&nbsp;"+DSMOD+"</h3></td>"+
                 "<td><a href='#'><h3 align=\"right\" style=\"color:#FF0000\"><u>more</u>&nbsp;&nbsp;</h3></a></td>"+
                 "</tr>"+
                 "<tr>"+
                 "<td colspan=\"2\">"+
                 "<ul>";	
	      var xml=db.QuerySQL("select name,icon from LSYSURL where REFID='"+DSMOD+"'");
	      for(var i=0;i<xml.getRowCount();i++){
			html+=  "<li style=\"color:#999999\">"+xml.getStringAt(i,"name")+"</li>";
			                              
	        }
		html+="</ul>"+
                "</td>"+
                 "</tr>"+
                "</table>"+
                "</div>";
                return html;
	}
	else if(DSMOD=="���䰸��"){
	   html="<div style=\"border:1px #999999 solid; width:100%; height:100%\">"+
                 "<table width=100%  height=100% border=\"0\">"+
	                 "<tr>"+
	                 "<td><h3 style=\"color:#FF0000\">&nbsp;&nbsp;&nbsp;&nbsp;"+DSMOD+"</h3></td>"+
	                  "<td><a href='#'><h3 align=\"right\" style=\"color:#FF0000\"><u>more</u>&nbsp;&nbsp;</h3></a></td>"+
	                 "</tr>"+   
	                 "<tr>"+
	                 	"<td style=\"border-right-color:#999999; border-right-style:solid; border-right-width:2px\">"+
	                	 "<ul>";	
		     			 var xml=db.QuerySQL("select name from LSYSURL where REFID='"+DSMOD+"'");
		     			 for(var i=0;i<xml.getRowCount();i++){
						html+=  "<li style=\"color:#999999\">"+xml.getStringAt(i,"name")+"</li>";
				                              
		       		 	}
				html+="</ul>"+
	               		 "</td>"+
	                
	                 	"<td>"+
		                	 "<ul>";	
			     		 var xml=db.QuerySQL("select name from LSYSURL where REFID='"+DSMOD+"'");
			      		for(var i=0;i<xml.getRowCount();i++){
						html+=  "<li style=\"color:#999999\">"+xml.getStringAt(i,"name")+"</li>";
					                              
			        	}
					html+="</ul>"+
	                	"</td>"+
	                 "</tr>"+
                "</table>"+
                "</div>";

		return html;
	}
	
	else if(DSMOD=="�����ν�"){
	   html="<div style=\"border:1px #999999 solid; width:100%; height:100%\">"+
                 "<table width=100% height=100% border=\"0\">"+
	                 "<tr>"+
	                 "<td><h3 style=\"color:#FF0000\">&nbsp;&nbsp;&nbsp;&nbsp;"+DSMOD+"</h3><a href='#'></td>"+
//	                 "<td><h3 align=\"right\" style=\"color:#FF0000\"><u>more</u>&nbsp;&nbsp;</h3></a></td>"+
	                 "</tr>"+   
	                 "<tr>"+
	                 	"<td >"+
	                	 "<ul>";	
		     			 var xml=db.QuerySQL("select name from LSYSURL where REFID='"+DSMOD+"' and seqid <=5");
		     			 for(var i=0;i<xml.getRowCount();i++){
						html+=  "<li style=\"color:#999999\">"+xml.getStringAt(i,"name")+"</li>";
				                              
		       		 	}
				html+="</ul>"+
	               		 "</td>"+
	                
	                 	"<td>"+
		                	 "<ul>";	
			     		 var xml=db.QuerySQL("select name from LSYSURL where REFID='"+DSMOD+"' and seqid between 6 and 10");
			      		for(var i=0;i<xml.getRowCount();i++){
						html+=  "<li style=\"color:#999999\">"+xml.getStringAt(i,"name")+"</li>";
					                              
			        	}
					html+="</ul>"+
	                	"</td>"+
	                 "</tr>"+
                "</table>"+
                "</div>";

		return html;
	}
	
	return html;

}
}