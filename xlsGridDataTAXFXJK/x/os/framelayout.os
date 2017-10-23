function x_framelayout(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//作为.sp服务时的入口
//预定义变量：request,response
//用于显示左右2个frame的页面，传入参数
//	lefturl,leftgrdid,righturl,rightgrdid
//	如果leftgrdid存在，那么使用show.sp?grdid=leftgrdid来替代lefturl，对于right也是一样
function Response()
{
      var ret = "";
      
      var leftgrdid = pubpack.EAFunc.NVL(request.getParameter("leftgrdid"),"");
      var lefturl = pubpack.EAFunc.NVL(request.getParameter("lefturl"),"show.sp?grdid="+leftgrdid );
      var rightgrdid = pubpack.EAFunc.NVL(request.getParameter("rightgrdid"),"");
      var righturl = pubpack.EAFunc.NVL(request.getParameter("righturl"),"" );
      
      var rightgrdid2 = pubpack.EAFunc.NVL(request.getParameter("rightgrdid2"),"");
      var righturl2 = pubpack.EAFunc.NVL(request.getParameter("righturl2"),"" );
      if (rightgrdid2!="" && righturl2=="")righturl2= "show.sp?grdid="+rightgrdid2;
      var rightflowid2 = pubpack.EAFunc.NVL(request.getParameter("rightflowid2"),"");
      var rightflowsytid2 = pubpack.EAFunc.NVL(request.getParameter("rightflowsyt2"),"");
      if ( rightflowid2 !="" ) {
      		righturl2 = "flow.jsp?flowid="+rightflowid2 ;
      		if (rightflowsytid2 !="" ) righturl2 += "&syt="+rightflowsytid2 ;
      }
      
      if (rightgrdid!="" && righturl=="")righturl= "show.sp?grdid="+rightgrdid;
      var rightflowid = pubpack.EAFunc.NVL(request.getParameter("rightflowid"),"");
      var rightflowsytid = pubpack.EAFunc.NVL(request.getParameter("rightflowsyt"),"");
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
      var leftlayoutid = pubpack.EAFunc.NVL(request.getParameter("leftlayoutid"),"");
      var leftlayoutorgid = pubpack.EAFunc.NVL(request.getParameter("leftlayoutorg"),"");
      if ( leftlayoutid !="" ) {
      		lefturl = "Layout.sp?id="+leftlayoutid  ;
      		if (leftlayoutorgid  !="" ) lefturl += "&org="+leftlayoutorgid  ;
      }
      var rightlayoutid = pubpack.EAFunc.NVL(request.getParameter("rightlayoutid"),"");
      var rightlayoutorgid = pubpack.EAFunc.NVL(request.getParameter("rightlayoutorg"),"");
      if ( rightlayoutid !="" ) {
      		righturl = "Layout.sp?id="+rightlayoutid  ;
      		if (rightlayoutorgid  !="" ) righturl += "&org="+rightlayoutorgid  ;
      }
      
      
      var rightlayoutid2 = pubpack.EAFunc.NVL(request.getParameter("rightlayoutid2"),"");
      var rightlayoutorgid2 = pubpack.EAFunc.NVL(request.getParameter("rightlayoutorg2"),"");
      if ( rightlayoutid2 !="" ) {
      		righturl2 = "Layout.sp?id="+rightlayoutid2  ;
      		if (rightlayoutorgid2  !="" ) righturl2 += "&org="+rightlayoutorgid2  ;
      }
	

      var title = pubpack.EAFunc.NVL(request.getParameter("title"),"XMIDWARE" );
      var width = pubpack.EAFunc.NVL(request.getParameter("width"),"280" );
      var paramlist = pubpack.EAFunc.GetRequestQueryString(request);
      if (lefturl!=""&&paramlist!="" ) {
  	lefturl+="&"+paramlist;
      }
      if (righturl!=""&&paramlist!="" ) {
  	righturl+="&"+paramlist;
      }
	 if (righturl2!=""&&paramlist!="" ) {
  	righturl2+="&"+paramlist;
      }
	//flow.jsp&flowid=
//return righturl;
	
	ret+="
<html> <head>  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=GBK\">  <title>"+title+"</title>  </head>
<script language = \"javascript\">
var num = 0;
function showInfo(str)
{
	try{
		for(var i = 0;i <  num ;i ++)
			document.getElementById(\"topic\"+i).style.display = 'none';
		document.getElementById(str).style.display = 'block';
	}
	catch ( e ) {}
}
var bShowLeftWin= true;
function switchLBar(){
	if (bShowLeftWin==true){
		bShowLeftWin=false;
		leftTd.style.display =\"none\"; 
    		midTd.style.width = 8;
	}
	else{
		bShowLeftWin=true;

		leftTd.style.display =\"\"; 
    		midTd.style.width = 8;
	}
}
</script>
<LINK rel=stylesheet type=text/css HREF=\"xlsgrid/css/main.css\"> 
<script language='javascript' src='xlsgrid/js/main.js' ></Script> 
<body style=\"background-color: #FFFFFF\" onload=\"showInfo('topic0');\">
<table border=\"1\" bordercolorlight=\"#4791C5\" bordercolordark=\"#4791C5\" style=\"border-collapse: collapse\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" height=\"100%\" id=\"table1\">
	<tr>
		<td width="+width +" valign=top id=\"leftTd\" valign=top>
		 <iframe id=\"left\" name=\"left\" height=100% width=100% src='"+lefturl+"' frameborder=0></iframe>
		</td>
		<td valign=middle width=\"8\"  background=\"xlsgrid/images/bbk2.jpg\" style=\"cursor:pointer;\" onclick=\"switchLBar()\"  id=\"midTd\">&nbsp;</td>
		<td valign=top>
			 <iframe id=\"right\" name=\"right\" height=100% width=100% src='"+righturl+"' frameborder=0></iframe>
		</td>
	</tr>
</table>
</body>
</html>
              	
	
	";
      return ret ;
}
}