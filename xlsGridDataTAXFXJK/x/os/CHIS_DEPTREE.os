function x_CHIS_DEPTREE(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

//
// 
//
function GetBody()
{
	var html = "";
	
	html += "<style type=\"text/css\">
			#vertmenu {
				font-family: Verdana, Arial, Helvetica, sans-serif;
				font-size: 100%;
				width: 30%;
				padding: 0px;
				margin: 0px;
				float:left;
				height:1000px;
				}
				
				#vertmenu h1 {
				display: block; 
				background-color:#FF9900;
				font-size: 90%; 
				padding: 1px 0 3px 3px;
				border: 1px solid #000000;
				color: #333333;
				margin: 0px;
				width:100%;
				}
				
				#vertmenu ul {
				list-style: none;
				margin: 0px;
				padding: 0px;
				border: none;
				}
				#vertmenu ul li {
				margin: 0px;
				padding: 0px;
				}
				#vertmenu ul li a {
				font-size: 80%;
				display: block;
				border-bottom: 1px dashed #C39C4E;
				padding: 5px 0px 2px 4px;
				text-decoration: none;
				color: #666666;
				width:100%;
				}
				
				#vertmenu ul li a:hover, #vertmenu ul li a:focus {
				color: #000000;
				background-color: #eeeeee;
				}
			</style>";
	var db = null;
	var ds = null;
	var first = "";
	var sql = "select * from yx_docdept where org='CHIS' and refid is null order by to_number(id)";
	db = new pubpack.EADatabase();
	ds = db.QuerySQL(sql);
	
	html += "
		<div id=\"vertmenu\"> 
		<h1>“Ω‘∫ø∆ “</h1>
		<ul>";
	for (var r = 0; r <ds.getRowCount(); r++) {
		var id = ds.getStringAt(r,"id");
		if(r == 0) first = id;
		var name = ds.getStringAt(r,"name");
		html += "<li><a href=\"#\" onclick=\"getDepDoc()\" tabindex="+r+">"+name+"</a></li>";
	}
		
	html += "
		</ul>
		</div>
		<div id=\"depDoc\" style=\"float:left; width:65%; height:100%;margin-left:10px;border-left:1px solid gray;\"></div>
	";
	
	var parent = new x_CHIS_FG_MEET();
	
	var resHtml = parent.GetBody();
	
	html += "
		<script>
			function getDepDoc() {
				document.getElementById(\"depDoc\").innerHTML = "+resHtml+";
			}
		</script>
	";
	return html;
}

}