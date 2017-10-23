function x_showflg_pig(){
//左右滚动图片右边带小视图
function lscrollimg(){
var html ="<style type=\"text/css\">
		/* Reset style */
		* { margin:0; padding:0; word-break:break-all; }
		body { background:#FFF; color:#333; font:12px/1.6em Helvetica, Arial, sans-serif; }
		h1, h2, h3, h4, h5, h6 { font-size:1em; }
		a { color:#039; text-decoration:none; }
		 a:hover { text-decoration:underline; }
		ul, li { list-style:none; }
		fieldset, img { border:none; }
		em, strong, cite, th { font-style:normal; font-weight:normal; }
		/* Focus_change style */
		
		 #focus_change_list li { float:left; }
		
		 #focus_change_btn ul { padding-left:5px; }
		 #focus_change_btn li { display:inline; float:left; margin:0 15px; padding-top:12px; }
		 #focus_change_btn li img {border:2px solid #888;}
		
		 #focus_change_btn .current img { border-color:#EEE; }
		</style>";
		
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
	
		
	
	html += "<script type=\"text/javascript\">

		function $a(id) { return document.getElementById(id); }
		function moveElement(elementID,final_x,final_y,interval) {
	
		 if (!document.getElementById) return false;
		 if (!document.getElementById(elementID)) return false;
		 var elem = document.getElementById(elementID);
		 if (elem.movement) {
		 clearTimeout(elem.movement);
		 }
		 if (!elem.style.left) {
		 elem.style.left = \"0px\";
		 }
		 if (!elem.style.top) {
		 elem.style.top = \"0px\";
		 }
		 var xpos = parseInt(elem.style.left);
		 var ypos = parseInt(elem.style.top);
		 if (xpos == final_x && ypos == final_y) {
		 return true;
		 }
		 if (xpos < final_x) {
		 var dist = Math.ceil((final_x - xpos)/10);
		 xpos = xpos + dist;
		 }
		 if (xpos > final_x) {
		 var dist = Math.ceil((xpos - final_x)/10);
		 xpos = xpos - dist;
		 }
		 if (ypos < final_y) {
		 var dist = Math.ceil((final_y - ypos)/10);
		 ypos = ypos + dist;
		 }
		 if (ypos > final_y) {
		 var dist = Math.ceil((ypos - final_y)/10);
		 ypos = ypos - dist;
		 }
		 elem.style.left = xpos + \"px\";
		 elem.style.top = ypos + \"px\";
		 var repeat = \"moveElement('\"+elementID+\"',\"+final_x+\",\"+final_y+\",\"+interval+\")\";
		 elem.movement = setTimeout(repeat,interval);
		}
		function classNormal(){
		
		 var focusBtnList = $a('focus_change_btn').getElementsByTagName('li');
		 for(var i=0; i<focusBtnList.length; i++) {
		 focusBtnList[i].className='';
		 }
		}
		function focusChange() {

			var focusBtnList = $a('focus_change_btn').getElementsByTagName('li');
			
			var widthImg = document.body.scrollWidth * 0.8 * 0.57;
			if(!document.body.scrollWidth >= 960){
				 widthImg = 960 * 0.8 * 0.57;
			}
		 	focusBtnList[0].onmouseover = function() {
			moveElement('focus_change_list',-widthImg * 0,0,5);
			classNormal()
			focusBtnList[0].className='current'
			 
			}			 
			 focusBtnList[1].onmouseover = function() {
			 moveElement('focus_change_list',-widthImg ,0,5);
			 classNormal()
			 focusBtnList[1].className='current'
			 }
			 focusBtnList[2].onmouseover = function() {
			 moveElement('focus_change_list',-widthImg *2,0,5);
			 classNormal()
			 focusBtnList[2].className='current'
			 }
			 focusBtnList[3].onmouseover = function() {
			 moveElement('focus_change_list',-widthImg *3,0,5);
			 classNormal()
			 focusBtnList[3].className='current'
			 }
			 focusBtnList[4].onmouseover = function() {
			 moveElement('focus_change_list',-widthImg *4,0,5);
			 classNormal()
			 focusBtnList[4].className='current'
			 }
			}
		setInterval('autoFocusChange()', 4000);
		function autoFocusChange() {
			
			 var focusBtnList = $a('focus_change_btn').getElementsByTagName('li');
			 for(var i=0; i<focusBtnList.length; i++) {
				 if (focusBtnList[i].className == 'current') {
				 var currentNum = i;
				 }
			 }
				 var widthImg = document.body.scrollWidth * 0.8 * 0.57;
				if(!document.body.scrollWidth >= 960){
					widthImg = 960 * 0.8 * 0.57;
				}
			 if (currentNum==0 ){
			 moveElement('focus_change_list',-widthImg ,0,5);
			 classNormal()
			 focusBtnList[1].className='current'
			 }
			 if (currentNum==1 ){
			 moveElement('focus_change_list',-widthImg *2,0,5);
			 classNormal()
			 focusBtnList[2].className='current'
			 }
			 if (currentNum==2 ){
			 moveElement('focus_change_list',-widthImg *3,0,5);
			 classNormal()
			 focusBtnList[3].className='current'
			 } 
			 if (currentNum==3 ){
			 moveElement('focus_change_list',-widthImg *4,0,5);
			 classNormal()
			 focusBtnList[4].className='current'
			 }
			if (currentNum==4 ){
			 moveElement('focus_change_list',0,0,5);
			 classNormal()
			 focusBtnList[0].className='current'
			 }
		}
		

		window.onload=function(){
		  focusChange();
		   eve();
		}
		</script>";

	html += "<div id=\"focus_change\" style=\" position:relative; height:350px;width:100%; overflow:hidden;\">
		 <div id=\"focus_change_list\" style=\"top:0; left:0; position:absolute; height:350px;\">
		 <ul>";
		for(var i=0;i<cnt;i++){
		if(i==0)
			html += "<li class=\"current\"><a href='"+xml.getStringAt(i,"url")+"&layhdrguid="+xml.getStringAt(i,"GUID")+"' ><img src="+xml.getStringAt(i,"icon")+" id='imgpx0' style=\"height:350px;\"  alt=\"\" ></a>";
		else
			html += "<li><a href=\"#\"><a href='"+xml.getStringAt(i,"url")+"&layhdrguid="+xml.getStringAt(i,"GUID")+"' ><img src="+xml.getStringAt(i,"icon")+" id='imgpx"+i+"'  style=\" height:350px;\"  alt=\"\" ></a>";
		}
	html +=	 "</ul>
		 </div>
		 <div  style=\"position:absolute; width:65px; height:100%; top:0; right:0; background:#000; filter:alpha(opacity=50); -moz-opacity:0.5; opacity: 0.5; \"></div>
		 <div id=\"focus_change_btn\" style=\"position:absolute; width:60px; height:100%;  bottom:0; right:20px;_right:-11px;\">
		 <ul>";
		 for(var i=0;i<cnt;i++){
		 if(i==0)
			html += "<li class=\"current\"><a href='"+xml.getStringAt(i,"url")+"&layhdrguid="+xml.getStringAt(i,"GUID")+"' ><img src="+xml.getStringAt(i,"icon2")+" style=\"width:50px; height:50px;\"   alt=\"\" ></a>";
		 else
			html += "<li><a href=\"#\"><a href='"+xml.getStringAt(i,"url")+"&layhdrguid="+xml.getStringAt(i,"GUID")+"' ><img src="+xml.getStringAt(i,"icon2")+" style=\"width:50px; height:50px;\"   alt=\"\" ></a>";
		 }
	html +=	"</ul>
		 </div>
		 </div>";
		
	html += "<script type=\"text/javascript\">


		
		//窗口宽度大小改变
		function eve() {
			var widthImg = document.body.scrollWidth * 0.8 * 0.57;
			if(document.body.scrollWidth >= 960){
				document.getElementById(\"focus_change\").style.width=widthImg +\"px\";		
				document.getElementById('imgpx0').style.width=widthImg +\"px\";			
				document.getElementById('imgpx1').style.width=widthImg +\"px\";
				document.getElementById('imgpx2').style.width=widthImg +\"px\";
				document.getElementById('imgpx3').style.width=widthImg +\"px\";
				document.getElementById('imgpx4').style.width=widthImg +\"px\";

				document.getElementById(\"focus_change_list\").style.width=4000+\"px\" ;
			}else{
				widthImg = 960 * 0.8 * 0.57;
				
				
				document.getElementById(\"focus_change\").style.width=widthImg +\"px\";
				document.getElementById('imgpx0').style.width=widthImg +\"px\";
				document.getElementById('imgpx1').style.width=widthImg +\"px\";
				document.getElementById('imgpx2').style.width=widthImg +\"px\";
				document.getElementById('imgpx3').style.width=widthImg +\"px\";
				document.getElementById('imgpx4').style.width=widthImg +\"px\";
				document.getElementById(\"focus_change_list\").style.width=4000+\"px\" ;
			}
		}
		

		fEventListen(window, 'resize',eve);
		function fEventListen(b,c,d,a){
		a=!!a;if(b.addEventListener)
		{b.addEventListener(c,d,a);}
		else{
			if(b.attachEvent)
			{b.attachEvent(\"on\"+c,d);}}
		}</script>";
	return html;

}

//上下滚动图片
function sxscrollimg(){
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

//W8风格商品显示
function w8item(){
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

//图文标题加省略内容
function imgtext(){

var html = "";
	var sql = "select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' order by crtdat desc "  ;
	
	var ds=db.QuerySQL(sql);
	var count =0;
	if(ds.getRowCount()>LAYROW){
		count = LAYROW;
	}else{
		count = ds.getRowCount();
	}
	
	for (var r =0;r < count; r ++) {
		var txt = "txt";
		var img = ds.getStringAt(r,"icon");
		var name = ds.getStringAt(r,"name");
		var htmlguid=ds.getStringAt(r,"htmlguid");
		var contextes=ds.getStringAt(r,"contextes");
		var context = db.getBlob2String("select b.bdata from LSYSURL a,formblob b where a.htmlguid=b.guid and a.htmlguid='"+htmlguid+"'","bdata");

		var url = ds.getStringAt(r,"url");
		if (url != "") {
			url += "&layhdrguid="+ds.getStringAt(r,"GUID");
		}
		txt=txt+r;
		html += "<table valign=\"top\" cellpadding=\"5\">";
		html += "<tr>";
		html += "<td><img src=\""+img+"\" width=\"200\" height=\"200\"/></td>";
		html += "<td valign=\"top\">";
		html += "<table  width=\"100%\">";
		html += "<tr>";
		html += "<td><h3>"+name+"</h3></td>";
		html += "</tr>";
		html += "<tr>";
		html += "<td height=\"40\"></td>";
		html += "</tr>";
		html += "<tr>";
		html += "<td id=\""+txt+"\">";
		html += "<a href=\""+url+"\">"+contextes+"</a>";	
		html += "</td>";
		html += "</tr>";
		html += "</table>";
		html += "</td>";
		html += "</tr>";
		html += "<tr>";
		html += "<td colspan=2><hr style=\"border-top:1px dashed #cccccc; height:1px\"></td>";
		html += "</tr>";
		html += "</table>";
	}

//	html += "
//			<script>
//				window.onload = function(){
//					for (var r=0;r<"+count+";r++) {
//						var txt = \"txt\";
//						txt=txt+r;
//						 var text = document.getElementById(txt),
//						 str = text.innerHTML,
//						 textLeng = 400;
//					
//						 if(str.length > textLeng ){
//							   text .innerHTML = str.substring(0,textLeng)+\"。。。。\";
//						 } 
//					 }
//				 }
//			 </script>
//			";
//
	return html;

}

function picsw(){
//	var iconwidth="";
//	var iconheight="";
//	var space ="";
//	var time="";
	var html="";
	//width:1342px;
	html="<style type=\"text/css\"> 
		img{border:0;}
		a{text-decoration:none;}
		a:hover{text-decoration:underline;}
		li{list-style:none; list-style-image:none; list-style-type:none;}
		.rollBox{width:"+iconwidth+"px;overflow:hidden;padding:0;margin:0 auto; }
		.rollBox .Cont{width:1342px;overflow:hidden;float:left;}
		.rollBox .ScrCont{width:10000000px;}
		.rollBox .Cont .pic{float:left;text-align:center; margin-right:0px;}
		.rollBox .Cont .pic img{display:block; margin-bottom:7px;}
		.rollBox #List1,.rollBox #List2{float:left;}
		</style>";
		
		if(LAYCOL =="")LAYCOL ="1";
		var sql = "select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' and icon is not null "  ;
		if(WHEREBY!="" ) sql+= " AND " +WHEREBY;
		if(SORTBY!="" ) sql+= " "+SORTBY;
		else sql+= " order by crtdat desc ";
		if(LAYCOL !=""&& LAYROW!="" ) sql+=") where  rownum<"+LAYCOL+"*"+LAYROW;
		
		  
		var xml=db.QuerySQL(sql);
		var spn="";
		var cnt=xml.getRowCount();
		 
		html+="<div class=\"rollBox\">
		     <div class=\"LeftBotton\" onmousedown=\"ISL_GoUp()\" onmouseup=\"ISL_StopUp()\" onmouseout=\"ISL_StopUp()\"></div>
			  <div class=\"Cont\" id=\"ISL_Cont\">
			       <div class=\"ScrCont\">
				<div id=\"List1\">";
					      for(var i=0;i<cnt;i++){
					      	html+="<div class=\"pic\"><a href=\""+xml.getStringAt(i,"url")+"&layhdrguid="+xml.getStringAt(i,"HTMLGUID")+"\"><img src=\""+xml.getStringAt(i,"icon")+"\" style=\"width:100%;height:auto;max-width=:100%;height=:auto;\"/></a></div>";//width="+iconwidth+" height="+iconheight+"
					      }																				
				 html+= " </div>
			      <div id=\"List2\"></div>
		            </div>
		    	 </div>
		     <div class=\"RightBotton\" onmousedown=\"ISL_GoDown()\" onmouseup=\"ISL_StopDown()\" onmouseout=\"ISL_StopDown()\"></div>
		    </div>
		 </div>";
		 
		 
		html+="<script language=\"javascript\" type=\"text/javascript\"> 
		var Speed = 0; //速度(毫秒)
		var Space = 1342; //每次移动(px)
		var PageWidth = 1; //翻页宽度 
		var fill = 0; //整体移位 
		var MoveLock = false; 
		var MoveTimeObj; 
		var Comp = 0;
		var AutoPlayObj = null;
		GetObj(\"List2\").innerHTML = GetObj(\"List1\").innerHTML;
		GetObj('ISL_Cont').scrollLeft = fill;
		GetObj(\"ISL_Cont\").onmouseover = function(){clearInterval(AutoPlayObj);}
		GetObj(\"ISL_Cont\").onmouseout = function(){AutoPlay();}
		AutoPlay();
		function GetObj(objName){if(document.getElementById){return eval('document.getElementById(\"'+objName+'\")')}else{return eval('document.all.'+objName)}}
		function AutoPlay(){ //自动滚动
		 clearInterval(AutoPlayObj);
		 AutoPlayObj = setInterval('ISL_GoDown();ISL_StopDown();',"+time+"); //间隔时间
		}
		function ISL_GoUp(){ //上翻开始
		 if(MoveLock) return;
		 clearInterval(AutoPlayObj);
		 MoveLock = true;
		 MoveTimeObj = setInterval('ISL_ScrUp();',Speed); 
		} 
		function ISL_StopUp(){ //上翻停止
		 clearInterval(MoveTimeObj); 
		 if(GetObj('ISL_Cont').scrollLeft % PageWidth - fill != 0){
		  Comp = fill - (GetObj('ISL_Cont').scrollLeft % PageWidth);
		  CompScr();
		 }else{
		  MoveLock = false;
		 }
		 AutoPlay();
		}
		function ISL_ScrUp(){ //上翻动作
		 if(GetObj('ISL_Cont').scrollLeft <= 0){GetObj('ISL_Cont').scrollLeft = GetObj('ISL_Cont').scrollLeft + GetObj('List1').offsetWidth}
		 GetObj('ISL_Cont').scrollLeft -= Space ;
		}
		function ISL_GoDown(){ //下翻
		 clearInterval(MoveTimeObj);
		 if(MoveLock) return; 
		 clearInterval(AutoPlayObj);
		 MoveLock = true;
		 ISL_ScrDown();
		 MoveTimeObj = setInterval('ISL_ScrDown()',Speed);
		}
		function ISL_StopDown(){ //下翻停止
		 clearInterval(MoveTimeObj);
		 if(GetObj('ISL_Cont').scrollLeft % PageWidth - fill != 0 ){
		  Comp = PageWidth - GetObj('ISL_Cont').scrollLeft % PageWidth + fill;
		  CompScr();
		 }else{
		  MoveLock = false;
		 }
		 AutoPlay();
		}
		function ISL_ScrDown(){ //下翻动作
		 if(GetObj('ISL_Cont').scrollLeft >= GetObj('List1').scrollWidth){GetObj('ISL_Cont').scrollLeft = GetObj('ISL_Cont').scrollLeft - GetObj('List1').scrollWidth;}
		 GetObj('ISL_Cont').scrollLeft += Space ;
		}
		function CompScr(){
		 var num;
		 if(Comp == 0){MoveLock = false;return;}
		 if(Comp < 0){ //上翻
		  if(Comp < -Space){
		   Comp += Space;
		   num = Space;
		  }else{
		   num = -Comp;
		   Comp = 0;
		  }
		  GetObj('ISL_Cont').scrollLeft -= num;
		  setTimeout('CompScr()',Speed);
		 }else{ //下翻
		  if(Comp > Space){
		   Comp -= Space;
		   num = Space;
		  }else{
		   num = Comp;
		   Comp = 0;
		  }
		  GetObj('ISL_Cont').scrollLeft += num;
		  setTimeout('CompScr()',Speed);
		 }
		}
	</script>";
	
	return html;
}

//二级菜单栏
function menu(){
	var typ =DSMOD ;
	var ds=db.QuerySQL("select * from lsysurl where org='"+deforg+"' and refid='"+typ+"' ");
	var div="";
	var iframe="";
	var rowcnt=ds.getRowCount();
	var pindd="15px";
	
	if(V_PADDING!="") pindd=V_PADDING;

	var st = new Array(); 
	var cdcnt = db.GetSQL("select CDMSSMCNT.Nextval CNT from dual");
	if(selfontcolor=="")selfontcolor="#333333";
	var css="<style>
		    .nav_a"+cdcnt+" {
		        color: "+fontcolor+";
		        cursor: pointer;
		        float: left;
		        font-size: 15px;
		        height: "+height+";
		        line-height: "+height+";
		        padding: 0px "+pindd+";
		        position: relative;

		    }
		
		    .nav"+cdcnt+" {
		        height:"+height+";
		
		    }
		    .nav"+cdcnt+" .on {
		        background-color:"+onclickcolor+";
		        background-image:url("+ck_bgimg+");
		        background-size:100% 100%;
		        color: "+selfontcolor+";
		    }
		    #dr"+cdcnt+" div:hover{
		        cursor:pointer;
		        background:"+hovercolor+";
		        color:#FF0000;";
		        if(bg_img!=null||bg_img!=""){
		        	css+="background-image:url("+bg_img+");";
		        }
	css += "}</style>";
	if (MENUID == "") MENUID = request.getParameter("MENUID");
	var menulog = MENUID;
	for(var i=0; i<rowcnt;i++){
		var id=ds.getStringAt(i,"id")+cdcnt;
		var name=ds.getStringAt(i,"name");
		var url=ds.getStringAt(i,"url");
		if(url!="") url+="&MENUID="+ds.getStringAt(i,"id");
		var target=ds.getStringAt(i,"target");

		st[i]=id;
		var onmo="";
		if(menulog+cdcnt==id)
			div+="<DIV onclick=\"swithpage"+typ+cdcnt+"(this.id,'"+url+"','"+target+"')\" "+onmo+" id="+id+" class=\"nav_a"+cdcnt+" on\">"+name+"</DIV>";
		else
			div+="<DIV onclick=\"swithpage"+typ+cdcnt+"(this.id,'"+url+"','"+target+"')\" "+onmo+" id="+id+" class=\"nav_a"+cdcnt+"\">"+name+"</DIV>";
	}

	var padding="";
	
//	if(typ=="NEW_MENU_1") return menulog+"-----------------------------我是分割线-----------------------";
	if(paddingleft!="")  padding="PADDING-LEFT:"+paddingleft+";"; else if(paddingleft==""&&paddingright=="")  padding="PADDING-LEFT:0px"; else padding="PADDING-RIGHT:"+paddingleft+";";
	var bgcolorimg="";
	if(bgcolor_img!=null) bgcolorimg="background-image:url("+bgcolor_img+");";
	var html="<div style=\"OVERFLOW: hidden; "+padding+" BACKGROUND-COLOR: "+bgcolor+"; "+bgcolorimg+");\"><DIV id=dr"+cdcnt+" class=nav"+cdcnt+" style=\"FLOAT: left\">"+div+"</div></div>";
	var script="<script>
			function swithpage"+typ+cdcnt+"(frameid,url,target){
				if(target=='_blank')
					window.open(url);
				else window.location.href=url;
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

}