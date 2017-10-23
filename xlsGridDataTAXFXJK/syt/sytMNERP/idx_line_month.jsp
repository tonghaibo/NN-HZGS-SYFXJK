<%@ page contentType="text/html;charset=gb2312" %>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*,com.xlsgrid.net.tag.*,com.xlsgrid.net.xmldb.*" %>
<html>
<%
  //===========================================================================
  //  可以使用的输入参数
  //    grdtyp: 中间件类型，可以是R B L 等，如果为空，表示R报表
  //    subtyp: 中间的子类型，如对于报表，设计器上的"分类"就是子类型，子类型使用Like的方式，如
  //         设计器上的"分类"是 "258" 那么，输入subtyp=2 =5 =8 都可以查询到该报表
  //    items: 特定的中间件编号列表；例如 items=,SO,PO,510,
  //===========================================================================
  EAUserinfo usrinfo = com.xlsgrid.net.web.EASession.GetLoginInfo(request)  ;
  String usrnam = usrinfo.getUsrnam();
  String logtime = usrinfo.getLogdat();
  String action  = EAFunc.NVL(request.getParameter("action"),"query");
  // 要查询的年和指标
  String yearidx  = EAFunc.NVL(request.getParameter("yearidx"),"");
  String dcfinUser = EAOption.get("DC_FINUSER");  
//String sAccid = "";
//String strItemList = "";
  String strIdxtyp = "";
  String strIdxtypOrg = "";
  //=====================================================================
  //查询指标的
  //select distinct idxid,idxnam,idxitmid,idxitmnam,count(*) from v_baseindex 
  //where idxnam like '%收入%'
  //group by idxid,idxnam,idxitmid,idxitmnam
  //=====================================================================
  //String a_idxid[]={"672","648","121","578","862","582","838","568" };
  //String a_idxitemid[]={"0000000163","0000000163","0000000201","0000000201","0000000201","0000000163","0000000201","0000000201"};
  //String a_idxitemname[]={"期末数","期末数","本月数","本月数","本月数","期末数","本月数","本月数"};
  //String a_idxname[]={"资产总额","固定资产净额","利润总额","净利润","商品销售收入","存货","主营业务收入","营业外收入"};//,"营业费用","管理费用","财务费用"
  //String a_idxshowsum[]={"false","false","false","false","false","false","false" ,"false"};
  String a_idxid[]={"862","121","578","672","726","750","202","203"};
  String a_idxitemid[]={"0000000203","0000000203","0000000203","0000000163","0000000163","0000000163","0000000203","0000000203"};
  String a_idxitemname[]={"本年累计数","本年累计数","本年累计数","期末数","期末数","期末数","本年累计数","本年累计数"};
  String a_idxname[]={"商品销售收入","利润总额","净利润","资产总额","负债合计","所有者权益合计","工资提取数","工资实发数"};
  String a_idxshowsum[]={"false","false","false","false","false","false","false" ,"false"};

  String strIdx = "";
  for ( int i=0;i<a_idxid.length-2;i++ ) {
  	strIdx += "<a href=\"javascript:G_SELSEQ="+i+";f_refresh();\">"+a_idxname[i]+"</a>&nbsp;";
  	//strIdx += "<a href=\"javascript:f_load('"+a_idxid[i]+"','"+a_idxitemid[i]+"','"+a_idxname[i]+"','"+a_idxitemname[i]+"',"+a_idxshowsum[i]+",false)\">"+a_idxname[i]+"</a>&nbsp;";
  }
  String strIdxMore = "";// more
  for ( int i=a_idxid.length-2;i<a_idxid.length;i++ ) {
  	strIdxMore += "<a href=\"javascript:G_SELSEQ="+i+";f_refresh();\">"+a_idxname[i]+"</a>&nbsp;";
  }  
  String sIdxid="var a_idxid=new Array(";
  String sIdxitemid="var a_idxitemid=new Array(";
  String sIdxitemname="var a_idxitemname=new Array(";
  String sIdxname="var a_idxname=new Array(";
  String sIdxshowsum="var a_idxshowsum=new Array(";
  for (int i=0;i<a_idxid.length;i++) {
    if ( i!=0 )sIdxid+=","; sIdxid+= "\""+a_idxid[i] + "\"";
    if ( i!=0 )sIdxitemid+=","; sIdxitemid+= "\""+a_idxitemid[i] + "\"";
    if ( i!=0 )sIdxitemname+=","; sIdxitemname+= "\""+a_idxitemname[i] + "\"";
    if ( i!=0 )sIdxname+=","; sIdxname+= "\""+a_idxname[i] + "\"";
    if ( i!=0 )sIdxshowsum+=","; sIdxshowsum+= a_idxshowsum[i] ;
  }
  sIdxid+=");";
  sIdxitemid+=");";
  sIdxitemname+=");";
  sIdxname+=");";
  sIdxshowsum+=");";
	try{
	//  EADS ds = EADbTool.QuerySQL("select indexid,indexname from "+dcfinUser+"M_INDEX where indexid in ( '672','648','121','578')");	// 资产总额 固定资产净额 利润总额 净利润
	 // int nRow = ds.getRowCount();
	  // 根据XmlDSListView的要求处理ds
	  //for ( int i =0 ; i< nRow; i ++ ) {
	  
	//	  strItemList+="&nbsp;<input type='checkbox' name='C1' value='"+ds.getStringAt(i,"INDEXID")+"'>"+ds.getStringAt(i,"INDEXNAME")+"&nbsp;";
	  //}
	  //'672','648','121','578')");	// 资产总额 固定资产净额 利润总额 净利润
	  EADS ds = EADbTool.QuerySQL("select distinct idxtypid,idxtyp from "+dcfinUser +"v_baseindex");	
	  int nRow = ds.getRowCount();
    // 根据XmlDSListView的要求处理ds
	  for ( int i =0 ; i< nRow; i ++ ) {
		  strIdxtyp+="<option value='"+ds.getStringAt(i,"idxtypid")+"'>"+ds.getStringAt(i,"idxtyp")+"</option>";
									
	  }
	  ds = EADbTool.QuerySQL("select id,name,note from "+dcfinUser +"v_baseorg order by sortid,refid");	
	  nRow = ds.getRowCount();
	  // 根据XmlDSListView的要求处理ds
	  strIdxtypOrg+="<option value=''>全部</option>";
	  for ( int i =0 ; i< nRow; i ++ ) {
		  strIdxtypOrg+="<option value='"+ds.getStringAt(i,"id")+"'>"+ds.getStringAt(i,"name")+"</option>";
	  }
	}
	catch ( EAException e ) {
	    request.getSession().setAttribute("XLSGRID_EXCEPTION",new EAException(EAException.errGeneral,"定义的中间件资料不正确：<BR>"+e.toString()));
	    response.sendRedirect("../xlsweb?action=ShowError");
	}


