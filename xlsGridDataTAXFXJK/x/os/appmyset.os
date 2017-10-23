function x_appmyset(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var web = new JavaPackage ( "com.xlsgrid.net.web" );
//
// 
//
function GetBody()
{
	var db = null;
	var ds = null;
	var sql = "";
	var ret = "";
	var nextguid="";
	var url="";
	try {
	
		var usrinfo = web.EASession.GetLoginInfo(request);
		var usrid = usrinfo.getUsrid();
	   	var accid = usrinfo.getAccid();
	   	var sytid = usrinfo.getSytid();
		var orgid = usrinfo.getOrgid();

		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”);
		//判断是否有基本信息如果没有就insert 
		sql="select * from chis_patinfo where formguid=(select guid from usr where id='"+usrid+"' and org='"+orgid+"' )";
		ds=db.QuerySQL(sql);
		
		if(ds.getRowCount()>0){
			nextguid=ds.getStringAt(0,"guid");
		}else{
		      sql="insert into chis_patinfo (patnam,formguid,org,crtdat) select name,guid,org,sysdate from usr where id='"+usrid+"' and org='"+orgid+"' ";
		      	db.ExcecutSQL(sql);
		      	sql="select * from chis_patinfo where formguid=(select guid from usr where id='"+usrid+"' and org='"+orgid+"' )";
			ds=db.QuerySQL(sql);
			if(ds.getRowCount()>0){
				nextguid=ds.getStringAt(0,"guid");
			}
			else{
			nextguid="";
			}
		      	db.Commit();
		}
		url="L.sp?grdid=CHIS_SETPATINFO&guid="+nextguid;
		
		ret+="<script type=\"text/javascript\">
		
		function loadusrnam(){
			document.getElementById('genlocalusrnam').innerHTML=G_APP_USRNAM;
			if(G_APP_USRIMG!=\"\"){
				document.getElementById('genlocalusrimg').src=\"EAFormBlob.sp?guid=\"+G_APP_USRIMG;
			}
		}
		window.onload=loadusrnam;
		</script>";
		
		ret+="
		
		<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery-1.7.2.min.js\"></script>
		<script type=\"text/javascript\" charset=\"utf-8\" src=\"cordova.js\"></script>  
		<script type=\"text/javascript\" charset=\"utf-8\" src=\"cordova_plugins.js\"></script>
		
		<script type=\"text/javascript\">
		        function uploadPic(){
		        	//$('#upPicture').show();
		        	//$('#bgcoloropa').show();
		        	document.getElementById('upPicture').style.display='block';
		        	document.getElementById('bgcoloropa').style.display='block';
		        }
		        			
		      function cancleUploadPic(){
		//        	$('#upPicture').hide();
		//        	$('#bgcoloropa').hide();
				document.getElementById('upPicture').style.display='none';
				document.getElementById('bgcoloropa').style.display='none';
		      }
        			

		    var pictureSource;  //设定图片来源  
		    var destinationType; //选择返回数据的格式  
		  
		    document.addEventListener(\"deviceready\",onDeviceReady,false);  
		  
		    // Cordova准备好了可以使用了  
		    function onDeviceReady() { 
			pictureSource=navigator.camera.PictureSourceType;  
		        destinationType=navigator.camera.DestinationType;  
		    }
		      
		    // 拍照 capture(50,1,0,-1,-1);
		    // 摄影 capture(50,1,1,-1,-1);
		    // 从图库选择 capture(100,0,0,-1,-1)
		    
		    // qua 清晰度 100;
		    // src:=0 图片库 =1 摄像头 =2 相册  
		    // mtype = 0 照相  = 1 摄像 =2 全部
		    // width height 如果为-1表示取照相机默认像素大小
		    
		    function capture(qua,src,mtype,width,height) {alert(\"进入\"); 
			navigator.camera.getPicture(onPhotoURISuccess, onFail, { quality: qua,  destinationType:destinationType.FILE_URI,sourceType:src, targetWidth:width,targetHeight:height,encodingType:0,mediaType:mtype });
		   	alert(\"结束\");
		    }
		    
		    // 图片获取成功  
		    function onPhotoURISuccess(imageURI) {  				
		//	appendMessage(\"<div ><img src='+imageURI+' width=120 height=120><div id='process_info'></div></div>\",G_USRID,G_USRIMG,'right');
			alert(\"图片获取成功\"); 
			uploadfile(imageURI,\"image/jpeg\");
		    }  
		    // 图片获取失败     
		    function onFail(message) {
		    	 alert(\"图片获取失败\"); 
		     	 log('Failed because: ' + message);  
		    }  
			
		    function captureAudio() {  
				document.all('addwnd').style.display='none';
				document.all('recordwnd').style.display='block';
		    }  
		  
		    // 上传一个文件到数据库	
		    function uploadfile(fileName,mimeType)
		    {		
				var ft = new FileTransfer();
				var options = new FileUploadOptions();
				options.fileKey = \"data\";//图片域名！！！
				if(fileName.indexOf('?')==-1){
					options.fileName = fileName;
				}else{
					options.fileName = fileName.substr(0,fileName.indexOf('?'));
				}
				
				 options.mimeType = mimeType;//
				 options.chunkedMode = false;
				 
				 var params = {};
				 params.fileurl = fileName;
				 params.grdid = \"APP_IMGUPLOAD\";
				 params.sytid = \"x\";
				 options.params = params;
				 ft.upload(fileName, G_WEBBASE+\"EAFormBlobUpload.sp?usrid=\"+G_APP_USRID+\"&userpwd=\"+G_APP_USERPWD, onFileUploadSuccess, onFileUploadFail, options);
				 ft.onprogress = uploadProcessing;
		}
		function onFileUploadSuccess(result)
		{alert(\"图片上传\");
			$.get('L.sp?osp=CHIS_appmyset_uploadUsrPhoto&imgguid='+result.response,function(data,status){
				alert(data);
				window.location.reload();
			});
		}
		function onFileUploadFail(error)
		{
			
		}
		function uploadProcessing(progressEvent){
			if (progressEvent.lengthComputable) { 
				//已经上传 
				var loaded=progressEvent.loaded; 
				//文件总长度 
				var total=progressEvent.total; 
				//计算百分比，用于显示进度条 
				var percent=parseInt((loaded/total)*100); 
				//换算成MB 
				loaded=(loaded/1024/1024).toFixed(2); 
				total=(total/1024/1024).toFixed(2); 
//				$('#process_info').html(loaded+'/'+total); 
				document.getElementById('process_info').html(loaded+'/'+total); 
				//$('.upload_current_process').css({'width':percent+'%'}); 
			}
		}       
		</script>
		";
		
		ret += "

		<style type=\"text/css\">
		      .avatar{border: 2px solid #999;border-radius: 50%;padding: .8em;}
		      .username{display: inline-block;width: 100%;padding: 10px 0 20px;font-size: 1.2em;color: #999;border-bottom: 1px solid #e6e6e6;}
		      .menu{border-bottom: 1px solid #e6e6e6;box-shadow: 0 0 1px #fff;}
		       ul{padding: 0;margin: 0;}
		       li{list-style: none;}
		       div {display: block;}
		       img {vertical-align: middle;}
		      .menu a{color: #333;padding: 1em 0;font-size: 1em;display: block;}
		      .glyphicon{position: relative;top: 1px;display: inline-block;font-family: 'Glyphicons Halflings';-webkit-font-smoothing: antialiased;font-style: normal;font-weight: normal;line-height: 1;}
		      .glyphicon-cog:before {content: \"\\e019\";}
		      .glyphicon-lock:before {content: \"\\e033\";}
		      .glyphicon-picture:before {content: \"\\e060\";}
		      .glyphicon-off:before {content: \"\\e017\";}
		</style>
			
		<div style=\"position:relative;height:100%;width:100%;z-index:1;\" data-role=\"panel\" data-position=\"right\" data-display=\"push\" class=\"user_box text-center dn linear-g ui-panel ui-panel-position-right ui-panel-display-push ui-body-inherit ui-panel-animate ui-panel-open\" id=\"panel-right\">
        		 
        		 <div onclick=\"cancleUploadPic()\" id=\"bgcoloropa\" style=\"position:absolute;height:100%;width:100%;background:#A0A0A0;display:none;z-index:50;opacity: 0.7;overflow:visible;\"></div>
        		 
        		 <div class=\"ui-panel-inner\" style=\"height:60%;\">
        			<div style=\"padding-top:20px;\">
            				<img class=\"avatar\" src=\"xlsgrid/images/flash/icon/icon_151.png\" alt=\"头像\"  onclick=\"uploadPic()\" id=\"genlocalusrimg\" style=\"height:10%;width: 20%;cursor:pointer;\">
            				<span class=\"username\" id=\"genlocalusrnam\"></span>
        			</div>
	        		<ul class=\"user_menu\"> 		
			          <li class=\"menu\"><a href=\"#\"  onclick=\"javascript:openWindow('"+url+"')\" class=\"ui-link\"><span class=\"glyphicon glyphicon-cog\"> </span> &nbsp;基本设置</a></li>
			          <li class=\"menu\"><a href=\"#\" onclick=\"javascript:openWindow('xlsgrid/jsp/pages/chgpassnew.jsp?flag=USR&grdid=PASSWD')\" class=\"ui-link\"><span class=\"glyphicon glyphicon-lock\"> </span> &nbsp;修改密码</a></li>
			          <li class=\"menu\"><a href=\"#\" onclick=\"uploadPic()\" class=\"ui-link\"><span class=\"glyphicon glyphicon-picture\"> </span> &nbsp;上传头像</a></li>
			          <li class=\"menu\"><a onclick=\"javascript:window.parent.location.href='L.sp?id=SICKLOGIN';\" class=\"ui-link\"><span class=\"glyphicon glyphicon-off\"> </span> &nbsp;重新登录</a></li>
			          <li class=\"menu\"><a onclick=\"javascript:navigator.app.exitApp();\" class=\"ui-link\"><span class=\"glyphicon glyphicon-off\"> </span> &nbsp;安全退出</a></li>
	        		</ul>
        		</div>
        		
        		<div id=\"upPicture\" style=\"display:none;width:100%;height:40%;position:absolute;z-index:10000;\" align=\"center\">
			
				<div style=\"background:#FFFFFF;width:92%;border-radius:7px;cursor:pointer;\">
					<div onclick=\"javascript:capture(50,1,0,-1,-1)\">
						<hr style=\"margin-bottom:15px;margin-top:15px;width:98%;height:0px;border:none;border-top:1px solid #e6e6e6;\"/>
						<a style=\"text-decoration: none;cursor:pointer;color: blue;font-size: 1em;\"><font><b>&nbsp;&nbsp;拍照</b></font></a>
						<hr style=\"margin-bottom:15px;margin-top:15px;width:100%;height:1px;border:none;border-top:1px solid #e6e6e6;\"/>
					</div>
				
					<div onclick=\"capture(100,0,0,-1,-1);\">	
						<a style=\"text-decoration: none;cursor:pointer;color: blue;font-size: 1em;\"><font><b>&nbsp;&nbsp;从相册选择</b></font></a>
						<hr style=\"margin-bottom:15px;margin-top:15px;width:98%;height:0px;border:none;border-top:1px solid #e6e6e6;\"/>
					</div>
				</div>
				
				<div onclick=\"cancleUploadPic()\" style=\"background:#FFFFFF;width:92%;border-radius:7px;cursor:pointer;\">
					<hr style=\"margin-bottom:15px;margin-top:15px;width:98%;height:1px;border:none;border-top:0px solid #e6e6e6;\"/>
					<div><a style=\"text-decoration: none;cursor:pointer;color: blue;font-size: 1em;\"><font><b>&nbsp;&nbsp;取消</b></font></a></div>
					<hr style=\"margin-bottom:15px;margin-top:15px;width:98%;height:0px;border:none;border-top:1px solid #e6e6e6;\"/>
				</div>
			</div>
        	</div>
        	";
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	
	return ret;
}

//数据库交互：上传或修改头像
function uploadUsrPhoto(){
	var sql="";
	var db=null;
	var ds=null;
	var msg="";
	
	var usrinfo = web.EASession.GetLoginInfo(request);
	var usrid = usrinfo.getUsrid();
	
	var imgguid= pubpack.EAFunc.NVL(request.getParameter("imgguid"),"") ;
//	throw new Exception("图片guid="+imgguid+"用户名为："+usrid);
	try{
		db = new pubpack.EADatabase();
		sql="update usr set imgguid='"+imgguid+"' where org='CHIS' and id='"+usrid+"'";
		
		db.ExcecutSQL(sql);
		
		db.Commit();
		msg="上传成功！";
	}catch(e){
		msg="上传失败！";
		db.Rollback();
		throw new Exception(e.toString());
	}finally{
		if(db != null)
			db.Close();
	}
	return msg;
}

}