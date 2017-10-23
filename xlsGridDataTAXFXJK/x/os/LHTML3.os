function x_LHTML3(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");

var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb");
var layoutpack = new JavaPackage ( "com.xlsgrid.net.layout");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd");

var langpack = new JavaPackage ( "java.lang");

//WNDMOD 的类型（不断扩展中）
//	_this.SetListValue(list1,"HTML","HTML");
//	_this.SetListValue(list1,"OS","OS脚本");
//	_this.SetListValue(list1,"MW","中间件界面");	
//	_this.SetListValue(list1,"FRAME","内部FRAME");
//	_this.SetListValue(list1,"FRAMEGROUP","分页FRAME组");	
//	_this.SetListValue(list1,"SCROLLIMAGE","滚动图片");
//	_this.SetListValue(list1,"TOOLBAR","系统默认工具栏");		
//	_this.SetListValue(list1,"MENU","菜单栏");	
//	_this.SetListValue(list1,"FLASH","视频演示");	
//	_this.SetListValue(list1,"表格","表格(标准)");
//	_this.SetListValue(list1,"空白表格","空白表格");
//	_this.SetListValue(list1,"MENU","菜单栏");
//	_this.SetListValue(list1,"TOPMENU","顶层分页菜单");
//	_this.SetListValue(list1,"WEIXINBO","微信微博");
//	_this.SetListValue(list1,"SCROLLIMG","左右滚动图片");
//	_this.SetListValue(list1,"LOGINSEARCH","登录和搜索");
//
//WNDMOD 窗口风格, DSMOD 数据来源 ,WHEREBY 条件, SORTBY 排序,SQLTXT  SQL语句, LAYCOL 分列数 ,LAYROW 分行数,PAGEROW 每页行记录数, OSMWID OS中间件, OSFUNC OS函数,OSPARAM OS函数的参数,IFRAMEURL IFRAME的URL,IFSCROLLBAR 是否显示滚动条,HTMLGUID,MOREURL,OPENLAYID HTML
function GetBody(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	if(WNDMOD=="WEIXINBO") return _GetWEIXINBO(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	
	if(WNDMOD=="SCROLLIMG") return _GetSCROLLIMG(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	
//	if(WNDMOD=="SX_SCROLLIMG") return _GetSX_SCROLLIMG(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	
	if(WNDMOD=="W8ITEM") return _GetW8ITEM(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
	
	return "";
}
function test(){
	return "xxx";
}
// 微信微博
function _GetWEIXINBO(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	return  db.getBlob2String("select bdata from formblob where guid='"+HTMLGUID+"' for update","bdata");
}
// 左右滚动图片
function _GetSCROLLIMG(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	return  gethtml(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID);
}
// W8风格商品显示
function _GetW8ITEM(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	
	var html = "";
	var sql = "select * from LSYSURL where icon is not null";
	var db = null;
	var width=120;
	var height=120;

	db = new pubpack.EADatabase();
	
	//表格标题
	var title = "商品";
	
	var itemds = db.QuerySQL(sql);
	
	var count = itemds.getRowCount();
	
	if(LAYROW=="" ) LAYROW=2;
	var trows = LAYROW;
	
	if(LAYCOL=="") LAYCOL =db.GetSQL("select ceil("+count+" / "+trows+") cols from dual");
	var tcols = LAYCOL;
	
	var tablewidth = 60+60*2+width*tcols;

	var tableheight = 60+height*trows;
	
//	html="<div style='overflow-x: auto; overflow-y: auto;width:500px; height=300px;'>";
	
	html += "<table id=\"XMIDWARE_MENU_TABLE\" class=\"XMIDWARE_MENU_TABLE\" border=\"0\" cellpadding=0 cellspacing=0 width=\""+tablewidth+"\" height=\""+tableheight+"\">\n";
	
	html += "<TR height=\"60\">\n
				<td width=\"60\" height=\"60\"><img border=0 src=\"http://xmidware.com/null.jpg\" width=\"60\" height=\"60\"></td>
				<td  colspan=\""+tcols+"\" align=\"left\"><font size=\"5\" color=\"#000000\"><div class=\"XMIDWARE_MENU_SHEETNAME\" >&nbsp;"+title+" ></div></font></td>
				<td width=\"60\" height=\"60\"><img border=\"0\" src=\"http://xmidware.com/null.jpg\" width=\"60\" height=\"60\"/></td>
			</TR>\n";
	
	
	var matds = getMatrix(trows,tcols);
	
	for (var r=0;r<trows;r++) {
		html += "<TR height=\""+height+"\">\n<td width=\"60\" height=\""+height+"\"><img border=0 src=\"http://xmidware.com/null.jpg\" width=\"60\" height=\""+height+"\"></td>";
		for (var c=0;c<tcols;c++) {
			var idx = 1 * matds.getStringAt(r,c);
			if (idx < count) {
				var id= itemds.getStringAt(idx,"id");
				var icon= itemds.getStringAt(idx,"ICON");
				var title = itemds.getStringAt(idx,"REFID");
				
				var note= itemds.getStringAt(idx,"name");
			
				var price ="";
				var hrefurl =itemds.getStringAt(idx,"url");
				
				html += gethdTableCellHtml(width,height,icon,"",price,hrefurl,"");//宽
				html += "\n";
				
			}
		}
		html += "</TR>\n";

	}
	html += "</TABLE>\n\n";
		
	return html;
}

//按列排列数组
function getMatrix(rows,cols)
{
	if (rows == 0) rows = 1;
	if (cols == 0) cols = 1;
	
	var ds = new pubpack.EAXmlDS();
	for (var c=0;c<cols;c++) {
		ds.addColumn(c,"COL"+c);
	}
	for (var r=0;r<rows;r++) {
		ds.AddNullRow(-1);
	}
	
	var num = 0;
	for (var c=0;c<cols;c++) { 
		for (var r=0;r<rows;r++) {
			ds.setValueAt(r,c,num++);
		}
	}
	
	return ds;
}

//取得活动商品表格中一个显示单元格的TD内容
function gethdTableCellHtml(width,height,icon,title,price,hrefurl,note)
{
	var html = "<TD class=\"XMIDWARE_MENU_CELL_TD\" height=\""+height+"\" width=\""+width+"\" >
			<a href=\""+hrefurl+"\" target=\"\" style=\"TEXT-DECORATION: none;\"> 
				<div class=\"XMIDWARE_MENU_CELL_TD_PDIV\" height=\"100%\" width=\"100%\" style=\"position:relative;\">
					<img border=\"0\" src=\""+icon+"\"  height=\""+(height-20)+"\" width=\""+(width-20)+"\"/>
					<img border=\"0\" src=\"http://www.xmidware.com/null.jpg\"  height=\""+(height-10)+"\" width=\"10\"/><BR>
					<img border=\"0\" src=\"http://www.xmidware.com/null.jpg\"  height=\"10\" width=\""+(width-10)+"\"/>	
					<div class=\"XMIDWARE_MENU_CELL_TD_BKDIV\" style=\"width: "+(width-20)+"px; height: "+(0.3*height-10)+"px; filter:alpha(Opacity=50);-moz-opacity:0.5;opacity: 0.5;z-index:100; position:absolute; left:0px; top:"+(0.7*height)+"px; background-color:#000000\"  ></div>
					<div class=\"XMIDWARE_MENU_CELL_TD_TCITLEDIV\" align=\"left\" valign=\"top\" style=\" width: "+(width-10)+"px; height: "+(0.3*height)+"px; float:left;z-index:100; position:absolute; left:0px; top:"+(0.7*height)+"px;padding:5px 5px 5px 5px; \"  >
						<font color=\"#ffffff\" size=4>"+title+"</font><br>
						<font color=\"#ffffff\" size=4>"+price+"</font><br>
						<font color=\"red\"  style=\"float:right; position:absolute; right:20px; \" size=5>"+note+"</font>
					</div> 
				</div>
			</a>
		   </TD>";
	return html;
}

// 上下滚动图片
//function _GetSX_SCROLLIMG(db,request,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,PAGEROW ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
//{
//	return  getsxgdhtml();
//}

function gethtml(db,request,deforg,WNDMOD,DSMOD,WHEREBY,SORTBY,SQLTXT ,LAYCOL ,LAYROW,MOREURL ,OSMWID,OSFUNC,OSPARAM,IFRAMEURL,IFSCROLLBAR,HTMLGUID,MOREURL,OPENLAYID)
{
	return "";
	var html="<table width='100%'><tr><td><div class=\"imgdiv\"><div class=\"imageRotation\" id=\"imageRotation\">"+
		    "<div class=\"imageBox\">";
	html=html;  
	
	if(LAYCOL =="")LAYCOL ="1";
	var sql = "select * from ( select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' and icon is not null "  ;
	if(WHEREBY!="" ) sql+= " AND " +WHEREBY;
	if(SORTBY!="" ) sql+= " "+SORTBY;
	else sql+= " order by crtdat desc ";
	if(LAYCOL !=""&& LAYROW!="" ) sql+=") where  rownum<"+LAYCOL+"*"+LAYROW;
	
	  
	var xml=db.QuerySQL(sql);
	var spn="";
	var cnt=xml.getRowCount();
	if(cnt>5) cnt=5;
	for(var i=0;i<cnt;i++){
		html+= "<a href='"+xml.getStringAt(i,"url")+"&layhdrguid="+xml.getStringAt(i,"GUID")+"' ><img src="+xml.getStringAt(i,"icon")+"></a>";
		if(i==0)
			spn+="<span class=\"active\" rel=\""+(i+1)+"\"><img src="+xml.getStringAt(i,"icon2")+"></span>";
		else
			spn+="<span  rel=\""+(i+1)+"\"><img src="+xml.getStringAt(i,"icon2")+"></span>";
	}
	html+="</div>"+ "<div class=\"icoBox\">"+spn+ "</div>"+"</div></div></tr></td></table>";
	
//	html+="<script type=\"text/javascript\" src=\"http://www.itxueyuan.org/uploads/javascript/jquery.js\"></script>";
	
	var css="<style type=\"text/css\">"+
		"	.imgdiv{"+
		"            width:100%;"+
		"            height:350px;"+
//		"            border:1px solid #BBBBBB;"+
		"            position:relative;"+
		"		clear:both;"+
		"        }"+
		"        .imageRotation{"+
		"            overflow:hidden;  /*--超出容器的所有元素都不可见--*/"+
//		"            position:relative;"+
		"        }"+
		"        .imageBox{"+
		"            position: relative;"+
		"            overflow:hidden;"+
		"            float:left;"+


		"        }"+
		"        .imageBox img {"+
		"            display:block;"+
		"            float:left;"+
		"            border:none;"+
		"        }"+
		"        .icoBox{"+
		"            position:absolute;  /*--固定定位--*/"+
		"            top:5px;"+
//		"            width:70px;"+
		"            text-align:center;"+
		"           line-height:40px;"+
		"            float:left;"+

		"        }"+
		"        .icoBox span{"+
		"            display:block;"+
		"            height:40px;"+
		"            width:60px;"+

		"            margin-top:4px;"+
		"            margin-left:0px;"+
		"            margin-right:0px;"+
		"            cursor:pointer;"+
		"        }"+
		"        .icoBox span.active {"+
		"            background-position:0px -12px;"+
		"            cursor:default;"+
		"        }"+
		"    </style>";
	var jvaspt="<script type=\"text/javascript\">"+
//			"	window.onresize=function(){"+
//			"	        var dvwid=$(\".imgdiv\").width();"+
//			"	        var dvhid=$(\".imgdiv\").height();"+
//			"	        var img2w=dvwid/6;"+
//			"	        var img2h=dvhid/10;"+
//			"	        $(\".imageRotation\").width(dvwid-(img2w+10));"+
//			"	        $(\".imageRotation\").height(dvhid);"+
//			"	        $(\".icoBox\").css({'left':(dvwid-(img2w-10))});"+
//			"	        $(\".imageBox img\").width(dvwid-(img2w+10));"+
//			"	        $(\".imageBox img\").height(dvhid);"+
//			"	    }"+
			
			
			"    $(document).ready(function() {"+
			"       $(\".imageRotation\").each(function(){"+
			
			"		var dvwid=$('.imgdiv').width();"+
			"                var dvhid=$('.imgdiv').height();"+
			
			"		var img2w=dvwid/6;"+
			"                var img2h=dvhid/10;"+
			
			"                $('.imageRotation').width(dvwid);"+
			"                $('.imageRotation').height(dvhid);"+
			"                $('.icoBox').css({'right':0});"+
			"                $('.imageBox img').width(dvwid);"+
			"                $('.imageBox img').height(dvhid);"+
			
			"                $('.icoBox span').height(dvhid/6);"+
			"                $('.icoBox span').width(dvwid/10);"+
			"                $('.icoBox span img').height(dvhid/6);"+
			"                $('.icoBox span img').width(dvwid/10);"+
			"           var imageRotation = this, "+
			"                    imageBox = $(imageRotation).children(\".imageBox\")[0],  "+
			"                   icoBox = $(imageRotation).children(\".icoBox\")[0],  "+
			"                    icoArr = $(icoBox).children(), "+
			"                    imageWidth =  $(\".imageBox img\").width(),  "+
			"                    imageNum = $(imageBox).children().size(),  "+
			"                    imageReelWidth = imageWidth*imageNum,  "+
			"                    activeID = parseInt($($(icoBox).children(\".active\")[0]).attr(\"rel\")), "+
			"                    nextID = 0, "+
			"                    setIntervalID,  "+
			"                    intervalTime = 4000,  "+
			"                    speed =500;  "+
			

			"            $(imageBox).css({'width' : imageReelWidth + \"px\"});"+
			
	
			"            var rotate=function(clickID){"+
			"                if(clickID){ nextID = clickID; }"+
			"                else{ nextID=activeID<=3 ? activeID+1 : 1; }"+
			
			"                $(icoArr[activeID-1]).removeClass(\"active\");"+
			"                $(icoArr[nextID-1]).addClass(\"active\");"+
			"                $(imageBox).animate({left:\"-\"+(nextID-1)* $(\".imageBox img\").width()+\"px\"} , speed);"+
			"                $(icoArr[nextID-1]).addClass(\"active\").css({'border':'3px solid red'});"+
			"                $(icoArr[activeID-1]).addClass(\"active\").css({'border':'0px solid red'});"+
			"                activeID = nextID;"+
			"            };"+
			"            setIntervalID=setInterval(rotate,intervalTime);"+
			
			"            $(imageBox).hover("+
			"                    function(){ clearInterval(setIntervalID); },"+
			"                    function(){ setIntervalID=setInterval(rotate,intervalTime); }"+
			"            );"+
			
			"            $(icoArr).click(function(){"+
			"                clearInterval(setIntervalID);"+
			"                var clickID = parseInt($(this).attr(\"rel\"));"+
			"                rotate(clickID);"+
			"                setIntervalID=setInterval(rotate,intervalTime);"+
			"            });"+
			 "       });"+
			"    });"+
			"</script>";
	html+=jvaspt;
//	throw new Exception(html);
	return css+html;
}
//滚动
function getsxgdhtml(db,DSMOD){
	
	var onload="<script type=\"text/javascript\">window.onload=function(){$(\".imageBox img\").width($(\".imageRotation\").width());$(\".imageBox img\").height($(\".imageRotation\").height());}</script>";
		

	var html="<div class=\"imageRotation\" id=\"imageRotation\">"+
		    "<div class=\"imageBox\">";
	html=ond+html;    
	var xml=db.QuerySQL("select icon,icon2,url from LSYSURL where REFID='"+DSMOD+"'");
	var spn="";
	for(var i=0;i<xml.getRowCount();i++){
		html+= "<img src="+xml.getStringAt(i,"icon")+">";
		if(i==0)
			spn+="<span class=\"active\" rel=\""+(i+1)+"\"><img src=\"http://dev.sss-shanghai.org/aca/ROOT_HIS/"+xml.getStringAt(i,"icon")+"\"/></span>";
		else
			spn+="<span  rel=\""+(i+1)+"\"><img src=\"http://dev.sss-shanghai.org/aca/ROOT_HIS/"+xml.getStringAt(i,"icon")+"\"/></span>";
	}
	html+="</div>"+ "<div class=\"icoBox\">"+spn+ "</div>"+"</div>";
	
	var jvaspt="<script type=\"text/javascript\">"+
			"    $(document).ready(function() {"+
			"       $(\".imageRotation\").each(function(){"+
			"           var imageRotation = this, "+
			"                    imageBox = $(imageRotation).children(\".imageBox\")[0],  "+
			"                   icoBox = $(imageRotation).children(\".icoBox\")[0],  "+
			"                    icoArr = $(icoBox).children(), "+
			"                    imageWidth = $(imageBox).width(),  "+
			"                    imageNum = $(imageBox).children().size(),  "+
			"                    imageReelWidth = imageWidth*imageNum,  "+
			"                    activeID = parseInt($($(icoBox).children(\".active\")[0]).attr(\"rel\")), "+
			"                    nextID = 0, "+
			"                    setIntervalID,  "+
			"                    intervalTime = 4000,  "+
			"                    speed =500;  "+
			

			"            $(imageBox).css({'width' : imageReelWidth + \"px\"});"+
			
	
			"            var rotate=function(clickID){"+
			"                if(clickID){ nextID = clickID; }"+
			"                else{ nextID=activeID<=3 ? activeID+1 : 1; }"+
			
			"                $(icoArr[activeID-1]).removeClass(\"active\");"+
			"                $(icoArr[nextID-1]).addClass(\"active\");"+
			"                $(imageBox).animate({left:\"-\"+(nextID-1)*imageWidth+\"px\"} , speed);"+
			"                $(icoArr[nextID-1]).addClass(\"active\").css({'border':'3px solid #eee'});"+
			"                $(icoArr[activeID-1]).addClass(\"active\").css({'border':'0px solid #eee'});"+
			"                activeID = nextID;"+
			"            };"+
			"            setIntervalID=setInterval(rotate,intervalTime);"+
			
			"            $(imageBox).hover("+
			"                    function(){ clearInterval(setIntervalID); },"+
			"                    function(){ setIntervalID=setInterval(rotate,intervalTime); }"+
			"            );"+
			
			"            $(icoArr).click(function(){"+
			"                clearInterval(setIntervalID);"+
			"                var clickID = parseInt($(this).attr(\"rel\"));"+
			"                rotate(clickID);"+
			"                setIntervalID=setInterval(rotate,intervalTime);"+
			"            });"+
			 "       });"+
			"    });"+
			"</script>";
   return html+jvaspt;
}



}