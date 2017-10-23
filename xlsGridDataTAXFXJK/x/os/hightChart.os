function x_hightChart(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var webpack = new JavaPackage ( "com.xlsgrid.net.web");

//
// 
//
function GetBody()
{
	var bodyHtml = ""; 

//	bodyHtml += "<script src=\"xlsgrid/js/jquery-1.6.js\"></script>";
//	bodyHtml += "<script src=\"xlsgrid/js/hightcharts.js\"></script>";

	var classid = request.getParameter("class");
//	var chartCls = "KJTDC_chartA1";
//	var chart = new KJTDC_chartA1();
//	return chart.title;
	var os = new pub.EAScript(null);
	var scriptArgs = new Array();
	scriptArgs[0] = request;
	
	var loginInfo = webpack.EASession.GetLoginInfo(request);
	var thissytid = loginInfo.getSytid();
					
	var chart = os.CallClassFunc(thissytid+"_"+classid,"_init",scriptArgs);
	//return chart.title;


	bodyHtml += "<div id=\"container\" ></div>";
	
	bodyHtml += chart.getCharts();
	
	
	return bodyHtml;
}



}