function x_CHIS_PAIT(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//加载类包 
//
// 
//
function GetBody(){
	
	var html = "";
	var db = null;
	var ds = "";
	var sql = "";
	try {
		db = new pubpack.EADatabase();
		sql="select id,name,CRTDAT from usr where org='SNPTC'";
		ds=db.QuerySQL(sql);
		
		//throw new Exception(sql);
		
		if(ds.getRowCount()==0){
			
		}
		
		//<hr style=\"border:0.5px #CCCCCC solid;margin-left:10px; margin-right:10px\"></hr>
		if(ds.getRowCount()>0){
			html = "
				<html>
				<head>
				<meta http-equiv=\"Content-Language\" content=\"zh-cn\">
				<meta http-equiv=\"Content-Type\" content=\"textml; charset=gb2312\">
				</head>
				<body>
				
			";
			for(var i =0;i<ds.getRowCount();i++){
			
			var name  = ds.getStringAt(i,"name");
			var dat = ds.getStringAt(i,"CRTDAT");
			html += "
				
					<table style=\"border:1px #CCCCCC solid;border-width:1px 0px 0px 0px;\" width=\"90%\" height=\"101\" align=center>
				
					<tr>
						<td rowspan=2 width=\"50%\"><IMG SRC=\"xlsgrid/images/flash/icon/icon_103.png\"></td>
						<td width=\"50%\" valign=bottom align=\"center\">"+name+"</td>
					</tr>
					<tr>
						<td width=\"50%\" valign=top align=\"center\" >"+dat+"</td>
					</tr>
					
					</table>
				";
			}
			html += "
			</body>
			</html>
			";
		}
		return html;
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	
	
}
}