%>
<head>
  <meta http-equiv="Content-Language" content="zh-cn">
  <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
  <title><%=usrnam%>的工作桌面</title>
  <LINK rel=stylesheet type=text/css HREF="../xlsgrid/css/main.css">
</head>

<script src="../xlsgrid/js/listobj.js" type="text/jscript" language="jscript"></script>
<script language="JavaScript">
<!--
  var G_SELORG = '';	// 当前选择的组织
  var G_SELYY = '2006';			// 当前选择的月份
  var G_SELSEQ = 0;   // 当前选择的指标的数组序号
  <%=sIdxid%>
  <%=sIdxitemid%>
  <%=sIdxitemname%>
  <%=sIdxname%>
  <%=sIdxshowsum%>
  // 刷新
  function f_refresh()
  {
    var i=G_SELSEQ;
    f_load(a_idxid[i],a_idxitemid[i],a_idxname[i],a_idxitemname[i],a_idxshowsum[i],false);
  }
  // 载入一个指标项的数据
  //	bAddSerail是否添加一个系列
  function f_load(idxid,idxitmid,title,idxitmnam,bShowSum,bAddSerail)
  {
    sql="select '"+idxid+"' myidxid,year||'年' tip,year||'年' 年度,"+
    "round(sum(money01)/10000,0)||'万' as \"1月\", \n"+
    "round(sum(money02-money01)/10000,0)||'万' \"2月\" ,\n"+
    "round(sum(money03-money02)/10000,0)||'万' as \"3月\" ,\n"+
    "round(sum(money04-money03)/10000,0)||'万' as \"4月\" ,\n"+
    "round(sum(money05-money04)/10000,0)||'万' as \"5月\" ,\n"+
    "round(sum(money06-money05)/10000,0)||'万' as \"6月\" ,\n"+
    "round(sum(money07-money06)/10000,0)||'万' as \"7月\" ,\n"+
    "round(sum(money08-money07)/10000,0)||'万' as \"8月\" ,\n"+
    "round(sum(money09-money08)/10000,0)||'万' as \"9月\" ,\n"+
    "round(sum(money10-money09)/10000,0)||'万' as \"10月\" ,\n"+
    "round(sum(money11-money10)/10000,0)||'万' as \"11月\" ,\n"+
    "round(sum(money12-money11)/10000,0)||'万' as \"12月\" \n"+
		" from <%=dcfinUser%>v_baseindex where idxid='"+idxid+"' and idxitmid='"+idxitmid+"' and year="+ document.all("SEL_YEAR").value +" and "+
    " orgid like '"+G_SELORG+"[PERCENT]' "+
    " group by year,idxitmid,idxitmnam order by year ";   
    //var sql="select '"+idxid+"' myidxid,mmnam tip,mmnam 月份,sum(mny) 金额 "+
		//"from <%=dcfinUser%>V_INDEX_BYMONTH where idxid='"+idxid+"' and idxitmid='"+idxitmid+"' and year>2000 and orgid='"+G_SELORG+"' and year="+G_SELYY+" group by idxitmid,idxitmnam,mm,mmnam order by mm ";
    f_showtable_ex(sql,"#",title+"按月份",bShowSum,"BYMONTH",bAddSerail);
    
  
  }

  // 改变了指标大类
  function f_idxtyp_change()
  {
  
  
  }
  //更多的指标
  function f_selectmore()
  {
    //document.all("tr_idxtyp").style="display=;";
  }
  //sql的第一列是属于URL的后缀，第二列是TIP,都不显示
  //bShowSum=true 最后一行显示合计
  //bAddSerail是否添加一个系列
  function f_showtable (sql,link,title,bShowSum,tagid,bAddSerail)
  {
 	
    // 画表格及填数据	  
    var TabH = "<table width='95%' align='center' bordercolor='#000000' class='TableBorder' cellpadding='5' cellspacing='0'>" ;
    var TabE = "</table>" ;
    var str = "" ;
    var TdbgColor = "" ;
    var TdAlign = "" ;
    var url = "<%=usrinfo.getHomeURL()%>/XmlDB.sp?sql="+sql;
    _this.OpenHttpRequest(url,"POST");
    _this.AddHttpRequestParam("sql",sql,0);
    
    xml=_this.SendHttpRequest();
    
    //alert ( xml );
    _this.CloseHttpRequest();
    _this.XMLDS_Reset();
  
    _this.XMLDS_Parse(xml);
    
    var colcnt = _this.XMLDS_GetColumnCount();
    var rowcnt = _this.XMLDS_GetRowCount();  
    // 这里来处理chart
	var c = document.all("Chart_"+tagid).Constants;
	//document.all("Chart_"+tagid).Clear();
	var newChart = document.all("Chart_"+tagid).Charts(0);	// document.all("Chart_"+tagid).Charts.Add() 新增一个
    	//newChart.Type = c.chChartTypePie;	// set to  a pie
	document.all("Chart_"+tagid).HasChartSpaceTitle =true;
	document.all("Chart_"+tagid).ChartSpaceTitle.Caption = "分析图";	// 标题title
	document.all("Chart_"+tagid).ChartSpaceTitle.Font.Size = 9;    
	
    var namelist = "";
    for ( var row=0;row<rowcnt;row++ ){
    		if ( row != 0 ) namelist+=",";
    		namelist+=_this.XMLDS_GetStringAt(row,2);
    }
    newChart.SetData(c.chDimCategories, c.chDataLiteral, namelist);// 横坐标
    for(var i=3;i<colcnt;i++ ) {	// loop 一次是一个系列
    	var valuelist = "";
    	for ( var row=0;row<rowcnt;row++ ){
    		if ( row != 0 ) valuelist+=",";
    		var ss = _this.XMLDS_GetStringAt(row,i);
    		if ( ss.length == 0 ) ss = "0";
    		valuelist+=ss;
    		
    	}
    	//var s = newChart.SeriesCollection.Add();
    	var s = newChart.SeriesCollection(0);
    	if ( bAddSerail== true ) 
    		s = newChart.SeriesCollection.Add();
    	s.Caption = title;	
    	s.SetData(c.chDimValues, c.chDataLiteral, valuelist);// 系列值
    }
	    
    
    // 显示表格
    if ( bShowSum ) sumfields();  
    colcnt = _this.XMLDS_GetColumnCount();
    rowcnt = _this.XMLDS_GetRowCount();  
    for ( var i=0;i<rowcnt;i++){
      
      str += "<tr height='25' bgcolor='"+TdbgColor+"'>" ;
      if ( i==0 ) {// 表头
        TdbgColor = "#d6dff7";	
        str += "<tr height='25' bgcolor='"+TdbgColor+"'>" ;
        for( j=2;j<colcnt;j++) {
          str += "<td align='center' class='TdBorderBottom'>" + _this.XMLDS_GetColumnName(j) + "</td>" ;
        }    
      }
      //设置表格行背景色
      if ( i%2 == 0 )
        TdbgColor = "#F2F5FD" ;
      else
        TdbgColor = "#ffffee" ;
    
      str += "<tr height='25' bgcolor='"+TdbgColor+"' ";
      str += " onmouseover=\"this.style.backgroundColor='#D3E5FA'; this.style.cursor='hand'; title='"+_this.XMLDS_GetStringAt(i,1)+"'\" onmouseout=\"this.style.backgroundColor='"+TdbgColor+"';\" " ;
      str += " onclick=\"window.open('"+link + _this.XMLDS_GetStringAt(i,0)+"');\" >";
      for(var j=2;j<colcnt;j++)
      {
        //设置单元格对齐方式
        if ( j == 2 )
          TdAlign = "center" ;
        else
          TdAlign = "right" ;
        str += "<td align='"+TdAlign+"'  >";// class='TdBorderBottom'
        //if ( j > 2 ) 
        //  str += parseFloat(_this.XMLDS_GetStringAt(i,j))/10000+"万";
        //else 
          str += _this.XMLDS_GetStringAt(i,j);
        str += "</td>" ;
      }
      str += "</tr>\n" ;
    }  
    //绘制数据表格外的表格样式
    var DataTab = TabH + str + TabE ;
    var strTemp = "";
    strTemp+="<table border=\"1\" width=\"100%\"cellspacing=\"0\" id=\"table5\" height=\"200\">";
    strTemp+="	<tr>";
    strTemp+="		<td style=\"border-left: 1px solid #3A77BA; border-right: 1px solid #3A77BA; border-bottom: 1px solid #3A77BA; border-top: 1px solid #3A77BA;\" bgcolor=\"#FFFFFF\"  valign=\"top\">";
    strTemp+="			<table width=\"100%\" cellspacing=\"1\" ><tr><td align='center' colspan="+(colcnt-2)+">"+title+"</td></tr><tr><td><font color=\"#014E82\">"+str +"</font> </td></tr></table>";
    strTemp+="　	</td>";
    strTemp+="	</tr>";
    strTemp+="</table>";
    //alert ( strTemp );
    document.all("TXT_"+tagid).innerHTML = strTemp;
  }
  // 类似于f_showtable,只是水平倒转
  function f_showtable_ex (sql,link,title,bShowSum,tagid,bAddSerail)
  {
    // 画表格及填数据	  
    var TabH = "<table width='95%' align='center' bordercolor='#000000' class='TableBorder' cellpadding='5' cellspacing='0'>" ;
    var TabE = "</table>" ;
    var str = "" ;
    var TdbgColor = "" ;
    var TdAlign = "" ;
    var url = "<%=usrinfo.getHomeURL()%>/XmlDB.sp?sql="+sql;
    _this.OpenHttpRequest(url,"POST");
    _this.AddHttpRequestParam("sql",sql,0);
    
    xml=_this.SendHttpRequest();
    
    //alert ( xml );
    _this.CloseHttpRequest();
    _this.XMLDS_Reset();
  
    _this.XMLDS_Parse(xml);
    
    var colcnt = _this.XMLDS_GetColumnCount();
    var rowcnt = _this.XMLDS_GetRowCount();  
    // 这里来处理chart
	var c = document.all("Chart_"+tagid).Constants;
	//document.all("Chart_"+tagid).Clear();
	var newChart = document.all("Chart_"+tagid).Charts(0);	// document.all("Chart_"+tagid).Charts.Add() 新增一个
    	//newChart.Type = c.chChartTypePie;	// set to  a pie
	document.all("Chart_"+tagid).HasChartSpaceTitle =true;
	document.all("Chart_"+tagid).ChartSpaceTitle.Caption = "分析图";	// 标题title
	document.all("Chart_"+tagid).ChartSpaceTitle.Font.Size = 9;    
	
    var namelist = "";
    for ( var col=3;col<colcnt;col++ ){
    		if ( col != 3 ) namelist+=",";
    		namelist+=_this.XMLDS_GetColumnName(col);
    }
    //alert ( namelist );
    newChart.SetData(c.chDimCategories, c.chDataLiteral, namelist);// 横坐标
    for(var i=0;i<rowcnt;i++ ) {	// loop 一次是一个系列
    	var valuelist = "";
    	for ( var col=3;col<colcnt;col++ ){
    		if ( col != 3 ) valuelist+=",";
    		var ss = _this.XMLDS_GetStringAt(i,col);
    		if ( ss.length == 0 ) ss = "0";
    		valuelist+=ss;
    		
    	}
    	//var s = newChart.SeriesCollection.Add();
    	var s = newChart.SeriesCollection(0);
    	if ( bAddSerail== true ) 
    		s = newChart.SeriesCollection.Add();
    	s.Caption = title;	
    	s.SetData(c.chDimValues, c.chDataLiteral, valuelist);// 系列值
      //alert ( valuelist );
    }
	    
    
    // 显示表格
    if ( bShowSum ) sumfields();  
    colcnt = _this.XMLDS_GetColumnCount();
    rowcnt = _this.XMLDS_GetRowCount();  
    for ( var i=0;i<rowcnt;i++){
      
      str += "<tr height='25' bgcolor='"+TdbgColor+"'>" ;
      if ( i==0 ) {// 表头
        TdbgColor = "#d6dff7";	
        str += "<tr height='25' bgcolor='"+TdbgColor+"'>" ;
        for( j=2;j<colcnt;j++) {
          str += "<td align='center' class='TdBorderBottom'>" + _this.XMLDS_GetColumnName(j) + "</td>" ;
        }    
      }
      //设置表格行背景色
      if ( i%2 == 0 )
        TdbgColor = "#F2F5FD" ;
      else
        TdbgColor = "#ffffee" ;
    
      str += "<tr height='25' bgcolor='"+TdbgColor+"' ";
      str += " onmouseover=\"this.style.backgroundColor='#D3E5FA'; this.style.cursor='hand'; title='"+_this.XMLDS_GetStringAt(i,1)+"'\" onmouseout=\"this.style.backgroundColor='"+TdbgColor+"';\" " ;
      str += " onclick=\"window.open('"+link + _this.XMLDS_GetStringAt(i,0)+"');\" >";
      for(var j=2;j<colcnt;j++)
      {
        //设置单元格对齐方式
        if ( j == 2 )
          TdAlign = "center" ;
        else
          TdAlign = "right" ;
        str += "<td align='"+TdAlign+"'  >";// class='TdBorderBottom'
        //if ( j > 2 ) 
        //  str += parseFloat(_this.XMLDS_GetStringAt(i,j))/10000+"万";
        //else 
          str += _this.XMLDS_GetStringAt(i,j);
        str += "</td>" ;
      }
      str += "</tr>\n" ;
    }  
    //绘制数据表格外的表格样式
    var DataTab = TabH + str + TabE ;
    var strTemp = "";
    strTemp+="<table border=\"1\" width=\"100%\"cellspacing=\"0\" id=\"table5\" height=\"200\">";
    strTemp+="	<tr>";
    strTemp+="		<td style=\"border-left: 1px solid #3A77BA; border-right: 1px solid #3A77BA; border-bottom: 1px solid #3A77BA; border-top: 1px solid #3A77BA;\" bgcolor=\"#FFFFFF\"  valign=\"top\">";
    strTemp+="			<table width=\"100%\" cellspacing=\"1\" ><tr><td align='center' colspan="+(colcnt-2)+">"+title+"</td></tr><tr><td><font color=\"#014E82\">"+str +"</font> </td></tr></table>";
    strTemp+="　	</td>";
    strTemp+="	</tr>";
    strTemp+="</table>";
    //alert ( strTemp );
    document.all("TXT_"+tagid).innerHTML = strTemp;
  }
  
