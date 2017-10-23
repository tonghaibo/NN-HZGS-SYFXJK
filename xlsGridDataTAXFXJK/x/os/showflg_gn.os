function x_showflg_gn(){
function gnlist(){
	
	var html="";
	var sql =SQL;
	html="<style type=\"text/css\">
		a:link { 
		color:#000000; 
		text-decoration:none; 
		} 
		a:visited { 
		color:#000000; 
		text-decoration:none; 
		} 
		a:hover { 
		color:#0166CB; 
		text-decoration:underline; 
		} 
		a:active { 
		color:#0166CB; 
		text-decoration:none; 
		} 
	</style>
	<div style=\"width:"+WIDTH+"; height:"+HEIGHT+"; border-radius:10px; background-image:url(EAFormBlob.sp?guid=27ECBF19F2F82993E050007F0100462A)\">
		<table width=\""+WIDTH+"\" style=\"  height:40px; border-bottom:1px #ccc solid; \" >
		  <tr>
		   <td align=\"left\" style=\"border-left:6px blue solid;\"><font style=\"font-family:'Î¢ÈíÑÅºÚ'; font-size:20px;  color:#233C90; margin-left:10px; \">"+TITLE+"</font></td>
		    <td align=\"right\"><font style=\"font-family:'Î¢ÈíÑÅºÚ'; font-size:14px\"><a  href=\""+MOREURL+"\" onfocus=\"this.blur()\">¸ü¶à></a></font></td>
		  </tr>
		</table>";
				
		var ds=db.QuerySQL(sql);
		var rowcount=0;
		if(ROWCNT*1>ds.getRowCount()*1){
			rowcount=ds.getRowCount();
		}
		else	
			rowcount=ROWCNT;		
		        
		for(var r=0; r<rowcount; r++){
		 	var id=ds.getStringAt(r,"guid");
		 	var name=ds.getStringAt(r,"title");
		 	var url=ds.getStringAt(r,"url");
		 	var dat=ds.getStringAt(r,"crtdat");

		   html+="<div style=\"height:"+LINE_HEIGHT+"; margin-left:5px; margin-right:5px;\">
			   <div style=\"line-height:"+LINE_HEIGHT+"; margin-left:10px; margin-right:10px\"><font style=\"font-family:'Î¢ÈíÑÅºÚ'; font-size:13px\">
				   <div style=\"float:left; width:10px\"></div><div style=\"float:left\"><a href=\""+url+"\" onfocus=\"this.blur()\">"+name+"</a></div>
				   <div style=\"float:right\">["+dat+"]</div></font>
			   </div>
		  	 </div>";
		 }
		html+="</div>";
	return html;
}
}