function x_showflg_BITEST(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var pub = new JavaPackage ( "com.xlsgrid.net.pub" );
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var tag = new JavaPackage("com.xlsgrid.net.tag");
var EAScript= new JavaPackage ( "com.xlsgrid.net.pub.EAScript");
var xmldsform = new tag.XmlDSForm();

var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb");
var layoutpack = new JavaPackage ( "com.xlsgrid.net.layout");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd");	
var langpack = new JavaPackage ( "java.lang");
var lamath=new JavaPackage("java.math");


function getlayout(request,layoutid){
	var db = null;
	var msg= "";
	var objid= pubpack.EAFunc.NVL( request.getParameter("objid"),"") ;
	var skin= pubpack.EAFunc.NVL( request.getParameter("skin"),"") ;
	var hashead = pubpack.EAFunc.NVL( request.getParameter("hashead"),"y") ;
	var deforg =  pubpack.EAFunc.NVL( request.getParameter("thisorgid"),webpack.EAWebDeforg.GetDeforg(request)) ;
	var browsetype = pubpack.EAFunc.getBroswerType( request );
	var sb=new langpack.StringBuffer();
	try{	
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var parent = new x_L();
		parent.GetLayoutHTML(db,request,sb,deforg,layoutid,0,"","");
	}
		catch ( ee ) {
			db.Rollback();
			sb.append(ee.toString());
			//throw new pubpack.EAException ( ee.toString() );
		}
		finally {
			if (db!=null) db.Close();
		}

	return sb.toString();
}


function BIWAP1(){
	var BI_GUID=pubpack.EAFunc.NVL( request.getParameter("BIID"),"");
	
	var BI_TITID=pubpack.EAFunc.NVL( request.getParameter("BITITID"),"");
	var BI_TYP=pubpack.EAFunc.NVL( request.getParameter("BI_TYP"),""); //显示图或表 0，1，2
	var BI_TYP1=pubpack.EAFunc.NVL( request.getParameter("BI_TYP1"),"column"); //显示初始图形风格
	var TB_IFHEAD="false";
	var TB_IFHEADBORDER="false";
	var TB_HEAD="";
	var TB_WIDTH="100%";
	var TB_HEIGHT="100%";
	var TB_ROLBGCOLOR="#d5d5d5";
	var TB_BORDERCOLOR="#cdcdcd";
	var LINE_HEIGHT="25px";
	var TB_TABLW="true";
	var TB_ENTBTYP="";

	var usr = web.EASession.GetUserinfo(request);
	
	var sytid = usr.getSytid();
	var topic = pub.EAFunc.NVL(BI_TITID,"");
	var modguid = pub.EAFunc.NVL(BI_GUID,"");
	
	var sql = "";
	var ret = "";
	// 生成查询条件
	sql = "select id,name,refmod,control,keyval,defval,wher,seq,isxs
		 from ( select id id,name,refmod,control,keyval,defval,wher,seq,isxs
		 	  from dim_dim
		 	 where refmod='"+BI_GUID+"' and nvl(control,' ') <> 'DATEBOX'
		 	union all
		 	select 'STA_'||id id,'开始'||name name,refmod,control,keyval,to_char(sysdate,'yyyy-mm-dd') defval,'' wher,0 seq,isxs
		 	  from dim_dim
		 	 where refmod='"+BI_GUID+"' and control='DATEBOX'
		 	union all
		 	select 'END_'||id id,'截止'||name name,refmod,control,keyval,to_char(sysdate,'yyyy-mm-dd') defval,'' wher,1 seq,isxs
		 	  from dim_dim
		 	 where refmod='"+BI_GUID+"' and control='DATEBOX' )
		order by seq";
	var ds = pub.EADbTool.QuerySQL(sql);
	
	var resetstr = "";
	var rowcount = ds.getRowCount();
	for ( var i=0;i<rowcount;i++ ) {
		var defval = "";
		if (ds.getStringAt(i,"DEFVAL") != null && ds.getStringAt(i,"DEFVAL") != "") {
			try {
				defval = db.GetSQL(web.EASession.GetSysValue(ds.getStringAt(i,"DEFVAL"),usr));	//SQL子句
			} catch ( e1 ) {
				try {
					defval = db.GetSQL("select '"+web.EASession.GetSysValue(ds.getStringAt(i,"DEFVAL"),usr)+"' val from dual");	//全局变量
				} catch ( e2 ) {
					try {
						defval = db.GetSQL("select "+web.EASession.GetSysValue(ds.getStringAt(i,"DEFVAL"),usr)+" val from dual");	//数据库函数
					} catch ( e3 ) {
						defval = web.EASession.GetSysValue(ds.getStringAt(i,"DEFVAL"),usr);	//字符串
					}
				}
			}
		}
		ds.setValueAt(i,"DEFVAL",defval);
		ds.setValueAt(i,"WHER",web.EASession.GetSysValue(ds.getStringAt(i,"WHER"),usr));
		
		resetstr += "try{document.all('"+ds.getStringAt(i,"ID")+"').value='"+ds.getStringAt(i,"DEFVAL")+"';}catch(e){}";
		
		if (ds.getStringAt(i,"ISXS") != "1") { //隐藏参数
			ret += "<input type='hidden' id='"+ds.getStringAt(i,"ID")+"' name='"+ds.getStringAt(i,"ID")+"'>";
			ds.DeleteRow(i);
			rowcount --;
			i --;
		}
	}
	
	var GHtml = xmldsform.HtmlForm(request,ds,"NAME","ID","KEYVAL","","Y","Y","DEFVAL","WHER","CONTROL","3","50");
	ret += pub.EAFunc.Replace(GHtml," bgcolor=\"#EEEEEE\""," bgcolor=\"#FFFFFF\"");
	ret += "<input type='hidden' id='sytid' name='sytid' value="+sytid+">
		<input type='hidden' id='topic' name='topic' value=''>
		<input type='hidden' id='FORMGUID' name='FORMGUID' value="+BI_GUID+">
		<input type='submit' style='height:24;cursor:pointer;' value=' 查 询 '>";
	
	var html = ret;
	html += "<table width=\"100%\" height=\"100%\">";
	var sql=getbisql(db,request,sytid,topic,modguid,usr);
//	throw new Exception(sql);
	var ds=db.QuerySQL(sql);
	if(BI_TYP==0)
	{
		html+="<tr><td valign=top>"+bityptable(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP)+"</td></tr>";
	}
	else if(BI_TYP==1)
	{
		html+="<tr><td>"+bitypicon(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,BI_TYP1)+"</td></tr>";
	}
	else if(BI_TYP==2)
	{
		html+="<tr><td>"+bitypicon(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,BI_TYP1)+"</td></tr>";
		html+="<tr><td valign=top>"+bityptable(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP)+"</td></tr>";
	}
	else if(BI_TYP==3)
	{

		html+="<tr><td  valign=top width=50%>"+bitypicon(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,BI_TYP1)+"</td>";
		html+="<td width=50%>"+bityptable(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP)+"</td></tr>";
	}
	else
	{

		html+="<tr><td valign=top width=50%>"+bityptable(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP)+"</td><td  valign=top width=50%>"+bitypicon(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,BI_TYP1)+"</td>";
		html+="</tr>";
	}
	html+="</table>";
	
	return html;
}
//
// 
//
function Biwap(){

	var usr = web.EASession.GetUserinfo(request);
	var sytid = usr.getSytid();
	var topic = pub.EAFunc.NVL(BI_TITID,"");
	var modguid = pub.EAFunc.NVL(BI_GUID,"");
	var sql=getbisql(db,request,sytid,topic,modguid,usr);
	var ds=db.QuerySQL(sql);
	
	if(BI_TYP==0){
		return bityptable(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP);
	}
	else if(BI_TYP==1){
		return bitypicon(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,"column");
	}
	else if(BI_TYP==2){
		var html="<table width=\""+TB_WIDTH+"\" height=\""+TB_HEIGHT+"\">";
		html+="<tr><td>"+bitypicon(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,"column")+"</td></tr>";
		html+="<tr><td valign=top>"+bityptable(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP)+"</td></tr>";
		html+="</table>";
		return html;
	}
	else if(BI_TYP==3){
		var html="<table width=\""+TB_WIDTH+"\" height=\""+TB_HEIGHT+"\">";
		html+="<tr><td valign=top width=50%>"+bitypicon(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,"column")+"</td>";
		html+="<td valign=top width=50%>"+bityptable(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP)+"</td></tr>";
		html+="</table>";
		return html;
	}
	else{
		var html="<table width=\""+TB_WIDTH+"\" height=\""+TB_HEIGHT+"\">";
		html+="<tr><td valign=top width=50%>"+bityptable(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP)+"</td>";
		
		html+="<td valign=top width=50%>"+bitypicon(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,"column")+"</td></tr>";
		html+="</table>";
		return html;
	}
}

//BI表格
function bityptable(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP){
	

	var sb=new langpack.StringBuffer();
	var sql="";
	var trbgcolor="#F9F9F9";
	var tdborder=0;
//	TB_ENTBTYP=true;
//	var vdim=db.GetSQL("select vdim from DIM_TOPIC where refmod='"+BI_GUID+"' and id='"+BI_TITID+"'");
	var html="<table borderColor=\"\"  align=\"center\" width=\"100%\" height=\"100%\" cellspcing=\"2\" cellpadding=\"2\" style=\"font-size:12px;border-collapse:collapse;line-height:"+LINE_HEIGHT+"\" >";
	var style="";
	if(TB_IFHEADBORDER){
		style="style=\"border:solid "+TB_BORDERCOLOR+"; border-width:1px 1px 1px 1px;\"";
	}
	if(TB_IFHEAD){
		html+="<tr><td align=\"center\" "+style+" colspan=\""+ds.getColumnCount()+"\">"+TB_HEAD+"</td></tr>";
	}
	var hjcolstr=new Array();//列保存合计值

	for(var r=0; r<=ds.getRowCount(); r++){
		var colsum=0;
		var rowsum=0;
		if(r==0){
			html+="<tr style=\"height:30px\" bgcolor=\""+TB_ROLBGCOLOR+"\">";
			for(var c=0;c<ds.getColumnCount();c++){
				
				html+="<td  style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px 1px 1px 1px;\">"+ds.getColumnName(c)+"</td>";
				if(c==ds.getColumnCount()-1){
					html+="<td  style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px 1px 1px 1px;\">合计</td>";
				}
			}
			html+="</tr>";
		}
		if(TB_TABLW==true&&r%2==1) trbgcolor="#F9F9F9"; else trbgcolor="#FFFFFF";
		if(TB_ENTBTYP==true) tdborder=0;  else tdborder=1;
		html+="<tr bgcolor=\""+trbgcolor+"\">";
		
		
		for(var c=0;c<ds.getColumnCount();c++){
			//最后一行合计
			if(r==ds.getRowCount()){
				if(c==0&&ds.getColumnCount()>1)
					html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px "+tdborder+"px 1px 1px;\">合计</td>";
				else{
					html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px "+tdborder+"px 1px "+tdborder+"px;\">"+hjcolstr[c]+"</td>";
					rowsum=FloatAdd(hjcolstr[c],rowsum);
				}
				if(c==ds.getColumnCount()-1){
						html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px 1px 1px "+tdborder+"px;\">"+rowsum+"</td>";
				}
				
			}
			else{
				if(c>0){
					var su=ds.getStringAt(r,c);
					colsum=FloatAdd(colsum,su);
					if(r==1){ 
						hjcolstr[c]=ds.getStringAt(r,c); 
					}
					else if(r>1){
					
						hjcolstr[c]=FloatAdd(hjcolstr[c],ds.getStringAt(r,c));
						
					}
				}
				if(c==0&&ds.getColumnCount()>1)
					html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px "+tdborder+"px 1px 1px;\">"+ds.getStringAt(r,c)+"</td>";
				else
					html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px "+tdborder+"px 1px "+tdborder+"px;\">"+ds.getStringAt(r,c)+"</td>";
				if(c==ds.getColumnCount()-1){
						html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px 1px 1px "+tdborder+"px;\">"+colsum+"</td>";
				}
			}
			
		}
		html+="</tr>";
//		throw new Exception(hjcolstr);
//		if(r==ds.getRowCount()-1){
//			
//			var rlsum=0;
//			html+="<tr bgcolor=\""+trbgcolor+"\">";
//			for(var c=0;c<ds.getColumnCount();c++){
//				var rowsum=0;
//				for(var rr=0;rr<ds.getRowCount();rr++){
//					if(c>0){
//						var su=ds.getStringAt(rr,c)*1.000;
//						 rowsum+=su;
//					}
//				}
//				rlsum+=rowsum;
//				if(c==0&&ds.getColumnCount()>1)
//					html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px "+tdborder+"px 1px 1px;\">合计</td>";
//				else
//					html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px "+tdborder+"px 1px "+tdborder+"px;\">"+rowsum+"</td>";
//				if(c==ds.getColumnCount()-1){
//						html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px 1px 1px "+tdborder+"px;\">"+rlsum+"</td>";
//				}
//			}
//			html+="</tr>";
//		}

	}
	
	
	html+="</table>";

	return html;

}
//BI图形
function bitypicon(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,BI_TYP1){

	var optionstr = "";
	var optionds = db.QuerySQL("select * from V_CHARTTYPE");
	var cdcnt = db.GetSQL("select CDMSSMCNT.Nextval CNT from dual");
	for (var r = 0;r < optionds.getRowCount();r ++) {
		var id = optionds.getStringAt(r,"ID");
		var name = optionds.getStringAt(r,"NAME");
		var typ = optionds.getStringAt(r,"TYP");
		optionstr += "<option value='"+id+"-"+typ+"'>"+name+"</option>";
	}
	var html="<table border='0' cellspacing='0' cellpadding='0'  style='border: 1px solid "+TB_BORDERCOLOR+"'  width='100%' height='100%'>
								
								<tr><td height=50% valign=top>
									<div id='container"+cdcnt+"' style='margin:0px; '></div>
								</td></tr>
								</table>";
	var style="<style>
			.navPoint {
				COLOR: #225f98; CURSOR: hand; FONT-FAMILY: 'Webdings'; FONT-SIZE: 9pt
				}
		</style>";
	var script="<script>
   	 var options"+cdcnt+"={
	        chart:{
	            backgroundColor: '#FFFFFF',
	            plotBackgroundColor: null,
		    plotBorderWidth: null,
		    plotShadow: false,
		    renderTo:'container"+cdcnt+"'  
	        },
	        exporting: {
	            buttons: {
	                contextButton: {
	                    menuItems: [
	                    	{
	                       	 	text: '柱状图',
	                        	onclick: function () {
	                            		f_chgchart"+cdcnt+"('柱状图');
	                       		}
	                   	},
	                   	{
	                       	 	text: '折线图',
	                        	onclick: function () {
	                            		f_chgchart"+cdcnt+"('折线图');
	                       		}
	                   	},
	                   	{
	                       	 	text: '区域图',
	                        	onclick: function () {
	                            		f_chgchart"+cdcnt+"('区域图');
	                       		}
	                   	},
	                   	{
	                       	 	text: '曲线区域图',
	                        	onclick: function () {
	                            		f_chgchart"+cdcnt+"('曲线区域图');
	                       		}
	                   	},
	                   	{
	                       	 	text: '3D柱状图',
	                        	onclick: function () {
	                            		f_chgchart"+cdcnt+"('3D柱状图');
	                       		}
	                   	},
	                   	{
	                       	 	text: '3D饼图',
	                        	onclick: function () {
	                            		f_chgchart"+cdcnt+"('3D饼图');
	                       		}
	                   	},
	                   	{
	                       	 	text: '混合图',
	                        	onclick: function () {
	                            		f_chgchart"+cdcnt+"('混合图');
	                       		}
	                   	},
	                   	{
	                       	 	text: '柱形堆叠图',
	                        	onclick: function () {
	                            		f_chgchart"+cdcnt+"('柱形堆叠图');
	                       		}
	                   	},
	                   	{
	                       	 	text: '漏斗图',
	                        	onclick: function () {
	                            		f_chgchart"+cdcnt+"('漏斗图');
	                       		}
	                   	},
	                   	{
	                        	separator: true
	                    	}
	                   ]
	                   .concat(Highcharts.getOptions().exporting.buttons.contextButton.menuItems)
	                 }
	       	   }
	        },
	        title: {
	            text: '"+GetTopic(db,sytid,topic)+"'
	        },
	        plotOptions: {
	            column: {
	                depth: 25
	            }
	        },
	        xAxis: {
	            "+getxAxis(db,ds,sytid,topic,0)+"
	        },
	        yAxis: {
	            allowDecimals: false,
	            title: {
	                text: 'z '
	            }
	        },
	        series: ["+getseries(db,ds,sytid,topic,0)+"]
	    };
    	$(document).ready(function(){
    		options"+cdcnt+".chart.type ='"+BI_TYP1+"';
		var chart = new Highcharts.Chart(options"+cdcnt+");
	});
</script>";
	script+="<script>
		function f_chgchart"+cdcnt+"(val){
			if(val=='柱状图'){
				options"+cdcnt+".labels={};
				options"+cdcnt+".legend={};
				options"+cdcnt+".plotOptions={};
				
				options"+cdcnt+".chart.type ='column';
				 options"+cdcnt+".chart.options3d={
				                enabled: false,
				                alpha: 0,
				                beta: 0,
				                depth: 100
				            };
				options"+cdcnt+".series=["+getseries(db,ds,sytid,topic,0)+"];
				options"+cdcnt+".xAxis={"+getxAxis(db,ds,sytid,topic,0)+"};
				var chart = new Highcharts.Chart(options"+cdcnt+");
			}
			else if(val=='折线图'){	
				options"+cdcnt+".plotOptions={};
				options"+cdcnt+".xAxis={};
			 	options"+cdcnt+".chart.options3d={
				                enabled: false,
				                alpha: 0,
				                beta: 0,
				                depth: 100
				            };	
        			options"+cdcnt+".yAxis.plotLines=[{
			                value: 0,
			                width: 1,
			                color: '#808080'
			            }];
				options"+cdcnt+".chart.type ='line';
				options"+cdcnt+".legend ={
				            layout: 'vertical',
				            align: 'right',
				            verticalAlign: 'middle',
				            borderWidth: 0
				        };
				        options"+cdcnt+".series=["+getseries(db,ds,sytid,topic,0)+"];
				var chart = new Highcharts.Chart(options"+cdcnt+");
			}
			else if(val=='区域图'){
				options"+cdcnt+".labels={};
				options"+cdcnt+".legend={};
				options"+cdcnt+".xAxis={};
				options"+cdcnt+".plotOptions={};
				options"+cdcnt+".chart.type ='area';
				 options"+cdcnt+".chart.options3d={
				                enabled: false,
				                alpha: 0,
				                beta: 0,
				                depth: 100
				            };
				options"+cdcnt+".series=["+getseries(db,ds,sytid,topic,0)+"];
				
				var chart = new Highcharts.Chart(options"+cdcnt+");
			}
			else if(val=='曲线区域图'){
				options"+cdcnt+".labels={};
				options"+cdcnt+".legend={};
				options"+cdcnt+".xAxis={};
				options"+cdcnt+".plotOptions={};
				options"+cdcnt+".chart.type ='areaspline';
				 options"+cdcnt+".chart.options3d={
				                enabled: false,
				                alpha: 0,
				                beta: 0,
				                depth: 100
				            };
				options"+cdcnt+".series=["+getseries(db,ds,sytid,topic,0)+"];
				 var chart = new Highcharts.Chart(options"+cdcnt+");
			}
			else if(val=='3D柱状图'){
				options"+cdcnt+".labels={};
				options"+cdcnt+".legend={};
				options"+cdcnt+".xAxis={};
				options"+cdcnt+".plotOptions={};
				 options"+cdcnt+".chart.type='column';
				 options"+cdcnt+".chart.margin=75;
				 options"+cdcnt+".chart.options3d={
				                enabled: true,
				                alpha: 10,
				                beta: 25,
				                depth: 70
				            };
				 options"+cdcnt+".plotOptions.column={
				                depth: 25
				            };
				 options"+cdcnt+".series=["+getseries(db,ds,sytid,topic,0)+"];
				 var chart = new Highcharts.Chart(options"+cdcnt+");
			}
			else if(val=='3D饼图'){
				 options"+cdcnt+".chart.type='pie';
				 options"+cdcnt+".plotOptions={};
				 options"+cdcnt+".xAxis={};
				 options"+cdcnt+".chart.options3d={
			                enabled: true,
			                alpha: 45,
			                beta: 0
			            };
			           options"+cdcnt+".series=[{
				            type: 'pie',
				            name: '合计',
				            data: "+getseriessum(db,ds,sytid,topic,0)+"
				   }];
				   
				   options"+cdcnt+".plotOptions={
				            pie: {
				                allowPointSelect: true,
				                cursor: 'pointer',
				                dataLabels: {
				                    enabled: true,
				                    color: '#cdcdcd',
				                    connectorColor: '#000000',
				                    format: '<b>{point.name}</b>: {point.percentage:.1f} %'
				                }
				            }
				        };
				 options"+cdcnt+".labels={};
			          var chart = new Highcharts.Chart(options"+cdcnt+");
			}
			else if(val=='混合图'){
				 options"+cdcnt+".chart.options3d={};
				 options"+cdcnt+".plotOptions={};
				 options"+cdcnt+".xAxis={};
				 options"+cdcnt+".series=["+getserieshunhe(db,ds,sytid,topic,0)+"];
				 options"+cdcnt+".labels= {                                                         
			            items: [{                                                     
			                html: '合计',                          
			                style: {                                                  
			                    left: '150px',                                         
			                    top: '8px',                                           
			                    color: 'black'                                        
			                }                                                         
			            }]                                                            
			        };                                                          
				 var chart = new Highcharts.Chart(options"+cdcnt+");
			}
			else if(val=='柱形堆叠图'){
				
				options"+cdcnt+".labels={};
				options"+cdcnt+".legend={};
				options"+cdcnt+".xAxis={};
				options"+cdcnt+".chart.type ='column';
				 options"+cdcnt+".chart.options3d={
				                enabled: false,
				                alpha: 0,
				                beta: 0,
				                depth: 100
				            };
				options"+cdcnt+".plotOptions={
					            column: {
					                stacking: 'normal'
					            }
					        };
				options"+cdcnt+".series=["+getseries(db,ds,sytid,topic,0)+"];
				var chart = new Highcharts.Chart(options"+cdcnt+");
			}
			else if(val=='漏斗图'){
				options"+cdcnt+".labels={};
				options"+cdcnt+".legend={};
				options"+cdcnt+".plotOptions={
					            series: {
					                dataLabels: {
					                    enabled: true,
					                    format: '<b>{point.name}</b> ({point.y:,.0f})',
					                    color: 'black',
					                    softConnector: true
					                },
					                neckWidth: '30%',
					                neckHeight: '25%'
					            }
					        };
				options"+cdcnt+".chart.type ={
					            type: 'funnel',
					            marginRight: 100
					        };
				
				options"+cdcnt+".series=[{
						   name: '合计',
						   data: "+getseriessum(db,ds,sytid,topic,0)+"
						}];
				options"+cdcnt+".xAxis={};
				options"+cdcnt+".yAxis={};
				var chart = new Highcharts.Chart(options"+cdcnt+");
			}

		}
	
	</script>";
	return style+script+html;
}
//获取BI sql
function getbisql(db,request,sytid,topic,modguid,usr){

	db = new pub.EADatabase();
	
	var tablename = db.GetSQL("select sourceds from dim_model where guid='"+modguid+"'");
	var isCross = isCrossReport(db,sytid,topic);
	var sql="";
	if (!isCross) {
		sql = "select "
			+ getVdimWithName(db,sytid,topic,modguid,tablename) + ","
			+ getTarget(db,sytid,topic,true,modguid,tablename)
			+ "\n  from "
			+ tablename
			+ "\n where "
			+ getSearchParam(db,sytid,topic,request)
			+ "\n group by "
			+ getVdim(db,sytid,topic)
			+ "\n order by "
			+ getVdimOrders(db,sytid,topic,modguid,tablename);
	} else {
		sql = "select "
			+ getVdimWithName(db,sytid,topic,modguid,tablename) + ","
			+ colDate2Char(db,sytid,topic,getTarget(db,sytid,topic,false,modguid,tablename))
			+ "\n  from "
			+ tablename
			+ "\n where "
			+ getSearchParam(db,sytid,topic,request);
		var r_HCols = getVdimName(db,sytid,topic,modguid,tablename);		//交叉行字段
		var r_VCols = getCrossCol(db,sytid,topic);	//交叉列字段
		var r_VCol = getCrossTarget(db,sytid,topic);	//交叉值字段
		var colsql = getColSQL(db,sytid,topic,r_VCols);	//交叉列字段SQL
		var orderby = getVdimOrders(db,sytid,topic,modguid,tablename);		//行排序字段
		sql = pub.EASqlFunc.GetSql2CrossTableSQL(db,sql,colsql,r_HCols,r_VCols,r_VCol,orderby);
	}
	sql=web.EASession.GetSysValue(sql,request);//替换request 中[%id]
	sql=web.EASession.GetSysValue(sql,web.EASession.GetUserinfo(request));

	
	return sql;
}

//获取维度（带中文名）
function getVdimWithName(db,sytid,topic,modguid,tablename)
{
	var str = "";
	var sql = "select vdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	var vdim = db.GetSQL(sql);
	
	var arr = vdim.split(",");
	for (var i = 0;i < arr.length();i ++) {
		var colnam = GetColname(db,arr[i],modguid,tablename); //获取字段名称
		if (colnam == "") colnam = arr[i];
		if (str != "") str += ",";
		str += arr[i] +" as \""+ colnam +"\"";
	}
	return str;
}

//获取目标（带中文名）
function getTarget(db,sytid,topic,sumflg,modguid,tablename)
{
	var str = "";
	var sql = "select hdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	var hdim = db.GetSQL(sql);
	
	var arr = hdim.split(",");
	if (!sumflg) {
		for (var i = 0;i < arr.length();i ++) {
			if (str != "") str += ",";
			str += arr[i];
		}
	} else {
		for (var i = 0;i < arr.length();i ++) {
			var colnam = GetColname(db,arr[i],modguid,tablename); //获取字段名称
			if (colnam == "") colnam = arr[i];
			
			if (i == 0) {
				str = "sum("+ arr[i] +") as \""+ colnam +"\"";
			} else {
				str += ",sum("+ arr[i] +") as \""+ colnam +"\"";
			}
		}
	}
	return str;
}

//获取查询条件
function getSearchParam(db,sytid,topic,request)
{
	var where = "1=1";
	
	var sql = "select refmod,lvl,to_char(sysdate,'yyyy-mm-dd') dat from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	
	var ds = db.GetXMLSQL(sql);
	var refmod = ds.getStringAt(0,"REFMOD");
	var lvl = ds.getStringAt(0,"LVL");
	var sysdate = ds.getStringAt(0,"DAT");
	
	if (lvl != null && lvl != "") {
		where += "\n   and "+lvl;
	}
	
	sql = "select * from dim_dim where refmod='%s' order by seq".format([refmod]);

	var dimxmlds = db.GetXMLSQL(sql);

	for (var i = 0;i < dimxmlds.getRowCount();i ++) {
		var id = dimxmlds.getStringAt(i,"ID");
		var name = dimxmlds.getStringAt(i,"NAME");
		var datatyp = dimxmlds.getStringAt(i,"DATATYP");
		var control = dimxmlds.getStringAt(i,"CONTROL");
		var keyval = dimxmlds.getStringAt(i,"KEYVAL");
		var val = dimxmlds.getStringAt(i,"defval");
		var dat1 = "";
		var dat2 = "";
		
		if (datatyp == "DATE") {
			dat1 = pub.EAFunc.NVL(request.getParameter("STA"+id),sysdate);
			dat2 = pub.EAFunc.NVL(request.getParameter("END"+id),sysdate);
			
			where += "\n   and " + id + ">=to_date(decode('"+dat1+"','','1900-01-01','"+dat1+"'),'yyyy-mm-dd')";
			where += "\n   and " + id + "<=to_date(decode('"+dat2+"','','2900-01-01','"+dat2+"'),'yyyy-mm-dd')";
		} else {
			if (val != "") {
				if (control != "" && keyval != "") {
					if (datatyp.indexOf("CHAR") >= 0) where += "\n   and "+ id +"='"+ val +"'";
					else where += "\n   and to_char("+ id +")='"+ val +"'";
				} else {
					if (datatyp.indexOf("CHAR") >= 0) where += "\n   and nvl("+ id +",' ') like '"+ val +"%'";
					else where += "\n   and nvl(to_char("+ id +"),' ') like '"+ val +"%'";
				}
			}
		}
	}

	return where;
}

//日期类型的转为字符型 select dat,itmid from aaa --> select to_char(dat,'yyyy-mm-dd') dat,itmid from aaa
function colDate2Char(db,sytid,topic,cols)
{
	var ret = "";
	var arrcols = cols.split(",");
	var incols = pub.EAFunc.SQLIN(cols);
	var sql = "select * from dim_dim where refmod=(select refmod from dim_topic where sytid='%s' and id='%s') and id in (%s)".format([sytid,topic,incols]);
	var ds = db.GetXMLSQL(sql);
	var colid = ds.getStringAt(0,"ID");
	var coltyp = ds.getStringAt(0,"DATATYP");
	
	for (var i = 0;i < arrcols.length();i ++) {
		if (ret != "") ret += ",";
		if (colid == arrcols[i] && coltyp == "DATE") ret += "to_char("+arrcols[i]+",'yyyy-mm-dd') "+arrcols[i];
		else ret += arrcols[i];
	}
	return ret;
}



//获取维度（中文名,用于交叉表行字段）
function getVdimName(db,sytid,topic,modguid,tablename)
{
	var str = "";
	var sql = "select vdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	var vdim = db.GetSQL(sql);
	
	var arr = vdim.split(",");
	for (var i = 0;i < arr.length();i ++) {
		var colnam = GetColname(db,arr[i],modguid,tablename); //获取字段名称
		if (colnam == "") colnam = arr[i];
		if (str != "") str += ",";
		str += colnam;
	}
	return str;
}


//取得交叉列字段
function getCrossCol(db,sytid,topic)
{
	var sql = "select b.id from dim_topic a,dim_dim b where a.refmod=b.refmod and a.id='%s' and a.sytid='%s' and a.hdim like '%'||b.id||'%'".format([topic,sytid]);
	return db.GetSQL(sql);
}

//交叉值字段
function getCrossTarget(db,sytid,topic)
{
	var sql = "select a.hdim,b.id from dim_topic a,dim_dim b where a.refmod=b.refmod and a.id='%s' and a.sytid='%s' and a.hdim like '%'||b.id||'%'".format([topic,sytid]);
	var ds = db.GetXMLSQL(sql);
	var hdim = ds.getStringAt(0,"HDIM");
	var vdim = ds.getStringAt(0,"ID");
	var arr = hdim.split(",");
	for (var i = 0;i < arr.length();i ++) {
		if (arr[i] != vdim) return arr[i];
	}
	return "";
}

//交叉列字段SQL
function getColSQL(db,sytid,topic,vcol)
{
	var sql = "select keyval,wher from dim_dim where refmod=(select refmod from dim_topic where sytid='%s' and id='%s') and id='%s'".format([sytid,topic,vcol]);
	var ds = db.GetXMLSQL(sql);
	var view_name = ds.getStringAt(0,"KEYVAL");
	var where = ds.getStringAt(0,"WHER");
	if (view_name == "") {
		return "";
	} else {
		if (where != "") where = " and " + where;
		sql = "select name from "+ view_name +" where 1>0 " + where;
		return sql;
	}
}
//排序依据（中文名）
function getVdimOrders(db,sytid,topic,modguid,tablename)
{
	var sql = "select orders,vdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	var ds = db.GetXMLSQL(sql);
	
	var str = ds.getStringAt(0,"ORDERS");
	var vdim = ds.getStringAt(0,"VDIM");
	
	if (str != null && str != "") return str;
	
	str = "";
	var arr = vdim.split(",");
	for (var i = 0;i < arr.length();i ++) {
		var colnam = GetColname(db,arr[i],modguid,tablename); //获取字段名称
		if (colnam == "") colnam = arr[i];
		if (str != "") str += ",";
		str += colnam;
	}
	return str;
}
//是否交叉
function isCrossReport(db,sytid,topic)
{
	var sql = "select a.hdim,b.id from dim_topic a,dim_dim b where a.refmod=b.refmod and a.sytid='%s' and a.id='%s' and a.hdim like '%'||b.id||'%'".format([sytid,topic]);
	var rowcnt = db.GetSQLRowCount(sql);
	if (rowcnt > 0) return true;
	return false;
}

//获取维度
function getVdim(db,sytid,topic)
{
	var sql = "select vdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	return db.GetSQL(sql);
}

//字段名称
function GetColname(db,colid,modguid,tablename)
{
	var ret = "";
	var ds = db.QuerySQL("select name from dim_dim where refmod='"+modguid+"' and upper(id)=upper('"+colid+"')"); //维度
	if ( ds.getRowCount() > 0 ) ret = ds.getStringAt(0,"NAME");
	else {
		ds = db.QuerySQL("select nvl(supername,'')||'Ｘ'||name name from dim_target where refmod='"+modguid+"' and upper(id)=upper('"+colid+"')"); //目标
		if ( ds.getRowCount() > 0 ) ret = ds.getStringAt(0,"NAME");
		else {
			ds = db.QuerySQL(" select comments name from user_col_comments where upper(table_name)=upper('"+tablename+"') and upper(column_name)=upper('"+colid+"')"); //系统
			if ( ds.getRowCount() > 0 ) ret = ds.getStringAt(0,"NAME");
		}
	}
	if ( ret == "" ) ret = colid;
	return ret;
}
//得到主题
function GetTopic(db,sytid,topicid)
{
	var ds = null;
	var curtopic = topicid;

	ds = db.QuerySQL("select name,longname,hdim,vdim,hdim||','||vdim hvdim,nvl(picnote,'MSColumn3D-1') picnote,vdimshowcol,piclocation,xchart from dim_topic where sytid='"+sytid+"' and id='"+topicid+"'");
	if ( ds.getRowCount() == 0 ) throw new Exception( "主题"+topicid+"没有找到" );
	
	var str =ds.getStringAt(0,"NAME");
	return str ;
}

//bchgxy	图型轴向 = 1 X和Y轴旋转
function getseries(db,ds,sytid,topic,bchgxy){

	var statrow=0;
	var statcol=0;
	var torow=ds.getRowCount();
	var tocol=ds.getColumnCount();
	var title = GetTopic(db,sytid,topic);
	var str="";
	if (bchgxy == "0") {
		for ( var r=statrow;r<torow;r++ ) {
			str+="{name: '"+ds.getStringAt(r,ds.getColumnName(0))+"',data: [";
			for(var c=1;c<tocol;c++){
				if(c==tocol-1)
					str+=ds.getStringAt(r,ds.getColumnName(c));
				else
					str+=ds.getStringAt(r,ds.getColumnName(c))+",";
			}
			str+="]";
			if(r==torow-1) str+="}"; else str+="},";
			
		}
	} else {
		for ( var c=1;c<tocol;c++ ) {
			str+="{name: '"+ds.getColumnName(c)+"',data: [";
			for(var r=1;r<torow;r++){
				if(c==torow-1)
					str+=ds.getStringAt(r,ds.getColumnName(c));
				else
					str+=ds.getStringAt(r,ds.getColumnName(c))+",";
			}
			str+="]";
			if(c==tocol-1) str+="}"; else str+="},";
		}
	}

	return str;
}

//bchgxy	图型轴向 = 1 X和Y轴旋转
function getxAxis(db,ds,sytid,topic,bchgxy){

	var statrow=0;
	var statcol=0;
	var torow=ds.getRowCount();
	var tocol=ds.getColumnCount();
	var str="";
	if (bchgxy == "0") {
		str+="categories:[";
		for ( var c=1;c<tocol;c++ ) {
			if(c==tocol-1)
				str+="'"+ds.getColumnName(c)+"'";
			else
				str+="'"+ds.getColumnName(c)+"',";
		}
		str+="]";
	} 
	else {
		str+="categories: [";
		for ( var r=0;r<torow;r++ ) {
			if(r==torow-1)
				str+="'"+ds.getStringAt(r,ds.getColumnName(0))+"'";
			else
				str+="'"+ds.getStringAt(r,ds.getColumnName(0))+"',";
		}
		str+="]";
	}
	
	return str;
}

//bchgxy图型轴向 = 1 X和Y轴旋转
function getseriessum(db,ds,sytid,topic,bchgxy){

	var statrow=0;
	var statcol=0;
	var torow=ds.getRowCount();
	var tocol=ds.getColumnCount();
	var title = GetTopic(db,sytid,topic);
	var str="[";
	var sum=0;
	var colsum=0;
	if (bchgxy == "0") {
		for ( var r=0;r<torow;r++ ) {
			colsum=0;
			for ( var c=1;c<tocol;c++ ) {
				colsum+=ds.getStringAt(r,ds.getColumnName(c))*1.00;
			}
			sum+=colsum;
		}
		for ( var r=0;r<torow;r++ ) {
			colsum=0;
			for ( var c=1;c<tocol;c++ ) {
				colsum+=ds.getStringAt(r,ds.getColumnName(c))*1.00;
			}
//			throw new Exception(colsum+"--"+sum+"==="+colsum*100/sum.toFixed(2));
			if(r==torow-1)
				str+="['"+ds.getStringAt(r,ds.getColumnName(0))+"',"+colsum+"]";
			else
				str+="['"+ds.getStringAt(r,ds.getColumnName(0))+"',"+colsum+"],";
		}
	} 
	else {
		for ( var c=1;c<tocol;c++ ) {
			colsum=0;
			for ( var r=0;r<torow;r++ ) {
				colsum+=ds.getStringAt(r,ds.getColumnName(c))*1.00;
			}
			if(c==tocol-1)
				str+=" ['"+ds.getStringAt(0,ds.getColumnName(c))+"',"+ds.getStringAt(tocol-1,ds.getColumnName(c))+"]";
			else
				str+=" ['"+ds.getStringAt(0,ds.getColumnName(c))+"',"+ds.getStringAt(tocol-1,ds.getColumnName(c))+"],";
		}
	}
	str+="]";
	return str;
}

//bchgxy	图型轴向 = 1 X和Y轴旋转
function getserieshunhe(db,ds,sytid,topic,bchgxy){

	var statrow=0;
	var statcol=0;
	var torow=ds.getRowCount();
	var tocol=ds.getColumnCount();
	var title = GetTopic(db,sytid,topic);
	var str="";
	
	if (bchgxy == "0") {
		for ( var r=statrow;r<torow;r++ ) {
			str+="{type:'column',name: '"+ds.getStringAt(r,ds.getColumnName(0))+"',data: [";
			for(var c=1;c<tocol;c++){
				if(c==tocol-1)
					str+=ds.getStringAt(r,ds.getColumnName(c));
				else
					str+=ds.getStringAt(r,ds.getColumnName(c))+",";
			}
			str+="]";
			if(r==torow-1) str+="}"; else str+="},";
			
		}
	} else {
		for ( var c=1;c<tocol;c++ ) {
			str+="{type:'column',name: '"+ds.getStringAt(0,ds.getColumnName(c))+"',data: [";
			for(var r=1;r<torow;r++){
				if(c==torow-1)
					str+=ds.getStringAt(r,ds.getColumnName(c));
				else
					str+=ds.getStringAt(r,ds.getColumnName(c))+",";
			}
			str+="]";
			if(c==tocol-1) str+="}"; else str+="},";
		}
	}
	str+=",{type: 'spline', name: '平均',data:"+getseriespingjun(db,ds,sytid,topic,bchgxy)+" },{type:'pie',name: '合计饼图',data:"+getseriessum(db,ds,sytid,topic,bchgxy)+",center: [150, 80],                                            
            size: 100,                                                    
            showInLegend: false,                                          
            dataLabels: {                                                 
                enabled: true,
                color: '#cdcdcd',
                connectorColor: '#000000',
                format: '<b>{point.name}</b>: {point.percentage:.1f} %'

            } }";
	return str;
}