function sumfields()
{
  var cols = _this.XMLDS_GetColumnCount();
  var rows = _this.XMLDS_GetRowCount();
  var sums=new Array();
  var c;
  var r;
  for(c=3;c<cols;c++)
  {
    sums[c] = 0;
    for(r=0;r<rows;r++)
    {
      sums[c] += 1.0 * _this.XMLDS_GetStringAt(r,c);
    }
  }
  r = _this.XMLDS_AddRow(_this.XMLDS_GetRowCount()-1,'');
  _this.XMLDS_SetStringAt(r,2,"合计：");
  for(c=3;c<cols;c++)
  {
    _this.XMLDS_SetStringAt(r,c,sums[c]);
  }
  
}


-->
</script>

<script language="javascript">
// 初始化
function winonload(){
  if("<%=yearidx%>"!="") {
    var yearidx = "<%=yearidx%>";
    var year=yearidx.substr(0,4);
    var idxid = yearidx.substr(4);

    document.all("SEL_YEAR").value=year;
    for (var i=0;i<a_idxid.length;i++) {
      if ( a_idxid[i]==idxid) G_SELSEQ=i;
    }
  }
  f_refresh();
	//newWin( "w_top11","清单列表",480,"","<iframe src='../ShowXlsGrid.sp?grdid=idxbydate' />" );
	//f_load('672','0000000163','资产总额','本月数',false,false);	// 3个同时
	//f_load('121','0000000201','利润总额','本月数',true,true);
	//f_load('578','0000000201','净利润','本月数',true,true);
}

