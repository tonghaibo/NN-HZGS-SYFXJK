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
	var code ="utf-8";//��ȡ��ҳ�������ݵı���
	var ret = ""; //������ҳ������������
	var inf = ""; //�����Ƿ�ɹ��ļ�¼log 
	try{ 
		var db = new pubpack.EADatabase();
		var httpcall = new webget.HttpCall();
		var httpclient = new HClient.HttpClient();
		//��¼��ɭ�Ĺ�Ӧ�����
		ret = httpcall.Post("http://www.sandpay.com.cn/website/shopservice/login.do","goto=login&imageField.y=16&imageField.x=34&map(loginId)=888888854110355&map(loginPwd)=54110355&");
		//����Ҫץȡ��ҳ���ݵ�HTML�ĵ�
		ret = httpcall.Get("http://www.sandpay.com.cn/website/shopservice/balance.do?map(beginDay)=2010-07-01&map(endDay)=2010-08-01&currentPage=1&init=true&goto=shopbalance",code);
		
		//����html�ַ���
		var HtmlParser = new x_WG_HtmlParser();
		var nodelist = HtmlParser.parserHtml(ret,code);
		
		//�õ�����Ҫ����ı�ǩ���nodelist����
		nodelist = HtmlParser.filterHtml(nodelist,"tr");

		var form = null;
		var formAttr = "";
		var formlist = null;
		
		var tdlists = null;
		
		var tmp = "";
		//ֻ����tr�а���<td></td>�Ĳ���
		for (var i = 0;i<nodelist.size();i++)
		{
			form = nodelist.elementAt(i);	
			//tr�л�ȡ����<td>��ǩ 
			tdlists = form.getChildren();
			var tdlist = HtmlParser.filterHtml(tdlists,"td");
			if(tdlist.elementAt(1)!=null&&tdlist.elementAt(1).getFirstChild()!=null){
				var link = HtmlParser.filterHtml(tdlist,"A");//��ȡtd�����е�<a></a>
				if(link!=null){
					link = link.elementAt(1);
					if(link!=null){
						var downlink = "http://www.sandpay.com.cn/website/shopservice/"+link.getAttribute("href");
						tmp += downlink  +"|";
						ret = httpcall.Post(downlink,"");
						//����=Ϊ�ļ�
						pub.EAFunc.WriteToFile("d:/EDIDownloads/sand/"+link.getStringText(),ret);
						
						var msg = imp2DB(ret);//�Ѷ���д�����ݿ�
						if (msg != "ok") {
							if (inf != "") inf += "\n";
							inf += dat+"��\n"+ msg;
						}
						//�����ļ���ͬʱ��������
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

//���뵽���ݿ�
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
		var arrHdr = new Array(23);	//�����ͷ��Ϣ���飬�±갴���ֶ�˳����
		var pc_success_no = 0;		//�����ۼƳɹ���������
		var isExist = false;		//�Ƿ��ѵ����־

		db = new pub.EADatabase();
		
		var guid = db.GetSQL("select sys_guid() guid from dual");	//����ץ�����Ķ�����ͷGUID
		arrHdr[0] = guid;
		var tmp = "";
		while( (line = br.readLine()) != null) { 
			var str = line;
			//��¼���Ѽ�¼(����)
			var arrDTL = new Array(11);
			var p = 0;//��ϸ��¼������arrDTL��� 
			if (line.length() < 1||line.indexOf("----------------------------------------------")>-1){//�����Ϊ������������ȡ
				continue; 
			}else if(line.indexOf("������ϸ��")>-1){//��ȡ��ͷ������
				//��ȡ������ϸ��  
				//��ȡλ��6-25���ַ� 
				arrHdr[1]="";
				for(var i=6;i<25;i++){
					arrHdr[1]+=line.charAt(i);
				}
				//throw new Exception("arrHdr[1]="+arrHdr[1]);
				continue;
			}else if(line.indexOf("�̻���")>-1&&line.indexOf("��������")>-1){ 
				//��ȡ�̻��ź� 
				arrHdr[2]=""; 
				for(var i=4;i<19;i++){
					arrHdr[2]+=line.charAt(i);
				}
				//�������� 
				arrHdr[3]="";
				for(var i=51;i<76;i++){
					arrHdr[3]+=line.charAt(i);
				}
				throw new Exception("arrHdr[3]="+arrHdr[3]);
			}else if(str.length()>=120){ 
				arrDTL[0]="";//��ʼ��Ϊ�շ�����+=ʱ����undifined 
				for(var i = 0;i<str.length();i++){
					if(str.charAt(i)!=" "){//�ַ����ǿո�,д������
						arrDTL[p]+=str.charAt(i)+"";
					}else if(i!=0&&str.charAt(i*1-1)!=" "){//�ַ��ǿո�,�ҿո����һ���ַ����ǿո���д�������+1
						p++;
						arrDTL[p]="";//��ʼ��Ϊ�շ�����+=ʱ����undifined
					}
				}
				tmp += arrDTL[8]+"|";
			}else{
				throw new Exception("��ʽ�б䶯,���������Ҫ�Ķ�");
			}

			
			

		}
		throw new Exception("tmp="+tmp );
		
		//�ı�������Щ�Ƚ�����
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
//			if (line.length() < 1) continue;	//�ļ���һ���ǿ��У�һ�ŵ��ӹ�66�У����ܻ���һ���ļ��ж��ŵ��� ��ZL_103310054110522_20100517.txt
//			
//			if (rows == 1) {
//				continue;
//			}
//			else if (rows == 2) {
//				arrHdr[1] = line;	//������
//			}
//			else if (rows == 3) {
//				arrHdr[5] = line;	//������������
//				arrHdr[5] = arrHdr[5].substring(arrHdr[5].indexOf(":")+1);
//			}
//			else if (rows == 4) {				
//				arrHdr[2] = line.substring(line.indexOf("�к�:")+3,line.indexOf("�̻���:"));		//�к�
//				arrHdr[3] = line.substring(line.indexOf("�̻���:")+4,line.indexOf("�̻�����:"));	//�̻���
//				arrHdr[4] = line.substring(line.indexOf("�̻�����:")+5,line.indexOf("��ӡ����:"));	//�̻�����
//				arrHdr[6] = line.substring(line.indexOf("��ӡ����:")+5);				//��ӡ����
//			}
//			//�����ָ����к�ͷ˵����
//			else if (rows == 5) {
//				//��鿴�Ƿ��ѵ��룬����Ѿ�����������
//				//�ж��������̻���+������������
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
//				if (line.substring(0,1) == "��") {
//					continue;
//				}
//				if (line.indexOf("�����ۼƳɹ�������") > -1) {
//					pc_success_no ++;
//					if (pc_success_no == 1) {
//						arrHdr[7] = line.substring(line.indexOf("�����ۼƳɹ�������")+9,line.indexOf("�������ۼƳɹ���"));
//						arrHdr[8] = line.substring(line.indexOf("�����ۼƳɹ���")+9,line.length()-1);
//					}
//					else {
//						arrHdr[9] = line.substring(line.indexOf("�����ۼƳɹ�������")+9,line.indexOf("�������ۼƳɹ���"));
//						arrHdr[10] = line.substring(line.indexOf("�����ۼƳɹ���")+9,line.length()-1);
//					}
//				}
//				else if (line.indexOf("�ն��ۼƳɹ�������") > -1) {
//					arrHdr[11] = line.substring(line.indexOf("�ն��ۼƳɹ�������")+9,line.indexOf("���ն��ۼƳɹ���"));
//					arrHdr[12] = line.substring(line.indexOf("�ն��ۼƳɹ���")+9,line.length()-1);
//				}
//				else if (line.indexOf("�̻��ۼƳɹ�������") > -1) {
//					arrHdr[13] = line.substring(line.indexOf("�̻��ۼƳɹ�������")+9,line.indexOf("���̻��ۼƳɹ���"));
//					arrHdr[14] = line.substring(line.indexOf("�̻��ۼƳɹ���")+9,line.indexOf("���̻��ؿ��ʩ�"));
//					arrHdr[15] = line.substring(line.indexOf("�̻��ؿ��ʩ�")+6,line.indexOf("��"));	//ȥ���ٷֺ�
//					arrHdr[16] = line.substring(line.indexOf("�̻�����(2)��")+8,line.length()-2);		//ȥ���ٷֺ�
//				}
//				else if (line.indexOf("�������") > -1) {
//					arrHdr[17] = line.substring(line.indexOf("�������")+5,line.indexOf("���ؿ۷ѩ�"));
//					arrHdr[18] = line.substring(line.indexOf("���ؿ۷ѩ�")+5,line.indexOf("�����ʱ�����"));
//					arrHdr[19] = line.substring(line.indexOf("�����ʱ�����")+6,line.indexOf("�����ʽ�"));
//					arrHdr[20] = line.substring(line.indexOf("�����ʽ�")+6,line.indexOf("�����ʽ�"));
//					arrHdr[21] = line.substring(line.indexOf("�����ʽ�")+6,line.indexOf("�����˽��(2)��"));
//					arrHdr[22] = line.substring(line.indexOf("�����˽��(2)��")+9,line.length()-1);
//					
//					//��������д��
//					if (!isExist) {					
//						//д���ͷNK_95599_HDR
//						sql = "insert into NK_95599_HDR select '%s','%s','%s','%s','%s','%s','%s','%s','%s',
//								'%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s' from dual"
//							.format([arrHdr[0],arrHdr[1],arrHdr[2],arrHdr[3],arrHdr[4],arrHdr[5],arrHdr[6],arrHdr[7],
//								arrHdr[8],arrHdr[9],arrHdr[10],arrHdr[11],arrHdr[12],arrHdr[13],arrHdr[14],arrHdr[15],
//								arrHdr[16],arrHdr[17],arrHdr[18],arrHdr[19],arrHdr[20],arrHdr[21],arrHdr[22]]);
//						db.ExcecutSQL(sql);
//						
//						guid = db.GetSQL("select sys_guid() guid from dual");	//��ͷGUID
//						arrHdr[0] = guid;
//						seqid = 0;
//						pc_success_no = 0;
//					}
//	
//				}
//				//��������ϸ�м�¼
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
//		return "�����кţ�"+rw+e.toString();
//	}
//	finally {
//		if( sr != null) sr.close();
//		if( br != null) br.close();
//		if (db != null) db.Close();
//	}
}


}