//bchgxy图型轴向 = 1 X和Y轴旋转 去平均数
function getseriespingjun(db,ds,sytid,topic,bchgxy){

	var statrow=0;
	var statcol=0;
	var torow=ds.getRowCount();
	var tocol=ds.getColumnCount();
	var title = GetTopic(db,sytid,topic);
	var str="[";
	if (bchgxy == "1") {
		var sum=0;
		var colsum=0;
		for ( var r=0;r<torow;r++ ) {
			colsum=0;
			for ( var c=1;c<tocol;c++ ) {
				colsum+=ds.getStringAt(r,ds.getColumnName(c))*1.00;
			}
			sum+=colsum;
		}
		for ( var r=0;r<torow;r++ ) {
			colsum=0;
			for ( var c=1;c<tocol;c++ ) {
				colsum+=ds.getStringAt(r,ds.getColumnName(c))*1.00;
			}
//			throw new Exception(colsum+"--"+sum+"==="+colsum*100/sum.toFixed(2));
//			colsum=colsum/sum;
			if(r==torow-1)
				str+=colsum;
			else
				str+=colsum+",";
		}
	} 
	else {
		var sum=0;
		var colsum=0;
		for ( var c=1;c<tocol;c++ ) {
			colsum=0;
			for ( var r=0;r<torow;r++ ) {
				colsum+=ds.getStringAt(r,ds.getColumnName(c))*1.00;
			}
			sum+=colsum;
		}
		for ( var c=1;c<tocol;c++ ) {
			colsum=0;
			for ( var r=0;r<torow;r++ ) {
				colsum+=ds.getStringAt(r,ds.getColumnName(c))*1.00;
			}
			var a=db.GetSQL("select round("+colsum+"/"+torow+",2) from dual");
//			throw new Exception("select round("+colsum/torow+",2) from dual");
			if(c==tocol-1)
				str+=a;
			else
				str+=a+",";
		}
	}
	str+="]";
	return str;
}

