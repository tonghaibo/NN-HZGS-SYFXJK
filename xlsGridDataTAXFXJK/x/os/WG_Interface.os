function x_WG_Interface(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var util = new JavaPackage("java.util");
var map = new util.HashMap();

//��Ϊ.sp����ʱ�����
//Ԥ���������request,response
function Response()
{
//	var db = new pubpack.EADatabase();
	var acc = "";		//���׺�
	var dat = "";		//ץȡ����
	var kaid = "";		//�������
	var userid ="";		//�û���
	var passwd = "";	//����	
	var deptid = "";	//���ű��
	var code = "";		//��֤��
	var rock_password = ""; //�������������������  kaid = "0010"
	var date = "";//�������������ץ������  kaid = "0010"
	//��ȡ��������������Ϣ���ַ�����Ӧ��OS����
	try { acc = request.getParameter("ACC"); } catch( e ) { acc = ""; }
	try { dat = request.getParameter("CALLDAT"); } catch( e ) { dat = ""; }
	try { kaid = request.getParameter("KAID"); } catch( e ) { kaid = ""; }
	try { userid = request.getParameter("USERID"); } catch( e ) { userid = ""; }
	try { passwd = request.getParameter("PASSWD"); } catch( e ) { passwd = ""; }
	try { deptid = request.getParameter("DEPTID"); } catch( e ) { deptid = ""; }
	try { code = request.getParameter("CODE");} catch( e ) { code = ""; }
//	pubpack.EAFunc.Log("acc="+acc);
	if (kaid == "0010") {
		try { rock_password = request.getParameter("ROCK_PASSWORD"); } catch( e ) { rock_password = ""; }
		try { date = request.getParameter("DATE"); } catch( e ) { date = ""; }
	}
	
	setOS();
	
	if (kaid == "0010") {
		return getOS(kaid).getOrderStr(acc,dat,kaid,userid,passwd,deptid,code,rock_password,date);
	} else {
		return getOS(kaid).getOrderStr(acc,dat,kaid,userid,passwd,deptid,code);
	}
}

function setOS()
{
	map.put("0001",new x_WG_RtMart());
	map.put("0004",new x_WG_GMS());
	map.put("0005",new x_WG_Currefour());
	map.put("00071",new x_WG_TescoTmp());
	map.put("0007",new x_WG_TescoBak());
	map.put("0010",new x_WG_CenturyMart());
	map.put("0012",new x_WG_WalMartbak());
	map.put("0015",new x_WG_EkChor());
	map.put("0016",new x_WG_Emart());
}

function getOS(kaid)
{
	if (map.containsKey(kaid)) return map.get(kaid);
}

}