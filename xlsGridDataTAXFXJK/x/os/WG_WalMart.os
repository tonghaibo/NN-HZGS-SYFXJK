function x_WG_WalMart(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var pub = new JavaPackage("com.xlsgrid.net.pub");
var httpcall = new webget.HttpCall();

var m_bilds = new pub.EADS();		//�����б� BilDS
var m_bilid = "";			//�������
var m_bilguid = "";			//�����ڲ����
var m_addid = "";			//����������ַ
var m_bilEnd = false;			//�����б�������
var m_bEntryHdr = false;		//��ͷ��ʼץȡ���
var m_colnamlist = new Array("��Ӧ����","��Ӧ�̺�","������","��������","��������","����");				//��ͷ��ץȡ��<TD>Info
var t_bilhdr = new pub.EADS();		//��ͷ��ץȡ TmpDS
var t_hdrrow = -1;
var m_colidlist = new Array("BILID","CORPNAM","CORPID","DEPT","������","DAT","����������","�绰����","�������");	//���ָ�ץȡ��<TD>Info
var m_bilhdr = new pub.EADS();		//���ָ���ʽ HdrDS
var m_hdrrow = -1;
var m_bEntryDtl = false;		//���忪ʼץȡ���
var m_bildtlstartflg = "�ϼƳɱ�";	//���忪ʼץȡ�ַ�����
var m_bildtlrowStat1 = false;		//��������б�� Stat
var m_bildtlrowStat2 = false;		//������ϸ�б�� Stat
var m_bildtlcolseq1 = 0;		//��������б�� Seqid
var m_bildtlcolseq2 = 0;		//������ϸ�б�� Seqid
var m_bildtl = new pub.EADS();		//���ָ���ʽ DtlDS���ɹ��첻ͬ��ʽ��DS��������������������˼��ָ��Ľ������������Ը�ʽ�ͼ��ָ���ͬ�����밴˳��
var m_dtlrow = -1;
var m_lastcolnam = "";			//��һ���ڵ�<TD>Value

function start()
{
	return getOrderStr("GMHD","2012-07-11","0012","bri950a","Jing003","dept","UTF-8");
}

function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
{
	var ret = "";
	var param = "";
	
	try {
		//1.��¼
		var loginurl = "https://rllogin.wal-mart.com/rl_security/rl_logon.aspx";
		param = "__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=%2FwEPDwULLTE0OTY5MTU2ODkPZBYCZg9kFgICCQ9kFgJmD2QWAmYPZBYCAgEPZBYCAgIPZBYCZg9kFgICAQ8PZBYEHgtvbm1vdXNlb3ZlcgUbdGhpcy5jbGFzc05hbWU9J2J0biBidG5ob3YnHgpvbm1vdXNlb3V0BRR0aGlzLmNsYXNzTmFtZT0nYnRuJ2RkPwsM6QfmB7nLs3YhaSzFQIMfpgs%3D&__EVENTVALIDATION=%2FwEWBwLeg6%2BXDAK145qeCgK7iKX4CAKgmu7gDwLB2tiHDgLKw6LdBQLvz%2FGACruWvf18O2f4%2Bkt%2BWRX4INDqRZCf&hidFailedLoginCount=&redirect=%2Frl_security%2Frl_logon.aspx&hidPwdErrHandledFlag=FALSE&txtUser="+userid+"&txtPass="+passwd+"&Login=%C1%AA%BB%FA%2F%B5%C7%C2%BC";
		ret = httpcall.Post(loginurl,param,code);
		ret = httpcall.Get(loginurl+"?"+param,code);
		
	        //2.�õ��ʼ��б�
	        var pageurl = "https://retaillink.wal-mart.com";
	        //2.1 ��վ��ͼ
//		ret = httpcall.Get(pageurl+"/sitemap/sitemap.aspx",code);
		//2.2 E-Commerce/EDI
//		ret = httpcall.Get(pageurl+"/edi/default.aspx?ch=H19&ukey=W5294",code);
		//2.3 WebEDI
		var node = httpcall.GetAndParse(pageurl+"/edi/webedi",code);
		GetBillist(node,dat);
		//2.4 �ѽ���
		param = "__VIEWSTATE=%2FwEPDwUKLTMwNjE2NzQ3N2Rknx5Ra9ay55QcvhTs%2FIpXdKLD7PU%3D&MailboxId=22856&VendorCountry=CN&PONumber=&StoreNumber=&DocumentType=850&Status=20&SortBy=3&SortOrder=DESC&IsPaginated=false&PageIndex=0&PageSize=10";
//		ret = httpcall.Post(pageurl+"/edi/webedi",param,code);
		node =  httpcall.PostAndParse(pageurl+"/edi/webedi",param,code);
		GetBillist(node,dat);
		
		//3.������
		for (var i = 0; i < m_bilds.getRowCount(); i ++) {
			m_bilguid = m_bilds.getStringAt(i,"BILGUID");
			m_addid = m_bilds.getStringAt(i,"ADDID");
			
//			ret = httpcall.Get(pageurl+m_bilguid,code);
			node = httpcall.GetAndParse(pageurl+m_bilguid,code);
			m_bEntryHdr = false;
			m_bEntryDtl = false;
			m_lastcolnam= "";
			m_bildtlcolseq1= 0;
			GetBildetail(node);
		}
//		return m_bilhdr.GetXml()+"\n"+m_bildtl.GetXml();
		
//		var func = new x_WG_Currefour();
//		return func.writeStr(userid,deptid,kaid,m_bilhdr,m_bildtl);		//���ü��ָ��Ľ�������
		return writeStr(userid,deptid,kaid,m_bilhdr,m_bildtl);			//��д���ָ��Ľ�������
	} catch ( e ) {
//		return e;
		throw new Exception(e);
	}
}

function GetBillist(node,dat)
{
	if (node.getNodeName().equals("A")) {
		var attrs  = node.getAttributes();
		var namnode = attrs.getNamedItem("href");
		if (namnode != null) {
			var namvalue = namnode.getNodeValue();
			if (namvalue != null && namvalue.indexOf("/edi/WebEDI/Document/ViewDetails/") >= 0) {
				//�ж��Ƿ������ڷ�Χ�ڣ����˶���
				var eafunc = new pub.EAFunc();
				var node1 = node.getParentNode(); //<TD>
				node1 = node1.getNextSibling(); //����
				while (node1.getNodeName() == "#text") node1 = node1.getNextSibling();
				var date = node1.getFirstChild().getNodeValue();
				date = eafunc.Replace(date," ","");
				date = eafunc.Replace(date ,"\n","");
				var num = pub.EADbTool.GetSQL("select to_date('"+dat+"','yyyy-mm-dd')-to_date('"+date+"','mm/dd/yyyy') from dual");
				
				node1 = node1.getNextSibling(); //�ص�
				while (node1.getNodeName() == "#text") node1 = node1.getNextSibling();
				var addid = node1.getFirstChild().getNextSibling().getNextSibling().getNodeValue();
				addid = eafunc.Replace(addid," ","");
				addid = eafunc.Replace(addid,"\n","");
				
				if (1*num == 0) {
					var row = m_bilds.AddRow(m_bilds.getRowCount()-1);
					m_bilds.setValueAt(row,"BILGUID",namvalue);
					m_bilds.setValueAt(row,"ADDID",addid);
				} else if (1*num > 0) {
					m_bilEnd = true;
					return;
				}
			}
		}
	}
	var children = node.getChildNodes();
	if (children != null) {
		for ( var i = 0; i < children.getLength(); i ++ ) {
			GetBillist(children.item(i),dat);
		}
	}
}

function GetBildetail(node)
{
	if (node.getNodeName().equals("TD") || node.getNodeName().equals("STRONG")) {
		if (m_bEntryDtl) {
			m_bildtlcolseq1 ++;
			if (!m_bildtlrowStat1 && m_dtlrow != -1) m_bildtlcolseq2 ++;
		}
		if (m_bildtlrowStat2 && m_bildtlcolseq2 == 3) {
			m_bildtlrowStat2 = false;
			m_bildtlcolseq2 = 0;
		}
		if (node.getFirstChild() != null) {
			var eafunc = new pub.EAFunc();
			var nodevalue = eafunc.NVL(node.getFirstChild().getNodeValue(),"");
			nodevalue = eafunc.Replace(nodevalue," ","");
			nodevalue = eafunc.Replace(nodevalue ,"\n","");
			
			if (nodevalue.length() >= m_colnamlist[0].length() && nodevalue.substring(0,m_colnamlist[0].length()).equals(m_colnamlist[0])) {
				t_hdrrow = t_bilhdr.AddRow(t_bilhdr.getRowCount()-1);
				t_bilhdr.setValueAt(t_hdrrow,m_colidlist[0],m_bilguid.substring("/edi/WebEDI/Document/ViewDetails/".length(),m_bilguid.indexOf("?")));
				m_bEntryHdr = true;	//��ͷ��ʼ
			}
			else if (nodevalue.length() >= m_bildtlstartflg.length() && nodevalue.substring(0,m_bildtlstartflg.length()).equals(m_bildtlstartflg)) {
				m_bEntryDtl = true;	//���忪ʼ
			}
			else if (m_bEntryHdr) {						//��ʼץȡHdrDS
				for ( var i = 0; i < m_colnamlist.length(); i ++ ) {	//"��Ӧ����","��Ӧ�̺�","������","��������","��������","����"
					if (m_lastcolnam.length() >= m_colnamlist[i].length() && m_lastcolnam.substring(0,m_colnamlist[i].length()).equals(m_colnamlist[i])) {
						if (i == 0) {
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[1],nodevalue);
						}
						else if (i == 1) {
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[2],nodevalue);
						}
						else if (i == 2) {
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[4],nodevalue);
							m_bilid = nodevalue;
						}
						else if (i == 3) {
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[5],pub.EADbTool.GetSQL("select to_char(to_date('"+nodevalue+"','mm/dd/yyyy'),'dd/mm/yyyy') from dual"));
						}
						else if (i == 4) {
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[6],pub.EADbTool.GetSQL("select to_char(to_date('"+nodevalue+"','mm/dd/yyyy'),'dd/mm/yyyy') from dual"));
						}
						else if (i == 5) {
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[3],nodevalue);
							m_bEntryHdr = false;
						}
						break;
					}
				}
			}
			else if (!m_bEntryHdr && t_bilhdr.getRowCount() > 0) {		//ץȡ��ͷ����(t_bilhdr)��������ָ���ʽHdrDS(m_bilhdr)
				m_hdrrow = m_bilhdr.AddRow(m_bilhdr.getRowCount()-1);
				for (var i = 0; i < m_colidlist.length(); i ++) {
					for (var j = 0; j < t_bilhdr.getColumnCount(); j ++) {
						if (m_colidlist[i] == t_bilhdr.getColumnName(j)) {
							m_bilhdr.setValueAt(m_hdrrow,m_colidlist[i],t_bilhdr.getStringAt(t_hdrrow,j));
							break;
						}
						else if (j == t_bilhdr.getRowCount()-1)
							m_bilhdr.setValueAt(m_hdrrow,m_colidlist[i],"");
					}
				}
				t_bilhdr.clearDS();
			}
			else if (m_bEntryDtl) {						//��ʼץȡDtlDS
				if (m_bildtlcolseq1 == 1) {
					try {
						var attrs  = node.getParentNode().getAttributes(); //<TR>
						var namnode = attrs.getNamedItem("class");
						if (namnode != null) {
							var namvalue = namnode.getNodeValue();
							if (namvalue == "tableRow") {
								m_bildtlrowStat1 = true;
								m_dtlrow = m_bildtl.AddRow(m_bildtl.getRowCount()-1);
								
								m_bildtl.setValueAt(m_dtlrow,"������",m_bilid);
								m_bildtl.setValueAt(m_dtlrow,"BILID", m_bilguid.substring("/edi/WebEDI/Document/ViewDetails/".length(),m_bilguid.indexOf("?")));
								m_bildtl.setValueAt(m_dtlrow,"SEQID", nodevalue);
								if (m_addid == "" || m_addid == "0") {
									m_bildtl.setValueAt(m_dtlrow,"CORPID", "");
									m_bildtl.setValueAt(m_dtlrow,"CORPNAM", "");
								} else {
									m_bildtl.setValueAt(m_dtlrow,"CORPID", m_addid);
									m_bildtl.setValueAt(m_dtlrow,"CORPNAM", m_addid);
								}
							}
						}
					} catch ( e ) {
						m_bildtlrowStat1 = false;
					}
				}
				if (m_bildtlrowStat1 && m_bildtlcolseq1 == 2) {
					m_bildtl.setValueAt(m_dtlrow,"ITMID", nodevalue);
				}
				if (!m_bildtlrowStat1 && m_bildtlcolseq1 == 2 && m_dtlrow != -1) {
					if (m_bildtl.getValueAt(m_dtlrow,"ITMNAM") == "" || m_bildtl.getValueAt(m_dtlrow,"ITMNAM") == "����˰��") {
						m_bildtl.setValueAt(m_dtlrow,"ITMNAM", eafunc.Replace(nodevalue,"��Ʒ˵��",""));
					}
				}
				if (m_bildtlrowStat1 && m_bildtlcolseq1 == 3) {
					m_bildtl.setValueAt(m_dtlrow,"����", nodevalue);
				}
				if (!m_bildtlrowStat1 && m_bildtlcolseq1 == 3 && m_dtlrow != -1) {
					if (m_bildtl.getValueAt(m_dtlrow,"����˰��") != "" && eafunc.Replace(nodevalue," ","").indexOf("%") != -1) {
						m_bildtl.setValueAt(m_dtlrow,"����˰��", eafunc.Round((1.0+0.01*eafunc.Replace(eafunc.Replace(nodevalue," ",""),"%",""))*m_bildtl.getValueAt(m_dtlrow,"����˰��")/m_bildtl.getValueAt(m_dtlrow,"UNTNUM"),4));
					}
				}
				if (m_bildtlrowStat1 && m_bildtlcolseq1 == 7) {
					m_bildtl.setValueAt(m_dtlrow,"SPEC", nodevalue);
					m_bildtl.setValueAt(m_dtlrow,"ITMNAM", "");
					
					var qtyflg = "";
					var untnum = "";
					try {
						var qtyflgnode = node.getNextSibling();
						while (qtyflgnode.getNodeName() == "#text") qtyflgnode = qtyflgnode.getNextSibling();
						qtyflgnode = qtyflgnode.getNextSibling();
						while (qtyflgnode.getNodeName() == "#text") qtyflgnode = qtyflgnode.getNextSibling();
						var untnumnode = qtyflgnode.getNextSibling();
						while (untnumnode.getNodeName() == "#text") untnumnode = untnumnode.getNextSibling();
						untnumnode = untnumnode.getNextSibling();
						while (untnumnode.getNodeName() == "#text") untnumnode = untnumnode.getNextSibling();
						
						qtyflg = qtyflgnode.getFirstChild().getNodeValue();
						untnum = untnumnode.getFirstChild().getNodeValue();
						untnum = untnum.substring(0,untnum.indexOf("/"));
					} catch ( e ) { }
					m_bildtl.setValueAt(m_dtlrow,"UNTNUM", untnum);	//������־
					m_bildtl.setValueAt(m_dtlrow,"QTYFLG", qtyflg);	//�������
				}
				if (m_bildtlrowStat1 && m_bildtlcolseq1 == 8) {
					m_bildtl.setValueAt(m_dtlrow,"QTY", nodevalue);
					m_bildtl.setValueAt(m_dtlrow,"��Ʒ����", "");
				}
				if (m_bildtlrowStat1 && m_bildtlcolseq1 == 10) {
					m_bildtl.setValueAt(m_dtlrow,"����˰��", nodevalue);
				}
				
				if (m_bildtlcolseq2 == 1) {
					try {
						var attrs  = node.getParentNode().getAttributes(); //<TR>
						var namnode = attrs.getNamedItem("class");
						if (namnode != null) {
							var namvalue = namnode.getNodeValue();
							if (namvalue == "destinationQuantityRows") {
								m_bildtlrowStat2 = true;
								m_dtlrow = m_bildtl.AddRow(m_bildtl.getRowCount()-1);
								
								m_bildtl.setValueAt(m_dtlrow,"CORPID", nodevalue);
								m_bildtl.setValueAt(m_dtlrow,"CORPNAM", nodevalue);
							}
						}
					} catch ( e ) { }
				}
				if (m_bildtlrowStat2 && m_bildtlcolseq2 == 2) {
					m_bildtl.setValueAt(m_dtlrow,"QTY", 1*nodevalue*m_bildtl.getValueAt(m_dtlrow,"UNTNUM"));
				}
				
				try { //�жϱ���һ�������Ƿ����
					var node1 = node.getNextSibling();
					while (node1.getNodeName() == "#text") node1 = node1.getNextSibling();
				} catch ( e ) {
					m_bildtlrowStat1 = false;
					m_bildtlcolseq1 = 0;
					m_bildtlrowStat2 = false;
					m_bildtlcolseq2 = 0;
				}
			}
			m_lastcolnam = nodevalue;
		}
	}
	var children = node.getChildNodes();
	if ( children != null ) {
		for ( var i = 0; i < children.getLength(); i ++ ) {
			GetBildetail(children.item(i));
		}
	}
}

