function x_ajax1(){

//��ʾ��ѯ����ǰԤ����
//�����ڲ�ѯ�򱨱���ʾ��ѯ����ǰ��Ԥ����
//������sb��StringBuffer����append HTML���ݻ���⸽���ű�
//�����޸�paramDs�����ݣ�������Щ�����ɼ����޸�Ĭ��ֵ
//  ID:���;  NAME:����; KEYVAL:�ؼ���; SQLWHE:WHERE����; DEFVAL:Ĭ��ֵ
//  TIP:��ʾ; EDTFLG:�Ƿ���޸�;  VISFLG:�Ƿ����ʾ; KEYFLG:�ؼ��ֶ�(û������)
//  DISPORD:������ʾ�����(�޸���Ч); INPCTL:�ؼ�����
function beforeShowParam(request,sb,paramDs,usrinfo)
//var request=javax.servlet.http.HttpServletRequest(); var sb = new java.lang.StringBuffer();var paramDs = new EAXmlDS();var usrinfo = new web.EAUserinfo();
{
//	sb.append("<script type='text/javascript' src='xlsgrid/js/jquery-1.3.1.js'></script>\n");  
	sb.append("<script type='text/javascript' src='xlsgrid/js/jquery-132min2.js'></script>\n"); //ѹ����
//	sb.append("<script language='javascript' src='xlsgrid/js/svgchart.js' ></Script>\n");
	sb.append("<script type='text/javascript'>");
	//Ϊ����ҳ�����ʹ�ÿͻ��˿ؼ�
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
						alert(arguments[1]); //�м��ƽ̨���ص�XML��encoding=GBK,��ajaxҪ����utf-8
						//alert(XMLResponse.responseText)
					},
					success:function(xml) {
						var id,name;
						//alert(xml);
						$(\"select[name=usrid]\").empty();// ���������
//						$(xml).find('ROW').each(function(){	//��IE�½���XML��ʽ���������⣬FIREFOX������
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