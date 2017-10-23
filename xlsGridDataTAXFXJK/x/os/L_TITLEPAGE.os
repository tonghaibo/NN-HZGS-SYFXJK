function x_L_TITLEPAGE(){function GetBody(){
	var html = "";
	var sql = "select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' order by crtdat desc "  ;
	var ds=db.QuerySQL(sql);
	
	html += "<script src=\"http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js\"></script>";
	html += "<script >
		    $(document).ready(function(){
		            $(\"#ol ul li:gt(10)\").hide();//初始化，前面4条数据显示，其他的数据隐藏。
		            var total_q=$(\"#ol ul li\").index()+1;//总数据
		            
		            var current_page=10;//每页显示的数据
		            var current_num=1;//当前页数
		            var total_page= Math.round(total_q/current_page);//总页数  
		            var next=$(\".next\");//下一页
		            var prev=$(\".prev\");//上一页
		            $(\".total\").text(total_page);//显示总页数
		            $(\".current_page\").text(current_num);//当前的页数
		             
		            //下一页
		            $(\".next\").click(function(){
		                if(current_num==total_page){
		                        return false;//如果大于总页数就禁用下一页
		                    }
		                    else{
		                        $(\".current_page\").text(++current_num);//点击下一页的时候当前页数的值就加1
		                        $.each($('#ol ul li'),function(index,item){
		                            var start = current_page* (current_num-1);//起始范围
		                            var end = current_page * current_num;//结束范围
		                            if(index >= start && index < end){//如果索引值是在start和end之间的元素就显示，否则就隐
		                                $(this).show();
		                            }else {
		                                $(this).hide(); 
		                            }
		                        });
		                    }
		            });
		            //上一页方法
		            $(\".prev\").click(function(){
		                    if(current_num==1){
		                        return false;
		                    }else{
		                        $(\".current_page\").text(--current_num);
		                        $.each($('#ol ul li'),function(index,item){
		                            var start = current_page* (current_num-1);//起始范围
		                            var end = current_page * current_num;//结束范围
		                            if(index >= start && index < end){//如果索引值是在start和end之间的元素就显示，否则就隐藏
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
	html += "<a class=\"prev\">上一页</a><span class=\"num\"><span class=\"current_page\">1</span><span style=\"padding:0 3px;\">/</span><span class=\"total\"></span></span><a class=\"next\">下一页</a>";
	html += "</span>";
	html += "</div>";
	html += "</div>";
	
	return html;

}
}