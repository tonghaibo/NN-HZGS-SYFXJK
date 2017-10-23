function x_JM_OrderAction(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var iopack = new JavaPackage("java.io");
var utilpack = new JavaPackage("java.util");
//作为.sp服务时的入口
//预定义变量：request,response
function Response()
{
	
	
	
	var db = null;
	var sql = "";
	var EBGUID = "" ;  //读取ebconfig中用户名密码需要的guid
	var acc = "";		//帐套号
	var DAT ="" ;		//抓取日期
	var kaid = "";		//渠道编号
	var userid ="";		//用户名
	var passwd = "";	//密码	
	var deptid = "";	//部门编号
	var code = "";		//验证码
//	
//	
//	try{acc = request.getParameter("ACC");}catch(e){acc = "";} 
//	try{dat = request.getParameter("DAT");}catch(e){dat = "";} 
//	try{kaid = request.getParameter("KAID");}catch(e){kaid = "";} 
//	try{userid = request.getParameter("USERID");}catch(e){userid = "";} 
//	try{passwd = request.getParameter("PASSWD");}catch(e){passwd = "";} 
//	try{deptid = request.getParameter("DEPTID");}catch(e){deptid = "";} 
//	try{code = request.getParameter("CODE");}catch(e){code = "";} 
	
	
	
	var browser=pubpack.EAFunc.getBroswerType(request);
	if(true){
	//if (browser=="4"){ 
	//获取基础数据 
	//--------------------------------------------
		//throw new Exception("这是手机浏览器");
		var func=pubpack.EAFunc.NVL(request.getParameter("func"),"");//获取执行的函数名称如:save
		var data=pubpack.EAFunc.NVL(request.getParameter("_this"),"");//获取提交的数据.是一个xml
		var corpid=pubpack.EAFunc.NVL(request.getParameter("CORPID"),"");
		var locid=pubpack.EAFunc.NVL(request.getParameter("LOCID"),"");
		var corpsoid = pubpack.EAFunc.NVL(request.getParameter("CORPSOID"),"");
		//throw new Exception ("func="+func);
		var usr=web.EASession.GetLoginInfo(request);//获取当前用户信息
		var usrid = usr.getUsrid();
		var accid = usr.getAccid();
		var sytid = usr.getSytid();
		var orgid = usr.getOrgid();
		var db = null;//数据库
		var selforg = orgid; 
		var aimorg = orgid; 
		var acc = accid;
		var syt = sytid;
		var crtusr = usrid;
	//---------------------------------------------- 
		//读取手机的表格的数据
		//show.sp?grdid=HDRTRK&hdrordtl=2&hdrguid=984E55D55B624F4ABB70F88CDD3CC36D&style=31&prjid=TRA&edit=&dd=
		var xml="";
		xml=pubpack.EAJ2meUtil.getMainCellRangeXml(data);
		var row=xml.getRowCount();
		var col=xml.getColumnCount();
		var HDRORDTL = "";
		//throw new Exception(dat+"|"+ebguid);
		try{DAT=dat;}catch(e){DAT="";}
		try {
			//xml的行是从0开始计算,列从1开始计算(相对excel的行列)
			if(DAT=="")DAT = xml.get(0,1) ;//获取日期 
		} catch ( e ) {DAT ="";} 
		try{EBGUID=ebguid;}catch(e){EBGUID="";}
		try {
			//xml的行是从0开始计算,列从1开始计算(相对excel的行列)
			if(EBGUID=="")EBGUID = xml.get(1,1) ;//获取ebconfig的guid用于读取登录的用户名密码 
		} catch ( e ) {EBGUID ="";} 
		if(DAT==""){throw new Exception("日期为空");} 
		//throw new Exception("日期="+dat); 
	//----------------------------------- 
		//读取登录渠道(如:家乐福)需要的用户名密码
		
		try
		{
		            db = new pubpack.EADatabase();
		            sql = "select userid,passwd,trim(kaid) kaid from ebconfig where guid='"+EBGUID+"'";
		            var ds = db.QuerySQL(sql);
		            
		            if(ds.getRowCount()>0){
		            	userid = ds.getStringAt(0,"userid");
		            	passwd = ds.getStringAt(0,"passwd");
		            	kaid = ds.getStringAt(0,"kaid");
		            }else{
		            	throw new Exception("无法获取到登录渠道需要的用户名和密码"+sql);
		            }

		}
		catch(e)
		{
		      	if( db!= null ) db.Rollback();
			throw e;
		}
		finally
		{
			db.Close(); 
		}       

		
	}
	//throw new Exception(dat+"|"+kaid+"|"+userid+"|"+passwd);
	//--------------------------------------------------
	//抓取订单...返回抓下来的订单...格式是自己定义的一定格式的字符串
	//通过上面获得的渠道，帐套信息，可以分发应该是哪个OS处理的
	//需要配置表，就是根据渠道来选择处理的中间件名
	//这里先写死家乐福，后面抓别的渠道再扩展
//	var str = acc+"~"+dat+"~"+kaid+"~"+userid+"~"+passwd+"~"+deptid+"~"+code;
//	var osObj = new pubpack.EAScript(db);
//	var args = str.split("~");
// 	return osObj.CallClassFunc("WG_Carrefour","getOrderStr",args);
	throw new Exception(kaid);
	var ret = getOS(kaid).getOrderStr(acc,DAT,kaid,userid,passwd,deptid,code);

//	var func = new x_WG_Currefour();
//	response.setCharacterEncoding("gbk");
	//deptid空,code从数据库中取,dat抓取日期,acc 用户acc , kaid 渠道,userid passwd 登录需要的用户名密码
//	var ret = func.getOrderStr(acc,DAT,kaid,userid,passwd,deptid,code);//抓下来的订单的字符串 
	//-------------------------------------------------- 
	return doStrToDB(ret);
		
}


//================================================================// 
// 函数：doStrToDB
// 说明：把服务器返回的字符串插入数据库
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：05/18/10 11:30:09
// 修改日志：
//================================================================// 
var EBID = 4;//订单单据号对应的列号
var EBSEQ = 12;//订单单据明细号对应列号
var EBKA = 2;
var MidTab = "ORD_TMP";//订单中间表
function doStrToDB(data)
{
	var acc = "JQPX";//accid 
	var dat = "2010-07-27";//时间 
	var str = data;//~12312~asdf~格式的订单字符串 
	
	
	
	var db = null;
	var br = null;
	var ds = null;
	var s = "";
	var sql = "";
	var pstmt = null;
	var msg = 0;
	var map = new utilpack.HashMap();	
	var row = null;//字符串中的每一行都是一张订单的商品明细,商品明细中以"~~~"分割的数组
	try{
		db = new pubpack.EADatabase(); 
		br = new iopack.BufferedReader(new iopack.StringReader(str));
		while((s = br.readLine())!=null)
		{
			row = s.split("~~~");
			sql = "select * from ord_tmp where ordid='"+row[EBID]+"' and seqid='"+row[EBSEQ]+"'";
			var tmpds = db.QuerySQL(sql);
			if (tmpds.getRowCount()==0)
			{
				if(map.containsKey(row[EBKA]))
				{
					var tmp = map.get(row[EBKA]);
					tmp += row[EBID];
					map.remove(row[EBKA]);
					map.put(row[EBKA],row[EBID]);
				}
				else{
					map.put(row[EBKA],row[EBID]);
				}
				//这里要过滤掉如果订单每一个商品明细对应的订单单据号与订单明细号在数据库如果有存在就不做插入数据库的动作
				sql = " insert into "+MidTab+" a(srflg,userid,deptid,kaid,bilid,ecorpnam,ecorpid,itmclass,ordid,dat,arrdat,tel,fax,seqid,eitmid,
								code,spec,eitmnam,untnum,qty,zpqty,eprice) 
				        values(trim(?),trim(?),trim(?),trim(?),trim(?),trim(?),trim(?),trim(?),trim(?),to_char(to_date(?,'dd/mm/yyyy'),'yyyy-mm-dd'),
				        to_char(to_date(?,'dd/mm/yyyy'),'yyyy-mm-dd'),trim(?),trim(?),trim(?),trim(?),trim(?),trim(?),trim(?),to_number(?),to_number(?),to_number(?),to_number(?,'999999.9999'))
				       ";
				
				pstmt = db.GetConn().prepareStatement(sql);	
						
				if(tmpds.getRowCount()==0)			
				{
					var xyz="";
					//throw new Exception(row.length());
					for ( var r=0;r<row.length();r++)
					{					
						
						pstmt.setString(r+1,row[r]);	
						xyz+=(r+1)+":"+row[r]+"|";
//						if(r+1==21)throw new Exception(xyz);
					}
					
					pstmt.addBatch();
					msg++;
				}
//				throw new Exception (sql);
				pstmt.executeBatch();
				
			}														
		 }		
		 var set = map.keySet();
		 var it = set.iterator();
		 while(it.hasNext())
		 {
		 	var ka = it.next();
		 	sql = " insert into msg(title,note)values('"+ka+"'||'新订单','"+ka+"'||'新订单明细：'||'"+map.get(ka)+"')";
		 	db.ExcecutSQL(sql);
		 }
		db.Commit();
		return msg;
	}catch(e){
		db.Rollback();
		throw new Exception(e);
	}	 
	finally{
		if(br!=null) 
			br.close();
	}
} 
function setOS()
{
	map.put("0004",new x_WG_GMS());	//吉买盛
	map.put("0005",new x_WG_Currefour());//家乐福
	map.put("0001",new x_WG_RtMart());//大润发
	map.put("0010",new x_WG_CenturyMart());//世纪联华
	map.put("0000",new x_WG_EkChor());//易初莲花
}

