function x_showflg_wap(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" );
var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var langpack = new JavaPackage ( "java.lang" );
var servletpack = new JavaPackage ( "com.xlsgrid.net.servlet");
//================================================================// 
// 函数：GetBody
// 说明：实现类似show.sp的功能
// 参数：MWID（中间件编号） VAL(参数列表 guid=131241&bilid=12131&)
// 返回：
// 样例：
// 作者：
// 创建日期：01/28/15 17:58:16
// 修改日志：
//================================================================// 
function Toolbar(){
	var html = "";
	var sb = new StringBuffer();
	sb.append("<div class=\"top_bar\">");
	sb.append("<ul id=\"top_menu\" class=\"top_menu\">");
	
//		<li><a href=\"#\"><img src=\"images/plugmenu6.png\"><label>首页</label></a></li>
//		<li><a href=\"javascript:void(0)\"><img src=\"images/plugmenu5.png\"><label>分享</label></a></li>
//		<li><a href=\"tel:13888888888\"><img src=\"images/plugmenu1.png\"><label>拨号</label></a></li>
//		<li><a href=\"javascript:void(0)\"><img src=\"images/plugmenu8.png\"><label>短信</label></a></li>  
	sb.append("</ul>");
	sb.append("</div>");
	return sb.toString() ;
} 

//
// 
//
function imgscroll()
{
	var sql = SQLTXT;
	var db = new pubpack.EADatabase();
	var ds = db.QuerySQL(sql);
	var sb = new StringBuffer();
	var images = "<style type='text/css' rel='stylesheet'>";
	for (var r=0;r<ds.getRowCount();r++){
		var img=ds.getStringAt(r,"icon");
		if(r == 0) images += ".main_image li .img_1{background:url('"+img+"') }";//center top no-repeat
		if(r == 1) images += ".main_image li .img_2{background:url('"+img+"') }";
		if(r == 2) images += ".main_image li .img_3{background:url('"+img+"') }";
		if(r == 3) images += ".main_image li .img_4{background:url('"+img+"') }";
		if(r == 4) images += ".main_image li .img_5{background:url('"+img+"') }";
		if(r == 5) break;
	}
	images+="</style>";
	
	sb.append(images);
	sb.append("		
		<script type=\"text/javascript\">
$(document).ready(function(){
	
	$(\".main_visual\").hover(function(){
		$(\"#btn_prev,#btn_next\").fadeIn()
	},function(){
		$(\"#btn_prev,#btn_next\").fadeOut()
	});
	
	$dragBln = false;
	
	$(\".main_image\").touchSlider({
		flexible : true,
		speed : 200,
		btn_prev : $(\"#btn_prev\"),
		btn_next : $(\"#btn_next\"),
		paging : $(\".flicking_con a\"),
		counter : function (e){
			$(\".flicking_con a\").removeClass(\"on\").eq(e.current-1).addClass(\"on\");
		}
	});
	
	$(\".main_image\").bind(\"mousedown\", function() {
		$dragBln = false;
	});
	
	$(\".main_image\").bind(\"dragstart\", function() {
		$dragBln = true;
	});
	
	$(\".main_image a\").click(function(){
		if($dragBln) {
			return false;
		}
	});
	
	timer = setInterval(function(){
		$(\"#btn_next\").click();
	}, 5000);
	
	$(\".main_visual\").hover(function(){
		clearInterval(timer);
	},function(){
		timer = setInterval(function(){
			$(\"#btn_next\").click();
		},5000);
	});
	
	$(\".main_image\").bind(\"touchstart\",function(){
		clearInterval(timer);
	}).bind(\"touchend\", function(){
		timer = setInterval(function(){
			$(\"#btn_next\").click();
		}, 5000);
	});
	
});
</script>
<div class=\"main_visual\">
			<div class=\"flicking_con\">
				<a href=\"#\"></a>
				<a href=\"#\"></a>
				<a href=\"#\"></a>
				<a href=\"#\"></a>
				<a href=\"#\"></a>
			</div>
			<div class=\"main_image\">
				<ul>
					<li><span class=\"img_1\"></span></li>
					<li><span class=\"img_2\"></span></li>
					<li><span class=\"img_3\"></span></li>
					<li><span class=\"img_4\"></span></li>
					<li><span class=\"img_5\"></span></li>
				</ul>
				<a href=\"javascript:;\" id=\"btn_prev\"></a>
				<a href=\"javascript:;\" id=\"btn_next\"></a>
			</div>
		</div>");

	return sb.toString();
	
}




}