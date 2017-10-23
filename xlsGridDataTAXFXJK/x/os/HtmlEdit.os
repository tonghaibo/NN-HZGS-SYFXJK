function x_HtmlEdit(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );//加载类包 
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" ); 


  //在Head区引用额外脚本

function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	var ret = "<link rel=\"stylesheet\" href=\"../kindeditor-4.1.7/themes/default/default.css\" />
		<link rel=\"stylesheet\" href=\"../kindeditor-4.1.7/plugins/code/prettify.css\" />
		<script charset=\"utf-8\" src=\"../kindeditor-4.1.7/kindeditor.js\"></script>
		<script charset=\"utf-8\" src=\"../kindeditor-4.1.7/lang/zh_CN.js\"></script>
		<script charset=\"utf-8\" src=\"../kindeditor-4.1.7/plugins/code/prettify.js\"></script>
		<script>
			var editor;
			KindEditor.ready(function(K) {
				var editor1 = K.create('textarea[name=\"content1\"]', {
					cssPath : '../kindeditor-4.1.7/plugins/code/prettify.css',
					uploadJson : '../kindeditor-4.1.7/jsp/upload_json.jsp',
					fileManagerJson : '../kindeditor-4.1.7/jsp/file_manager_json.jsp',
					allowFileManager : true,
					afterCreate : function() {
						var self = this;
						K.ctrl(document, 13, function() {
							self.sync();
							document.forms['example'].submit();
						});
						K.ctrl(self.edit.doc, 13, function() {
							self.sync();
							document.forms['example'].submit();
						});
					}
				});
				editor = editor1;
				prettyPrint();
			});
			</script>";
	
	sb.append(ret) ;
	sb.append("<table border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"10\" height=\"100%\"><tr><td bgcolor=\"#EFEFEF\" align=center valign=middle>");
	sb.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" ><tr><td  style=\"border: 1px solid #EEEEEE\">	");
	sb.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" ><tr><td width=100% height=5% style=\"border: 1px solid #DEDEDE;\">");


}


//添加额外html
//afterBodyHtml事件后触发，已过时，建议用afterBodyHtml事件进行处理
function addBottomHtml(mwobj,request,sb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("</td><tr><td width=100% bgcolor=\"#FEFEFE\" style=\"border: 1px solid #DEDEDE\" align=left valign=top>");
	// 这里是HTML正文内容
	sb.append("<table border=\"0\" width=\"100%\" height=\"50\" cellspacing=\"\" cellpadding=\"5\" >");
	sb.append("<tr><td align=right colspan=3>");
	sb.append("<textarea id = \"content1\" name=\"content1\" line-height=\"3px\" style=\"width:100%;height:550;\"></textarea>");
	sb.append("</td></tr></table>");
	//==================
	sb.append("</td></tr></table>");
	sb.append("</td></tr></table></td></tr></table>");
}







}