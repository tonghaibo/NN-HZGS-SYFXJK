function x_MAINAPPFRAM(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
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

/****
首页打开布局用f_openLocalURL(url)
子页面打开布局用openWindow(url)
****/
function GetBody(){
//组件里的参数直接使用
var menu5str=MENU5;
var menu4str=MENU4;
var menu2str=MENU2;
var menu3str=MENU3;
var menu1str=MENU1;
var htmltitle=HTMLTITLE;//网页标题
var title1=TITLE1;
var title2=TITLE2;
var title3=TITLE3;
var title4=TITLE4;
var title5=TITLE5;
var qty=DIVQTY;
var html="
<!--HTML5 doctype-->
<html>
<head>
    <title>"+htmltitle+"</title>
    <meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=0, minimal-ui\">
    <meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />
    <META HTTP-EQUIV=\"Pragma\" CONTENT=\"no-cache\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />
    <!--这两个css 是必须的！！！-->
    <link rel=\"stylesheet\" type=\"text/css\" href=\"xlsgrid/images/flash/js/icons.css\" />
    <link href=\"xlsgrid/images/flash/js/cate.css\" rel=\"stylesheet\" type=\"text/css\" />
    	<!--这三个js 是http的-->
    	<script type=\"text/javascript\" charset=\"utf-8\" src=\"http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js\"></script>
	<script type=\"text/javascript\" charset=\"utf-8\" src=\"http://cdnjs.cloudflare.com/ajax/libs/fastclick/1.0.3/fastclick.min.js\"></script>   
	<script src=\"http://cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.20/angular.min.js\"></script>
	<!--这个appframework.ui.js必须放在前面-->
	<script type=\"text/javascript\" charset=\"utf-8\" src=\"xlsgrid/images/flash/js/appframework.ui.js\"></script>
	<style type=\"text/css\" >
	.copyright {
	padding: 8px;
	text-align: center;
	font-size: 14px;
	color:#B2B2B2;
	}
	</style>
	
<link type=\"text/css\" href=\"sytx/js/chis/css/style.css\" rel=\"stylesheet\"/>
<script type=\"text/javascript\">
var curwinid=0;
var maxwinid=10;
function f_openWebURL(url){
	curwinid ++;
	if(curwinid>maxwinid)curwinid=1;
	$.get(url,function(data,status){				
	document.getElementById(\"DOCWIN\"+curwinid).innerHTML=data;
	});			
	document.all('a_gotoitem'+curwinid).click();
}
function f_openLocalURL(url) {
        curwinid ++;
        if (curwinid>maxwinid) curwinid=1;
        var data = \"<iframe src='\"+url+\"' width=100% height=100% frameborder=0></iframe>\";
        document.getElementById(\"PANEL_WIN\"+curwinid).innerHTML=data;
        document.all('a_gotopanel'+curwinid).click();
}     
</script>	
<!--公用js-->
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery-1.7.2.min.js\"></script>
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery.event.drag-1.5.min.js\"></script>
<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery.touchSlider.js\"></script>

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
            <h1>"+htmltitle+"</h1>
        </header>
        <div class=\"pages\">
        	    ";	
        	    if(title1!="" && title1!=null){			
         	   	   html+="
         	           <!--第一个布局--------->
         	    	   <div class=\"panel\" data-title=\""+title1+"\" id=\"all_panel1\" data-footer=\"none\"  data-selected=\"true\" style=\"margin:0;padding:0;\">";		
		     	   if(menu1str!="" && menu1str!=null){   		
		          	html+=getlayout(request,menu1str);   
		           }
		     	   html+="</div>";
		     }
        	    if(title2!="" && title2!=null){			
         	   	   html+="
         	           <!--第二个布局--------->
         	    	   <div class=\"panel\" data-title=\""+title2+"\" id=\"all_panel2\" data-footer=\"none\"   style=\"margin:0;padding:0;\">";		
		     	   if(menu2str!="" && menu2str!=null){   		
		          	html+=getlayout(request,menu2str);   
		           }
		     	   html+="</div>";
		     }
        	    if(title3!="" && title3!=null){			
         	   	   html+="
         	           <!--第三个布局--------->
         	    	   <div class=\"panel\" data-title=\""+title3+"\" id=\"all_panel3\" data-footer=\"none\"   style=\"margin:0;padding:0;\">";		
		     	   if(menu3str!="" && menu3str!=null){   		
		          	html+=getlayout(request,menu3str);   
		           }
		     	   html+="</div>";
		     }
		     
        	    if(title4!="" && title4!=null){			
         	   	  
         	   	   html+="
         	           <!--第四个布局--------->
         	    	   <div class=\"panel\" data-title=\""+title4+"\" id=\"all_panel4\" data-footer=\"none\"   style=\"margin:0;padding:0;\">";		
		     	   if(menu4str!="" && menu4str!=null){   		
		          	html+=getlayout(request,menu4str);   
		           }
		     	   html+="</div>";
		     }
		      if(title5!="" && title5!=null){			
         	   	  
         	   	   html+="
         	           <!--第五个布局--------->
         	    	   <div class=\"panel\" data-title=\""+title5+"\" id=\"all_panel4\" data-footer=\"none\"   style=\"margin:0;padding:0;\">";		
		     	   if(menu4str!="" && menu4str!=null){   		
		          	html+=getlayout(request,menu5str);   
		           }
		     	   html+="</div>";
		     }	
		          
		          html+="
		     		
		     <!--10个循环的div--------->
		     <div class=\"panel\" data-title=\"连接内部窗口不显示\" id=\"WININNER\" data-footer=\"none\">";
		          if(qty==0 || qty==null || qty==""){
		          	qty=10;
		          }
		          for(var i=1;i<=qty;i++){
		          	html+="<a href='#PANEL_WIN"+i+"' id='a_gotopanel"+i+"' style=\"display：none;\">直接跳转到win"+i+"</a><br>";
		          }
		     html+="</div>";     
			   for(var i=1;i<=qty;i++){
			   	html+="
			          	<div class='panel' data-title='子页面' id='PANEL_WIN"+i+"' data-footer='none' style='padding:0;'>
				        <img src='xlsgrid/images/flash/images/loading.gif' style='max-width=:100%;height=:auto;margin-top:30px;' >
				        </div><br>
			        ";
		          }
		      html+=";
		      </div><!--这个是pages 的结束-------------------------------------------------------------------------------->	         
		         
		         <!--Footer to add tabs if desired-->
		        <footer>
		            <!--五个div固定的菜单--------->
		            ";
		            if(title1!="" && title1!=null){
		            	html+="<a href=\"#all_panel1\" class=\"icon home\" id='tab1' data-transition=\"none\">"+title1+"</a>";	
		            }
		            if(title2!="" && title2!=null){
		            	html+="<a href=\"#all_panel2\" class=\"icon heart\" id='tab2' data-transition=\"up-reveal\">"+title2+"</a>";
			    }
			    if(title3!="" && title3!=null){
			    	html+="<a href=\"#all_panel3\" class=\"icon pencil\" id='tab3' data-transition=\"none\">"+title3+"</a>";
		            }
		            if(title4!="" && title4!=null){
		            	html+="<a href=\"#all_panel4\" class=\"icon user\" id='tab4' data-transition=\"none\">"+title4+"</a>";
			    }
		            if(title5!="" && title5!=null){
		            	html+="<a href=\"#all_panel5\" class=\"icon user\" id='tab5' data-transition=\"none\">"+title5+"</a>";
			    }

			    html+="
	
		        </footer>
    </div><!--这个是view 的结束------------------------------------------------------------------------------------->

</body>

</html>	
";
return html;

}


//获取每个布局的编号
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
			AND A.ID ='MAINAPPFRAM' AND A.CLS='CHIS'and B.id ='"+str+"'
		";
		ds=db.QuerySQL(sql);
		if(ds.getRowCount()==1){
			layid=ds.getStringAt(0,"VAL");
			return layid; 
		}
	}
	catch(e){return "";}
	if(db!=null){db.Close();}
}
//获取布局的html
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
			sb.append("");
						
			//throw new pubpack.EAException ( ee.toString() );
		}
		finally {
			if (db!=null) db.Close();
		}

	return sb.toString();
}

}