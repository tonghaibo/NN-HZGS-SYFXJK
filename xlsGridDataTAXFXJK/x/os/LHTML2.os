function x_LHTML2(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");

var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb");
var layoutpack = new JavaPackage ( "com.xlsgrid.net.layout");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd");

var langpack = new JavaPackage ( "java.lang");

//WNDMOD �����ͣ�������չ�У�
//	_this.SetListValue(list1,"HTML","HTML");
//	_this.SetListValue(list1,"OS","OS�ű�");
//	_this.SetListValue(list1,"MW","�м������");	
//	_this.SetListValue(list1,"FRAME","�ڲ�FRAME");
//	_this.SetListValue(list1,"FRAMEGROUP","��ҳFRAME��");	
//	_this.SetListValue(list1,"SCROLLIMAGE","����ͼƬ");
//	_this.SetListValue(list1,"TOOLBAR","ϵͳĬ�Ϲ�����");		
//	_this.SetListValue(list1,"MENU","�˵���");	
//	_this.SetListValue(list1,"FLASH","��Ƶ��ʾ");	
//	_this.SetListValue(list1,"���","���(��׼)");
//	_this.SetListValue(list1,"�հױ��","�հױ��");
//
//WNDMOD ���ڷ��, DSMOD ������Դ ,WHEREBY ����, SORTBY ����,SQLTXT  SQL���, LAYCOL ������ ,LAYROW ������,PAGEROW ÿҳ�м�¼��, OSMWID OS�м��, OSFUNC OS����,OSPARAM OS�����Ĳ���,IFRAMEURL IFRAME��URL,IFSCROLLBAR �Ƿ���ʾ������,HTMLGUID,MOREURL,OPENLAYID HTML
function GetBody(db,request,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,PAGEROW ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{	
	//HTML
	return _GetHTML(db,request,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,PAGEROW ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
}
// HTML 
function _GetHTML(db,request,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,PAGEROW ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	return  _GetOS2(db,request,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,PAGEROW ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
}

//xd
function _GetOS2(db,request,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,PAGEROW ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	var parent = new x_LHTML2();
	var ds = db.QuerySQL("select * from ("+SQLTXT+" )where refid is null ");
	var str="";
	str="
	<style type=\"text/css\">*{ font-size:12px; font-family:Tahoma, Geneva, sans-serif; }
   #nav a{ display:block; width:80px; }
   #nav{ margin:1; padding:0;} 
   #nav li{ float:left; text-align:center;  }
   #nav li a{ color:#999; background:#F0F0F0; height:25px; }
   #nav li a:hover{ color:213213213; background:#999; }
   #nav li ul{ list-style-type:none; margin:0px; padding:0px; display:none; }
   #nav li ul li{ float:none; }
   #nav li ul li a{ width:80px; height:25px;color:#999; background-color:#EFEFEF;}
   #nav li ul li a:hover{ background:#999; color:#F00; }
   #ddss{ float:none; width:950px; height:20px; background:#CCC; margin:5px 0 0 0;}
   .yy{clear:both;height:10px;line-height:1px;font-size:1px;}
 </style>
	 <ul id=\"nav\">";
	 for (var r = 0; r < ds.getRowCount(); r ++) {
		 var idm="nav"+r;
		 var menunam = ds.getValueAt(r,"name");
		 str+="
		 <li onmouseover=\"show('"+idm+"');\" onmouseout=\"hide('"+idm+"')\" >
		 <a href=\"#\">"+menunam+"</a>  
		 <ul id='"+idm+"'>";  
		var ds2=db.QuerySQL("select * from ("+SQLTXT+")where refid = "+ds.getValueAt(r,"id"));
		 for(var j=0;j<ds2.getRowCount();j++){   
			 str+="
			 <li><a href=\"#\">"+ds2.getValueAt(j,"name")+"</a></li>";        
		 }
		 
		str+=" </ul>   </li>";
		 
	 }
	 str+="
	 </ul> 
	 <script type=\"text/javascript\"> 
	 function show(id){document.getElementById(id).style.display='block';}  
	 function hide(id){ document.getElementById(id).style.display='none';}
	 </script>
	 ";
	 return str;
}

//select 1 id,'��ҵ' name,'#' url, null refid from dual 
//union all
//select 1 id,'��ѯ' name,'#' url, null refid from dual 
//union all
//select 1 id,'����' name,'#' url, null refid from dual 
//union all
//select 1 id,'�ĵ�' name,'#' url, null refid from dual 
//union all
//select 1 id,'�Ӳ˵�1' name,'#' url,1  refid from dual 
//union all
//select 1 id,'�Ӳ˵�1' name,'#' url,2  refid from dual 
//union all
//select 1 id,'�Ӳ˵�1' name,'#' url,3 refid from dual 
//union all
//select 1 id,'�Ӳ˵�1' name,'#' url, 4 refid from dual 


}