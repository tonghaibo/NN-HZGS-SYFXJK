function x_JM_OrderAction(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var iopack = new JavaPackage("java.io");
var utilpack = new JavaPackage("java.util");
//��Ϊ.sp����ʱ�����
//Ԥ���������request,response
function Response()
{
	
	
	
	var db = null;
	var sql = "";
	var EBGUID = "" ;  //��ȡebconfig���û���������Ҫ��guid
	var acc = "";		//���׺�
	var DAT ="" ;		//ץȡ����
	var kaid = "";		//�������
	var userid ="";		//�û���
	var passwd = "";	//����	
	var deptid = "";	//���ű��
	var code = "";		//��֤��
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
	//��ȡ�������� 
	//--------------------------------------------
		//throw new Exception("�����ֻ������");
		var func=pubpack.EAFunc.NVL(request.getParameter("func"),"");//��ȡִ�еĺ���������:save
		var data=pubpack.EAFunc.NVL(request.getParameter("_this"),"");//��ȡ�ύ������.��һ��xml
		var corpid=pubpack.EAFunc.NVL(request.getParameter("CORPID"),"");
		var locid=pubpack.EAFunc.NVL(request.getParameter("LOCID"),"");
		var corpsoid = pubpack.EAFunc.NVL(request.getParameter("CORPSOID"),"");
		//throw new Exception ("func="+func);
		var usr=web.EASession.GetLoginInfo(request);//��ȡ��ǰ�û���Ϣ
		var usrid = usr.getUsrid();
		var accid = usr.getAccid();
		var sytid = usr.getSytid();
		var orgid = usr.getOrgid();
		var db = null;//���ݿ�
		var selforg = orgid; 
		var aimorg = orgid; 
		var acc = accid;
		var syt = sytid;
		var crtusr = usrid;
	//---------------------------------------------- 
		//��ȡ�ֻ��ı�������
		//show.sp?grdid=HDRTRK&hdrordtl=2&hdrguid=984E55D55B624F4ABB70F88CDD3CC36D&style=31&prjid=TRA&edit=&dd=
		var xml="";
		xml=pubpack.EAJ2meUtil.getMainCellRangeXml(data);
		var row=xml.getRowCount();
		var col=xml.getColumnCount();
		var HDRORDTL = "";
		//throw new Exception(dat+"|"+ebguid);
		try{DAT=dat;}catch(e){DAT="";}
		try {
			//xml�����Ǵ�0��ʼ����,�д�1��ʼ����(���excel������)
			if(DAT=="")DAT = xml.get(0,1) ;//��ȡ���� 
		} catch ( e ) {DAT ="";} 
		try{EBGUID=ebguid;}catch(e){EBGUID="";}
		try {
			//xml�����Ǵ�0��ʼ����,�д�1��ʼ����(���excel������)
			if(EBGUID=="")EBGUID = xml.get(1,1) ;//��ȡebconfig��guid���ڶ�ȡ��¼���û������� 
		} catch ( e ) {EBGUID ="";} 
		if(DAT==""){throw new Exception("����Ϊ��");} 
		//throw new Exception("����="+dat); 
	//----------------------------------- 
		//��ȡ��¼����(��:���ָ�)��Ҫ���û�������
		
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
		            	throw new Exception("�޷���ȡ����¼������Ҫ���û���������"+sql);
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
	//ץȡ����...����ץ�����Ķ���...��ʽ���Լ������һ����ʽ���ַ���
	//ͨ�������õ�������������Ϣ�����Էַ�Ӧ�����ĸ�OS�����
	//��Ҫ���ñ����Ǹ���������ѡ������м����
	//������д�����ָ�������ץ�����������չ
//	var str = acc+"~"+dat+"~"+kaid+"~"+userid+"~"+passwd+"~"+deptid+"~"+code;
//	var osObj = new pubpack.EAScript(db);
//	var args = str.split("~");
// 	return osObj.CallClassFunc("WG_Carrefour","getOrderStr",args);
	throw new Exception(kaid);
	var ret = getOS(kaid).getOrderStr(acc,DAT,kaid,userid,passwd,deptid,code);

//	var func = new x_WG_Currefour();
//	response.setCharacterEncoding("gbk");
	//deptid��,code�����ݿ���ȡ,datץȡ����,acc �û�acc , kaid ����,userid passwd ��¼��Ҫ���û�������
//	var ret = func.getOrderStr(acc,DAT,kaid,userid,passwd,deptid,code);//ץ�����Ķ������ַ��� 
	//-------------------------------------------------- 
	return doStrToDB(ret);
		
}


//================================================================// 
// ������doStrToDB
// ˵�����ѷ��������ص��ַ����������ݿ�
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�05/18/10 11:30:09
// �޸���־��
//================================================================// 
var EBID = 4;//�������ݺŶ�Ӧ���к�
var EBSEQ = 12;//����������ϸ�Ŷ�Ӧ�к�
var EBKA = 2;
var MidTab = "ORD_TMP";//�����м��
function doStrToDB(data)
{
	var acc = "JQPX";//accid 
	var dat = "2010-07-27";//ʱ�� 
	var str = data;//~12312~asdf~��ʽ�Ķ����ַ��� 
	
	
	
	var db = null;
	var br = null;
	var ds = null;
	var s = "";
	var sql = "";
	var pstmt = null;
	var msg = 0;
	var map = new utilpack.HashMap();	
	var row = null;//�ַ����е�ÿһ�ж���һ�Ŷ�������Ʒ��ϸ,��Ʒ��ϸ����"~~~"�ָ������
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
				//����Ҫ���˵��������ÿһ����Ʒ��ϸ��Ӧ�Ķ������ݺ��붩����ϸ�������ݿ�����д��ھͲ����������ݿ�Ķ���
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
		 	sql = " insert into msg(title,note)values('"+ka+"'||'�¶���','"+ka+"'||'�¶�����ϸ��'||'"+map.get(ka)+"')";
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
	map.put("0004",new x_WG_GMS());	//����ʢ
	map.put("0005",new x_WG_Currefour());//���ָ�
	map.put("0001",new x_WG_RtMart());//����
	map.put("0010",new x_WG_CenturyMart());//��������
	map.put("0000",new x_WG_EkChor());//�׳�����
}

function getOS(kaid)
{
	if (map.containsKey(kaid))
		return map.get(kaid);
}

//��ʾ��ѯ����ǰԤ����
//�����ڲ�ѯ�򱨱���ʾ��ѯ����ǰ��Ԥ����
//������sb��StringBuffer����append HTML���ݻ���⸽���ű�
//�����޸�paramDs�����ݣ�������Щ�����ɼ����޸�Ĭ��ֵ
//  ID:���;  NAME:����; KEYVAL:�ؼ���; SQLWHE:WHERE����; DEFVAL:Ĭ��ֵ
//  TIP:��ʾ; EDTFLG:�Ƿ���޸�;  VISFLG:�Ƿ����ʾ; KEYFLG:�ؼ��ֶ�(û������)
//  DISPORD:������ʾ�����(�޸���Ч); INPCTL:�ؼ�����
function beforeShowParam(request,sb,paramDs,usrinfo)
//var request=javax.servlet.http.HttpServletRequest(); var sb = new java.lang.StringBuffer();var paramDs = new EAXmlDS();var usrinfo = new web.EAUserinfo();
{
	//��ȡ�������Ĳ���
	var kaid = request.getParameter("kaid");
//	sb.append("<script type='text/javascript' src='xlsgrid/js/jquery-1.3.1.js'></script>\n");  
	sb.append("<script type='text/javascript' src='http://www.xlsgrid.net/xlsgrid/xlsgrid/js/jquery-1.3.2.min.js'></script>\n"); //ѹ����
//	sb.append("<script language='javascript' src='xlsgrid/js/svgchart.js' ></Script>\n");
	sb.append("<script type='text/javascript'>");
	//Ϊ����ҳ�����ʹ�ÿͻ��˿ؼ�
	sb.append("function CreateControl(ObjectID, WIDTH, HEIGHT){
		  	document.write( '<object classid=clsid:37CC6FCD-9BF5-4433-B3F3-576E08025EA8 id=' + ObjectID  
		   	+ ' width=' + WIDTH + ' height=' + HEIGHT +'>'+'</OBJECT>');
		    }
		    CreateControl('svg','100%','100%');
		    var _this = document.getElementById('svg');
	");
	//���jquery�Ľű� ���ݲ�ѯ�����Ĳ�ѯ����
	sb.append("
		$(document).ready(function() {
		//�ĵ�������ִ��
//                		alert(\"select changed.\"+$(this).val());
                		var orgid = $(this).val();

				$.ajax({
					type:'GET',
					//������������ͼ��xml,where������sql������� ,collist�ǻ�õ�column���� 
					url:\"XmlDB.sp?bind=V_EBCONFIG&where=KAID%3d'"+kaid+"'&collist=id,name\",
					
					dataType:'text/xml',
					error:function(XMLResponse){
						alert(arguments[1]); //�м��ƽ̨���ص�XML��encoding=GBK,��ajaxҪ����utf-8
						//alert(XMLResponse.responseText)
					},
					success:function(xml) {
						
						var id,name;
						//alert(xml);
						$(\"select[name=ebconfig]\").empty();// ���������
//						$(xml).find('ROW').each(function(){	//��IE�½���XML��ʽ���������⣬FIREFOX������
//							id = $(this).children('ID').text();
//							name = $(this).children('NAME').text();
//							alert('usri='+id+' usrname='+name);
//							//$(\"<option value='\"+id+\"'>\"+name+\"</option>\").appendTo(\"select[name=usrid]\");
//							$(\"select[name=usrid]\").append(\"<option value='\"+id+\"'>\"+name+\"</option>\");
//							
//						});
						_this.XMLDS_Reset();
						_this.XMLDS_Parse(xml);
						
						//�趨�������ֵ
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