function getOS(kaid)
{
	if (map.containsKey(kaid))
		return map.get(kaid);
}

//显示查询参数前预处理
//用于在查询或报表显示查询参数前的预处理。
//可以往sb（StringBuffer）中append HTML内容或额外附近脚本
//可以修改paramDs的内容，决定哪些参数可见或修改默认值
//  ID:编号;  NAME:标题; KEYVAL:关键字; SQLWHE:WHERE条件; DEFVAL:默认值
//  TIP:提示; EDTFLG:是否可修改;  VISFLG:是否可显示; KEYFLG:关键字段(没有作用)
//  DISPORD:参数显示次序号(修改无效); INPCTL:控件类型
function beforeShowParam(request,sb,paramDs,usrinfo)
//var request=javax.servlet.http.HttpServletRequest(); var sb = new java.lang.StringBuffer();var paramDs = new EAXmlDS();var usrinfo = new web.EAUserinfo();
{
	//获取传过来的参数
	var kaid = request.getParameter("kaid");
//	sb.append("<script type='text/javascript' src='xlsgrid/js/jquery-1.3.1.js'></script>\n");  
	sb.append("<script type='text/javascript' src='http://www.xlsgrid.net/xlsgrid/xlsgrid/js/jquery-1.3.2.min.js'></script>\n"); //压缩版
//	sb.append("<script language='javascript' src='xlsgrid/js/svgchart.js' ></Script>\n");
	sb.append("<script type='text/javascript'>");
	//为了在页面可以使用客户端控件
	sb.append("function CreateControl(ObjectID, WIDTH, HEIGHT){
		  	document.write( '<object classid=clsid:37CC6FCD-9BF5-4433-B3F3-576E08025EA8 id=' + ObjectID  
		   	+ ' width=' + WIDTH + ' height=' + HEIGHT +'>'+'</OBJECT>');
		    }
		    CreateControl('svg','100%','100%');
		    var _this = document.getElementById('svg');
	");
	//添加jquery的脚本 根据查询语句更改查询条件
	sb.append("
		$(document).ready(function() {
		//文档加载完执行
//                		alert(\"select changed.\"+$(this).val());
                		var orgid = $(this).val();

				$.ajax({
					type:'GET',
					//发送请求获得视图的xml,where参数是sql条件语句 ,collist是获得的column名称 
					url:\"XmlDB.sp?bind=V_EBCONFIG&where=KAID%3d'"+kaid+"'&collist=id,name\",
					
					dataType:'text/xml',
					error:function(XMLResponse){
						alert(arguments[1]); //中间件平台返回的XML的encoding=GBK,而ajax要求是utf-8
						//alert(XMLResponse.responseText)
					},
					success:function(xml) {
						
						var id,name;
						//alert(xml);
						$(\"select[name=ebconfig]\").empty();// 清空下拉框
//						$(xml).find('ROW').each(function(){	//在IE下解释XML格式数据有问题，FIREFOX下正常
//							id = $(this).children('ID').text();
//							name = $(this).children('NAME').text();
//							alert('usri='+id+' usrname='+name);
//							//$(\"<option value='\"+id+\"'>\"+name+\"</option>\").appendTo(\"select[name=usrid]\");
//							$(\"select[name=usrid]\").append(\"<option value='\"+id+\"'>\"+name+\"</option>\");
//							
//						});
						_this.XMLDS_Reset();
						_this.XMLDS_Parse(xml);
						
						//设定下拉框的值
						for (var i=0;i<_this.XMLDS_GetRowCount();i++) {
							var id = _this.XMLDS_GetString(i,\"ID\");
							var name = _this.XMLDS_GetString(i,\"NAME\");
							$(\"select[name=ebconfig]\").append(\"<option value='\"+id+\"'>\"+name+\"</option>\");
						}
					}
				});

        	});
	
	
	");
	sb.append("</script>
	");
}



}