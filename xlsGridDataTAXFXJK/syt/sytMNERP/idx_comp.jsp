<%@ page contentType="text/html;charset=gb2312" %>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*,com.xlsgrid.net.tag.*,com.xlsgrid.net.xmldb.*" %>
<html>
<%
  //===========================================================================
  //  ����ʹ�õ��������
  //    grdtyp: �м�����ͣ�������R B L �ȣ����Ϊ�գ���ʾR����
  //    subtyp: �м�������ͣ�����ڱ���������ϵ�"����"���������ͣ�������ʹ��Like�ķ�ʽ����
  //         ������ϵ�"����"�� "258" ��ô������subtyp=2 =5 =8 �����Բ�ѯ���ñ���
  //    items: �ض����м������б����� items=,SO,PO,510,
  //===========================================================================
  EAUserinfo usrinfo = com.xlsgrid.net.web.EASession.GetLoginInfo(request)  ;
  String usrnam = usrinfo.getUsrnam();
  String logtime = usrinfo.getLogdat();
  String action  = EAFunc.NVL(request.getParameter("action"),"query");
  String dcfinUser = EAOption.get("DC_FINUSER");  
//String sAccid = "";
//String strItemList = "";
  String strIdxtyp = "";
  //=====================================================================
  //��ѯָ���
  //select distinct idxid,idxnam,idxitmid,idxitmnam,count(*) from v_index 
  //where idxnam like '%����%'
  //group by idxid,idxnam,idxitmid,idxitmnam
  //=====================================================================
  String a_idxid[]={"672","648","121","578","862","582","838","568" };
  String a_idxitemid[]={"0000000163","0000000163","0000000201","0000000201","0000000201","0000000163","0000000201","0000000201"};
  String a_idxitemname[]={"��ĩ��","��ĩ��","������","������","������","��ĩ��","������","������"};
  String a_idxname[]={"�ʲ��ܶ�","�̶��ʲ�����","�����ܶ�","������","��Ʒ��������","���","��Ӫҵ������","Ӫҵ������"};//,"Ӫҵ����","�������","�������"
  String a_idxshowsum[]={"false","false","true","true","true","false","true" ,"true"};
  String strIdx = "";
  for ( int i=0;i<a_idxid.length;i++ ) {
  	strIdx += "<a href=\"javascript:f_load('"+a_idxid[i]+"','"+a_idxitemid[i]+"','"+a_idxname[i]+"','"+a_idxitemname[i]+"',"+a_idxshowsum[i]+",false)\">"+a_idxname[i]+"</a>&nbsp;";
  }
  
	try{
	//  EADS ds = EADbTool.QuerySQL("select indexid,indexname from "+dcfinUser+"M_INDEX where indexid in ( '672','648','121','578')");	// �ʲ��ܶ� �̶��ʲ����� �����ܶ� ������
	 // int nRow = ds.getRowCount();
	  // ����XmlDSListView��Ҫ����ds
	  //for ( int i =0 ; i< nRow; i ++ ) {
	  
	//	  strItemList+="&nbsp;<input type='checkbox' name='C1' value='"+ds.getStringAt(i,"INDEXID")+"'>"+ds.getStringAt(i,"INDEXNAME")+"&nbsp;";
	  //}
	  //'672','648','121','578')");	// �ʲ��ܶ� �̶��ʲ����� �����ܶ� ������
	  EADS ds = EADbTool.QuerySQL("select distinct idxtypid,idxtyp from "+dcfinUser +"v_index");	
	  int nRow = ds.getRowCount();
	  // ����XmlDSListView��Ҫ����ds
	  for ( int i =0 ; i< nRow; i ++ ) {
		  strIdxtyp+="<option value='"+ds.getStringAt(i,"idxtypid")+"'>"+ds.getStringAt(i,"idxtyp")+"</option>";
									
	  }
	
	}
	catch ( EAException e ) {
	    request.getSession().setAttribute("XLSGRID_EXCEPTION",new EAException(EAException.errGeneral,"������м�����ϲ���ȷ��<BR>"+e.toString()));
	    response.sendRedirect("../xlsweb?action=ShowError");
	}


