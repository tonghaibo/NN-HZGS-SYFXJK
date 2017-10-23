function x_BIPath(){var pub= new JavaPackage("com.xlsgrid.net.pub");
var pubpack= new JavaPackage("com.xlsgrid.net.pub");
var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var utilpack = new JavaPackage ( "java.util");
var basePath = pubpack.EAOption.dynaDataRoot;

var grd = new JavaPackage("com.xlsgrid.net.grd");

var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var tag = new JavaPackage("com.xlsgrid.net.tag");
var xmldsform = new tag.XmlDSForm();
var EAfunc = new pubpack.EAFunc();
  function  XmlToStd(xml)
  {
      xml = pub.EAFunc.Replace(xml, "&"+"quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"amp;quot;", "\"" );
      xml = pub.EAFunc.Replace(xml, "&"+"apos;", "'"  );
    return xml;
  }
//得到模型下面的所有主题
function GetDIMTOPIC()
{
	var xml = _GetDIMTOPIC("",modguid);
	return xml;
}
//树型递归函数
function _GetDIMTOPIC(topicid,modguid)
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var refidstr = " and refid is null ";
	if ( topicid!= "" ) 
		refidstr = " and refid='"+topicid+"'";
	var sql = "select id,name,guid from dim_topic where refmod='"+modguid+"' "+refidstr+" and url is null order by id";

	var ds = pubpack.EADbTool.QuerySQL(sql);
	if ( ds == null ) return "";
	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"ID");
		var name = ds.getStringAt(i,"NAME");
		var guid = ds.getStringAt(i,"GUID");
		xml+="<"+name + " imageid=\"5\" topicid=\""+id+"\"  modguid=\""+modguid+"\" topicguid=\""+guid+"\">";
		//递归，找出下级所有的
		xml+=_GetDIMTOPIC(id ,modguid);
		xml+="</"+name+">";

	}
	
	return xml;
}



//作为.sp服务时的入口	
//预定义变量：request,response
function Response()
{
	var optionstr = "";
	  var optionds = pubpack.EADbTool.QuerySQL("select * from v_charttype");
            
            for(var r = 0;r <optionds .getRowCount();r ++)
            {	//有多少个主题
            	    var id = optionds .getStringAt(r,"ID");
            	    var typ = optionds .getStringAt(r,"typ");
            	    var name = optionds .getStringAt(r,"name");
            	    optionstr+="<option value='"+id+"-"+typ+"'>"+name+"</option>";
	   }

	var    ret="	<html>
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
					    var bfirst = false;
					    function f_chgchart()
					    {
   					    	var swf = opener.f_getcharttype();
   					    	if ( bfirst == true ) 
	   					    	swf=document.all('chgchart').value;
	   					bfirst  = true;
					    	var ss = swf.split('-');
					    	var w = ''+document.body.clientWidth ;
					    	var h = ''+(document.body.clientHeight-30) ;
					    	var chart1 = new FusionCharts('xlsgrid/images/flash/'+ss[0]+'.swf', 'ChartId1', w, h); 
					    	chartdatatype  = ss[1];
					    	if ( ss[1]=='1') 
					            chart1.setDataXML(opener.f_getchartxml1()  );
					        else     chart1.setDataXML(opener.f_getchartxml2() );

					        chart1.render('chartdiv1');
					    }



				</script>
				</head> 
				<body  topmargin='0' leftmargin='0' scroll=no onload='javascript:f_chgchart();'>
					<table width=100% height=100% border=0 cellspacing=0 cellpadding=0 >
						<tr><td height=30 align=center background=xlsgrid/images/xlsgrid/tab.bg.off.grid.gif>图型更换：&nbsp;<select id=chgchart size=1 name=chgchart onchange=f_chgchart(); style=border: 1px solid #808080>"
				                  	+optionstr+"</select></td></tr><tr><td valign=top><div id=chartdiv1 align=center> &nbsp; </div>
				        </td></tr></table>
				</body>
			</html>
	";
      return ret ;
}



}