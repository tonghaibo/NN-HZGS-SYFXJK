function x_WG_WalMartbak(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var protocolpack = new JavaPackage("org.apache.commons.httpclient.protocol");
var EAfunc = new pubpack.EAFunc();
var HtmlParser = new x_WG_HtmlParser();
var httpcall = new webget.HttpCall();
var tagFilter = new JavaPackage("org.htmlparser.filters");
var htmlutil = new JavaPackage("org.htmlparser.util");







function start()
{
	return getOrderStr("GMHD","2013-03-07","0012","sha528a","32165Zz","1","utf-8");
}

function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
{

	code="utf-8"; 
	var turl="https://rllogin.wal-mart.com/rl_security/rl_logon.aspx?ServerType=IIS1&CTAuthMode=BASIC&language=en&CT_ORIG_URL=%2Fsitemap%2Fsitemap.aspx&ct_orig_uri=%2Fsitemap%2Fsitemap.aspx";
	var parm="__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=%2FwEPDwULLTE0OTY5MTU2ODkPZBYCZg9kFgICCQ9kFgJmD2QWAmYPZBYCAgEPZBYCAgIPZBYCZg9kFgICAQ8PZBYEHgtvbm1vdXNlb3ZlcgUbdGhpcy5jbGFzc05hbWU9J2J0biBidG5ob3YnHgpvbm1vdXNlb3V0BRR0aGlzLmNsYXNzTmFtZT0nYnRuJ2RkPwsM6QfmB7nLs3YhaSzFQIMfpgs%3D&__EVENTVALIDATION=%2FwEWBwLeg6%2BXDAK145qeCgK7iKX4CAKgmu7gDwLB2tiHDgLKw6LdBQLvz%2FGACruWvf18O2f4%2Bkt%2BWRX4INDqRZCf&hidFailedLoginCount=&redirect=%2Fsitemap%2Fsitemap.aspx&hidPwdErrHandledFlag=FALSE&txtUser="+userid+"&txtPass="+passwd+"&Login=%C1%AA%BB%FA%2F%B5%C7%C2%BC";
	var ret =httpcall.Get(turl+parm,code);//登录
	ret =httpcall.Post("https://retaillink.wal-mart.com/sitemap/sitemap.aspx",code);//网址地图
	ret =httpcall.Post("https://retaillink.wal-mart.com/edi/default.aspx?ch=H19&ukey=W5294",code);//edi
	ret =httpcall.Post("https://retaillink.wal-mart.com/edi/edi.aspx?ch=H19&ukey=W5294",code);//edi
	parm="__VIEWSTATE=/wEPDwUJMTQzMDAxNzM1ZGRq6ZJylwOAalt0L3a7eDb8SUNhlA==&DocumentType=850&IsPaginated=true&MailboxId=38415&PageIndex=0&PONumber=&SortBy=3&SortOrder=desc&Status=20&StoreNumber=&VendorCountry=CN&PageSize=100";
	ret =httpcall.Post("https://retaillink.wal-mart.com/edi/webedi/",parm,code);//webedi//查询默认是查询新增
	parm="__VIEWSTATE=%2FwEPDwUJMTQzMDAxNzM1ZGRq6ZJylwOAalt0L3a7eDb8SUNhlA%3D%3D&MailboxId=38415&VendorCountry=CN&PONumber=&StoreNumber=&DocumentType=850&Status=20&SortBy=3&SortOrder=DESC&IsPaginated=false&PageIndex=0&PageSize=10";
	ret =httpcall.Post("https://retaillink.wal-mart.com/edi/webedi/",parm,code);//webedi//查询已接受的
	return getBil(ret,httpcall,acc,dat,kaid,userid,passwd,deptid,code);
}
function getBil(note,httpcall,acc,dat,kaid,userid,passwd,deptid,code){
	var str="";//明细字符串
	
	//	 <tr  style="background-color: #EFF6FF" >
	//            <td>
	//                <input name="[0].IsSelected" type="checkbox" value="true" /><input name="[0].IsSelected" type="hidden" value="false" />               
	//                <input name="[0].Id" type="hidden" value="136896087" />
	//                <input name="[0].VendorCountryCode" type="hidden" value="CN" />
	//                <input name="[0].JointVentureTax" type="hidden" value="440301710936858" />               
	//                <input name="[0].GroupControlNumber" type="hidden" value="850000325" />
	//                <input name="[0].IntControlNumber" type="hidden" value="850000325" />
	//                <input name="[0].SetControlNumber" type="hidden" value="366" />
	//            </td>
	//            <td align="center"><a href="/edi/WebEDI/Document/ViewDetails/136896087?Type=850">8700716482</a></td>
	//            <td align="center">                01/21/2013            </td>
	//            <td align="center">                <input name="[0].StoreNumber" type="hidden" value="0" />                0            </td>
	//            <td align="center">                         </td>
	//            <td align="center">                0            </td>
	//            <td align="right">                26378.83            </td>        
	//        </tr>
	//格式如上	
	note=pub.EAFunc.Replace(note,"<th","<td");//替换
	note=pub.EAFunc.Replace(note,"</th>","</td>");//替换
	//note=pub.EAFunc.Replace(note,"<input","");//替换
	note=pub.EAFunc.Replace(note,"\"","");//替换
	note=pub.EAFunc.Replace(note,"=","");//替换
	note=pub.EAFunc.Replace(note,";","");//替换
	note=pub.EAFunc.Replace(note,":","");//替换
	note=pub.EAFunc.Replace(note,"].","");//替换
	note=pub.EAFunc.Replace(note,"<a href","");//替换
	note=pub.EAFunc.Replace(note,"</a>","");//替换	
	var nodelist = HtmlParser.parserHtml(note,code); 
	var tablist = HtmlParser.filterHtml(nodelist,"table");
	var ds = HtmlParser.parserTableOne(tablist,code,new Array("10"));
	var herf="";
	var strsplit="";
	var bilid="";//订单号
	var bildat="";//订单日期
	var fadat="";//发货日期
	var ccdat="";//取消日期
	var fax=" ";
	var tel=" ";
	var CORPADDR=" ";
	dat=dat.substring(8,10)+"/"+dat.substring(5,7)+"/"+dat.substring(0,4);
	
	for (var r=0;r<ds.getRowCount();r++){
		herf=ds.getStringAt(r,"_javascriptSort2stylefont-weightbold");
		herf=herf.substring(herf.indexOf("发票号")+4,herf.length());
		herf=herf.substring(herf.indexOf("Details")+7,herf.indexOf(">"));
		var strsplit=herf.split("Type");
		herf="https://retaillink.wal-mart.com/edi/WebEDI/Document/ViewDetails/"+strsplit[0]+"Type="+strsplit[1];
		///https://retaillink.wal-mart.com/edi/WebEDI/Document/ViewDetails/137105281?Type=850
		var ret =httpcall.Get(herf,code);//点击发票号//这里取到的具体的单据信息是乱码(如果用post取的话)，改成用get就好了
		ret =pub.EAFunc.Replace(ret,"</","_</");//替换
		ret =pub.EAFunc.Replace(ret,"</strong>","");//替换
		ret =pub.EAFunc.Replace(ret,"<strong>","");//替换
		
		var list = HtmlParser.parserHtml(ret,code); 
		var tlist = HtmlParser.filterHtml(list,"table");
		var tds = HtmlParser.parserTableOne(tlist,code,new Array("11"));
		//这是表头信息
		
		if(tds.getRowCount()>0){
			bilid=tds.getColumnName(1);
			bildat=tds.getStringAt(0,bilid);
			fadat=tds.getStringAt(2,bilid);
			if(fadat.length()==9)
      		       	fadat=fadat.substring(2,4)+"/"+fadat.substring(0,2)+"/"+fadat.substring(4,fadat.length()-1);
      		       	bildat=bildat.substring(2,4)+"/"+bildat.substring(0,2)+"/"+bildat.substring(4,bildat.length()-1);
			if(bildat!=dat){
				break;
			}		
			ccdat=tds.getStringAt(2,bilid);
			bilid=bilid.substring(1);
		}
		
		//上面是表头信息，下面取明细格式如下：
		//	<ROW num="0" >
		//		<_行号_>001_</_行号_>
		//		<_商品号_>009630502_</_商品号_>
		//		<_条码_>6903293470892_</_条码_>
		//		<_供应商商品号_>EAN_</_供应商商品号_>
		//		<_颜色_>47089_</_颜色_>
		//		<_尺码_>_</_尺码_>
		//		<_订货数量_>500ml_</_订货数量_>
		//		<_单位_>5_</_单位_>
		//		<_外包内盒装_>CA_</_外包内盒装_>
		//		<_成本_>1212_</_成本_>
		//		<_合计成本_>173.4300_</_合计成本_>
		//	</ROW>
		tds = HtmlParser.parserTableOne(tlist,code,new Array("14"));
		
		var itemdtl="";
		var num =1;
		var spce="";
		var first=0;
		if(tds.getRowCount()>0){//这个循环是循环商品
			
			for(var i=0;i<tds.getRowCount();i+=4){
					//首先分析有几个客户
					try{
						itemdtl=tds.getStringAt(i+3,"_商品号_").split("_");
						
						for(var arr=8;arr<itemdtl.length();arr+=4){//这个循环是循环客户
							spce=tds.getStringAt(i,"_成本_");
							//spce=spce.substring(0,2)+"/"+spce.substring(2,4);
							//throw new Exception((spce.length()-1)/2);
							first=(spce.length()-1)/2;
							spce=spce.substring(0,first)+"/"+spce.substring(first,spce.length()-1);
							if(str != "")
				 			str += "╃";
				 			
							str += "NR ~~~"+userid+"~~~"+deptid+"~~~"+kaid+"~~~"+bilid+"~~~"+itemdtl[arr]+"~~~"+itemdtl[arr]+"~~~ ~~~"+itemdtl[arr]+"~~~"+bildat+"~~~"+fadat+"~~~"+
							tel+"~~~"+fax+"~~~"+num+"~~~"+tds.getStringAt(i,"_商品号_")+"~~~"+tds.getStringAt(i,"_条码_")+"~~~"+spce+"~~~"+tds.getStringAt(i+2,"_商品号_")+
							"~~~ ~~~"+tds.getStringAt(i,"_外包内盒装_")+"~~~"+itemdtl[arr+1]+"~~~"+0+"~~~"+tds.getStringAt(i,"_合计成本_")+"~~~"+CORPADDR+"~~~ ~~~ ";
							num++;
						}
					}catch (e){
						throw new Exception(e.toString());
					
					}	
			}
			
		}

	}
	str=pub.EAFunc.Replace(str,"商品说明","");//替换
	str=pub.EAFunc.Replace(str,"_","");//替换
	return str;
	//throw new Exception(str);
}
}