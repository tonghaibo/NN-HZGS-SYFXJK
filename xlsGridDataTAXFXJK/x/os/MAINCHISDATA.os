function x_MAINCHISDATA(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
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
var picstr=genSTR("MOVPIC");
var menu4str=genSTR("MENU4");
var menu2str=genSTR("MENU2");
var menu3str=genSTR("MENU3");
var menu1str=genSTR("MENU1");
var title1=genSTR("TITLE1");
var title2=genSTR("TITLE2");
var title3=genSTR("TITLE3");
var title4=genSTR("TITLE4");

var html="
<html>
<head>
    <title>����ҽԺ</title>
    <meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=0, minimal-ui\">
    <meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />
    <META HTTP-EQUIV=\"Pragma\" CONTENT=\"no-cache\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />
    <link rel=\"stylesheet\" type=\"text/css\" href=\"sytx/js/chis/css/icons.css\" />
    <link rel=\"stylesheet\" type=\"text/css\" href=\"sytx/js/chis/css/ss.css\" />
	<link href=\"sytx/js/chis/css/cate.css\" rel=\"stylesheet\" type=\"text/css\" />
     <script type=\"text/javascript\" charset=\"utf-8\" src=\"http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js\"></script>
	<script type=\"text/javascript\" charset=\"utf-8\" src=\"http://cdnjs.cloudflare.com/ajax/libs/fastclick/1.0.3/fastclick.min.js\"></script>   
	<script src=\"http://cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.20/angular.min.js\"></script>
	<script type=\"text/javascript\" charset=\"utf-8\" src=\"sytx/js/chis/js/appframework.ui.js\"></script>
	<style type=\"text/css\" >
	.copyright {
	padding: 8px;
	text-align: center;
	font-size: 14px;
	color:#B2B2B2;
	}
	</style>

<link type=\"text/css\" href=\"sytx/js/chis/css/style.css\" rel=\"stylesheet\"/>
<script type=\"text/javascript\" src=\"sytx/js/chis/js/jquery-1.7.1.min.js\"></script>
<script type=\"text/javascript\" src=\"sytx/js/chis/js/jquery.event.drag-1.5.min.js\"></script>
<script type=\"text/javascript\" src=\"sytx/js/chis/js/jquery.touchSlider.js\"></script>
<link type=\"text/css\" href=\"sytx/js/chis/css/menu.css\" rel=\"stylesheet\" />
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

</head>
<body > 
    <div class=\"view\" id=\"mainview\">
        <header>
            <h1>����ҽԺ</h1>
        </header>
        <div class=\"pages\">
        		<div class=\"panel\" data-title=\"����\" id=\"theabout\" data-footer=\"none\"  >
        		</div>
         	    <div class=\"panel\" data-title=\"��ҳ\" id=\"about1\" data-footer=\"none\"  data-selected=\"true\" >
		      ";
			  //<!--��ҳ--------->		        
			  //data-include=\"L.SP?id=CHIA_FG_KS\"
			 // html+=getlayout(request,picstr);   		
		          //html+=getlayout(request,menu1str);   
		          html+="
		     </div>		
		        <!-- �����������-->
		    <div class=\"panel\" data-title=\""+title2+"\" id=\"item12\" data-footer=\"none\">
		        ";
			  //<!--��������--------->		        
			  
			  //html+=getlayout(request,menu2str);   		
		          html+="
		    </div>
		   
		    <div class=\"panel\" data-title=\""+title3+"\" id=\"item10\" data-footer=\"none\" style=\"margin:0;padding:0;\">
		         ";
			   //<!--��ͨ--------->		        
			    //html+=getlayout(request,menu3str);   		
			    html+="
		     </div>
		     <div class=\"panel\" data-title=\"�ҵ�\" id=\"about\" data-footer=\"none\"  >
		      ";
			  //<!--�ҵ�--------->		        
			 // html+=getlayout(request,menu4str);   		
		          html+="

		     </div>	
		     <div class=\"panel\" data-title=\"��ҩ\" id=\"health01\" data-footer=\"none\"  >
			   ";
			   //<!--��ҩ--------->		            
			   // html+=getlayout(request,"MEDICATION");   		
			    html+="
		     	</div>	
			<div class=\"panel\" data-title=\"��ʳ\" id=\"health02\" data-footer=\"none\"  >
		         ";
			   //<!--��ʳ--------->		        
			    
			   // html+=getlayout(request,"DIETCHIS");   		
			    html+="
		     </div>
		     <div class=\"panel\" data-title=\"�˶�\" id=\"health03\" data-footer=\"none\"  >
		         ";
			   //<!--�˶�--------->		        
			    
			    //html+=getlayout(request,"MOTIONCHIS");   		
			    html+="
		     </div>
		     <div class=\"panel\" data-title=\"���\" id=\"health04\" data-footer=\"none\"  >
		         ";
			   //<!--���--------->		        
			    
			    //html+=getlayout(request,"MONITORCHIS");   		
			    html+="����޷���ʾ
		     </div>
		     <div class=\"panel\" data-title=\"����\" id=\"health05\" data-footer=\"none\"  >
		         ";
			   //<!--����--------->		        
			    
			    //html+=getlayout(request,"MISSIONCHIS");   		
			    html+="
		     </div>
		     <div class=\"panel\" data-title=\"ԤԼ����\" id=\"health06\" data-footer=\"none\"  >
		         ";
			   //<!--ԤԼ����--------->		        
			    
			    //html+=getlayout(request,"RESERVATIONCHIS");   		
			    html+="
		     </div>
		
			<div class=\"panel\" data-title=\"�������\" id=\"MYROOMpanel\" data-footer=\"none\"  >
		         ";
			   //<!--�������--------->		        
			    
			    //html+=getlayout(request,"MYROOM");   		
			    html+="
		     </div>
			<div class=\"panel\" data-title=\"���ڿ�\" id=\"SJNKpanel\" data-footer=\"none\" style=\"background-color:#eee;\" >
		         ";
			   //<!--���ڿ�--------->		        
			    //html+=getlayout(request,"SJNK");   		
			    html+="
		     </div>
		     	<div class=\"panel\" data-title=\"��ͼ\" id=\"MAPFINDpanel\" data-footer=\"none\"  >
		         ";
			   //<!--��ͼ--------->		        
			    
			   // html+=getlayout(request,"MAPFIND");   		
			    html+="
		     </div>
		     	<div class=\"panel\" data-title=\"ҽ��΢վ\" id=\"ABOUTDOCpanel\" data-footer=\"none\"  >
		         ";
			   //<!--ҽ��΢վ--------->		        
			    
			   // html+=getlayout(request,"ABOUTDOC");   		
			    html+="
		     </div>

			
			
		        </div><!--�����pages �Ľ���-------------------------------------------------------------------------------->	         
		         
		         
		         <!--Footer to add tabs if desired-->
		        <footer>
		            <a href=\"#about1\" class=\"icon home\" id='tab4' data-transition=\"none\">"+title1+"</a>	
		            <a href=\"#item12\" class=\"icon heart\" id='tab2' data-transition=\"up-reveal\">"+title2+"</a>
			    <a href=\"#item10\" class=\"icon pencil\" id='tab3' data-transition=\"none\">"+title3+"</a>
		            <a href=\"#about\" class=\"icon user\" id='tab4' data-transition=\"none\">"+title4+"</a>
			    

	
		        </footer>
    </div><!--�����view �Ľ���------------------------------------------------------------------------------------->

</body>

</html>	
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
			AND A.ID ='CHIS_MAINFGOS' AND A.CLS='CHIS'and B.id ='"+str+"'
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

function genmenu2(){

var menu2="
 <div class=\"panel\" data-title=\"��ҩ\" id=\"health01\" data-footer=\"none\"  >
		         ";
			   //<!--��ҩ--------->		        
			    
			    html+=getlayout(request,"MEDICATION");   		
			    html+="
		     </div>
		     <div class=\"panel\" data-title=\"��ʳ\" id=\"health02\" data-footer=\"none\"  >
		         ";
			   //<!--��ʳ--------->		        
			    
			    html+=getlayout(request,"DIETCHIS");   		
			    html+="
		     </div>
		     <div class=\"panel\" data-title=\"�˶�\" id=\"health03\" data-footer=\"none\"  >
		         ";
			   //<!--�˶�--------->		        
			    
			    html+=getlayout(request,"MOTIONCHIS");   		
			    html+="
		     </div>
		     <div class=\"panel\" data-title=\"���\" id=\"health04\" data-footer=\"none\"  >
		         ";
			   //<!--���--------->		        
			    
			    html+=getlayout(request,"MONITORCHIS");   		
			    html+="
		     </div>
		     <div class=\"panel\" data-title=\"����\" id=\"health05\" data-footer=\"none\"  >
		         ";
			   //<!--����--------->		        
			    
			    html+=getlayout(request,"MISSIONCHIS");   		
			    html+="
		     </div>
		     <div class=\"panel\" data-title=\"ԤԼ����\" id=\"health06\" data-footer=\"none\"  >
		         ";
			   //<!--ԤԼ����--------->		        
			    
			    html+=getlayout(request,"RESERVATIONCHIS");   		
			    html+="
		     </div>
		     <div class=\"panel\" data-title=\"��ҩ\" id=\"health01\" data-footer=\"none\"  data-include=\"L.sp?id=MEDICATION\"></div>
		     <div class=\"panel\" data-title=\"��ʳ\" id=\"health02\" data-footer=\"none\"  data-include=\"L.sp?id=DIETCHIS\"></div>
		     <div class=\"panel\" data-title=\"�˶�\" id=\"health03\" data-footer=\"none\" data-include=\"L.sp?id=MOTIONCHIS\" ></div>
		     <div class=\"panel\" data-title=\"���\" id=\"health04\" data-footer=\"none\"  data-include=\"L.sp?id=MONITORCHIS\"></div>
		     <div class=\"panel\" data-title=\"����\" id=\"health05\" data-footer=\"none\"  data-include=\"L.sp?id=MISSIONCHIS\"></div>
		     <div class=\"panel\" data-title=\"ԤԼ����\" id=\"health06\" data-footer=\"none\"  data-include=\"L.sp?id=RESERVATIONCHIS\"></div>
";
return menu2;
}
function genbody(){
var picstr=genSTR("MOVPIC");
var menu4str=genSTR("MENU4");
var menu2str=genSTR("MENU2");
var menu3str=genSTR("MENU3");
var menu1str=genSTR("MENU1");
var title1=genSTR("TITLE1");
var title2=genSTR("TITLE2");
var title3=genSTR("TITLE3");
var title4=genSTR("TITLE4");

var html="
<html>
<head>
    <title>����ҽԺ</title>
    <meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=0, minimal-ui\">
    <meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />
    <META HTTP-EQUIV=\"Pragma\" CONTENT=\"no-cache\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />
    <link rel=\"stylesheet\" type=\"text/css\" href=\"sytx/js/chis/css/icons.css\" />
    <link rel=\"stylesheet\" type=\"text/css\" href=\"sytx/js/chis/css/ss.css\" />
	<link href=\"sytx/js/chis/css/cate.css\" rel=\"stylesheet\" type=\"text/css\" />
     <script type=\"text/javascript\" charset=\"utf-8\" src=\"http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js\"></script>
	<script type=\"text/javascript\" charset=\"utf-8\" src=\"http://cdnjs.cloudflare.com/ajax/libs/fastclick/1.0.3/fastclick.min.js\"></script>   
	<script src=\"http://cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.20/angular.min.js\"></script>
	<script type=\"text/javascript\" charset=\"utf-8\" src=\"sytx/js/chis/js/appframework.ui.js\"></script>
	<style type=\"text/css\" >
	.copyright {
	padding: 8px;
	text-align: center;
	font-size: 14px;
	color:#B2B2B2;
	}
	</style>

<link type=\"text/css\" href=\"sytx/js/chis/css/style.css\" rel=\"stylesheet\"/>
<script type=\"text/javascript\" src=\"sytx/js/chis/js/jquery-1.7.1.min.js\"></script>
<script type=\"text/javascript\" src=\"sytx/js/chis/js/jquery.event.drag-1.5.min.js\"></script>
<script type=\"text/javascript\" src=\"sytx/js/chis/js/jquery.touchSlider.js\"></script>
<link type=\"text/css\" href=\"sytx/js/chis/css/menu.css\" rel=\"stylesheet\" />
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

</head>
<body > 
    <div class=\"view\" id=\"mainview\">
        <header>
            <h1>����ҽԺ</h1>
        </header>
        <div class=\"pages\">
         	<div class=\"panel\" data-title=\""+title1+"\" id=\"item13\" data-selected=\"true\" style=\"margin:0;padding:0;\" data-include=\"L.sp?id="+menu1str+"\">
		       <!--����ͼƬ--------->
		  </div>
		  <div class=\"panel\" data-title=\""+title4+"\" id=\"item11\" data-footer=\"none\" data-include=\"L.sp?id="+menu4str+"\">		         
			  <!--�ҵ�--------->		        
	           </div>
		        <!-- �����������-->
		    <div class=\"panel\" data-title=\""+title2+"\" id=\"item12\" data-footer=\"none\" data-include=\"L.sp?id="+menu2str+"\">
			  <!--��������--------->		        
		    </div>
		    <div class=\"panel\" data-title=\""+title3+"\" id=\"item10\" data-footer=\"none\" style=\"margin:0;padding:0;\" data-include=\"L.sp?id="+menu3str+"\">
			   <!--��ͨ--------->		       
		     </div>
		     <div class=\"panel\" data-title=\"��ҩ\" id=\"health01\" data-footer=\"none\"  data-include=\"L.sp?id=MEDICATION\"></div>
		     <div class=\"panel\" data-title=\"��ʳ\" id=\"health02\" data-footer=\"none\"  data-include=\"L.sp?id=DIETCHIS\"></div>
		     <div class=\"panel\" data-title=\"�˶�\" id=\"health03\" data-footer=\"none\" data-include=\"L.sp?id=MOTIONCHIS\" ></div>
		     <div class=\"panel\" data-title=\"���\" id=\"health04\" data-footer=\"none\"  data-include=\"L.sp?id=MONITORCHIS\"></div>
		     <div class=\"panel\" data-title=\"����\" id=\"health05\" data-footer=\"none\"  data-include=\"L.sp?id=MISSIONCHIS\"></div>
		     <div class=\"panel\" data-title=\"ԤԼ����\" id=\"health06\" data-footer=\"none\"  data-include=\"L.sp?id=RESERVATIONCHIS\"></div>
					        

		        </div><!--�����pages �Ľ���-------------------------------------------------------------------------------->
		         <!--Footer to add tabs if desired-->
		        <footer>
		            <a href=\"#item13\" class=\"icon home\" id='tab1' data-transition=\"slide\">"+title1+"</a>
		            <a href=\"#item12\" class=\"icon heart\" id='tab2' data-transition=\"up-reveal\">"+title2+"</a>
			    <a href=\"#item10\" class=\"icon pencil\" id='tab3' data-transition=\"none\">"+title3+"</a>
			    <a href=\"#item11\" class=\"icon user\" id='tab4' data-transition=\"none\">"+title4+"</a>
		        </footer>
    </div><!--�����view �Ľ���------------------------------------------------------------------------------------->
</body>

</html>	
";
return html;
}

function genANgel(){
var picstr=genSTR("MOVPIC");
var menu4str=genSTR("MENU4");
var menu2str=genSTR("MENU2");
var menu3str=genSTR("MENU3");
var menu1str=genSTR("MENU1");
var title1=genSTR("TITLE1");
var title2=genSTR("TITLE2");
var title3=genSTR("TITLE3");
var title4=genSTR("TITLE4");


	var html="
	<!DOCTYPE html>
	<html>
	<head>
	    <title>��ҽԺ</title>
	    <meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\">
	    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=0, minimal-ui\">
	    <meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />
	    <META HTTP-EQUIV=\"Pragma\" CONTENT=\"no-cache\">
	    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />
	    <link rel=\"stylesheet\" type=\"text/css\" href=\"sytx/js/chis/angel/af.ui.css\" />
	    <link rel=\"stylesheet\" type=\"text/css\" href=\"sytx/js/chis/angel/icons.css\" />
	    <script type=\"text/javascript\" charset=\"utf-8\" src=\"http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js\"></script>
	    <script type=\"text/javascript\" charset=\"utf-8\" src=\"http://cdnjs.cloudflare.com/ajax/libs/fastclick/1.0.3/fastclick.min.js\"></script>
	    <script src=\"sytx/js/chis/angel/appframework.ui.min.js\"></script>  
	    <script src=\"http://cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.20/angular.min.js\"></script>
		<script type=\"text/javascript\" charset=\"utf-8\" src=\"sytx/js/chis/angel/app.js\"></script>
		<script type=\"text/javascript\" charset=\"utf-8\" src=\"sytx/js/chis/angel/controllers.js\"></script>
		<script type=\"text/javascript\" charset=\"utf-8\" src=\"sytx/js/chis/angel/directives.js\"></script>
	</head>
	<body id=\"todoaf\">
	    <div id=\"splashscreen\" class='ui-loader heavy'>
	        App Framework
	        <br>
	        <br>
	        <span class='ui-icon ui-icon-loading spin'></span>
	        <h1>Starting app</h1>
	
	    </div>
	    <div class=\"view\" id=\"mainview\">
	        <header>
	            <h1>Welcome</h1>
	        </header>
	        <div class=\"pages\">
	            <div class=\"panel active\" id=\"item13\" data-title=\""+title1+"\" data-selected=\"true\"  ng-controller=\"TodoCtrl\" data-include=\"L.sp?id="+menu1str+"\">
	            </div>
	            <div class=\"panel\" id=\"about\" data-title=\"About\">
	                This basic demo shows how to use Angular and App Framework UI together.
	            </div>
	            <div class=\"panel\" data-title=\""+title4+"\" id=\"item11\" data-footer=\"none\" data-include=\"L.sp?id="+menu4str+"\">		         
			  <!--�ҵ�--------->		        
	           </div>
		        <!-- �����������-->
		    <div class=\"panel\" data-title=\""+title2+"\" id=\"item12\" data-footer=\"none\" data-include=\"L.sp?id="+menu2str+"\">
			  <!--��������--------->		        
		    </div>
		    <div class=\"panel\" data-title=\""+title3+"\" id=\"item10\" data-footer=\"none\" style=\"margin:0;padding:0;\" data-include=\"L.sp?id="+menu3str+"\">
			   <!--��ͨ--------->		       
		     </div>
		     <div class=\"panel\" data-title=\"��ҩ\" id=\"health01\" data-footer=\"none\"  data-include=\"L.sp?id=MEDICATION\"></div>
		     <div class=\"panel\" data-title=\"��ʳ\" id=\"health02\" data-footer=\"none\"  data-include=\"L.sp?id=DIETCHIS\"></div>
		     <div class=\"panel\" data-title=\"�˶�\" id=\"health03\" data-footer=\"none\" data-include=\"L.sp?id=MOTIONCHIS\" ></div>
		     <div class=\"panel\" data-title=\"���\" id=\"health04\" data-footer=\"none\"  data-include=\"L.sp?id=MONITORCHIS\"></div>
		     <div class=\"panel\" data-title=\"����\" id=\"health05\" data-footer=\"none\"  data-include=\"L.sp?id=MISSIONCHIS\"></div>
		     <div class=\"panel\" data-title=\"ԤԼ����\" id=\"health06\" data-footer=\"none\"  data-include=\"L.sp?id=RESERVATIONCHIS\"></div>

	        </div>
	        <footer>
        	    <a href=\"#item13\" class=\"icon home\" id='tab1' data-transition=\"slide\">"+title1+"</a>
	            <a href=\"#item12\" class=\"icon heart\" id='tab2' data-transition=\"up-reveal\">"+title2+"</a>
		    <a href=\"#item10\" class=\"icon pencil\" id='tab3' data-transition=\"none\">"+title3+"</a>
		    <a href=\"#item11\" class=\"icon user\" id='tab4' data-transition=\"none\">"+title4+"</a>
	        </footer>
	    </div>
	</body>
	</html>
";
return html;
}
}