// 在指定的DIV位置创建一个窗口
function newWin( id, topic, height,bkimage , wintext ) {
	var str = "";
	str+="<table border=\"0\" width=\"100%\"cellspacing=\"0\" id=\"table5\" height=\""+height+"\">";
	str+="	<tr>";
	str+="		<td height=\"23\" style=\"border: 1px solid #3A77BA\" bgcolor=\"#FFFFFF\">";
	str+="		<table width=\"100%\"><tr><td width=\"154\">&nbsp;<img border=\"0\" src=\"../xlsgrid/images/my/collapse.gif\" width=\"9\" height=\"9\"> "+topic+"</td>";
	str+="			<td >";
	str+="			<img border=\"0\" src=\"../xlsgrid/images/my/barright.jpg\" width=\"22\" height=\"15\" align=\"right\"></td></tr></table>";
	str+="		</td>";
	str+="	</tr>";
	str+="	<tr>";
	str+="		<td style=\"border-left: 1px solid #3A77BA; border-right: 1px solid #3A77BA; border-bottom: 1px solid #3A77BA; \" bgcolor=\"#FFFFFF\" "+bkimage+" valign=\"top\">";
	str+="			<table width=\"100%\" cellspacing=\"6\"><tr><td><font color=\"#014E82\">"+wintext+"</font> </td></tr></table>";
	str+="　	</td>";
	str+="	</tr>";
	str+="</table>";
	document.all(id).innerHTML = str;
}