%>
<head>
  <meta http-equiv="Content-Language" content="zh-cn">
  <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
  <title><%=usrnam%>�Ĺ�������</title>
  <LINK rel=stylesheet type=text/css HREF="../xlsgrid/css/main.css">
</head>

<script src="../xlsgrid/js/listobj.js" type="text/jscript" language="jscript"></script>
<script language="JavaScript">
<!--
  var G_SELORG = '0000317815';	// ��ǰѡ�����֯
  var G_SELYY = '2006';			// ��ǰѡ����·�
  
  // ����һ��ָ���������
  //	bAddSerail�Ƿ����һ��ϵ��
  function f_load(idxid,idxitmid,title,idxitmnam,bShowSum,bAddSerail)
  {
    var sql="select '"+idxid+"' myidxid,year||'��' tip,year||'��' ���,sum(money12) ��� "+
		"from <%=dcfinUser%>V_INDEX where idxid='"+idxid+"' and idxitmid='"+idxitmid+"' and year>2000 and orgid='"+G_SELORG+"' and year<to_number(to_char(sysdate,'YYYY')) group by year,idxitmid,idxitmnam order by year ";
	f_showtable(sql," ",title+"�����",bShowSum,"BYYEAR",bAddSerail);
    //document.all("BYYEAR").innerHTML = ret;
/*    var sql="select '"+idxid+"' myidxid,orgnam tip,max(orgnam) ��֯,sum(money12) ��� "+
		"from <%=dcfinUser%>V_INDEX where idxid='"+idxid+"' and idxitmid='"+idxitmid+"' and year>2000 and orgid='"+G_SELORG+"' and year<to_number(to_char(sysdate,'YYYY')) group by orgid,idxitmid,idxitmnam order by year ";
		f_showtable(sql," ",title+"���·�",bShowSum,"BYYEAR",bAddSerail);
*/		
    var sql="select '"+idxid+"' myidxid,mmnam tip,mmnam �·�,sum(mny) ��� "+
		"from <%=dcfinUser%>V_INDEX_BYMONTH where idxid='"+idxid+"' and idxitmid='"+idxitmid+"' and year>2000 and orgid='"+G_SELORG+"' and year="+G_SELYY+" group by idxitmid,idxitmnam,mm,mmnam order by mm ";
	f_showtable(sql," ",title+"���·�",bShowSum,"BYMONTH",bAddSerail);
    
  
  }

  // �ı���ָ�����
  function f_idxtyp_change()
  {
  
  
  }
  //�����ָ��
  function f_selectmore()
  {
    document.all("tr_idxtyp").style="display=;";
  }
  //sql�ĵ�һ��������URL�ĺ�׺���ڶ�����TIP,������ʾ
  //bShowSum=true ���һ����ʾ�ϼ�
  //bAddSerail�Ƿ����һ��ϵ��
  function f_showtable (sql,link,title,bShowSum,tagid,bAddSerail)
  {
 	
    // �����������	  
    var TabH = "<table width='95%' align='center' bordercolor='#000000' class='TableBorder' cellpadding='5' cellspacing='0'>" ;
    var TabE = "</table>" ;
    var str = "" ;
    var TdbgColor = "" ;
    var TdAlign = "" ;
    var url = "<%=usrinfo.getHomeURL()%>/XmlDB.sp?sql="+sql;
    _this.OpenHttpRequest(url,"POST");
    _this.AddHttpRequestParam("sql",sql,0);
    xml=_this.SendHttpRequest();
    
    _this.CloseHttpRequest();
    _this.XMLDS_Reset();
  
    _this.XMLDS_Parse(xml);
    
    var colcnt = _this.XMLDS_GetColumnCount();
    var rowcnt = _this.XMLDS_GetRowCount();  
    // ����������chart
	var c = document.all("Chart_"+tagid).Constants;
	//document.all("Chart_"+tagid).Clear();
	var newChart = document.all("Chart_"+tagid).Charts(0);	// document.all("Chart_"+tagid).Charts.Add() ����һ��
    	//newChart.Type = c.chChartTypePie;	// set to  a pie
	document.all("Chart_"+tagid).HasChartSpaceTitle =true;
	document.all("Chart_"+tagid).ChartSpaceTitle.Caption = "����ͼ";	// ����title
	document.all("Chart_"+tagid).ChartSpaceTitle.Font.Size = 9;    
	
    var namelist = "";
    for ( var row=0;row<rowcnt;row++ ){
    		if ( row != 0 ) namelist+=",";
    		namelist+=_this.XMLDS_GetStringAt(row,2);
    }
    newChart.SetData(c.chDimCategories, c.chDataLiteral, namelist);// ������
    for(var i=3;i<colcnt;i++ ) {	// loop һ����һ��ϵ��
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
    	s.SetData(c.chDimValues, c.chDataLiteral, valuelist);// ϵ��ֵ
    }
	    
    
    // ��ʾ���
    if ( bShowSum ) sumfields();  
    colcnt = _this.XMLDS_GetColumnCount();
    rowcnt = _this.XMLDS_GetRowCount();  
    for ( var i=0;i<rowcnt;i++){
      
      str += "<tr height='25' bgcolor='"+TdbgColor+"'>" ;
      if ( i==0 ) {// ��ͷ
        TdbgColor = "#d6dff7";	
        str += "<tr height='25' bgcolor='"+TdbgColor+"'>" ;
        for( j=2;j<colcnt;j++) {
          str += "<td align='center' class='TdBorderBottom'>" + _this.XMLDS_GetColumnName(j) + "</td>" ;
        }    
      }
      //���ñ���б���ɫ
      if ( i%2 == 0 )
        TdbgColor = "#F2F5FD" ;
      else
        TdbgColor = "#ffffee" ;
    
      str += "<tr height='25' bgcolor='"+TdbgColor+"' ";
      str += " onmouseover=\"this.style.backgroundColor='#D3E5FA'; this.style.cursor='hand'; title='"+_this.XMLDS_GetStringAt(i,1)+"'\" onmouseout=\"this.style.backgroundColor='"+TdbgColor+"';\" " ;
      str += " onclick=\"<A href=# onclick=window.open('"+link + _this.XMLDS_GetStringAt(i,0)+"');>\" >";
      for(var j=2;j<colcnt;j++)
      {
        //���õ�Ԫ����뷽ʽ
        if ( j == 2 )
          TdAlign = "center" ;
        else
          TdAlign = "right" ;
        str += "<td align='"+TdAlign+"'  >";// class='TdBorderBottom'
        str += _this.XMLDS_GetStringAt(i,j);
        str += "</td>" ;
      }
      str += "</tr>\n" ;
    }  
    //�������ݱ����ı����ʽ
    var DataTab = TabH + str + TabE ;
    var strTemp = "";
    strTemp+="<table border=\"1\" width=\"100%\"cellspacing=\"0\" id=\"table5\" height=\"200\">";
    strTemp+="	<tr>";
    strTemp+="		<td style=\"border-left: 1px solid #3A77BA; border-right: 1px solid #3A77BA; border-bottom: 1px solid #3A77BA; border-top: 1px solid #3A77BA;\" bgcolor=\"#FFFFFF\"  valign=\"top\">";
    strTemp+="			<table width=\"100%\" cellspacing=\"1\" ><tr><td align='center' colspan="+(colcnt-2)+">"+title+"</td></tr><tr><td><font color=\"#014E82\">"+str +"</font> </td></tr></table>";
    strTemp+="��	</td>";
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
  _this.XMLDS_SetStringAt(r,2,"�ϼƣ�");
  for(c=3;c<cols;c++)
  {
    _this.XMLDS_SetStringAt(r,c,sums[c]);
  }
  
}


