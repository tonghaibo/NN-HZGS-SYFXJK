function x_L_TITLEPAGE(){function GetBody(){
	var html = "";
	var sql = "select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' order by crtdat desc "  ;
	var ds=db.QuerySQL(sql);
	
	html += "<script src=\"http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js\"></script>";
	html += "<script >
		    $(document).ready(function(){
		            $(\"#ol ul li:gt(10)\").hide();//��ʼ����ǰ��4��������ʾ���������������ء�
		            var total_q=$(\"#ol ul li\").index()+1;//������
		            
		            var current_page=10;//ÿҳ��ʾ������
		            var current_num=1;//��ǰҳ��
		            var total_page= Math.round(total_q/current_page);//��ҳ��  
		            var next=$(\".next\");//��һҳ
		            var prev=$(\".prev\");//��һҳ
		            $(\".total\").text(total_page);//��ʾ��ҳ��
		            $(\".current_page\").text(current_num);//��ǰ��ҳ��
		             
		            //��һҳ
		            $(\".next\").click(function(){
		                if(current_num==total_page){
		                        return false;//���������ҳ���ͽ�����һҳ
		                    }
		                    else{
		                        $(\".current_page\").text(++current_num);//�����һҳ��ʱ��ǰҳ����ֵ�ͼ�1
		                        $.each($('#ol ul li'),function(index,item){
		                            var start = current_page* (current_num-1);//��ʼ��Χ
		                            var end = current_page * current_num;//������Χ
		                            if(index >= start && index < end){//�������ֵ����start��end֮���Ԫ�ؾ���ʾ���������
		                                $(this).show();
		                            }else {
		                                $(this).hide(); 
		                            }
		                        });
		                    }
		            });
		            //��һҳ����
		            $(\".prev\").click(function(){
		                    if(current_num==1){
		                        return false;
		                    }else{
		                        $(\".current_page\").text(--current_num);
		                        $.each($('#ol ul li'),function(index,item){
		                            var start = current_page* (current_num-1);//��ʼ��Χ
		                            var end = current_page * current_num;//������Χ
		                            if(index >= start && index < end){//�������ֵ����start��end֮���Ԫ�ؾ���ʾ�����������
		                                $(this).show();
		                            }else {
		                                $(this).hide(); 
		                            }
		                        });     
		                    }
		                     
		                })
		    })
		</script>";
	
	html += "<style>
		    .main{width:100%;zoom:1;margin:0 auto;}
		    .item{width:100%;overflow:hidden;}
		   
		    .clear{zoom:1;}
		    .clear:after{content:\"\";display:block;height:0;clear:both;visibility:hidden;}
		    
		    .page_btn{padding-top:20px;}
		    .page_btn a{cursor:pointer;padding:5px;border:solid 1px #ccc;font-size:12px;}
		    .page_box{float:right;}
		    .num{padding:0 10px;}
		</style>";
	
	
	html += "<div class=\"main\">";
	html += "<div class=\"item\" id=\"ol\">";
	html += "<ul class=\"clear\">";
	for (var r = 0; r < ds.getRowCount(); r ++) {
		var icon = ds.getStringAt(r,"icon");
		var name = ds.getStringAt(r,"name");
		var url = ds.getStringAt(r,"url");

		if (url != "") {
			url = "L.sp?id="+OPENLAYID+"&layhdrguid="+ds.getStringAt(r,"GUID");
			html += "<li><a target=\""+ds.getStringAt(r,"target")+"\" href=\""+url+"\">"+name+"</a></li>";
		} else {
			html += "<li>"+name+"</li>";
		}
	}
	html += "</ul>";
	html += "</div>";
	html += "<div class=\"page_btn clear\">";
	html += "<span class=\"page_box\">";
	html += "<a class=\"prev\">��һҳ</a><span class=\"num\"><span class=\"current_page\">1</span><span style=\"padding:0 3px;\">/</span><span class=\"total\"></span></span><a class=\"next\">��һҳ</a>";
	html += "</span>";
	html += "</div>";
	html += "</div>";
	
	return html;

}
}