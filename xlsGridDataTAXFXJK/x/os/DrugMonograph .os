function x_DrugMonograph (){var langpack = new JavaPackage ( "java.lang");
var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
function GetBody(){
	var sb=new langpack.StringBuffer();
	sb.append("<div id=\"hidde\" style=\"margin-left:10%;\"></div>");
	sb.append("<div id=\"frist\" onclick=\"tree(0)\" style=\"margin-left:10%;width:100px;height:20px;\" ><font color=\"#FFFFFF\">药理分类</font></div>");
	sb.append("<div id=\"tree\" style=\"margin-left:10%;margin-right:10%;float:left;width:1000px;\"></div>");//显示菜单
	sb.append("<div id=\"dru\" style=\"margin-left:10%;float:left;\"></div>");//
	sb.append("<input type=\"hidden\" id=\"inp\"");//用来得到菜单
	
	
	sb.append("<script src=\"http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js\"></script>");
	sb.append("<script type=\"text/javascript\">
	function manu(id){
		$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_TreeNode.manu.osp?id='+id,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		document.getElementById(\"dru\").innerHTML=result;
		

		}
		});
	
	}
	function dru(id,page){
		//隐藏上级菜单
		document.getElementById(\"tree\").style.display =\"none\";
		document.getElementById(\"dru\").style.display =\"\";
		$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_TreeNode.dru.osp?id='+id+'&page'+page,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		document.getElementById(\"dru\").innerHTML=result;
		

		}
		});
	}
	function tree(id){

	if(document.getElementById(\"dru\").innerHTML != \"\"){
		document.getElementById(\"dru\").style.display =\"none\";//隐藏
		document.getElementById(\"dru\").innerHTML =\"\";//清空
	}
	document.getElementById(\"tree\").style.display =\"\";
	document.getElementById(\"frist\").style.display =\"none\";
	$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_TreeNode.node.osp?id='+id,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		document.getElementById(\"inp\").value+=result +\"<font color='#FFFFFF'>></font>\";
		document.getElementById(\"hidde\").innerHTML = document.getElementById(\"inp\").value;
	
		var spl = document.getElementById(\"inp\").value.split(\"<input type='hidden' value=\"+id+\" />\");
		
		document.getElementById(\"hidde\").innerHTML = spl[0]+\"<input type='hidden' value=\"+id+\" />\";

		document.getElementById(\"inp\").value = spl[0]+\"<input type='hidden' value=\"+id+\" />\";
	}
	});
	
	$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_TreeNode.treenode.osp?id='+id,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		document.getElementById(\"tree\").innerHTML =result;
		
		
	}
	});
	
	
	}
	//分页
	function page(id,pagesize,count){
		
		$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_TreeNode.page.osp?id='+id+'&pagesize='+pagesize+'&count='+count,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		document.getElementById(\"dru\").innerHTML=result;
		

		}
		});
	}
	</script>");
