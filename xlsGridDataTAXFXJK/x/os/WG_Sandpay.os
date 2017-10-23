function x_WG_Sandpay(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var HClient = new JavaPackage("org.apache.commons.httpclient");
var method = new JavaPackage("org.apache.commons.httpclient.methods");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");



function getOrderStr() 
{
	var acc = "";
	var dat = "";
	var kaid = "";
	var userid = "";
	var passwd = "";
	var deptid = "";
	var code ="utf-8";//读取网页返回数据的编码
	var ret = ""; //保存网页返回来的数据
	var inf = ""; //保存是否成功的记录log 
	try{ 
		var db = new pubpack.EADatabase();
		var httpcall = new webget.HttpCall();
		var httpclient = new HClient.HttpClient();
		//登录罗森的供应商入口
		ret = httpcall.Post("http://www.sandpay.com.cn/website/shopservice/login.do","goto=login&imageField.y=16&imageField.x=34&map(loginId)=888888854110355&map(loginPwd)=54110355&");
		//返回要抓取网页数据的HTML文档
		ret = httpcall.Get("http://www.sandpay.com.cn/website/shopservice/balance.do?map(beginDay)=2010-07-01&map(endDay)=2010-08-01&currentPage=1&init=true&goto=shopbalance",code);
		
		//解析html字符串
		var HtmlParser = new x_WG_HtmlParser();
		var nodelist = HtmlParser.parserHtml(ret,code);
		
		//得到过滤要处理的标签后的nodelist对象
		nodelist = HtmlParser.filterHtml(nodelist,"tr");

		var form = null;
		var formAttr = "";
		var formlist = null;
		
		var tdlists = null;
		
		var tmp = "";
		//只处理tr中包含<td></td>的部分
		for (var i = 0;i<nodelist.size();i++)
		{
			form = nodelist.elementAt(i);	
			//tr中获取所有<td>标签 
			tdlists = form.getChildren();
			var tdlist = HtmlParser.filterHtml(tdlists,"td");
			if(tdlist.elementAt(1)!=null&&tdlist.elementAt(1).getFirstChild()!=null){
				var link = HtmlParser.filterHtml(tdlist,"A");//获取td下所有的<a></a>
				if(link!=null){
					link = link.elementAt(1);
					if(link!=null){
						var downlink = "http://www.sandpay.com.cn/website/shopservice/"+link.getAttribute("href");
						tmp += downlink  +"|";
						ret = httpcall.Post(downlink,"");
						//保存=为文件
						pub.EAFunc.WriteToFile("d:/EDIDownloads/sand/"+link.getStringText(),ret);
						
						var msg = imp2DB(ret);//把订单写入数据库
						if (msg != "ok") {
							if (inf != "") inf += "\n";
							inf += dat+"：\n"+ msg;
						}
						//下载文件并同时保存下来
						//HtmlParser.downloadFile(downlink,"d:/EDIDownloads/sand/"+link.getStringText());
					}
				}
			}
			

		}	
		throw new Exception(inf+"||"+tmp); 
				
	}catch(e){
		throw new Exception(e);
	}
	finally
	{
		if(db != null)
			db.Close();
	}	
}

//导入到数据库
function imp2DB(txt)
{
	var db = null;
	var sr = new java.io.StringReader(txt);
	var br = new java.io.BufferedReader(sr);
	var sql = "";
	var rw = 0;
//	try {
		var line = "";
		var rows = 0;
		var k = 0;
		var seqid = 0;
		var arrHdr = new Array(23);	//保存表头信息数组，下标按表字段顺序排
		var pc_success_no = 0;		//批次累计成功笔数记数
		var isExist = false;		//是否已导入标志

		db = new pub.EADatabase();
		
		var guid = db.GetSQL("select sys_guid() guid from dual");	//保存抓下来的订单表头GUID
		arrHdr[0] = guid;
		var tmp = "";
		while( (line = br.readLine()) != null) { 
			var str = line;
			//记录消费记录(表体)
			var arrDTL = new Array(11);
			var p = 0;//详细记录的数组arrDTL序号 
			if (line.length() < 1||line.indexOf("----------------------------------------------")>-1){//如果行为空则跳过不读取
				continue; 
			}else if(line.indexOf("交易明细单")>-1){//读取表头的数据
				//获取交易明细单  
				//读取位置6-25的字符 
				arrHdr[1]="";
				for(var i=6;i<25;i++){
					arrHdr[1]+=line.charAt(i);
				}
				//throw new Exception("arrHdr[1]="+arrHdr[1]);
				continue;
			}else if(line.indexOf("商户号")>-1&&line.indexOf("结算周期")>-1){ 
				//获取商户号和 
				arrHdr[2]=""; 
				for(var i=4;i<19;i++){
					arrHdr[2]+=line.charAt(i);
				}
				//结算周期 
				arrHdr[3]="";
				for(var i=51;i<76;i++){
					arrHdr[3]+=line.charAt(i);
				}
				throw new Exception("arrHdr[3]="+arrHdr[3]);
			}else if(str.length()>=120){ 
				arrDTL[0]="";//初始化为空否则在+=时会有undifined 
				for(var i = 0;i<str.length();i++){
					if(str.charAt(i)!=" "){//字符不是空格,写入数组
						arrDTL[p]+=str.charAt(i)+"";
					}else if(i!=0&&str.charAt(i*1-1)!=" "){//字符是空格,且空格后下一个字符不是空格则写入的数组+1
						p++;
						arrDTL[p]="";//初始化为空否则在+=时会有undifined
					}
				}
				tmp += arrDTL[8]+"|";
			}else{
				throw new Exception("格式有变动,代码可能需要改动");
			}

			
			

		}
		throw new Exception("tmp="+tmp );
		
		//文本内容有些比较特殊
		//ZL_103310054110522_20100607.txt
		//ZL_103310054110522_20100531.txt

//		while( (line = br.readLine()) != null) {
//			rows ++; k++; rw ++;
//			line = formatStr(line);			
//			rows = rows % 67;						
//			if (rows == 0) {												
//				rows ++;
//				continue;
//			}									
//			
//			if (line.length() < 1) continue;	//文件第一行是空行，一张单子共66行，可能会有一个文件有多张单子 如ZL_103310054110522_20100517.txt
//			
//			if (rows == 1) {
//				continue;
//			}
//			else if (rows == 2) {
//				arrHdr[1] = line;	//标题行
//			}
//			else if (rows == 3) {
//				arrHdr[5] = line;	//银联清算日期
//				arrHdr[5] = arrHdr[5].substring(arrHdr[5].indexOf(":")+1);
//			}
//			else if (rows == 4) {				
//				arrHdr[2] = line.substring(line.indexOf("行号:")+3,line.indexOf("商户号:"));		//行号
//				arrHdr[3] = line.substring(line.indexOf("商户号:")+4,line.indexOf("商户名称:"));	//商户号
//				arrHdr[4] = line.substring(line.indexOf("商户名称:")+5,line.indexOf("打印日期:"));	//商户名称
//				arrHdr[6] = line.substring(line.indexOf("打印日期:")+5);				//打印日期
//			}
//			//跳过分割线行和头说明行
//			else if (rows == 5) {
//				//检查看是否已导入，如果已经导入过则忽略
//				//判定条件：商户号+银联清算日期
//				sql = "select * from NK_95599_HDR where shopno='%s' and bankdat='%s' and printdat='s%'".format([arrHdr[3],arrHdr[5],arrHdr[6]]);
//				var cnt = db.GetSQLRowCount(sql);
//				if (cnt > 0) {
//					isExist = true;
//				}	
//				else {
//					isExist = false;
//				}	
//						
//				continue;
//			}
//			else if (rows == 6 || rows == 7) {
//				continue;
//			}
//			else {
//				if (line.substring(0,1) == "─") {
//					continue;
//				}
//				if (line.indexOf("批次累计成功笔数│") > -1) {
//					pc_success_no ++;
//					if (pc_success_no == 1) {
//						arrHdr[7] = line.substring(line.indexOf("批次累计成功笔数│")+9,line.indexOf("│批次累计成功金额│"));
//						arrHdr[8] = line.substring(line.indexOf("批次累计成功金额│")+9,line.length()-1);
//					}
//					else {
//						arrHdr[9] = line.substring(line.indexOf("批次累计成功笔数│")+9,line.indexOf("│批次累计成功金额│"));
//						arrHdr[10] = line.substring(line.indexOf("批次累计成功金额│")+9,line.length()-1);
//					}
//				}
//				else if (line.indexOf("终端累计成功笔数│") > -1) {
//					arrHdr[11] = line.substring(line.indexOf("终端累计成功笔数│")+9,line.indexOf("│终端累计成功金额│"));
//					arrHdr[12] = line.substring(line.indexOf("终端累计成功金额│")+9,line.length()-1);
//				}
//				else if (line.indexOf("商户累计成功笔数│") > -1) {
//					arrHdr[13] = line.substring(line.indexOf("商户累计成功笔数│")+9,line.indexOf("│商户累计成功金额│"));
//					arrHdr[14] = line.substring(line.indexOf("商户累计成功金额│")+9,line.indexOf("│商户回扣率│"));
//					arrHdr[15] = line.substring(line.indexOf("商户回扣率│")+6,line.indexOf("％"));	//去掉百分号
//					arrHdr[16] = line.substring(line.indexOf("商户扣率(2)│")+8,line.length()-2);		//去掉百分号
//				}
//				else if (line.indexOf("│发生额│") > -1) {
//					arrHdr[17] = line.substring(line.indexOf("│发生额│")+5,line.indexOf("│回扣费│"));
//					arrHdr[18] = line.substring(line.indexOf("│回扣费│")+5,line.indexOf("│调帐笔数│"));
//					arrHdr[19] = line.substring(line.indexOf("│调帐笔数│")+6,line.indexOf("│调帐金额│"));
//					arrHdr[20] = line.substring(line.indexOf("│调帐金额│")+6,line.indexOf("│划帐金额│"));
//					arrHdr[21] = line.substring(line.indexOf("│划帐金额│")+6,line.indexOf("│划账金额(2)│"));
//					arrHdr[22] = line.substring(line.indexOf("│划账金额(2)│")+9,line.length()-1);
//					
//					//不存在则写入
//					if (!isExist) {					
//						//写入表头NK_95599_HDR
//						sql = "insert into NK_95599_HDR select '%s','%s','%s','%s','%s','%s','%s','%s','%s',
//								'%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s' from dual"
//							.format([arrHdr[0],arrHdr[1],arrHdr[2],arrHdr[3],arrHdr[4],arrHdr[5],arrHdr[6],arrHdr[7],
//								arrHdr[8],arrHdr[9],arrHdr[10],arrHdr[11],arrHdr[12],arrHdr[13],arrHdr[14],arrHdr[15],
//								arrHdr[16],arrHdr[17],arrHdr[18],arrHdr[19],arrHdr[20],arrHdr[21],arrHdr[22]]);
//						db.ExcecutSQL(sql);
//						
//						guid = db.GetSQL("select sys_guid() guid from dual");	//表头GUID
//						arrHdr[0] = guid;
//						seqid = 0;
//						pc_success_no = 0;
//					}
//	
//				}
//				//下面拆分明细行记录
//				else {
//					seqid ++;
//					setDetail(db,guid,line,seqid,arrHdr[5],arrHdr[6]);
//				}			
//			}
//		}
		
					
		//db.Commit();
		return "ok";
//	}
//	catch ( e ) {
//		if (db != null) db.Rollback();
//		return "出错行号："+rw+e.toString();
//	}
//	finally {
//		if( sr != null) sr.close();
//		if( br != null) br.close();
//		if (db != null) db.Close();
//	}
}


}