</script>

<body topmargin="0" leftmargin="0" onload="javascript:winonload();" bgcolor="#014E82">
<table width="100%" height="100%" bgcolor="#2547BC"><tr><td>
<table align="center" border="0" width="100%" id="table1" cellpadding="0" cellspacing="0">
	<tr>
		<td align="left" valign="top" bgcolor="#FFFFFF" height="350">
		
		<table border="0" width="100%" id="table3" height="269" cellspacing="5" cellpadding="0">
			<tr>
				<td height="142" bgcolor="#D1E2FE" valign="top" width="100%" colspan="2">
					<table width="100%"><tr><td width="31">
					<img border="0" src="../xlsgrid/images/my/bartop.jpg" width="30" height="14"></td>
					<td width="100%">
					<p align="center"><font color="#014E82">时间走势分析，统计各项指标月的走势</font></td><td width="32">
					<p align="right">
					<img border="0" src="../xlsgrid/images/my/bartop.jpg" width="30" height="14"></td></tr></table>

					<table border="0" width="100%" id="table4" cellspacing="1">
						<tr>
							<td align="left" valign="top">
                  <table border=0  cellspacing=1 id=table5 height=100% width="100%">
                    <tr>
                      <td height=23 style="border: 1px solid #3A77BA" bgcolor=#FFFFFF>
                      <table width="100%"><tr><td width=152>&nbsp;<img border=0 src=../xlsgrid/images/my/collapse.gif width=9 height=9> 
						选择组织：</td>
                        <td width="776" align=left >
                        <select size="1" name="SEL_ORG" onchange="javascript:G_SELORG=document.all('SEL_ORG').value;f_refresh();">
									<%=strIdxtypOrg%>
									</select>
                        </td>
                        <td width="39" ><img border=0 src=../xlsgrid/images/my/barright.jpg width=22 height=15 align=right>
                        　</td></tr></table>
                      </td>
                    </tr>
                    <tr>
                      <td style="border-left: 1px solid #3A77BA; border-right: 1px solid #3A77BA; border-bottom: 1px solid #3A77BA;"  bgcolor=#FFFFFF  valign=top>
                        <table  cellspacing=5><tr><td>
							<table border="0" id="table6" width="100%" >
								
								<tr>
									<td colspan="2" align="left" height="12" style="border-left-width: 1px; border-right-width: 1px; border-top-width: 1px; border-bottom: 1px solid #808080">
									&nbsp;主要分析指标：&nbsp;<%=strIdx%><BR><BR>
									&nbsp;<a href="javascript:f_selectmore();">更多的指标〉〉&nbsp;<%=strIdxMore%>...</a><BR><BR>
									</td>
								</tr>								
								<tr id="tr_idxtyp" style="display:none" >
									<td width="67"><select size="5" name="D1" onchange="javascript:f_idxtyp_change()">
									<%=strIdxtyp%>
									</select>　</td>
									<td valign="top">
									
