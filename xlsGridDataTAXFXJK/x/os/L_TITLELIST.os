function x_L_TITLELIST(){var pub = new JavaPackage("com.xlsgrid.net.pub");
function GetBody(){
	var html = "";
	if(LAYCOL =="")LAYCOL ="1";
	var sql = "select * from ( select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' "  ;
	if(WHEREBY!="" ) sql+= " AND " +WHEREBY;
	if(SORTBY!="" ) sql+= " "+SORTBY;
	else sql+= " order by crtdat desc ";
	if(LAYCOL !=""&& LAYROW!="" ) sql+=") where  rownum<"+LAYCOL+"*"+LAYROW;
	
//	return OSMWID;
//
//	return "deforg="+deforg+",WNDMOD="+WNDMOD+",DSMOD="+DSMOD+",WHEREBY="+WHEREBY+",SORTBY="+SORTBY
//	+",SQLTXT="+SQLTXT+",LAYCOL="+LAYCOL+" ,LAYROW="+LAYROW+",PAGEROW="+PAGEROW+" ,OSMWID="+OSMWID+",OSFUNC="+OSFUNC
//	+",OSPARAM="+OSPARAM+",IFRAMEURL="+IFRAMEURL+",IFSCROLLBAR="+IFSCROLLBAR+",HTMLGUID="+HTMLGUID+",MOREURL="+MOREURL
//	+",OPENLAYID="+OPENLAYID;
	
	// 自定义数据源SQL
	// 列名需要：guid,icon2,name,url,target
	if (SQLTXT != "") {
		sql = db.getBlob2String("select bdata from formblob where guid='"+SQLTXT+"'","bdata");
	}
	
	// "+WHEREBY +" "+SORTBY;
	var ds=db.QuerySQL(sql);
//	for(var i=0;i<ds.getRowCount();i++){
//		html+=  "<li style=\"color:#999999\"><a href='"+ds.get(i,"URL")+"' target='"+ds.get(i,"URL")+"'>"+ds.getStringAt(i,"name")+"</a></li>";
//	}

	html +="<table>";
		
	for(var i=0;i<ds.getRowCount();i++){

		html +="<tr>";
		
		html +="<td width=\"40\">";
		html +="<img src=\""+ds.getStringAt(i,"icon2")+"\" width=40 height=40/>";
		html +="</td>";
		
		html +="<td width=100% style=\"border-bottom: 1px dotted #C0C0C0; line-height:200%; line-width:100% \">";
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
}