<%@page contentType="text/html;charset=gb2312" import="java.util.*"%>
<html>
<head>
<script>
  function DivSetVisible(state,div,refobj,toggle)
  {
       var DivRef = div;//document.getElementById('PopupDiv');
       var IfrRef = document.getElementById("frame1");
      if(state && toggle && IfrRef.style.display!="none") state=false;    
	  if(state)
   {
    if(!!refobj){
    div.style.left=getLeft(refobj);
    div.style.top=getTop(refobj)+refobj.offsetHeight;
    div.style.visibility="visible";
	}
    DivRef.style.display = "block";
    IfrRef.style.width = DivRef.offsetWidth;
    IfrRef.style.height = DivRef.offsetHeight;
    IfrRef.style.top = DivRef.style.top;
    IfrRef.style.left = DivRef.style.left;
    IfrRef.style.zIndex = DivRef.style.zIndex - 1;
    IfrRef.style.display = "block";
   }
   else
   {
    DivRef.style.display = "none";
    IfrRef.style.display = "none";
   }
  }
</script>
  <LINK rel=stylesheet type=text/css HREF="../xlsgrid/css/main.css">
  <meta http-equiv="Content-Language" content="zh-cn">
  <meta http-equiv="Content-Type" content="text/html; charset=gb2312"> 
  <title>ª∂”≠ π”√xlsGrid</title>
</head>
<body topmargin="0" > 
<table width="100%" height="100%" cellspacing="0">
  <tr>
    <td align="left">
      <p align="center"><img border="0" src="images/SALES_1.jpg" usemap="#FPMap0" alt="" style="border:1px solid #000000; color: #FFFFFF; background-color: #FFFFFF; padding-left:4px; padding-right:4px; padding-top:1px; padding-bottom:1px">
        <map name="FPMap0">
          <area href="../BillEntry.sp?grdid=soplanCopy" shape="rect" onMouseOut="DivSetVisible(false,menu1)" onMouseOver="DivSetVisible(true,menu1)"  coords="186,261,233,299">
          <area href="../BillEntry.sp?grdid=135" shape="rect" coords="408,372,454,410">
          <area href="../BillEntry.sp?grdid=136" shape="rect" coords="484,371,530,409">
          <area href="../BillEntry.sp?grdid=131_1y" shape="rect" coords="332,372,378,410">
          <area href="../BillEntry.sp?grdid=131" shape="rect" coords="262,282,371,331">
          <area href="../BillEntry.sp?grdid=137" shape="rect" coords="263,107,370,157">
          <area href="../BillEntry.sp?grdid=SOPLAN" shape="rect" coords="278,191,356,245">
          <area href="../BillEntry.sp?grdid=expData" shape="rect" coords="178,199,244,238">
          <area href="../SERP/PO_1.html" shape="rect" coords="487,299,584,336">
          <area href="../SERP/CTRL_1.html" shape="rect" coords="482,124,579,161">	    
        </map>		  
	
</p><span style="z-index:100; BACKGROUND-COLOR: #FFFFFB; position:absolute; left: 319px; width: 169px; top: 360px; height: 97px;" id=menu1 class="close" onMouseOut="DivSetVisible(false,this)" onMouseOver="DivSetVisible(true,this)">
<table cellpadding="2" ><tr><td align=left>1111</td></tr></table></span>
</td></tr></table>
</body></html>