//	var sb=new langpack.StringBuffer();
//	sb.append("<input type=\"hidden\" id=\"va\" value=\"frist\"/> ");
//	//sb.append("<input type=\"text\" id=\"sp\" value=\"\"/> ");
//	sb.append("<input type=\"hidden\" id=\"val\" value=\"\"/> ");
//	sb.append("<div  id=\"tex\"  style=\"width:25%;border:1px solid #CCCCCC;\"></div>");
//	sb.append("<div  id=\"right\"  style=\"width:74.9%;border:1px solid #CCCCCC;float:right;\"></div>");
//
//	//<a onclick=\"onclic(1,1,0,'西药')\">西药</a>
//	sb.append("<div id=\"frist\" style=\"width:300px;border:1px solid #CCCCCC;\"><a  onclick=\"onclic(0,0,0,'药理分类')\">药理分类</a> </div>");
//	pha(0,sb,0);
//	
//	
//	//sb.append("<script type=\"text/javascript\">function onclic(id,refid,isl,valu){alert(valu);if(isl == 0){document.getElementById(\"tex\").innerHTML +=\" >><a onclick='onclic(\"+id+\",\"+refid+\",\"+isl+\",\"+"'"+valu+"'"+"\")'> \"+valu+\"</a>\"; var tid = document.getElementById(\"va\").value;document.getElementById(tid).style.display =\"none\";document.getElementById(\"va\").value=id;document.getElementById(id).style.display =\"\";}else{alert(\"最低层\");}}</script>");
//	
//	
//	sb.append("<script type=\"text/javascript\">
//	function onclic(id,refid,isl,valu){
//	//document.getElementById(\"sp\").value=document.getElementById(\"tex\").innerHTML+\"a\"+id;
//	
//	if(isl == 0){
//		
//		var tid = document.getElementById(\"va\").value;
//		document.getElementById(tid).style.display =\"none\";
//		document.getElementById(\"va\").value=id;document.getElementById(id).style.display =\"\";
//	}else{
//	//var tex = document.getElementById(\"tex\").innerHTML;
//	//window.location.href=\"http://dev.sss-shanghai.org/aca/x.L_TreeNode.html.osp?id=\"+id+\"&tex\"+tex;
//	$.ajax({
//	url: 'http://dev.sss-shanghai.org/aca/x.L_TreeNode.html.osp?id='+id,type: 'POST',error: function(){alert('Error loading PHP document');},
//	
//	success: function(result){document.getElementById(\"right\").innerHTML =result;}
//	
//	});
//	return ; 
//	}
//	var spl =document.getElementById(\"val\").value.split(\"<input type='hidden'value=\"+id +\"/>\");
//	document.getElementById(\"tex\").innerHTML=spl[0]+\"<input type='hidden'value=\"+id +\"/>\";
//	if(valu==0){
//		document.getElementById(\"val\").value=spl[0]+\"<input type='hidden'value=\"+id +\"/>\";
//
//	}else{
//		document.getElementById(\"val\").value=spl[0];
//		document.getElementById(\"tex\").innerHTML +=\" >><a onclick='onclic(\"+id+\",\"+refid+\",\"+isl+\",0)'> \"+valu+\"</a>\"+\"<input type='hidden'value=\"+id +\"/>\";
//		document.getElementById(\"val\").value +=\" >><a onclick='onclic(\"+id+\",\"+refid+\",\"+isl+\",0)'> \"+valu+\"</a>\"+\"<input type='hidden'value=\"+id +\"/>\";
//	} 
//	//document.getElementById(\"val\").value=spl[0];
//	}
//	function dis(id){document.getElementById(\"+id+\").display =\"\";}</script>");
//
	return sb;


}

function pha(refid,sb,id){
//		
//		var db = "";
//		try {
//		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
//			//根节点-中药-西药1
//		var sql = "select * from cdms_pha where refid='"+refid+"' ";
//		var ds=db.QuerySQL(sql);
//		sb.append("<div id="+refid+" style=\"display:none;width:300px;height:500px;border:1px solid #CCCCCC;\">");
//		for(var i =0;i<ds.getRowCount();i++){
//		
//			//id="+ds.getValueAt(j,0)+"
//			for(var j =0;j<ds.getRowCount();j++){
//1			if(ds.getValueAt(j,3) != 0){
//			
//				var hql = "select  * from cdms_drunam where id in(select catalog_id from cdms_phatyp where phacatalog_id ='"+ds.getValueAt(j,0)+"') ";
//				var hs = db.QuerySQL(hql);
//				sb.append("<div id=a"+ds.getValueAt(j,0)+" style=\"display:none;\">");
//				for(var k =0;k<hs.getRowCount();k++){
//				sb.append("<div id=b"+hs.getValueAt(k,0)+">"+hs.getValueAt(k,4));
//					sb.append("<div style=\"display:none;\" id=\"a\"+hs.getValueAt(k,0)>"+hs.getValueAt(k,4)+"</div>");
//					sb.append("<a onclick=\"+qs.getValueAt(k,0)+\">"+hs.getValueAt(k,4)+"</a>");
//
//					
//				}
//				sb.append("</div>");
//2			}
//				sb.append("<a onclick=\"onclic("+ds.getValueAt(j,0)+","+refid+","+ds.getValueAt(j,3)+",'"+ds.getValueAt(j,1)+"')\" >");
//				sb.append(ds.getValueAt(j,1)+"</br>");
//				sb.append("</a>");
//	
//				}
//				sb.append("</div>");
//				pha(ds.getValueAt(i,0),sb,ds.getValueAt(i,2));
//							
//			}
//		}
//		catch ( ee ) {
//			db.Rollback();
//			sb.append(ee.toString());
//			//throw new pubpack.EAException ( ee.toString() );
//		}
//		finally {
//			if (db!="") db.Close();
//		}
//		
		
		

}

