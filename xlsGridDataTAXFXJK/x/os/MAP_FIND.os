function x_MAP_FIND(){
//
// 
//
function Map()
{
var html="
<style type=\"text/css\">
p{margin:0;padding:0}
#map_container{height:80%; border: 1px solid #999;height:400px;margin:5px;}
.BMap_cpyCtrl{display: none!important;}/*���ذٶȵ�ͼ��Ȩ*/
@media print{
  #notes{display:none}
  #map_container{margin:0}
}
</style>
<script type=\"text/javascript\" src=\"http://api.map.baidu.com/api?v=1.4\"></script>
<script type=\"text/javascript\" src=\"http://api.map.baidu.com/library/SearchControl/1.4/src/SearchControl_min.js\"></script>
<script type=\"text/javascript\" src=\"http://api.map.baidu.com/library/TrafficControl/1.4/src/TrafficControl_min.js\"></script>

<link rel=\"stylesheet\" href=\"http://api.map.baidu.com/library/SearchControl/1.4/src/SearchControl_min.css\" />
<link href=\"http://api.map.baidu.com/library/TrafficControl/1.4/src/TrafficControl_min.css\" rel=\"stylesheet\" type=\"text/css\" />
	<div id=\"searchBox\"></div>
	<div id=\"map_container\" ></div>

	<script type=\"text/javascript\">
	// ������ͼ���󲢳�ʼ��
	var mp = new BMap.Map(\"map_container\",{
		enableHighResolution: true //�Ƿ�������
	});
	var point = new BMap.Point(116.404, 39.915);
	mp.centerAndZoom(point, 14); //��ʼ����ͼ
	mp.enableInertialDragging(); //������ϵ��ק
	mp.enableScrollWheelZoom();  //��������������
	
	// ��Ӷ�λ�ؼ�
	var geoCtrl = new BMap.GeolocationControl({
		showAddressBar       : true //�Ƿ���ʾ
		, enableAutoLocation : false //�״��Ƿ�����Զ���λ
		, offset             : new BMap.Size(0,25) 
		//, locationIcon     : icon //��λ��iconͼ��
	});
	
	//������λ�ɹ��¼�
	geoCtrl.addEventListener(\"locationSuccess\",function(e){
			console.log(e);
	});
	
	//������λʧ���¼�
	geoCtrl.addEventListener(\"locationError\",function(e){
			console.log(e);
	});
	
	// ����λ�ؼ���ӵ���ͼ
	//mp.addControl(geoCtrl);
	
	//��������
	var type = \"\";
	type = LOCAL_SEARCH ;   //�ܱ߼���
	//type = TRANSIT_ROUTE; //��������
	//type = DRIVING_ROUTE; //�ݳ�����
	
	//������ǿؼ�
	var navCtrl = new BMap.NavigationControl({
			anchor: BMAP_ANCHOR_TOP_LEFT //������ǿؼ���λ��
	});
	// �������ӵ���ͼ����
	mp.addControl(navCtrl);
	
	
	//���������ؼ�
	var searchControl = new BMapLib.SearchControl({
		container : \"searchBox\" //��ż����ؼ�������
		, map     : mp          //�����Ĺ�����ͼ
		, type    : type        //��������
	});
	
//	document.getElementById(\"selectType\").onchange = function () {
//		searchControl.setType(this.value);
//	};
	
	//���·���ؼ�
	var ctrl = new BMapLib.TrafficControl({
	   showPanel: false //�Ƿ���ʾ·����ʾ���
	});      
	mp.addControl(ctrl);
	ctrl.setAnchor(BMAP_ANCHOR_TOP_RIGHT);
	</script>