-->
</script>

<script language="javascript">
// ��ʼ��
function winonload(){
	//newWin( "w_top11","�嵥�б�",480,"","<iframe src='../ShowXlsGrid.sp?grdid=idxbydate' />" );
	f_load('672','0000000163','�ʲ��ܶ�','������',false,false);	// 3��ͬʱ
	f_load('121','0000000201','�����ܶ�','������',true,true);
	f_load('578','0000000201','������','������',true,true);
}

// ��ָ����DIVλ�ô���һ������
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
	str+="��	</td>";
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
					<p align="center"><font color="#014E82">ʱ�����Ʒ�����ͳ�Ƹ���ָ���ꡢ�µ�����</font></td><td width="32">
					<p align="right">
					<img border="0" src="../xlsgrid/images/my/bartop.jpg" width="30" height="14"></td></tr></table>

					<table border="0" width="100%" id="table4" cellspacing="1">
						<tr>
							<td align="left" valign="top">
                  <table border=0  cellspacing=1 id=table5 height=100% width="100%">
                    <tr>
                      <td height=23 style="border: 1px solid #3A77BA bgcolor=#FFFFFF">
                      <table width=100%><tr><td width=101>&nbsp;<img border=0 src=../xlsgrid/images/my/collapse.gif width=9 height=9> 
						��ѯ������</td>
                        <td >
                        <img border=0 src=../xlsgrid/images/my/barright.jpg width=22 height=15 align=right></td></tr></table>
                      </td>
                    </tr>
                    <tr>
                      <td style="border-left: 1px solid #3A77BA; border-right: 1px solid #3A77BA; border-bottom: 1px solid #3A77BA;  bgcolor=#FFFFFF  valign=top">
                        <table  cellspacing=5><tr><td>
							<table border="0" id="table6" width="100%" >
								<tr>
									<td colspan="2" align="left" height="12" style="border-left-width: 1px; border-right-width: 1px; border-top-width: 1px; border-bottom: 1px solid #808080">
									&nbsp;<%=strIdx%>
									&nbsp;<a href="javascript:f_selectmore();">�����ָ��>></a>
									</td>
								</tr>
								<tr id="tr_idxtyp" style="display:none" >
									<td width="67"><select size="5" name="D1" onchange="javascript:f_idxtyp_change()">
									<%=strIdxtyp%>
									</select>��</td>
									<td valign="top">
									