function node(){
	var html ="";
	var db = "";
	if(id==0){
	html ="<a onclick=\"tree("+id+")\"><font color=\"#FFFFFF\">药理分类></font>"+"</a><input type='hidden' value=0 />";
	return html;
	}
		try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			//根节点-中药-西药1
		var sql = "select * from CDMS_PHA where id='"+id+"' ";
		var ds=db.QuerySQL(sql);
		
		html = "<a  onclick=\"tree("+id+")\"><font color=\"#FFFFFF\">"+ds.getValueAt(0,1)+"</font></a><input type='hidden' value="+ds.getValueAt(0,0)+"/>";
		
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "出现错误";
		}
		finally {
		
			if (db!="") db.Close();
		}
	return html;

	
	}

function treenode(){
	var html ="";
	var db = "";
		try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			//根节点-中药-西药1
		var sql = "select * from CDMS_PHA where REFID='"+id+"' ";
		var ds=db.QuerySQL(sql);
		
		if(ds.getRowCount() == 0){
		
			var sql = "select * from CDMS_DRUNAM where id in(select DISTINCT A.catalog_id from cdms_phatyp A,CDMS_DRUTONOTE B where A.CATALOG_ID=B.CATALOG_ID AND  phacatalog_id='"+id+"' )";
			var ds=db.QuerySQL(sql);
			
			for(var i =0;i<ds.getRowCount();i++){
				html += "<table style=\"width:100px;height:100px; float:left;margin:5px;background-color:#3399FF;\">";
				html += "<tr><td onclick=\"dru("+ds.getValueAt(i,0)+",1)\"><font  size=\"3\" color=\"#FFFFFF\" style=\"margin-top:20px;\">"+ds.getValueAt(i,4)+"</font>";
				html += "<td></tr></table>";
			}
			
			
			
			return html;
		}
		
		for(var i =0;i<ds.getRowCount();i++){
			html += "<table style=\"width:100px;height:100px; float:left;margin:5px; background-color:#3399FF;\">";
			html += "<tr><td onclick=\"tree("+ds.getValueAt(i,0)+")\"><font  size=\"3\" color=\"#FFFFFF\" style=\"margin-top:20px;\">"+ds.getValueAt(i,1)+"</font>";
			html += "</td></tr></table>";
			
		}
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			//throw new pubpack.EAException ( ee.toString() );
			return "出现错误";
		}
		finally {
		
			if (db!="") db.Close();
		}
	return html;


}