<div class=\"info-box\" style=\"display: block;\"><h3 class=\"info-title\" align=\"left\">    
1.</h3><p class=\"info-content\" align=\"left\">    ��ַ:�Ϻ���</p><div class=\"info-btn btn-group row\" align=\"left\">    <a href=\"http://map.baidu.com/mobile/webapp/place/linesearch/foo=bar/end=word=%E4%B8%8A%E6%B5%B7%E8%93%9D%E5%8D%81%E5%AD%97%E8%84%91%E7%A7%91%E5%8C%BB%E9%99%A2&tab=line?third_party=lbscomponents\" class=\"_btn tohere\"><i class=\"icon -route\"></i>������</a>    <a href=\"tel:021-64041990\" class=\"btn-s\"><i class=\"g-icon tel-icon\"></i>�绰</a>     </div></div>
<div class=\"panel-opacity\"></div>


";
return html;


}


function genHTML()
{
	var html="
	<script type=\"text/javascript\" src=\"http://api.map.baidu.com/api?v=2.0&ak=FIUxd51j33drDUIpomrhsuH9\"></script>
	    <script type=\"text/javascript\" src=\"http://api.map.baidu.com/library/Heatmap/2.0/src/Heatmap_min.js\"></script>
	    <title>����ͼ����ʾ��</title>
	    <style type=\"text/css\">
			ul,li{list-style: none;margin:0;padding:0;float:left;}
			html{height:100%}
			body{height:100%;margin:0px;padding:0px;font-family:\"΢���ź�\";}

	    </style>	
	<div id=\"container\" style=\"height:105%;width:100%\"></div>
	<script type=\"text/javascript\">
	    var map = new BMap.Map(\"container\");          // ������ͼʵ��
	
	    var point = new BMap.Point(116.418261, 39.921984);
	    map.centerAndZoom(point, 15);             // ��ʼ����ͼ���������ĵ�����͵�ͼ����
	    
	    //map.centerAndZoom('����',13); 
	    map.enableScrollWheelZoom(); // �����������
	    map.addControl(new BMap.MapTypeControl());          //��ӵ�ͼ���Ϳؼ�
	  	
	    var points =[
	    {\"lng\":116.418261,\"lat\":39.921984,\"count\":50},
	    {\"lng\":116.423332,\"lat\":39.916532,\"count\":51},
	    {\"lng\":116.419787,\"lat\":39.930658,\"count\":15},
	    {\"lng\":116.418455,\"lat\":39.920921,\"count\":40},
	    {\"lng\":116.418843,\"lat\":39.915516,\"count\":100},
	    {\"lng\":116.42546,\"lat\":39.918503,\"count\":6},
	    {\"lng\":116.423289,\"lat\":39.919989,\"count\":18},
	    {\"lng\":116.418162,\"lat\":39.915051,\"count\":80},
	    {\"lng\":116.422039,\"lat\":39.91782,\"count\":11},
	    {\"lng\":116.41387,\"lat\":39.917253,\"count\":7},
	    {\"lng\":116.41773,\"lat\":39.919426,\"count\":42},
	    {\"lng\":116.421107,\"lat\":39.916445,\"count\":4},
	    {\"lng\":116.417521,\"lat\":39.917943,\"count\":27},
	    {\"lng\":116.419812,\"lat\":39.920836,\"count\":23},
	    {\"lng\":116.420682,\"lat\":39.91463,\"count\":60},
	    {\"lng\":116.415424,\"lat\":39.924675,\"count\":8},
	    {\"lng\":116.419242,\"lat\":39.914509,\"count\":15},
	    {\"lng\":116.422766,\"lat\":39.921408,\"count\":25},
	    {\"lng\":116.421674,\"lat\":39.924396,\"count\":21},
	    {\"lng\":116.427268,\"lat\":39.92267,\"count\":1},
	    {\"lng\":116.417721,\"lat\":39.920034,\"count\":51},
	    {\"lng\":116.412456,\"lat\":39.92667,\"count\":7},
	    {\"lng\":116.420432,\"lat\":39.919114,\"count\":11},
	    {\"lng\":116.425013,\"lat\":39.921611,\"count\":35},
	    {\"lng\":116.418733,\"lat\":39.931037,\"count\":22},
	    {\"lng\":116.419336,\"lat\":39.931134,\"count\":4},
	    {\"lng\":116.413557,\"lat\":39.923254,\"count\":5},
	    {\"lng\":116.418367,\"lat\":39.92943,\"count\":3},
	    {\"lng\":116.424312,\"lat\":39.919621,\"count\":100},
	    {\"lng\":116.423874,\"lat\":39.919447,\"count\":87},
	    {\"lng\":116.424225,\"lat\":39.923091,\"count\":32},
	    {\"lng\":116.417801,\"lat\":39.921854,\"count\":44},
	    {\"lng\":116.417129,\"lat\":39.928227,\"count\":21},
	    {\"lng\":116.426426,\"lat\":39.922286,\"count\":80},
	    {\"lng\":116.421597,\"lat\":39.91948,\"count\":32},
	    {\"lng\":116.423895,\"lat\":39.920787,\"count\":26},
	    {\"lng\":116.423563,\"lat\":39.921197,\"count\":17},
	    {\"lng\":116.417982,\"lat\":39.922547,\"count\":17},
	    {\"lng\":116.426126,\"lat\":39.921938,\"count\":25},
	    {\"lng\":116.42326,\"lat\":39.915782,\"count\":100},
	    {\"lng\":116.419239,\"lat\":39.916759,\"count\":39},
	    {\"lng\":116.417185,\"lat\":39.929123,\"count\":11},
	    {\"lng\":116.417237,\"lat\":39.927518,\"count\":9},
	    {\"lng\":116.417784,\"lat\":39.915754,\"count\":47},
	    {\"lng\":116.420193,\"lat\":39.917061,\"count\":52},
	    {\"lng\":116.422735,\"lat\":39.915619,\"count\":100},
	    {\"lng\":116.418495,\"lat\":39.915958,\"count\":46},
	    {\"lng\":116.416292,\"lat\":39.931166,\"count\":9},
	    {\"lng\":116.419916,\"lat\":39.924055,\"count\":8},
	    {\"lng\":116.42189,\"lat\":39.921308,\"count\":11},
	    {\"lng\":116.413765,\"lat\":39.929376,\"count\":3},
	    {\"lng\":116.418232,\"lat\":39.920348,\"count\":50},
	    {\"lng\":116.417554,\"lat\":39.930511,\"count\":15},
	    {\"lng\":116.418568,\"lat\":39.918161,\"count\":23},
	    {\"lng\":116.413461,\"lat\":39.926306,\"count\":3},
	    {\"lng\":116.42232,\"lat\":39.92161,\"count\":13},
	    {\"lng\":116.4174,\"lat\":39.928616,\"count\":6},
	    {\"lng\":116.424679,\"lat\":39.915499,\"count\":21},
	    {\"lng\":116.42171,\"lat\":39.915738,\"count\":29},
	    {\"lng\":116.417836,\"lat\":39.916998,\"count\":99},
	    {\"lng\":116.420755,\"lat\":39.928001,\"count\":10},
	    {\"lng\":116.414077,\"lat\":39.930655,\"count\":14},
	    {\"lng\":116.426092,\"lat\":39.922995,\"count\":16},
	    {\"lng\":116.41535,\"lat\":39.931054,\"count\":15},
	    {\"lng\":116.413022,\"lat\":39.921895,\"count\":13},
	    {\"lng\":116.415551,\"lat\":39.913373,\"count\":17},
	    {\"lng\":116.421191,\"lat\":39.926572,\"count\":1},
	    {\"lng\":116.419612,\"lat\":39.917119,\"count\":9},
	    {\"lng\":116.418237,\"lat\":39.921337,\"count\":54},
	    {\"lng\":116.423776,\"lat\":39.921919,\"count\":26},
	    {\"lng\":116.417694,\"lat\":39.92536,\"count\":17},
	    {\"lng\":116.415377,\"lat\":39.914137,\"count\":19},
	    {\"lng\":116.417434,\"lat\":39.914394,\"count\":43},
	    {\"lng\":116.42588,\"lat\":39.922622,\"count\":27},
	    {\"lng\":116.418345,\"lat\":39.919467,\"count\":8},
	    {\"lng\":116.426883,\"lat\":39.917171,\"count\":3},
	    {\"lng\":116.423877,\"lat\":39.916659,\"count\":34},
	    {\"lng\":116.415712,\"lat\":39.915613,\"count\":14},
	    {\"lng\":116.419869,\"lat\":39.931416,\"count\":12},
	    {\"lng\":116.416956,\"lat\":39.925377,\"count\":11},
	    {\"lng\":116.42066,\"lat\":39.925017,\"count\":38},
	    {\"lng\":116.416244,\"lat\":39.920215,\"count\":91},
	    {\"lng\":116.41929,\"lat\":39.915908,\"count\":54},
	    {\"lng\":116.422116,\"lat\":39.919658,\"count\":21},
	    {\"lng\":116.4183,\"lat\":39.925015,\"count\":15},
	    {\"lng\":116.421969,\"lat\":39.913527,\"count\":3},
	    {\"lng\":116.422936,\"lat\":39.921854,\"count\":24},
	    {\"lng\":116.41905,\"lat\":39.929217,\"count\":12},
	    {\"lng\":116.424579,\"lat\":39.914987,\"count\":57},
	    {\"lng\":116.42076,\"lat\":39.915251,\"count\":70},
	    {\"lng\":116.425867,\"lat\":39.918989,\"count\":8}];
	   
	    if(!isSupportCanvas()){
	    	alert('����ͼĿǰֻ֧����canvas֧�ֵ������,����ʹ�õ����������ʹ������ͼ����~')
	    }
		//��ϸ�Ĳ���,���Բ鿴heatmap.js���ĵ� https://github.com/pa7/heatmap.js/blob/master/README.md
		//����˵������:
		/* visible ����ͼ�Ƿ���ʾ,Ĭ��Ϊtrue
	     * opacity ������͸����,1-100
	     * radius ����ͼ��ÿ����İ뾶��С   
	     * gradient  {JSON} ����ͼ�Ľ������� . gradient������ʾ
	     *	{
				.2:'rgb(0, 255, 255)',
				.5:'rgb(0, 110, 255)',
				.8:'rgb(100, 0, 255)'
			}
			���� key ��ʾ��ֵ��λ��, 0~1. 
			    value Ϊ��ɫֵ. 
	     */
		heatmapOverlay = new BMapLib.HeatmapOverlay({\"radius\":20});
		map.addOverlay(heatmapOverlay);
		heatmapOverlay.setDataSet({data:points,max:100});
		//�Ƿ���ʾ����ͼ
	    function openHeatmap(){
	        heatmapOverlay.show();
	    }
		function closeHeatmap(){
	        heatmapOverlay.hide();
	    }
		closeHeatmap();
	    function setGradient(){
	     	/*��ʽ������ʾ:
			{
		  		0:'rgb(102, 255, 0)',
		 	 	.5:'rgb(255, 170, 0)',
			  	1:'rgb(255, 0, 0)'
			}*/
	     	var gradient = {};
	     	var colors = document.querySelectorAll(\"input[type='color']\");
	     	colors = [].slice.call(colors,0);
	     	colors.forEach(function(ele){
				gradient[ele.getAttribute(\"data-key\")] = ele.value; 
	     	});
	        heatmapOverlay.setOptions({\"gradient\":gradient});
	    }
		//�ж�������Ƿ�֧��canvas
	    function isSupportCanvas(){
	        var elem = document.createElement('canvas');
	        return !!(elem.getContext && elem.getContext('2d'));
	    }
	    
	    
	    
	    function myFun(result){
		var cityName = result.name;
		map.setCenter(cityName);
		alert('��ǰ��λ����:'+cityName);
	}
	var myCity = new BMap.LocalCity();
	myCity.get(myFun);
	
	</script> 
	 
	 	
	";
	return html;


}


}