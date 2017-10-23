function x_L_retrieve(){function GetBody(){
	var html = menu();
	return html;
}

function menu(){
	var html ="<style type=\"text/css\">
		.nav_a { 
		color: #FFFFFF;
		cursor: pointer;
		float: left;
		font-size: 14px;
		height: 40px;
		line-height: 40px;
		margin-right: 2px;
		padding: 0px 15px;
		position: relative;
		}
		
		.nav { 
		height: 40px;
		margin: 0px auto;
		width: 1002px;
		}
		.nav .on { 
		background-color: #FFFFFF;
		color: #F94262;
		font-weight: 700;
		}

		</style>
		<div style=\"width:100%;height:69px;background-color: #9900FF\">
			
		</div>
		<div style=\"background-color: #9933FF;\">
		  <div class=\"nav\" id=\"dr\">
		    <a class=\"nav_a on\"  id=\"ck1\" onclick=\"clickon('ck1','药品说明书','cka')\">药品说明书</a>
		    <a  class=\"nav_a\" id=\"ck2\" onclick=\"clickon('ck2','药物专论','ckb')\">药物专论</a>
		    <a  class=\"nav_a\" id=\"ck3\" onclick=\"clickon('ck3','药物相互作用','ckc')\">药物相互作用</a>
		    <a class=\"nav_a\" id=\"ck4\" onclick=\"clickon('ck4','配伍禁忌','ckd')\">配伍禁忌</a>
		    <div style=\"display:none;\">
		    </div>
		<input type=\"hidden\" value=\"药品说明书\" id=\"his\" />
		<div style=\"float:right;margin-top:5px;\">
		<input type=\"text\" style=\"height:24px;\" name=\"wd\"  id=\"kw1\" size=\"40\"  autocomplete=\"off\"/>
		<input type=\"button\" style=\"background:none; border:0px;  color:#FFFFFF; height:30px;width:70px;\" onclick=\"likedru()\"  value=\"搜 索\">
		</div>
		  </div>
		</div>";
		html +="<script type=\"text/javascript\">
		//模糊搜索
		function likedru(){
			var va = document.getElementById(\"his\").value;
		
			var likename = document.getElementById(\"kw1\").value;
			if(va == \"药品说明书\"){
			}else if(va == \"药物专论\"){
			
			}else if(va == \"药物相互作用\"){
		
				$.ajax({
				url: 'http://cdms.xmidware.com/aca/x.L_TreeNode.like.osp?likename='+likename+'&ty'+va,
				type: 'POST',
				error: function(){alert('Error loading PHP document');},
				success: function(result){
				document.getElementById(\"dru\").innerHTML=result;
				}
				});

			}else{
			}

			
		}
		
		function clickon(id,va,cid){
		
		document.getElementById(\"inp\").value =\"\";
		document.getElementById(\"dru\").innerHTML =\"\";
		document.getElementById(\"tree\").innerHTML =\"\";
		if(va == \"药品说明书\"){
	
		document.getElementById(\"frist\").innerHTML =\"<div onclick='tree(0,0)' style='width:100px;height:20px;'><font>药理分类</font></div>\";
		if(document.getElementById(\"hidde\").innerHTML !=\"\"){
			document.getElementById(\"hidde\").innerHTML ='<a onclick=\"tree(0,0)\"><font>药理分类></font></a><input value=\"0\" type=\"hidden\">';
		}

		}else if(va == \"药物专论\"){
		document.getElementById(\"frist\").innerHTML =\"<div onclick='tree(0,1)' style='width:100px;height:20px;'><font>药理分类</font></div>\";
		if(document.getElementById(\"hidde\").innerHTML !=\"\"){
			document.getElementById(\"hidde\").innerHTML ='<a onclick=\"tree(0,1)\"><font>药理分类></font></a><input value=\"0\" type=\"hidden\">';
		}
		}else if(va == \"药物相互作用\"){
		document.getElementById(\"frist\").innerHTML =\"\";
		document.getElementById(\"hidde\").innerHTML =\"\";
		}else{
		document.getElementById(\"frist\").innerHTML =\"\";
		document.getElementById(\"hidde\").innerHTML =\"\";
		}
		
		document.getElementById(\"his\").value =va;
		var b = document.getElementById('dr').getElementsByTagName('a');
		
		for(var i = 0;i<b.length;i++){
			
			b[i].className=\"nav_a\";
		}
	
		document.getElementById(id).className=\"nav_a on\";
		}
		</script>";


		return html;
	
}
}