function dru(){
		var html ="";
		var db = "";
		
		try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			//根节点-中药-西药1
		var sql = "select * from CDMS_DRUNOTEREF where DOC_ID in(select doc_id from CDMS_DRUTONOTE where CATALOG_ID = '"+id+"') ";
		var ds=db.QuerySQL(sql);
	
		//判断是否进行分页
			if(ds.getRowCount() >15){
				
				var pagesize = 0;
				
				//总页数
				var count = ds.getRowCount() % 15==0?ds.getRowCount() / 15:(ds.getRowCount() / 15)+1;
				
				//最小数
				var pagemin = pagesize * 15;
				//最大数
				var pagemax = (pagesize+1) * 15;
				var sql = "select * from (select rownum as r,CDMS_DRUNOTEREF.* from CDMS_DRUNOTEREF  where DOC_ID in(select doc_id from CDMS_DRUTONOTE where CATALOG_ID = '"+id+"')and rownum<="+pagemax +") where r> "+pagemin;	
			
				var ds=db.QuerySQL(sql);
					for(var i =0;i<ds.getRowCount();i++){
					var drug_name = ds.getValueAt(i,"drug_name");
					var manufacturer = ds.getValueAt(i,"manufacturer");
					var collectdate = ds.getValueAt(i,"collectdate");
					var doseform = ds.getValueAt(i,"doseform");
					var strength1 = ds.getValueAt(i,"strength1");
					if(doseform == ""||doseform ==null)doseform = "&nbsp;&nbsp;&nbsp;";
					if(collectdate == ""||collectdate ==null)collectdate = "&nbsp;&nbsp;&nbsp;";
					if(drug_name == ""||drug_name ==null)drug_name = "&nbsp;&nbsp;&nbsp;";
					if(manufacturer == ""||manufacturer ==null)manufacturer = "&nbsp;&nbsp;&nbsp;";
					if(strength1 == ""||strength1 ==null)strength1= "&nbsp;&nbsp;&nbsp;";
					html += "<p><a  href=\"http://cdms.xmidware.com/aca//ROOT_CDMS/L.sp?id=InstructionBook&doc_id="+ds.getValueAt(i,"DOC_ID")+"  \" target='_blank'  ><font color:#3366FF>"+drug_name+"</font></a></p>";
					html += "<p><font color='#333333'>商品名称:</font>"+drug_name+"</p>";
					html += "<p><font color='#333333'>生产厂家：</font>"+manufacturer+"<font color='#333333'>收集日期:</font>"+collectdate +"<font color='#333333'>剂型:</font>"+doseform +"<font color='#333333'>规格</font>:"+strength1+"</p>";
					html += "<hr  size=1 style=\"COLOR: #ffd306;border-style:outset;width:1000px;margin-right:20%\">";
					}
					html +="</div>";
					html +="<div><span>总页数"+count+"当前页"+pagesize +"</span>";
					html += "<span><select onchange=\"page("+id+",this.value-1,"+count+")\">";
					for(var k = 1;k<=count;k++){
						if(k == pagesize*1+1){
							html += "<option selected='selected'>";
							html += k;
							html += "</option>";
						}else{
							html += "<option>";
							html += k;
							html += "</option>";
						}
		
					}
					html += "</select></span>";
					html += "<span  onclick=\"page("+id+",0,"+count+")\">首页</span>";
					if(pagesize ==0){//没有上一页
					html +="<span><a>上一页</a></span>";
					}
					var bpage = pagesize * 1 +1;
					html += "<span ><a onclick=\"page("+id+","+bpage +","+count+")\">下一页</a></span >";
					html += "<span ><a onclick=\"page("+id+","+count+","+count+")\">尾页</a></span >";
					html +="</div>";
					return html;
			}
			html +="<div width=\"1000px\">";
			for(var i =0;i<ds.getRowCount();i++){
			var drug_name = ds.getValueAt(i,"drug_name");
			var manufacturer = ds.getValueAt(i,"manufacturer");
			var collectdate = ds.getValueAt(i,"collectdate");
			var doseform = ds.getValueAt(i,"doseform");
			var strength1 = ds.getValueAt(i,"strength1");
			if(doseform == ""||doseform ==null)doseform = "&nbsp;&nbsp;&nbsp;";
			if(collectdate == ""||collectdate ==null)collectdate = "&nbsp;&nbsp;&nbsp;";
			if(drug_name == ""||drug_name ==null)drug_name = "&nbsp;&nbsp;&nbsp;";
			if(manufacturer == ""||manufacturer ==null)manufacturer = "&nbsp;&nbsp;&nbsp;";
			if(strength1 == ""||strength1 ==null)strength1= "&nbsp;&nbsp;&nbsp;";
			html += "<p><a  href=\"http:cdms.xmidware.com/aca//ROOT_CDMS/L.sp?id=InstructionBook&doc_id="+ds.getValueAt(i,"DOC_ID")+"  \" target='_blank'  ><font color:#3366FF>"+drug_name+"</font></a></p>";
			html += "<p><font color='#333333'>商品名称:</font>"+drug_name+"</p>";
			html += "<p><font color='#333333'>生产厂家：</font>"+manufacturer+"<font color='#333333'>收集日期:</font>"+collectdate +"<font color='#333333'>剂型:</font>"+doseform +"<font color='#333333'>规格</font>:"+strength1+"</p>";
			html += "<hr  size=1 style=\"COLOR: #ffd306;border-style:outset;width:1000px;margin-right:20%\">";
			}
			html +="</div>";

		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "出现错误";
		}
		finally {
		
			if (db!="") db.Close();
		}
	return html;

}

