function x_demo1(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var webget = new JavaPackage("com.xlsgrid.net.webget");
var json = new JavaPackage("net.sf.json");

function Response()
{
	//response.setContentType("content-type:text/html; charset=UTF-8");
	//request.setCharacterEncoding("UTF-8");
	
	//URL���ݹ����ķ�ʽ��"&lb="+java.net.URLEncoder.encode(lb,"gbk")
	var mylocation = pub.EAFunc.NVL(request.getParameter("lb"),"");
	mylocation = java.net.URLDecoder.decode(mylocation,"utf-8");
	//mylocation = pub.EAJ2meUtil.changeCharset(mylocation,"gbk","utf-8");
	var location_x = request.getParameter("lx");
	var location_y = request.getParameter("ly");
	
	//var html = getBaiduMap(location_x,location_y,mylocation);
	//html = getGoogleMap(location_x,location_y,mylocation);
	
	var code = request.getParameter("code");
	var url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=wx28aa2668339fb4b2&secret=f7d9a13993dea13a7977497cdc29883d&code="+code+"&grant_type=authorization_code";
	var httpcall = new webget.HttpCall();
	var result = httpcall.Get(url,"UTF-8");
	
	var html = testShare(openid);
	return html;
}

function testShare(openid)
{
	var openidstr = "";
	if (openid != "") {
		openidstr = "<p> openid="+openid;
	}
	
	var html = "";
	//html = pub.EAFunc.readFile("/u/share.html","UTF-8");
	html = "<!DOCTYPE html>
<html> 
<head> 
    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">
    <link rel=\"dns-prefetch\" href=\"http://mmbiz.qpic.cn\">
    <link rel=\"dns-prefetch\" href=\"http://res.wx.qq.com\">
    <title>test</title>
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
    <meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0\" />
    <meta name=\"apple-mobile-web-app-capable\" content=\"yes\">
    <meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\">
    <meta name=\"format-detection\" content=\"telephone=no\">

    <link rel=\"stylesheet\" type=\"text/css\" href=\"http://res.wx.qq.com/mmbizwap/zh_CN/htmledition/style/page/page_mp_article20701f.css\"/>
    <!--[if lt IE 9]>
    <link rel=\"stylesheet\" type=\"text/css\" href=\"http://res.wx.qq.com/mmbizwap/zh_CN/htmledition/style/page/page_mp_article_pc20701f.css\"/>
    <![endif]-->

    <style>
    	ol,ul{list-style-position:inside;}
    </style>
    
    <script type='text/javascript' src='xlsgrid/js/jquery-1.3.2.min.js'></script>
		<script type=\"text/javascript\">
			//����ɹ��ص�����
			function shareSuccess(sharetype) {
				$.ajax({type:'GET',
								url:\"RunSql.sp?usrid=xlsgrid&userpwd=0&sql=insert into log(str)values('΢�ŷ���ɹ�typ=1')\",
								dataType:'text/xml',
								error:function(XMLResponse){
									alert('send failed!'+XMLResponse); 
								},
								success:function(xml) {
									alert('send ok...');
								}
					});
			}

			document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
              // ���͸�����
              WeixinJSBridge.on('menu:share:appmessage', function (argv) {
                  WeixinJSBridge.invoke('sendAppMessage', {
                      \"appid\": \"123\",
                      \"img_url\": \"http://bcs.duapp.com/api100/image/logo/lover.jpg\",
                      \"img_width\": \"160\",
                      \"img_height\": \"160\",
                      \"link\": \"http://api100.duapp.com/card/\",
                      \"desc\":  \"ɽ���꣬��غϣ��˸��������\",
                      \"title\": \"����ؿ�\"
                  }, function (res) {
                      //_report('send_msg', res.err_msg);
                      shareSuccess('1');
                  })
              });

              // ��������Ȧ
              WeixinJSBridge.on('menu:share:timeline', function (argv) {
                  WeixinJSBridge.invoke('shareTimeline', {
                      \"img_url\": \"http://bcs.duapp.com/api100/image/logo/newyear.jpg\",
                      \"img_width\": \"160\",
                      \"img_height\": \"160\",
                      \"link\": \"http://www.xlsgrid.net\",
                      \"desc\":  \"Best wishes for a wonderful new year.\",
                      \"title\": \"����������\"
                  }, function (res) {
                      //_report('timeline', res.err_msg);
                      //alert('share finish callback.'+res);
                      shareSuccess('2');
                  });
              });
          }, false)
      </script>

</head> 

<body id=\"activity-detail\">

	<div class=\"rich_media\">
		
		<div class=\"rich_media_inner\">
			<h2 class=\"rich_media_title\" id=\"activity-name\">test</h2>
			
			<div class=\"rich_media_meta_list\">
				<em id=\"post-date\" class=\"rich_media_meta text\">2014-09-18</em>
				<em class=\"rich_media_meta text\">harry</em>
				<a class=\"rich_media_meta link nickname\" href=\"javascript:viewProfile();\" id=\"post-user\">˶�����</a>
			</div>

			<div id=\"page-content\" class=\"rich_media_content_wrp\">
		
				<div id=\"img-content\">
					
					<div class=\"rich_media_thumb\" id=\"media\">
						<img onerror=\"this.parentNode.removeChild(this)\" src=\"http://mmbiz.qpic.cn/mmbiz/t4l43QDP1ohmsQhVsGQxkhl3pLUSQDd7INw7x3BpWXRGvWj5ncWuZXg6RKUQlabNWq5ibhPY2PFQA0iawpjSyGDQ/0\" />
					</div>
					
					<div class=\"rich_media_content\" id=\"js_content\">
						<p>���ʣ����������������˶���ʲô��</p><p>������</p><p><br  /></p><p>���ʣ��й����������˶���ʲô��</p><p>���й�����</p><p><br  /></p><p>���ء���������</p>
					"+openidstr+"
					</div>
					
					<div class=\"rich_media_tool\" id=\"js_toobar\">
						<a class=\"media_tool_meta link_primary meta_extra\" href=\"javascript:report_article();\">�ٱ�</a>
					</div>
					
				</div>
				
			</div>

		</div>

	</div>
           
        