　</td>
								</tr>
								</table>
							<table border="0"  id="table8" width="740">
								<tr>
									<td bgcolor="#86C2FF" width="734" colspan="2">
									月指标走势 选择年 <select size="1" name="SEL_YEAR" onchange="javascript:f_refresh();">
<option value="2006">2006年</option>
<option value="2005">2005年</option>
<option value="2004">2004年</option>
<option value="2003">2003年</option>
<option value="2002">2002年</option>
					</select></td>
								</tr>
								<tr>
									<td width="490">
									
<object classid="clsid:0002E55D-0000-0000-C000-000000000046" id="Chart_BYMONTH" width="723" height="230">
										<param name="XMLData" value="&lt;xml xmlns:x=&quot;urn:schemas-microsoft-com:office:excel&quot;&gt;
 &lt;x:ChartSpace&gt;
  &lt;x:OWCVersion&gt;11.0.0.5531         &lt;/x:OWCVersion&gt;
  &lt;x:Width&gt;18997&lt;/x:Width&gt;
  &lt;x:Height&gt;5292&lt;/x:Height&gt;
  &lt;x:DisplayPropertyBrowser/&gt;
  &lt;x:FormatValue&gt;
   &lt;x:DataSourceIndex&gt;-3&lt;/x:DataSourceIndex&gt;
   &lt;x:Data&gt;2&lt;/x:Data&gt;
  &lt;/x:FormatValue&gt;
  &lt;x:DisplayFieldList/&gt;
  &lt;x:Palette&gt;
   &lt;x:Entry&gt;#000000&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#000000&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#000000&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#000000&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#000000&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#000000&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#000000&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#000000&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#000000&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#000000&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#000000&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#000000&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#000000&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#000000&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#000000&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#000000&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#8080FF&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#802060&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#FFFFA0&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#A0E0E0&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#600080&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#FF8080&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#008080&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#C0C0FF&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#000080&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#FF00FF&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#80FFFF&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#0080FF&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#FF8080&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#C0FF80&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#FFC0FF&lt;/x:Entry&gt;
   &lt;x:Entry&gt;#FF80FF&lt;/x:Entry&gt;
  &lt;/x:Palette&gt;
  &lt;x:DefaultFont&gt;宋体&lt;/x:DefaultFont&gt;
  &lt;x:Interior&gt;
   &lt;x:ColorIndex&gt;None&lt;/x:ColorIndex&gt;
  &lt;/x:Interior&gt;
  &lt;x:Chart&gt;
   &lt;x:PlotArea&gt;
    &lt;x:Interior&gt;
     &lt;x:Color&gt;#E1FBEE&lt;/x:Color&gt;
     &lt;x:FillEffect&gt;
      &lt;x:PicturePlacement&gt;Front&lt;/x:PicturePlacement&gt;
      &lt;x:PicturePlacement&gt;Side&lt;/x:PicturePlacement&gt;
      &lt;x:PicturePlacement&gt;End&lt;/x:PicturePlacement&gt;
      &lt;x:fill x:type=&quot;tile&quot; patternbuiltin=&quot;62&quot; x:color=&quot;#E1FBEE&quot;/&gt;
     &lt;/x:FillEffect&gt;
    &lt;/x:Interior&gt;
    &lt;x:Graph&gt;
     &lt;x:SubType&gt;Clustered&lt;/x:SubType&gt;
     &lt;x:Type&gt;Column&lt;/x:Type&gt;
     &lt;x:SubType&gt;3D&lt;/x:SubType&gt;
     &lt;x:Series&gt;
      &lt;x:Border&gt;
       &lt;x:Color&gt;#000080&lt;/x:Color&gt;
       &lt;x:Weight&gt;3&lt;/x:Weight&gt;
       &lt;x:LineStyle&gt;Solid&lt;/x:LineStyle&gt;
      &lt;/x:Border&gt;
      &lt;x:Interior&gt;
       &lt;x:Color&gt;#6495ED&lt;/x:Color&gt;
       &lt;x:FillEffect&gt;
        &lt;x:fill x:type=&quot;gradient&quot; x:color=&quot;#6495ED&quot; x:color2=&quot;#AFEEEE&quot;
         x:angle=&quot;-90&quot; focusposition=&quot;0,0&quot; focus=&quot;0%&quot;/&gt;
       &lt;/x:FillEffect&gt;
      &lt;/x:Interior&gt;
      &lt;x:FormatMap&gt;
      &lt;/x:FormatMap&gt;
      &lt;x:Name&gt;系列 1&lt;/x:Name&gt;
      &lt;x:Caption&gt;
       &lt;x:DataSourceIndex&gt;-1&lt;/x:DataSourceIndex&gt;
       &lt;x:Data&gt;&amp;quot;系列 1&amp;quot;&lt;/x:Data&gt;
      &lt;/x:Caption&gt;
      &lt;x:Index&gt;0&lt;/x:Index&gt;
      &lt;x:Category&gt;
       &lt;x:DataSourceIndex&gt;-1&lt;/x:DataSourceIndex&gt;
       &lt;x:Data&gt;{&amp;quot;A&amp;quot;,&amp;quot;分类 2&amp;quot;,&amp;quot;分类 3&amp;quot;,&amp;quot;分类 4&amp;quot;,&amp;quot;分类 5&amp;quot;,&amp;quot;分类 6&amp;quot;,&amp;quot;分类 7&amp;quot;,&amp;quot;分类 8&amp;quot;,&amp;quot;分类 9&amp;quot;,&amp;quot;分类 10&amp;quot;,&amp;quot;分类 11&amp;quot;,&amp;quot;分类 12&amp;quot;}&lt;/x:Data&gt;
      &lt;/x:Category&gt;
      &lt;x:Value&gt;
       &lt;x:DataSourceIndex&gt;-1&lt;/x:DataSourceIndex&gt;
       &lt;x:Data&gt;{10.0,20.0,30.0,40.0,50.0,60.0,70.0,80.0,90.0,100.0,110.0,120.0}&lt;/x:Data&gt;
      &lt;/x:Value&gt;
      &lt;x:Marker&gt;
       &lt;x:Symbol&gt;None&lt;/x:Symbol&gt;
      &lt;/x:Marker&gt;
      &lt;x:Explode&gt;0&lt;/x:Explode&gt;
      &lt;x:Thickness&gt;10&lt;/x:Thickness&gt;
     &lt;/x:Series&gt;
     &lt;x:Dimension&gt;
      &lt;x:ScaleID&gt;41313828&lt;/x:ScaleID&gt;
      &lt;x:Index&gt;Categories&lt;/x:Index&gt;
     &lt;/x:Dimension&gt;
     &lt;x:Dimension&gt;
      &lt;x:ScaleID&gt;41314032&lt;/x:ScaleID&gt;
      &lt;x:Index&gt;Value&lt;/x:Index&gt;
     &lt;/x:Dimension&gt;
     &lt;x:Dimension&gt;
      &lt;x:ScaleID&gt;41314236&lt;/x:ScaleID&gt;
      &lt;x:Index&gt;Series&lt;/x:Index&gt;
     &lt;/x:Dimension&gt;
     &lt;x:Overlap&gt;0&lt;/x:Overlap&gt;
     &lt;x:GapWidth&gt;150&lt;/x:GapWidth&gt;
     &lt;x:FirstSliceAngle&gt;0&lt;/x:FirstSliceAngle&gt;
    &lt;/x:Graph&gt;
    &lt;x:Axis&gt;
     &lt;x:AxisID&gt;41320352&lt;/x:AxisID&gt;
     &lt;x:ScaleID&gt;41313828&lt;/x:ScaleID&gt;
     &lt;x:Type&gt;Category&lt;/x:Type&gt;
     &lt;x:Font&gt;
      &lt;x:Size&gt;9&lt;/x:Size&gt;
      &lt;x:B&gt;Automatic&lt;/x:B&gt;
      &lt;x:I&gt;Automatic&lt;/x:I&gt;
      &lt;x:U&gt;Automatic&lt;/x:U&gt;
     &lt;/x:Font&gt;
     &lt;x:Alignment&gt;
      &lt;x:Rotation&gt;0&lt;/x:Rotation&gt;
     &lt;/x:Alignment&gt;
     &lt;x:MajorTick&gt;Outside&lt;/x:MajorTick&gt;
     &lt;x:MinorTick&gt;None&lt;/x:MinorTick&gt;
     &lt;x:Placement&gt;Bottom&lt;/x:Placement&gt;
     &lt;x:GroupingEnum&gt;Auto&lt;/x:GroupingEnum&gt;
    &lt;/x:Axis&gt;
    &lt;x:Axis&gt;
     &lt;x:AxisID&gt;41321160&lt;/x:AxisID&gt;
     &lt;x:ScaleID&gt;41314032&lt;/x:ScaleID&gt;
     &lt;x:Type&gt;Value&lt;/x:Type&gt;
     &lt;x:Font&gt;
      &lt;x:Size&gt;9&lt;/x:Size&gt;
      &lt;x:B&gt;Automatic&lt;/x:B&gt;
      &lt;x:I&gt;Automatic&lt;/x:I&gt;
      &lt;x:U&gt;Automatic&lt;/x:U&gt;
     &lt;/x:Font&gt;
     &lt;x:MajorGridlines&gt;
     &lt;/x:MajorGridlines&gt;
     &lt;x:MajorTick&gt;Outside&lt;/x:MajorTick&gt;
     &lt;x:MinorTick&gt;None&lt;/x:MinorTick&gt;
     &lt;x:Title&gt;
      &lt;x:Font&gt;
       &lt;x:Size&gt;9&lt;/x:Size&gt;
       &lt;x:B&gt;Automatic&lt;/x:B&gt;
       &lt;x:I&gt;Automatic&lt;/x:I&gt;
       &lt;x:U&gt;Automatic&lt;/x:U&gt;
      &lt;/x:Font&gt;
      &lt;x:Border&gt;
       &lt;x:ColorIndex&gt;None&lt;/x:ColorIndex&gt;
      &lt;/x:Border&gt;
      &lt;x:Caption&gt;
       &lt;x:DataSourceIndex&gt;-1&lt;/x:DataSourceIndex&gt;
       &lt;x:Data&gt;&amp;quot;万元&amp;quot;&lt;/x:Data&gt;
      &lt;/x:Caption&gt;
      &lt;x:Position&gt;Left&lt;/x:Position&gt;
     &lt;/x:Title&gt;
     &lt;x:Placement&gt;Left&lt;/x:Placement&gt;
    &lt;/x:Axis&gt;
   &lt;/x:PlotArea&gt;
   &lt;x:View3D&gt;
    &lt;x:GapDepth&gt;150&lt;/x:GapDepth&gt;
    &lt;x:ChartDepth2&gt;43&lt;/x:ChartDepth2&gt;
    &lt;x:HeightPercent&gt;35&lt;/x:HeightPercent&gt;
    &lt;x:RightAngleAxes/&gt;
    &lt;x:ExtrudeAngle&gt;45.0&lt;/x:ExtrudeAngle&gt;
    &lt;x:Light&gt;
     &lt;x:Rotation&gt;328.0&lt;/x:Rotation&gt;
     &lt;x:Inclination&gt;27.0&lt;/x:Inclination&gt;
     &lt;x:IntensityDiffuse&gt;0.549019607843137&lt;/x:IntensityDiffuse&gt;
     &lt;x:IntensityAmbient&gt;0.619607843137255&lt;/x:IntensityAmbient&gt;
     &lt;x:Normal&gt;0.3&lt;/x:Normal&gt;
    &lt;/x:Light&gt;
   &lt;/x:View3D&gt;
   &lt;x:Walls&gt;
    &lt;x:Index&gt;0&lt;/x:Index&gt;
    &lt;x:Thickness&gt;6&lt;/x:Thickness&gt;
   &lt;/x:Walls&gt;
   &lt;x:Walls&gt;
    &lt;x:Index&gt;1&lt;/x:Index&gt;
    &lt;x:Thickness&gt;6&lt;/x:Thickness&gt;
   &lt;/x:Walls&gt;
   &lt;x:Walls&gt;
    &lt;x:Index&gt;2&lt;/x:Index&gt;
    &lt;x:Thickness&gt;6&lt;/x:Thickness&gt;
   &lt;/x:Walls&gt;
  &lt;/x:Chart&gt;
  &lt;x:Legend&gt;
   &lt;x:Font&gt;
    &lt;x:Size&gt;9&lt;/x:Size&gt;
    &lt;x:B&gt;Automatic&lt;/x:B&gt;
    &lt;x:I&gt;Automatic&lt;/x:I&gt;
    &lt;x:U&gt;Automatic&lt;/x:U&gt;
   &lt;/x:Font&gt;
   &lt;x:Placement&gt;Right&lt;/x:Placement&gt;
  &lt;/x:Legend&gt;
  &lt;x:Scaling&gt;
   &lt;x:ScaleID&gt;41313828&lt;/x:ScaleID&gt;
  &lt;/x:Scaling&gt;
  &lt;x:Scaling&gt;
   &lt;x:ScaleID&gt;41314032&lt;/x:ScaleID&gt;
  &lt;/x:Scaling&gt;
  &lt;x:Scaling&gt;
   &lt;x:ScaleID&gt;41314236&lt;/x:ScaleID&gt;
  &lt;/x:Scaling&gt;
 &lt;/x:ChartSpace&gt;
