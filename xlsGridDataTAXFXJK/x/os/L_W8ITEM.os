function x_L_W8ITEM(){function GetBody(){
var html = "";
	var sql = "select * from LSYSURL where icon is not null";
	var db = null;
	var width=120;
	var height=120;

	db = new pubpack.EADatabase();
	
	//表格标题
	var title = "商品";
	
	var itemds = db.QuerySQL(sql);
	
	var count = itemds.getRowCount();
	
	if(LAYROW=="" ) LAYROW=2;
	var trows = LAYROW;
	
	if(LAYCOL=="") LAYCOL =db.GetSQL("select ceil("+count+" / "+trows+") cols from dual");
	var tcols = LAYCOL;
	
	var tablewidth = 60+60*2+width*tcols;

	var tableheight = 60+height*trows;
	
//	html="<div style='overflow-x: auto; overflow-y: auto;width:500px; height=300px;'>";
	
	html += "<table id=\"XMIDWARE_MENU_TABLE\" class=\"XMIDWARE_MENU_TABLE\" border=\"0\" cellpadding=0 cellspacing=0 width=\""+tablewidth+"\" height=\""+tableheight+"\">\n";
	
	html += "<TR height=\"60\">\n
				<td width=\"60\" height=\"60\"><img border=0 src=\"http://xmidware.com/null.jpg\" width=\"60\" height=\"60\"></td>
				<td  colspan=\""+tcols+"\" align=\"left\"><font size=\"5\" color=\"#000000\"><div class=\"XMIDWARE_MENU_SHEETNAME\" >&nbsp;"+title+" ></div></font></td>
				<td width=\"60\" height=\"60\"><img border=\"0\" src=\"http://xmidware.com/null.jpg\" width=\"60\" height=\"60\"/></td>
			</TR>\n";
	
	
	var matds = getMatrix(trows,tcols);
	
	for (var r=0;r<trows;r++) {
		html += "<TR height=\""+height+"\">\n<td width=\"60\" height=\""+height+"\"><img border=0 src=\"http://xmidware.com/null.jpg\" width=\"60\" height=\""+height+"\"></td>";
		for (var c=0;c<tcols;c++) {
			var idx = 1 * matds.getStringAt(r,c);
			if (idx < count) {
				var id= itemds.getStringAt(idx,"id");
				var icon= itemds.getStringAt(idx,"ICON");
				var title = itemds.getStringAt(idx,"REFID");
				
				var note= itemds.getStringAt(idx,"name");
			
				var price ="";
				var hrefurl =itemds.getStringAt(idx,"url");
				
				html += gethdTableCellHtml(width,height,icon,"",price,hrefurl,"");//宽
				html += "\n";
				
			}
		}
		html += "</TR>\n";

	}
	html += "</TABLE>\n\n";
		
	return html;

}
}