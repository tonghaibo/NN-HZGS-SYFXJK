function x_showflg_chart(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
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


//BI��������ʾ���1:��״ͼ
function BI1()
{
	var db = null;
	
	var chaptyp= pubpack.EAFunc.NVL( request.getParameter("CHARTTYPE"),"") ;
	if (chaptyp!=""||chaptyp!="null"||chaptyp!=null){} else CHARTTYPE= chaptyp;
	if(CHARTTYPE==""||CHARTTYPE=="null"||CHARTTYPE==null)CHARTTYPE= "column";
	
	var stackstr="";
	if(CHARTTYPE=="stacking") {stackstr="plotOptions: { column: { stacking: 'normal'} },"; CHARTTYPE="column"; }
	
	if(WIDTH==""||WIDTH=="null"||WIDTH==null)WIDTH= "100%";
	if(HEIGHT==""||HEIGHT=="null"||HEIGHT==null)HEIGHT= "100%";
	if(SHOWFLAG==""||SHOWFLAG=="null"||SHOWFLAG==null)SHOWFLAG= "default";
	if(XCOLLIST==""||XCOLLIST=="null"||XCOLLIST==null)throw new Exception("X���ֶ��б���Ϊ��");
	if(YCOLLIST==""||YCOLLIST=="null"||YCOLLIST==null)throw new Exception("Y���ֶ��б�(ͳ��ֵ)����Ϊ��");
	if(ZCOLLIST==""||ZCOLLIST=="null"||ZCOLLIST==null)ZCOLLIST= "";
	
	if(YTITLE==""||YTITLE=="null"||YTITLE==null)YTITLE= "";
	
	var conid = "contrainer"+(""+langpack.Math.ceil(langpack.Math.random()*1000000)).substring(0,5);
	var cates = "";// X�������
	
	var series = "";
        var loadchart = pubpack.EAFunc.NVL( request.getParameter("loadchart"),"") ;// loadchart =1 �����룬chart����ʹ�ú�����ķ�ʽ
	if(loadchart!="1"){// ��һ��
	        return "
		<div id='"+conid +"' style='padding:5px;width:"+WIDTH+";height:"+HEIGHT+"'><br><img src='xlsgrid/images/flash/images/loading.gif' style='max-width=:100%;height=:auto;margin-top:30px;'></div>	
		<script>
			//setTimeout( function(){
				$.get(G_WEBBASE+'rcall.jsp?loadchart=1&deforg="+deforg+"&menuid=&crtlid="+CTRLID+"'+G_CLIENTPARAM,function(data,status){
					var jsondata = data.replace(/\\r\\n/g,\"\"); //����URL���λ��з�����
					jsondata = jsondata.replace(/\\n/g,\"\");
					var json = (new Function(\"return \" + jsondata))();
					$('#"+conid+"').highcharts(json   );
					SetThreme('"+SHOWFLAG+"');            		
				});
			//},500);  
		</script>"; 
	}
	else {	// �ڶ���
		try {
			if(DBNAME!="")
				db = new pubpack.EADatabase(DBNAME);	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
			else db = new pubpack.EADatabase();
			// ����SQL�����
			var usrinfo  = web.EASession.GetLoginInfo(request);
			SQL=web.EASession.GetSysValue(SQL,usrinfo);
			SQL=web.EASession.GetSysValue(SQL,request);//�滻request ��[%id]
			
			var r_HCols = XCOLLIST;		//�������ֶ�
			var r_VCols = ZCOLLIST;	//�������ֶ�
			var r_VCol = YCOLLIST;	//����ֵ�ֶ�
			var colsql = "";	//�������ֶ�SQL
			var orderby = "";		//�������ֶ�
			if(ZCOLLIST!=""){
				SQL= pub.EASqlFunc.GetSql2CrossTableSQL(db,SQL,colsql,r_HCols,r_VCols,r_VCol,orderby);
			}
			else if(CHARTTYPE=="radarchart"){
			
			}
			else SQL = "select "+XCOLLIST+",sum("+YCOLLIST+") "+YCOLLIST+" from ("+SQL+") t group by "+XCOLLIST+" order by "+XCOLLIST;
			
			var ds = db.QuerySQL(SQL);//��������Ҫ��ICON��NAME��URL��CNT����¼�������ֶ�
			var ss = XCOLLIST.split(",");
			var startcol = ss.length();
			// ��ά����X����
			for ( var i=0;i<ds.getRowCount();i++ ) {
				var XVAL = ds.getStringAt(i,0);
				var rownam = "";
				for ( var ii=1;ii<=startcol;ii++){// ������֧�ֶ���ֶ�
					if(rownam!="")rownam+=" ";
					rownam+=ds.getStringAt(i,ii-1);
				}
	
				if(cates!="")cates+=",";
				cates += "'"+rownam+"'";
			}
			series = "";
			if(CHARTTYPE=="pie")  series += pie_series(ds,startcol,CHARTTYPE );
			else if(CHARTTYPE=="scatter")series += scatter_series(ds,startcol,CHARTTYPE );
			else if(CHARTTYPE=="radarchart"){
				cates="";
				// ��ά����X����
				for ( var i=0;i<ds.getRowCount();i++ ) {
					var rownam = "";
					if(cates!="")cates+=",";
					cates += "'"+ds.getStringAt(i,0)+"'";
				}
				series += RadarChart_series(ds,startcol,CHARTTYPE);
				
				return "{ chart: {  type: 'line',polar: true },   title: {text:'"+TITLE+"' },   subtitle: { text: '"+SUBTITLE+"'},
				 xAxis: { categories: ["+cates+"] }, yAxis: {title: {text: '"+YTITLE+"'}}, 
				 tooltip: {enabled: false,formatter: function() {return '<b>'+ this.series.name +'</b><br/>'+this.x +': '+ this.y ; }},
				 plotOptions: {line: { dataLabels: { enabled: true },enableMouseTracking: false}}, 
				 series: ["+series+"]  }"; 
				
			}
			else series += other_series(ds,startcol,CHARTTYPE );
			
			return "{ chart: {  type: '"+CHARTTYPE+"', zoomType: ''},   title: {text:'"+TITLE+"' },   subtitle: { text: '"+SUBTITLE+"'},
				 xAxis: { categories: ["+cates+"] }, yAxis: {title: {text: '"+YTITLE+"'}}, 
				 tooltip: { formatter: function() { var s;if (this.point.name) {s = ''+this.point.name +': '+ this.y;} else {  s = ''+ this.x  +': '+ this.y;} return s; }  },"+stackstr+" 
				 series: ["+series+"]  }";
		}
		catch ( ee ) {
			db.Rollback();
			throw new pubpack.EAException ( ee.toString() );
		}
		finally {
			if (db!=null) db.Close();
		}
	}
}
// PIEͼ������
function pie_series(ds,startcol,CHARTTYPE ){
	var series  = "";
	var j = startcol ;
	series += "{type: 'pie',name: '"+ds.getColumnName(j)+"',data: [";	
	var sstr = "";		
	for ( var i=0;i<ds.getRowCount();i++ ) {
		var XVAL = ds.getStringAt(i,j);
		if(XVAL=="") XVAL = "0";
		if(sstr !="")sstr +=",";
		var rownam = "";
		for ( var ii=1;ii<=startcol;ii++){// ������֧�ֶ���ֶ�
			if(rownam!="")rownam+=" ";
			rownam+=ds.getStringAt(i,ii-1);
		}
		sstr += "['"+rownam+"',    "+XVAL+"]" ;
	}
	series += sstr+"]}";
	return series ;
}
// ɢ��ͼ������
function scatter_series(ds,startcol,CHARTTYPE){
	var series  = "";
	var j = startcol ;
	series += "{type: '"+CHARTTYPE+"',name: '"+ds.getColumnName(j)+"',color: 'rgba(223, 83, 83, .5)', data: [";	
	var sstr = "";		
	for ( var i=0;i<ds.getRowCount();i++ ) {
		var XVAL = ds.getStringAt(i,j);
		if(XVAL=="") XVAL = "0";
		if(sstr !="")sstr +=",";
		var rownam = "";
		for ( var ii=1;ii<=startcol;ii++){// ������֧�ֶ���ֶ�
			if(rownam!="")rownam+=" ";
			rownam+=ds.getStringAt(i,ii-1);
		}
		sstr += "["+XVAL+",    "+XVAL+"]" ;
	}
	series += sstr+"]}";
	return series ;

}
// ������ϵ�е�����
function other_series(ds,startcol,CHARTTYPE){
	var series  = "";
			
	for ( var j=startcol ;j<ds.getColumnCount();j++ ) {
		if(series !="")series +=",";
		series += "{type: '"+CHARTTYPE+"',name: '"+ds.getColumnName(j)+"',data: [";	
		var sstr = "";		
		for ( var i=0;i<ds.getRowCount();i++ ) {
			var XVAL = ds.getStringAt(i,j);
			if(XVAL =="") XVAL  = "0";
			if(sstr !="")sstr +=",";
			sstr += XVAL ;
		}
		series += sstr+"]}";
	}
	return series ;
}
// �״�ͼ������
function RadarChart_series(ds,startcol,CHARTTYPE){
	var series  = "";
	var sstr = "";
	for(var c=1;c<ds.getColumnCount();c++){
		if(c!=1) series +=",";
		
		series += "{pointPlacement: 'on',name: '"+ds.getColumnName(c)+"', data: [";
		for(var r=0;r<ds.getRowCount();r++){
			var rval=ds.getStringAt(r,c);
			if(r==0) series+=rval; else series+=","+rval;
		}
		series += sstr+"]}";
	}
	return series;
}

// ����
//BI��������ʾ���2:����ͼ
function BI2()
{
	var db = null;
	if(CHARTTYPE==""||CHARTTYPE=="null"||CHARTTYPE==null)CHARTTYPE= "1";
	if(WIDTH==""||WIDTH=="null"||WIDTH==null)WIDTH= "100%";
	if(HEIGHT==""||HEIGHT=="null"||HEIGHT==null)HEIGHT= "100%";
	var conid = "contrainer"+(""+langpack.Math.ceil(langpack.Math.random()*1000000)).substring(0,5);
	
	
	var rethtml= "
	<div id='"+conid +"' style='padding:5px;width:"+WIDTH+";height:"+HEIGHT+"'></div>	
	<script>
	setTimeout( function () {                                                               
    $('#"+conid +"').highcharts({                                          
        chart: {     
		zoomType: 'xy'                                                     
        },                                                                
        title: {                                                          
            text: '"+TITLE+"'                                     
        },                                                                
        xAxis: {                                                          
            categories: ['��������','רҵ����','ģ��ʵ��','����ʵѵ','ʵ������','�ۺ�ѡ��','רҵѡ��']
        },                                                                
        tooltip: {                                                        
            formatter: function() {                                       
                var s;                                                    
                if (this.point.name) { // the pie chart                   
                    s = ''+                                               
                        this.point.name +': '+ this.y +' fruits';         
                } else {                                                  
                    s = ''+                                               
                        this.x  +': '+ this.y;                            
                }                                                         
                return s;                                                 
            }                                                             
        },                                                                
        labels: {                                                         
            items: [{                                                     
                html: '�ٷֹ���',                          
                style: {                                                  
                    left: '40px',                                         
                    top: '8px',                                           
                    color: 'black'                                        
                }                                                         
            }]                                                            
        },   
	series: [
		{type: 'column',name: '��˰ѧԺ',data: [0,19,5,0,4,0,20]},
		{type: 'column',name: '��ְѧԺ',data: [32,13,0,0,36,37,43]},
		{type: 'column',name: '���̹���ѧԺ',data: [0,32,8,0,4,0,27]},
		{type: 'column',name: '��������ѧԺ',data: [21,61,8,8,12,0,40]},
		{type: 'column',name: '����ѧԺ',data: [0,22,5,0,6,0,28]},
		{type: 'column',name: '��óѧԺ',data: [0,27,7,0,4,0,30]},
		{type: 'column',name: '����ѧԺ',data: [7,49,25,0,4,0,42]},
		{type: 'column',name: '����ѧԺ',data: [1,49,8,6,5,0,20]},
		{type: 'column',name: '�ķ�ѧԺ',data: [4,59,10,0,5,0,36]},
		{type: 'line',name: 'ƽ��ֵ',data: [12,40,39,0,41,0,48]},
		{type: 'pie', name: '�ϼ�',data: [
			{ name: '��������',y: 65,color: Highcharts.getOptions().colors[0]  }, 
			{ name: 'רҵ����',y: 331,color: Highcharts.getOptions().colors[1]  }, 
			{ name: 'ģ��ʵ��',y: 76,color: Highcharts.getOptions().colors[2]  },
			{ name: '����ʵѵ',y: 14,color: Highcharts.getOptions().colors[3] },
			{ name: 'ʵ������', y: 80, color: Highcharts.getOptions().colors[4] },
			{name: '�ۺ�ѡ��',y: 37,color: Highcharts.getOptions().colors[5] },
			{name: 'רҵѡ��',y: 286,color: Highcharts.getOptions().colors[6] },
			{ name: 'Joe', y: 1089,color: Highcharts.getOptions().colors[7] }
			],                                                           
            		center: [100, 80],  size: 130, showInLegend: false,dataLabels: { enabled: false  }              
	   	}
	]                                                              
    });                                                                   
},1000);  
	</script>

";
	try {
		if(DBNAME!="")
			db = new pubpack.EADatabase(DBNAME);	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		else db = new pubpack.EADatabase();
		// ����SQL�����
		var usrinfo  = web.EASession.GetLoginInfo(request);
		SQL=web.EASession.GetSysValue(SQL,request);//�滻request ��[%id]
		SQL=web.EASession.GetSysValue(SQL,usrinfo);
		var ds = db.QuerySQL(SQL);//��������Ҫ��ICON��NAME��URL��CNT����¼�������ֶ�
		for ( var i=0;i<ds.getRowCount();i++ ) {
			var NAME = ds.getStringDef(i,"NAME","");
		}
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return rethtml;
	

}



}