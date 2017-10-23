function x_ajax1(){

//显示查询参数前预处理
//用于在查询或报表显示查询参数前的预处理。
//可以往sb（StringBuffer）中append HTML内容或额外附近脚本
//可以修改paramDs的内容，决定哪些参数可见或修改默认值
//  ID:编号;  NAME:标题; KEYVAL:关键字; SQLWHE:WHERE条件; DEFVAL:默认值
//  TIP:提示; EDTFLG:是否可修改;  VISFLG:是否可显示; KEYFLG:关键字段(没有作用)
//  DISPORD:参数显示次序号(修改无效); INPCTL:控件类型
function beforeShowParam(request,sb,paramDs,usrinfo)
//var request=javax.servlet.http.HttpServletRequest(); var sb = new java.lang.StringBuffer();var paramDs = new EAXmlDS();var usrinfo = new web.EAUserinfo();
{
//	sb.append("<script type='text/javascript' src='xlsgrid/js/jquery-1.3.1.js'></script>\n");  
	sb.append("<script type='text/javascript' src='xlsgrid/js/jquery-132min2.js'></script>\n"); //压缩版
//	sb.append("<script language='javascript' src='xlsgrid/js/svgchart.js' ></Script>\n");
	sb.append("<script type='text/javascript'>");
	//为了在页面可以使用客户端控件
	sb.append("function CreateControl(ObjectID, WIDTH, HEIGHT){
		  	document.write( '<object classid=clsid:37CC6FCD-9BF5-4433-B3F3-576E08025EA8 id=' + ObjectID  
		   	+ ' width=' + WIDTH + ' height=' + HEIGHT +'>'+'</OBJECT>');
		    }
		    CreateControl('svg','100%','100%');
		    var _this = document.getElementById('svg');
	");
	
	sb.append("
		$(document).ready(function() {
			$(\"select[name=orgid]\").bind(\"change\",null,function(){
//                		alert(\"select changed.\"+$(this).val());
                		var orgid = $(this).val();

				$.ajax({
					type:'GET',
					url:\"XmlDB.sp?bind=V_MYUSR&where=oid='\"+orgid+\"'&collist=id,name\",
					dataType:'text/xml',
					error:function(XMLResponse){
						alert(arguments[1]); //中间件平台返回的XML的encoding=GBK,而ajax要求是utf-8
						//alert(XMLResponse.responseText)
					},
					success:function(xml) {
						var id,name;
						//alert(xml);
						$(\"select[name=usrid]\").empty();// 清空下拉框
//						$(xml).find('ROW').each(function(){	//在IE下解释XML格式数据有问题，FIREFOX下正常
//							id = $(this).children('ID').text();
//							name = $(this).children('NAME').text();
//							alert('usri='+id+' usrname='+name);
//							//$(\"<option value='\"+id+\"'>\"+name+\"</option>\").appendTo(\"select[name=usrid]\");
//							$(\"select[name=usrid]\").append(\"<option value='\"+id+\"'>\"+name+\"</option>\");
//							
//						});
						_this.XMLDS_Reset();
						_this.XMLDS_Parse(xml);
						for (var i=0;i<_this.XMLDS_GetRowCount();i++) {
							var id = _this.XMLDS_GetString(i,\"ID\");
							var name = _this.XMLDS_GetString(i,\"NAME\");
							$(\"select[name=usrid]\").append(\"<option value='\"+id+\"'>\"+name+\"</option>\");
						}
					}
				});

				
            		});
        	});
	
	
	");
	sb.append("</script>
	");
}


}