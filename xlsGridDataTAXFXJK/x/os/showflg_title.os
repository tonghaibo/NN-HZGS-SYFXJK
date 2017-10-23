function x_showflg_title(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb");
var layoutpack = new JavaPackage ( "com.xlsgrid.net.layout");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd");	
var langpack = new JavaPackage ( "java.lang");
var web = new JavaPackage ( "com.xlsgrid.net.web" );
//二级菜单栏
function menu(){
	var typ =DSMOD ;
	var ds=db.QuerySQL("select * from lsysurl where org='"+deforg+"' and refid='"+typ+"'");
	var div="";
	var iframe="";
	var rowcnt=ds.getRowCount();
	
	var st = new Array(); 
	var cdcnt = db.GetSQL("select CDMSSMCNT.Nextval CNT from dual");
	var css="<style>
		    .nav_a"+cdcnt+" {
		        color: "+fontcolor+";
		        cursor: pointer;
		        float: left;
		        font-size: 14px;
		        height: "+height+";
		        line-height: "+height+";
		        padding: 0px 15px;
		        position: relative;

		    }
		
		    .nav"+cdcnt+" {
		        height:"+height+";
		
		    }
		    .nav"+cdcnt+" .on {
		        background-color:"+onclickcolor+";
		        color: #000000;
		    }
		    #dr"+cdcnt+" div:hover{
		        cursor:pointer;
		        background:"+hovercolor+";";
		        if(bg_img!=null||bg_img!=""){
		        	css+="background-image:url("+bg_img+");";
		        }
	css += "}</style>";
	var menulog= MENUID;
	for(var i=0; i<rowcnt;i++){
		var id=ds.getStringAt(i,"id")+cdcnt;
		var name=ds.getStringAt(i,"name");
		var url=ds.getStringAt(i,"url");
		st[i]=id;
		var onmo="";
		if(menulog+cdcnt==id)
			div+="<DIV onclick=\"swithpage"+typ+cdcnt+"(this.id,'"+url+"')\" "+onmo+" id="+id+" class=\"nav_a"+cdcnt+" on\">"+name+"</DIV>";
		else
			div+="<DIV onclick=\"swithpage"+typ+cdcnt+"(this.id,'"+url+"')\" "+onmo+" id="+id+" class=\"nav_a"+cdcnt+"\">"+name+"</DIV>";
	}

	var padding="";
	
//	if(typ=="NEW_MENU_1") return menulog+"-----------------------------我是分割线-----------------------";
	if(paddingleft!="")  padding="PADDING-LEFT:"+paddingleft+";"; else if(paddingleft==""&&paddingright=="")  padding="PADDING-LEFT:0px"; else padding="PADDING-RIGHT:"+paddingleft+";";
	var bgcolorimg="";
	if(bgcolor_img!=null) bgcolorimg="background-image:url("+bgcolor_img+");";
	var html="<div style=\"OVERFLOW: hidden; "+padding+" BACKGROUND-COLOR: "+bgcolor+"; "+bgcolorimg+");\"><DIV id=dr"+cdcnt+" class=nav"+cdcnt+" style=\"FLOAT: left\">"+div+"</div></div>";
	var script="<script>
			function swithpage"+typ+cdcnt+"(frameid,url){
				window.location.href=url;
			}
	
	</script>";
//	window.onload=function(){";
//				
//				if(bgcolor_img!=null)
//		            		script+="document.getElementById('"+menulog+cdcnt+"').style.backgroundImage=\"url("+bgcolor_img+")\";";
//		            	else
//				 	script+="document.getElementById('"+menulog+cdcnt+"').style.background=\""+onclickcolor+"\";";
//				 	
//				script+="document.getElementById('"+menulog+cdcnt+"').style.color=\"#000000\";
//			}
	
	return css+html+script;


}

//顶级菜单
function topmenu(){
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
 
function MENU_WIN8(){
	return "<style type=\"text/css\">
.menu {
 
}
.menu ul {
padding:0; 
margin:0;
list-style-type: none;
}
.menu ul li {
float:left;
position:relative;
}
.menu ul li a, .menu ul li a:visited {
display:block; 
text-decoration:none; 
color:#000; 
width:139px; 
height:3em; 
color:#000; 
border:0px solid #fff; 
border-width:0px 0px 0 0; 
background:#dfc184; 
padding-left:10px; 
line-height:3em;
}
* html .menu ul li a, .menu ul li a:visited {
width:149px;
 
}
.menu ul li ul {
display: none;
}
DIV {
margin:-1px; 
border-collapse:collapse;
font-size:1em;
}

/* specific to non IE browsers */
.menu ul li:hover a {
color:#fff; 
background:#bd8d5e;
}
.menu ul li:hover ul {
display:block; 
position:absolute; 
top:3em;
margin-top:0px;
left:0; 
width:150px;
}
.menu ul li:hover ul li ul {
display: none;
}
.menu ul li:hover ul li a {
display:block; 
background:#faeec7; 
color:#000; 
height:auto; 
line-height:1.2em; 
padding:5px 10px; 
width:129px
}
.menu ul li:hover ul li a.drop {
background:#999999;
}
.menu ul li:hover ul li a:hover {
background:#c9c9a7; 
color:#000;
}
.menu ul li:hover ul li:hover ul {
display:block; 
position:absolute; 
left:149px;
top:0;
width:150px;
}
.menu ul li:hover ul li:hover ul.left {
left:-149px;
}

</style>
<!--[if lte IE 6]>
<style type=\"text/css\">
.menu ul li a:hover {
color:#fff; 
background:#bd8d5e;
}
.menu ul li a:hover ul {
display:block; 
position:absolute; 
top:3em; 
left:0;
background:#fff;
margin-top:0;
 
}
.menu ul li a:hover ul li a {
display:block; 
background:#dbe4ab; 
color:#000; 
height:auto; 
line-height:1.5em; 
padding:5px 10px; 
width:150px;
 
}
.menu ul li a:hover ul li a.drop {
background:#c9c9a7;
}
.menu ul li a:hover ul li a ul {
visibility:hidden; 
position:absolute; 
height:0; 
width:0;
}
.menu ul li a:hover ul li a:hover {
background:#c9c9a7; color:#000;
}
.menu ul li a:hover ul li a:hover ul {
visibility:visible; 
position:absolute; 
top:0; 
color:#000;
left:150px;
}
.menu ul li a:hover ul li a:hover ul.left {
left:-150px;
}

</style>
<![endif]-->
</head>
<body>
<div class=\"menu\">

<ul>
<li><a class=\"drop\" href=\"http://www.alixixi.com/\">DEMOS
<!--[if IE 7]><!-->
</a>
<!--<![endif]-->

<DIV><DIV><DIV>

    <ul>
    <li><a href=\"http://www.alixixi.com/\" title=\"The zero dollar ads page\">zero dollars advertising page</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"Wrapping text around images\">wrapping text around images</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"Styling forms\">styled form</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"Removing active/focus borders\">active focus</a></li>
    <li><a class=\"drop\" href=\"http://www.alixixi.com/\" title=\"Hover/click with no active/focus borders\">hover/click with no borders
<!--[if IE 7]><!-->
</a>
<!--<![endif]-->


<DIV><DIV><DIV>
        <ul>
            <li><a href=\"http://www.alixixi.com/\" title=\"Styling forms\">styled form</a></li>
            <li><a href=\"http://www.alixixi.com/\" title=\"Removing active/focus borders\">removing active/focus borders</a></li>
            <li><a href=\"http://www.alixixi.com/\" title=\"Hover/click with no active/focus borders\">hover/click</a></li>
        </ul>
</DIV></DIV></DIV>

<!--[if lte IE 6]>
</a>
<![endif]-->

    </li>

    <li class=\"upone\"><a href=\"http://www.alixixi.com/\" title=\"Multi-position drop shadow\">shadow boxing</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"Image Map for detailed information\">image map for detailed information</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"fun with background images\">fun with background images</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"fade-out scrolling\">fade scrolling</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"em size images compared\">em image sizes compared</a></li>
    </ul>

</DIV></DIV></DIV>

<!--[if lte IE 6]>
</a>
<![endif]-->

</li>


<li><a href=\"http://www.alixixi.com/\">BOXES
<!--[if IE 7]><!-->
</a>
<!--<![endif]-->


<DIV><DIV><DIV>

    <ul>
    <li><a href=\"http://www.alixixi.com/\" title=\"a coded list of spies\">a coded list of spies</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"a horizontal vertical menu\">vertical menu</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"an enlarging unordered list\">enlarging unordered list</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"an unordered list with link images\">link images</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"non-rectangular links\">non-rectangular</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"jigsaw links\">jigsaw links</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"circular links\">circular links</a></li>
    </ul>

</DIV></DIV></DIV>

<!--[if lte IE 6]>
</a>
<![endif]-->

</li>

<li><a href=\"http://www.alixixi.com/\">MOZILLA
<!--[if IE 7]><!-->
</a>
<!--<![endif]-->


<DIV><DIV><DIV>

    <ul>
    <li><a href=\"http://www.alixixi.com/\" title=\"A drop down menu\">drop down menu</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"A cascading menu\">cascading menu</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"Using content:\">content:</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\":hover applied to a div\">mozzie box</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"I can build a rainbow\">I can build a rainbow with DIVansparent borders</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"Snooker cue\">a snooker cue using border art</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"Target Practise\">target practise</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"Two tone headings\">two tone headings</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"Shadow text\">shadow text</a></li>
    </ul>

</DIV></DIV></DIV>

<!--[if lte IE 6]>
</a>
<![endif]-->

</li>

<li><a href=\"http://www.alixixi.com/\">EXPLORER
<!--[if IE 7]><!-->
</a>
<!--<![endif]-->


<DIV><DIV><DIV>

    <ul>
    <li><a href=\"http://www.alixixi.com/\" title=\"Example one\">the first example for Internet Explorer</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"Weft fonts\">weft fonts</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"Vertical align\">vertically aligning text</a></li>
    </ul>

</DIV></DIV></DIV>

<!--[if lte IE 6]>
</a>
<![endif]-->

</li>

<li><a href=\"http://www.alixixi.com/\">OPACITY
<!--[if IE 7]><!-->
</a>
<!--<![endif]-->


<DIV><DIV><DIV>

    <ul>
    <li><a href=\"http://www.alixixi.com/\" title=\"colour wheel\">a colour wheel using opaque colours</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"a menu using opacity\">a menu using opacity</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"partial opacity\">partial opacity</a></li>
    <li><a href=\"http://www.alixixi.com/\" title=\"partial opacity II\">partial opacity II</a></li>

    <li><a class=\"drop\" href=\"http://www.alixixi.com/\" title=\"Hover/click with no active/focus borders\">HOVER/CLICK
<!--[if IE 7]><!-->
</a>
<!--<![endif]-->

<DIV><DIV><DIV>

        <ul class=\"left\">
            <li><a href=\"http://www.alixixi.com/\" title=\"Styling forms\">styled form</a></li>
            <li><a href=\"http://www.alixixi.com/\" title=\"Removing active/focus borders\">removing active/focus borders</a></li>
            <li><a href=\"http://www.alixixi.com/\" title=\"Hover/click with no active/focus borders\">hover/click</a></li>
        </ul>

</DIV></DIV></DIV>

<!--[if lte IE 6]>
</a>
<![endif]-->

    </li>
    </ul>

</DIV></DIV></DIV>

<!--[if lte IE 6]>
</a>
<![endif]-->

</li>
</ul>

</div>";
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
		
		parent.GetLayoutHTML(db,request,sb,deforg,layoutid,0);
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
//
// 
//
function getifrom(){

	var typ =DSMOD ;
	var ds=db.QuerySQL("select * from lsysurl where org='"+deforg+"' and refid='"+typ+"'");
	var div="";
	var iframe="";
	var rowcnt=ds.getRowCount();
	
	var st = new Array(); 
	var cdcnt = db.GetSQL("select CDMSSMCNT.Nextval CNT from dual");
	var css="<style>
		    .nav_a"+cdcnt+" {
		        color: "+fontcolor+";
		        cursor: pointer;
		        float: left;
		        font-size: 14px;
		        height: "+height+";
		        line-height: "+height+";
		        padding: 0px 15px;
		        position: relative;

		    }
		
		    .nav"+cdcnt+" {
		        height:"+height+";
		
		    }
		    .nav"+cdcnt+" .on {
		        background-color:"+onclickcolor+";
		        color: #000000;
	
		
		    }
		    #dr"+cdcnt+" div:hover{
		        cursor:pointer;
		        background:"+hovercolor+";";
		        
		   
		        if(bg_img!=null||bg_img!=""){
		        	css+="background-image:url("+bg_img+");";
		        }
		        
		    css += "}
		</style>";
//	return css;
	for(var i=0; i<rowcnt;i++){
		var id=ds.getStringAt(i,"id")+cdcnt;
		var name=ds.getStringAt(i,"name");
		var url=ds.getStringAt(i,"url");
		st[i]=id;
		var onmo="";
//		if(Event=="onclick") onmo="onmousemove=onmous(this.id,1) onmouseout=onmous(this.id,2)";
		if(i==0){
			//onmousemove,onclick,onmouseover
			div+="<DIV "+Event+"=\"swithpage"+typ+cdcnt+"(this.id,'"+url+"')\" "+onmo+" id="+id+" class=\"nav_a"+cdcnt+" on\">"+name+"</DIV>";
			if(OSPARAM=="iframe"){
				iframe+="<iframe id=\"ifr_"+id+"\"  width=\"100%\" height=\"100%\" frameborder=\"0\" src=\""+url+"\" style=\"display:block;\"></iframe>";
			}
			else if(OSPARAM=="div"){
				iframe+="<div id=\"ifr_"+id+"\"  width=\"100%\" height=\"100%\" frameborder=\"0\" src=\"\" style=\"display:block;\"></div>";
			}
			else{
				var loyhtml="";
				if(url!=""){
					var layoutid=url.split("&")[0].split("=")[1];
					loyhtml=getlayout(request,layoutid);
					
				}
				if(loadtyp=="onclick")
					iframe+="<div id=\"ifr_"+typ+"\"  width=\"100%\" height=\"100%\" frameborder=\"0\" src=\"\" style=\"display:block;\">"+loyhtml+"</div>";
				else
					iframe+="<div id=\"ifr_"+id+"\"  width=\"100%\" height=\"100%\" frameborder=\"0\" src=\"\" style=\"display:block;\">"+loyhtml+"</div>";
			}
		}
		else{
			div+="<DIV "+Event+"=\"swithpage"+typ+cdcnt+"(this.id,'"+url+"')\" "+onmo+" id="+id+" class=\"nav_a"+cdcnt+"\">"+name+"</DIV>";
			if(OSPARAM=="iframe"){
				iframe+="<iframe id=\"ifr_"+id+"\"  width=\"100%\" height=\"100%\" frameborder=\"0\" src=\"\" style=\"display:none;\"></iframe>";
			}
			else if(OSPARAM=="div"){
				iframe+="<div id=\"ifr_"+id+"\"  width=\"100%\" height=\"100%\" frameborder=\"0\" src=\"\" style=\"display:none;\"></div>";
			}
			else{
				var loyhtml="";
				if(url!=""){
					var layoutid=url.split("&")[0].split("=")[1];
					loyhtml=getlayout(request,layoutid);
					
				}
				if(loadtyp!="onclick")
				iframe+="<div id=\"ifr_"+id+"\"  width=\"100%\" height=\"100%\" frameborder=\"0\" src=\"\" style=\"display:none;\">"+loyhtml+"</div>";
				
			}
		}
	}

	var padding="";
	if(paddingleft!="")  padding="PADDING-LEFT:"+paddingleft+";"; else if(paddingleft==""&&paddingright=="")  padding="PADDING-LEFT:0px"; else padding="PADDING-RIGHT:"+paddingleft+";";
	var html="<div style=\"OVERFLOW: hidden; "+padding+" BACKGROUND-COLOR: "+bgcolor+"; background-image:url("+bgcolor_img+");\"><DIV id=dr"+cdcnt+" class=nav"+cdcnt+" style=\"FLOAT: left\">"+div+"</div></div>";
//	var html="<table border=\"1\" width=\"100%\" height=\"100%\"><tr><td><DIV id=dr class=nav"+cdcnt+" style=\"FLOAT: left\">"+div+"</div></td></tr>";
//	html+="<tr><td>"+iframe+"</td></tr></table>";
	html+="<div id=\"CDMS_menu\" >"+iframe+"</div>";
	var script="<script>";
	if(OSPARAM=="iframe"){
		script+="function swithpage"+typ+cdcnt+"(frameid,url){
			       var st"+typ+cdcnt+"="+st+";
			        var cnt=st"+typ+cdcnt+".length;
			        var id=\"ifr_\"+frameid;
			        for ( var i=0;i<cnt;i++){
			            var ifid=\"ifr_\"+st"+typ+cdcnt+"[i];
			            document.getElementById(ifid).style.display=\"none\";
				 
			          document.getElementById(st"+typ+cdcnt+"[i]).style.backgroundColor=\""+bgcolor+"\";
			       }
			        document.getElementById(frameid).style.backgroundColor=\"#FFFFFF\";
			        var issrc= document.getElementById(id).src;
			        if(issrc==\"\"){
				        document.getElementById(id).src=url;
			        }
			       document.getElementById(id).style.display=\"block\";
			      
			   }
			   window.onload=function(){
				meid=\"CDMS_menu\";
			        var div=document.getElementById(meid);
			        var y=window.screen.availHeight-div.offsetTop-130;
			       div.style.height=y;
	    		}";
		
	}
	if(OSPARAM=="div"){
		script+="function swithpage"+typ+cdcnt+"(frameid,url){
				var st"+typ+cdcnt+"="+st+";
			        var cnt=st"+typ+cdcnt+".length;
			        var id=\"ifr_\"+frameid;
			        for ( var i=0;i<cnt;i++){
			            var ifid=\"ifr_\"+st"+typ+cdcnt+"[i];
			            document.getElementById(ifid).style.display=\"none\";";
			if(bgcolor_img!=null) {
			            script+="document.getElementById(st"+typ+cdcnt+"[i]).style.backgroundImage=\"url("+bgcolor_img+")\"";
			}
			else{
			            script+="document.getElementById(st"+typ+cdcnt+"[i]).style.background=\""+bgcolor+"\";";
			            script+="document.getElementById(st"+typ+cdcnt+"[i]).style.color=\""+fontcolor+"\";";
			 }
			if(onclickcolor!=""||onclickcolor!=null)
			script+="} document.getElementById(frameid).style.background=\""+onclickcolor+"\";";
			
			if(bgcolor_img==null)
			script+="document.getElementById(frameid).style.color=\"#000000\";
		        
			       $.ajax({
					url: url+'&hashead=n',
					type: 'POST',
					error: function(){alert('您的网速有问题,如若网络正常。请联系管理员!');},
					success: function(result){
						var ht=result.split(\"<sprict>\");
						var htl='';//得到html
						var spt='';//得到script
						if(ht.length>2){
							for(var i=0;i<ht.length;i++){
								if(i==0) 
									htl+=ht[i];
								else{
									spt+=ht[i].split(\"</script>\")[0]
									htl+=ht[i].split(\"</script>\")[1];
								}
							}
						}
						else{
							htl=ht[0];
							spt=ht[1].split(\"</script>\")[0];
							htl+=ht[1].split(\"</script>\")[1];
						}
						var script=document.createElement(\"script\");//在模版页创建新的<script>标签
			                        script.text=spt;//给新的script标签赋值
			                        document.getElementsByTagName(\"head\")[0].appendChild(script);
						document.getElementById(id).innerHTML=htl;
					}
				});
		       		document.getElementById(id).style.display=\"block\";
		   }
		   window.onload=function(){
	
		   	$.ajax({
				url: '"+ds.getStringAt(0,"url")+"&hashead=n',
				type: 'POST',
				error: function(){alert('您的网速有问题,如若网络正常。请联系管理员!');},
				success: function(result){
					document.getElementById(\"ifr_"+st[0].split(\"__\")[0]+"\").innerHTML=result;
				}
			});
		   
		   }";
			   
	}
	else{
		
		script+="function swithpage"+typ+cdcnt+"(frameid,url){
			var st"+typ+cdcnt+"="+st+";
		        var cnt=st"+typ+cdcnt+".length;
		        var id=\"ifr_\"+frameid;
		        for ( var i=0;i<cnt;i++){
		            var ifid=\"ifr_\"+st"+typ+cdcnt+"[i];";
		 if(loadtyp!="onclick")
		           script+="document.getElementById(ifid).style.display=\"none\";";
		if(bgcolor_img!=null) {
		            script+="document.getElementById(st"+typ+cdcnt+"[i]).style.backgroundImage=\"url("+bgcolor_img+")\"";
		}
		else{
		            script+="document.getElementById(st"+typ+cdcnt+"[i]).style.background=\""+bgcolor+"\";";
		            script+="document.getElementById(st"+typ+cdcnt+"[i]).style.color=\""+fontcolor+"\";";
		 }
		            	
		
		if(onclickcolor==""||onclickcolor==null){
			script+="}";
		}	
		else
			script+="} document.getElementById(frameid).style.background=\""+onclickcolor+"\";";
		if(bgcolor_img==null)
		script+="document.getElementById(frameid).style.color=\"#000000\";";
		
		if(loadtyp=="onclick")
			script+="$.ajax({
					url: url+'&hashead=n',
					type: 'POST',
					error: function(){alert('您的网速有问题,如若网络正常。请联系管理员!');},
					success: function(result){
						document.getElementById(\"ifr_"+typ+"\").innerHTML=result;
					}
				});";
		else
			script+="document.getElementById(id).style.display=\"block\";";
		
		
		script+="}";
	}
	script+="
//		function onmous(id,ty){
//			document.getElementById(id).style.cursor=\"pointer\";
//			var colc=document.getElementById(id).style.background-color;
//			if(ty==1)
//			document.getElementById(id).style.background=\"#666666\";
//			else
//			document.getElementById(id).style.background=colc;
//		}
	</script>";
		
	
	return css+html+script;
	
}

//
// 
//
function Search(){
		if(xlcolor=="") xlcolor="#C0C0C0";
		if(gridcolor=="") gridcolor="#ff0000";
		if(width=="") width="500"; else if(width.split("px").length()>1) width=width.split("px")[0];
		if(height=="") height="25"; else if(height.split("px").length()>1) height=height.split("px")[0]*1.0;

		var css="<style>
		</style>";
		var cdcnt = db.GetSQL("select CDMSSMCNT.Nextval CNT from dual");
		var html="<table border=\"0\" width=\""+width+"px\" cellspacing=\"0\" cellpadding=\"5\">
			<tr>
				<td  bgcolor=\""+gridcolor+"\">
					<table border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" bgcolor=\"#FFFFFF\" height=\"25\" style=\"border:"+border+" solid "+bordercolor+"\">
						<tr>
						<td width=\"80\" bgcolor=\""+xlcolor+"\" style=\"display:none\"><p align=\"center\">"+qurnam+"</td>
						<td><input onkeyup=\"searchA"+cdcnt+"('ipt"+cdcnt+"')\"  id=\"ipt"+cdcnt+"\" type=\"text\" name=\"T1\"  style=\"height:"+height+"px;width:95%; border: 1px solid #FFFFFF; padding-left: 4px; padding-right: 4px; padding-top: "+height/5+"px; padding-bottom: 1px; font-size:14pt; text-align:left;\" size=\"100%\"></td>
						<td onclick=\"search"+cdcnt+"('ipt"+cdcnt+"')\" width=\"80\" style=\"CURSOR: pointer;\" bgcolor=\""+gridcolor+"\"><p align=\"center\"><font color=\"#FFFFFF\" size=\"+1\" style=\"font-family:'微软雅黑'\">搜 索</font></p></td>
						</tr>
						<tr><td></td><td><div id=\"div_search"+cdcnt+"\"  style=\"position: absolute;z-index:9;background-color:white;border:1px solid;display:none;\"></div></td><td></td></tr>
					</table>
				</td>
			</tr></table>";
		var script="<script>
			
			
			function searchA"+cdcnt+"(id){
				var sah=\""+sahurl+"\";
				if(sah==\"xhzysearch1\"||sah==\"pwjjSearch1\"){
					var value=document.getElementById(id).value;
					if(value!=null && value!=\"\"){
						var setlistname=\"seachinfo"+cdcnt+"\";
						var url=\"http://cdms.xmidware.com/aca/x.showflg_title.getyp.osp?typ=4&value=\"+value+\"&setlistname=\"+setlistname;
					
						$.ajax({
							url: url,
							type: 'POST',
							error: function(){alert('您的网速有问题,如若网络正常。请联系管理员!');},
							success: function(result){
								
								var str=result;
								var arr=str.split(\",\");
								var html=\"\";
		
								for(var i=0;i<arr.length;i++){
									if(arr[i]!=null&&arr[i]!=\"\"){
										strs=arr[i].split(\"~\");
									html+=\"<p style=\'margin:0px;padding:0px;border:0px;cursor:pointer;width:330px;height:30px;size:16\'  onmousemove=this.style.backgroundColor='#D3D3D3' onmouseout=this.style.backgroundColor='white' onclick=doClick"+cdcnt+"(\"+strs[0]+\",'\"+strs[1]+\"'); >\"+strs[1]+\"</p>\";
									}
								};
								html+=\"\";
								document.getElementById(\"div_search"+cdcnt+"\").innerHTML=\"\";
								document.getElementById(\"div_search"+cdcnt+"\").style.display='block';
								document.getElementById(\"div_search"+cdcnt+"\").innerHTML=html;
							}
						});
					}else{
						document.getElementById(\"div_search"+cdcnt+"\").style.display='none';
	
					}
				}
							
			};
			
			
		
			function doClick"+cdcnt+"(id,val){

					document.getElementById(\"ipt"+cdcnt+"\").value=val;
					document.getElementById(\"div_search"+cdcnt+"\").style.display='none';
					var sah=\""+sahurl+"\";
					if(sah==\"xhzysearch1\"){
						setywscqd(id,val);
					}else if(sah==\"pwjjSearch1\"){
						//alert(id);
						setywscqd2(id,val);
					}		
			};

			function search"+cdcnt+"(id){
				var value=document.getElementById(id).value;
				document.getElementById(\"div_search"+cdcnt+"\").style.display='none';
				var sah=\""+sahurl+"\";
				
				if(value!=null&&value!=\"\"){
					var setlistname=\"seachinfo"+cdcnt+"\";
					var url=\""+sahdtlMethod+"\"+value+\"&setlistname=\"+setlistname;
					
					$.ajax({
						url: url,
						type: 'POST',
						error: function(){alert('您的网速有问题,如若网络正常。请联系管理员!');},
						success: function(result){
							
							document.getElementById(\""+sahurl+"\").innerHTML=result;
							if(sah==\"YongYaoSearch\"){
								document.getElementById(\"YYJYdiv1\").style.display='none';
								document.getElementById(\"YYJYdiv3\").style.display='none';
								document.getElementById(\"YYJYdiv2\").style.display='block';
								document.getElementById(\"YYJYdiv2\").innerHTML='<h4>用药教育-'+value+'</h4>';
								document.getElementById(\"YongYaoSearch\").style.display='block';
							}
							
						}
					});
				}

			}";
			
			
		if(sahhdrMethod!=""){
			script+="function seachinfo"+cdcnt+"(id,name,typ){
				$.ajax({
					url: '"+sahhdrMethod+"'+id,
					type: 'POST',
					error: function(){alert('您的网速有问题,如若网络正常。请联系管理员!');},
					success: function(result){
						if(result==\"<div></div>\") 
						document.getElementById(\""+sahurl+"\").innerHTML=\"<p>未找到‘\"+name+\"‘相关信息</p>\";
						else
						document.getElementById(\""+sahurl+"\").innerHTML=result;
					}
				});
			}";
		}	
		script+="</script>";
				
		
	return css+html+script;
}
//模糊查询
function getyp(){
 	var html ="";
	var db="";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sp = likename.split(" ");
		var sql = "select * from CDMS_DRUNAM where 1=1 and name like ";
		var spli = "";//查询条件
		for(var i =0;i<sp.length();i++){
			if(sp[i] != ""){
			sql += "'%"+sp[i]+"%' and name like";
			}
		}
		sql += " '%%'";
		var ds=db.QuerySQL(sql);
	
		html += "<div style=\"width:1000px;\">";
		if(ds.getRowCount() == 0){
			html += "<p>未检索到与 "+likename+" 相关的信息。</p><p>建议您：</p><p>1. 检查您输入的关键词有无错误；</p><p>2. 更换检索词后重新进行检索。</p> ";
		}
		for(var i=0;i<ds.getRowCount();i++){
			html += "<table style=\"width:110px;height:110px;cursor:pointer; float:left;margin:5px;background:url(EAFormBlob.sp?guid=A93897F4D66A4D9BB9F0A0CFBC13EDF6);\">";
			html += "<tr><td onclick=\"fenxi("+ds.getValueAt(i,"id")+",'"+ds.getValueAt(i,"name")+"')\" ><font  size=\"3\" color=\"#666666\" >"+ds.getValueAt(i,4)+"</font>";
			html += "<td></tr></table>";
	
		}
		html +="<div>";
		}catch ( ee ) {
			db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "出现错误";
		}
		finally {
		
			if (db!="") db.Close();
		}
	return html;

}


//
// 
//传入参数 sql（表名称表如table1,table2,table3）
function listinfo(){

	var cdcnt = db.GetSQL("select CDMSSMCNT.Nextval CNT from dual");
	var divname="tree_"+cdcnt; //设置div id
	var arryname="menulist_"+cdcnt;//设置 数组id
	var setlistname="setlist"+cdcnt;
	var upNavigationBarname="upNavigationBar"+cdcnt;
	var gethttpname="gethttp"+cdcnt;
	var NavigationBarname="NavigationBar"+cdcnt;


	var css="<style>#"+NavigationBarname+" div:hover{ cursor:pointer;background-color: #FFFFFF; }</style>";
	var html="<DIV  id=\""+NavigationBarname+"\" style=\"BORDER-TOP: #d7d4cf 1px solid;PADDING-LEFT: 10%; HEIGHT: 46px; WIDTH: 100%; BACKGROUND-IMAGE: url(http://cdms.xmidware.com/aca/ROOT_CDMS/EAFormBlob.sp?guid=5CD9AA2C3A12404DB711A10F0B547A24); BORDER-BOTTOM: #c4c6c3 1px solid; CLEAR: left\">
	</div>
	<DIV id="+divname+" style=\"HEIGHT:100%; WIDTH: 80%; OVERFLOW-X: hidden; OVERFLOW-Y: auto; FLOAT: left; PADDING-LEFT: 10%; PADDING-RIGHT: 10%\">
	</div>";
	var script="<script>
		var "+arryname+" = new Array();
		function "+setlistname+"(id,name,isleaf){
			var table=\""+SQLTXT+"\";
			var html=\"\";
			"+upNavigationBarname+"(id+\",\"+name+\",\"+isleaf);
			for(var i=0;i<"+arryname+".length;i++){
				if("+arryname+"[i]!=\"\"){
					id="+arryname+"[i].split(\",\")[0];
					name="+arryname+"[i].split(\",\")[1];
					isleaf="+arryname+"[i].split(\",\")[2];
					html+=\"<DIV onclick="+setlistname+"(\"+id+\",'\"+name+\"',\"+isleaf+\")  style='FONT-SIZE: 14px; TEXT-DECORATION: none; POSITION: relative; FLOAT: left; FONT-WEIGHT: 700; COLOR: #666666; TEXT-ALIGN: center; PADDING-LEFT: 20px; DISPLAY:block; LINE-HEIGHT: 47px;PADDING-RIGHT: 20px;' >\"+name+\"-></DIV>\";
				}
			}
			"+gethttpname+"(id,isleaf,table);
		        document.getElementById(\""+NavigationBarname+"\").innerHTML=html;
		}
		function "+gethttpname+"(id,isleaf,table){
			var url=\"http://cdms.xmidware.com/aca/ROOT_CDMS/x.showflg_title.getlisti.osp?usrid=xlsgrid&userpwd=0&id=\"+id+\"&type=\"+isleaf+\"&setlistname="+setlistname+"&tabe=\"+table;
			var html=\"\";
			$.ajax({
		            url: url,
		            type: 'POST',
		            error: function(){alert('您的网速有问题,如若网络正常。请联系管理员!');},
		            success: function(result){
		                document.getElementById(\""+divname+"\").innerHTML=result;
		            }
		        });
		}
		function "+upNavigationBarname+"(name){
			if("+arryname+".length<1){
				"+arryname+"[0]=name;
			}else{
				var bloo=0;
				var lenth="+arryname+".length;
				for(var i=0;i<lenth;i++){
					if(bloo==1) "+arryname+".pop();
					if("+arryname+"[i]==name) bloo=1;
										
				}
				for(var i=0;i<=lenth;i++){
					if(bloo!=1&&("+arryname+"[i]==\"\"||i==lenth)) "+arryname+"[i]=name;
				}
			}
		}
		window.load ="+setlistname+"(0,'首页',0);
	</script>";
	return css+html+script;
		
}
//获取数据集合
function getlisti(){
	
	var html ="";
	var rid=id;
	var typ=type;
	var tabname=tabe.split(",");
	var db = null;
		try {
			db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
			//非底层节点
			if(typ==0||typ==1){
				var sql = "select * from "+tabname[0]+" where REFID='"+id+"' ";
				var ds=db.QuerySQL(sql);
				if(ds.getRowCount() > 0){
					for(var i =0;i<ds.getRowCount();i++){
						var id= ds.getStringAt(i,"id");
						var name=ds.getStringAt(i,"name");
						var isleaf=ds.getStringAt(i,"isleaf");
						var imgurl="EAFormBlob.sp?guid=A93897F4D66A4D9BB9F0A0CFBC13EDF6";
						html+=gettalelist(id,isleaf,name,imgurl,setlistname);
						
					}
				}
				return html;
			}
			//已经是最底层节点
			else if(typ==2){

				var sql = "select * from "+tabname[1]+" where refid = '"+id+"'";
				var ds=db.QuerySQL(sql);
				if(ds.getRowCount() > 0){
					for(var i =0;i<ds.getRowCount();i++){
						var drug_name = ds.getValueAt(i,1);
						var manufacturer = ds.getValueAt(i,2);
						var collectdate = ds.getValueAt(i,3);
						var doseform = ds.getValueAt(i,4);
						var strength1 = ds.getValueAt(i,5);
						if(doseform == ""||doseform ==null)doseform = "&nbsp;&nbsp;&nbsp;";
						if(collectdate == ""||collectdate ==null)collectdate = "&nbsp;&nbsp;&nbsp;";
						if(drug_name == ""||drug_name ==null)drug_name = "&nbsp;&nbsp;&nbsp;";
						if(manufacturer == ""||manufacturer ==null)manufacturer = "&nbsp;&nbsp;&nbsp;";
						if(strength1 == ""||strength1 ==null)strength1= "&nbsp;&nbsp;&nbsp;";
						
						html += "<p style=\"line-height: 25px;\"><div  target='_blank'  ><font color:#00FF99><a href=\"#\" onclick=\""+setlistname+"("+ds.getValueAt(i,"id")+",'"+drug_name+"','3')\">"+drug_name+"</a></font></div></p>";
							
				
						html += "<p style=\"line-height: 25px;\"><font color='#333333'>"+ds.getColumnName(1)+":</font>"+drug_name+"</p>";
						html += "<p><font color='#333333'>"+ds.getColumnName(2)+":</font>"+manufacturer+"</p>";
						html += "<p><font color='#333333'>"+ds.getColumnName(3)+":</font>"+collectdate +"</p>";
						html += "<p><font color='#333333'>"+ds.getColumnName(4)+":</font>"+doseform +"</p>";
						html += "<p><font color='#333333'>"+ds.getColumnName(5)+":</font>"+strength1+"</p>";
				
						html += "<hr  size=1 style=\"COLOR: #ffd306;border-style:outset;width:800px;margin-right:25%\">";
					}
				}		
				return html;
			}
			else if(typ==3){

				var sb=new langpack.StringBuffer();
				var sql ="select * from "+tabname[2]+" where id = '"+id+"'";
				var ds=db.QuerySQL(sql);
				sb.append("<div >");
				for(var i =0;i<ds.getRowCount();i++){
					var title=ds.getValueAt(i,"title");
					var noteguid=ds.getValueAt(i,"note");
					if(i != 0){
						
						var hql = "select bdata from formblob  b where b.guid  = '"+noteguid+"'";
						var blo = db.getBlob2String(hql,"bdata");
						
						if(blo!=""){
							var a=srcprice(id,blo);
							if(a!="") blo=a;
							sb.append("<span>【"+title+"】</span>");
							sb.append("<div style=\"padding:25px 25px; width:800px;\"><font color='#666666'>"+blo +"</font></div>");
							sb.append("<hr  style=\"margin-right:25%;width:800px;\">");
						}
					}else{
						
						var hql = "select bdata from formblob  b where b.guid  = '"+noteguid+"'";
						var blo = db.getBlob2String(hql,"bdata");
						sb.append("<div style=\"margin-left:40%; width:800px;\"><font color='#CCCCCC'>"+blo+"</font></div>");
					}
				}				
				sb.append("</div>");
				return sb;
			}
		
		}catch ( ee ) {
			if(db!=null)db.Rollback();
			//sb.append(ee.toString());
			throw new pubpack.EAException ( ee.toString() );
			return "出现错误";
		}
		finally {
		
			if (db!="") db.Close();
		}
	return html;
}
//构造方块
function gettalelist(id,isleaf,name,img,setlistname){
	var html="";
	html += "<table style=\"width:110px;height:110px;cursor:pointer; float:left;margin:5px;background:url("+img+");\">";
	html += "<tr><td align=\"center\" onclick=\""+setlistname+"("+id+",'"+name+"',"+isleaf+")\"  ><font  size=\"3\" color=\"#666666\" >"+name+"</font>";
	html += "</td></tr></table>";
	return html;
}
//替换图片
//<img src="‘115100507.jpg‘">
function srcprice(docid,srcnam){
	
	var db = "";
	var sb="";
	try {
		db = new pubpack.EADatabase();
		
		var st="<img src=‘";
		var stix1=srcnam.indexOf(st);
		if(stix1==-1) return "";
		var a=srcnam.split(st);
		var jsidx=0;
		if(a.length()>2){
			for(var i=1;i<=a.length()-1;i++){
				
				stix1=srcnam.indexOf(st,jsidx);
				stix1=stix1+st.length();
				var stix2=srcnam.indexOf("‘></img>",stix1);
				jsidx=stix2;
				var sr=srcnam.substring(stix1,stix2);
				
				
				var sql="select pic_jpg from cdms_notepic where name='"+sr+"' and doc_id='"+docid+"'";
				var ds=db.QuerySQL(sql);
				var guid = ds.getStringAt(0,"pic_jpg");
				
				sb = pubpack.EAFunc.regexReplace(srcnam,"‘"+sr+"‘","EAFormBlob.sp?guid="+guid);
				srcnam=sb;
			}
		}
		else{
			stix1=stix1+st.length();
			var stix2=srcnam.indexOf("‘></img>");
			var sr=srcnam.substring(stix1,stix2);
			var sql="select pic_jpg from cdms_notepic where name='"+sr+"' and doc_id='"+docid+"'";
			var ds=db.QuerySQL(sql);
			var guid = ds.getStringAt(0,"pic_jpg");
			sb = pubpack.EAFunc.regexReplace(srcnam,"‘"+sr+"‘","EAFormBlob.sp?guid="+guid);
		}
		
	}catch ( ee ) {
		db.Rollback();
		//sb.append(ee.toString());
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!="") db.Close();
	}
	return sb;

	
}

function getLogin()
{
	var ds = null;
	var sql = ""; 
	var usrid = "";
	var style = "";
	var html = "";

	try {
		db = new pubpack.EADatabase();
		
		//取request教师编号
		usrid =pubpack.EAFunc.NVL( request.getParameter("tid"),"");
		
		///取session登录教师编号
		if (usrid == null || usrid == "") {
			var usrinfo = web.EASession.GetLoginInfo(request);
			usrid = usrinfo.getUsrid();
			if(usrid =="xlsgrid") usrid ="040381";
		}
		
		sql = "select name from (select id,name from APO_FUL UNION ALL select id,name from APO_EXT ) where id='"+usrid+"'";
		ds = db.QuerySQL(sql);
		
		var aponame = ds.getStringAt(0,"NAME");
		html = "<table border=\"0\"><tr><td align=\"right\">欢迎您，"+aponame +"   | </td><td id='td1' class='td1' align=\"left\" onclick='window.close();'><font style='color:#097eb6'>退出</font></td></tr></table>";
		style = "<style> 
		.td1{ cursor: hand; } 
		</style>";

	}catch ( ee ) {
		db.Rollback();
		//sb.append(ee.toString());
		throw new pubpack.EAException (ee.toString());
	}
	finally {
		if (db!="") db.Close();
	}
	return html+style;
}
 

}