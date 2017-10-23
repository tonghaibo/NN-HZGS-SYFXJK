function x_L_IMGTEXT(){function GetBody(){
	var html = "";
	var sql = "select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' order by crtdat desc "  ;
	
	var ds=db.QuerySQL(sql);
	var count =0;
	if(ds.getRowCount()>LAYROW){
		count = LAYROW;
	}else{
		count = ds.getRowCount();
	}
	
	for (var r =0;r < count; r ++) {
		var txt = "txt";
		var img = ds.getStringAt(r,"icon");
		var name = ds.getStringAt(r,"name");
		var htmlguid=ds.getStringAt(r,"htmlguid");
		var contextes=ds.getStringAt(r,"contextes");
		var context = db.getBlob2String("select b.bdata from LSYSURL a,formblob b where a.htmlguid=b.guid and a.htmlguid='"+htmlguid+"'","bdata");
		
		var url = ds.getStringAt(r,"url");
		if (url != "") {
			url += "&layhdrguid="+ds.getStringAt(r,"GUID");
		}
		txt=txt+r;
		html += "<table valign=\"top\" cellpadding=\"5\">";
		html += "<tr>";
		html += "<td><img src=\""+img+"\" width=\"200\" height=\"200\"/></td>";
		html += "<td valign=\"top\">";
		html += "<table  width=\"100%\">";
		html += "<tr>";
		html += "<td><h3>"+name+"</h3></td>";
		html += "</tr>";
		html += "<tr>";
		html += "<td height=\"40\"></td>";
		html += "</tr>";
		html += "<tr>";
		html += "<td id=\""+txt+"\">";
		html += "<a href=\""+url+"\">"+contextes+"</a>";	
		html += "</td>";
		html += "</tr>";
		html += "</table>";
		html += "</td>";
		html += "</tr>";
		html += "<tr>";
		html += "<td colspan=2><hr style=\"border-top:1px dashed #cccccc; height:1px\"></td>";
		html += "</tr>";
		html += "</table>";
	}

//	html += "
//			<script>
//				window.onload = function(){
//					for (var r=0;r<"+count+";r++) {
//						var txt = \"txt\";
//						txt=txt+r;
//						 var text = document.getElementById(txt),
//						 str = text.innerHTML,
//						 textLeng = 400;
//					
//						 if(str.length > textLeng ){
//							   text .innerHTML = str.substring(0,textLeng)+\"。。。。\";
//						 } 
//					 }
//				 }
//			 </script>
//			";
//
	return html;

}


//	var html = "";
//	var sql = "select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' order by crtdat desc "  ;
//	
//	var ds=db.QuerySQL(sql);
//	var count =0;
//	if(ds.getRowCount()>LAYROW){
//		count = LAYROW;
//	}else{
//		count = ds.getRowCount();
//	}
//	
//	for (var r =0;r < count; r ++) {
//		var txt = "txt";
//		var img = ds.getStringAt(r,"icon");
//		var name = ds.getStringAt(r,"name");
//		var htmlguid=ds.getStringAt(r,"htmlguid");
//		var context = db.getBlob2String("select b.bdata from LSYSURL a,formblob b where a.htmlguid=b.guid and a.htmlguid='"+htmlguid+"'","bdata");
//	
//		var url = ds.getStringAt(r,"url");
//		if (url != "") {
//			url += "&layhdrguid="+ds.getStringAt(r,"GUID");
//		}
//		txt=txt+r;
//		html += "<table width=\"100%\"   height=\"100%\" valign=\"top\" cellpadding=\"5\">";
//		html += "<tr>";
//		html += "<td><div  style=\" float:left;\"><img src=\""+img+"\" width=\"200\" height=\"200\"/></div>";
//		html += "<table ><tr><td><table align=\"center\"><tr><td><h3>"+name+"</h3></td></tr></table>";
//		html += "</td></tr><tr><td><a href=\""+url+"\">"+context.substring(0,400)+"</a></td></tr></table></td></tr></table>";
//
//	}
}