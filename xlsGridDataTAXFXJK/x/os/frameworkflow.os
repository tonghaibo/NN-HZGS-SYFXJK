function x_frameworkflow(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var web = new JavaPackage("com.xlsgrid.net.web");
var grd = new JavaPackage("com.xlsgrid.net.grd");
var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var tag = new JavaPackage("com.xlsgrid.net.tag");
var xmldsform = new tag.XmlDSForm();
var EAfunc = new pubpack.EAFunc();
//作为.sp服务时的入口	
//预定义变量：request,response
function Response()
{
	var db = null;
        var ret= "";
        var sql = "";
        var _sql = "";
        var ds = null;
        var _ds = null;
        var GHtml = "";
	var SYTID = pub.EAFunc.NVL(request.getParameter("sytid"),"");
	


	var usr = web.EASession.GetLoginInfo(request);
	if (SYTID == "" || SYTID == null){
		SYTID = usr.getSytid();
	}
      var ret= "";
      var leftgrdid = pubpack.EAFunc.NVL(request.getParameter("leftgrdid"),"");
      var lefturl = pubpack.EAFunc.NVL(request.getParameter("lefturl"),"" );
      if(leftgrdid!="")lefturl="show.sp?grdid="+leftgrdid;
      var rightgrdid = pubpack.EAFunc.NVL(request.getParameter("rightgrdid"),"");
      var righturl = pubpack.EAFunc.NVL(request.getParameter("righturl"),"" );
      if (rightgrdid!="" && righturl=="")righturl= "show.sp?grdid="+rightgrdid;
      var rightflowid = pubpack.EAFunc.NVL(request.getParameter("rightflowid"),"");
      var rightflowsytid = pubpack.EAFunc.NVL(request.getParameter("rightflowsyt"),"");
      var charttype= pubpack.EAFunc.NVL(request.getParameter("defcharttype"),"");
      	if(charttype=="") charttype = "Funnel";
	
      
      if ( rightflowid !="" ) {
      		righturl = "flow.jsp?flowid="+rightflowid ;
      		if (rightflowsytid !="" ) righturl += "&syt="+rightflowsytid ;
      }
      var leftflowid = pubpack.EAFunc.NVL(request.getParameter("leftflowid"),"");
      var leftflowsytid = pubpack.EAFunc.NVL(request.getParameter("leftflowsyt"),"");
      if ( leftflowid !="" ) {
      		lefturl = "flow.jsp?flowid="+leftflowid ;
      		if (leftflowsytid !="" ) lefturl += "&syt="+leftflowsytid ;
      }
      
      var wfgrdid = pub.EAFunc.NVL(request.getParameter("wfgrdid"),"");// 工作流中间件编号
      if (wfgrdid!="")
      	righturl = "show.sp?grdid=WF_Funnel&wfgrdid="+wfgrdid;
      	
      	
      	
      var paramlist = pubpack.EAFunc.GetRequestQueryString(request);
      if (lefturl!=""&&paramlist!="" ) {
  	lefturl+="&"+paramlist;
      }
      if (righturl!=""&&paramlist!="" ) {
  	righturl+="&"+paramlist;
      }
      //加载GUID
//      var GUID = pub.EAFunc.NVL(request.getParameter("guid"),"");
//      if(GUID!=""&&lefturl!="") 
//      	lefturl = lefturl + "&guid="+GUID;
//      if(GUID!=""&&righturl!="") 
//      	righturl= righturl+ "&guid="+GUID;
      	
      try {
            db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
            
          

	  var optionstr = "";
	  var optionds = db.QuerySQL("select * from v_charttype");
            
            for(var r = 0;r <optionds .getRowCount();r ++)
            {	//有多少个主题
            	    var id = optionds .getStringAt(r,"ID");
            	    var typ = optionds .getStringAt(r,"typ");
            	    var name = optionds .getStringAt(r,"name");
            	    if(id=="Funnel"||(typ =="1")){
	            	    if (id=="Funnel")
	            	    	optionstr+="<option value='"+id+"-"+typ+"' selected>"+name+"</option>";
	            	    else optionstr+="<option value='"+id+"-"+typ+"' >"+name+"</option>";
		    }
	   }
	  
	     ret="	<html>
    			<LINK rel=stylesheet type=text/css HREF='xlsgrid/css/main.css'>
    			<script language='javascript' src='xlsgrid/js/main.js' ></Script>
    			<script language='javascript' src='xlsgrid/images/flash/FusionCharts.js' ></Script>
			<head>
			<meta http-equiv='Content-Type' content='text/html; charset=gb2312'>
			
			<STYLE>
    						.navPoint {
					COLOR: #225f98; CURSOR: hand; FONT-FAMILY: 'Webdings'; FONT-SIZE: 9pt
					}
			</STYLE>
			<script>
				
				function switchRBar()
				{
					if (RPoint.innerText==4)
					{
						RPoint.innerText=3;
						rightTd.style.display ='none'; 
    							rightTd.style.width = 10;
					}
					else
					{
						RPoint.innerText=4;
						rightTd.style.display=''; 
   							rightTd.style.width = 400;
					}
				}

				
				      
			      function SetRightURL(url){
			        _grid.location=url;
			      }
			      
			    function loadmainwnd ()
			    {
			    	_right.location = '"+lefturl +"';
			    
			    }
								
			    //更新分析图1
			    var chartxml1 = '';
			    var chartxml2 = '';
			    var charttype =  '"+charttype+"';
			    var chartdatatype = '1';
			    function f_setchartxml1(xml){	//多维度的XML格式
			    	chartxml1  = xml;
			    }	 
			    function f_setchartxml2(xml){	//多维度的XML格式
			    	chartxml2  = xml;
			    }	 
			    function f_chgchart()
			    {
   					var swf = document.all('chgchart').value;
			    	var ss = swf.split('-');
			    	var chart1 = new FusionCharts('xlsgrid/images/flash/'+ss[0]+'.swf', 'ChartId1', '400', '300'); 
			    	chartdatatype  = ss[1];
			    	if ( ss[1]=='1') 
			            chart1.setDataXML(chartxml1  );
			        else     chart1.setDataXML(chartxml2  );

			        chart1.render('chartdiv1');
			    }
			    function f_getcharttype()
			    {
			    	return document.all('chgchart').value;

			    }
			    function f_getchartxml1()
			    {
			    	return chartxml1  ;

			    }
			    function f_getchartxml2()
			    {
			    	return chartxml2;

			    }
			    function f_showpath(tip){
			    	document.all('pathtip').innerHTML= tip;
			    
			    }
			    
			    function zoomchart()
			    {
			    	window.open( 'BIPath.sp','','fullscreen=yes,toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=no');
			    }
					

		</script>
		</head> 
		<body  topmargin='0' leftmargin='0' scroll=no bgcolor='#F6F6F6' >
		
			<table width=100% height=100% border='0' cellspacing='0' cellpadding='0' ><tr>
				<td id=rightTd width=400>
        				<table width=100% height=100% border='0' cellspacing='0' cellpadding='0' >
        				<tr><td height=30 align=center background=xlsgrid/images/xlsgrid/tab.bg.off.grid.gif>
        				更换图型：&nbsp;<select id=chgchart size='1' name='chgchart' onchange='f_chgchart();' style='border: 1px solid #808080'>
        				"+optionstr+"
        				</select>
        				&nbsp;<a href='javascript:zoomchart();'>放大图</a>&nbsp;
        				</td></tr>

        				<tr><td height=300 valign=top>

        				<div id='chartdiv1' align='center'> &nbsp; </div>
		      		
					</td></tr>
					
	        				<tr><td height=30 align=left background=xlsgrid/images/xlsgrid/tab.bg.off.grid.gif>
	        					<div id='pathtip'>&nbsp;</div>
	        				</td></tr>
					<tr><td valign=top>
					<IFRAME name='_left' id='_left' frameBorder=0 width='100%' height='100%' border='0' src='"+lefturl +"'
	        				scrolling='yes' style='border: 0px solid #808080' >
	        			</IFRAME>
					</td></tr>
	        			</td>
	        			
	        			</td></tr></table>		  
				</td>
				
        			<TD  class=navPoint id=RPoint bgColor=#EEEEEE onclick=switchRBar() style='border-right: 1px solid #CCCCCC; border-left: 1px solid #CCCCCC; WIDTH: 3pt;vertical-align: middle;'>
      					3
    				</TD>
				<td >
        			<IFRAME name='_grid' id='_grid' frameBorder=0 width='100%' height='100%' border='0'
        				scrolling='yes' style='border: 0px solid #808080' src='"+righturl+"' >
        			</IFRAME>	
        			</td>
        			
			</tr></table>
	
		</body>
		</html>
	";

      }
      catch ( ee ) {
            db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      return ret ;
}


}