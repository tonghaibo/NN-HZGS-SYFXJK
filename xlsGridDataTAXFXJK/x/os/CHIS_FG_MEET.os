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
<!--������css �Ǳ����-->
    <link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/css/appframe-icons.css\" />
    <link href=\"xlsgrid/images/flash/css/appframe-cate.css\" rel=\"stylesheet\" type=\"text/css\" />
    <link href=\"xlsgrid/images/flash/css/appframe-ss.css\" rel=\"stylesheet\" type=\"text/css\" />
    <!--������js ��http���ص�jquery211.min.js����ȥ��-->
    <script type=\"text/javascript\" charset=\"utf-8\" src=\"xlsgrid/images/flash/js/fastclick.min.js\"></script>   
	<script src=\"xlsgrid/images/flash/js/angular.min.js\"></script>
	<script src=\"xlsgrid/images/flash/js/jquery211.min.js\"></script> 
	<!--���appframework.ui.js�������ǰ��-->
	<script type=\"text/javascript\" charset=\"utf-8\" src=\"xlsgrid/images/flash/js/appframework.ui.js\"></script>	
<!--����js-->
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
					<a href=\"#\" class=\"asa\" style=\"text-decoration:none;\"><em></em><p class=\"\"><span>��Ѫ��</span><span class=\"spans2\" style=\"margin-top:10px;\">15</span><i class=\"\">��Ѫ��ר��</i></p><b></b></a>
				</li>
			</ul>
			<ul class=\"uls\" id=\"ul1\" style=\"display:block;\">
				<li class=\"lis2\" id=\"\" >
					<a href=\"#\" class=\"asa2\" >01 ��ΰ<span class=\"spans2\">5</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">02 ��ҽ��<span class=\"spans2\">15</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">03 ������<span class=\"spans2\">9</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">04 ����<span class=\"spans2\">20</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">05 ��ͩ<span class=\"spans2\">15</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">06 ����<span class=\"spans2\">6</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">07 ���<span class=\"spans2\">1</span></a>
				</li>
			</ul>

			<ul class=\"mainmenu\"  onclick=\"clicul('ul2');\" >
				<li align=\"left\">
					<a href=\"#\" class=\"asa\" style=\"text-decoration:none;\"><em></em><p class=\"\"><span>���ڿ�</span><span class=\"spans2\" style=\"margin-top:10px;\">15</span><i class=\"\">���ڿ�ר��</i></p><b></b></a>
				</li>
			</ul>
			
			
			<ul class=\"uls\" id=\"ul2\" style=\"display:none;\">
			<li class=\"lis2\" id=\"\" >
					<a href=\"#\" class=\"asa2\" >01 ��ΰ<span class=\"spans2\">5</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">02 ��ҽ��<span class=\"spans2\">15</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">03 ������<span class=\"spans2\">9</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">04 ����<span class=\"spans2\">20</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">05 ��ͩ<span class=\"spans2\">15</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">06 ����<span class=\"spans2\">6</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">07 ���<span class=\"spans2\">1</span></a>
				</li>
			</ul>

			
			<ul class=\"mainmenu\"  onclick=\"clicul('ul3');\" >
				<li align=\"left\">
					<a href=\"#\" class=\"asa\" style=\"text-decoration:none;\"><em></em><p class=\"\"><span>�ǿ�</span><span class=\"spans2\" style=\"margin-top:10px;\">15</span><i class=\"\">�ǿ�ר��</i></p><b></b></a>
				</li>
			</ul>

			
			
			<ul class=\"uls\" id=\"ul3\" style=\"display:none;\">
			<li class=\"lis2\" id=\"\" >
					<a href=\"#\" class=\"asa2\" >01 ��ΰ<span class=\"spans2\">5</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">02 ��ҽ��<span class=\"spans2\">15</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">03 ������<span class=\"spans2\">9</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">04 ����<span class=\"spans2\">20</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">05 ��ͩ<span class=\"spans2\">15</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">06 ����<span class=\"spans2\">6</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">07 ���<span class=\"spans2\">1</span></a>
				</li>
			</ul>
						<ul class=\"mainmenu\"  onclick=\"clicul('ul4');\" >
				<li align=\"left\">
					<a href=\"#\" class=\"asa\" style=\"text-decoration:none;\"><em></em><p class=\"\"><span>�����</span><span class=\"spans2\" style=\"margin-top:10px;\">15</span><i class=\"\">�����ר��</i></p><b></b></a>
				</li>
			</ul>
			
			<ul class=\"uls\" id=\"ul4\" style=\"display:none;\">
			<li class=\"lis2\" id=\"\" >
					<a href=\"#\" class=\"asa2\" >01 ��ΰ<span class=\"spans2\">5</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">02 ��ҽ��<span class=\"spans2\">15</span></a>
				</li>
				<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">03 ������<span class=\"spans2\">9</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">04 ����<span class=\"spans2\">20</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">05 ��ͩ<span class=\"spans2\">15</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">06 ����<span class=\"spans2\">6</span></a>
				</li>
					<li class=\"lis2\" id=\"\">
					<a href=\"#\" class=\"asa2\">07 ���<span class=\"spans2\">1</span></a>
				</li>
			</ul>
";
return html;

}
//��ȡ����ͼƬ
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
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
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