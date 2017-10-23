// JavaScript Document
var top_zIndex=100;

function getDocument(){
	return document.body;
}

function onResize(event){
	$("#mydock").css("height",$(window).height());
	windowMask.css({height:$(window).height(),width:$(window).width()});
}

//��һ��guid
function f_openWindow(x,y,w,h,url,icon,guid,caption){
	if(openIcon(guid))return;
	var opensucceed=false;
	if(getDockId()!=null){
		opensucceed=getDockId().f_openWindow(x,y,w,h,url,icon,guid,caption);
		}
	if(opensucceed){
		var webWindow=new newWindow(x,y,w,h,url,guid,caption);
		webWindowArray.push(webWindow);
	}else{
		//û����dock�в���ͼ��
		}
}

//as �ӿ� ����Ļת�Ƶ��ĸ���Ļ��
function f_swichScreen(index){
	if(getDockId()!=null){getDockId().f_toScreenId(index)}
}

//as �ӿ� ����һ��SWF�ļ�
function f_openFlash(x,y,w,h,url,screenid){
	if(getDockId()!=null){getDockId().f_openFlash(x,y,w,h,url,screenid)}
}

//as �ӿ� ����һ��Table���
function f_openTable(x,y,w,h,url,caption,screenid){
	if(getDockId()!=null){getDockId().f_openTable(x,y,w,h,url,caption,screenid)}
}


//AS�Ѿ�װ���˻ص�����
//function JScomplete(){
//	f_openFlash(10,220,0,0,"image/swf/flash.swf",1)
//	f_openTable(100,200,400,200,"table.xml","������",2);
//	f_openWindow(50,50,600,450,'http://qinghailake.kepu.cn/camera/single.jsp?//cid=2','resource://icon_tools',''+Math.random(),'Flash����');
//}

//JSURLת��
function f_toUrl(url){
	document.location=url;
}

//Flash�е��ô�һ������
function j_openWindow(x,y,w,h,url,guid,caption){
	var webWindow=new newWindow(x,y,w,h,url,guid,caption);
	webWindowArray.push(webWindow);
}

//����һ����ַ
function visitURL(url,data,guid){
	$.ajax({url:url,async:false,cache:false,type:"GET",data:data});
}

function runjs(value){
	eval(value)
}

//JS�¼�֪ͨ�ӿ� ������Ļ�����һ��ͼ��
function addOffenIcon(guid){
	//�����һ��ͼ�굽���ù�����Ļʱ�����õĺ���
	//�����ǵ� ��ַд��url��������,�ᴫ����һ������guid,�������ǵ���ַ,���ǾͿ��Լ�¼һ��ͼ����ӵ�������Ļ��
	var url="x.CloudBG.adddesktop.osp";
	if(url.length>0){visitURL(url,"guid="+guid,guid)}
	}