��</td>
								</tr>
								</table>
							<table border="0"  id="table7" width="100%">
								<tr>
									<td width="200" valign="top"><div id="TXT_BYYEAR"></div>
									
									</td>
									<td valign="top" >
									<object classid="clsid:0002E55D-0000-0000-C000-000000000046" id="Chart_BYYEAR" width="520" height="200">
										<param name="XMLData" value="&lt;xml xmlns:x=&quot;urn:schemas-microsoft-com:office:excel&quot;&gt;
 &lt;x:ChartSpace&gt;
  &lt;x:OWCVersion&gt;11.0.0.5531         &lt;/x:OWCVersion&gt;
  &lt;x:Width&gt;13758&lt;/x:Width&gt;
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
  &lt;x:DefaultFont&gt;����&lt;/x:DefaultFont&gt;
  &lt;x:Interior&gt;
   &lt;x:ColorIndex&gt;None&lt;/x:ColorIndex&gt;
  &lt;/x:Interior&gt;
  &lt;x:Chart&gt;
   &lt;x:PlotArea&gt;
    &lt;x:Interior&gt;
     &lt;x:Color&gt;#E0FFFF&lt;/x:Color&gt;
     &lt;x:FillEffect&gt;
      &lt;x:fill x:type=&quot;Solid&quot; x:color=&quot;#E0FFFF&quot;/&gt;
     &lt;/x:FillEffect&gt;
    &lt;/x:Interior&gt;
    &lt;x:Graph&gt;
     &lt;x:Type&gt;Column&lt;/x:Type&gt;
     &lt;x:SubType&gt;3D&lt;/x:SubType&gt;
     &lt;x:Series&gt;
      &lt;x:FormatMap&gt;
      &lt;/x:FormatMap&gt;
      &lt;x:Name&gt;ϵ�� 1&lt;/x:Name&gt;
      &lt;x:Caption&gt;
       &lt;x:DataSourceIndex&gt;-1&lt;/x:DataSourceIndex&gt;
       &lt;x:Data&gt;&amp;quot;ϵ�� 1&amp;quot;&lt;/x:Data&gt;
      &lt;/x:Caption&gt;
      &lt;x:Index&gt;0&lt;/x:Index&gt;
      &lt;x:Category&gt;
       &lt;x:DataSourceIndex&gt;-1&lt;/x:DataSourceIndex&gt;
       &lt;x:Data&gt;{&amp;quot;A&amp;quot;}&lt;/x:Data&gt;
      &lt;/x:Category&gt;
      &lt;x:Value&gt;
       &lt;x:DataSourceIndex&gt;-1&lt;/x:DataSourceIndex&gt;
       &lt;x:Data&gt;{10.0}&lt;/x:Data&gt;
      &lt;/x:Value&gt;
      &lt;x:Marker&gt;
       &lt;x:Symbol&gt;None&lt;/x:Symbol&gt;
      &lt;/x:Marker&gt;
      &lt;x:Explode&gt;0&lt;/x:Explode&gt;
      &lt;x:Thickness&gt;10&lt;/x:Thickness&gt;
     &lt;/x:Series&gt;
     &lt;x:Dimension&gt;
      &lt;x:ScaleID&gt;224263680&lt;/x:ScaleID&gt;
      &lt;x:Index&gt;Categories&lt;/x:Index&gt;
     &lt;/x:Dimension&gt;
     &lt;x:Dimension&gt;
      &lt;x:ScaleID&gt;224207192&lt;/x:ScaleID&gt;
      &lt;x:Index&gt;Value&lt;/x:Index&gt;
     &lt;/x:Dimension&gt;
     &lt;x:Dimension&gt;
      &lt;x:ScaleID&gt;224263476&lt;/x:ScaleID&gt;
      &lt;x:Index&gt;Series&lt;/x:Index&gt;
     &lt;/x:Dimension&gt;
     &lt;x:Overlap&gt;0&lt;/x:Overlap&gt;
     &lt;x:GapWidth&gt;150&lt;/x:GapWidth&gt;
     &lt;x:FirstSliceAngle&gt;0&lt;/x:FirstSliceAngle&gt;
    &lt;/x:Graph&gt;
    &lt;x:Axis&gt;
     &lt;x:AxisID&gt;225975964&lt;/x:AxisID&gt;
     &lt;x:ScaleID&gt;224263680&lt;/x:ScaleID&gt;
     &lt;x:Type&gt;Category&lt;/x:Type&gt;
     &lt;x:MajorTick&gt;Outside&lt;/x:MajorTick&gt;
     &lt;x:MinorTick&gt;None&lt;/x:MinorTick&gt;
     &lt;x:Placement&gt;Bottom&lt;/x:Placement&gt;
     &lt;x:GroupingEnum&gt;Auto&lt;/x:GroupingEnum&gt;
    &lt;/x:Axis&gt;
    &lt;x:Axis&gt;
     &lt;x:AxisID&gt;225973400&lt;/x:AxisID&gt;
     &lt;x:ScaleID&gt;224207192&lt;/x:ScaleID&gt;
     &lt;x:Type&gt;Value&lt;/x:Type&gt;
     &lt;x:MajorGridlines&gt;
     &lt;/x:MajorGridlines&gt;
     &lt;x:MajorTick&gt;Outside&lt;/x:MajorTick&gt;
     &lt;x:MinorTick&gt;None&lt;/x:MinorTick&gt;
     &lt;x:Placement&gt;Left&lt;/x:Placement&gt;
    &lt;/x:Axis&gt;
    &lt;x:Axis&gt;
     &lt;x:AxisID&gt;40540612&lt;/x:AxisID&gt;
     &lt;x:ScaleID&gt;224263476&lt;/x:ScaleID&gt;
     &lt;x:Type&gt;Series&lt;/x:Type&gt;
     &lt;x:MajorTick&gt;Outside&lt;/x:MajorTick&gt;
     &lt;x:MinorTick&gt;None&lt;/x:MinorTick&gt;
     &lt;x:Placement&gt;Bottom&lt;/x:Placement&gt;
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
    &lt;x:Interior&gt;
     &lt;x:Color&gt;#F0FFFF&lt;/x:Color&gt;
     &lt;x:FillEffect&gt;
      &lt;x:fill x:type=&quot;Solid&quot; x:color=&quot;#F0FFFF&quot;/&gt;
     &lt;/x:FillEffect&gt;
    &lt;/x:Interior&gt;
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
   &lt;x:ScaleID&gt;224263680&lt;/x:ScaleID&gt;
  &lt;/x:Scaling&gt;
  &lt;x:Scaling&gt;
   &lt;x:ScaleID&gt;224207192&lt;/x:ScaleID&gt;
  &lt;/x:Scaling&gt;
  &lt;x:Scaling&gt;
   &lt;x:ScaleID&gt;224263476&lt;/x:ScaleID&gt;
  &lt;/x:Scaling&gt;
 &lt;/x:ChartSpace&gt;
