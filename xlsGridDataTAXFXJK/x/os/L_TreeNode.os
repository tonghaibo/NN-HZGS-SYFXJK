function x_L_TreeNode(){var langpack = new JavaPackage ( "java.lang");
var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
function GetBody(){
	var sb=new langpack.StringBuffer();
	sb.append("<div id=\"hidde\" style=\"margin-left:10%;\"></div>");
	sb.append("<div id=\"frist\" style=\"margin-left:10%;width:100px;height:20px;\" ><div onclick='tree(0,0)'><font>ҩ�����</font></div></div>");
	sb.append("<div id=\"tree\" style=\"margin-left:10%;margin-right:10%;float:left;width:1000px;\"></div>");//��ʾ�˵�
	sb.append("<div id=\"dru\" style=\"margin-left:10%;float:left;\"></div>");//
	sb.append("<input type=\"hidden\" id=\"inp\"");//�����õ��˵�
	
	
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
	//ȡͬ��ҩƷ
	function dru(id,page){
		//�����ϼ��˵�
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
	//ֱ����ʾҩƷ
	function drugShow(id){
		$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_TreeNode.drugShow.osp?id='+id,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		//Ĭ����<div style=\"width:1000px;\"></div>�൱���п�
		if(result.length >36){
			document.getElementById(\"dru\").innerHTML=result;
		}else{
			document.getElementById(\"dru\").innerHTML=\"û���ҵ����ҩƷ����Ϣ\";
		}
		}
		});
		document.getElementById(\"dru\").style.display =\"\";//��ʾ

	}
	
	
	function tree(id,ty){
	
	if(document.getElementById(\"dru\").innerHTML != \"\"){
		document.getElementById(\"dru\").style.display =\"none\";//����
		document.getElementById(\"dru\").innerHTML =\"\";//���
	}
	document.getElementById(\"tree\").style.display =\"\";
	document.getElementById(\"frist\").style.display =\"none\";
	$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_TreeNode.node.osp?id='+id+'&ty='+ty,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		
		document.getElementById(\"inp\").value+=result +\"<font>></font>\";
		document.getElementById(\"hidde\").innerHTML = document.getElementById(\"inp\").value;
	
		var spl = document.getElementById(\"inp\").value.split(\"<input type='hidden' value=\"+id+\" />\");
		
		document.getElementById(\"hidde\").innerHTML = spl[0]+\"<input type='hidden' value=\"+id+\" />\";

		document.getElementById(\"inp\").value = spl[0]+\"<input type='hidden' value=\"+id+\" />\";
	}
	});
	
	$.ajax({
		url: 'http://cdms.xmidware.com/aca/x.L_TreeNode.treenode.osp?id='+id+'&ty='+ty,
		type: 'POST',
		error: function(){alert('Error loading PHP document');},
		success: function(result){
		
		document.getElementById(\"tree\").innerHTML =result;
		
		
	}
	});
	
	
	}
	//��ҳ
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
	return sb;


}



//����
function node(){

	var html ="";
	var db = "";
	if(id==0){
	html ="<a onclick=\"tree("+id+","+ty+")\"><font >ҩ�����></font>"+"</a><input type='hidden' value=0 />";
	return html;
	}
		try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
			//���ڵ�-��ҩ-��ҩ1
		var sql = "select * from CDMS_PHA where id='"+id+"' ";
		var ds=db.QuerySQL(sql);
		
		html = "<a  onclick=\"tree("+id+","+ty+")\"><font >"+ds.getValueAt(0,1)+"</font></a><input type='hidden' value="+ds.getValueAt(0,0)+"/>";
		
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "���ִ���";
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
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
			//���ڵ�-��ҩ-��ҩ1
		var sql = "select * from CDMS_PHA where REFID='"+id+"' ";
		var ds=db.QuerySQL(sql);
		
		if(ds.getRowCount() == 0){
			var ty= pubpack.EAFunc.NVL(request.getParameter("ty"),"");
			var sql = "select * from CDMS_DRUNAM where id in(select DISTINCT A.catalog_id from cdms_phatyp A,CDMS_DRUTONOTE B where A.CATALOG_ID=B.CATALOG_ID AND  phacatalog_id='"+id+"' )";
			var ds=db.QuerySQL(sql);
			if(ty == 0){//ҩƷ˵����
				for(var i =0;i<ds.getRowCount();i++){
					html += "<table style=\"width:100px;height:100px; float:left;margin:5px;background-color:#3399FF;\">";
					html += "<tr><td onclick=\"dru("+ds.getValueAt(i,0)+",1)\"><font  size=\"3\" color=\"#FFFFFF\" style=\"margin-top:20px;\">"+ds.getValueAt(i,4)+"</font>";
					html += "<td></tr></table>";
				}
			}else if(ty ==1){//ҩ��ר��
				for(var i =0;i<ds.getRowCount();i++){
					html += "<table style=\"width:100px;height:100px; float:left;margin:5px;background-color:#3399FF;\">";
					html += "<tr><td onclick=\"drugShow("+ds.getValueAt(i,0)+",1)\"><font  size=\"3\" color=\"#FFFFFF\" style=\"margin-top:20px;\">"+ds.getValueAt(i,4)+"</font>";
					html += "<td></tr></table>";
				}
			}
			
			
			
			return html;
		}
		
		for(var i =0;i<ds.getRowCount();i++){
			html += "<table style=\"width:100px;height:100px; float:left;margin:5px; background-color:#3399FF;\">";
			html += "<tr><td onclick=\"tree("+ds.getValueAt(i,0)+","+ty+")\"><font  size=\"3\" color=\"#FFFFFF\" style=\"margin-top:20px;\">"+ds.getValueAt(i,1)+"</font>";
			html += "</td></tr></table>";
			
		}
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "���ִ���";
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
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
			//���ڵ�-��ҩ-��ҩ1
		var sql = "select * from CDMS_DRUNOTEREF where DOC_ID in(select doc_id from CDMS_DRUTONOTE where CATALOG_ID = '"+id+"') ";
		var ds=db.QuerySQL(sql);
	
		//�ж��Ƿ���з�ҳ
			if(ds.getRowCount() >15){
				
				var pagesize = 0;
				
				//��ҳ��
				var count = ds.getRowCount() % 15==0?ds.getRowCount() / 15:(ds.getRowCount() / 15)+1;
				
				//��С��
				var pagemin = pagesize * 15;
				//�����
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
					html += "<p><font color='#333333'>��Ʒ����:</font>"+drug_name+"</p>";
					html += "<p><font color='#333333'>�������ң�</font>"+manufacturer+"<font color='#333333'>�ռ�����:</font>"+collectdate +"<font color='#333333'>����:</font>"+doseform +"<font color='#333333'>���</font>:"+strength1+"</p>";
					html += "<hr  size=1 style=\"COLOR: #ffd306;border-style:outset;width:1000px;margin-right:20%\">";
					}
					html +="</div>";
					html +="<div><span>��ҳ��"+count+"��ǰҳ"+pagesize +"</span>";
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
					html += "<span  onclick=\"page("+id+",0,"+count+")\">��ҳ</span>";
					if(pagesize ==0){//û����һҳ
					html +="<span><a>��һҳ</a></span>";
					}
					var bpage = pagesize * 1 +1;
					html += "<span ><a onclick=\"page("+id+","+bpage +","+count+")\">��һҳ</a></span >";
					html += "<span ><a onclick=\"page("+id+","+count+","+count+")\">βҳ</a></span >";
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
			html += "<p><font color='#333333'>��Ʒ����:</font>"+drug_name+"</p>";
			html += "<p><font color='#333333'>�������ң�</font>"+manufacturer+"<font color='#333333'>�ռ�����:</font>"+collectdate +"<font color='#333333'>����:</font>"+doseform +"<font color='#333333'>���</font>:"+strength1+"</p>";
			html += "<hr  size=1 style=\"COLOR: #ffd306;border-style:outset;width:1000px;margin-right:20%\">";
			}
			html +="</div>";

		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "���ִ���";
		}
		finally {
		
			if (db!="") db.Close();
		}
	return html;

}

function page(){

		var db="";
		
		try{
		//��ҳ��
		db = new pubpack.EADatabase();
		var pag = pagesize*1 +1;
		//��С��
		var pagemin = pagesize * 15;
		//�����
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
			html += "<p><font color='#333333'>��Ʒ����:</font>"+drug_name+"</p>";
			html += "<p><font color='#333333'>�������ң�</font>"+manufacturer+"<font color='#333333'>�ռ�����:</font>"+collectdate +"<font color='#333333'>����:</font>"+doseform +"<font color='#333333'>���</font>:"+strength1+"</p>";
			html += "<hr  size=1 style=\"COLOR: #ffd306;border-style:outset;width:1000px;margin-right:20%\">";
			}
			html +="</div>";
			html +="<div><span>��ҳ��"+count+"��ǰҳ"+pagesize +"</span>";
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
			html += "<span  onclick=\"page("+id+",0,"+count+")\">��ҳ</span>";
			var bpage = pagesize *1 +1;
			var tpage = pagesize *1 -1;
	
			if(pagesize ==0){
				html += "<span><a>��һҳ</a></span>";
			}else{
				html += "<span><a onclick=\"page("+id+","+tpage+","+count+")\">��һҳ</a></span>";
			}
			var coun = count * 1 -1;
			if(pagesize == coun){
				html += "<span><a>��һҳ</a></span>";
			}else{
				html += "<span><a onclick=\"page("+id+","+bpage+","+count+")\">��һҳ</a></span>";
			}
			
			html += "<span><a onclick=\"page("+id+","+coun+","+count+")\">βҳ</a></span>";
			html +="</div>";
		
		
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "���ִ���";
		}
		finally {
		
			if (db!="") db.Close();
		}
		return html;	

}

//ҩ��ר����ʾ
function drugShow(){
	var html ="";
	var db="";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
			//���ڵ�-��ҩ-��ҩ1
		var sql = "select * from CDMS_DRCONTENT  where CATALOG_ID ='"+id+"' ";
		var ds=db.QuerySQL(sql);
		html += "<div style=\"width:1000px;\">";
		for(var i=0;i<ds.getRowCount();i++){
			html += "<div>"+ds.getValueAt(i,"dr_title")+"</div>";
			var hql = "select bdata from formblob where guid ='"+ds.getValueAt(i,"dr_content")+"'";
			var blo = db.getBlob2String(hql,"bdata");
			html += "<div>"+blo+"</div>";
			html += "<hr  style=\"width:1000px;margin-right:20%\">";
			
		}
		html +="<div>";
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "���ִ���";
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
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
			//���ڵ�-��ҩ-��ҩ1
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

//ģ����ѯ
function like(){
	return likename;
 	var html ="";
	var db="";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
			//���ڵ�-��ҩ-��ҩ1
		var sql = "select * from CDMS_DRUNAM where name like '%"+likename+"%'";
		var ds=db.QuerySQL(sql);
		html += "<div style=\"width:1000px;\">";
		for(var i=0;i<ds.getRowCount();i+3){
			html += "<div>";
			html += "<span style=\"width:100px;height:100px;background-color:#3399FF;\">"+ds.getValueAt(i,"name")+"</span>";
			html += "<span style=\"width:100px;height:100px;background-color:#3399FF;\">"+ds.getValueAt(i+1,"name")+"</span>";
			html += "<span style=\"width:100px;height:100px;background-color:#3399FF;\">"+ds.getValueAt(i+2,"name")+"</span>";	
			html += "</div>";
		}
		html +="<div>";
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "���ִ���";
		}
		finally {
		
			if (db!="") db.Close();
		}
	return html;

}



}