// ������writeStr
// ˵������ץȡ������ƴ��
function writeStr(userid,deptid,kaid,hdrds,dtlds)
{
	var ordid = "";
	var context = "";
	var sb = new StringBuffer();
	var eafunc = new pub.EAFunc();
	for (var i = 0 ; i < hdrds.getRowCount(); i ++) {
		var hval = "NR~~~"+userid+"~~~"+deptid+"~~~"+kaid+"~~~";
		
		for (var c = 0; c < hdrds.getColumnCount(); c ++) {
			if (hdrds.getColumnName(c) == "CORPID") hval += "#CORPID#~~~";
			else if (hdrds.getColumnName(c) == "CORPNAM") hval += "#CORPNAM#~~~";
			else hval += hdrds.getStringAt(i,c)+"~~~";
		}
		ordid = hdrds.getStringAt(i,"������")+hdrds.getStringAt(i,"BILID");
		
		for(var j = 0; j < dtlds.getRowCount(); j ++) {
			var tmpord = dtlds.getStringAt(j,"������")+dtlds.getStringAt(j,"BILID");
			var tval = hval;
			var dval = "";
			if(tmpord.equals(ordid) && dtlds.getStringAt(j,"CORPID") != "") {
				for (var m = 2; m < dtlds.getColumnCount(); m ++) {
					if (dtlds.getColumnName(m) == "CORPID") tval = eafunc.Replace(tval,"#CORPID#",dtlds.getStringAt(j,m));
					else if (dtlds.getColumnName(m) == "CORPNAM") tval = eafunc.Replace(tval,"#CORPNAM#",dtlds.getStringAt(j,m));
					else dval += dtlds.getStringAt(j,m)+"~~~";
				}
				context = tval+dval;
				context += "None~~~None~~~None��";
				sb.append(context);
				sb.append("\n");
			}
		}
	}
	return sb.toString();
}

}