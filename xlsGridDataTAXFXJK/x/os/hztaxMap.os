function x_hztaxMap(){var pub = new JavaPackage("com.xlsgrid.net.pub");

// 显示贺州国税办税地图
function Response()
{
	//response.setContentType("content-type:text/html; charset=UTF-8");
	//request.setCharacterEncoding("UTF-8");
	
	//URL传递过来的方式是"&lb="+java.net.URLEncoder.encode(lb,"gbk")
	var mylocation = pub.EAFunc.NVL(request.getParameter("lb"),"");
	mylocation = java.net.URLDecoder.decode(mylocation,"utf-8");
	//mylocation = pub.EAJ2meUtil.changeCharset(mylocation,"gbk","utf-8");
	var location_x = request.getParameter("lx");
	var location_y = request.getParameter("ly");
	
	var html = getBaiduMap(location_x,location_y,mylocation);
	//html = getGoogleMap(location_x,location_y,mylocation);

	return html;
}

// 百度地图
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
		<title>微信地图网页-我的位置</title>
		</head>
		<body>
		<div id=\"allmap\"></div>
		</body>
		</html>
		<script type=\"text/javascript\">
		var mylocation = '"+mylocation+"';
		var location_x = "+location_x+";
		var location_y = "+location_y+";
		// 百度地图API功能
		var map = new BMap.Map(\"allmap\");            // 创建Map实例
		var gpsPoint = new BMap.Point(location_y,location_x);
		map.centerAndZoom(gpsPoint,16);  //初始化时，即可设置中心点和地图缩放级别。
		//map.setCenter(\"南宁\");
		//map.addControl(new BMap.ZoomControl());          //添加地图缩放控件 v1.0
		map.addControl(new BMap.NavigationControl());  //添加默认缩放平移控件 v2.0
		
		var marker1 = new BMap.Marker(gpsPoint);  // 创建标注
		map.addOverlay(marker1);              // 将标注添加到地图中		
		var opts = {
		  width : 200,     // 信息窗口宽度
		  height: 80,     // 信息窗口高度
		  title : \"我的位置\" // 信息窗口标题
		}
		//创建信息窗口
		var infoWindow1 = new BMap.InfoWindow(mylocation,opts);
		//marker1.openInfoWindow(infoWindow1,opts);
		marker1.addEventListener(\"click\", function(){this.openInfoWindow(infoWindow1,opts);});
		//map.openInfoWindow(infoWindow,point); //开启信息窗口
		
//		//创建信息窗口
//		var infoWindow1 = new BMap.InfoWindow(mylocation);
//		marker1.addEventListener(\"click\", function(){this.openInfoWindow(infoWindow1);});
		
		setTimeout(function(){
		    //BMap.Convertor.translate(gpsPoint,0,translateCallback);     //GPS坐标 真实经纬度转成百度坐标
		    BMap.Convertor.translate(gpsPoint,2,translateCallback);     //谷歌坐标 真实经纬度转成百度坐标
		}, 2000);

		//坐标转换完之后的回调函数
		translateCallback = function (point){
		    //var marker2 = new BMap.Marker(point);
		    //map.addOverlay(marker2);
		    //创建信息窗口
		    //var infoWindow2 = new BMap.InfoWindow(mylocation,opts);
		    //marker2.openInfoWindow(infoWindow2,opts);
		    //marker2.addEventListener(\"click\", function(){this.openInfoWindow(infoWindow2,opts);});
		    map.setCenter(point);
		    //alert(point.lng + ',' + point.lat);
		    var local = new BMap.LocalSearch(map, {
			  renderOptions:{map: map, autoViewport:true}
			});
		    local.searchNearby(\"国税\", point);
		}
		</script>";
	
	return html;

}

// 谷歌地图
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
		<title>微信地图网页-我的位置</title>
		</head>
		<body>
		<div id=\"allmap\"></div>
		</body>
		</html>
		<script type=\"text/javascript\">
		var mylocation = '"+mylocation+"';
		var location_x = "+location_x+";
		var location_y = "+location_y+";
		// 百度地图API功能
		var map = new GMap2(document.getElementById(\"allmap\"));          // 创建Map实例
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