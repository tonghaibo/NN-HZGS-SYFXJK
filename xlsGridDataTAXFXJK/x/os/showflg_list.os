function x_showflg_list(){

var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var pub= new JavaPackage ( "com.xlsgrid.net.pub" );
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var EAScript= new JavaPackage ( "com.xlsgrid.net.pub.EAScript");
var langpack = new JavaPackage ( "java.lang");
//文字列表分页
function titlepage(){
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

//多列标题栏测试div
function toublelist1(){
var html = "";
	var sql = "select * from ( select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' "  ;
	if(WHEREBY!="" ) sql+= " AND " +WHEREBY;
	if(SORTBY!="" ) sql+= " "+SORTBY;
	else sql+= " order by crtdat desc ";
	if(LAYCOL !=""&& LAYROW!="" ) sql+=") where  rownum<"+LAYCOL+"*"+LAYROW;
	sql+=")";
	// "+WHEREBY +" "+SORTBY;
	var ds=db.QuerySQL(sql);
	html += "<div style=\"background-color:#E5E5E5;\">";
	var n = 0;
	var val = "";
	
	for (var r=0;r<LAYCOL;r++) {
		html +="<table>";
		for (var i=0;i<LAYROW;i++) {
		html += "<tr><td>";
		html += "<div style=\"height:20px; padding:2px;\">";
			if (n < ds.getRowCount()) {
				val = ds.getStringAt(n,"name");
				var dat = ds.getStringAt(n,"crtdat");
				if (ds.getStringAt(n,"icon") != "") {
					html +="<img src=\""+ds.getStringAt(n,"icon")+"\" width=20 height=20/>";
				}
				var url = ds.getStringAt(n,"url") ;
				if(OPENLAYID!=""){
					url = "L.sp?id="+OPENLAYID+"&layhdrguid="+ds.getStringAt(n,"GUID");
				}
				
				if (ds.getStringAt(n,"url") != "") {
					html +="<a href=\""+url+"\" target=\""+ds.getStringAt(n,"target")+"\">"+val+"</a>";
				} else {
					html +=val;
				}

			} else {
				break;
			}
			n++;
			
		html += "</td></tr></table>";
		}
		html += "</div>";

	}
	html += "</div>";


}

//多列型的标题列表
function toublelist(){
		var sql = "select * from ( select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' "  ;
	if(WHEREBY!="" ) sql+= " AND " +WHEREBY;
	if(SORTBY!="" ) sql+= " "+SORTBY;
	else sql+= " order by crtdat desc ";
	if(LAYCOL !=""&& LAYROW!="" ) sql+=") where  rownum<"+LAYCOL+"*"+LAYROW;
	sql+=")";
	// "+WHEREBY +" "+SORTBY;
	var ds=db.QuerySQL(sql);
	html += "<div style=\"background-color:#E5E5E5;\">";
	var n = 0;
	var val = "";
	
	for (var r=0;r<LAYCOL;r++) {
		html +="<table>";
		for (var i=0;i<LAYROW;i++) {
		html += "<tr><td>";
		html += "<div style=\"height:20px; padding:2px;\">";
			if (n < ds.getRowCount()) {
				val = ds.getStringAt(n,"name");
				var dat = ds.getStringAt(n,"crtdat");
				if (ds.getStringAt(n,"icon") != "") {
					html +="<img src=\""+ds.getStringAt(n,"icon")+"\" width=20 height=20/>";
				}
				var url = ds.getStringAt(n,"url") ;
				if(OPENLAYID!=""){
					url = "L.sp?id="+OPENLAYID+"&layhdrguid="+ds.getStringAt(n,"GUID");
				}
				
				if (ds.getStringAt(n,"url") != "") {
					html +="<a href=\""+url+"\" target=\""+ds.getStringAt(n,"target")+"\">"+val+"</a>";
				} else {
					html +=val;
				}

			} else {
				break;
			}
			n++;
			
		html += "</td></tr></table>";
		}
		html += "</div>";

	}
	html += "</div>";
}

//左边带图片单列列表(简约型的列表)
function titlelist(){
var html = "";
	

	var sql = " select * from ( select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' "  ;
	if(WHEREBY!="" ) sql+= " AND " +WHEREBY;
	if(SORTBY!="" ) sql+= " "+SORTBY;
	else sql+= " order by crtdat desc ";

	if(LAYCOL !=""&& LAYROW!="" ) sql+= " ) where  rownum<"+LAYCOL+"*"+LAYROW;
	else sql+=")";
	// "+WHEREBY +" "+SORTBY;
	//直接ＳＱＬ查询
	if (SQLTXT != "") sql = SQLTXT;
	var ds=db.QuerySQL(sql);
	html += "<table valign=\"top\" width=100% >";
	html += "<tr>";
	var n = 0;
	var val = "";
	if(LAYCOL == "" ) LAYCOL = "1";
	if(LAYROW == "" ) LAYROW = "20";
	if(maxtitlelen==null||maxtitlelen=="null")maxtitlelen = "";
	if(borderstyle==null||borderstyle=="null")borderstyle= "";
	//=0(默认)无边框线 =1 下方虚线 =2 表格线
	var sBorderStyle = "border-bottom: 1px dotted #C0C0C0;";
	if(borderstyle=="0")
		sBorderStyle = "";
	if(borderstyle=="2") sBorderStyle = "border: 1px solid #C0C0C0;";

	if(rowheight==null||rowheight=="null"||rowheight=="")rowheight= "30";
	if(cellbkcolor==null||cellbkcolor=="null")cellbkcolor= "";
	var sCellBkColorStyle = "";
	if(cellbkcolor!="")sCellBkColorStyle  = "bgcolor=\""+cellbkcolor+"\"";
	
	for (var r=0;r<LAYCOL;r++) {
		html += "<td valign=\"top\"  >";
		html +="<table width=100%>";
		for (var i=0;i<LAYROW;i++) {
			if (n < ds.getRowCount()) {
				val = ds.getStringAt(n,"name");
				if(maxtitlelen !="") {
					if(val.length()>maxtitlelen) 
						val = val.substring(0,maxtitlelen )+"...";
				}
				var dat = ds.getStringAt(n,"crtdat");
				html +="<tr height=\""+rowheight+"\">";
				html +="<td "+sCellBkColorStyle +" >";
				html +="<table cellpadding=\"0\" cellspacing=\"0\" width=100%>";
				html +="<tr height="+rowheight+">";
				var icon = ds.getStringAt(n,"icon2") ;
				if (icon  != "") {
					html +="<td width=\"30\" style=\""+sBorderStyle +"\">";
					if(icon.substring(0,9)=="glyphicon" ) 
						html +="<span class='"+icon+"'></span>";
					else if(icon.substring(0,1)=="<" ) 
						html +=icon;
					else html +="<img src=\""+ds.getStringAt(n,"icon")+"\" width=20 height=20/>";
					html +="</td>";
				}
				
				html +="<td style=\""+sBorderStyle +"\" align=left >";
				var url = ds.getStringAt(n,"url") ;
				if(OPENLAYID!=""){
					url = "L.sp?id="+OPENLAYID+"&layhdrguid="+ds.getStringAt(n,"GUID");
				}
				
				if (ds.getStringAt(n,"url") != "") {
					html +="<a href=\""+url+"\" target=\""+ds.getStringAt(n,"target")+"\">"+val+"</a>";
				} else {
					html +=val;
				}
				html +="</td>";
				html +="</tr>";
				html +="</table>";
				html +="</td>";
				html +="</tr>";
			} else {
				break;
			}
			n++;
		}
		
		html +="</table>";
		html +="</td>";
	}
	html += "</tr>";
	html += "</table>";
	
	return html;
}
//
// 
//
function crttable(){

	var sql="";
	var trbgcolor="#F9F9F9";
	var tdborder=0;
//	TB_ENTBTYP=true;
	var html="<table id=\"mytable\" borderColor=\"\" align=\"center\" width=\""+TB_WIDTH+"\" height=\""+TB_HEIGHT+"\" cellspcing=\"2\" cellpadding=\"2\" style=\"border-collapse:collapse;line-height:"+LINE_HEIGHT+"\" >
        <tbody id=\"table2\" >";
	 
	if(SQLTXT!=""){
		sql=SQLTXT;
		sql=pub.EAFunc.Replace(sql,"#$amp;","&");
		sql=pub.EAFunc.Replace(sql,"<","<");
		sql=pub.EAFunc.Replace(sql,">",">");
		sql=web.EASession.GetSysValue(sql,request);//替换request 中[%id]
		sql=web.EASession.GetSysValue(sql,web.EASession.GetUserinfo(request));

		var ds=db.QuerySQL(sql);
		var style="";
		if(TB_IFHEADBORDER=="true"){
			style="style=\"border:solid "+TB_BORDERCOLOR+"; border-width:1px 1px 1px 1px; font-size: 20px;\"";
		}
		if(TB_IFHEAD=="true"){
			html+="<tr><td align=\"center\" "+style+" colspan=\""+ds.getColumnCount()+"\">"+TB_HEAD+"</td></tr>";
		}
		for(var r=0; r<ds.getRowCount(); r++){
			if(r==0){
				html+="<tr bgcolor=\""+TB_ROLBGCOLOR+"\">";
				for(var c=0;c<ds.getColumnCount();c++){
					html+="<td style=\"border:solid "+TB_BORDERCOLOR+"; border-width:1px 1px 1px 1px;\">"+ds.getColumnName(c)+"</td>";
				}
				html+="</tr>";
			}
			if(TB_TABLW=="true"&&r%2==1) trbgcolor="#F9F9F9"; else trbgcolor="#FFFFFF";
			if(TB_ENTBTYP=="true") tdborder=0;  else tdborder=1;
			html+="<tr bgcolor=\""+trbgcolor+"\">";
			for(var c=0;c<ds.getColumnCount();c++){
				if(c==0&&ds.getColumnCount()>1)
					html+="<td style=\"border:solid "+TB_BORDERCOLOR+"; border-width:1px "+tdborder+"px 1px 1px;\">"+ds.getStringAt(r,c)+"</td>";
				else if(c==ds.getColumnCount()-1)
					html+="<td style=\"border:solid "+TB_BORDERCOLOR+"; border-width:1px 1px 1px "+tdborder+"px;\">"+ds.getStringAt(r,c)+"</td>";
				else
					html+="<td style=\"border:solid "+TB_BORDERCOLOR+"; border-width:1px "+tdborder+"px 1px "+tdborder+"px;\">"+ds.getStringAt(r,c)+"</td>";
				
			}
			html+="</tr>";

		}
	}
	
	html+="</tbody></table>";
	if(TB_ISPAGE=="true"){			
		html+="<div align=\"center\" style=\"margin-top:15px\">
		  <span id=\"spanFirst\">第一页</span> 
		  <span id=\"spanPre\">上一页</span> 
		  <span id=\"spanNext\">下一页</span> 
		  <span id=\"spanLast\">最后一页</span> 
		  第<span id=\"spanPageNum\"></span>页/共<span id=\"spanTotalPage\"></span>页
	      </div>
		      <script>
			      var theTable = document.getElementById(\"table2\");
			      var totalPage = document.getElementById(\"spanTotalPage\");
			      var pageNum = document.getElementById(\"spanPageNum\");
			 
			      var spanPre = document.getElementById(\"spanPre\");
			      var spanNext = document.getElementById(\"spanNext\");
			      var spanFirst = document.getElementById(\"spanFirst\");
			      var spanLast = document.getElementById(\"spanLast\");
			 
			      var numberRowsInTable = theTable.rows.length;
			      var pageSize =10;
			      var page = 1;
				  
			     //下一页
			      function next() {
			         hideTable();
			         currentRow = pageSize * page;
			          maxRow = currentRow + pageSize;
			          if (maxRow > numberRowsInTable) maxRow = numberRowsInTable;
			          for (var i = currentRow; i < maxRow; i++) {
			              theTable.rows[i].style.display = '';
			          }
			          page++;
			         if (maxRow == numberRowsInTable) { nextText(); lastText(); }
			          showPage();
			          preLink();
			          firstLink();
			      }
			     //上一页
			      function pre() {
			         hideTable();
			         page--;
			         currentRow = pageSize * page;
			          maxRow = currentRow - pageSize;
			          if (currentRow > numberRowsInTable) currentRow = numberRowsInTable;
			          for (var i = maxRow; i < currentRow; i++) {
			              theTable.rows[i].style.display = '';
			          }
			         if (maxRow == 0) { preText(); firstText(); }
			          showPage();
			          nextLink();
			          lastLink();
			      }
			     //第一页
			      function first() {
			          hideTable();
			          page = 1;
			          for (var i = 0; i < pageSize; i++) {
			              theTable.rows[i].style.display = '';
			          }
			          showPage();
			          preText();
			          nextLink();
			          lastLink();
			      }
			     //最后一页
			      function last() {
			          hideTable();
			          page = pageCount();
			          currentRow = pageSize * (page - 1);
			          for (var i = currentRow; i < numberRowsInTable; i++) {
			              theTable.rows[i].style.display = '';
			          }
			          showPage();
			          preLink();
			          nextText();
			          firstLink();
			      }
			
			     function hideTable() {
			          for (var i = 0; i < numberRowsInTable; i++) {
			              theTable.rows[i].style.display = 'none';
			          }
			      }
			     function showPage() {
			          pageNum.innerHTML = page;
			      }
			     //总共页数
			      function pageCount() {
			          var count = 0;
			          
			          if (numberRowsInTable % pageSize != 0) count = 1;
			          return parseInt(numberRowsInTable / pageSize) + count;
			      }
			     //显示链接
			      function preLink() { spanPre.innerHTML = \"<a href='javascript:pre();'>上一页</a>\"; }
			      function preText() { spanPre.innerHTML = \"上一页\"; }
			 
			      function nextLink() { spanNext.innerHTML = \"<a href='javascript:next();'>下一页</a>\"; }
			      function nextText() { spanNext.innerHTML = \"下一页\"; }
			
			      function firstLink() { spanFirst.innerHTML = \"<a href='javascript:first();'>第一页</a>\"; }
			      function firstText() { spanFirst.innerHTML = \"第一页\"; }
			
			      function lastLink() { spanLast.innerHTML = \"<a href='javascript:last();'>最后一页</a>\"; }
			      function lastText() { spanLast.innerHTML = \"最后一页\"; }
			
			     //隐藏表格
			      function hide() {
			          for (var i = pageSize; i < numberRowsInTable; i++) {
			              theTable.rows[i].style.display = 'none';
			          }
			      	var a=pageCount();
	
			         totalPage.innerHTML = a;
			    
			         pageNum.innerHTML = '1';
			         
			         nextLink();
			         lastLink();
			      }
			     hide();
			 </script>  
		  ";
	}
	if(TB_ISPAGE=="false"){
		html+="";
	}
	return html;
}
//
// 
//id,name,img,url,crtdat,note
function wximgtitletyp(){
	
	var sql="";
	var html="";
	var ds="";
	
	if(SQLTXT!=""){
		sql=SQLTXT;
		sql=pub.EAFunc.Replace(sql,"#$amp;","&");
		var usrinfo = web.EASession.GetUserinfo(request);
		if(usrinfo!=null){
			sql=web.EASession.GetSysValue(sql,request);//替换request 中[%id]
			sql=web.EASession.GetSysValue(sql,web.EASession.GetUserinfo(request));
		}
		
		ds=db.QuerySQL(sql);
	}
	else{
		if(DSMOD=="") return "选择数据来源或sql！";
		sql="select id,name,icon2 img,url,to_char(crtdat,'MM-dd') crtdat,note from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"'";
		ds=db.QuerySQL(sql);
	}
	
	for(var i=0;i<ds.getRowCount();i++){
		var id=ds.getStringAt(i,"id");
		var name=ds.getStringAt(i,"name");
		var img=ds.getStringAt(i,"img");
		var url=ds.getStringAt(i,"url");
		var crtdat=ds.getStringDef(i,"crtdat","");
		var note=ds.getStringDef(i,"note","");
		if(note.length()>15) note=note.substring(0,15)+".....";
		if(WX_CELLSPACING==null) WX_CELLSPACING = 5;
		//onMouseOut=\"tabonmouseup(this.id)\" onMouseOver=\"tabonmousedown(this.id)\" 移动到对象出发事件
		html+="<table width=\"100%\"  cellspacing=\""+WX_CELLSPACING+"\" id=\""+id+"\"  onclick=\"tabonmousedown(this.id,'"+url+"')\" onMouseDown=\"tabonmousedown(this.id,'"+url+"')\" onMouseUp=\"tabonmouseup(this.id)\" onmousemove=\"tabonmouseover(this.id)\"  onMouseOut=\"tabonmouseup(this.id)\"   style=\" border:1px #CCCCCC solid;border-width:0px 0px 1px 1px;\">
			<tr >
				<td width=\""+WX_WIDTH+"\" height=\""+WX_HEIGHT+"\" rowspan=\"2\"><img width=\""+WX_WIDTH+"\" height=\""+WX_HEIGHT+"\"  src=\""+img+"\"></td>
				<td  height=\"49%\" align=\"left\" style=\"font-size: 18px;color: "+WX_TITLECOLOR+";\">"+name+"</td>
				<td align=\"right\" style=\"font-size: 16px;color: "+WX_NOTECOLOR+";\">"+crtdat+"</td>
			</tr>
			<tr>
				<td height=\"49%\" colspan=\"2\" align=\"left\" style=\"font-size: 14px;color: "+WX_NOTECOLOR+";\">"+note+"</td>
			</tr>
		</table>";
	}
	html+="<p align=center>共"+ds.getRowCount()+"笔记录";
	
	var script="<script>
			function tabonmousedown(id,url){
				document.getElementById(id).background=\""+WX_ONCLICKCOLOR+"\";//backgroundColor
				window.location.href=url;
				
			}
			function tabonmouseup(id){
				document.getElementById(id).background=\"#FFFFFF\";//
			}
			function tabonmouseover(id){
				document.getElementById(id).background=\"#DEDEDE\";//
			}

		</script>";
	return script+html;
}

//
// 
//
function APPDISPLAY(){
	var sb=new langpack.StringBuffer();
	var sql="select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"'";
	var ds=db.QuerySQL(sql);
	var cnt = db.GetSQL("select CDMSSMCNT.Nextval CNT from dual");
	var num = db.GetSQL("select count(*) from hin_his where cadnum='310107193207170864'");
	var dtlds =null;
	if (num > 0) {
		sql="select * from hin_his where cadnum='310107193207170864'";
		dtlds = db.QuerySQL(sql);
	}
	
	var table="<table width=\"100%\">";
			
	var refnam="";
	var refurl="";
	for(var i=0;i<ds.getRowCount();i++){
		var id=ds.getStringAt(i,"id");
		var name=ds.getStringAt(i,"name");
		var img=ds.getStringAt(i,"icon2");
		var url=ds.getStringAt(i,"url");
		var refid=ds.getStringAt(i,"CONTEXTES");//上层div编号已dsy_+refid
		url=pub.EAFunc.Replace(url,"#$amp;","&");
		if(refnam==""){
			refnam=db.GetSQL("select name from LSYSURL where id='"+refid+"'");
			refurl=db.GetSQL("select url from LSYSURL where id='"+refid+"'");
		}
		if (id == "12163" && num > 0) {
			table+="<tr id=\""+id+"\" style=\"cursor:pointer;\" onMouseDown=\"tabonmousedown"+cnt+"(this.id,'"+url+"','"+refid+"','"+refnam+"','"+refurl+"')\" onMouseUp=\"tabonmouseup"+cnt+"(this.id)\" onMouseOut=\"tabonmouseup"+cnt+"(this.id)\">
					<td width=\"50px\" height=\"50px\"><img width=\"40px\" height=\"40px\" src=\""+img+"\" style=\"color:red;\"></td>
					<td align=\"left\" style=\"font-size:18px;color:#333333;\">
						<table>
							<tr>
								<td style=\"font-size:18px;color:#333333;\">"+name+"</td>
								<td align=\"center\">
									 <div style=\"width:20px; height:20px;background-color:#F00; border-radius:25px;\">         
									 	<span style=\"width:20px; height:20;pxdisplay:block; color:#FFF; text-align:center\">"+num+"</span>
									 </div>
								</td>
							</tr>
							
						</table>
					</td>
				</tr> ";
		} else {
			table+="<tr id=\""+id+"\" style=\"cursor:pointer;\" onMouseDown=\"tabonmousedown"+cnt+"(this.id,'"+url+"','"+refid+"','"+refnam+"','"+refurl+"')\" onMouseUp=\"tabonmouseup"+cnt+"(this.id)\" onMouseOut=\"tabonmouseup"+cnt+"(this.id)\">
					<td width=\"50px\" height=\"50px\"><img width=\"40px\" height=\"40px\" src=\""+img+"\"></td>
					<td align=\"left\" style=\"font-size:18px;color:#333333;\">"+name+"</td>
				</tr> ";
		}
	}
	table+="</table>";

	sb.append("<div style=\"width:100%; height:100%;\"><div id=\"valid"+cnt+"\" style=\"width:100%; height:100%; display:block;\">"+table+"</div></div>");
	
	
	sb.append("<script>
			function tabonmousedown"+cnt+"(id,url,refid,refnam,refurl){
				var len=refids.length;
				var ref=refid+'__'+refnam+'__'+refurl;
    				if(eqArray(refids,ref)); 
					refids[len]=ref;
				document.getElementById(id).style.backgroundColor=\"#EEEEEE\";
				document.getElementById(\"dsy_menu\").style.display=\"block\";
				$.ajax({
					url: url+'&hashead=n',
					type: 'POST',
					success: function(result){
						document.getElementById(\"dsy_\"+refids[0].split('__')[0]).innerHTML=result;
						fdisplay"+cnt+"(ref);
					}
				});
				
			}
			
			function eqArray(str,str1){
				for(var i=0;i<str.length;i++){
					if(str[i]==str1)
					return 1;
				}
				return 0;
			}
			
//			function delArray(str,str1){
//				var del=0;
//				for(var i=0;i<str.length;i++){
//					if(del==1)
//						str.shift();
//					if(str[i]==str1){
//						del=1;
//					}
//					
//				}
//				return 0;
//			}
			
			function tabonmouseup"+cnt+"(id){
				document.getElementById(id).style.backgroundColor=\"#FFFFFF\";
			}
			function fdisplay"+cnt+"(clackid){
				delArray(refids,clackid);

				document.getElementById(\"dsy_menu\").style.display='block';
				var div='';
				for(var i=0;i<refids.length;i++){
					var id='dsy_'+refids[i].split('__')[0];
					var name=refids[i].split('__')[1];
					var url=refids[i].split('__')[2];
					div+='<DIV onclick=\"clickmenu(url,id)\" style=\"color:#666666;cursor: pointer;float: left;font-size: 14px;height:25px;padding: 0px 15px;border-right:1px solid #CFCFCF;position: relative;\">'+name+'</DIV>';
				}
				document.getElementById(\"dsy_menu\").innerHTML=div;
			}
			function clickmenu(url,id){
				$.ajax({
					url: url+'&hashead=n',
					type: 'POST',
					success: function(result){
						document.getElementById(id).innerHTML=result;
					}
				});
			}
		</script>");
	return sb.toString();
}

//
//标题，图片，正文，附件
//title,crtdat,img,context,fileguid,filename
function PRJTBODY(){

	var html = "";
	var prjguid= request.getParameter("guid" ) ;
	var sql =SQLTXT;
	var where="";
	if(prjguid!=""||prjguid!=null) sql="select * from ("+SQLTXT+") where guid='"+prjguid+"'";
	
	var ds = db.QuerySQL(sql);
	var title = "";
	var crtdat = "";
	var image = "";
	var context="";
	var fileguid="";
	var filename="";
	var TITLESIZE=4;
	var noteblob="";
	if(ds.getRowCount()>0){
		title = ds.getStringAt(0,"title");
		crtdat = ds.getStringAt(0,"crtdat");
		image = ds.getStringAt(0,"img");
		context =ds.getStringAt(0,"context");
		fileguid=ds.getStringAt(0,"fileguid");
		filename=ds.getStringAt(0,"filename");
	}
	if(context!=""){
		sql = "select BDATA from formblob where guid='"+context +"'";
		noteblob= db.getBlob2String(sql,"BDATA");
	}	
	html = "<table width=\"100%\" height=\"100%\">";
	html +="<tr><td align=center ><font size="+TITLESIZE+"> "+title +"</font></td></tr>
		 <tr><td align=center >"+crtdat+"</td></tr>
		 <tr><td><hr style=\"border-bottom: 1px solid #DFDFDF; padding-left: 4px; padding-right: 4px; padding-top: 1px; padding-bottom: 1px\" size=\"0\"></td></tr>
		 ";
	
	if(image!=""){
		html +="<tr><td align=center ><img src=\""+image +"\" border=\"0\"></td></tr>";
	}
	
	html+= "<tr><td align=center ><table  width=90% style=\"text-align: left;\"  ><tr><td>"+noteblob+" </td></tr></table></td></tr>";
	if(filename!=""){
		html+= "<tr><td align=left>附件：<a href=\"EAFormBlob.sp?guid="+fileguid+"\"><font color=#4169E1>"+filename+"</font></a></td></tr>";
	}
	html+="</table>";
	return  html;
}

}