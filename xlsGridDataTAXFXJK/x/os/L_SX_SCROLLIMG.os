function x_L_SX_SCROLLIMG(){function GetBody(){
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
}