&lt;/xml&gt;">
										<param name="ScreenUpdating" value="-1">
										<param name="EnableEvents" value="-1">
<table width='100%' cellpadding='0' cellspacing='0' border='0' height='8'><tr><td bgColor='#336699' height='25' width='10%'>&nbsp;</td><td bgColor='#666666'width='85%'><font face='����' color='white' size='4'><b>&nbsp; ȱ�� Microsoft Office Web Components</b></font></td></tr><tr><td bgColor='#cccccc' width='15'>&nbsp;</td><td bgColor='#cccccc' width='500px'><br> <font face='����' size='2'>����ҳҪ�� Microsoft Office Web Components��<p align='center'> <a href='G:/files/owc11/setup.exe'>�����˴���װ Microsoft Office Web Components��</a>.</p></font><p><font face='����' size='2'>����ҳͬʱҪ�� Microsoft Internet Explorer 5.01 ����߰汾��</p><p align='center'><a href='http://www.microsoft.com/windows/ie/default.htm'> �����˴���װ���µ� Internet Explorer</a>.</font><br>&nbsp;</td></tr></table></object>

									
									</td>
								</tr>
							</table>
							<table border="0"  id="table8" width="100%">
								<tr>
									<td bgcolor="#86C2FF">
									��ָ������ ѡ���� <select size="1" name="SEL_YEAR">
