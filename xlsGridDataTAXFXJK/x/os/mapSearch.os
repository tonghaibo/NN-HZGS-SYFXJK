function x_mapSearch(){var pub = new JavaPackage("com.xlsgrid.net.pub");
  var path = "/xlsGridData/d.txt";
function demo()
{
var s="   ggg  ";
return s.trim();
var osw =
      new java.io.OutputStreamWriter(new java.io.FileOutputStream(path ), "GBK");
osw.write(msg);
osw.close(); 
  return read();
}

function read()
{
  //return pub.EAFunc.readFile(path);
    var fi = new java.io.FileInputStream(path);
    var ir = new java.io.InputStreamReader(fi,"GBK");
    return pub.EAFunc.ReaderToString(ir);
}

function runsql()
{
  var db = pub.EADbTool.QuerySQL("select * from usr");
  return db.getValueAt(0,0);
  return java.lang.System.getProperty("user.home")+","+java.lang.System.getProperty("user.dir.orig");
  //db.getStringAt(0,0);
}
function getKey()
{
  var ds = pub.EADbTool.QuerySQL("select id,name from "+tablename+" where rownum<10");
  return ds.GetXml();
}

var mypack = new JavaPackage ( "com.syt.serp.ejb" );
function Run()
{
      var ctrl = new mypack.CustCtrl();
      var db = null;
      try {
            db = new pub.EADatabase();
            //ctrl.CheckADS(db,accid,"SX","ZJ11581");
            ctrl.CheckSXADS(db,accid,"SX","ZJ11581");
            return "ok";
      }
      catch ( ee ) {
            throw ee;
      }
      finally {
            if (db!=null) db.Close();
      }
      return "�����ɹ�";
}
function addHeaderHtml(mwobj,request,sb,usrinfo)
{
  
}
var i=0;
function addBottomHtml(mwobj,request,sb,usrinfo)
{
//  var c = 1300;
//  for( i=0;i<c;i++)
//  {
//    sb.append(i);
//    sb.append(",");
//    sb.append(pub.EAFunc.DateToStr(new java.util.Date(),"hh:mm:ss"));
//    sb.append(",");
//    sb.append(java.lang.Thread.activeCount());
//    sb.append("\n");
    //java.lang.Thread.currentThread().sleep(1);
    //java.lang.Thread.currentThread().stop();
//  }
//  sb.append(java.lang.Thread.currentThread().getName());
//  sb.append(".end:"+c);
}

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
	
	var html = getBaiduMap(location_x,location_y,mylocation);
	//html = getGoogleMap(location_x,location_y,mylocation);

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
		    //var marker2 = new BMap.Marker(point);
		    //map.addOverlay(marker2);
		    //������Ϣ����
		    //var infoWindow2 = new BMap.InfoWindow(mylocation,opts);
		    //marker2.openInfoWindow(infoWindow2,opts);
		    //marker2.addEventListener(\"click\", function(){this.openInfoWindow(infoWindow2,opts);});
		    map.setCenter(point);
		    //alert(point.lng + ',' + point.lat);
		    var local = new BMap.LocalSearch(map, {
			  renderOptions:{map: map, autoViewport:true}
			});
		    local.searchNearby(\"��ǿ\", point);
		    //local.searchNearby(\"����\", point);
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