function TAXFXJK_SpiderSMBS(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var pub = new JavaPackage("com.xlsgrid.net.pub");
var httphtml = new x_httpcallpaser();
var Paser = new JavaPackage("org.htmlparser");
var HtmlParser = new x_WG_HtmlParser();
var httpclient = new JavaPackage("org.apache.commons.httpclient");
var io = new JavaPackage("java.io");

var hostip = "http://87.16.17.217:8080/taxafism/";
var code = "utf-8";

function Run()
{
	request.setCharacterEncoding("GB2312");
	response.setCharacterEncoding("GB2312");
	
	var httpcall = "";
	var ret = "";
	try {
		httpcall = new webget.HttpCall();
		ret = httpcall.Get(hostip+"",code);
		ret = ret.substring(ret.indexOf("_t"));
		var pos = ret.indexOf("/>");
		var _t = ret.substring(ret.indexOf("value=\"")+"value=\"".length(),pos-1);
		//var _t = 1501719550153;
		var username = "14511000102";
		var userpwd = "Lin5136017";
		ret =  httpcall.Post(hostip+"userinfo.do?method=login","_t="+_t+"&username="+username+"&userpwd="+userpwd+"&type=password",code);	//登陆
//return ret;
		//企业信息查询
		//System.out.println(hostip+"userinfo.do?method=getMenuByMenuId&menuId=517");
		ret =  httpcall.Get(hostip+"userinfo.do?method=getMenuByMenuId&menuId=517",code);
		
return ret;		
		//导出
		var sql = "select n.nsrsbh ,n.nsrmc ,n.fddbrxm ,n.fddbrsfzjhm ,n.fddbrcjqk , n.cwfzrxm ,n.cwfzrsfzjhm ,n.cwfzrcjqk,  n.bsrxm ,n.bsrsfzjhm ,n.bsrcjqk ,n.gprxm,n.gprsfzjhm ,n.gprcjqk ,n.djrq, cast((CASE WHEN n.HY_DM>='0600' AND n.HY_DM<'4700' THEN '工业' WHEN n.HY_DM>='5100' AND n.HY_DM<'5300' THEN '商业' ELSE '其他' END)as varchar(4)) ,s.swjgmc, n.zgswskfj_dm from J3_NSRXX  n,j3_swjg s where n.zgswskfj_dm=s.swjg_dm  and n.nsrzt_dm <'05'  and  n.zgswskfj_dm  like '14511%'";
		var filename = "企业信息导出";
		var tableHead = "纳税人识别号,企业名称,法人,法人身份证号,法人采集情况,财务负责人,财务负责人身份证号,财务负责人采集情况,办税人,办税人身份证号,办税人采集情况,购票员,购票员身份证号,购票员采集情况";
		var index = "0,1,2,3,4,5,6,7,8,9,10,11,12,13";
		ret =  httpcall.Post(hostip+"taxaction.do?method=exportData","sql="+sql+"&filename="+filename+"&tableHead="+tableHead+"&index="+index);
return ret;
		return ret;
	} catch ( e ) {
		throw new Exception( e );
	}
}


}