<option value="2006">2006��</option>
<option value="2005">2005��</option>
<option value="2004">2004��</option>
<option value="2003">2003��</option>
<option value="2002">2002��</option>
					</select></td>
								</tr>
								<tr>
									<td>
									<object classid="clsid:0002E55D-0000-0000-C000-000000000046" id="Chart_BYMONTH" width="720" height="200">
										<param name="XMLData" value="&lt;xml xmlns:x=&quot;urn:schemas-microsoft-com:office:excel&quot;&gt;
 &lt;x:ChartSpace&gt;
  &lt;x:OWCVersion&gt;11.0.0.5531         &lt;/x:OWCVersion&gt;
  &lt;x:Width&gt;19050&lt;/x:Width&gt;
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
  &lt;x:DefaultFont&gt;����&lt;/x:DefaultFont&gt;
  &lt;x:Interior&gt;
   &lt;x:ColorIndex&gt;None&lt;/x:ColorIndex&gt;
  &lt;/x:Interior&gt;
  &lt;x:Chart&gt;
   &lt;x:PlotArea&gt;
    &lt;x:Interior&gt;
     &lt;x:Color&gt;#E0FFFF&lt;/x:Color&gt;
     &lt;x:FillEffect&gt;
      &lt;x:fill x:type=&quot;Solid&quot; x:color=&quot;#E0FFFF&quot;/&gt;
     &lt;/x:FillEffect&gt;
    &lt;/x:Interior&gt;
    &lt;x:Graph&gt;
     &lt;x:Type&gt;Column&lt;/x:Type&gt;
     &lt;x:SubType&gt;3D&lt;/x:SubType&gt;
     &lt;x:Series&gt;
      &lt;x:FormatMap&gt;
      &lt;/x:FormatMap&gt;
      &lt;x:Name&gt;ϵ�� 1&lt;/x:Name&gt;
      &lt;x:Caption&gt;
       &lt;x:DataSourceIndex&gt;-1&lt;/x:DataSourceIndex&gt;
       &lt;x:Data&gt;&amp;quot;ϵ�� 1&amp;quot;&lt;/x:Data&gt;
      &lt;/x:Caption&gt;
      &lt;x:Index&gt;0&lt;/x:Index&gt;
      &lt;x:Category&gt;
       &lt;x:DataSourceIndex&gt;-1&lt;/x:DataSourceIndex&gt;
       &lt;x:Data&gt;{&amp;quot;A&amp;quot;}&lt;/x:Data&gt;
      &lt;/x:Category&gt;
      &lt;x:Value&gt;
       &lt;x:DataSourceIndex&gt;-1&lt;/x:DataSourceIndex&gt;
       &lt;x:Data&gt;{10.0}&lt;/x:Data&gt;
      &lt;/x:Value&gt;
      &lt;x:Marker&gt;
       &lt;x:Symbol&gt;None&lt;/x:Symbol&gt;
      &lt;/x:Marker&gt;
      &lt;x:Explode&gt;0&lt;/x:Explode&gt;
      &lt;x:Thickness&gt;10&lt;/x:Thickness&gt;
     &lt;/x:Series&gt;
     &lt;x:Dimension&gt;
      &lt;x:ScaleID&gt;236625448&lt;/x:ScaleID&gt;
      &lt;x:Index&gt;Categories&lt;/x:Index&gt;
     &lt;/x:Dimension&gt;
     &lt;x:Dimension&gt;
      &lt;x:ScaleID&gt;236620108&lt;/x:ScaleID&gt;
      &lt;x:Index&gt;Value&lt;/x:Index&gt;
     &lt;/x:Dimension&gt;
     &lt;x:Dimension&gt;
      &lt;x:ScaleID&gt;236625244&lt;/x:ScaleID&gt;
      &lt;x:Index&gt;Series&lt;/x:Index&gt;
     &lt;/x:Dimension&gt;
     &lt;x:Overlap&gt;0&lt;/x:Overlap&gt;
     &lt;x:GapWidth&gt;150&lt;/x:GapWidth&gt;
     &lt;x:FirstSliceAngle&gt;0&lt;/x:FirstSliceAngle&gt;
    &lt;/x:Graph&gt;
    &lt;x:Axis&gt;
     &lt;x:AxisID&gt;226013756&lt;/x:AxisID&gt;
     &lt;x:ScaleID&gt;236625448&lt;/x:ScaleID&gt;
     &lt;x:Type&gt;Category&lt;/x:Type&gt;
     &lt;x:MajorTick&gt;Outside&lt;/x:MajorTick&gt;
     &lt;x:MinorTick&gt;None&lt;/x:MinorTick&gt;
     &lt;x:Placement&gt;Bottom&lt;/x:Placement&gt;
     &lt;x:GroupingEnum&gt;Auto&lt;/x:GroupingEnum&gt;
    &lt;/x:Axis&gt;
    &lt;x:Axis&gt;
     &lt;x:AxisID&gt;226015608&lt;/x:AxisID&gt;
     &lt;x:ScaleID&gt;236620108&lt;/x:ScaleID&gt;
     &lt;x:Type&gt;Value&lt;/x:Type&gt;
     &lt;x:MajorGridlines&gt;
     &lt;/x:MajorGridlines&gt;
     &lt;x:MajorTick&gt;Outside&lt;/x:MajorTick&gt;
     &lt;x:MinorTick&gt;None&lt;/x:MinorTick&gt;
     &lt;x:Placement&gt;Left&lt;/x:Placement&gt;
    &lt;/x:Axis&gt;
    &lt;x:Axis&gt;
     &lt;x:AxisID&gt;226015820&lt;/x:AxisID&gt;
     &lt;x:ScaleID&gt;236625244&lt;/x:ScaleID&gt;
     &lt;x:Type&gt;Series&lt;/x:Type&gt;
     &lt;x:MajorTick&gt;Outside&lt;/x:MajorTick&gt;
     &lt;x:MinorTick&gt;None&lt;/x:MinorTick&gt;
     &lt;x:Placement&gt;Bottom&lt;/x:Placement&gt;
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
    &lt;x:Interior&gt;
     &lt;x:Color&gt;#F0FFFF&lt;/x:Color&gt;
     &lt;x:FillEffect&gt;
      &lt;x:fill x:type=&quot;Solid&quot; x:color=&quot;#F0FFFF&quot;/&gt;
     &lt;/x:FillEffect&gt;
    &lt;/x:Interior&gt;
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
   &lt;x:ScaleID&gt;236625448&lt;/x:ScaleID&gt;
  &lt;/x:Scaling&gt;
  &lt;x:Scaling&gt;
   &lt;x:ScaleID&gt;236620108&lt;/x:ScaleID&gt;
  &lt;/x:Scaling&gt;
  &lt;x:Scaling&gt;
   &lt;x:ScaleID&gt;236625244&lt;/x:ScaleID&gt;
  &lt;/x:Scaling&gt;
 &lt;/x:ChartSpace&gt;
