function x_WG_Aquarius(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var pub = new JavaPackage("com.xlsgrid.net.pub");
var httpcall = new webget.HttpCall();

var hostip = "http://210.51.48.210:9082/";
var selorderstate = 1;	//����״̬��1��������2��δ���ģ�3���Ѳ��ģ�4���ѷ���

var m_bilds = new pub.EADS();
var m_bilid = "";	//�������
var m_bilguid = "";	//�ڲ����
var m_bEntryHdr = false;
var m_lastcolnam = "";
var m_colnamlist = new Array("�ɹ��������","��Ӧ�̱���","��Ӧ������","��������","�ͻ�����");				//��ͷ��ץȡ��<TD>info
var t_bilhdr = new pub.EADS();
var t_hdrrow = -1;
var m_colidlist = new Array("BILID","CORPNAM","CORPID","DEPT","������","DAT","����������","�绰����","�������");	//���ָ���ʽ��HdrDS
var m_bilhdr = new pub.EADS();
var m_hdrrow = -1;
var m_bEntryDtl = false;
var m_bildtlstartflg = "���(";
var m_bildtlcolseq = 0;
var m_bildtl = new pub.EADS();		//���ָ���ʽ��DtlDS���ɹ��첻ͬ��ʽ��DS��������������������˼��ָ��Ľ������������Ը�ʽ�ͼ��ָ���ͬ��
var m_dtlrow = -1;

function start()
{
	return getOrderStr("JQPX","2010-07-19","0030","gmbl1275","123456","dept","5188");
}

function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
{
	var ret = "";
	try {
		ret =  httpcall.Post(hostip+"default.jsp","flag=login&txtUserID="+userid+"&txtPassword="+passwd+"&txtCompanyCode="+code);	//��½
//		ret = httpcall.Get(hostip+"MainPage1.jsp?code=01","");
		
		var billistparam = "command=query&type=��Ӧ��&btnQuery=�� ѯ&target=_self&txtOrderStartDate="+dat+"&txtOrderEndDate="+dat
			+"&selorderstate="+selorderstate+"&pageSize=999999999";
		
//		ret = httpcall.Post(hostip+"purchase/BLPOrderQuery.jsp",billistparam,"GBK");
		var node = httpcall.PostAndParse(hostip+"purchase/BLPOrderQuery.jsp",billistparam,"GBK");					//�嵥
		GetBillist(node);
		
		for (var i = 0; i < m_bilds.getRowCount(); i ++) {
			m_bilguid = m_bilds.getStringAt(i,"BILGUID");
			var billparam = "chkSelection="+m_bilguid+"&id="+m_bilguid;
			
//			ret = httpcall.Post(hostip+"purchase/BLPOrderModify.jsp",billparam);
			node = httpcall.PostAndParse(hostip+"purchase/BLPOrderModify.jsp",billparam,"GBK");					//��
			m_bEntryHdr = false;
			m_bEntryDtl = false;
			m_lastcolnam= "";
			m_bildtlcolseq= 0;
			GetBildetail(node);
		}
//		throw new Exception(m_bilhdr.GetXml()+"\n"+m_bildtl.GetXml());
		
		var func = new x_WG_Currefour();
		return func.writeStr(userid,deptid,kaid,m_bilhdr,m_bildtl);		//���ü��ָ��Ľ�������
	} catch ( e ) {
		throw new Exception( e );
	}
}

function GetBillist(node)
{
	if (node.getNodeName().equals("INPUT")) {
		var attrs  = node.getAttributes();
		var namnode = attrs.getNamedItem("name");
		if ( namnode != null ) {
			var namvalue = namnode.getNodeValue();
			if ( namvalue != null && namvalue.indexOf("chkSelection") >= 0 ) {
				var valnode = attrs.getNamedItem("value");
				if ( valnode != null ) {
					var valvalue = valnode.getNodeValue();
					var row = m_bilds.AddRow(m_bilds.getRowCount()-1);
					m_bilds.setValueAt(row,"BILGUID",valvalue);
				}
			}
		}
	}
	var children = node.getChildNodes();
	if ( children != null ) {
		for ( var i = 0; i < children.getLength(); i ++ ) {
			GetBillist(children.item(i));
		}
	}
}

function GetBildetail(node)
{
	if (node.getNodeName().equals("TD")) {
		if (m_bEntryDtl) m_bildtlcolseq ++;
		if (node.getFirstChild() != null) {
			var eafunc = new pub.EAFunc();
			var nodevalue = eafunc.NVL(node.getFirstChild().getNodeValue(),"");
			
			if (nodevalue.length() >= m_colnamlist[0].length() && nodevalue.substring(0,m_colnamlist[0].length()).equals(m_colnamlist[0])) {
				t_hdrrow = t_bilhdr.AddRow(t_bilhdr.getRowCount()-1);
				t_bilhdr.setValueAt(t_hdrrow,m_colidlist[0],m_bilguid);
				m_bEntryHdr = true;	//��ͷ��ʼ
			}
			else if (nodevalue.length() >= m_bildtlstartflg.length()
				&& nodevalue.substring(0,m_bildtlstartflg.length()).equals(m_bildtlstartflg))
			{
				m_bEntryDtl = true;	//���忪ʼ
			}
			else if ( m_bEntryHdr ) {					//��ʼץȡHdrDS
				for ( var i = 0; i < m_colnamlist.length(); i ++ ) {	//"�ɹ��������","��Ӧ�̱���","��Ӧ������","��������","�ͻ�����"
					if (m_lastcolnam.length() >= m_colnamlist[i].length()
						&& m_lastcolnam.substring(0,m_colnamlist[i].length()).equals(m_colnamlist[i]))
					{
						if (i == 0) {
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[4],nodevalue);
							m_bilid = nodevalue;
						}
						else if (i == 1)
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[2],nodevalue);
						else if (i == 2)
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[1],nodevalue);
						else if (i == 3)
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[5],nodevalue);
						else if (i == 4) {
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[6],nodevalue);
							m_bEntryHdr = false;
						}
						break;
					}
				}
			}
			else if ( ! m_bEntryHdr && t_bilhdr.getRowCount() > 0 ) {	//ץȡ��ͷ����(t_bilhdr)��������ָ���ʽHdrDS(m_bilhdr)
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
			else if ( m_bEntryDtl ) {					//��ʼץȡDtlDS
				if (m_bildtlcolseq == 1) {
					m_dtlrow = m_bildtl.AddRow(m_bildtl.getRowCount()-1);
					
					m_bildtl.setValueAt(m_dtlrow,"������",m_bilid);
					m_bildtl.setValueAt(m_dtlrow,"BILID", m_bilguid);
					m_bildtl.setValueAt(m_dtlrow,"SEQID", nodevalue);
				}
				else if (m_bildtlcolseq == 2) {
					m_bildtl.setValueAt(m_dtlrow,"ITMID", nodevalue);
				}
				else if (m_bildtlcolseq == 3) {
					var codenode = node.getNextSibling().getNextSibling();
					var specnode = codenode.getNextSibling().getNextSibling();
					
					var code = codenode.getFirstChild().getNodeValue();
					var spec = specnode.getFirstChild().getNodeValue();
					
					m_bildtl.setValueAt(m_dtlrow,"����", code);
					m_bildtl.setValueAt(m_dtlrow,"SPEC", spec);
					m_bildtl.setValueAt(m_dtlrow,"ITMNAM", nodevalue);
				}
				else if (m_bildtlcolseq == 6) {
					var untnum = node.getNextSibling().getNextSibling().getNextSibling().getNextSibling()
						.getNextSibling().getNextSibling().getNextSibling().getNextSibling().getFirstChild().getNodeValue();
					
					m_bildtl.setValueAt(m_dtlrow,"UNTNUM",untnum);	//��װϵ��
					m_bildtl.setValueAt(m_dtlrow,"QTY",nodevalue);	//��װ����
					m_bildtl.setValueAt(m_dtlrow,"��Ʒ����", "");
				}
				else if (m_bildtlcolseq == 11) {
					m_bildtl.setValueAt(m_dtlrow,"����˰��",nodevalue);
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

}