//
// 
//
function GetMap() {
	var html = "	<html>
		<head>
			<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />
			<meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no\" />
			<style type=\"text/css\">
				body, html{width: 100%;height: 100%; margin:0;font-family:\"微软雅黑\";}
				#l-map{height:800px;width:100%;}
			</style>
			<script type=\"text/javascript\" src=\"http://api.map.baidu.com/api?v=2.0&ak=bcqnSYjGSOPcmxcDpG8T9nMs\"></script>
			<title>附近医院</title>
		</head>
		<body onload=\"load()\">
			<div id=\"l-map\"></div>
			
		</body>
		</html>
		<script type=\"text/javascript\">
			function load() {
				navigator.geolocation.getCurrentPosition(onSuccess, onError,{ maximumAge: 3000, timeout: 10000, enableHighAccuracy: true });
			}
			
			var onSuccess = function (position) {
				var lat = position.coords.latitude;
				var lng = position.coords.longitude;
			if(lat!=''&&lat!=null&&lng!=''&&lng!=null){
				var map = new BMap.Map('l-map');
				var gpsPoint=new BMap.Point(lng,lat);
				map.centerAndZoom(gpsPoint, 16);
				map.addControl(new BMap.NavigationControl());  //添加默认缩放平移控件 v2.0

				var marker1 = new BMap.Marker(gpsPoint);  // 创建标注	
				map.addOverlay(marker1);              // 将标注添加到地图中	
				
				map.setCenter(gpsPoint);
				var label = new BMap.Label('当前位置',{offset:new BMap.Size(20,-10)});
				map.addOverlay(label);//添加标签

				var local = new BMap.LocalSearch(map, {
					renderOptions:{map: map, autoViewport:true}
				});
				local.searchNearby('医院', gpsPoint);
			}
			};
			function onError(error) {  
				alert(JSON.stringify(error)); 
			} 
		</script>";
		
		return html;
}



//求和
function FloatAdd(arg1,arg2){  
	
	var r1;
	var r2;
	var m;  
   	try{r1=arg1.toString().split(".")[1].length;}catch(e){r1=0;}  
   	try{r2=arg2.toString().split(".")[1].length;}catch(e){r2=0;}  
  	m=langpack.Math.pow(10,langpack.Math.max(r1,r2))  ;
  	return (arg1*m+arg2*m)/m;
//  	var b1=new lamath.BigDecimal(arg1.toString());
//	var b2=new lamath.BigDecimal(arg2.toString());
//    	return b1.add(b2);
}

}