function x_L_SCROLLIMG(){function GetBody(){
//	var html="<table width='100%'><tr><td><div class=\"imgdiv\"><div class=\"imageRotation\" id=\"imageRotation\">
//		    <div class=\"imageBox\">";
		    
	var html = "<div style\"width:100%;\" id=\"evewidth\"><div class=\"imgdiv\" id=\"eve\" ><div class=\"imageRotation\" id=\"imageRotation\">
		    <div class=\"imageBox\" >";

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
		html+= "<a href='"+xml.getStringAt(i,"url")+"&layhdrguid="+xml.getStringAt(i,"GUID")+"' ><img src="+xml.getStringAt(i,"icon")+" width=\"100%\"></a>";
		if(i==0)
			spn+="<span class=\"active\" rel=\""+(i+1)+"\"><img src="+xml.getStringAt(i,"icon2")+" width=\"100%\"></span>";
		else
			spn+="<span  rel=\""+(i+1)+"\"><img src="+xml.getStringAt(i,"icon2")+"  width=\"100%\"></span>";
	}
	//html+="</div>"+ "<div class=\"icoBox\">"+spn+ "</div>"+"</div></div></tr></td></table>";
	html+="</div>"+ "<div class=\"icoBox\">"+spn+ "</div>"+"</div></div></div>";

//	html+="<script type=\"text/javascript\" src=\"http://www.itxueyuan.org/uploads/javascript/jquery.js\"></script>";
	
	var css="<style type=\"text/css\">
		.imgdiv{
			width:100%;
			height:350px;
//			border:1px solid #BBBBBB;
			position:relative;
//			clear:both;
		}
		.imageRotation{
			overflow:hidden;  /*--超出容器的所有元素都不可见--*/
		}
		.imageBox{
			position: relative;
		}
		.imageBox img {
			display:block;
			float:left;
			border:none;
		}
		.icoBox{
			position:absolute;  /*--固定定位--*/
			top:5px;
			text-align:center;
			line-height:40px;
			float:left;
		}
		.icoBox span{
			display:block;
			float:top;
			margin-top:4px;
			margin-left:0px;
			margin-right:0px;
			overflow:hidden;
			background:url(\"\") 0px 0px no-repeat;
			cursor:pointer;
		}
		.icoBox span.active {
			background-position:0px -12px;
			cursor:default;
		}
		</style>";
	var jvaspt="<script type=\"text/javascript\">			
			
			$(document).ready(function (){
				$(\".imageRotation\").each(function(){
					var dvwid=$('.imgdiv').width();
					var dvhid=$('.imgdiv').height();
					var img2w=dvwid/6;
					var img2h=dvhid/10;
					$('.imageRotation').width(dvwid);
					$('.imageRotation').height(dvhid);
					$('.icoBox').css({'right':0});
					$('.imageBox img').width(dvwid);
					$('.imageBox img').height(dvhid);
					
					$('.icoBox span').height(dvhid/6);
					$('.icoBox span').width(dvwid/10);
					$('.icoBox span img').height(dvhid/6);
					$('.icoBox span img').width(dvwid/10);
					var imageRotation = this,
					imageBox = $(imageRotation).children(\".imageBox\")[0],
					icoBox = $(imageRotation).children(\".icoBox\")[0],
					icoArr = $(icoBox).children(),
					imageWidth =  $(\".imageBox img\").width(),
					imageNum = $(imageBox).children().size(),
					imageReelWidth = imageWidth*imageNum,
					activeID = parseInt($($(icoBox).children(\".active\")[0]).attr(\"rel\")),
					nextID = 0, 
					setIntervalID,  
					intervalTime = 4000,
					speed =500;
					$(imageBox).css({'width' : imageReelWidth + \"px\"});
					
			
					var rotate=function(clickID){
					if(clickID){ nextID = clickID; }
					else{ nextID=activeID<=3 ? activeID+1 : 1; }
					
					$(icoArr[activeID-1]).removeClass(\"active\");
					$(icoArr[nextID-1]).addClass(\"active\");
					 $(imageBox).animate({left:\"-\"+(nextID-1)* $(\".imageBox img\").width()+\"px\"} , speed);
					$(icoArr[nextID-1]).addClass(\"active\").css({'border':'3px solid red'});
					$(icoArr[activeID-1]).addClass(\"active\").css({'border':'0px solid red'});
					activeID = nextID;
					};
					setIntervalID=setInterval(rotate,intervalTime);
					
					$(imageBox).hover(
					function(){ clearInterval(setIntervalID); },
					function(){ setIntervalID=setInterval(rotate,intervalTime); }
					);
					
					$(icoArr).click(function(){
						clearInterval(setIntervalID);
						var clickID = parseInt($(this).attr(\"rel\"));
						rotate(clickID);
						setIntervalID=setInterval(rotate,intervalTime);
					});
				});
			});

			//窗口较小的时候自动改变宽度
			window.onload = function(){
				eve();
			}
			
			//窗口宽度大小改变
			function eve() {
				var widthImg = document.body.scrollWidth * 0.8 * 0.57;
				if(document.body.scrollWidth >= 960){
					document.getElementById(\"eve\").style.width=widthImg +\"px\";
					document.getElementById(\"imageRotation\").style.width=widthImg+\"px\" ;
				}else{
					widthImg = 960 * 0.8 * 0.57;
					document.getElementById(\"eve\").style.width=widthImg +\"px\";
					document.getElementById(\"imageRotation\").style.width=widthImg +\"px\" ;
				}
				
			}
			

			fEventListen(window, 'resize',eve);
			function fEventListen(b,c,d,a){
			a=!!a;if(b.addEventListener)
			{b.addEventListener(c,d,a);}
			else{
				if(b.attachEvent)
				{b.attachEvent(\"on\"+c,d);}}
			}
			</script>";
	html+=jvaspt;
//	throw new Exception(html);
	return css+html;

}
}