&lt;/xml&gt;">
										<param name="ScreenUpdating" value="-1">
										<param name="EnableEvents" value="-1">
<table width='100%' cellpadding='0' cellspacing='0' border='0' height='8'><tr><td bgColor='#336699' height='25' width='10%'>&nbsp;</td><td bgColor='#666666'width='85%'><font face='����' color='white' size='4'><b>&nbsp; ȱ�� Microsoft Office Web Components</b></font></td></tr><tr><td bgColor='#cccccc' width='15'>&nbsp;</td><td bgColor='#cccccc' width='500px'><br> <font face='����' size='2'>����ҳҪ�� Microsoft Office Web Components��<p align='center'> <a href='G:/files/owc11/setup.exe'>�����˴���װ Microsoft Office Web Components��</a>.</p></font><p><font face='����' size='2'>����ҳͬʱҪ�� Microsoft Internet Explorer 5.01 ����߰汾��</p><p align='center'><a href='http://www.microsoft.com/windows/ie/default.htm'> �����˴���װ���µ� Internet Explorer</a>.</font><br>&nbsp;</td></tr></table></object>

									</td>
								</tr>
								<tr>
									<td><div id="TXT_BYMONTH"></div>
									��</td>
								</tr>
							</table>							
							<p>��</p>
							<p>��</p>
							<p>��</p>
							<p>��</p>
							<p>��</td></tr></table>
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