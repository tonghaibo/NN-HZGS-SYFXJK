function x_showflg_BI(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
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
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
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

//
// 
//
function Biwap(){
	var iBIID = request.getParameter("BIID");
	if(iBIID !=null) BI_GUID = iBIID ; 
	var iBITITID = request.getParameter("BITITID");
	if(iBITITID !=null) BI_TITID = iBITITID ; 
	var iBI_TYP = request.getParameter("BI_TYP");//
	if(iBI_TYP!=null) BI_TYP = iBI_TYP; 
	var iBI_TYP1 = request.getParameter("BI_TYP1");//��ʾ��ʼͼ�η��
	if(iBI_TYP1!=null) DEFCHARTTYPE = iBI_TYP1; 	

	if(TB_IFHEAD==null||TB_IFHEAD==""||TB_IFHEAD=="null")TB_IFHEAD="false";
	if(TB_IFHEADBORDER==null||TB_IFHEADBORDER==""||TB_IFHEADBORDER=="null")TB_IFHEADBORDER="false";
	if(TB_HEAD==null||TB_HEAD==""||TB_HEAD=="null")TB_HEAD="";
	if(TB_WIDTH==null||TB_WIDTH==""||TB_WIDTH=="null")TB_WIDTH="100%";
	if(TB_HEIGHT==null||TB_HEIGHT==""||TB_HEIGHT=="null")TB_HEIGHT="100%";
	if(TB_ROLBGCOLOR==null||TB_ROLBGCOLOR==""||TB_ROLBGCOLOR=="null")TB_ROLBGCOLOR="#d5d5d5";
	if(TB_BORDERCOLOR==null||TB_BORDERCOLOR==""||TB_BORDERCOLOR=="null")TB_BORDERCOLOR="#cdcdcd";
	if(LINE_HEIGHT==null||LINE_HEIGHT==""||LINE_HEIGHT=="null")LINE_HEIGHT="25px";
	if(TB_TABLW==null||TB_TABLW==""||TB_TABLW=="null")TB_TABLW="true";
	if(TB_ENTBTYP==null||TB_ENTBTYP==""||TB_ENTBTYP=="null")TB_ENTBTYP="";
	var usr = web.EASession.GetUserinfo(request);
//	var usr = web.EASession.GetLoginInfo(request);
	var sytid =pubpack.EAFunc.NVL( request.getParameter("SYTID"),"");
	if(sytid==""&&usr!=null){
		sytid = usr.getSytid();
	}
	var topic = pub.EAFunc.NVL(BI_TITID,"");
	var modguid = pub.EAFunc.NVL(BI_GUID,"");
	var sql=getbisql(db,request,sytid,topic,modguid,usr);
	if(IFROWSUM==null || IFROWSUM=="") IFROWSUM = "1";
	if(IFCOLSUM==null || IFCOLSUM=="") IFCOLSUM = "1";
	if(DEFCHARTTYPE==null || DEFCHARTTYPE=="") DEFCHARTTYPE= "column";

	var ds=db.QuerySQL(sql);
	
//	throw new Exception(sql);	
	if(ds.getRowCount()==0) return "û�в�ѯ������";

	if(BI_TYP==0){// ������
		return bityptable(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,IFROWSUM,IFCOLSUM);
	}
	else if(BI_TYP==1){//��ͼ
		return bitypicon(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,DEFCHARTTYPE);
	}
	else if(BI_TYP==2){//���·ָ���ͼ�ͱ�
		var html="<table width=\""+TB_WIDTH+"\" height=\""+TB_HEIGHT+"\">";
		html+="<tr><td>"+bitypicon(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,DEFCHARTTYPE)+"</td></tr>";
		html+="<tr><td valign=top>"+bityptable(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,IFROWSUM,IFCOLSUM)+"</td></tr>";
		html+="</table>";
		return html;
	}
	else if(BI_TYP==3){//�����ͼ
		var html="<table width=\""+TB_WIDTH+"\" height=\""+TB_HEIGHT+"\">";
		html+="<tr><td valign=top width=50%>"+bitypicon(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,DEFCHARTTYPE)+"</td>";
		html+="<td valign=top width=50%>"+bityptable(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,IFROWSUM,IFCOLSUM)+"</td></tr>";
		html+="</table>";
		return html;
	}
	else{//��ͼ�ұ�
		var html="<table width=\""+TB_WIDTH+"\" height=\""+TB_HEIGHT+"\">";
		html+="<tr><td valign=top width=50%>"+bityptable(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,IFROWSUM,IFCOLSUM)+"</td>";
		
		html+="<td valign=top width=50%>"+bitypicon(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,DEFCHARTTYPE)+"</td></tr>";
		html+="</table>";
		return html;
	}
}

//BI����
function bityptable(db,ds,request,sytid,topic,modguid,usr,BI_GUID,BI_TITID,BI_TYP,TB_IFHEAD,TB_IFHEADBORDER,TB_HEAD,TB_WIDTH,TB_HEIGHT,TB_ROLBGCOLOR,TB_BORDERCOLOR,LINE_HEIGHT,TB_TABLW,TB_ENTBTYP,IFROWSUM,IFCOLSUM){
	

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
	//throw new Exception ( "IFCOLSUM="+IFCOLSUM+",IFROWSUM="+IFROWSUM+",rowcount()="+ ds.getRowCount()+",colcount="+ds.getColumnCount() );
	var hjcolstr=new Array();//�б���ϼ�ֵ
	var rownum = ds.getRowCount();
	if(IFCOLSUM!="1")rownum = rownum -1 ;
	for(var r=0; r<=rownum ; r++){
		var colsum=0;
		var rowsum=0;
		if(r==0){
			html+="<tr style=\"height:30px\" bgcolor=\""+TB_ROLBGCOLOR+"\">";
			for(var c=0;c<ds.getColumnCount();c++){
				html+="<td background=xlsgrid/images/xlsgrid/tab.bg.off.grid.gif style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px 1px 1px 1px;\">"+ds.getColumnName(c)+"</td>";
			}
			if(IFROWSUM=="1"){
				html+="<td background=xlsgrid/images/xlsgrid/tab.bg.off.grid.gif style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px 1px 1px 1px;\">�ϼ�</td>";
			}
			html+="</tr>";
		}
		if(TB_TABLW==true&&r%2==1) trbgcolor="#F9F9F9"; else trbgcolor="#FFFFFF";
		if(TB_ENTBTYP==true) tdborder=0;  else tdborder=1;
		html+="<tr bgcolor=\""+trbgcolor+"\">";
		
		for(var c=0;c< ds.getColumnCount();c++){
			//���һ�кϼ�
			if(r==ds.getRowCount() ){
				//throw new Exception("���һ�кϼ�");
				if(c==0&&ds.getColumnCount()>1)
					html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px "+tdborder+"px 1px 1px;\" align=center>�ϼ�</td>";
				else{
					html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px "+tdborder+"px 1px "+tdborder+"px;\" align=right>"+pubpack.EAFunc.formatMoney(hjcolstr[c],2)+"</td>";
					
					try{
						rowsum=FloatAdd(hjcolstr[c],rowsum);
					}
					catch( eee ){
						//throw new Exception ( "FloatAdd error jcolstr[c]="+hjcolstr[c]+",rowsum="+rowsum+",c="+c+",hjcolstr="+hjcolstr +",ds.getRowCount()="+ds.getColumnCount()+",e="+ eee);
					}
				}
				if(c==ds.getColumnCount()-1&&IFROWSUM=="1"){
						html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px 1px 1px "+tdborder+"px;\" align=right>"+pubpack.EAFunc.formatMoney(rowsum,2)+"</td>";
				}
				
			}
			else{
				if(c>0){
					var su=ds.getStringAt(r,c);
					colsum=FloatAdd(colsum,su);
					if(r==0){ 
						hjcolstr[c]=ds.getStringAt(r,c); 
					}
					else if(r>0){
					
						hjcolstr[c]=FloatAdd(hjcolstr[c],ds.getStringAt(r,c));
						
					}
				}
				if(c==0&&ds.getColumnCount()>1)// ÿ�е�һ����Ԫ��
					html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px "+tdborder+"px 1px 1px;\" align=center>"+ds.getStringAt(r,c)+"</td>";
				else// ÿ�к�����Ԫ����Ҫ����С��λ
					html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px "+tdborder+"px 1px "+tdborder+"px;\" align=right>"+pubpack.EAFunc.formatMoney(ds.getStringAt(r,c),2)+"</td>";
				if(c==ds.getColumnCount()-1&&IFROWSUM=="1"){//�ϼ�
					html+="<td style=\"border:solid "+TB_BORDERCOLOR+";font-size:12px; border-width:1px 1px 1px "+tdborder+"px;\" align=right>"+pubpack.EAFunc.formatMoney(colsum,2)+"</td>";
				}
			}
			
		}
		
		html+="</tr>";

	}
	
	
	html+="</table>";

	return html;

}
//BIͼ��
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
	                       	 	text: '��״ͼ',
	                        	onclick: function () {
	                            		f_chgchart"+cdcnt+"('��״ͼ');
	                       		}
	                   	},
	                   	{
	                       	 	text: '����ͼ',
	                        	onclick: function () {
	                            		f_chgchart"+cdcnt+"('����ͼ');
	                       		}
	                   	},
	                   	{
	                       	 	text: '����ͼ',
	                        	onclick: function () {
	                            		f_chgchart"+cdcnt+"('����ͼ');
	                       		}
	                   	},
	                   	{
	                       	 	text: '��������ͼ',
	                        	onclick: function () {
	                            		f_chgchart"+cdcnt+"('��������ͼ');
	                       		}
	                   	},
	                   	{
	                       	 	text: '3D��״ͼ',
	                        	onclick: function () {
	                            		f_chgchart"+cdcnt+"('3D��״ͼ');
	                       		}
	                   	},
	                   	{
	                       	 	text: '3D��ͼ',
	                        	onclick: function () {
	                            		f_chgchart"+cdcnt+"('3D��ͼ');
	                       		}
	                   	},
	                   	{
	                       	 	text: '���ͼ',
	                        	onclick: function () {
	                            		f_chgchart"+cdcnt+"('���ͼ');
	                       		}
	                   	},
	                   	{
	                       	 	text: '���ζѵ�ͼ',
	                        	onclick: function () {
	                            		f_chgchart"+cdcnt+"('���ζѵ�ͼ');
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
			if(val=='��״ͼ'){
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
			else if(val=='����ͼ'){	
				options"+cdcnt+".plotOptions={};
				options"+cdcnt+".chart.margin={};
				options"+cdcnt+".xAxis={"+getxAxis(db,ds,sytid,topic,0)+"};
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
				options"+cdcnt+".legend ={};
				        options"+cdcnt+".series=["+getseries(db,ds,sytid,topic,0)+"];
				var chart = new Highcharts.Chart(options"+cdcnt+");
			}
			else if(val=='����ͼ'){
				options"+cdcnt+".labels={};
				options"+cdcnt+".legend={};
				options"+cdcnt+".chart.margin={};
				options"+cdcnt+".xAxis={"+getxAxis(db,ds,sytid,topic,0)+"};
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
			else if(val=='��������ͼ'){
				options"+cdcnt+".labels={};
				options"+cdcnt+".legend={};
				options"+cdcnt+".chart.margin={};
				options"+cdcnt+".xAxis={"+getxAxis(db,ds,sytid,topic,0)+"};
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
			else if(val=='3D��״ͼ'){
				options"+cdcnt+".labels={};
				options"+cdcnt+".legend={};
				options"+cdcnt+".xAxis={"+getxAxis(db,ds,sytid,topic,0)+"};
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
			else if(val=='3D��ͼ'){
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
				            name: '�ϼ�',
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
			else if(val=='���ͼ'){
				 options"+cdcnt+".chart.options3d={};
				 options"+cdcnt+".plotOptions={};
				 options"+cdcnt+".xAxis={};
				 options"+cdcnt+".chart.margin={};
				 options"+cdcnt+".series=["+getserieshunhe(db,ds,sytid,topic,0)+"];
				 options"+cdcnt+".labels= {                                                         
			            items: [{                                                     
			                html: '�ϼ�',                          
			                style: {                                                  
			                    left: '150px',                                         
			                    top: '8px',                                           
			                    color: 'black'                                        
			                }                                                         
			            }]                                                            
			        };                                                          
				 var chart = new Highcharts.Chart(options"+cdcnt+");
			}
			else if(val=='���ζѵ�ͼ'){
				
				options"+cdcnt+".labels={};
				options"+cdcnt+".legend={};
				options"+cdcnt+".xAxis={};
				options"+cdcnt+".chart.margin={};
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
			else if(val=='©��ͼ'){
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
						   name: '�ϼ�',
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
//��ȡBI sql
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
		var r_HCols = getVdimName(db,sytid,topic,modguid,tablename);		//�������ֶ�
		var r_VCols = getCrossCol(db,sytid,topic);	//�������ֶ�
		var r_VCol = getCrossTarget(db,sytid,topic);	//����ֵ�ֶ�
		var colsql = getColSQL(db,sytid,topic,r_VCols);	//�������ֶ�SQL
		var orderby = getVdimOrders(db,sytid,topic,modguid,tablename);		//�������ֶ�
		sql = pub.EASqlFunc.GetSql2CrossTableSQL(db,sql,colsql,r_HCols,r_VCols,r_VCol,orderby);
	}

	var gusrinfo=web.EASession.GetUserinfo(request);
	if(gusrinfo!=null){
		sql=web.EASession.GetSysValue(sql,request);//�滻request ��[%id]
		sql=web.EASession.GetSysValue(sql,web.EASession.GetUserinfo(request));
	}

	return sql;
}

//��ȡά�ȣ�����������
function getVdimWithName(db,sytid,topic,modguid,tablename)
{
	var str = "";
	var sql = "select vdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	var vdim = db.GetSQL(sql);
	
	var arr = vdim.split(",");
	for (var i = 0;i < arr.length();i ++) {
		var colnam = GetColname(db,arr[i],modguid,tablename); //��ȡ�ֶ�����
		if (colnam == "") colnam = arr[i];
		if (str != "") str += ",";
		str += arr[i] +" as \""+ colnam +"\"";
	}
	return str;
}

//��ȡĿ�꣨����������
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
			var colnam = GetColname(db,arr[i],modguid,tablename); //��ȡ�ֶ�����
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

//��ȡ��ѯ����
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
		var val =  pub.EAFunc.NVL(request.getParameter(id),"");
		if (datatyp == "DATE") {
			if(val!="")
				where += "\n   and to_char(" + id + ",'YYYY-MM-DD') like '"+mydat+"%' ";
			dat1 = pub.EAFunc.NVL(request.getParameter("STA"+id),"");
			dat2 = pub.EAFunc.NVL(request.getParameter("END"+id),"");
			if(dat1!="")
				where += "\n   and " + id + ">=to_date(decode('"+dat1+"','','1900-01-01','"+dat1+"'),'yyyy-mm-dd')";
			if(dat2!="")
				where += "\n   and " + id + "<=to_date(decode('"+dat2+"','','2900-01-01','"+dat2+"'),'yyyy-mm-dd')";
			

		} else if(datatyp.indexOf("CHAR") >= 0) {
			if(val!=""){
				if (datatyp.indexOf("CHAR") >= 0) where += "\n   and nvl("+ id +",' ') like '"+ val +"%'";
				else where += "\n and nvl("+ id +",' ') like '"+ val +"%'";
			}
		}
		else  {// ������
			if(val!="")				
				where += "\n   and to_char(" + id +") like '"+val+"%' ";
			
			dat1 = pub.EAFunc.NVL(request.getParameter("STA"+id),"");
			dat2 = pub.EAFunc.NVL(request.getParameter("END"+id),"");
			if(dat1!="")
				where += "\n   and " + id + ">="+dat1;
			if(dat2!="")
				where += "\n   and " + id + "<="+dat2;
		}
			
//			if (val != "") {
//				if (control != "" && keyval != "") {
//					if (datatyp.indexOf("CHAR") >= 0) where += "\n   and "+ id +"='"+ val +"'";
//					else where += "\n   and to_char("+ id +")='"+ val +"'";
//				} else {
//					if (datatyp.indexOf("CHAR") >= 0) where += "\n   and nvl("+ id +",' ') like '"+ val +"%'";
//					else where += "\n   and nvl(to_char("+ id +"),' ') like '"+ val +"%'";
//				}
//			}
		
	}

	return where;
}

//�������͵�תΪ�ַ��� select dat,itmid from aaa --> select to_char(dat,'yyyy-mm-dd') dat,itmid from aaa
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



//��ȡά�ȣ�������,���ڽ�������ֶΣ�
function getVdimName(db,sytid,topic,modguid,tablename)
{
	var str = "";
	var sql = "select vdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	var vdim = db.GetSQL(sql);
	
	var arr = vdim.split(",");
	for (var i = 0;i < arr.length();i ++) {
		var colnam = GetColname(db,arr[i],modguid,tablename); //��ȡ�ֶ�����
		if (colnam == "") colnam = arr[i];
		if (str != "") str += ",";
		str += colnam;
	}
	return str;
}


//ȡ�ý������ֶ�
function getCrossCol(db,sytid,topic)
{
	var sql = "select b.id from dim_topic a,dim_dim b where a.refmod=b.refmod and a.id='%s' and a.sytid='%s' and a.hdim like '%'||b.id||'%'".format([topic,sytid]);
	return db.GetSQL(sql);
}

//����ֵ�ֶ�
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

//�������ֶ�SQL
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
//�������ݣ���������
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
		var colnam = GetColname(db,arr[i],modguid,tablename); //��ȡ�ֶ�����
		if (colnam == "") colnam = arr[i];
		if (str != "") str += ",";
		str += colnam;
	}
	return str;
}
//�Ƿ񽻲�
function isCrossReport(db,sytid,topic)
{
	var sql = "select a.hdim,b.id from dim_topic a,dim_dim b where a.refmod=b.refmod and a.sytid='%s' and a.id='%s' and a.hdim like '%'||b.id||'%'".format([sytid,topic]);
	var rowcnt = db.GetSQLRowCount(sql);
	if (rowcnt > 0) return true;
	return false;
}

//��ȡά��
function getVdim(db,sytid,topic)
{
	var sql = "select vdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	return db.GetSQL(sql);
}

//�ֶ�����
function GetColname(db,colid,modguid,tablename)
{
	var ret = "";
	var ds = db.QuerySQL("select name from dim_dim where refmod='"+modguid+"' and upper(id)=upper('"+colid+"')"); //ά��
	if ( ds.getRowCount() > 0 ) ret = ds.getStringAt(0,"NAME");
	else {
		ds = db.QuerySQL("select nvl(supername,'')||' '||name name from dim_target where refmod='"+modguid+"' and upper(id)=upper('"+colid+"')"); //Ŀ��
		if ( ds.getRowCount() > 0 ) ret = ds.getStringAt(0,"NAME");
		else {
			ds = db.QuerySQL(" select comments name from user_col_comments where upper(table_name)=upper('"+tablename+"') and upper(column_name)=upper('"+colid+"')"); //ϵͳ
			if ( ds.getRowCount() > 0 ) ret = ds.getStringAt(0,"NAME");
		}
	}
	if ( ret == "" ) ret = colid;
	return ret;
}
//�õ�����
function GetTopic(db,sytid,topicid)
{
	var ds = null;
	var curtopic = topicid;

	ds = db.QuerySQL("select name,longname,hdim,vdim,hdim||','||vdim hvdim,nvl(picnote,'MSColumn3D-1') picnote,vdimshowcol,piclocation,xchart from dim_topic where sytid='"+sytid+"' and id='"+topicid+"'");
	if ( ds.getRowCount() == 0 ) throw new Exception( "����"+topicid+"û���ҵ�" );
	
	var str =ds.getStringAt(0,"NAME");
	return str ;
}

//bchgxy	ͼ������ = 1 X��Y����ת
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

//bchgxy	ͼ������ = 1 X��Y����ת
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

//bchgxyͼ������ = 1 X��Y����ת
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

//bchgxy	ͼ������ = 1 X��Y����ת
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
	str+=",{type: 'spline', name: 'ƽ��',data:"+getseriespingjun(db,ds,sytid,topic,bchgxy)+" },{type:'pie',name: '�ϼƱ�ͼ',data:"+getseriessum(db,ds,sytid,topic,bchgxy)+",center: [150, 80],                                            
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


//bchgxyͼ������ = 1 X��Y����ת ȥƽ����
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
			colsum = pubpack.EAFunc.formatDouble(colsum,2);
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
			var a = "";
			try{
				if(1*torow!=0)//ע�ⱻ����
					a = pubpack.EAFunc.formatDouble(colsum/torow,2);
			}
			catch(e){}
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
				body, html{width: 100%;height: 100%; margin:0;font-family:\"΢���ź�\";}
				#l-map{height:800px;width:100%;}
			</style>
			<script type=\"text/javascript\" src=\"http://api.map.baidu.com/api?v=2.0&ak=bcqnSYjGSOPcmxcDpG8T9nMs\"></script>
			<title>����ҽԺ</title>
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
				map.addControl(new BMap.NavigationControl());  //����Ĭ������ƽ�ƿؼ� v2.0

				var marker1 = new BMap.Marker(gpsPoint);  // ������ע	
				map.addOverlay(marker1);              // ����ע���ӵ���ͼ��	
				
				map.setCenter(gpsPoint);
				var label = new BMap.Label('��ǰλ��',{offset:new BMap.Size(20,-10)});
				map.addOverlay(label);//���ӱ�ǩ

				var local = new BMap.LocalSearch(map, {
					renderOptions:{map: map, autoViewport:true}
				});
				local.searchNearby('ҽԺ', gpsPoint);
			}
			};
			function onError(error) {  
				alert(JSON.stringify(error)); 
			} 
		</script>";
		
		return html;
}



//���
function FloatAdd(arg1,arg2){  
	
	var r1;
	var r2;
	var m;  
	try{
	   	try{r1=arg1.toString().split(".")[1].length;}catch(e){r1=0;}  
	   	try{r2=arg2.toString().split(".")[1].length;}catch(e){r2=0;}  
	  	m=langpack.Math.pow(10,langpack.Math.max(r1,r2))  ;
	  	return (arg1*m+arg2*m)/m;
	}
	catch( ee ){
		throw new Exception ("FloatAdd arg1="+arg1+",arg2="+arg2 +",e="+ee);
	}
//  	var b1=new lamath.BigDecimal(arg1.toString());
//	var b2=new lamath.BigDecimal(arg2.toString());
//    	return b1.add(b2);
}





}