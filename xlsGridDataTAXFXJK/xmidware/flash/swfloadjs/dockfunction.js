// JavaScript Document
function onResize(event){
	$("#mydock").css("height",$(window).height());
}
function f_openWindow(x,y,w,h,url,guid,caption){
	var webWindow=new newWindow(x,y,w,h,url,guid,caption);
	webWindowArray.push(webWindow);
}
function JScomplete(){
	//AS已经装载了回调函数
}

//as 接口 将屏幕转移到哪个屏幕上
function f_toScreenId(index){
	if(getDockId()!=null){getDockId().f_toScreenId(index)}
	}

function getDomainName(url){
	if(url==null){return ""}
	var _url=new String(url);
	var $url=new String(_url.toLowerCase());
	if($url.substr(0,7)=="http://"){
		$url=_url.substr(7)
	}else if($url.substr(0,8)=="https://"){
		$url=_url.substr(8)
	}else{return ""}
	if($url.indexOf("/")>0){
		$url=$url.substr(0,$url.indexOf("/"))
	}
	return $url
}

var flashObject=null;//Flash控件ID
function getDockId(){
	if(flashObject!=null && flashObject!=undefined){return flashObject}
	if($.browser.msie){
		flashObject=window["mydock"];
		}else{
		flashObject=document["mydock"];
	}
	return flashObject;
}

//JS 方法，使得移动更加平滑
function moveAndMask(isshow){
	for(var i=webWindowArray.length-1;i>=0;i--){
		var obj=$(webWindowArray[i]);
		if(obj==null || obj.attr("guid")==null || obj.attr("mask")==null ){
				webWindowArray.splice(i,1)
			}else{
				if(isshow){obj.attr("mask").show()}else{obj.attr("mask").hide()}
		}
	}
}

//JS 接口 还原一个窗口
function openIcon(guid){
	for(var i=webWindowArray.length-1;i>=0;i--){
		var obj=$(webWindowArray[i]);
		if(obj==null || obj.attr("guid")==null || obj.attr("web")==null ){
				webWindowArray.splice(i,1)
			}else if(obj.attr("guid")==guid){
				top_zIndex++;
				obj.attr("web").css("z-index",top_zIndex).slideDown(100);
		}
	}
}

//JS 接口 关闭一个窗口
function closeIcon(guid){
	for(var i=webWindowArray.length-1;i>=0;i--){
		var obj=$(webWindowArray[i]);
		if(obj==null || obj.attr("guid")==null || obj.attr("web")==null){
			webWindowArray.splice(i,1)
		}else if(obj.attr("guid")==guid){
			obj.attr("web").hide(200,function (event){
				if(getDockId()!=null){getDockId().f_closeWindow(guid)}
				$("#webWindow_"+guid).remove();
			})
			webWindowArray.splice(i,1);
		}
	}
}

function webGoBack(iframe){
	try{
		var currentPagNum = iframe.contentWindow.history.position;
    	var maxPagNum = iframe.contentWindow.history.length;
		alert(currentPagNum+"--"+maxPagNum)
		if(currentPagNum>0){iframe.contentWindow.history.back()}
	}catch(e){
		alert("无法完成后退操作！")	
	}
}

//获得web窗口数量
function getWebWindowCount(){
	var webCount=0;
	for(var i=webWindowArray.length-1;i>=0;i--){
		var obj=$(webWindowArray[i]);
		if(obj==null || obj.attr("guid")==null || obj.attr("web")==null){webWindowArray.splice(i,1)}else{webCount++}
	}
	return webCount;
}

//web窗口排序
function setWebWindow(){
	var webWindowCount=getWebWindowCount();
	var margin=$(window).height()/webWindowCount;
	if(margin<40){margin=40}
	for(var i=0;i<webWindowArray.length;i++){
		var obj=$(webWindowArray[i]);
		if(obj==null || obj.attr("web")==null){webWindowArray.splice(i,1)}else{top_zIndex++;
			obj.attr("web").css("z-index",top_zIndex).animate({left:10,top:40+i*margin},200);
		}
	}
}