//JS�¼�֪ͨ�ӿ�  ������Ļɾ����һ��ͼ��
function deleteOffenIcon(guid){
	//��ɾ��һ�����ù���ͼ��ʱ�����õĺ���
	//�����ǵ� ��ַд��url��������,�ᴫ����һ������guid,�������ǵ���ַ,���ǾͿ��Լ�¼һ��ͼ��ӳ�����Ļɾ����
	var url="x.CloudBG.deldesktop.osp";
	if(url.length>0){visitURL(url,"guid="+guid,guid)}
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

var flashObject=null;//Flash�ؼ�ID
function getDockId(){
	if(flashObject!=null && flashObject!=undefined){return flashObject}
	if($.browser.msie){
		flashObject=window["mydock"];
		}else{
		flashObject=document["mydock"];
	}
	return flashObject;
}

function getObject(guid){
	for(var i=webWindowArray.length-1;i>=0;i--){
		var obj=$(webWindowArray[i]);
		if(obj==null || obj.attr("guid")==null || obj.attr("web")==null ){
				webWindowArray[i]=null;
				webWindowArray.splice(i,1)
			}else if(obj.attr("guid")==guid){
				return webWindowArray[i];
		}
	}
	return null;
}

//JS �ӿ� ��ԭһ������
function openIcon(guid){
	for(var i=webWindowArray.length-1;i>=0;i--){
		var obj=$(webWindowArray[i]);
		if(obj==null || obj.attr("guid")==null || obj.attr("web")==null ){
				webWindowArray[i]=null;
				webWindowArray.splice(i,1)
			}else if(obj.attr("guid")==guid){
				top_zIndex++;
				obj.attr("web").css("z-index",top_zIndex).slideDown(100);
				return true;//�ɹ���ԭ��һ������
		}
	}
	return false;
}

//JS �ӿ� �ر�һ������
function closeIcon(guid){
	for(var i=webWindowArray.length-1;i>=0;i--){
		var obj=$(webWindowArray[i]);
		if(obj==null || obj.attr("guid")==null || obj.attr("web")==null){
			webWindowArray[i]=null;
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
		if(iframe.contentWindow.history.length>0){
			iframe.contentWindow.history.back();
		}
	}catch(e){
		alert("�޷���ɺ��˲�����")	
	}
}

//���web��������
function getWebWindowCount(){
	var webCount=0;
	for(var i=webWindowArray.length-1;i>=0;i--){
		var obj=$(webWindowArray[i]);
		if(obj==null || obj.attr("guid")==null || obj.attr("web")==null){webWindowArray[i]=null;webWindowArray.splice(i,1)}else{
			webCount++
		}
	}
	return webCount;
}

//web��������
function setWebWindow(){
	//�ų���󻯴���
	var webWindowCount=getWebWindowCount();
	var margin=$(window).height()/webWindowCount;
	if(margin<40){margin=40}
	var cnum=0;
	for(var i=0;i<webWindowArray.length;i++){
		var obj=$(webWindowArray[i]);
		if(obj==null || obj.attr("web")==null){webWindowArray[i]=null;webWindowArray.splice(i,1)}else{
			var web=obj.attr("web");
			var func=obj.attr("IsmaxWindow");
			if(!func()){
				top_zIndex++;
				web.css({zIndex:top_zIndex}).animate({left:10,top:40+cnum*margin},200);
				//��󻯴��ڲ���������
				cnum++;
			}
		}
	}
}
var jishuqi=0
var windowMask=$("<div/>")
$(function(){
	//top_zIndex++;
	windowMask.css({width:"100%",height:"100%",background:"#000",position:"absolute",opacity:0,left:0,top:0,zIndex:1}).hide().appendTo("body");
})
//windowMask.hide();

var skin="skin/blue/";
//var skin="skin/gray/";
//var skin="skin/black/";

function newWindow(_x,_y,_w,_h,_url,_webguid,_caption){
	if(_y<0){_y=0}
	var x=_x,y=_y,w=_w+16,h=_h+37;
	this.x=_x;
	this.y=_y;
	this.width=_w+16;
	this.height=_h+37;
	this.url=_url;
	this.caption=_caption;
	this.guid=_webguid;
	var guid=_webguid;
	top_zIndex++;
	
	var url=_url;
	var ismaxWindow=false;
	
	this.showWinMask=function(value){
			var index=parseInt(urlIframe.css("zIndex"))-1
			windowMask.css({zIndex:index}).show();
	}
	this.hideWinMask=function(value){
		windowMask.hide();
	}
	
	function setIsmaxWindow(value){ismaxWindow=value}
	function getIsmaxWindow(){return ismaxWindow}
	
	this.setIsmaxWindow=function(value){ismaxWindow=value}
	this.getIsmaxWindow=function(){return ismaxWindow}
	this.IsmaxWindow=function(){return ismaxWindow}
	this.hide=function (event){web.hide(200)}

	var position="absolute";//($.browser.msie?"absolute":"fixed");
	
	var urlIframe=$("<iframe/>").attr({id:"webWindow_"+this.guid,marginHeight:0,marginWidth:0,frameBorder:0,width:this.width,height:this.height});
	urlIframe.css({position:position,zIndex:top_zIndex,left:this.x,top:this.y});
	this.web=urlIframe;
	
	this.hide=function(time){
		urlIframe.hide(time)
	}
	
	urlIframe[0].src="newwindow.html?guid="+this.guid+"&url="+this.url;
	urlIframe[0].onload = urlIframe[0].onreadystatechange = function() {  
			 if (this.readyState && this.readyState != 'complete'){
				 return;
			 }else{
				urlIframe.css({opacity:1});
				//debug("������------------->>");
			 }
	}
	urlIframe.appendTo("body");
	
	function resizeEvent(event){
		var window_w=$(window).width();
		var window_h=$(window).height();
		urlIframe.stop(true,true).css({left:0,top:0,width:window_w,height:window_h})
	}
	this.toMaxIndex=function(){
		top_zIndex+=2;
		urlIframe.css({zIndex:top_zIndex});
	}
	
	this.setMaxWindow=function(){//���
		x=urlIframe.css("left")
		y=urlIframe.css("top")
		w=urlIframe.css("width")
		h=urlIframe.css("height")
		//bottomrightdiv.css({cursor:"default"});//�ı����ָ�����״
		setIsmaxWindow(true);
		urlIframe.stop(true,true).animate({top:"0px",left:"0px",width:$(window).width(),height:$(window).height()},100)
		$(window).bind("resize",resizeEvent)
		//resizeEvent(null);
		//moveAndMask(false);
	}
	this.setNormalWindow=function(){
		setIsmaxWindow(false);
		$(window).unbind("resize",resizeEvent);
		urlIframe.stop(true,true).animate({left:x,top:y,width:w,height:h},100)
		//mask.stop(true,true).animate({width:w-8-8,height:h-29-8},100,"linear",function(event){$(this).hide()})
		
		//bottomrightdiv.css("cursor","se-resize");//�ı����ָ�����״
		//moveAndMask(false);
	}
}

function resetwindow(obj,top,left,width,height){
	$(obj).css({top:top,left:left,width:width,height:height})
}

$(function (){
	var debugDiv=$("<div/>").attr("id","debugDiv").css({width:"100%",height:30,lineHeight:"30px",position:"absolute",left:0,top:parseInt($(window).height())-30,zIndex:10000,background:"#000",color:"#fff",display:"none"}).appendTo("body");
})
function debug(value){
	$("#debugDiv").stop(true,true).css({top:parseInt($(window).height())-30}).show(200).text(value)
}