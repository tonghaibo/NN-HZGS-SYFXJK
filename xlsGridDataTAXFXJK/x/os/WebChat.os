function x_WebChat(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function showMsgList()
{
	var html ="<table>";
		
	for(var i=0;i<9;i++){
		var title = "¹Ø×¢ºÅ "+(i+1);
		html +="<tr>";
		
		html +="<td width=\"40\">";
		html +="<img src=\"xlsgrid/images/icon/1.png\" width=40 height=40/>";
		html +="</td>";
		
		html +="<td width=100% style=\"border-bottom: 1px dotted #C0C0C0; line-height:200%; line-width:100% \">";
		var url = "L.sp?id=test&layhdrguid=";
		html +="<a href='"+url+"' >"+title+"</a>";

		html +="</td>";
		html +="</tr>";

	} 			
		
	html +="</table>";
	return html;

}

function GetBody()
{

}
}