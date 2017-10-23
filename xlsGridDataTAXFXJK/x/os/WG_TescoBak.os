function x_WG_TescoBak(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var pub = new JavaPackage("com.xlsgrid.net.pub");
var protocolpack = new JavaPackage("org.apache.commons.httpclient.protocol");
var EAfunc = new pubpack.EAFunc();
var HtmlParser = new x_WG_HtmlParser();
var httpcall = new webget.HttpCall();
var HtmlParser = new x_WG_HtmlParser();
//var order = new pubpack.EAXmlDS();
//var row = -1;

var msg = "";

function start()
{
	return getOrderStr("GMHD","2014-01-17","0007","10000704","654321","dept","utf-8");
}

function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
{
	var ret = "";
	var param = "";
	var url = "";
	var db="";
	var sql="";
	var msg="";
	try
	{
	       db=new pubpack.EADatabase();
	       //日期用用户输入的日期，编码格式这里强制改为utf-8
	       code="utf-8";
	       var dat1=dat;
	       var dat2=dat;
		url = "https://tesco.chinab2bi.com";
		ret = httpcall.Get(url+"/mainLogon.hlt",code);
		param = "j_captcha=&j_username="+userid+"&j_password="+passwd+"&Submit=   登录" ;
		ret = httpcall.Post(url+"/j_spring_security_check",param,code);
		//两个供应商编号需要查两次1-------12255751
		param = "downFlag=&readFlag=&page.jumpNumber=1&page.pageNo=1&page.totalPages=2&page.pageSize=100&orderDateStart="+dat1+"&orderDateEnd="+dat1+"&parentVendor=100255&vendor=12255751&page.togglestatus=null&status=sell" ;
		ret = httpcall.Post(url+"/tesco/sp/purOrder/sellPubOrderQry.hlt",param,code);//查询
	        ret =GetBillist(ret,httpcall,userid,dat,deptid,kaid,code);
	        msg+=ret ;
	        //1-------12256086
	        param = "downFlag=&readFlag=&page.jumpNumber=1&page.pageNo=1&page.totalPages=2&page.pageSize=100&orderDateStart="+dat1+"&orderDateEnd="+dat1+"&parentVendor=100255&vendor=12256086&page.togglestatus=null&status=sell" ;
		ret = httpcall.Post(url+"/tesco/sp/purOrder/sellPubOrderQry.hlt",param,code);//查询
	        ret =GetBillist(ret,httpcall,userid,dat,deptid,kaid,code);
	        msg += "╃";
 		msg+=ret ;
	        
	       // return ret; 
	}
	catch(e)
	{
	 	db.Rollback();
		throw new Exception(e);
	}
	finally{
		if(db!=""){
			db.Close();
		}
	}
	//throw new Exception(msg);
	return msg;
}

//递归，取出单据列表
function GetBillist(node,httpcall,userid,dat ,deptid,kaid,code)
{
	
			 /*  具体订单的商品信息  ds格式
					<ROW num="1" >
						<_序号>2</_序号>
						<_供应商编号>100255</_供应商编号>
						<_供应商8位编号>12255751</_供应商8位编号>
						<_供应商名称>上海捷强烟草糖酒集团配销中心</_供应商名称>
						<_通知日期>2012-12-21</_通知日期>
						<_通知状态>已阅读</_通知状态>
						<_下载状态>已下载</_下载状态>
						<_最后一次访问IP>218.242.148.242</_最后一次访问IP>
						<_最后访问时间>2012-12-2413:34</_最后访问时间>
						<_最后下载IP>218.242.148.242</_最后下载IP>
						<_最后下载时间>2012-12-2413:34</_最后下载时间>
						<_操作>"#"onclick="openPDF('2050606','100255','MERGE_12255751@supplier.cn.tesco.com_20121221132444.txt','2012-12-2113:29:08.0')">[明细]</_操作>
						<_操作__操作>"#"onclick="downPDF('2050606','100255','MERGE_12255751@supplier.cn.tesco.com_20121221132444.txt','2012-12-2113:29:08.0')">[PDF下载]</_操作__操作>
					</ROW>
			*/
			
			node=pub.EAFunc.Replace(node,"<th>","<td>");//替换
			node=pub.EAFunc.Replace(node,"</th>","</td>");//替换
			node=pub.EAFunc.Replace(node,"<a href=","");//替换
			node=pub.EAFunc.Replace(node,"</a>","");//替换
			
			var nodelist = HtmlParser.parserHtml(node,code); 
			var tablist = HtmlParser.filterHtml(nodelist,"table"); 
			var ds = HtmlParser.parserTableOne(tablist,code,new Array("5"));
			//throw new Exception(ds.GetXml());
			//分析具体的单子
			var url="https://tesco.chinab2bi.com";
			var param="";
			var createDate="";
			var str ="";
			var fileName="";
			var poid="";
			var parentVendor="";
			for (var r=0;r<ds.getRowCount();r++){ 
				str=ds.getStringAt(r,"_操作");
				str=str.substring(str.indexOf( "(" )+1,str.indexOf( ")" ));
				var strsplits =str.split(",");
				//strsplits[0] =2054340
				//strsplits[1] =100255
				//strsplits[2] =MERGE_12255751@supplier.cn.tesco.com_20121221185044.txt
				//strsplits[3] =2012-12-2118:58:59.0
				createDate=strsplits[3];
				createDate=createDate.substring(1,11);
				createDate=pub.EAFunc.Replace(createDate,"-","");//替换
				fileName=strsplits[2];
				fileName=fileName.substring(1,fileName.length()-1);
				poid=strsplits[0];
				poid=poid.substring(1,poid.length()-1);
				parentVendor=strsplits[1];
				parentVendor=parentVendor.substring(1,parentVendor.length()-1);
				param="seed&fileName="+fileName+"&createDate="+createDate+"&poId="+poid+"&parentVendor="+parentVendor+"";
				var txt = httpcall.Post(url+"/tesco/sp/purOrder/pdfView.hlt",param,code);
				if(msg != "")
		          	msg += "╃";
		          	msg += parseOneBill(httpcall,txt,userid,deptid,kaid);
				
			}
			return msg ;
   }

//解析一张单据
//httpcall
//str：单据的文本
//返回：字符串分割的字符
function  parseOneBill(httpcall,str,userid,deptid,kaid)
{
      /**
	*		               TESCO 乐  购  商  品  订  单
	*	    店别:  上海大华店                     页1  页
	*	─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
	*	  订单号码  12000323          促销期数                    紧急订单                  
	*	  订单日期  2012/12/21        交货日期  2012/12/25        订单类型  -DSD PO-        
	*	  电  话    66405003          传  真                                                
	*	  店  址    上海大华路518号                               邮  编                    
	*	  厂商编号  12255751                                      名  称    上海捷强烟草糖酒集团配销中心-
	*	  电  话    02158357527       传  真    02158203461       联 系 人  徐菁            
	*	  地  址    浦东新区张杨路579号9楼三鑫世界大厦            邮  编    200120          
	*	  备  注                                                
	*	─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
	*	 商品货号/       品名                           规格     订购   箱   单件成本     成本   总成本 订购数量     应交 应交单件  订单     促销
	*	 单个商品货号                                   国际条码 单位   入数                            搭赠数量     总数 总数      (Ti Hi)  票折
	*	─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
	*	 150502662/      SP_24_52度泸州老窖头曲1        瓶       箱       24     9.23   221.54   221.54        1        1       24    1    1 N   
	*	 103067890       25ml/瓶                        6901798132611                                       0.00                             Y   
	*
	*	─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
	*	 Terms & Conditions /  备注 :                                                    
	*	 1.收货时间 周一至周六5 30-19 00 周日5 30-12 00 大进货期间周一至周日8 00-21 00
	*	 ......
	*	 9.商品单价不包含供应商在商品购销合同中承诺给予的折扣!
	*	─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
	*/
	var ret = str; 
	var title_param = "TESCO 乐  购  商  品  订  单\n";
	var title_params = ret.split(title_param);                         
	var line = "─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────\n";
	var msgs = "";
	for(var r = 1;r < title_params.length();r ++)
	{
		
		var lines = title_params[r].split(line);
		var corpnam = lines[0].substring(lines[0].indexOf(":")+3,lines[0].indexOf("页")); 
		corpnam  = EAfunc.regexReplace(corpnam , "\\s+","");
		
		var bilid = lines[1].substring(lines[1].indexOf("订单号码")+6,lines[1].indexOf("促销期数"));//订单编号
		bilid = EAfunc.regexReplace(bilid, "\\s+","");
		var date = lines[1].substring(lines[1].indexOf("订单日期")+6,lines[1].indexOf("交货日期"));//订单日期
		date = EAfunc.regexReplace(date, "\\s+","");
		//dd/mm/yyyy
		var _date = date.split("/")[2]+"/"+date.split("/")[1]+"/"+date.split("/")[0];
		var addrdate = lines[1].substring(lines[1].indexOf("交货日期")+6,lines[1].indexOf("订单类型"));//交货日期
		addrdate = EAfunc.regexReplace(addrdate, "\\s+","");
		if (addrdate == "") addrdate = date;
		var _addrdate = addrdate.split("/")[2]+"/"+addrdate.split("/")[1]+"/"+addrdate.split("/")[0];
		var tel = lines[1].substring(lines[1].indexOf("电  话")+6,lines[1].indexOf("传  真"));//电话
		tel = EAfunc.regexReplace(tel, "\\s+","");
		var fax = lines[1].substring(lines[1].indexOf("传  真")+6,lines[1].indexOf("店  址"));//传真
		fax = EAfunc.regexReplace(fax, "\\s+","");
		var addr = lines[1].substring(lines[1].indexOf("店  址")+6,lines[1].indexOf("邮  编"));//地址
		addr = EAfunc.regexReplace(addr, "\\s+","");
//		throw new Exception("corpnam"+corpnam+",bilid="+bilid+",date="+_date+",addrdate="+_addrdate+",tel="+tel+",fax="+fax+"\n,addr="+addr);
                //双引号里面的\r代表换行符
		var details = lines[3].split("\n");
		//throw  new Exception(lines[1]);
		var count = 1;
		for(var details_r = 0;details_r < details.length();details_r++)
		{
			if(details[details_r].length() > 0&&details[details_r] != "───")
			{
				var detail = EAfunc.regexReplace(details[details_r] , "\\s+",",");//抓明细
				var detail1 = EAfunc.regexReplace(details[details_r+1] , "\\s+",",");//抓明细
//				,102717619/,椰岛鹿龟酒一星33度/500,瓶,个,12,-,-,12.00,-,12.00,12.00,1,1,***,6901160007073,ml/瓶,0.00,	
				var itmid = detail.split(",")[1];
			
				var _itmnam = "";
				var zpqty = "";
			
				if(detail1.split(",").length() > 2)
					_itmnam = detail1.split(",")[2];
				zpqty = detail1.split(",")[detail1.split(",").length()-2];

//				if((detail1.split(",")[3]).indexOf(".") == -1)
//				{
//					_itmnam = detail1.split(",")[2];
//					zpqty = detail1.split(",")[4];
//				}
//				else
//				{
//					zpqty = detail1.split(",")[3];
//				}
			
				if(msgs != "")
				 	msgs += "╃";
				//srflg,userid,deptid,kaid,bilid,ecorpnam,ecorpid,itmclass,ordid,dat,arrdat,tel,fax,seqid,eitmid,code,spec,eitmnam,untnum,qtyflg,qty,zpqty,eprice,corpaddr,note,EBOPTION,org
				//&100143587&渔夫之宝特强薄荷糖(&盒&EA&12&12.00&0&12.00&1&1&原味)/11g/盒
				//SRFLG~~~USERID~~~DEPTID~~~KAID~~~BILID~~~ECORPNAM~~~ECORPID~~~ITMCLASS~~~ORDID~~~DAT~~~ARRDAT~~~
				//TEL~~~FAX~~~SEQID~~~EITMID~~~CODE~~~SPEC~~~EITMNAM~~~
				//QTYFLG~~~UNTNUM~~~QTY~~~ZPQTY~~~EPRICE~~~CORPADDR~~~NOTE~~~NULL
				msgs += "NR ~~~"+userid+"~~~"+deptid+"~~~"+kaid+"~~~"+bilid+"~~~"+corpnam+"~~~"+corpnam+"~~~ ~~~"+bilid+"~~~"+_date+"~~~"+_addrdate+"~~~"+
					tel+"~~~"+fax+"~~~"+count+"~~~"+itmid.substring(0,itmid.length()-1)+"~~~ ~~~"+detail.split(",")[3]+"~~~"+detail.split(",")[2]+_itmnam+
					"~~~ ~~~"+detail.split(",")[5]+"~~~"+detail.split(",")[9]+"~~~"+zpqty+"~~~"+detail.split(",")[6]+"~~~"+addr+"~~~ ~~~ ";
				count ++;
				details_r++;
			}
		}
	}
	return msgs;

}

//将字符串中的某些字符替换成""
function ReploaceStatment(str,array)
{
	
	for(var r = 0;r < array.length() ;r ++)
	{
		var replacestatment = array[r];
		while(true)
		{
			if (str.indexOf(replacestatment)>-1)			
				str = EAfunc.Replace(str,replacestatment,"");	
			else
			     break;
		}
	}
	return str;
}

function DeleteSameStatment(str,replacement1,replacement2)
{
	var strs = str.split(replacement1);
	var strs_1 = strs[1];
	for(var r = 2;r < strs.length()-1;r ++)
	{
		if(strs[r+1] == replacement2&&strs[r] == strs[r+1])
		{
			strs[r] = EAfunc.Replace(strs[r],replacement2,"");
			strs_1 += strs[r];
		}
		else
			strs_1 += strs[r];
	}
	return strs_1;
}


}