function page(){

		var db="";
		
		try{
		//总页数
		db = new pubpack.EADatabase();
		var pag = pagesize*1 +1;
		//最小数
		var pagemin = pagesize * 15;
		//最大数
		var pagemax = pag* 15;
		var sql = "select * from (select rownum as r,CDMS_DRUNOTEREF.* from CDMS_DRUNOTEREF  where DOC_ID in(select doc_id from CDMS_DRUTONOTE where CATALOG_ID = '"+id+"')and rownum<="+pagemax +") where r> "+pagemin;	
		var ds=db.QuerySQL(sql);
		html ="";
	


		for(var i =0;i<ds.getRowCount();i++){
			var drug_name = ds.getValueAt(i,"drug_name");
			var manufacturer = ds.getValueAt(i,"manufacturer");
			var collectdate = ds.getValueAt(i,"collectdate");
			var doseform = ds.getValueAt(i,"doseform");
			var strength1 = ds.getValueAt(i,"strength1");
			if(doseform == ""||doseform ==null)doseform = "&nbsp;&nbsp;&nbsp;";
			if(collectdate == ""||collectdate ==null)collectdate = "&nbsp;&nbsp;&nbsp;";
			if(drug_name == ""||drug_name ==null)drug_name = "&nbsp;&nbsp;&nbsp;";
			if(manufacturer == ""||manufacturer ==null)manufacturer = "&nbsp;&nbsp;&nbsp;";
			if(strength1 == ""||strength1 ==null)strength1= "&nbsp;&nbsp;&nbsp;";
			html += "<p><a  href=\"http://cdms.xmidware.com/aca//ROOT_CDMS/L.sp?id=InstructionBook&doc_id="+ds.getValueAt(i,"DOC_ID")+"  \" target='_blank'  ><font color:#3366FF>"+drug_name+"</font></a></p>";
			html += "<p><font color='#333333'>商品名称:</font>"+drug_name+"</p>";
			html += "<p><font color='#333333'>生产厂家：</font>"+manufacturer+"<font color='#333333'>收集日期:</font>"+collectdate +"<font color='#333333'>剂型:</font>"+doseform +"<font color='#333333'>规格</font>:"+strength1+"</p>";
			html += "<hr  size=1 style=\"COLOR: #ffd306;border-style:outset;width:1000px;margin-right:20%\">";
			}
			html +="</div>";
			html +="<div><span>总页数"+count+"当前页"+pagesize +"</span>";
			html += "<span><select onchange=\"page("+id+",this.value-1,"+count+")\">";
			for(var k = 1;k<=count;k++){
				if(k == pagesize*1+1){
					html += "<option selected='selected'>";
					html += k;
					html += "</option>";
				}else{
					html += "<option>";
					html += k;
					html += "</option>";
				}
	
			}
			html += "</select></span>";
			html += "<span  onclick=\"page("+id+",0,"+count+")\">首页</span>";
			var bpage = pagesize *1 +1;
			var tpage = pagesize *1 -1;
	
			if(pagesize ==0){
				html += "<span><a>上一页</a></span>";
			}else{
				html += "<span><a onclick=\"page("+id+","+tpage+","+count+")\">上一页</a></span>";
			}
			var coun = count * 1 -1;
			if(pagesize == coun){
				html += "<span><a>下一页</a></span>";
			}else{
				html += "<span><a onclick=\"page("+id+","+bpage+","+count+")\">下一页</a></span>";
			}
			
			html += "<span><a onclick=\"page("+id+","+coun+","+count+")\">尾页</a></span>";
			html +="</div>";
		
		
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "出现错误";
		}
		finally {
		
			if (db!="") db.Close();
		}
		return html;	

}
function html(){

	var html ="";
	var db = "";
		try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			//根节点-中药-西药1
		var sql = "select DISTINCT A.* from cdms_phatyp A,CDMS_DRUTONOTE B where A.CATALOG_ID=B.CATALOG_ID AND  phacatalog_id='"+id+"' ";
		var ds=db.QuerySQL(sql);
		for(var i =0;i<ds.getRowCount();i++){
			var hql = "select * from cdms_drunam where id ="+ds.getValueAt(i,1);
			var dsa =db.QuerySQL(hql);
			html += "<div>"+dsa.getValueAt(0,0)+""+dsa.getValueAt(0,4)+"</div>";
		}
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
		}
		finally {
			if (db!="") db.Close();
		}
	return html;
	
}






}