function x_PageTable_gn(){function page_table()
{
	var sql="";
	var trbgcolor="#F9F9F9";
	var tdborder=0;
//	TB_ENTBTYP=true;
	var html="
		<style type=\"text/css\">
		a:link { 
		color:#000000; 
		text-decoration:none; 
		} 
		a:visited { 
		color:#000000; 
		text-decoration:none; 
		} 
		a:hover { 
		color:#0166CB; 
		text-decoration:underline; 
		} 
		a:active { 
		color:#0166CB; 
		text-decoration:none; 
		} 
	</style>
	<table id=\"mytable\" borderColor=\"\" align=\"center\" width=\""+TB_WIDTH+"\" height=\""+TB_HEIGHT+"\" cellspcing=\"2\" cellpadding=\"2\" style=\"border-collapse:collapse;line-height:"+LINE_HEIGHT+"\" >
        <tbody id=\"table2\" >";
	if(SQLTXT!=""){
		sql=SQLTXT;
		sql=pub.EAFunc.Replace(sql,"#$amp;","&");
		sql=pub.EAFunc.Replace(sql,"<","<");
		sql=pub.EAFunc.Replace(sql,">",">");
		sql=web.EASession.GetSysValue(sql,request);//�滻request ��[%id]
		sql=web.EASession.GetSysValue(sql,web.EASession.GetUserinfo(request));

		var ds=db.QuerySQL(sql);
		var style="";
		if(TB_IFHEADBORDER){
			style="style=\"border:solid "+TB_BORDERCOLOR+"; border-width:1px 1px 1px 1px; font-size: 20px;\"";
		}
		if(TB_IFHEAD){
			html+="<tr><td align=\"center\" "+style+" colspan=\""+ds.getColumnCount()+"\">"+TB_HEAD+"</td></tr>";
		}
		for(var r=0; r<ds.getRowCount(); r++){
			if(r%9==0){
				html+="<tr bgcolor=\""+TB_ROLBGCOLOR+"\">";
				for(var c=0;c<ds.getColumnCount();c++){
					html+="<td style=\"border:solid "+TB_BORDERCOLOR+"; border-width:1px 1px 1px 1px;\">"+ds.getColumnName(c)+"</td>";
				}
				html+="</tr>";
			}
			if(TB_TABLW==true&&r%2==1) trbgcolor="#F9F9F9"; else trbgcolor="#FFFFFF";
			if(TB_ENTBTYP==true) tdborder=0;  else tdborder=1;
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
	if(TB_ISPAGE==true){			
		html+="<div align=\"center\" style=\"margin-top:15px\">
		  <span id=\"spanFirst\">��һҳ</span> 
		  <span id=\"spanPre\">��һҳ</span> 
		  <span id=\"spanNext\">��һҳ</span> 
		  <span id=\"spanLast\">���һҳ</span> 
		  ��<span id=\"spanPageNum\"></span>ҳ/��<span id=\"spanTotalPage\"></span>ҳ
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
				  
			     //��һҳ
			      function next() {
			         hideTable();
			         currentRow = pageSize * page;
			          maxRow = currentRow + pageSize;
			          if (maxRow > numberRowsInTable) maxRow = numberRowsInTable;
			          for (var i = currentRow; i < maxRow; i++) {
			              theTable.rows[i].style.display = '';
			          }
			          page++;
			         
			         if (maxRow==numberRowsInTable) {nextText(); lastText(); }
			          showPage();
			          preLink();
			          firstLink();
			      }
			     //��һҳ
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
			     //��һҳ
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
			     //���һҳ
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
			     //�ܹ�ҳ��
			      function pageCount() {
			          var count = 0;
			          
			          if (numberRowsInTable % pageSize != 0) count = 1;
			          return parseInt(numberRowsInTable / pageSize) + count;
			      }
			     //��ʾ����
			      function preLink() { spanPre.innerHTML = \"<a href='javascript:pre();'>��һҳ</a>\"; }
			      function preText() { spanPre.innerHTML = \"��һҳ\"; }
			 
			      function nextLink() { spanNext.innerHTML = \"<a href='javascript:next();'>��һҳ</a>\"; }
			      function nextText() { spanNext.innerHTML = \"��һҳ\"; }
			
			      function firstLink() { spanFirst.innerHTML = \"<a href='javascript:first();'>��һҳ</a>\"; }
			      function firstText() { spanFirst.innerHTML = \"��һҳ\"; }
			
			      function lastLink() { spanLast.innerHTML = \"<a href='javascript:last();'>���һҳ</a>\"; }
			      function lastText() { spanLast.innerHTML = \"���һҳ\"; }
			
			     //���ر��
			      function hide() {

			          for (var i = pageSize; i < numberRowsInTable; i++) {
			              theTable.rows[i].style.display = 'none';
			          }
			      	var a=pageCount();
	
			         totalPage.innerHTML = a;
			    
			         pageNum.innerHTML = '1';
			         
			         if(pageSize<=numberRowsInTable) nextLink();
			         if(pageSize<=numberRowsInTable) lastLink();
			      }
			     hide();
			 </script>  
		  ";
	}
	if(TB_ISPAGE==false){
		html+="";
	}
	return html;
}

}