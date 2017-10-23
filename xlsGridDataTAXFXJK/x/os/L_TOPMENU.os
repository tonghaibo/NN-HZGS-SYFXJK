function x_L_TOPMENU(){

















function GetBody(){
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
}