&lt;/xml&gt;">
										<param name="ScreenUpdating" value="-1">
										<param name="EnableEvents" value="-1">
<table width='100%' cellpadding='0' cellspacing='0' border='0' height='8'><tr><td bgColor='#336699' height='25' width='10%'>&nbsp;</td><td bgColor='#666666'width='85%'><font face='宋体' color='white' size='4'><b>&nbsp; 缺少 Microsoft Office Web Components</b></font></td></tr><tr><td bgColor='#cccccc' width='15'>&nbsp;</td><td bgColor='#cccccc' width='500px'><br> <font face='宋体' size='2'>此网页要求 Microsoft Office Web Components。<p align='center'> <a href='G:/files/owc11/setup.exe'>单击此处安装 Microsoft Office Web Components。</a>.</p></font><p><font face='宋体' size='2'>此网页同时要求 Microsoft Internet Explorer 5.01 或更高版本。</p><p align='center'><a href='http://www.microsoft.com/windows/ie/default.htm'> 单击此处安装最新的 Internet Explorer</a>.</font><br>&nbsp;</td></tr></table></object>
                  </td>
									<td width="0" valign="top">
									　</td>
								</tr>
								<tr>
									<td width="734" colspan="2"><div id="TXT_BYMONTH"></div>
									　</td>
								</tr>
							</table>							
							<p>　</p>
							<p>　</p>
							<p>　</p>
							<p>　</p>
							<p>　</td></tr></table>
                    </td>
                    </tr>
                  </table>
              
              </td>
						</tr>
						</table>
				</td>
			</tr>
			<tr>
				<td bgcolor="#D1E2FE" valign="top" >
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</td></tr></table>
<OBJECT id=_this width="0" height="0" style="LEFT: 0px; WIDTH: 0px; TOP: 0px; HEIGHT: 0px"
  classid=clsid:37CC6FCD-9BF5-4433-B3F3-576E08025EA8
  CODEBASE=\"activex/xlsGrid.ocx\">
      <PARAM NAME=_Version VALUE=65536>
    <PARAM NAME=_ExtentX VALUE=9684>
    <PARAM NAME=_ExtentY VALUE=5080>
    <PARAM NAME=_StockProps VALUE=0>
</OBJECT>

</body>
</html>