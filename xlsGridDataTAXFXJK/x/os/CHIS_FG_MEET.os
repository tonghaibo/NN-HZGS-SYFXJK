function x_CHIS_FG_MEET(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var ret = "";
var pub = new JavaPackage ( "com.xlsgrid.net.pub" );
var EAScript= new JavaPackage ( "com.xlsgrid.net.pub.EAScript");
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb");
var layoutpack = new JavaPackage ( "com.xlsgrid.net.layout");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd");	
var langpack = new JavaPackage ( "java.lang");


//
// 
//
function GetBody(){
var html="
<!--这两个css 是必须的-->
    <link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/css/appframe-icons.css\" />
    <link href=\"xlsgrid/images/flash/css/appframe-cate.css\" rel=\"stylesheet\" type=\"text/css\" />
    <link href=\"xlsgrid/images/flash/css/appframe-ss.css\" rel=\"stylesheet\" type=\"text/css\" />
    <!--这三个js 是http下载的jquery211.min.js不能去掉-->
    <script type=\"text/javascript\" charset=\"utf-8\" src=\"xlsgrid/images/flash/js/fastclick.min.js\"></script>   
	<script src=\"xlsgrid/images/flash/js/angular.min.js\"></script>
	<script src=\"xlsgrid/images/flash/js/jquery211.min.js\"></script> 
	<!--这个appframework.ui.js必须放在前面-->
	<script type=\"text/javascript\" charset=\"utf-8\" src=\"xlsgrid/images/flash/js/appframework.ui.js\"></script>	
<!--公用js-->
<link type=\"text/css\" href=\"xlsgrid/images/flash/css/showflgapp_style.css\" rel=\"stylesheet\"/>
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/showflgapp_jquery1.7.1.min.js\"></script>
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery.event.drag-1.5.min.js\"></script>
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery.touchSlider.js\"></script>
<link type=\"text/css\" href=\"xlsgrid/images/flash/css/showflgapp_menu.css\" rel=\"stylesheet\" />
<script type=text/javascript>
function clicul(id){
	var li=document.getElementById(id);
	if(li.style.display=='none' || li.style.display=='' ){
		li.style.display='block';
	}
	else{
	 	li.style.display='none';
	}

}
</script>




	<!--<link type=\"text/css\" href=\"sytx/js/chis/css/menu.css\" rel=\"stylesheet\" />-->
	<link type=\"text/css\" href=\"xlsgrid/images/flash/css/showflgapp_menu.css\" rel=\"stylesheet\" />
         <ul class=\"mainmenu\"  onclick=\"clicul('ul1');\" >
				<li align=\"left\">
					<a href=\"#\" class=\"asa\" style=\"text-decoration:none;\"><em></em><p class=\"\"><span>心血管</span><span class=\"spans2\" style=\"margin-top:10px;\">15</span><i class=\"\">心血管专家</i></p><b></b></a>
				</li>
			</ul>
			<ul class=\"uls\" id=\"ul1\" style=\"display:block;\">
				<li class=\"lis2\" id=\"\" >
					<a href=\"#\" class=\"asa2\" >01 李伟<span class=\"spans2\">5</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">02 黄医生<span class=\"spans2\">15</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">03 张主任<span class=\"spans2\">9</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">04 李欣<span class=\"spans2\">20</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">05 吴桐<span class=\"spans2\">15</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">06 张燕<span class=\"spans2\">6</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">07 李军<span class=\"spans2\">1</span></a>
				</li>
			</ul>

			<ul class=\"mainmenu\"  onclick=\"clicul('ul2');\" >
				<li align=\"left\">
					<a href=\"#\" class=\"asa\" style=\"text-decoration:none;\"><em></em><p class=\"\"><span>神经内科</span><span class=\"spans2\" style=\"margin-top:10px;\">15</span><i class=\"\">神经内科专家</i></p><b></b></a>
				</li>
			</ul>
			
			
			<ul class=\"uls\" id=\"ul2\" style=\"display:none;\">
			<li class=\"lis2\" id=\"\" >
					<a href=\"#\" class=\"asa2\" >01 李伟<span class=\"spans2\">5</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">02 黄医生<span class=\"spans2\">15</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">03 张主任<span class=\"spans2\">9</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">04 李欣<span class=\"spans2\">20</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">05 吴桐<span class=\"spans2\">15</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">06 张燕<span class=\"spans2\">6</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">07 李军<span class=\"spans2\">1</span></a>
				</li>
			</ul>

			
			<ul class=\"mainmenu\"  onclick=\"clicul('ul3');\" >
				<li align=\"left\">
					<a href=\"#\" class=\"asa\" style=\"text-decoration:none;\"><em></em><p class=\"\"><span>骨科</span><span class=\"spans2\" style=\"margin-top:10px;\">15</span><i class=\"\">骨科专家</i></p><b></b></a>
				</li>
			</ul>

			
			
			<ul class=\"uls\" id=\"ul3\" style=\"display:none;\">
			<li class=\"lis2\" id=\"\" >
					<a href=\"#\" class=\"asa2\" >01 李伟<span class=\"spans2\">5</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">02 黄医生<span class=\"spans2\">15</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">03 张主任<span class=\"spans2\">9</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">04 李欣<span class=\"spans2\">20</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">05 吴桐<span class=\"spans2\">15</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">06 张燕<span class=\"spans2\">6</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">07 李军<span class=\"spans2\">1</span></a>
				</li>
			</ul>
						<ul class=\"mainmenu\"  onclick=\"clicul('ul4');\" >
				<li align=\"left\">
					<a href=\"#\" class=\"asa\" style=\"text-decoration:none;\"><em></em><p class=\"\"><span>神经外科</span><span class=\"spans2\" style=\"margin-top:10px;\">15</span><i class=\"\">神经外科专家</i></p><b></b></a>
				</li>
			</ul>
			
			<ul class=\"uls\" id=\"ul4\" style=\"display:none;\">
			<li class=\"lis2\" id=\"\" >
					<a href=\"#\" class=\"asa2\" >01 李伟<span class=\"spans2\">5</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">02 黄医生<span class=\"spans2\">15</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">03 张主任<span class=\"spans2\">9</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">04 李欣<span class=\"spans2\">20</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">05 吴桐<span class=\"spans2\">15</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">06 张燕<span class=\"spans2\">6</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">07 李军<span class=\"spans2\">1</span></a>
				</li>
			</ul>
";
return html;

}
//获取滚动图片
function genSTR(str){

	var sql="";
	var ds="";
	var db=null;
	db = new pubpack.EADatabase();
	var layid="";
	try{
		sql="
			SELECT B.* FROM LAYOBJ A ,LAYOBJDTL B  
			WHERE A.GUID=B.FORMGUID 
			AND A.ID ='CHIS_FGos' AND A.CLS='CHIS'and B.id ='"+str+"'
		";
		ds=db.QuerySQL(sql);
		if(ds.getRowCount()==1){
			layid=ds.getStringAt(0,"VAL");
			return layid; 
		}
	}
	catch(e){ throw new Exception(e);}
	if(db!=null){db.Close();}
}

function getlayout(request,layoutid){
	var db = null;
	var msg= "";
	var objid= pubpack.EAFunc.NVL( request.getParameter("objid"),"") ;
	var skin= pubpack.EAFunc.NVL( request.getParameter("skin"),"") ;
	var hashead = pubpack.EAFunc.NVL( request.getParameter("hashead"),"y") ;
	var deforg =  pubpack.EAFunc.NVL( request.getParameter("thisorgid"),webpack.EAWebDeforg.GetDeforg(request)) ;
	var browsetype = pubpack.EAFunc.getBroswerType( request );
	var sb=new langpack.StringBuffer();
	try{	
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var parent = new x_L();
		parent.GetLayoutHTML(db,request,sb,deforg,layoutid,0,"","");
	}
		catch ( ee ) {
			db.Rollback();
			sb.append(ee.toString());
			//throw new pubpack.EAException ( ee.toString() );
		}
		finally {
			if (db!=null) db.Close();
		}

	return sb.toString();
}

}