</body>
</html>";


	return html;
}

// �ٶȵ�ͼ
function getBaiduMap(location_x,location_y,mylocation) 
{
	var html = "<!DOCTYPE html>
		<html>
		<head>
		<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />
		<meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no\" />
		<style type=\"text/css\">
		body, html,#allmap {width: 100%;height: 100%;overflow: hidden;margin:0;}
		</style>
		<!--<script type=\"text/javascript\" src=\"http://api.map.baidu.com/api?type=quick&v=1.0&ak=bcqnSYjGSOPcmxcDpG8T9nMs\"></script>-->
		<script type=\"text/javascript\" src=\"http://api.map.baidu.com/api?v=2.0&ak=bcqnSYjGSOPcmxcDpG8T9nMs\"></script>
		<script type=\"text/javascript\" src=\"http://developer.baidu.com/map/jsdemo/demo/convertor.js\"></script>
		<title>΢�ŵ�ͼ��ҳ-�ҵ�λ��</title>
		</head>
		<body>
		<div id=\"allmap\"></div>
		</body>
		</html>
		<script type=\"text/javascript\">
		var mylocation = '"+mylocation+"';
		var location_x = "+location_x+";
		var location_y = "+location_y+";
		// �ٶȵ�ͼAPI����
		var map = new BMap.Map(\"allmap\");            // ����Mapʵ��
		var gpsPoint = new BMap.Point(location_y,location_x);
		map.centerAndZoom(gpsPoint,16);  //��ʼ��ʱ�������������ĵ�͵�ͼ���ż���
		//map.setCenter(\"����\");
		//map.addControl(new BMap.ZoomControl());          //��ӵ�ͼ���ſؼ� v1.0
		map.addControl(new BMap.NavigationControl());  //���Ĭ������ƽ�ƿؼ� v2.0
		
		var marker1 = new BMap.Marker(gpsPoint);  // ������ע
		map.addOverlay(marker1);              // ����ע��ӵ���ͼ��		
		var opts = {
		  width : 200,     // ��Ϣ���ڿ��
		  height: 80,     // ��Ϣ���ڸ߶�
		  title : \"�ҵ�λ��\" // ��Ϣ���ڱ���
		}
		//������Ϣ����
		var infoWindow1 = new BMap.InfoWindow(mylocation,opts);
		//marker1.openInfoWindow(infoWindow1,opts);
		marker1.addEventListener(\"click\", function(){this.openInfoWindow(infoWindow1,opts);});
		//map.openInfoWindow(infoWindow,point); //������Ϣ����
		
//		//������Ϣ����
//		var infoWindow1 = new BMap.InfoWindow(mylocation);
//		marker1.addEventListener(\"click\", function(){this.openInfoWindow(infoWindow1);});
		
		setTimeout(function(){
		    //BMap.Convertor.translate(gpsPoint,0,translateCallback);     //GPS���� ��ʵ��γ��ת�ɰٶ�����
		    BMap.Convertor.translate(gpsPoint,2,translateCallback);     //�ȸ����� ��ʵ��γ��ת�ɰٶ�����
		}, 2000);

		//����ת����֮��Ļص�����
		translateCallback = function (point){
		    var marker2 = new BMap.Marker(point);
		    map.addOverlay(marker2);
		    //������Ϣ����
		    var infoWindow2 = new BMap.InfoWindow(mylocation,opts);
		    marker2.openInfoWindow(infoWindow2,opts);
		    marker2.addEventListener(\"click\", function(){this.openInfoWindow(infoWindow2,opts);});
		    map.setCenter(point);
		    //alert(point.lng + ',' + point.lat);
		}
		</script>";
	
	return html;

}

// �ȸ��ͼ
function getGoogleMap(location_x,location_y,mylocation) 
{
	var html = "<!DOCTYPE html>
		<html>
		<head>
		<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />
		<meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no\" />
		<style type=\"text/css\">
		body, html,#allmap {width: 100%;height: 100%;overflow: hidden;margin:0;}
		</style>
		<script src='http://maps.google.com/maps?file=api&v=2&sensor=true_or_false&key=ABQIAAAADEgO6kqjKx2W3NKoYkXzGhTepiFuMo4rdqjr65BYebADdmCbPBSZRe2SjhGp7UEHeh4Eg90T-LJuxw&sensor=true' type='text/javascript'></script>
		<title>΢�ŵ�ͼ��ҳ-�ҵ�λ��</title>
		</head>
		<body>
		<div id=\"allmap\"></div>
		</body>
		</html>
		<script type=\"text/javascript\">
		var mylocation = '"+mylocation+"';
		var location_x = "+location_x+";
		var location_y = "+location_y+";
		// �ٶȵ�ͼAPI����
		var map = new GMap2(document.getElementById(\"allmap\"));          // ����Mapʵ��
		if (GBrowserIsCompatible()) {
		        map.addControl(new GSmallMapControl());
			map.addControl(new GMapTypeControl());
			map.setCenter(new GLatLng(location_x,location_y), 15);
			
			var latlng = new GLatLng(location_x,location_y);
			var marker = new GMarker(latlng, {title:mylocation,draggable:false});
			map.addOverlay(marker);
			marker.openInfoWindow(mylocatin);

	
	        }
		

		</script>";
	
	return html;

}


}