function newWindow(_x,_y,_w,_h,_url,_webguid,_caption){
	this.x=_x;
	this.y=_y;
	this.width=_w;
	this.height=_h;
	this.url=_url;
	this.caption=_caption;
	this.guid=_webguid;
	var guid=_webguid;
	top_zIndex++;
	
	this.hide=function (event){web.hide(200)}
	var position=($.browser.msie?"absolute":"fixed");
	
	var web=$("<div/>").attr({id:"webWindow_"+this.guid}).css({position:position,zIndex:top_zIndex,left:this.x,top:this.y,width:this.width,height:this.height,overFlow:"hidden"});
	var urlIframe=$("<iframe/>").attr({marginHeight:0,marginWidth:0,frameBorder:0}).css({width:this.width-8-8,height:this.height-29-8,float:"right",background:"#FFF"})
	
	var captionframediv=$("<div/>").css({width:this.width,height:29,background:"url(image/window/topleftbg.png) no-repeat"});//标题框架
	var captiondiv=$("<div/>").css({width:this.width-29-11,height:29,float:"right",background:"url(image/window/topcenterbg.png) repeat-x"});//标题框架
	var caption=$("<div/>").css({fontSize:12,fontWeight:"bold",color:"#FFF",display:"block",float:"left",lineHeight:"29px",height:29}).text(this.caption);//标题
	var captionrightdiv=$("<div/>").css({width:11,height:29,float:"right",background:"url(image/window/toprightbg.png) repeat-x"});//右上角div
	
	var closeWindow=$("<div/>").css({width:20,height:20,marginTop:5,float:"right",cursor:"pointer",background:"url(image/window/close.png) no-repeat"});
	closeWindow.bind("click",function (event){closeIcon(guid)});
	
	var minWindow=$("<div/>").css({width:20,height:20,marginTop:5,marginRight:3,float:"right",cursor:"pointer",background:"url(image/window/minwindow.png) no-repeat"});
	minWindow.bind("click",function (event){web.hide(200)});
	
	var reBack=$("<div/>").css({width:44,height:20,marginTop:5,marginRight:3,float:"right",cursor:"pointer",background:"url(image/window/reback.png) no-repeat"});
	reBack.bind("click",function (event){webGoBack(urlIframe[0])});
	
	var setWindow=$("<div/>").css({width:44,height:20,marginTop:5,marginRight:3,float:"right",cursor:"pointer",background:"url(image/window/setwindow.png) no-repeat"});
	setWindow.bind("click",function (event){setWebWindow()});
	
	captionframediv[0].appendChild(captionrightdiv[0]);
	captionframediv[0].appendChild(captiondiv[0]);
	captiondiv[0].appendChild(caption[0]);
	captiondiv[0].appendChild(closeWindow[0]);
	captiondiv[0].appendChild(minWindow[0]);
	captiondiv[0].appendChild(reBack[0]);
	captiondiv[0].appendChild(setWindow[0]);
	
	var bodyframe=$("<div/>").css({width:this.width,height:this.height-29-8,background:"url(image/window/centerleftbg.png) repeat-y"});//中部框架
	var mask=$("<div/>").css({width:this.width-8-8,height:this.height-29-8,position:"absolute",left:8,top:29,zIndex:11,background:"#FFF",opacity:0,display:"none"})
	bodyframe[0].appendChild($("<div/>").css({width:8,height:this.height-29-8,float:"right",background:"url(image/window/centerrightbg.png) repeat-y"})[0]);
	bodyframe[0].appendChild(urlIframe[0]);
	bodyframe[0].appendChild(mask[0]);
	
	var bottomframe=$("<div/>").css({width:this.width,height:"8px",background:"url(image/window/bottomleftbg.png) no-repeat"});
	bottomframe[0].appendChild($("<div/>").css({width:"8px",height:"8px",float:"right",background:"url(image/window/bottomrightbg.png) no-repeat"})[0]);
	bottomframe[0].appendChild($("<div/>").css({width:this.width-8-8,height:"8px",float:"right",background:"url(image/window/bottomcenterbg.png) repeat-x"})[0]);
	
	web[0].appendChild(captionframediv[0]);
	web[0].appendChild(bodyframe[0]);
	web[0].appendChild(bottomframe[0]);
	
	var marginX=0;
	var marginY=0;
	
	this.onMouseDown=function (event){
		top_zIndex++;
		web.css({zIndex:top_zIndex});
		captionframediv.css("cursor","move");//改变鼠标指针的形状
		var offset = $(this).offset();//DIV在页面的位置
        marginX = event.pageX - offset.left;//获得鼠标指针离DIV元素左边界的距离   
        marginY = event.pageY - offset.top;//获得鼠标指针离DIV元素上边界的距离
		//mask.show();
		$(document).bind("selectstart",function(){return false});
		moveAndMask(true)
		$(document).bind("mousemove",function(event){
			web.stop(true,true);//加上这个停止动画
		 	var $x = event.pageX - marginX;//获得X轴方向移动的值   
         	var $y = event.pageY - marginY;//获得Y轴方向移动的值   
         	web.animate({left:$x+"px",top:$y+"px"},10);
		})
		$(document).bind("mouseup",function(event){
			//mask.hide();
			moveAndMask(false)
			captionframediv.css("cursor","default");//改变鼠标指针的形状
			$(document).unbind("mousemove");
		 	$(document).unbind("mouseup");
			$(document).unbind("selectstart");
		})
		}
	web.bind("click",function(event){top_zIndex++,$(this).css("z-index",top_zIndex)})
	captionframediv.bind("mousedown",this.onMouseDown);
	
	this.web=web;
	this.mask=mask;
	this.iframe=urlIframe;
	
	urlIframe[0].src=this.url
	reBack.css("display",((document.location.hostname).toLowerCase()==getDomainName(urlIframe[0].src).toLowerCase() || getDomainName(urlIframe[0].src)=="")?"block":"none")
	
	web.appendTo("body")
	web.show(100);
}

$(function (){
	var debugDiv=$("<div/>").attr("id","debugDiv").css({width:"100%",height:30,position:"fixed",left:0,top:30,zIndex:10000,background:"#000",color:"#fff"})//.appendTo("body");
	})
function debug(value){
	$("#debugDiv").text(value);
	}