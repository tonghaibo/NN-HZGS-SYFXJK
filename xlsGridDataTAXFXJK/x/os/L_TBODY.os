function x_L_TBODY(){function GetBody()
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
	var context = db.getBlob2String("select b.bdata from LSYSURL a,formblob b where a.htmlguid=b.guid and a.guid='"+layhdrguid+"' ","bdata");
	html = "  
		<table   >
		<tr><td><h1 style=\"   text-align: center; \">"+title +"</h1></td></tr>
		 <tr><td align=center >"+crtdat+"</td></tr>
		 <tr><td><hr style=\"border-bottom: 1px solid #DFDFDF; padding-left: 4px; padding-right: 4px; padding-top: 1px; padding-bottom: 1px\" size=\"0\"></td></tr>
		 ";
	if(image!=""){
		html +="<tr><td align=center ><img src=\""+image +"\" border=\"0\"></td></tr>";
	}
	
	html+= "
		 <tr><td align=center ><table     width=90% style=\"text-align: left;\"  ><tr><td>"+context +" </td></tr></table></td></tr>
		</table>

		 ";
//	html = "<p align=\"center\"><b><font size=\"4\">БъЬт</font></b></p>
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
}